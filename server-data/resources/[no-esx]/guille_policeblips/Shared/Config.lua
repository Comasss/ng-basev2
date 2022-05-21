Cfg = {} or Cfg

Cfg.Colors = { -- https://docs.fivem.net/docs/game-references/blips/ Bottom of the page
    {label = "MANDO-00", color = 67},
    {label = "CENTRAL", color = 72},
    {label = "ADAM", color = 2},
    {label = "UNION", color = 29},
    {label = "MERY", color = 8},
    {label = "488", color = 47},
    {label = "254-V", color = 49},
    {label = "AIRE", color = 24},
    {label = "LICON", color = 40},
    {label = "TAC", color = 13}
}

Cfg.AllowedJobs = { -- Jobs allowed to use references
    [1] = "police",
}

Cfg.JobsIcons = { -- Icons in the beginning of https://docs.fivem.net/docs/game-references/blips/ (You can leave this white)
    ["police"] = 1
}

Cfg.RefreshRate = 2000 -- Refresh rate from server to client

Cfg.OpenCommand = "ref" -- Command to open the reference menu

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