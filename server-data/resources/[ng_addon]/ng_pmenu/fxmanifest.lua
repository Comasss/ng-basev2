fx_version 'adamant'

game 'gta5'

client_scripts {
	'client/client.lua'
}

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}