ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_minerojob:doymineral')
AddEventHandler('esx_minerojob:doymineral', function(mineral)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
		if xPlayer.canCarryItem(mineral, 1) then
			xPlayer.addInventoryItem(mineral, 1)
		else xPlayer.showNotification('No tienes suficiente espacio en el inventario')
		end
	end)
	
RegisterServerEvent('esx_minerojob:doypico')
AddEventHandler('esx_minerojob:doypico', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon('WEAPON_BATTLEAXE')
end)

RegisterServerEvent('esx_minerojob:quitopico')
AddEventHandler('esx_minerojob:quitopico', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeWeapon('WEAPON_BATTLEAXE')
end)

RegisterServerEvent('esx_minerojob:recibodata')
AddEventHandler('esx_minerojob:recibodata',function(data)
	rocas = data
	TriggerClientEvent('esx_minerojob:recibodatacliente',-1,data)
end)

RegisterServerEvent('esx_minerojob:quitomin')
AddEventHandler('esx_minerojob:quitomin',function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	for i = 1, #xPlayer.inventory,1 do
		if xPlayer.inventory[i].name == "hierro" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(Config.HierroMin,Config.HierroMax))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
			end
		elseif xPlayer.inventory[i].name == "cobre" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(Config.CobreMin,Config.CobreMax))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
			end
		elseif xPlayer.inventory[i].name == "carbon" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(Config.CarbonMin,Config.CarbonMax))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
			end
		end
	end
end)


function recarocas()
	for i=1, #rocas, 1 do
		if rocas[i].vida < rocas[i].max then
			rocas[i].vida = rocas[i].vida + 1
		end
	end
	--Sincronizar
	TriggerClientEvent('esx_minerojob:recibodatacliente',-1,rocas)
end

function loop()
Citizen.CreateThread(function()
	while true do
		recarocas()
		Citizen.Wait(30000)
	Citizen.Wait(0)
	end
end)
end

loop()



