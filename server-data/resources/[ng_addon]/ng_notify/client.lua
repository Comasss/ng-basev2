Config = Config or {}
Config.EnableDemoCommands = true --Delete this if you don't want to delete the demo commands for the notifications


function Alert(title, message, time, type)
	SendNUIMessage({
		action = 'open',
		title = Conversor(title),
		type = type,
		message = Conversor(message),
		time = time,
	})
end

RegisterNetEvent('ng_notify:Alert')
AddEventHandler('ng_notify:Alert', function(title, message, time, type)
	Alert(title, message, time, type)
end)
function Conversor(text)
    text = text:gsub("~r~", "<span class='red'>") 
    text = text:gsub("~b~", "<span class='blue'>")
    text = text:gsub("~g~", "<span class='green'>")
    text = text:gsub("~y~", "<span class='yellow'>")
    text = text:gsub("~p~", "<span class='purple'>")
    text = text:gsub("~c~", "<span class='grey'>")
    text = text:gsub("~m~", "<span class='darkgrey'>")
    text = text:gsub("~u~", "<span class='black'>")
    text = text:gsub("~o~", "<span class='gold'>")
    text = text:gsub("~s~", "</span>")
    text = text:gsub("~w~", "</span>")
    text = text:gsub("~b~", "<b>")
    text = text:gsub("~n~", "<br>")
    text = "<span>" .. text .. "</span>"

    return text
end

---EXAMPLE NOTIFY (DELETE THIS BELOW) ]---
if (Config.EnableDemoCommands) then
RegisterCommand('1', function()
	exports['ng_notify']:Alert("SUCCESS", "<span style='color:#c7c7c7'>You have widthdrawn <span style='color:#069a19'><b>100$</b></span>!", 5000, 'success')
end)

RegisterCommand('2', function()
	exports['ng_notify']:Alert("INFORMATION", "<span style='color:#c7c7c7'>Server restart in <span style='color:#fff'>5 minutes</span>!", 5000, 'info')
end)

RegisterCommand('3', function()
	exports['ng_notify']:Alert("ERROR", "<span style='color:#c7c7c7'>You have no <span style='color:#ff0000'>permissions</span>!", 5000, 'error')
end)

RegisterCommand('4', function()
	exports['ng_notify']:Alert("NEW SMS", "<span style='color:#ffc107'>695-2713: </span><span style='color:#c7c7c7'> How are you?", 5000, 'warning')
end)

RegisterCommand('5', function()
	exports['ng_notify']:Alert("TWITTER", "<span style='color:#01a2dc'>@USER69: </span><span style='color:#c7c7c7'> Hello everyone!", 5000, 'sms')
end)

RegisterCommand('6', function()
	exports['ng_notify']:Alert("SAVED", "<span style='color:#c7c7c7'>Clothes saved successfully!", 5000, 'long')
end)



RegisterCommand('allnoty', function()
	exports['ng_notify']:Alert("SUCCESS", "<span style='color:#c7c7c7'>You have widthdrawn <span style='color:#069a19'><b>100$</b></span>!", 5000, 'success')
	exports['ng_notify']:Alert("INFORMATION", "<span style='color:#c7c7c7'>Server restart in <span style='color:#fff'>5 minutes</span>!", 5000, 'info')
	exports['ng_notify']:Alert("ERROR", "<span style='color:#c7c7c7'>You have no <span style='color:#ff0000'>permissions</span>!", 5000, 'error')
	exports['ng_notify']:Alert("NEW SMS", "<span style='color:#ffc107'>695-2713: </span><span style='color:#c7c7c7'> How are you?", 5000, 'warning')
	exports['ng_notify']:Alert("TWITTER", "<span style='color:#01a2dc'>@USER69: </span><span style='color:#c7c7c7'> Hello everyone!", 5000, 'sms')
	exports['ng_notify']:Alert("SAVED", "<span style='color:#c7c7c7'>Clothes saved successfully!", 5000, 'long')
end)
end