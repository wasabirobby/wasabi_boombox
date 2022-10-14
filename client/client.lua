-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

xSound = exports.xsound
activeRadios = {}
Framework = nil

if GetResourceState('es_extended') == 'started' or GetResourceState('es_extended') == 'starting' then
    Framework = 'ESX'
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' or GetResourceState('qb-core') == 'starting' then
    Framework = 'qb'
    QBCore = exports['qb-core']:GetCoreObject()
else
    print("^0[^1ERROR^0] Check the Server console for infos!^0")
end

RegisterNetEvent('wasabi_boombox:useBoombox')
AddEventHandler('wasabi_boombox:useBoombox', function()
    local ped = PlayerPedId()
    local hash = loadModel('prop_boombox_01')
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,3.0,0.5))
    local radio = CreateObjectNoOffset(hash, x, y, z, true, false)
    SetModelAsNoLongerNeeded(hash)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`)
    AttachEntityToEntity(radio, ped, GetPedBoneIndex(ped, 57005), 0.32, 0, -0.05, 0.10, 270.0, 60.0, true, true, false, true, 1, true)
    hasBoomBox(radio)
end)

RegisterNetEvent('wasabi_boombox:deleteObj', function(netId)
    if DoesEntityExist(NetToObj(netId)) then
        DeleteObject(NetToObj(netId))
        if not DoesEntityExist(NetToObj(netId)) then
            TriggerServerEvent('wasabi_boombox:objDeleted')
        end
    end
end)

AddEventHandler('wasabi_boombox:pickup', function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local radio = `prop_boombox_01`
    local closestRadio = GetClosestObjectOfType(pedCoords, 3.0, radio, false)
    local radioCoords = GetEntityCoords(closestRadio)
    local musicId = 'id_'..closestRadio
    TaskTurnPedToFaceCoord(ped, radioCoords.x, radioCoords.y, radioCoords.z, 2000)
    TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(1000)
    if xSound:soundExists(musicId) then
        TriggerServerEvent("wasabi_boombox:soundStatus", "stop", musicId, {})
    end
    FreezeEntityPosition(closestRadio, false)
    TriggerServerEvent("wasabi_boombox:deleteObj", ObjToNet(closestRadio))
    if activeRadios[closestRadio] then
        activeRadios[closestRadio] = nil
    end 
    TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
    ClearPedTasks(ped)
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
            TriggerServerEvent('wasabi_boombox:DiscordKnows',data.link)
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

AddEventHandler('wasabi_boombox:interact', function()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local radio = GetClosestObjectOfType(pedCoords, 5.0, `prop_boombox_01`, false)
    local radioCoords = GetEntityCoords(radio)
    interactBoombox(radio, radioCoords)
end)

AddEventHandler('wasabi_boombox:savedSongs', function(radio)
    savedSongsMenu(radio)
end)

AddEventHandler('wasabi_boombox:saveSong', function()
    local input = lib.inputDialog(_U('save_song'), {_U('name'), _U('youtube_link')})
    if input[1] and input[2] then
        TriggerServerEvent('wasabi_boombox:save', input[1], input[2])
        lib.notify({
            title = _U('success_title'),
            description = _U('song_saved'),
            type = 'success'
        })
    else
        lib.notify({
            title = _U('incorrect_title'),
            description = _U('incomplete_information'),
            type = 'error'
        })
    end
end)

AddEventHandler('wasabi_boombox:selectSavedSong', function(data)
    selectSavedSong(data)
end)

AddEventHandler('wasabi_boombox:playSavedSong', function(data)
    local musicId = 'id_'..data.id
    TriggerServerEvent("wasabi_boombox:soundStatus", "play", musicId, { position = activeRadios[data.id].pos, link = data.link, volume = '0.2', distance = 25 })
    activeRadios[data.id].data = {playing = true, currentId = 'id_'..PlayerId()}
    TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
end)

AddEventHandler('wasabi_boombox:deleteSong', function(data)
	local confirmed = lib.alertDialog({
		header = _U('delete_song'),
		content = _U('sure_about_delete_song'),
		centered = true,
		cancel = true
	})
	if confirmed == 'confirm' then
		TriggerServerEvent('wasabi_boombox:deleteSong', data)
		lib.notify({
			title = _U('deleted'),
			description = _U('song_deleted'),
			type = 'success'
		})
	else
		lib.notify({
			title = _U('cancelled'),
			description = _U('cancel_previous_action'),
			type = 'error'
		})
	end
end)

AddEventHandler('wasabi_boombox:playMenu', function(data)
    local musicId = 'id_'..data.id
    if data.type == 'play' then
        local keyboard = lib.inputDialog(_U('play_music'), {_U('youtube_link'),_U('distance'), _U('volume')})
        if keyboard then
            if keyboard[1] and tonumber(keyboard[2]) and tonumber(keyboard[2]) <= 40 and tonumber(keyboard[3]) and tonumber(keyboard[3]) <= 100 then
                TriggerServerEvent("wasabi_boombox:soundStatus", "play", musicId, { position = activeRadios[data.id].pos, link = keyboard[1], volume = keyboard[3]/100, distance = keyboard[2] })
                activeRadios[data.id].data = {playing = true, currentId = 'id_'..PlayerId()}
                TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
            end
        end
    elseif data.type == 'stop' then
        TriggerServerEvent("wasabi_boombox:soundStatus", "stop", musicId, {})
        activeRadios[data.id].data = {playing = false}
        TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
    elseif data.type == 'volume' then
        local keyboard = lib.inputDialog(_U('change_volume'), {_U('volume')})    
        if keyboard then
            if tonumber(keyboard[1]) and tonumber(keyboard[1]) <= 100 then
                TriggerServerEvent("wasabi_boombox:soundStatus", "volume", musicId, {volume = keyboard[1]/100})
            end
        end
    elseif data.type == 'distance' then
        local keyboard = lib.inputDialog(_U('change_distance'), {_U('distance')})
        if keyboard then
            if tonumber(keyboard[1]) and tonumber(keyboard[1]) <= 40 then
                TriggerServerEvent("wasabi_boombox:soundStatus", "distance", musicId, {distance = keyboard[1]})
            end
        end
    end
end)

RegisterNetEvent('wasabi_boombox:syncActive')
AddEventHandler('wasabi_boombox:syncActive', function(activeBoxes)
    activeRadios = activeBoxes
end)
    
   
