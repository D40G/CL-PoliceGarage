local QBCore = exports['qb-core']:GetCoreObject()

discord = {
    ['webhook'] = "YOUR WEBHOOK",
    ['name'] = 'CL-PoliceGarage',
    ['image'] = "YOUR IMAGE"
}

function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

RegisterServerEvent("CL-PoliceGarage:AddVehicleSQL")
AddEventHandler('CL-PoliceGarage:AddVehicleSQL', function(mods, vehicle, hash, plate)
    local src = source;
    local playerD = QBCore.Functions.GetPlayer(src);
    if (playerD ~= nil and playerD) then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            playerD.PlayerData.license,
            playerD.PlayerData.citizenid,
            vehicle,
            hash,
            json.encode(mods),
            plate,
            0
        })
    end
end)

RegisterServerEvent('CL-PoliceGarage:TakeMoney', function(data)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local steamname = GetPlayerName(src)
    if Player.PlayerData.money.cash >= data.price then
        TriggerClientEvent("CL-PoliceGarage:SpawnVehicle", src, data.vehicle)  
        Player.Functions.RemoveMoney("cash", data.price)
	    TriggerClientEvent('QBCore:Notify', src, 'Vehicle Successfully Bought', "success")    
        DiscordLog(discord['webhook'], 'New Vehicle Bought By: **'..steamname..'** ID: **' ..source.. '** Bought: **' ..data.vehicle.. '** For: **' ..data.price.. '$**', 14177041) 
    else
        TriggerClientEvent('QBCore:Notify', src, 'You Dont Have Enough Money !', "error")              
    end    
end)

function DiscordLog(name, message, color)
    local embed = {
        {
            ["color"] = 000, 
            ["title"] = "CloudDevelopment Police Garage",
            ["description"] = message,
            ["url"] = "https://discord.gg/e4AYS3VE",
            ["footer"] = {
            ["text"] = "By CloudDevelopment",
            ["icon_url"] = "YOUR IMAGE"
        },
            ["thumbnail"] = {
                ["url"] = "YOUR IMAGE",
            },
    }
}
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = embed, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end