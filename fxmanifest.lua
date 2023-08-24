-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

fx_version "cerulean"
game "gta5"

description 'Wasabi ESX/QB Boombox'
version '2.1.5'

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
  'xsound',
  'ox_lib'
}

files {
  'locales/*.json'
}