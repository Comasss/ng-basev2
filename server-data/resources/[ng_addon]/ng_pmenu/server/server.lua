ESX = nil

local ng = "[NG BASE] - PERSONAL MENU"

print(ng)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("ng:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

RegisterNetEvent('ng:getJob')
AddEventHandler('ng:getJob', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.label
    return job
end)

RegisterNetEvent('ng:getJobLabel')
AddEventHandler('ng:getJobLabel', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local jobgrade = xPlayer.job.grade_label
    return jobgrade
end)



RegisterServerEvent('ng:announce')
AddEventHandler('ng:announce', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Anuncio Administrativo', '~b~Información', '¡Dentro de 5 minutos habrá un reinicio breve!', 'CHAR_TENNIS_COACH', 8)
    end
end)


RegisterServerEvent('ng:dinero')
AddEventHandler('ng:dinero', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local getmoney = xPlayer.getMoney()
    local getmoneybank = xPlayer.getAccount('bank').money
    local getmoneynegro = xPlayer.getAccount('black_money').money
    TriggerClientEvent("ng:OpenMenu", source, getmoney, getmoneybank, getmoneynegro)
end)