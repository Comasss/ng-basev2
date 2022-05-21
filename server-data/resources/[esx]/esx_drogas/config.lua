Config = {}

Config.Locale = 'es'

Config.EnableMapBlips = false -- Habilita los blips del mapa.
Config.RequireCopsOnline = true --Si esta en <<true>> tendrá que haber policia para cosechar/plantar/recoger.
Config.CopsCheckRefreshTime = 30 -- Tiempo (en minutos) para contar los policias conectados (previene que nada mas haya el poli puedan farmear como locos).
Config.GiveBlack = true

--Clubs/Bandas/Mafias que pueden recolectar x cosa
Config.ClubsChemicals = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta'}
Config.ClubsCoke = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta'}
Config.ClubsHeroin = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta'}
Config.ClubsHydrochloricacid = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta'}
Config.ClubsLSD = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta'}
Config.ClubsMeth = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta' }
Config.ClubsSodiumhydroxide = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta' }
Config.ClubsSulfuricacid = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta' }
Config.ClubsWeed = { 'ballas', 'cartelmedellin', 'merryweather', 'families', 'industriastrevor', 'bloods', 'marabunta'}


-- El tiempo que lleva procesar x cosa
Config.Delays = {
	WeedProcessing = 1000 * 10,
	MethProcessing = 1000 * 10,
	CokeProcessing = 1000 * 10,
	lsdProcessing = 1000 * 10,
	HeroinProcessing = 1000 * 10,
	thionylchlorideProcessing = 1000 * 10,
}

Config.DrugDealerItems = {
	heroin = 350,
	marijuana = 50,
	coke = 200,
	lsd = 600,
}


-- Elementos incluidos en el menú de conversión de productos químicos
Config.ChemicalsConvertionItems = {
	hydrochloric_acid = 0,
	sodium_hydroxide = 0,
	sulfuric_acid = 0,
	lsa = 0,
}


-- La cantidad de policías que necesitan estar en línea para recolectar/procesar.
-- Solo es necesario cuando RequireCopsOnline se establece en <<true>>.
Config.Cops = {
	Heroin = 1,
	Weed = 1,
	Coke = 1,
	Meth = 1,
	LSD = 1,
	Chemicals = 1,
	ChemicalsMenu = 1
}

-- Zonas
Config.CircleZones = {
	--Marihuana (marijuana) -- 
	WeedField = {coords = vector3(1059.53, 4243.05, 36.1)}, -- Zona de cosecha de marihuana
	WeedProcessing = {coords = vector3(2329.04, 2571.43, 46.71)}, -- Zona de procesado de marihuana
	
	-- Meta
	MethProcessing = {coords = vector3(660.85, 1282.36, 360.3)}, -- Zona de procesado de meta
	HydrochloricAcidFarm = {coords = vector3(2724.12, 1583.03, 24.5)}, -- Zona de cosecha ácido clorhídrico
	SulfuricAcidFarm = {coords = vector3(-600.98, 5346.27, 70.47)}, -- Zona de cosecha ácido sulfúrico
	SodiumHydroxideFarm = {coords = vector3(-2165.3606, 5180.3887, 15.2074)}, -- Zona de cosecha hidroxido de sodio

	-- Quimicos --
	ChemicalsField = {coords = vector3(817.46, -3192.84, 5.9)}, -- Zona de cosecha de quimicos
	ChemicalsConvertionMenu = {coords = vector3(2806.67, 1610.97, 24.53)}, -- Menu de conversión de químicos
	
	-- Cocaina --
	CokeField = {coords = vector3(2750.8, -833.6, 17.4)}, -- Zona de cosecha de coca
	CokeProcessing = {coords = vector3(1450, 1134.84, 114.33)}, -- Zona de procesado de coca

	-- LSD --
	lsdProcessing = {coords = vector3(-581.8, -1611.3, 27)}, -- Zona de cosecha de lsd
	thionylchlorideProcessing = {coords = vector3(1391.7, 3606.3, 38.9)}, --Zona de procesado coca (Cloruro de tionilo)
	

	--- VENTA DE DROGAS MENOS META ---
	DrugDealer = {coords = vector3(1218.19, 2397.32, 66.08)},

	-- Heroina -- 
	HeroinField = {coords = vector3(1951.9, 4858.9, 48.7)}, -- Zona de cosecha de heroína
	HeroinProcessing = {coords = vector3(1417.46, 6344.01, 24.0)}, -- Zona de procesado de heroína
}