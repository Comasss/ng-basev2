Config                            = {}
Cfg = {} or Cfg

Config.DrawDistance               = 3.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 0, g = 0, b = 255 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'fr'

Cfg.Strings = {
    [1] = "Se ha habilitado la referencia",
    [2] = "Se ha deshabilitado la referencia",
    [3] = "Habilitar todas las referencias",
    [4] = 'Las referencias han sido habilitadas',
    [5] = 'Las referencias han sido deshabilitadas',
    [6] = 'Tu trabajo no tiene referencias',
    [7] = "Sistema de referencias",
    [8] = "Menu REf",
    [9] = "Ver/Ocultar Referencias",
    [10] = "On/Off Referencias",
    [11] = "Asignaciones",
    [12] = "Asignaciones",
}

Cfg.Colors = { -- https://docs.fivem.net/docs/game-references/blips/ Bottom of the page
    {label = "MANDO-00 LSPD", color = 67},
    {label = "CENTRAL LSPD", color = 72},
    {label = "ADAM LSPD", color = 2},
    {label = "UNION LSPD", color = 29},
    {label = "MERY LSPD", color = 8},
    {label = "488 LSPD", color = 47},
    {label = "254-V LSPD", color = 49},
    {label = "AIRE LSPD", color = 24},
    {label = "LICON LSPD", color = 40},
    {label = "TAC LSPD", color = 13},
	{label = "----------------------", color = 13},
	{label = "MANDO-00 BCSD", color = 67},
    {label = "CENTRAL BCSD", color = 72},
    {label = "ADAM BCSD", color = 2},
    {label = "UNION BCSD", color = 29},
    {label = "MERY BCSD", color = 8},
    {label = "488 BCSD", color = 47},
    {label = "254-V BCSD", color = 49},
    {label = "AIRE BCSD", color = 24},
    {label = "LICON BCSD", color = 40},
    {label = "TAC BCSD", color = 13}
}


Config.SpawnPointsHelicopters = {
    { x = 449.85, y = -981.1, z = 42.8, heading = 90.09, radius = 5.0},
}

Config.PoliceStations = {

	LSPD = {
		Blip = {
			Pos     = vector3(428.2724, -982.161, 30.710),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.8,
			Colour  = 29,
		},

		Cloakrooms = {
			vector3(462.6498, -999.122, 29.70)
		},

		Armories = {
			vector3(482.7109, -996.348, 29.70)
		},

		Vehicles = {
			{
				Spawner    =  vector3(458.94, -992.62, 24.7),
				SpawnPoint = vector3(450.8, -975.65, 25.32),
				Heading    = 90.01,
				DeletePoint = vector3(436.39, -975.84, 24.81)
			}
		},

		Helicopters = {
			{
				Spawner = vector3(462.35, -981.24, 42.69),
				DeletePoint = vector3(449.85, -981.1, 42.8)
			}
		},

		BossActions = {
			vector3(463.0627, -985.2068, 29.7281)
		}

	}

}

Config.Shops = {
	items = {
		{label = 'Sandwich (20$)', name = 'hamburger', price = 20},
		{label = 'Agua (10$)', name = 'water', price = 10},
		{label = 'Coca Cola (15$)', name = 'cocacola', price = 15},
	}
}

Config.AuthorizedWeapons = {
	recruit = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = 1 },
		{ weapon = 'WEAPON_STUNGUN',       price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = 1 },
		{ weapon = 'WEAPON_MACHINEPISTOL',     price = 5 }
	},

	officer = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = 1 },
		{ weapon = 'WEAPON_STUNGUN',       price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = 1 },
		{ weapon = 'WEAPON_MACHINEPISTOL',     price = 5 }
	},

	sergeant = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = 1 },
		{ weapon = 'WEAPON_STUNGUN',       price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = 1 },
		{ weapon = 'WEAPON_MACHINEPISTOL',     price = 5 },
		{ weapon = 'WEAPON_SMG',     price = 10 }
	},

	intendent = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = 1 },
		{ weapon = 'WEAPON_STUNGUN',       price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = 1 },
		{ weapon = 'WEAPON_MACHINEPISTOL',     price = 5 },
		{ weapon = 'WEAPON_SMG',     price = 10 }
	},

	lieutenant = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = 1 },
		{ weapon = 'WEAPON_STUNGUN',       price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = 1 },
		{ weapon = 'WEAPON_MACHINEPISTOL',     price = 5 },
		{ weapon = 'WEAPON_SMG',     price = 10 }
	},

	chef = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = 1 },
		{ weapon = 'WEAPON_STUNGUN',       price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = 1 },
		{ weapon = 'WEAPON_MACHINEPISTOL',     price = 5 },
		{ weapon = 'WEAPON_SMG',     price = 10 },
		{ weapon = 'WEAPON_SPECIALCARBINE', price = 1000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 500 }
	},

	boss = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = 1 },
		{ weapon = 'WEAPON_STUNGUN',       price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = 1 },
		{ weapon = 'WEAPON_MACHINEPISTOL',     price = 5 },
		{ weapon = 'WEAPON_SMG',     price = 10 },
		{ weapon = 'WEAPON_SPECIALCARBINE', price = 1000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 500 },
		{ weapon = 'WEAPON_SMOKEGRENADE', price = 1500 }
	}
}

Config.AuthorizedVehicles = {
	Shared = {
		{
			model = 'code3bmw',
			label = 'Moto carretera'
		},
		{
			model = 'pd_dirtbike',
			label = 'Moto montaña'
		},
		{
			model = 'code3fpis',
			label = 'Ford'
		},
		{
			model = 'code318charg',
			label = 'Dogde Charge'
		},
		{
			model = 'code320exp',
			label = '4x4 Lspd'
		},
		{
			model = 'code398cvpi',
			label = 'Interceptor'
		},
		{
			model = 'HellcatRed',
			label = 'Secreta'
		},
		{
			model = 'pbike',
			label = 'Bici LSPD'
		}
	},

	recruit = {

	},

	officer = {

	},

	sergeant = {

	},

	lieutenant = {

	},

	boss = {
			model = 'riot',
			label = 'Police Riot'
	}
}

Config.AuthorizedHelicopters = {
	{ model = 'polmav', label = 'Helicoptero LSPD' }
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	officer_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	sergeant_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 1,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	intendent_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	lieutenant_wear = { -- currently the same as intendent_wear
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	chef_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 2,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 2,  ['bproof_2'] = 0
		}
	},
	gilet_wear = {
		male = {
			['bproof_1'] = 10,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 10,  ['bproof_2'] = 0
		}
	}

}