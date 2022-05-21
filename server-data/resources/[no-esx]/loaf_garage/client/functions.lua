Loaded = false
Cache = {}

CreateThread(function()
    while not NetworkIsSessionStarted() do 
        Wait(250)
    end

    while ESX == nil do 
        TriggerEvent("esx:getSharedObject", function(obj) 
            ESX = obj 
        end) 
        Wait(250) 
    end

    while ESX.GetPlayerData().job == nil do -- Wait for character (job) to load (support for kashacters, etc)
        Wait(250)
    end

    Loaded = true

    for k, v in pairs(Config.Garages) do
        if v.location then
            Cache["blip_garage_"..k] = AddBlip(v.location.xyz, 50, 38, Strings["garage"])
        else
            Cache["blip_garage_"..k] = AddBlip(v.browse.xyz, 50, 38, Strings["garage"])
        end
        Wait(5)
    end

    for k, v in pairs(Config.Impounds) do
        Cache["blip_impound_"..k] = AddBlip(v.Retrieve, 67, 47, Strings["impound"])
        Wait(5)
    end

    if Config.Impounding and Config.Impounding.AllowJobsToImpound and Config.Impounding.Command and Config.Impounding.AllowedJobs then
        RegisterCommand(Config.Impounding.Command, function()
            ImpoundClosestVehicle()
        end)
    end
end)

ImpoundClosestVehicle = function()
    local job = ESX.GetPlayerData().job.name
    local hasjob = false
    for k, v in pairs(Config.Impounding.AllowedJobs) do
        if v == job then
            hasjob = true
            break
        end
    end
    
    if not hasjob then 
        ESX.ShowNotification(Strings["you_dont_have_access"])
        return
    end

    local veh = ESX.Game.GetClosestVehicle()
    if DoesEntityExist(veh) and #(GetEntityCoords(veh) - GetEntityCoords(PlayerPedId())) <= 5.0 then
        local vehprops = ESX.Game.GetVehicleProperties(veh)
        ESX.TriggerServerCallback("loaf_garage:impound", function(res)
            if res then
                local timer = GetGameTimer() + 10000

                AddTextEntry("LOADING", Strings["impounding"])
                BeginTextCommandBusyspinnerOn("LOADING")
                EndTextCommandBusyspinnerOn(3)

                while DoesEntityExist(veh) do
                    while not NetworkHasControlOfEntity(veh) do
                        NetworkRequestControlOfEntity(veh)
                        Wait(100)
                    end

                    SetEntityAsMissionEntity(veh, true, true)
                    DeleteEntity(veh)
                    Wait(100)

                    if GetGameTimer() > timer then
                        ESX.ShowNotification(Strings["couldnt_impound"])
                        return
                    end
                end

                ESX.ShowNotification(Strings["impounded_veh"])
                
                BusyspinnerOff()
            end
        end, vehprops.plate)
    else
        ESX.ShowNotification(Strings["no_vehicle_nearby"])
    end
end

AddBlip = function(coords, sprite, colour, label, scale)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, 4)
    SetBlipScale(blip, 0.6)
    SetBlipAsShortRange(blip, true)
    if scale then
        SetBlipScale(blip, scale)
    end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)

    return blip
end

LoadModel = function(model)
    local ogmodel = model
    if type(model) == "string" then model = GetHashKey(model) elseif type(model) ~= "number" then return {loaded = false, model = model} end
    local timer = GetGameTimer() + 20000 -- 20 seconds to load

    AddTextEntry("LOADING", Strings["loading_object"])
    BeginTextCommandBusyspinnerOn("LOADING")
    EndTextCommandBusyspinnerOn(3)

    if not HasModelLoaded(model) and IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) and timer >= GetGameTimer() do -- give it time to load
            Wait(50)
        end
    end

    BusyspinnerOff()

    if HasModelLoaded(model) then
        return {loaded = true, model = model}
    else
        if not IsModelInCdimage(model) then
            ESX.ShowNotification("Model " .. ogmodel .. " is not in cd image")
        else
            ESX.ShowNotification("Contact your server owner, the model couldn't load (doesn't exist?): " .. ogmodel)
        end
        return {loaded = false, model = model}
    end
end

HelpText = function(text, sound)
    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(0, 0, (sound == true), -1)
end

DrawTxt3D = function(coords, text, sound, force)
    if not Config.Use3DText and not force then
        HelpText(text, (sound == true))
        return
    end

    local str = text

    local start, stop = string.find(text, "~([^~]+)~")
    if start then
        start = start - 2
        stop = stop + 2
        str = ""
        str = str .. string.sub(text, 0, start) .. "   " .. string.sub(text, start+2, stop-2) .. string.sub(text, stop, #text)
    end

    AddTextEntry(GetCurrentResourceName(), str)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1)

	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
