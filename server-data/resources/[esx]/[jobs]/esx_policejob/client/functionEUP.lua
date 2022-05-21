function EUPCategoryAllowed(masterJob, category)
	local category = Config.EUPOutFitsCategories[category]
	if (category ~= nil) then
		for _, k in pairs(category.jobs) do
			if (k == masterJob) then
				return true
			end
		end
		return false
	end
	return true
end
function OpenEUPClothesMenu(masterJob, sex)
	print(masterJob, sex)
	local elements = {}
	local categoryOutfits = {}

	for name, outfit in pairs(Config.EUPOutFits) do
		if not categoryOutfits[outfit.category] then
			categoryOutfits[outfit.category] = {}
		end
		if (sex == 0 and outfit.ped == "mp_m_freemode_01") or (sex == 1 and outfit.ped == "mp_f_freemode_01") then
			categoryOutfits[outfit.category][name] = outfit
		end
	end
	for _, categoryName in pairs(sortedKeys(categoryOutfits)) do
		if (EUPCategoryAllowed(masterJob, categoryName)) then
			table.insert(elements, {label = categoryName, value = categoryName})
		end
	end
	ESX.UI.Menu.Open(
		"default",
		GetCurrentResourceName(),
		"eupcategories",
		{
			title = "Ropa EUP",
			align    = 'right',
			elements = elements
		},
		function(data, menu)
			local elements2 = {}
			local selectedCategory = data.current.value
			for _, name in pairs(sortedKeys(categoryOutfits[selectedCategory])) do
				table.insert(elements2, {label = name, value = name})
			end
			ESX.UI.Menu.Open(
				"default",
				GetCurrentResourceName(),
				"eupclothes",
				{
					title = "Ropa EUP - " .. selectedCategory,
					align    = 'right',
					elements = elements2
				},
				function(dataOutfit, menuOutfit)
					local selectedEUPOutfit = dataOutfit.current.value
					setEUPOutfit(categoryOutfits[selectedCategory][selectedEUPOutfit])
					if (categoryOutfits[selectedCategory][selectedEUPOutfit].armor ~= nil) then
						SetPedArmour(PlayerPedId(), categoryOutfits[selectedCategory][selectedEUPOutfit].armor)
					else
						SetPedArmour(PlayerPedId(), 0)
					end
				end,
				function(dataOutfit, menuOutfit)
					menuOutfit.close()
				end
			)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function setEUPOutfit(outfit)
	local ped = PlayerPedId()
	local skinEup = TranslateEupToSkinChanger(outfit)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent('skinchanger:loadClothes', skin, skinEup)
	end)
end

function GetEUPComponentVariationForId(outfit, id, variation)
	for _, comp in ipairs(outfit.components) do
		if(comp[1] == id)then
			return comp[variation]
		end
	end
	return nil
end
function GetEUPPropIndexForId(outfit, id, variation)
	for _, comp in ipairs(outfit.props) do
		if(comp[1] == id)then
			return comp[variation]
		end
	end
	return nil
end
function TranslateEupToSkinChanger(outfit)
	
	local skin = {
		['mask_1'] = GetEUPComponentVariationForId(outfit, 1, 2) - 1,  
		['mask_2'] = GetEUPComponentVariationForId(outfit, 1, 3) - 1,  

		['arms'] = GetEUPComponentVariationForId(outfit, 3, 2) - 1,
		['arms_2'] = GetEUPComponentVariationForId(outfit, 3, 3) - 1,

		['pants_1'] = GetEUPComponentVariationForId(outfit, 4, 2) - 1, 
		['pants_2'] = GetEUPComponentVariationForId(outfit, 4, 3) - 1,

		['bags_1'] = GetEUPComponentVariationForId(outfit, 5, 2) - 1, 
		['bags_2'] = GetEUPComponentVariationForId(outfit, 5, 3) - 1,

		['shoes_1'] = GetEUPComponentVariationForId(outfit, 6, 2) - 1, 
		['shoes_2'] = GetEUPComponentVariationForId(outfit, 6, 3) - 1,

		['chain_1'] =  GetEUPComponentVariationForId(outfit, 7, 2) - 1,
		['chain_2'] = GetEUPComponentVariationForId(outfit, 7, 3) - 1,

		['tshirt_1'] = GetEUPComponentVariationForId(outfit, 8, 2) - 1,  
		['tshirt_2'] = GetEUPComponentVariationForId(outfit, 8, 3) - 1,  

		['bproof_1'] = GetEUPComponentVariationForId(outfit, 9, 2) - 1,  
		['bproof_2'] = GetEUPComponentVariationForId(outfit, 9, 3) - 1,  

		['decals_1'] = GetEUPComponentVariationForId(outfit, 10, 2) - 1, 
		['decals_2'] = GetEUPComponentVariationForId(outfit, 10, 3) - 1,

		['torso_1'] = GetEUPComponentVariationForId(outfit, 11, 2) - 1,  
		['torso_2'] = GetEUPComponentVariationForId(outfit, 11, 3) - 1,
		
		['helmet_1'] =  GetEUPPropIndexForId(outfit, 0, 2) - 1,  
		['helmet_2'] = GetEUPPropIndexForId(outfit, 0, 3) - 1, 
		['glasses_1'] =  GetEUPPropIndexForId(outfit, 1, 2) - 1,  
		['glasses_2'] = GetEUPPropIndexForId(outfit, 1, 3) - 1, 
		['ears_1'] =  GetEUPPropIndexForId(outfit, 2, 2) - 1,   
		['ears_2'] =  GetEUPPropIndexForId(outfit, 2, 3) - 1,  
	}
	return skin
end
function OpenCustomClothesMenu(masterJob)
	local elements = {}
	if (PlayerHaveMenuPermission(masterJob, "ConfigureClothes")) then
		table.insert(elements, {label = "Guardar ropa actual como nueva ropa custom", value = "newclothes_menuoption"})
		table.insert(elements, {label = "Eliminar ropa custom", value = "deleteclothes_menuoption"})
	end

	ESX.UI.Menu.CloseAll()
	if (#elements > 0) then
		ESX.UI.Menu.Open(
			"default",
			GetCurrentResourceName(),
			"customclothes",
			{
				title = "Ropa custom",
				align    = 'right',
				elements = elements
			},
			function(data, menu)
				if data.current.value == "newclothes_menuoption" then
					ESX.UI.Menu.Open(
						"dialog",
						GetCurrentResourceName(),
						"newclothes_menuoption_name",
						{
							title = "Nombre de la ropa"
						},
						function(data2, menu2)
							ESX.TriggerServerCallback(
								"esx_skin:getPlayerSkin",
								function(skin)
									ESX.TriggerServerCallback(
										"esx_mole_masterjob:addSocietyClothes",
										function()
											ESX.ShowNotification(_U('skin_saved'))
											menu2.close()
											OpenCustomClothesMenu(masterJob)
										end,
										masterJob,
										data2.value,
										skin
									)
								end
							)
						end
					)
				elseif data.current.value == "deleteclothes_menuoption" then
					OpenRemoveCustomClothesMenu(masterJob)
				end
			end,
			function(data, menu)
				menu.close()
			end
		)
	end
end


function sortedKeys(query, sortFunction)
    local keys, len = {}, 0
    for k, _ in pairs(query) do
        len = len + 1
        keys[len] = k
    end
    table.sort(keys, sortFunction)
    return keys
end