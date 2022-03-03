ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem(Config.boomboxItem, function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.triggerEvent('wasabi_boombox:useBoombox')
    xPlayer.removeInventoryItem(Config.boomboxItem, 1)
end)

RegisterServerEvent('wasabi_boombox:deleteObj', function(netId)
    TriggerClientEvent('wasabi_boombox:deleteObj', -1, netId)
end)

RegisterServerEvent('wasabi_boombox:objDeleted', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(Config.boomboxItem, 1)
end)

RegisterNetEvent("wasabi_boombox:soundStatus")
AddEventHandler("wasabi_boombox:soundStatus", function(type, musicId, data)
    TriggerClientEvent("wasabi_boombox:soundStatus", -1, type, musicId, data)
end)

RegisterNetEvent("wasabi_boombox:syncActive")
AddEventHandler("wasabi_boombox:syncActive", function(activeRadios)
    TriggerClientEvent("wasabi_boombox:syncActive", -1, activeRadios)
end)
