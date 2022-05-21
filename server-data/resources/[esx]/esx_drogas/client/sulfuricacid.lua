local spawnedSulfuricAcidBarrels = 0
local SulfuricAcidBarrels = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.SulfuricAcidFarm.coords, true) < 50 then
			SpawnSulfuricAcidBarrels()
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
		local nearbyObject, nearbyID

		for i=1, #SulfuricAcidBarrels, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(SulfuricAcidBarrels[i]), false) < 1 then
				nearbyObject, nearbyID = SulfuricAcidBarrels[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para recoger el ácido sulfúrico del bote", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				if isAllowedDrug('sulfuricacid') then
					if Config.RequireCopsOnline then
						ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
							if cb then
								PickUpSulfuricAcid(playerPed, coords, nearbyObject, nearbyID)
							else
								ESX.ShowNotification(_U('cops_notenough'))
							end
						end, Config.Cops.Meth)
					else
						PickUpSulfuricAcid(playerPed, coords, nearbyObject, nearbyID)
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

function PickUpSulfuricAcid(playerPed, coords, nearbyObject, nearbyID)
	isPickingUp = true

	ESX.TriggerServerCallback('esx_yisus_drogas:canPickUp', function(canPickUp)

		if canPickUp then
			TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

			Citizen.Wait(2000)
			ClearPedTasks(playerPed)
			Citizen.Wait(1500)

			ESX.Game.DeleteObject(nearbyObject)

			table.remove(SulfuricAcidBarrels, nearbyID)

			TriggerServerEvent('esx_yisus_drogas:pickedUpSulfuricAcid')
			Citizen.Wait(5000)
			spawnedSulfuricAcidBarrels = spawnedSulfuricAcidBarrels - 1
		else
			ESX.ShowNotification(_U('SulfuricAcid_inventoryfull'))
		end

		isPickingUp = false

	end, 'sulfuric_acid')
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(SulfuricAcidBarrels) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnSulfuricAcidBarrels()
	while spawnedSulfuricAcidBarrels < 10 do
		Citizen.Wait(0)
		local weedCoords = GenerateSulfuricAcidCoords()

		ESX.Game.SpawnLocalObject('prop_barrel_02b', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(SulfuricAcidBarrels, obj)
			spawnedSulfuricAcidBarrels = spawnedSulfuricAcidBarrels + 1
		end)
	end
end

function ValidateSulfuricAcidCoord(plantCoord)
	if spawnedSulfuricAcidBarrels > 0 then
		local validate = true

		for k, v in pairs(SulfuricAcidBarrels) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.SodiumHydroxideFarm.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateSulfuricAcidCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-7, 7)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-7, 7)

		weedCoordX = Config.CircleZones.SulfuricAcidFarm.coords.x + modX
		weedCoordY = Config.CircleZones.SulfuricAcidFarm.coords.y + modY

		local coordZ = GetCoordZSulfuricAcid(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateSulfuricAcidCoord(coord) then
			return coord
		end
	end
end

function GetCoordZSulfuricAcid(x, y)
	local groundCheckHeights = { 67.44, 68.44, 69.44, 70.44, 71.44, 71.44, 73.44, 74.44, 75.44 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 18.31
end