local PlayerData = {}
ESX = nil

ng_noclip = false
ng_godmode = false
ng_vanish = false
ng_noclipSpeed = 2.01
ng = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setjob')
AddEventHandler('esx:setjob', function(job)
  PlayerData.job = job
end)

-- MENU PRINCIPAL --

MenuPersonal = function()
  
  ESX.UI.Menu.CloseAll()

  local id = GetPlayerServerId(PlayerId())

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'menu_personal',
    {
      title    = '<span style="color:#ff0052;">Menu Personal - '..id.."",
      align    = 'bottom-right',
      elements = {
        {label = "Info", value = 'part1'},
        {label = "Extras", value = 'part2'},
        {label = "Admin", value = 'part3'},
    }
  },
    function(data, menu)

      local player, distance = ESX.Game.GetClosestPlayer()

      if data.current.value == 'part1' then
        TriggerServerEvent('ng:dinero')
      elseif data.current.value == 'part2' then
        part2()
      elseif data.current.value == 'part3' then
        ESX.TriggerServerCallback("ng:fetchUserRank", function(playerRank)
          if playerRank == "mod" or playerRank == "admin" or playerRank == "superadmin" then
            part3()
          else
            ESX.ShowNotification("No tienes permiso para ver esto ;)")
            end
          end)
      end
    end,
    function(data, menu)
      menu.close()
    end)
  end

RegisterKeyMapping("MenuPersonal", "Menu Personal", "keyboard", "F10")
RegisterCommand("MenuPersonal", function()
   MenuPersonal()
end)

-- INFORMACIÓN --

RegisterNetEvent("ng:OpenMenu")
AddEventHandler("ng:OpenMenu", function(dineromano, dinerobanco, blackmoney)
    part1(dineromano, dinerobanco, blackmoney)
end)

part1 = function(dineromano, dinerobanco, blackmoney)

  local DataJob = ESX.GetPlayerData()
  local id = GetPlayerServerId(PlayerId())
  local job = DataJob.job.label
  local jobgrade = DataJob.job.grade_label
  local name = GetPlayerName(PlayerId())

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'part1',
    {
      title    = ""..name.." - "..id.. "",
      align    = 'bottom-right',
      elements = {
        {label = job .. " - " .. jobgrade, value = 'verjob'},
        {label = 'Banco - <span style="color:lime;">' ..dinerobanco.. '$', value = 'nil'},
        {label = 'Dinero en mano - <span style="color:lime;">'..dineromano.. '$', value = 'nil'},
        {label = 'Dinero en negro - <span style="color:red;">'..blackmoney.. '$', value = 'nil'},
        {label = "Ver/Mostrar licencias", value = 'licenses_interaction'},
      },
    },
    function(data, menu)

      local player, distance = ESX.Game.GetClosestPlayer()

      if data.current.value == 'verjob' then
      ExecuteCommand("trabajo")
      elseif data.current.value == 'licenses_interaction' then
      Licencias()
       end
    end,
    function(data, menu)
      menu.close()
    end)
end

-- VARIOS --

part2 = function()

  local id = GetPlayerServerId(PlayerId())
  local name = GetPlayerName(PlayerId())
  
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'part2',
    {
      title    = ""..name.." - "..id.. "",
      align    = 'bottom-right',
      elements = {
        {label = "Mostrar/Ocultar hud", value = 'hud'},
        {label = "Activar/Desactivar graficos", value = 'graficos'},
        {label = "Resetear voz", value = 'voz'},
        {label = "Resetear pj", value = 'pj'},
        {label = "Habilidades", value = 'habilidades'},
        {label = "Gps Rapido", value = 'gps'},
        {label = "Menu vehículo", value = 'veh'},
        {label = "Rockstar Editor", value = 'rockstar'},
        {label = "Borrar Chat", value = 'chat'},
      },
    },
    function(data, menu)

      local player, distance = ESX.Game.GetClosestPlayer()

      if data.current.value == 'hud' then
      ExecuteCommand("hud")
      elseif data.current.value == 'graficos' then
        if not graphMode then
            graphMode = true
            SetTimecycleModifier('MP_Powerplay_blend')
            SetExtraTimecycleModifier('reflection_correct_ambient')
            ESX.ShowNotification('Graficos ~y~Activados')
        else
            graphMode = false
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
            ESX.ShowNotification('Graficos ~r~Desactivados')
        end
      elseif data.current.value == 'voz' then
        ExecuteCommand("rvoz")
      elseif data.current.value == 'pj' then
        ExecuteCommand("fixpj")
      elseif data.current.value == 'habilidades' then
        ExecuteCommand("habilidades")
      elseif data.current.value == 'gps' then
        GPS()
      elseif data.current.value == 'veh' then
        ExecuteCommand("carmenu")
      elseif data.current.value == 'rockstar' then
        TriggerEvent('ng:rockstarEditor')
      elseif data.current.value == 'chat' then
        ExecuteCommand("cls")
       end
    end,
    function(data, menu)
      menu.close()
    end)
