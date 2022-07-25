-----------------For support, scripts, and more----------------
----------------- https://discord.gg/XJFNyMy3Bv ---------------
---------------------------------------------------------------
fx_version "cerulean"
game "gta5"

description 'Wasabi ESX Boombox'
version '2.0.1'

lua54 'yes'

client_scripts {
    'client/**.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/**.lua'
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

dependencies {
  'es_extended',
  'xsound',
  'ox_lib'
}
