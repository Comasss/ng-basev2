local spawnedPoppys = 0
local PoppyPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.HeroinField.coords, true) < 50 then
			SpawnPoppyPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.HeroinProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ procesar la heroína", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				if isAllowedDrug('heoin') then
					if not IsPedInAnyVehicle(playerPed, true) then
						if Config.RequireCopsOnline then
							ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
								if cb then
									ProcessHeroin()
								else
									ESX.ShowNotification(_U('cops_notenough'))
								end
							end, Config.Cops.Heroin)
						else
							ProcessHeroin()
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

function ProcessHeroin()
	isProcessing = true

	ESX.ShowNotification(_U('heroin_processingstarted'))
	TriggerServerEvent('esx_yisus_drogas:processPoppyResin')
	local timeLeft = Config.Delays.HeroinProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.HeroinProcessing.coords, false) > 5 then
			ESX.ShowNotification(_U('heroin_processingtoofar'))
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

		for i=1, #PoppyPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(PoppyPlants[i]), false) < 1 then
				nearbyObject, nearbyID = PoppyPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ cosechar el cogollo de la amapola", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				if isAllowedDrug('heoin') then
					if Config.RequireCopsOnline then
						ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
							if cb then
								PickUpPoppy(playerPed, coords, nearbyObject, nearbyID)
							else
								ESX.ShowNotification(_U('cops_notenough'))
							end
						end, Config.Cops.Heroin)
					else
						PickUpPoppy(playerPed, coords, nearbyObject, nearbyID)
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

function PickUpPoppy(playerPed, coords, nearbyObject, nearbyID)
	isPickingUp = true

	ESX.TriggerServerCallback('esx_yisus_drogas:canPickUp', function(canPickUp)

		if canPickUp then
			TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

			Citizen.Wait(2000)
			ClearPedTasks(playerPed)
			Citizen.Wait(1500)

			ESX.Game.DeleteObject(nearbyObject)

			table.remove(PoppyPlants, nearbyID)


			TriggerServerEvent('esx_yisus_drogas:pickedUpPoppy')
			Citizen.Wait(5000)
			spawnedPoppys = spawnedPoppys - 1
		else
			ESX.ShowNotification(_U('poppy_inventoryfull'))
		end

		isPickingUp = false

	end, 'poppyresin')
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(PoppyPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnPoppyPlants()
	while spawnedPoppys < 15 do
		Citizen.Wait(0)
		local heroinCoords = GenerateHeroinCoords()

		ESX.Game.SpawnLocalObject('prop_cs_plant_01', heroinCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(PoppyPlants, obj)
			spawnedPoppys = spawnedPoppys + 1
		end)
	end
end

function ValidateHeroinCoord(plantCoord)
	if spawnedPoppys > 0 then
		local validate = true

		for k, v in pairs(PoppyPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.HeroinField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateHeroinCoords()
	while true do
		Citizen.Wait(1)

		local heroinCoordX, heroinCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		heroinCoordX = Config.CircleZones.HeroinField.coords.x + modX
		heroinCoordY = Config.CircleZones.HeroinField.coords.y + modY

		local coordZ = GetCoordZHeroin(heroinCoordX, heroinCoordY)
		local coord = vector3(heroinCoordX, heroinCoordY, coordZ)

		if ValidateHeroinCoord(coord) then
			return coord
		end
	end
end

function GetCoordZHeroin(x, y)
	local groundCheckHeights = { 480.0, 481.0, 482.0, 483.0, 484.0, 485.0, 485.0, 486.0, 487.0, 488.0, 489.0, 490.0, 491.0, 492.0, 493.0, 494.0, 495.0, 496.0, 497.0, 498.0, 499.0, 500.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 12.64
end