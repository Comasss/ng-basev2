ESXEvent = "esx:getSharedObject"

ESX = nil

TriggerEvent(ESXEvent, function(obj) 
    ESX = obj 
end)

PayMoney = function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if xPlayer.getMoney() >= amount then
            xPlayer.removeMoney(amount)
            return true
        elseif xPlayer.getAccount("bank").money >= amount then
            xPlayer.removeAccountMoney("bank", amount)
            return true
        end
    end

    return false
end

GetVehicles = function(source, garage, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local vehicletype = Config.DefaultType
    if Config.Garages[garage] and Config.Garages[garage].vehicletype then
        vehicletype = Config.Garages[garage].vehicletype
    end

    if xPlayer and xPlayer.identifier then
        MySQL.Async.fetchAll("SELECT `vehicle`, `type`, `damages`, `garage`, `job`, `plate`, `stored` FROM `owned_vehicles` WHERE `owner` = @identifier", {
            ["@identifier"] = xPlayer.identifier,
        }, function(result)

            if result and #result > 0 then
                local to_return = {}
                for k, v in pairs(result) do
                    if not v.damages then v.damages = "{}" end
                    if (v.job == Config.DefaultJob or Config.ShowJobVehicles) and v.type == vehicletype then
                        if Config.IndependentGarage then
                            if v.garage == garage then
                                table.insert(to_return, v)
                            end
                        else
                            table.insert(to_return, v)
                        end
                    end
                end

                cb(to_return)
            else
                cb(false)
            end
        end)
    else
        cb(false)
    end
end

StoreVehicle = function(source, garage, damages, vehprops)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.identifier then
        MySQL.Async.fetchAll("SELECT `owner`, `vehicle` FROM `owned_vehicles` WHERE `plate` = @plate", {
            ["@plate"] = vehprops.plate,
        }, function(data)
            if data then data = data[1] end
            if data and data.owner == xPlayer.identifier then
                if json.decode(data.vehicle).model == vehprops.model then
                    MySQL.Async.execute("UPDATE `owned_vehicles` SET `vehicle`=@vehicle, `damages`=@damages, `garage`=@garage, `stored`=1 WHERE `plate`=@plate", {
                        ["@vehicle"] = json.encode(vehprops),
                        ["@damages"] = json.encode(damages),
                        ["@garage"] = garage,
                        ["@plate"] = vehprops.plate
                    })

                    TriggerClientEvent("loaf_garage:deleteStoredVehicle", xPlayer.source, vehprops.plate)
                else
                  --  print(data.owner .. " tried to store a vehicle with another model. Cheater?")
                end
            end
        end)
    end
end

TakeOutVehicle = function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.identifier then
        MySQL.Async.fetchScalar("SELECT `owner` FROM `owned_vehicles` WHERE `owner`=@identifier AND `plate`=@plate AND `stored`=1", {
            ["@identifier"] = xPlayer.identifier,
            ["@plate"] = plate,
        }, function(owner)
            if owner then
                MySQL.Async.execute("UPDATE `owned_vehicles` SET `stored`=0 WHERE `plate`=@plate", {
                    ["@plate"] = plate
                })
                cb(true)
            else
                cb(false)
            end
        end)
    else
        cb(false)
    end
end

ImpoundVehicle = function(plate, cb)
    if plate and type(plate) == "string" then
        MySQL.Async.fetchScalar("SELECT `plate` FROM `owned_vehicles` WHERE `plate`=@plate", {
            ["@plate"] = plate,
        }, function(result)
            if result and type(result) == "string" then
                cb(true)
            else
                cb(false)
            end
        end)
    end
end

GetImpounded = function(source, cb, vehtype)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.identifier then
        MySQL.Async.fetchAll("SELECT `vehicle`, `type`, `damages`, `garage`, `job`, `plate` FROM `owned_vehicles` WHERE `owner` = @identifier AND `stored`=0", {
            ["@identifier"] = xPlayer.identifier,
        }, function(result)

            if result and #result > 0 then
                local to_return = {}
                for k, v in pairs(result) do
                    if not v.damages then v.damages = "{}" end
                    if (v.job == Config.DefaultJob or Config.ShowJobVehicles) and v.type == vehtype then
                        table.insert(to_return, v)
                    end
                end

                cb(to_return)
            else
                cb(false)
            end
        end)
    else
        cb(false)
    end
end

RetrieveCar = function(source, plate, coords, heading)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.identifier then
        if PayMoney(source, Config.ImpoundPrice) then
            MySQL.Async.fetchAll("SELECT `vehicle`, `damages`, `garage`, `job`, `plate` FROM `owned_vehicles` WHERE `owner`=@identifier AND `stored`=0 AND `plate`=@plate", {
                ["@identifier"] = xPlayer.identifier,
                ["@plate"] = plate
            }, function(result)
                if result and result[1] then
                    TriggerClientEvent("loaf_garage:spawnImpoundedCar", source, coords, heading, result[1])
                end
            end)
        else
            xPlayer.showNotification(Strings["not_enough_money"])
        end
    end
end