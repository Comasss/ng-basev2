Config = {
    IndependentGarage = false, -- if you store a vehicle in garage A, you can not take it out from garage B.
    ShowJobVehicles = true, -- show job vehicles such as police cars
    Damages = false, -- save & load damages when storing / retrieving a car?
    Use3DText = true, -- use 3d text?
    ImpoundPrice = 500, -- price to retrieve a vehicle from the impound
    AllowMultiple = false, -- allow people to take out vehicles from the impound if it is already out?
    DefaultJob = "", -- this is the job for cars which are not for jobs. For some servers, this should be just "" and for others "civ"
    DefaultType = "car", -- if type is not defined for the garage, it will chec kif the "type" in owned_vehicles is DefaultType

    Impounding = {
        AllowJobsToImpound = true, -- allow specific jobs to impound vehicles?
        Command = "impound", -- command for impounding, or false for disabled
        AllowedJobs = { -- the specific jobs allowed to impound vehicles, if AllowJobsToImpound is enabled
            "police",
        },
    },

    Interior = {
        Enabled = false, -- should you browse vehicles at the interior or at the garage location?
        Coords = vector4(228.8, -986.97, -99.96, 180.0) -- vector4(x, y, z, heading) location of the interior.
    },
    
    Garages = {
        --[[
            garage_name = coords = vector4(x, y, z, heading) -- garage location
        ]]
        square = {
            location = vector4(232.2, -792.48, 29.9, 160.0),
            vehicletype = "car",
        },
        airport2 = 
        {
            location = vector4(-1045.86, -2671.03, 13.21, 315.81),
            vehicletype = "car",
        },
        motel = {
            location = vector4(288.39, -339.62, 44.31, 160.0),
            vehicletype = "car",
        },
        sandy = {
            location = vector4(1703.93, 3764.55, 33.74, 317.62),
            vehicletype = "car",
        },
        public = {
            location = vector4(-212.82, 301.63, 96.33, 357.46),
            vehicletype = "car",
        },
        mirrorpark = {
            location = vector4(1028.12, -784.94, 57.27, 310.9),
            vehicletype = "car",
        },
        elburro = {
            location = vector4(1188.8, -1541.28, 39.4, 358.09),
            vehicletype = "car",
        },
        gasstation = {
            location = vector4(2587.02, 417.17, 107.8, 84.69),
            vehicletype = "car",
        },
        grapeseed = {
            location = vector4(1709.76, 4804.93, 41.8, 84.69),
            vehicletype = "car",
        },
        paleto = {
            location = vector4(127.48, 6608.51, 30.87, 230.0),
            vehicletype = "car",
        },
        tongva = {
            location = vector4(-1907.52, 2012.95, 140.6, 268.18),
            vehicletype = "car",
        },
        senora = {
            location = vector4(1124.25, 2648.08, 37.0, 359.04),
            vehicletype = "car",
        },
        observatory = {
            location = vector4(-417.46, 1215.35, 324.9, 231.49),
            vehicletype = "car",
        },
        publico3 = {
            location = vector4(-302.5, -742.64, 33.2, 155.08),
            vehicletype = "car",
        },
        paleto = {
            location = vector4(-263.81, 6065.28, 30.84, 120.69),
            vehicletype = "car",
        },
        sandymotel = {
            location = vector4(1124.02, 2647.07, 37.37, 0.73),
            vehicletype = "car",
        },
        magellanave = {
            location = vector4(-1190.51, -1503.7, 3.75, 306.11),
            vehicletype = "car",
        },
        boulevardperro = {
            location = vector4(-925.35, -170.77, 41.25, 26.35),
            vehicletype = "car",
        },
        hangar = {
            location = vector4(-1274.35, -3381.59, 13.30, 331.31),
            vehicletype = "airplane",
        },
        senora = {
            location = vector4(1731.49, 3314.03, 40.6, 190.96),
            vehicletype = "airplane",
        },
        grapeseed = {
            location = vector4(2134.33, 4782.14, 40.3, 24.74),
            vehicletype = "airplane",
        },
        chumash = {
            browse = vector3(-3424.05, 952.83, 7.8),
            spawn = vector4(-3425.4, 945.29, -0.22, 90.1),
            vehicletype = "boat"
        },
    },

    Impounds = {
        {
            Retrieve = vector3(483.73, -1312.26, 28.5), -- where you open the menu to retrieve the car
            Spawn = vector4(490.99, -1313.66, 28.83, 285.99), -- where the car spawns
            vehicletype = "car",
        },
        {
            Retrieve = vector3(1650.8, 3806.43, 37.9), -- where you open the menu to retrieve the car
            Spawn = vector4(1640.04, 3797.32, 33.83, 128.2), -- where the car spawns
            vehicletype = "car",
        },
        {
            Retrieve = vector3(-234.44, 6198.71, 31.3), -- where you open the menu to retrieve the car
            Spawn = vector4(-232.45, 6192.38, 30.49, 134.5), -- where the car spawns
            vehicletype = "car",
        },
        {
            Retrieve = vector3(-1467.7732, -504.4711, 32.05), -- where you open the menu to retrieve the car
            Spawn = vector4(-1475.1661, -501.3565, 32.4142, 300.5), -- where the car spawns
            vehicletype = "car",
        },
        {
            Retrieve = vector3(-1615.52, -3137.48, 13.3), -- where you open the menu to retrieve the plane
            Spawn = vector4(-1654.096, -3146.48, 13.57, 329.89), -- where the plane spawns
            vehicletype = "airplane",
        },
    }
}