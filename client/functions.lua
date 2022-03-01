LoadAnimDict = function(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

hasBoomBox = function(radio)
    local equipRadio = true
    CreateThread(function()
        while equipRadio do
            Wait(0)
            if IsControlJustReleased(0, 38) then
                equipRadio = false
				DetachEntity(radio)
				PlaceObjectOnGroundProperly(radio)
            end
        end
    end)
end

local isBusy = false

InteractBoombox = function(radio, radioCoords)
    if not isBusy then
        isBusy = true
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
            local elements = {}
            table.insert(elements, {
                id = 1,
                header = 'Play Music',
                txt = 'Play Music On Speaker',
                params = {
                    event = 'wasabi_boombox:playMenu',
                    arg1 = {
                        type = 'play',
                        id = radio
                    }
                }
            })
            TriggerEvent('nh-context:sendMenu', elements)
        else
            local elements = {}
            table.insert(elements, {
                id = 1,
                header = 'Change Music',
                txt = 'Change Music On Speaker',
                params = {
                    event = 'wasabi_boombox:playMenu',
                    arg1 = {
                        type = 'play',
                        id = radio
                    }
                }
            })
            table.insert(elements, {
                id = 2,
                header = 'Stop Music',
                txt = 'Stop Music On Speaker',
                params = {
                    event = 'wasabi_boombox:playMenu',
                    arg1 = {
                        type = 'stop',
                        id = radio
                    }
                }
            })
            table.insert(elements, {
                id = 3,
                header = 'Adjust Volume',
                txt = 'Change Volume On Speaker',
                params = {
                    event = 'wasabi_boombox:playMenu',
                    arg1 = {
                        type = 'volume',
                        id = radio
                    }
                }
            })
            table.insert(elements, {
                id = 4,
                header = 'Change Distance',
                txt = 'Change Distance On Speaker',
                params = {
                    event = 'wasabi_boombox:playMenu',
                    arg1 = {
                        type = 'distance',
                        id = radio
                    }
                }
            })    
            TriggerEvent('nh-context:sendMenu', elements)
        end
        isBusy = false
    end
end