ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('anton_adrenalin:oziviIgraca', function(source, cb, targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local najbliziIgrac = ESX.GetPlayerFromId(targetId)

    if xPlayer and najbliziIgrac then
        xPlayer.removeInventoryItem('adrenalin', 1)
        TriggerClientEvent('esx_ambulancejob:revive', targetId)
        cb(true)
    else
        cb(false)
    end
end)