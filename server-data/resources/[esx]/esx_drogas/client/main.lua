ESX = nil
local menuOpen = false
local wasOpen = false
local PlayerClub, PlayerRankNum = nil, 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_yisus_masterclubs:getPlayerClub', function(playerdata)
		PlayerClub = playerdata.club
		PlayerRankNum = playerdata.club_rank
	end)
end)

--Gang Load
RegisterNetEvent('esx_yisus_masterclubs:clubAdded')
AddEventHandler('esx_yisus_masterclubs:clubAdded', function(club)
	ESX.TriggerServerCallback('esx_yisus_masterclubs:getPlayerClub', function(playerdata)
		PlayerClub = playerdata.club
		PlayerRankNum = playerdata.club_rank
	end)
end)

--Gang Load
RegisterNetEvent('esx_yisus_masterclubs:clubRemoved')
AddEventHandler('esx_yisus_masterclubs:clubRemoved', function()
	PlayerClub, PlayerRankNum = nil, 0
end)

function isAllowedDrug(plant)
	--print("plant: "..plant)
	--print("playerclub: "..PlayerClub)
	if plant == 'chemicals' then
		return true
	elseif plant == 'coke' then
		return true
	elseif plant == 'heoin' then
		return true
	elseif plant == 'hydrochloricacid' then
		return true
	elseif plant == 'lsd' then
		return true
	elseif plant == 'meth' then
		return true
	elseif plant == 'sodiumhydroxide' then
		return true
	elseif plant == 'sulfuricacid' then
		return true
	elseif plant == 'weed' then
		return true
	end

	return false
end

local coordonate = {
	-- HEROINA -- 
    {1417.19, 6343.87, 23.0,"", 280.0, 0xC99F21C4,"a_m_y_business_01"},
	-- CANNABIS -- 
    {2329.04, 2571.43, 45.68,"", 331.97, 0xF6157D8F,"g_m_m_chemwork_01"},
	-- COCA --
    {1449.53, 1135.01, 113.33,"", 271.56, 0x48FF4CA9,"csb_vagspeak"},
    -- QUIMICOS --   
	{2806.29, 1610.98, 23.53,"", 269.8, 0x48FF4CA9,"csb_vagspeak"},
	-- META --
	{660.78, 1282.59, 359.3,"", 263.03, 0x48FF4CA9,"a_m_y_bevhills_02"},
	-- NARCO --
	{1218.17, 2398.24, 65.1,"", 190.58, 0x48FF4CA9,"a_m_y_bevhills_02"},
}

Citizen.CreateThread(function()

    for _,v in pairs(coordonate) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1000)
      end
      ped = CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, false)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"anim@amb@nightclub@peds@","rcmme_amanda1_stand_loop_cop",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)	
    end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local _msec = 250
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer.coords, true) < 1 then
			if not menuOpen then
				_msec = 0
				ESX.ShowFloatingHelpNotification("Pulsa ~r~[E]~s~ para hablar con el narco", vector3(coords.x, coords.y, coords.z + 1))

				if IsControlJustReleased(0, 38) then
					wasOpen = true
					OpenDrugShop()
				end
			else
			end
		end
		Citizen.Wait(_msec)
	end
end)

function OpenDrugShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.DrugDealerItems[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
				name = v.name,
				price = price,

				type = 'slider',
				value = v.count,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = _U('dealer_title'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('ariuky:sellDrug', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)