end

-- ADMIN --

part3 = function()
  local elements = {}

  local elements = {
      {label = "Noclip", value = "noclip"},
      {label = "GodMode", value = "godmode"},
      {label = "Teletransporte a punto", value = "tpoint"},
      {label = "Spawnear coche", value = "spawnCar"},
      {label = "Borrar vehículo", value = "clearVehicle"},
      {label = "Borrar inventario", value = "invt"},
      {label = "Borrar el chat", value = "clearChat"},
      {label = "Rellenar vida", value = "heal"},
      {label = "Reparar coche", value = "fix"},
      {label = "Invisible",     value = "inv"},
      {label = "Mostrar Cordenadas", value = "coords"},
      {label = "Anuncio 5 minutos", value = "anuncio"},
      {label = "Cerrar", value = "close"}
  }


ESX.UI.Menu.CloseAll()

ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'adminMenu',
  {
    title  = "Menu administrativo",
    align = "right",
    elements = elements
  },
  function(data, menu)
    if data.current.value == "noclip" then
      TriggerEvent('ng:nocliped')
      ESX.UI.Menu.CloseAll()
    elseif data.current.value == "godmode" then
      TriggerEvent('ng:godmodePlayer')
      ESX.UI.Menu.CloseAll()
    elseif data.current.value == "tpoint" then
      ExecuteCommand("tpm")
    elseif data.current.value == "spawnCar" then
      openGetterMenu('spawnCar')
    elseif data.current.value == "clearVehicle" then
      TriggerEvent('esx:deleteVehicle')
      TriggerEvent('esx:showNotification', "Vehículo ~r~eliminado~w~.")
    elseif data.current.value == "invt" then
      borrarinvt('invt')
    elseif data.current.value == "clearChat" then
      TriggerEvent('ng:clearchat')
    elseif data.current.value == "heal" then
      ExecuteCommand("heal me")
    elseif data.current.value == "fix" then
      TriggerEvent( 'ng:repairVehicle')
    elseif data.current.value == "inv" then
      TriggerEvent('ng:invisible')
    elseif data.current.value == "coords" then
      TriggerEvent('ng:coords')
    elseif data.current.value == "anuncio" then
      TriggerServerEvent('ng:announce')
    elseif data.current.value == "close" then
      ESX.UI.Menu.CloseAll()
    end
  end,
  function(data, menu)
    menu.close()
  end)
end

  Citizen.CreateThread(function()
    while true do 
        local _msec = 250
        if ng_noclip then
          _msec = 0
            local ped = GetPlayerPed(-1)
            local x,y,z = getPosition()
            local dx,dy,dz = getCamDirection()
            local speed = ng_noclipSpeed
        

            SetEntityVelocity(ped, 0.05,  0.05,  0.05)

            if IsControlPressed(0, 32) then
              _msec = 0
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end

            if IsControlPressed(0, 269) then
              _msec = 0
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end

            SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
        end
        Citizen.Wait(_msec)
    end
end)

-- INICIO FUNCIONES --

-- SPAWN COCHE --

openGetterMenu = function(type)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'getterAdminMenu',
	{
		title = "Ingrese el parámetro correspondiente",
	}, function(data, menu)
		local parameter = data.value
		if type == "spawnCar" then
			TriggerEvent('esx:spawnVehicle', parameter)
			TriggerEvent('esx:showNotification', "Se ha intentado spawnear un : ~g~"..parameter.."~w~")
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

