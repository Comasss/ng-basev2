local playersProcessingChemicalsToHydrochloricAcid = {}

RegisterServerEvent('esx_yisus_drogas:pickedUpChemicals')
AddEventHandler('esx_yisus_drogas:pickedUpChemicals', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addInventoryItem('chemicals', 1)
	
end)

RegisterServerEvent('esx_yisus_drogas:ChemicalsConvertionMenu')
AddEventHandler('esx_yisus_drogas:ChemicalsConvertionMenu', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)
	local xChemicals = xPlayer.getInventoryItem('chemicals')

	if xChemicals.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('Chemicals_notenough', xItem.label))
		return
	end
	
	Citizen.Wait(5000)

	xPlayer.addInventoryItem(xItem.name, amount)

	xPlayer.removeInventoryItem('chemicals', amount)

	TriggerClientEvent('esx:showNotification', source, _U('Chemicals_made', xItem.label))
end)

ESX.RegisterServerCallback('esx_yisus_drogas:CheckLisense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xChemicalsLisence = xPlayer.getInventoryItem('chemicalslisence')

	if xChemicalsLisence.count == 1 then
		cb(true)
	else
		cb(false)
	end
end)