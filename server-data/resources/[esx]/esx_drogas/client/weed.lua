local spawnedWeeds = 0
local weedPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 50 then
			SpawnWeedPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para procesar cannabis", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				if isAllowedDrug('weed') then
					if not IsPedInAnyVehicle(playerPed, true) then
						if Config.RequireCopsOnline then
							ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
								if cb then
									ProcessWeed()
								else
									ESX.ShowNotification(_U('cops_notenough'))
								end
						end, Config.Cops.Weed)
					else
						ProcessWeed()
					end
					else
						ESX.ShowNotification(_U('need_on_foot'))
					end
				else
					ESX.ShowNotification("No tienes la suficiente habilidad para realizar esta acción")
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessWeed()
	isProcessing = true

	ESX.ShowNotification(_U('weed_processingstarted'))
	TriggerServerEvent('esx_yisus_drogas:processCannabis')
	local timeLeft = Config.Delays.WeedProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 5 then
			ESX.ShowNotification(_U('weed_processingtoofar'))
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

		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para cosechar la planta de cannbis", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				if isAllowedDrug('weed') then
					if not IsPedInAnyVehicle(playerPed, true) then
						if Config.RequireCopsOnline then
							ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
								if cb then
									PickUpWeed(playerPed, coords, nearbyObject, nearbyID)
								else
									ESX.ShowNotification(_U('cops_notenough'))
								end
							end, Config.Cops.Weed)
						else
							PickUpWeed(playerPed, coords, nearbyObject, nearbyID)
						end
					else
						ESX.ShowNotification(_U('need_on_foot'))
					end
				else
					ESX.ShowNotification("No tienes la suficiente habilidad para realizar esta acción")
				end
			end

		else
			Citizen.Wait(500)
		end

	end

end)

function PickUpWeed(playerPed, coords, nearbyObject, nearbyID)
	isPickingUp = true

	ESX.TriggerServerCallback('esx_yisus_drogas:canPickUp', function(canPickUp)

		if canPickUp then
			TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

			Citizen.Wait(2000)
			ClearPedTasks(playerPed)
			Citizen.Wait(1500)

			ESX.Game.DeleteObject(nearbyObject)

			table.remove(weedPlants, nearbyID)

			TriggerServerEvent('esx_yisus_drogas:pickedUpCannabis')
			Citizen.Wait(5000)
			spawnedWeeds = spawnedWeeds - 1
		else
			ESX.ShowNotification(_U('weed_inventoryfull'))
		end

		isPickingUp = false

	end, 'cannabis')
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnWeedPlants()
	while spawnedWeeds < 15 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()

		ESX.Game.SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(weedPlants, obj)
			spawnedWeeds = spawnedWeeds + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeeds > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY

		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZWeed(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0, 61.0, 62.0, 63.0, 64.0, 65.0, 66.0, 67.0, 68.0, 69.0, 70.0, 71.0, 72.0, 73.0, 74.0, 75.0, 76.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end