-- BORRAR INVENTARIO --

borrarinvt = function(type)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'borrarinventario',
	{
		title = "Ingrese la ID del jugador",
	}, function(data, menu)
		local parameter = data.value
		if type == "invt" then
      ExecuteCommand('clearinventory '..parameter..'')
      ExecuteCommand('clearloadout '..parameter..'')
      TriggerEvent('esx:showNotification', "Se ha borrado el inventario del la ID: ~g~"..parameter.."~w~")
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

-- FIX PJ --

RegisterCommand('fixpj', function()
  local hp = GetEntityHealth(GetPlayerPed(-1))
  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
      local isMale = skin.sex == 0
      TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
              TriggerEvent('skinchanger:loadSkin', skin)
              TriggerEvent('esx:restoreLoadout')
              TriggerEvent('dpc:ApplyClothing')
              SetEntityHealth(GetPlayerPed(-1), hp)
          end)
      end)
  end)
end, false)

-- GPS --

GPS = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gps_spawnpoit',{
        title = 'GPS Rápido',
		    align = 'bottom-right',
		    elements = {
			  {label = 'Garage Cental', value = 'garage_central'},
			  {label = 'Comisaria', value = 'police_office'}, 
			  {label = 'Hospital', value = 'hospital'}, 
			  {label = 'Concesionario', value = 'vehicle_shop'},
			  {label = 'Mecánico', value = 'empty'},
			  {label = 'Badulake Central', value = 'badu'},	
		 }
  },
	function(data, menu)
		local val = data.current.value
		
		if val == 'garage_central' then
			SetNewWaypoint(215.12, -815.74)
		elseif val == 'police_office' then 
			SetNewWaypoint(411.28, -978.73)
		elseif val == 'vehicle_shop' then
			SetNewWaypoint(-33.78, -1102.12)
		elseif val == 'hospital' then 
			SetNewWaypoint(291.37, -581.63)
		elseif val == 'empty' then
			SetNewWaypoint(-359.59, -133.44)
		elseif val == 'badu' then
			SetNewWaypoint(-708.01, -913.8)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

-- ROCKSTAR EDITOR --

rockstarEditor = function()

  local elements = {}
  table.insert(elements, {label = 'Grabar', value = 'start_recording'})
  table.insert(elements, {label = 'Guardar grabación', value = 'save_recording'})
  table.insert(elements, {label = 'Descartar grabación', value = 'discard_recording'})

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'client',
      {
          title    = 'Rockstar Editor',
          align    = 'bottom-right',
          elements = elements,
      },
      function(data, menu)
      if data.current.value == 'start_recording' then
        StartRecording(1)
      elseif data.current.value == 'save_recording' then
        if(IsRecording()) then
          StopRecordingAndSaveClip()
        end
      elseif data.current.value == 'discard_recording' then
        StopRecordingAndDiscardClip()
      else
      end
    end, function(data, menu)
        menu.close()
  end)
end

AddEventHandler('ng:rockstarEditor', function()
rockstarEditor()
end)

-- LICENCIAS --

Licencias = function()
  
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_personal_documents', {
      title = 'Documentación', 
      align = 'right',
      elements = {
          {label = 'Ver DNI', value = 'checkID'},
          {label = 'Enseñar DNI', value = 'showID'},
          {label = 'Ver Licencia de Conducir', value = 'checkDriver'},
          {label = 'Enseñar Licencia de Conducir', value = 'showDriver'},
          {label = 'Ver Licencia de Armas', value = 'checkFirearms'},
          {label = 'Enseñar Licencia de Armas', value = 'showFirearms'},
      }
  
  }, function(data, menu)
      if data.current.value == 'checkID' then
          TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId())) 
      elseif data.current.value == 'showID' then
          local player, distance = ESX.Game.GetClosestPlayer()

          if distance ~= -1 and distance <= 3.0 then
              TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
          else
              ESX.ShowNotification('No hay nadie cerca')
          end

      elseif data.current.value == 'checkDriver' then
          TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
      elseif data.current.value == 'showDriver' then
          local player, distance = ESX.Game.GetClosestPlayer()

          if distance ~= -1 and distance <= 3.0 then
              TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
          else
              ESX.ShowNotification('No hay nadie cerca')
          end
      elseif data.current.value == 'checkFirearms' then
          TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
      elseif data.current.value == 'showFirearms' then
          local player, distance = ESX.Game.GetClosestPlayer()

          if distance ~= -1 and distance <= 3.0 then
              TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
          else
              ESX.ShowNotification('No hay nadie cerca')
          end
      end
  end, function(data, menu)
      menu.close()
  end)
