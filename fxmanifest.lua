fx_version 'cerulean'
game 'gta5'
lua54 'on'

author 'IamNath'
name 'I_Locations'

ui_page 'ui/index.html' 

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

files {
    'ui/index.html',
    'ui/styles.css',
    'ui/js/*',
    'ui/img/*',
    'ui/fonts/*'
}

client_scripts {
    'client/client.lua',
    'shared/config.lua'
}

server_scripts {
    'shared/config.lua',
    'server/server.lua'
}
