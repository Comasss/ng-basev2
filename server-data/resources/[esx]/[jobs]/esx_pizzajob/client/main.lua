--[[ ============================================================ ]] --
--[[ |       FIVEM MSX DELIVERY PLUGIN REMAKE BY AKKARIIN       | ]] --
--[[ ============================================================ ]] --
ESX = nil

local Status = {
    DELIVERY_INACTIVE = 0,
    PLAYER_STARTED_DELIVERY = 1,
    PLAYER_REACHED_VEHICLE_POINT = 2,
    PLAYER_REMOVED_GOODS_FROM_VEHICLE = 3,
    PLAYER_REACHED_DELIVERY_POINT = 4,
    PLAYER_RETURNING_TO_BASE = 5
}

local CurrentStatus = Status.DELIVERY_INACTIVE
local CurrentSubtitle = nil
local CurrentBlip = nil
local CurrentType = nil
local CurrentVehicle = nil
local CurrentAttachments = {}
local CurrentVehicleAttachments = {}
local DeliveryLocation = {}
local DeliveryComplete = {}
local DeliveryRoutes = {}
local PlayerJob = nil
local FinishedJobs = 0
local isPedStressed = false

-- Make player look like a worker
function LoadWorkPlayerSkin(deliveryType)
    TriggerEvent('skinchanger:getSkin', function(skin)
            
            if skin.sex == 0 then
                if Config.Uniforms["empleado_outfit"].male ~= nil then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms["empleado_outfit"].male)
                else
                    ESX.ShowNotification("Error al cambiarte de uniforme")
                end
                if job ~= 'citizen_wear' and job ~= 'empleado_outfit' then end
            else
                if Config.Uniforms["empleado_outfit"].female ~= nil then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms["empleado_outfit"].female)
                else
                    ESX.ShowNotification("Error al cambiarte de uniforme")
                end
                if job ~= 'citizen_wear' and job ~= 'empleado_outfit' then end
            end
    end)
end

function LoadDefaultPlayerSkin()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end


function HandleInput()
    if ESX.PlayerData.job == nil then
        return
    end
    
    if ESX.PlayerData.job.name ~= "pizza" then
        return
    end
    
    if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
        DisableControlAction(0, 21, true)
    else
        Citizen.Wait(500)
    end
end

