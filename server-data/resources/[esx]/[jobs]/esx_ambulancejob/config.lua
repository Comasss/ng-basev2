Config                            = {}

Config.DrawDistance               = 10.0

Config.Marker                     = {type = 1, x = 1.3, y = 1.3, z = 0.2, r = 255, g = 0, b = 0, a = 195, rotate = false}

Config.ReviveReward               = 500  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

Config.EarlyRespawnTimer          = 60000 * 7  -- time til respawn is available
Config.BleedoutTimer              = 60000 * 10 -- time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = {coords = vector3(297.3490, -584.0962, 43.1325), heading = 74.1378}

Config.SpawnPointsVehicles = {coords = vector3(295.98, -607.06, 42.22), heading = 71.25, radius = 10.0}
Config.SpawnPointsHelicopters = {coords = vector3(351.19, -588.39, 73.06), heading = 251.33, radius = 10.0}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(308.37,-591.22,43.29),
			sprite = 61,
			scale  = 0.8,
			color  = 1
		},

		AmbulanceActions = {
			vector3(301.5590, -599.2518, 42.28)
		},

		Pharmacies = {
			vector3(309.4885, -568.5468, 42.28)
		},

		BossActions = {
			vector3(334.92, -593.3, 42.32)
		},

		Vehicles = {
			{
				Spawner = vector3(294.89, -601.05, 42.4),
				Delete = vector3(295.97, -607.05, 42.30),
				Marker = { type = 1, x = 1.2, y = 1.2, z = 0.2, r = 255, g = 0, b = 0, a = 130, rotate = true }				
			}
		},

		Helicopters = {
			{
				Spawner = vector3(338.52, -587.63, 73.17),
				Delete = vector3(351.19, -588.39, 73.06),
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.2, r = 255, g = 0, b = 0, a = 130, rotate = true }
			}
		},

		FastTravels = {
			{
				From = vector3(329.9, -601.02, 42.30),
                To = { coords = vector3(338.67, -584.69, 74.19), heading = 249.99 },
                Marker = { type = 1, x = 1.2, y = 1.2, z = 0.2, r = 255, g = 0, b = 0, a = 130, rotate = false }
			},

			{
				From = vector3(339.2, -583.31, 73.19),
                To = { coords = vector3(331.94, -595.47, 42.30), heading = 75.54 },
                Marker = { type = 1, x = 1.2, y = 1.2, z = 0.2, r = 255, g = 0, b = 0, a = 130, rotate = false }
			}
		},
	}
}

Config.AuthorizedVehicles = {
	{ model = 'EMSA', label = 'Ambulancia', price = 1},
	{ model = 'EMSC', label = 'Coche EMS', price = 1},
	{ model = 'EMST', label = 'Coche 4x4', price = 1},
	{ model = 'EMSF', label = 'Ambulancia Larga', price = 1},
	{ model = 'EMSV', label = 'Ambulancia Experimentada', price = 1},
	{ model = 'firetruk', label = 'Camión de Bomberos', price = 1}

}

Config.AuthorizedHelicopters = {
	{ model = 'emsair', label = 'Helicoptero L.S.M.D', price = 10000 }

}
