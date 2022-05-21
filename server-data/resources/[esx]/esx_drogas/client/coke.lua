local spawnedCocaLeaf = 0
local CocaPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeField.coords, true) < 50 then
			SpawnCocaPlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para procesar cocaína", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				if isAllowedDrug('coke') then
					if not IsPedInAnyVehicle(playerPed, true) then
						if Config.RequireCopsOnline then
							ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
								if cb then
									ProcessCoke()
								else
									ESX.ShowNotification(_U('cops_notenough'))
								end
							end, Config.Cops.Coke)
						else
							ProcessCoke()
						end
					else
						ESX.ShowNotification(_U('need_on_foot'))
					end
				else
					ESX.ShowNotification("No tienes tanta habilidad como para realizar esta acción")
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessCoke()
	isProcessing = true

	ESX.ShowNotification(_U('coke_processingstarted'))
	TriggerServerEvent('esx_yisus_drogas:processCocaLeaf')
	local timeLeft = Config.Delays.CokeProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CokeProcessing.coords, false) > 5 then
			ESX.ShowNotification(_U('coke_processingtoofar'))
			TriggerServerEvent('esx_yisus_drogas:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #CocaPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(CocaPlants[i]), false) < 1 then
				nearbyObject, nearbyID = CocaPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para cosechar la planta de coca", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				if isAllowedDrug('coke') then
					if Config.RequireCopsOnline then
						ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
							if cb then
								PickUpCocaLeaf(playerPed, coords, nearbyObject, nearbyID)
							else
								ESX.ShowNotification(_U('cops_notenough'))
							end
						end, Config.Cops.Coke)
					else
						PickUpCocaLeaf(playerPed, coords, nearbyObject, nearbyID)
					end
				else
					ESX.ShowNotification("No tienes tanta habilidad como para realizar esta acción")
				end
			end

		else
			Citizen.Wait(500)
		end

	end
end)

function PickUpCocaLeaf(playerPed, coords, nearbyObject, nearbyID)
	isPickingUp = true

	ESX.TriggerServerCallback('esx_yisus_drogas:canPickUp', function(canPickUp)
		
		if canPickUp then
			TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

			Citizen.Wait(2000)
			ClearPedTasks(playerPed)
			Citizen.Wait(1500)

			ESX.Game.DeleteObject(nearbyObject)

			table.remove(CocaPlants, nearbyID)

			TriggerServerEvent('esx_yisus_drogas:pickedUpCocaLeaf')
			Citizen.Wait(5000)
			spawnedCocaLeaf = spawnedCocaLeaf - 1
		else
			ESX.ShowNotification(_U('coke_inventoryfull'))
		end

		isPickingUp = false

	end, 'coca_leaf')
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(CocaPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCocaPlants()
	while spawnedCocaLeaf < 15 do
		Citizen.Wait(0)
		local weedCoords = GenerateCocaLeafCoords()

		ESX.Game.SpawnLocalObject('prop_plant_01a', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(CocaPlants, obj)
			spawnedCocaLeaf = spawnedCocaLeaf + 1
		end)
	end
end

function ValidateCocaLeafCoord(plantCoord)
	if spawnedCocaLeaf > 0 then
		local validate = true

		for k, v in pairs(CocaPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.CokeField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCocaLeafCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		weedCoordX = Config.CircleZones.CokeField.coords.x + modX
		weedCoordY = Config.CircleZones.CokeField.coords.y + modY

		local coordZ = GetCoordZCoke(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateCocaLeafCoord(coord) then
			return coord
		end
	end
end

function GetCoordZCoke(x, y)
	local groundCheckHeights = { 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 77
end