-- Main logic handler
function HandleLogic()
    if ESX.PlayerData.job == nil then
        return
    end
    
    
    if ESX.PlayerData.job.name ~= "pizza" then
        return
    end
    
    local playerPed = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(playerPed)
    
    if CurrentStatus ~= Status.DELIVERY_INACTIVE then
        if IsPedDeadOrDying(playerPed, true) then
            FinishDelivery(CurrentType, false)
            return
        elseif GetVehicleEngineHealth(CurrentVehicle) < 20 and CurrentVehicle ~= nil then
            FinishDelivery(CurrentType, false)
            return
        end
        
        if CurrentStatus == Status.PLAYER_STARTED_DELIVERY then
            if not IsPlayerInsideDeliveryVehicle() then
                CurrentSubtitle = Config.Locales["get_back_in_vehicle"]
            else
                CurrentSubtitle = nil
            end
            
            if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, DeliveryLocation.Item1.x, DeliveryLocation.Item1.y, DeliveryLocation.Item1.z, true) < 1.5 then
                CurrentStatus = Status.PLAYER_REACHED_VEHICLE_POINT
                CurrentSubtitle = Config.Locales["remove_goods_subtext"]
                PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
            end
        end
        
        if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
            
            if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, DeliveryLocation.Item2.x, DeliveryLocation.Item2.y, DeliveryLocation.Item2.z, true) < 1.5 then
                
                TriggerServerEvent("esx_pizzajob:finishDelivery:server", CurrentType)
                PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
                FinishedJobs = FinishedJobs + 1
                
                ESX.ShowNotification(Config.Locales["finish_job"] .. FinishedJobs .. "/" .. #DeliveryRoutes)
                
                if FinishedJobs >= #DeliveryRoutes then
                    RemovePlayerProps()
                    RemoveBlip(CurrentBlip)
                    DeliveryLocation.Item1 = Config.Base.retveh
                    DeliveryLocation.Item2 = {x = 0, y = 0, z = 0}
                    CurrentBlip = CreateBlipAt(DeliveryLocation.Item1.x, DeliveryLocation.Item1.y, DeliveryLocation.Item1.z)
                    CurrentSubtitle = Config.Locales["get_back_to_deliveryhub"]
                    CurrentStatus = Status.PLAYER_RETURNING_TO_BASE
                    return
                else
                    RemovePlayerProps()
                    GetNextDeliveryPoint(false)
                    CurrentStatus = Status.PLAYER_STARTED_DELIVERY
                    CurrentSubtitle = Config.Locales["drive_next_point"]
                    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
                end
            end
        end
        Citizen.Wait(500)
    else
        Citizen.Wait(1000)
    end
end

-- Handling markers and object status
function HandleMarkers()
    if ESX.PlayerData.job == nil then
        return
    end
    
    if ESX.PlayerData.job.name ~= "pizza" then
        return
    end
    
    local pCoords = GetEntityCoords(GetPlayerPed(-1))
    local deleter = Config.Base.deleter
    
    if CurrentStatus ~= Status.DELIVERY_INACTIVE then
        DrawMarker(20, deleter.x, deleter.y, deleter.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 249, 38, 114, 150, true, true)
        if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, deleter.x, deleter.y, deleter.z) < 1.5 then
            ESX.ShowFloatingHelpNotification("Presiona ~r~[E]~s~ para terminar la entrega, sientate en el vehículo o perderas la fianza", vector3(pCoords.x, pCoords.y, pCoords.z + 1))
            if IsControlJustReleased(0, 51) then
                EndDelivery()
                return
            end
        end
        
        if CurrentStatus == Status.PLAYER_STARTED_DELIVERY then
            if not IsPlayerInsideDeliveryVehicle() and CurrentVehicle ~= nil then
                local VehiclePos = GetEntityCoords(CurrentVehicle)
                local ArrowHeight = VehiclePos.z
                ArrowHeight = VehiclePos.z + 1.0
                
                DrawMarker(20, VehiclePos.x, VehiclePos.y, ArrowHeight, 0, 0, 0, 0, 180.0, 0, 0.8, 0.8, 0.8, 102, 217, 239, 150, true, true)
            else
                local dl = DeliveryLocation.Item1
                if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, dl.x, dl.y, dl.z, true) < 150 then
                    DrawMarker(20, dl.x, dl.y, dl.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
                end
            end
        end
        
        if CurrentStatus == Status.PLAYER_REACHED_VEHICLE_POINT then
            if not IsPlayerInsideDeliveryVehicle() then
                TrunkPos = GetEntityCoords(CurrentVehicle)
                TrunkForward = GetEntityForwardVector(CurrentVehicle)
                local ScaleFactor = 1.0
                
                for k, v in pairs(Config.Scales) do
                    if k == CurrentType then
                        ScaleFactor = v
                    end
                end
                
                TrunkPos = TrunkPos - (TrunkForward * ScaleFactor)
                TrunkHeight = TrunkPos.z
                TrunkHeight = TrunkPos.z + 0.7
                
                local ArrowSize = {x = 0.8, y = 0.8, z = 0.8}
                
                if CurrentType == 'scooter' then
                    ArrowSize = {x = 0.15, y = 0.15, z = 0.15}
                end
                
                DrawMarker(20, TrunkPos.x, TrunkPos.y, TrunkHeight, 0, 0, 0, 180.0, 0, 0, ArrowSize.x, ArrowSize.y, ArrowSize.z, 102, 217, 239, 150, true, true)
                
                if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, TrunkPos.x, TrunkPos.y, TrunkHeight, true) < 1.0 then
                    ESX.ShowFloatingHelpNotification("Presiona ~r~[E]~s~ para sacar la mercancía del vehículo", vector3(pCoords.x, pCoords.y, pCoords.z + 1))
                    if IsControlJustReleased(0, 51) then
                        GetPlayerPropsForDelivery(CurrentType)
                        CurrentStatus = Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE
                    end
                end
            end
        end
        
        if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
            local dp = DeliveryLocation.Item2
            DrawMarker(20, dp.x, dp.y, dp.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
        end
        
        if CurrentStatus == Status.PLAYER_RETURNING_TO_BASE then
            local dp = Config.Base.deleter
            DrawMarker(20, dp.x, dp.y, dp.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
        end
    else
        local bCoords = Config.Base.coords
        if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, bCoords.x, bCoords.y, bCoords.z, true) < 150.0 then
            local ScooterPos = Config.Base.scooter
            
            DrawMarker(1, ScooterPos.x, ScooterPos.y, ScooterPos.z, 0, 0, 0, 0, 0, 0, 2.5, 2.5, 0.2, 255, 0, 0, 150, false, true)
            
            local SelectType = false
            
            if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, ScooterPos.x, ScooterPos.y, ScooterPos.z, true) < 1.5 then
                ESX.ShowFloatingHelpNotification("Presiona ~r~[E]~s~ para empezar el reparto", vector3(pCoords.x, pCoords.y, pCoords.z + 1))
                SelectType = 'scooter'
            else
                SelectType = false
            end
            
            if SelectType ~= false then
                if IsControlJustReleased(0, 51) then
                    StartDelivery(SelectType)
                    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
                end
            end
        end
    end