end

Marker = function(position, text, control, distancecheck)
    DrawMarker(1, position - vec3(0.0, 0.0, 1.0), vec3(0.0, 0.0, 0.0), vec3(0.0, 0.0, 0.0), vec3(2.0, 2.0, 0.2), 202, 17, 227, 200, false, true)
    if not distancecheck then distancecheck = 1.0 end
    if #(GetEntityCoords(PlayerPedId()) - position) <= distancecheck and text then
        DrawTxt3D(position, text, true)
        if IsControlJustReleased(0, control or 51) then
            return true
        end
    end
end

GetDamages = function(vehicle)
    local damages = {
        damaged_windows = {},
        burst_tires = {},
        broken_doors = {},
        wheel_rotation = {},
        body_health = GetVehicleBodyHealth(vehicle), 
        engine_health = GetVehicleEngineHealth(vehicle),
        dirt_level = GetVehicleDirtLevel(vehicle),
    }

    local loaded, started = false, GetGameTimer()

    CreateThread(function()
        for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
            Wait(5)
            damages.wheel_rotation[tostring(i)] = GetVehicleWheelYRotation(vehicle, i)
            if IsVehicleTyreBurst(vehicle, i, false) then 
                damages.burst_tires[tostring(i)] = true
            else
                damages.burst_tires[tostring(i)] = false
            end 
        end
    
        for i = 0, 13 do
            if not IsVehicleWindowIntact(vehicle, i) then 
                Wait(5)
                damages.damaged_windows[tostring(i)] = true
            else
                damages.damaged_windows[tostring(i)] = false
            end
        end
        
        for i = 0, GetNumberOfVehicleDoors(vehicle) do 
            Wait(5)
            if IsVehicleDoorDamaged(vehicle, i) then 
                damages.broken_doors[tostring(i)] = true
            else
                damages.broken_doors[tostring(i)] = false
            end 
        end

        loaded = true
    end)

    while not loaded do
        Wait(250)
        if GetGameTimer() - started >= 5000 then
            break
        end
    end

    return damages
end

SetDamages = function(vehicle, damages)
    CreateThread(function()
        if damages.body_health then
            SetVehicleBodyHealth(vehicle, damages.body_health)
        end
    
        if damages.engine_health then
            SetVehicleEngineHealth(vehicle, damages.engine_health)
        end

        if damages.burst_tires and damages.broken_doors and damages.damaged_windows then
            for k, v in pairs(damages.burst_tires) do
                Wait(5)
                if v then
                    SetVehicleTyreBurst(vehicle, tonumber(k), true, 1000.0)
                end
                if damages.wheel_rotation and type(damages.wheel_rotation[k]) == "number" then
                    SetVehicleWheelYRotation(vehicle, tonumber(k), damages.wheel_rotation[k])
                end
            end

            for k, v in pairs(damages.damaged_windows) do
                if v then
                    Wait(5)
                    SmashVehicleWindow(vehicle, tonumber(k))
                end
            end

            for k, v in pairs(damages.broken_doors) do
                if v then
                    Wait(5)
                    SetVehicleDoorBroken(vehicle, tonumber(k), true)
                end
            end
        end

        if damages.dirt_level then
            SetVehicleDirtLevel(vehicle, damages.dirt_level)
        end
    end)
end

CreateLocalVehicle = function(data, coords, heading)
    local info = json.decode(data.vehicle)
    DoScreenFadeOut(0)
    local model = LoadModel(info.model)
    if model.loaded then
        model = model.model
        if Config.Interior.Enabled then
            coords = Config.Interior.Coords.xyz
            heading = Config.Interior.Coords.w
        end

        local vehicle = CreateVehicle(model, coords, heading, false, false)
        ESX.Game.SetVehicleProperties(vehicle, info)

        if Config.Damages then
            SetDamages(vehicle, json.decode(data.damages))
        end

        SetEntityAsMissionEntity(vehicle, true, false)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(model)

        while not HasCollisionLoadedAroundEntity(vehicle) do
            RequestCollisionAtCoord(coords)
            Wait(0)
        end

        SetVehicleOnGroundProperly(vehicle)

        SetVehRadioStation(vehicle, 'OFF')
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        FreezeEntityPosition(vehicle, true)
        DoScreenFadeIn(500)
        return vehicle
    end

    DoScreenFadeIn(500)

    return false
end

--679642867