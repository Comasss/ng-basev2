local isPickingUp, isProcessing = false, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.lsdProcessing.coords, true) < 2 then
			if not isProcessing then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para procesar LSD", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				if isAllowedDrug('lsd') then
					if not IsPedInAnyVehicle(playerPed, true) then
						if Config.RequireCopsOnline then
							ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
								if cb then
									Processlsd()
								else
									ESX.ShowNotification(_U('cops_notenough'))
								end
							end, Config.Cops.LSD)
						else
							Processlsd()
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

function Processlsd()
	isProcessing = true

	ESX.ShowNotification(_U('lsd_processingstarted'))
	TriggerServerEvent('esx_yisus_drogas:processLSD')
	local timeLeft = Config.Delays.lsdProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.lsdProcessing.coords, false) > 5 then
			ESX.ShowNotification(_U('lsd_processingtoofar'))
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.thionylchlorideProcessing.coords, true) < 2 then
			if not isProcessing then
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para procesar cloruro de tionilo", vector3(coords.x, coords.y, coords.z + 1))
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				if isAllowedDrug('lsd') then
					if not IsPedInAnyVehicle(playerPed, true) then
						if Config.RequireCopsOnline then
							ESX.TriggerServerCallback('esx_yisus_drogas:EnoughCops', function(cb)
								if cb then
									Processthionylchloride()
								else
									ESX.ShowNotification(_U('cops_notenough'))
								end
							end, Config.Cops.LSD)
						else
							Processthionylchloride()
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

function Processthionylchloride()
	isProcessing = true

	ESX.ShowNotification(_U('thionylchloride_processingstarted'))
	TriggerServerEvent('esx_yisus_drogas:processThionylChloride')
	local timeLeft = Config.Delays.thionylchlorideProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.thionylchlorideProcessing.coords, false) > 5 then
			ESX.ShowNotification(_U('thionylchloride_processingtoofar'))
			TriggerServerEvent('esx_yisus_drogas:cancelProcessing')
			break
		end
	end

	isProcessing = false
end