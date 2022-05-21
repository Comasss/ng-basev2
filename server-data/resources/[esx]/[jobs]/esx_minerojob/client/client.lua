ESX = nil
local clicks = 0
local roca = nil
local vendercositas = true
local tengopico = false
local fundir = {x = 1110.03, y = -2008.15, z = 31.06}
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    drawBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    drawBlips()
end)

RegisterNetEvent('esx_minerojob:recibodatacliente')
AddEventHandler('esx_minerojob:recibodatacliente', function(data) rocas = data end)

function DrawText3D(x, y, z, text)

    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 1.1 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function DrawText3Dlittle(x, y, z, text)

    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.5 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function get3DDistance(x1, y1, z1, x2, y2, z2)
    local a = (x1 - x2) * (x1 - x2)
    local b = (y1 - y2) * (y1 - y2)
    local c = (z1 - z2) * (z1 - z2)
    return math.sqrt(a + b + c)
end

function AbrirMenu()

    local elements = {
        {label = "Sí", value = "yes"}, {label = "No", value = "no"}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'get_job', {
        title = '¿Quieres que me quede con tus minerales y te de dinero a cambio?',
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'yes' then
            TriggerServerEvent('esx_minerojob:quitomin')
        end
        menu.close()
    end, function(data, menu) menu.close() end)
end

function startAnim(lib, anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false,
                     false, false)
    end)
end

Citizen.CreateThread(function()
    while true do
        if IsPedDead then
            clicks = 0
            roca = nil
        end
        s = 1000
        if PlayerData.job ~= nil and PlayerData.job.name == 'miner' then
            s = 5
            local coords = GetEntityCoords(GetPlayerPed(-1))
            for i = 1, #rocas, 1 do
                if GetDistanceBetweenCoords(coords.x, coords.y, coords.z,rocas[i].x, rocas[i].y, rocas[i].z) < 15 then
                    s = 1
                    if rocas[i].vida >= 50 then
                        DrawText3D(rocas[i].x, rocas[i].y, rocas[i].z,"Roca de ~b~" .. rocas[i].tipo .. "~w~ : ~g~" ..rocas[i].vida .. "/" .. rocas[i].max)
                    elseif rocas[i].vida >= 25 then
                        DrawText3D(rocas[i].x, rocas[i].y, rocas[i].z,"Roca de ~b~" .. rocas[i].tipo .. "~w~ : ~b~" ..rocas[i].vida .. "/" .. rocas[i].max)
                    elseif rocas[i].vida < 25 and rocas[i].vida ~= 0 then
                        DrawText3D(rocas[i].x, rocas[i].y, rocas[i].z,"Roca de ~b~" .. rocas[i].tipo .. "~w~ : ~y~" ..rocas[i].vida .. "/" .. rocas[i].max)
                    elseif rocas[i].vida <= 0 then
                        DrawText3D(rocas[i].x, rocas[i].y, rocas[i].z,"Roca de ~b~" .. rocas[i].tipo .."~w~ : ~r~ " .. rocas[i].vida .. "/" ..rocas[i].max)
                    end
                end
            end

            if get3DDistance(coords.x, coords.y, coords.z, 2953.68, 2790.68,41.28) > 150 then
                s = 1
                if PlayerData.job ~= nil and PlayerData.job.name == 'miner' and tengopico == true then
                    TriggerServerEvent('esx_minerojob:quitopico')
                    ESX.ShowNotification('El personal de seguridad te ha requisado la herramienta de trabajo.')
                    tengopico = false
                end
            end

            if GetCurrentPedWeapon(GetPlayerPed(-1), "WEAPON_BATTLEAXE", true) then
                s = 1
                if IsControlJustReleased(1, 24) then

                    for i = 1, #rocas, 1 do
                        if GetDistanceBetweenCoords(coords.x, coords.y,coords.z, rocas[i].x,rocas[i].y, rocas[i].z) < 1.8 and rocas[i].vida > 0 then
                            s = 1
                            roca = i
                        end
                    end
                    if roca ~= nil then
                        if PlayerData.job ~= nil and PlayerData.job.name == 'miner' then
                            s = 1
                            click()
                            Citizen.Wait(10)
                        else
                            s = 1
                            DisplayHelpText(
                                "Debes ser minero. Vuelve cuando lo seas para trabajar")
                        end
                    end
                end
            end

            if get3DDistance(2952.0, 2748.8, 43.48 - 1, coords.x, coords.y,coords.z) < 20 then
                s = 1
                DrawMarker(1, 2952.0, 2748.8, 43.48 - 1, 0, 0, 0, 0, 0, 0, 2.5, 2.5, 0.2, 1555, 132, 23, 255, 0, 0, 0,0)
            end
            if get3DDistance(2952.0, 2748.8, 43.48 - 1, coords.x, coords.y,coords.z) < 1.5 then
                s = 1
                if PlayerData.job ~= nil and PlayerData.job.name == 'miner' then
                    ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para coger tu herramienta de trabajo y comenzar a trabajar", vector3(2952.0, 2748.8, 43.48 + 1))
                    if IsControlJustReleased(1, 38) then
                        TriggerServerEvent('esx_minerojob:doypico')
                        ESX.ShowNotification('Equipate la herramienta que te hemos dado para trabajar.')
                        tengopico = true
                    end
                else
                    DisplayHelpText(
                        "Debes ser minero. Vuelve cuando lo seas para trabajar")
                end
            end

            if vendercositas then
                if get3DDistance(1109.4546, -2007.8351, 31.0407, coords.x, coords.y,coords.z) < 5 then
                    s = 1
                    ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para vender los minerales", vector3(1109.4546, -2007.8351, 31.0407 + 1))
                    if IsControlJustReleased(1, 38) then
                        AbrirMenu()
                    end
                end
            end

        end
        Citizen.Wait(s)
    end
end)

local blips = {
    {
        title = "Mina",
        colour = 2,
        id = 486,
        x = 2952.0,
        y = 2748.8,
        z = 43.48 - 1
    }, {
        title = "Venta de minerales",
        colour = 2,
        id = 486,
        x = 1110.03,
        y = -2008.15,
        z = 31.06 - 1
    }
}

function click()
    -- Los clicks habrán que equilibrarlos a la dinámica del servidor
    if roca ~= nil then
        if rocas[roca].vida > 0 then
            if clicks >= 25 then
                clicks = 0
                rocas[roca].vida = rocas[roca].vida - 20
                TriggerServerEvent('esx_minerojob:doymineral', rocas[roca].data)
                TriggerServerEvent('esx_minerojob:recibodata', rocas)
                roca = nil
            else
                clicks = clicks + 1
                roca = nil
            end
        end
    end

end

function drawBlips()
    for _, info in pairs(blips) do
        if PlayerData.job ~= nil and PlayerData.job.name == 'miner' then
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, info.id)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 0.8)
            SetBlipColour(info.blip, info.colour)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.title)
            EndTextCommandSetBlipName(info.blip)
        else
            if info.blip ~= nil then RemoveBlip(info.blip) end
        end
    end
end
