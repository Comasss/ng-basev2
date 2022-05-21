local scriptName = "loaf_garage"
local msg = function(type, msg)
    local len = "[" .. scriptName .. "]: " .. msg
    local equals = ""
    for i = 1, #len do
        equals = equals .. "="
    end
    if type == "error" then
    --    print("\n^0" .. equals  .. "\n[^1" .. scriptName .. "^0]: " .. msg .. "\n^0" .. equals .. "\n")
    else
  --      print("\n^0" .. equals .. "\n[^2" .. scriptName .. "^0]: " .. msg .. "\n^0" .. equals .. "\n")
    end
end

CreateThread(function()
    while ESXEvent == nil do
        Wait(1000)
    end

    ESX = nil

    TriggerEvent(ESXEvent, function(obj) 
        ESX = obj 
    end)

    msg("success", "authorized & started.")

    ESX.RegisterServerCallback("loaf_garage:getImpoundedVehicles", function(source, cb, vehtype)
        GetImpounded(source, cb, vehtype)
    end)

    ESX.RegisterServerCallback("loaf_garage:getVehicles", function(source, cb, garage)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer and xPlayer.identifier and garage then
            local vehicles = GetVehicles(xPlayer.source, garage, function(vehicles)
                cb(vehicles)
            end)
        end
    end)

    ESX.RegisterServerCallback("loaf_garage:takeOutVehicle", function(source, cb, plate)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer.identifier then
            TakeOutVehicle(source, cb, plate)
        else
            cb(false)
        end
    end)

    ESX.RegisterServerCallback("loaf_garage:impound", function(source, cb, plate)
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer.job.name
        local hasjob = false
        for k, v in pairs(Config.Impounding.AllowedJobs) do
            if v == job then
                ImpoundVehicle(plate, cb)
                break
            end
        end
    end)

    RegisterServerEvent("loaf_garage:storeVehicle")
    AddEventHandler("loaf_garage:storeVehicle", function(garage, damages, vehprops)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer.identifier then
            StoreVehicle(xPlayer.source, garage, damages, vehprops)
        end
    end)

    RegisterServerEvent("loaf_garage:retrieveCar")
    AddEventHandler("loaf_garage:retrieveCar", function(plate, coords, heading)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer.identifier then
            RetrieveCar(xPlayer.source, plate, coords, heading)
        end
    end)
end) 