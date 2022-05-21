local playersProcessingCannabis = {}

RegisterServerEvent('esx_yisus_drogas:pickedUpCannabis')
AddEventHandler('esx_yisus_drogas:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.addInventoryItem('cannabis', 1)
	
end)

RegisterServerEvent('esx_yisus_drogas:processCannabis')
AddEventHandler('esx_yisus_drogas:processCannabis', function()
	if not playersProcessingCannabis[source] then
		local _source = source

		playersProcessingCannabis[_source] = ESX.SetTimeout(Config.Delays.WeedProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCannabis, xMarijuana = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('marijuana')

			
			if xCannabis.count > 0 then
				 if xPlayer.canSwapItem('cannabis', 1, 'marijuana', 1) then
					xPlayer.removeInventoryItem('cannabis', 1)
					xPlayer.addInventoryItem('marijuana', 1)

					xPlayer.showNotification(_U('weed_processed'))
				else
					xPlayer.showNotification(_U('weed_processingfull'))
				end
			else
				xPlayer.showNotification(_U('weed_processingenough'))
			end

			playersProcessingCannabis[_source] = nil
		end)
	else
	--	print(('esx_yisus_drogas: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)


function CancelProcessing(playerID)
	if playersProcessingCannabis[playerID] then
		ESX.ClearTimeout(playersProcessingCannabis[playerID])
		playersProcessingCannabis[playerID] = nil
	end
end

RegisterServerEvent('esx_yisus_drogas:cancelProcessing')
AddEventHandler('esx_yisus_drogas:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
