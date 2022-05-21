AddEventHandler("LoadingScreen", function(varName, varValue)

	SendNUIMessage({ name = varName, value = varValue })

end)