end

DrawGenericText = function(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(6)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.14, 0.97)
end

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

-- FIN FUNCIONES --

-- INICIOS REGISTRO --

RegisterNetEvent('ng:nocliped')
AddEventHandler('ng:nocliped',function()
	ng_noclip = not ng_noclip
    local ped = GetPlayerPed(-1)

    if ng_noclip then
    	SetEntityInvincible(ped, true)
    	SetEntityVisible(ped, false, false)
    else
    	SetEntityInvincible(ped, false)
    	SetEntityVisible(ped, true, false)
    end

    if ng_noclip == true then 
        ESX.ShowNotification('Has activado el ~g~noclip.')
    else
        ESX.ShowNotification('Has desactivado el ~r~noclip.')
    end
end)

RegisterNetEvent('ng:invisible')
AddEventHandler('ng:invisible', function()
	ng_vanish = not ng_vanish
    local ped = GetPlayerPed(-1)
    SetEntityVisible(ped, not ng_vanish, false)
    if ng_vanish == true then 
        ESX.ShowNotification('Has activado el ~g~invisible.')
    else
        ESX.ShowNotification('Has desactivado el ~r~invisible.')
    end
end)

RegisterNetEvent('ng:godmodePlayer')
AddEventHandler('ng:godmodePlayer', function()
	ng_godmode = not ng_godmode
	local playerPed = PlayerPedId()
	if ng_godmode then
		SetEntityInvincible(playerPed, true)
		ESX.ShowNotification('Has activado el ~g~ Godmode.')
	else
		SetEntityInvincible(playerPed, false)
		ESX.ShowNotification('Has desactivado el ~r~Godmode.')
	end
end)

RegisterNetEvent("ng:clearchat")
AddEventHandler("ng:clearchat", function()
    TriggerEvent('chat:clear', -1)
  ESX.ShowNotification('~g~Has limpiado todo el chat.')
end)

RegisterNetEvent('ng:repairVehicle')
AddEventHandler('ng:repairVehicle', function()
    local ply = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(ply)
    if IsPedInAnyVehicle(ply) then 
        SetVehicleFixed(plyVeh)
        SetVehicleDeformationFixed(plyVeh)
        SetVehicleUndriveable(plyVeh, false)
        SetVehicleEngineOn(plyVeh, true, true)
        ESX.ShowNotification('~g~Has reparado el coche')
    else
        ESX.ShowNotification('~r~Debes estar en un vehículo para poder repararlo')
    end
end)

RegisterNetEvent('ng:coords')
AddEventHandler('ng:coords', function()
    coordsVisible = not coordsVisible
	  while true do
		local sleepThread = 250
		
		if coordsVisible then
			sleepThread = 5

			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)

			DrawGenericText(("~r~X~w~: %s ~r~Y~w~: %s ~r~Z~w~: %s ~r~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		end

		Citizen.Wait(sleepThread)
	end
end)

-- FIN REGISTROS --

-- INICIO EXTRAS --

getPosition = function()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  	return x,y,z
end

getCamDirection = function()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()
  
	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)
  
	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
	  x = x/len
	  y = y/len
	  z = z/len
	end
  
	return x,y,z
end

RegisterCommand('rvoz', function()
  NetworkClearVoiceChannel()
  NetworkSessionVoiceLeave()
  Wait(50)
  NetworkSetVoiceActive(false)
  MumbleClearVoiceTarget(2)
  Wait(1000)
  MumbleSetVoiceTarget(2)
  NetworkSetVoiceActive(true)
  ESX.ShowNotification('~g~Chat de voz reiniciado.')
end)

-- FIN EXTRAS --