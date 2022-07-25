-----------------For support, scripts, and more----------------
----------------- https://discord.gg/XJFNyMy3Bv ---------------
---------------------------------------------------------------
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem(Config.BoomboxItem, function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.triggerEvent('wasabi_boombox:useBoombox')
    xPlayer.removeInventoryItem(Config.BoomboxItem, 1)
end)

RegisterServerEvent('wasabi_boombox:deleteObj', function(netId)
    TriggerClientEvent('wasabi_boombox:deleteObj', -1, netId)
end)

RegisterServerEvent('wasabi_boombox:objDeleted', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(Config.BoomboxItem, 1)
end)

RegisterNetEvent("wasabi_boombox:soundStatus")
AddEventHandler("wasabi_boombox:soundStatus", function(type, musicId, data)
    TriggerClientEvent("wasabi_boombox:soundStatus", -1, type, musicId, data)
end)

RegisterNetEvent("wasabi_boombox:syncActive")
AddEventHandler("wasabi_boombox:syncActive", function(activeRadios)
    TriggerClientEvent("wasabi_boombox:syncActive", -1, activeRadios)
end)

RegisterServerEvent('wasabi_boombox:save')
AddEventHandler('wasabi_boombox:save', function(name, link)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.insert('INSERT INTO `boombox_songs` (`identifier`, `label`, `link`) VALUES (@identifier, @label, @link)', {
		['@identifier'] = xPlayer.identifier,
		['@label'] = name,
        ['@link'] = link
	})
end)

RegisterServerEvent('wasabi_boombox:deleteSong')
AddEventHandler('wasabi_boombox:deleteSong', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM `boombox_songs` WHERE `identifier` = @identifier AND label = @label AND link = @link', {
        ["@identifier"] = xPlayer.identifier,
        ["@label"] = data.label,
        ["@link"] = data.link,
	})
end)

ESX.RegisterServerCallback('wasabi_boombox:getSavedSongs', function(source, cb)
    local savedSongs = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT label, link FROM boombox_songs WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1] then
            for i=1, #result do
                table.insert(savedSongs, {label = result[i].label, link = result[i].link})
            end
        end
        if savedSongs then
            cb(savedSongs)
        else
            cb(false)
        end
	end)
end)