end


-- Create a blip for the location
function CreateBlipAt(x, y, z)
    
    local tmpBlip = AddBlipForCoord(x, y, z)
    
    SetBlipSprite(tmpBlip, 1)
    SetBlipScale(tpmBlip, 0.8)
    SetBlipColour(tmpBlip, 66)
    SetBlipAsShortRange(tmpBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Locales["dst_blip"])
    EndTextCommandSetBlipName(blip)
    SetBlipAsMissionCreatorBlip(tmpBlip, true)
    SetBlipRoute(tmpBlip, true)
    
    return tmpBlip
end

-- Tell the server start delivery job
function StartDelivery(deliveryType)
    TriggerServerEvent("esx_pizzajob:removeSafeMoney:server", deliveryType)
end

-- Check is the player in the delivery vehicle
function IsPlayerInsideDeliveryVehicle()
    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        if playerVehicle == CurrentVehicle then
            return true
        end
    end
    return false
end

-- Is this checkpoint the last checkpoint?
function IsLastDelivery()
    local isLast = false
    local dp1 = DeliveryLocation.Item2
    local dp2 = DeliveryRoutes[#DeliveryRoutes].Item2
    if dp1.x == dp2.x and dp1.y == dp2.y and dp1.z == dp2.z then
        isLast = true
    end
    return isLast
end

-- Remove all object from the player ped
function RemovePlayerProps()
    print("Removing entities from player")
    for i = 0, #CurrentAttachments do
        DetachEntity(CurrentAttachments[i])
        DeleteEntity(CurrentAttachments[i])
    end
    ClearPedTasks(GetPlayerPed(-1))
    CurrentAttachments = {}
end

-- Spawn an object and attach it to the player
function GetPlayerPropsForDelivery(deliveryType)
    
    local ModelHash = GetHashKey("prop_pizza_box_02")
    local PlayerPed = GetPlayerPed(-1)
    local PlayerPos = GetEntityCoords(PlayerPed)
    
    ESX.Streaming.RequestModel(ModelHash, function()
        local Object = CreateObject(ModelHash, PlayerPos.x, PlayerPos.y, PlayerPos.z, true, false, false)
        AttachEntityToEntity(Object, PlayerPed, GetPedBoneIndex(PlayerPed, 60309), 0.215, 0.05, 0.200, -50.0, 290.0, 0.0, true, false, false, true, 1, true)
        table.insert(CurrentAttachments, Object)
    end)
    
    ESX.Streaming.RequestAnimDict("anim@heists@box_carry@", function()
        TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
        print("played animation")
    end)
    
    local JobData = (FinishedJobs + 1) / #DeliveryRoutes
    
    if JobData >= 0.5 and #CurrentVehicleAttachments > 2 then
        DetachEntity(CurrentVehicleAttachments[1])
        DeleteEntity(CurrentVehicleAttachments[1])
        table.remove(CurrentVehicleAttachments, 1)
    end
    if JobData >= 1.0 and #CurrentVehicleAttachments > 1 then
        DetachEntity(CurrentVehicleAttachments[1])
        DeleteEntity(CurrentVehicleAttachments[1])
        table.remove(CurrentVehicleAttachments, 1)
    end
end



-- Spawn the scooter, truck or van
function SpawnDeliveryVehicle(deliveryType)
    
    local Rnd = GetRandomFromRange(1, #Config.ParkingSpawns)
    local SpawnLocation = Config.ParkingSpawns[Rnd]
    
    if deliveryType == 'scooter' then
        local ModelHash = GetHashKey(Config.Models.scooter)
        ESX.Streaming.RequestModel(ModelHash, function()
            CurrentVehicle = CreateVehicle(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, SpawnLocation.h, true, true)
            SetVehicleNumberPlateText(CurrentVehicle, "JOB" .. GetPlayerServerId(PlayerId()))
            SetEntityAsMissionEntity(CurrentVehicle, true, false)
            SetVehicleHasBeenOwnedByPlayer(CurrentVehicle, true)
            SetVehicleNeedsToBeHotwired(CurrentVehicle, false)
        end)
    end
    
    exports["LegacyFuel"]:SetFuel(CurrentVehicle, 100)
    DecorSetInt(CurrentVehicle, "Delivery.Rental", Config.DecorCode)
    SetVehicleOnGroundProperly(CurrentVehicle)
    
    if deliveryType == 'scooter' then
        local ModelHash = GetHashKey("ba_prop_battle_bag_01b")
        ESX.Streaming.RequestModel(ModelHash, function()
            local Object = CreateObject(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, true, false, false)
            AttachEntityToEntity(Object, CurrentVehicle, GetEntityBoneIndexByName(CurrentVehicle, "misc_a"), 0.0, -0.55, 0.28, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
            table.insert(CurrentVehicleAttachments, Object)
        end)
    end
end

-- Get the next destination
function GetNextDeliveryPoint(firstTime)
    if CurrentBlip ~= nil then
        RemoveBlip(CurrentBlip)
    end
    
    for i = 1, #DeliveryComplete do
        if not DeliveryComplete[i] then
            if not firstTime then
                DeliveryComplete[i] = true
                break
            end
        end
    end
    
    for i = 1, #DeliveryComplete do
        if not DeliveryComplete[i] then
            CurrentBlip = CreateBlipAt(DeliveryRoutes[i].Item1.x, DeliveryRoutes[i].Item1.y, DeliveryRoutes[i].Item1.z)
            DeliveryLocation = DeliveryRoutes[i]
            break
        end
    end
end

-- Create some random destinations
function CreateRoute(deliveryType)
    
    local TotalDeliveries = GetRandomFromRange(Config.Deliveries.min, Config.Deliveries.max)
    local DeliveryPoints = {}
    
    if deliveryType == 'scooter' then
        DeliveryPoints = Config.DeliveryLocationsScooter
    end
    
    while #DeliveryRoutes < TotalDeliveries do
        Citizen.Wait(10)
        local PreviousPoint = nil
        if #DeliveryRoutes < 1 then
            PreviousPoint = GetEntityCoords(GetPlayerPed(-1))
        else
            PreviousPoint = DeliveryRoutes[#DeliveryRoutes].Item1
        end
        
        local Rnd = GetRandomFromRange(1, #DeliveryPoints)
        local NextPoint = DeliveryPoints[Rnd]
        local HasPlayerAround = false
        
        for i = 1, #DeliveryRoutes do
            local Distance = GetDistanceBetweenCoords(NextPoint.Item1.x, NextPoint.Item1.y, NextPoint.Item1.z, DeliveryRoutes[i].x, DeliveryRoutes[i].y, DeliveryRoutes[i].z, true)
            if Distance < 50 then
                HasPlayerAround = true
            end
        end
        
        if not HasPlayerAround then
            table.insert(DeliveryRoutes, NextPoint)
            table.insert(DeliveryComplete, false)
        end
    end
end

-- Create a blip to tell the player back to the delivery hub
function ReturnToBase(deliveryType)
    CurrentBlip = CreateBlipAt(Config.Base.retveh.x, Config.Base.retveh.y, Config.Base.retveh.z)
end

-- End Delivery, is the player finish or failed?
function EndDelivery()
    local PlayerPed = GetPlayerPed(-1)
    if not IsPedSittingInAnyVehicle(PlayerPed) or GetVehiclePedIsIn(PlayerPed) ~= CurrentVehicle then
        TriggerEvent("MpGameMessage:send", Config.Locales["delivery_end"], Config.Locales["delivery_failed"], 3500, 'error')
        FinishDelivery(CurrentType, false)
    else
        TriggerEvent("MpGameMessage:send", Config.Locales["delivery_end"], Config.Locales["delivery_finish"], 3500, 'success')
        ReturnVehicle(CurrentType)
    end
end

-- Return the vehicle to system
function ReturnVehicle(deliveryType)
    
    TriggerEvent("dps_citizen:QuitarLlave", CurrentVehicle)
    Citizen.Wait(1000)
    SetEntityAsMissionEntity(CurrentVehicle, false, true)
    SetVehicleAsNoLongerNeeded(CurrentVehicle)
    DeleteEntity(CurrentVehicle)
    ESX.ShowNotification(Config.Locales["delivery_vehicle_returned"])
    FinishDelivery(deliveryType, true)


end

-- When the delivery mission finish
function FinishDelivery(deliveryType, safeReturn)
    TriggerEvent("dps_citizen:QuitarLlave", CurrentVehicle)
    Citizen.Wait(1000)
    if CurrentVehicle ~= nil then
        for i = 0, #CurrentVehicleAttachments do
            DetachEntity(CurrentVehicleAttachments[i])
            DeleteEntity(CurrentVehicleAttachments[i])
        end
        CurrentVehicleAttachments = {}
        DeleteEntity(CurrentVehicle)
    end
    
    CurrentStatus = Status.DELIVERY_INACTIVE
    CurrentVehicle = nil
    CurrentSubtitle = nil
    FinishedJobs = 0
    DeliveryRoutes = {}
    DeliveryComplete = {}
    DeliveryLocation = {}
    
    if CurrentBlip ~= nil then
        RemoveBlip(CurrentBlip)
    end
    
    CurrentBlip = nil
    CurrentType = ''
    
    TriggerServerEvent("esx_pizzajob:returnSafe:server", deliveryType, safeReturn)
    
    LoadDefaultPlayerSkin()
end

-- Some helpful functions
function DisplayHelpText(text)
    ESX.ShowHelpNotification(text)
end

function GetRandomFromRange(a, b)
    return GetRandomIntInRange(a, b)
end

function Draw2DTextCenter(x, y, text, scale)
    SetTextFont(0)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    ESX.PlayerData = ESX.GetPlayerData()
end)

-- Main thread
Citizen.CreateThread(function()
    blip = AddBlipForCoord(Config.Base.coords.x, Config.Base.coords.y, Config.Base.coords.z)
    SetBlipSprite(blip, 267)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 47)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Locales['blip_name'])
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        HandleInput()
        HandleLogic()
    end
end)

Citizen.CreateThread(function()
    while true do
        local _msec = 250
        if CurrentSubtitle ~= nil then
            _msec = 0
            Draw2DTextCenter(0.5, 0.88, CurrentSubtitle, 0.7)
        end
        Citizen.Wait(5)
        HandleMarkers()
    end
    Citizen.Wait(_msec)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_pizzajob:startJob:client')
AddEventHandler('esx_pizzajob:startJob:client', function(deliveryType)
    TriggerEvent("MpGameMessage:send", Config.Locales["delivery_start"], Config.Locales["delivery_tips"], 3500, 'success')
    LoadWorkPlayerSkin(deliveryType)
    local ModelHash = GetHashKey("prop_paper_bag_01")
    ESX.Streaming.RequestModel(ModelHash, function()
        SpawnDeliveryVehicle(deliveryType)
        CreateRoute(deliveryType)
        GetNextDeliveryPoint(true)
        CurrentType = deliveryType
        CurrentStatus = Status.PLAYER_STARTED_DELIVERY
    end)
end)
