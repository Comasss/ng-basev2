local playersProcessingPoppyResin = {}

RegisterServerEvent('esx_yisus_drogas:pickedUpPoppy')
AddEventHandler('esx_yisus_drogas:pickedUpPoppy', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addInventoryItem('poppyresin', 1)
end)

RegisterServerEvent('esx_yisus_drogas:processPoppyResin')
AddEventHandler('esx_yisus_drogas:processPoppyResin', function()
	if not playersProcessingPoppyResin[source] then
		local _source = source

		playersProcessingPoppyResin[_source] = ESX.SetTimeout(Config.Delays.HeroinProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPoppyResin, xHeroin = xPlayer.getInventoryItem('poppyresin'), xPlayer.getInventoryItem('heroin')

			if xPoppyResin.count > 0 then
				if xPlayer.canSwapItem('poppyresin', 1, 'heroin', 1) then
					xPlayer.removeInventoryItem('poppyresin', 1)
					xPlayer.addInventoryItem('heroin', 1)

					xPlayer.showNotification(_U('heroin_processed'))
				else
					xPlayer.showNotification(_U('heroin_processingfull'))
				end
			else
				xPlayer.showNotification(_U('heroin_processingenough'))
			end

			playersProcessingPoppyResin[_source] = nil
		end)
	else
	--	print(('esx_yisus_drogas: %s attempted to exploit heroin processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingPoppyResin[playerID] then
		ESX.ClearTimeout(playersProcessingPoppyResin[playerID])
		playersProcessingPoppyResin[playerID] = nil
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
