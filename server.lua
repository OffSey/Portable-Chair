local framework = nil

CreateThread(function()
    if Config.Framework == "esx" then
        framework = exports["es_extended"]:getSharedObject()

        framework.RegisterUsableItem('portablechair', function(source)
            local xPlayer = framework.GetPlayerFromId(source)
            xPlayer.removeInventoryItem('portablechair', 1)
            TriggerClientEvent("portablechair:Toggle", source)
        end)

    elseif Config.Framework == "qbcore" then
        framework = exports['qb-core']:GetCoreObject()

        framework.Functions.CreateUseableItem("portablechair", function(source)
            local Player = framework.Functions.GetPlayer(source)
            if Player then
                Player.Functions.RemoveItem("portablechair", 1)
                TriggerClientEvent("portablechair:Toggle", source)
            end
        end)

    else
        RegisterCommand("chair", function(source)
            TriggerClientEvent("portablechair:Toggle", source)
        end)
    end
end)

RegisterNetEvent("portablechair:up", function()
    local src = source

    if Config.Framework == "esx" then
        local xPlayer = framework.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem("portablechair", 1)
        end

    elseif Config.Framework == "qbcore" then
        local Player = framework.Functions.GetPlayer(src)
        if Player then
            Player.Functions.AddItem("portablechair", 1)
        end
    end
end)
