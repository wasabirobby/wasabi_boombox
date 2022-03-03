ESX = nil
xSound = exports.xsound
activeRadios = {}

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local boomBox = {`prop_boombox_01`}

CreateThread(function()
    exports.qtarget:AddTargetModel(boomBox, {
        options = {
            {
                event = "wasabi_boombox:pickupRadio",
                icon = "fas fa-hand-paper",
                label = Language['pickup_radio'],
            },
            {
                event = "wasabi_boombox:interactRadio",
                icon = "fas fa-volume-up",
                label = Language['interact_radio'],
            },

        },
        job = "all",
        distance = 1.5
    })
end)

RegisterNetEvent('wasabi_boombox:useBoombox')
AddEventHandler('wasabi_boombox:useBoombox', function()
    local ped = PlayerPedId()
    local hash = `prop_boombox_01`
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,3.0,0.5))
    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(0) end
    local radio = CreateObjectNoOffset(hash, x, y, z, true, false)
    SetModelAsNoLongerNeeded(hash)
    local unarmed = `WEAPON_UNARMED`
    SetCurrentPedWeapon(ped, unarmed)
    AttachEntityToEntity(radio, ped, GetPedBoneIndex(ped, 57005), 0.32, 0, -0.05, 0.10, 270.0, 60.0, true, true, false, true, 1, true)
    hasBoomBox(radio)
end)

RegisterNetEvent('wasabi_boombox:interactRadio', function()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local radio = GetClosestObjectOfType(pedCoords, 5.0, `prop_boombox_01`, false)
    local radioCoords = GetEntityCoords(radio)
    InteractBoombox(radio, radioCoords)
end)


RegisterNetEvent('wasabi_boombox:pickupRadio', function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local radio = `prop_boombox_01`
    local closestRadio = GetClosestObjectOfType(pedCoords, 3.0, radio, false)
    local radioCoords = GetEntityCoords(closestRadio)
    local musicId = 'id_'..closestRadio
    TaskTurnPedToFaceCoord(ped, radioCoords.x, radioCoords.y, radioCoords.z, 2000)
    LoadAnimDict('anim@mp_snowball')
    TaskPlayAnim(ped, 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
    if xSound:soundExists(musicId) then
        TriggerServerEvent("wasabi_boombox:soundStatus", "stop", musicId, {})
    end
    TriggerServerEvent("wasabi_boombox:deleteObj", ObjToNet(closestRadio))
    if activeRadios[closestRadio] then
        activeRadios[closestRadio] = nil
    end
    TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
    ClearPedTasks(ped)
    RemoveAnimDict('anim@mp_snowball')
end)

RegisterNetEvent('wasabi_boombox:deleteObj', function(netId)
    if DoesEntityExist(NetToObj(netId)) then
        DeleteObject(NetToObj(netId))
        if not DoesEntityExist(NetToObj(netId)) then
            TriggerServerEvent('wasabi_boombox:objDeleted')
        end
    end   
end)

RegisterNetEvent('wasabi_boombox:soundStatus')
AddEventHandler('wasabi_boombox:soundStatus', function(type, musicId, data)
    CreateThread(function()
        if type == "position" then
            if xSound:soundExists(musicId) then
                xSound:Position(musicId, data.position)
            end
        end
        if type == "play" then
            xSound:PlayUrlPos(musicId, data.link, data.volume, data.position)
            xSound:Distance(musicId, data.distance)
            xSound:setVolume(musicId, data.volume)
        end

        if type == "volume" then
            xSound:setVolume(musicId, data.volume)
        end
    
        if type == "stop" then
            xSound:Destroy(musicId)
        end
    end)
end)

RegisterNetEvent('wasabi_boombox:playMenu')
AddEventHandler('wasabi_boombox:playMenu', function(data)
    local musicId = 'id_'..data.id
    if data.type == 'play' then
        local keyboard = exports["nh-keyboard"]:KeyboardInput({
            header = "Play Music",
            rows = {
                {
                    id = 1,
                    txt = "Youtube URL"
                },
                {
                    id = 2,
                    txt = "Distance (Max 40)"
                },
                {
                    id = 3,
                    txt = "Volume (0.0 - 1.0)"
                },
            }
        })
    
        if keyboard then
            if keyboard[1].input and tonumber(keyboard[2].input) and tonumber(keyboard[2].input) <= 40 and tonumber(keyboard[3].input) and tonumber(keyboard[3].input) <= 1.0 then
                TriggerServerEvent("wasabi_boombox:soundStatus", "play", musicId, { position = activeRadios[data.id].pos, link = keyboard[1].input, volume = keyboard[3].input, distance = keyboard[2].input })
                activeRadios[data.id].data = {playing = true, currentId = 'id_'..PlayerId()}
                TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
            end
        end
    elseif data.type == 'stop' then
        TriggerServerEvent("wasabi_boombox:soundStatus", "stop", musicId, {})
        activeRadios[data.id].data = {playing = false}
        TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
    elseif data.type == 'volume' then
        local keyboard = exports["nh-keyboard"]:KeyboardInput({
            header = "Change Volume", 
            rows = {
                {
                    id = 1,
                    txt = "Volume (0.0 - 1.0)"
                }
            }
        })
    
        if keyboard then
            if tonumber(keyboard[1].input) and tonumber(keyboard[1].input) <= 1.0 then
                TriggerServerEvent("wasabi_boombox:soundStatus", "volume", musicId, {volume = keyboard[1].input})
            end
        end
    elseif data.type == 'distance' then
        local keyboard = exports["nh-keyboard"]:KeyboardInput({
            header = "Change Distance", 
            rows = {
                {
                    id = 1,
                    txt = "Distance (Max 40)"
                }
            }
        })
    
        if keyboard then
            if tonumber(keyboard[1].input) and tonumber(keyboard[1].input) <= 40 then
                TriggerServerEvent("wasabi_boombox:soundStatus", "distance", musicId, {distance = keyboard[1].input})
            end
        end
    end
end)

RegisterNetEvent('wasabi_boombox:syncActive')
AddEventHandler('wasabi_boombox:syncActive', function(activeBoxes)
    activeRadios = activeBoxes
end)
