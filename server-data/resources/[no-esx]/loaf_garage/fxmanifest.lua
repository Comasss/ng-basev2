fx_version "adamant"
game "gta5"
description "ESX Garage"
author "Loaf Scripts"
version "0.1.0"

server_script "@mysql-async/lib/MySQL.lua"
shared_script "configuration/*.lua"
server_script "server/*.lua"
client_script "client/*.lua"

dependency "es_extended"