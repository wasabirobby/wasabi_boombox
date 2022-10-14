-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

hasBoomBox = function(radio)
    local equipRadio = true
    CreateThread(function()
        if Config.InstructionNotification then
            lib.notify({
                title = _U('instructions'),
                description = _U('drop_boombox'),
                type = 'success'
            })
        end
        while equipRadio do
            Wait(0)
            if IsControlJustReleased(0, 38) then
                equipRadio = false
				DetachEntity(radio)
				PlaceObjectOnGroundProperly(radio)
                FreezeEntityPosition(radio, true)
                boomboxPlaced(radio)
            end
        end
    end)
end

if Framework == "ESX" then
    boomboxPlaced = function(obj)
        local coords = GetEntityCoords(obj)
        local heading = GetEntityHeading(obj)
        local targetPlaced = false
        CreateThread(function()
            while true do
                if DoesEntityExist(obj) and not targetPlaced then
                    exports.qtarget:AddBoxZone("boomboxzone", coords, 1, 1, {
                        name="boomboxzone",
                        heading=heading,
                        debugPoly=false,
                        minZ=coords.z-0.9,
                        maxZ=coords.z+0.9
                    }, {
                        options = {
                            {
                                event = 'wasabi_boombox:interact',
                                icon = 'fas fa-hand-paper',
                                label = _U('interact'),
                            },
                            {
                                event = 'wasabi_boombox:pickup',
                                icon = 'fas fa-volume-up',
                                label = _U('pickup')
                            }

                        },
                        job = 'all',
                        distance = 1.5
                    })
                    targetPlaced = true
                elseif not DoesEntityExist(obj) then
                    exports.qtarget:RemoveZone('boomboxzone')
                    targetPlaced = false
                    break
                end
                Wait(1000)
            end
        end)
    end
elseif Framework == "QB" then
    boomboxPlaced = function(obj)
        local coords = GetEntityCoords(obj)
        local heading = GetEntityHeading(obj)
        local targetPlaced = false
        CreateThread(function()
            while true do
                if DoesEntityExist(obj) and not targetPlaced then
                    exports['qb-target']:AddBoxZone("boomboxzone", coords, 1, 1, {
                        name="boomboxzone",
                        heading=heading,
                        debugPoly=false,
                        minZ=coords.z-0.9,
                        maxZ=coords.z+0.9
                    }, {
                        options = {
                            {
                                event = 'wasabi_boombox:interact',
                                icon = 'fas fa-hand-paper',
                                label = _U('interact'),
                            },
                            {
                                event = 'wasabi_boombox:pickup',
                                icon = 'fas fa-volume-up',
                                label = _U('pickup')
                            }

                        },
                        job = 'all',
                        distance = 1.5
                    })
                    targetPlaced = true
                elseif not DoesEntityExist(obj) then
                    exports['qb-target']:RemoveZone('boomboxzone')
                    targetPlaced = false
                    break
                end
                Wait(1000)
            end
        end)
    end
end

interactBoombox = function(radio, radioCoords)
    if not activeRadios[radio] then
        activeRadios[radio] = {
            pos = radioCoords,
            data = {
                playing = false
            }
        }
    else
        activeRadios[radio].pos = radioCoords
    end
    TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
    if not activeRadios[radio].data.playing then
        lib.registerContext({
            id = 'boomboxFirst',
            title = _U('boombox_title'),
            options = {
                {
                    title = _U('play_music'),
                    description = _U('play_music_on_speaker'),
                    arrow = true,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'play', id = radio}
                },
                {
                    title = _U('saved_songs'),
                    description = _U('previously_saved_songs'),
                    arrow = true,
                    event = 'wasabi_boombox:savedSongs',
                    args = {id = radio}
                }
            }
        })
        lib.showContext('boomboxFirst')
    else
        lib.registerContext({
            id = 'boomboxSecond',
            title = _U('boombox_title'),
            options = {
                {
                    title = _U('change_music'),
                    description = _U('change_music_on_speaker'),
                    arrow = true,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'play', id = radio}
                },
                {
                    title = _U('saved_songs'),
                    description = _U('previously_saved_songs'),
                    arrow = true,
                    event = 'wasabi_boombox:savedSongs',
                    args = {id = radio}
                },
                {
                    title = _U('stop_music'),
                    description = _U('stop_music_on_speaker'),
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'stop', id = radio}
                },
                {
                    title = _U('adjust_volume'),
                    description = _U('change_volume_on_speaker'),
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'volume', id = radio}
                },
                {
                    title = _U('change_distance'),
                    description = _U('change_distance_on_speaker'),
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'distance', id = radio}
                }
            }
        })
        lib.showContext('boomboxSecond')
    end
end

selectSavedSong = function(data)
    lib.registerContext({
        id = 'selectSavedSong',
        title = _U('manage_song'),
        options = {
            {
                title = _U('play_song'),
                description = _U('play_this_song'),
                arrow = false,
                event = 'wasabi_boombox:playSavedSong',
                args = data
            },
            {
                title = _U('delete_song'),
                description = _U('delete_this_song'),
                arrow = true,
                event = 'wasabi_boombox:deleteSong',
                args = data
            }
        }
    })
    lib.showContext('selectSavedSong')
end

if Framework == "ESX" then
    savedSongsMenu = function(radio)
        ESX.TriggerServerCallback('wasabi_boombox:getSavedSongs', function(cb)
            local radio = radio.id
            local Options = {
                {
                    title = _U('save_a_song'),
                    description = _U('save_a_song_to_play_later'),
                    arrow = true,
                    event = 'wasabi_boombox:saveSong',
                    args = {id = radio}
                }
            }
            if cb then
                for i=1, #cb do
                    print(radio)
                    table.insert(Options, {
                        title = cb[i].label,
                        description = '',
                        arrow = true,
                        event = 'wasabi_boombox:selectSavedSong',
                        args = {id = radio, link = cb[i].link, label = cb[i].label}
                    })
                end
            end
            lib.registerContext({
                id = 'boomboxSaved',
                title = _U('boombox_title'),
                options = Options
            })
            lib.showContext('boomboxSaved')
        end)
    end
elseif Framework == "QB" then
    savedSongsMenu = function(radio)
        QBCore.Functions.TriggerCallback('wasabi_boombox:getSavedSongs', function(cb)
            local radio = radio.id
            local Options = {
                {
                    title = _U('save_a_song'),
                    description = _U('save_a_song_to_play_later'),
                    arrow = true,
                    event = 'wasabi_boombox:saveSong',
                    args = {id = radio}
                }
            }
            if cb then
                for i=1, #cb do
                    print(radio)
                    table.insert(Options, {
                        title = cb[i].label,
                        description = '',
                        arrow = true,
                        event = 'wasabi_boombox:selectSavedSong',
                        args = {id = radio, link = cb[i].link, label = cb[i].label}
                    })
                end
            end
            lib.registerContext({
                id = 'boomboxSaved',
                title = _U('boombox_title'),
                options = Options
            })
            lib.showContext('boomboxSaved')
        end)
    end
end
