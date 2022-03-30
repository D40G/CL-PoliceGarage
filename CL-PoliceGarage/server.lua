local QBCore = exports['qb-core']:GetCoreObject()

discord = {
    ['webhook'] = "https://discord.com/api/webhooks/931199353874436126/lTRwYdh4pQpj9HnBfk0dlfeEFGq-Sq7-PcDKImDZEE5xrg75zI5AI7pQJ4QGytsTOgmi",
    ['name'] = 'CL-PoliceGarage',
    ['image'] = "https://cdn.discordapp.com/attachments/926465631770005514/958798583992287272/POLICE-GARAGE.png"
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
        exports.oxmysql:execute('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
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
    if Player.PlayerData.money.cash >= data.price then
        TriggerClientEvent("CL-PoliceGarage:SpawnVehicle", src, data.vehicle)  
        Player.Functions.RemoveMoney("cash", data.price)
	    TriggerClientEvent('QBCore:Notify', src, 'Vehicle Successfully Bought', "success")    
        DiscordLog(discord['webhook'], 'New Vehicle Bought By: **'..steamname..'** ID: **' ..source.. '** Bought: **' ..data.vehicle.. '** For: **' ..data.price.. '**', 14177041) 
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
            ["icon_url"] = "https://cdn.discordapp.com/attachments/926465631770005514/958798583992287272/POLICE-GARAGE.png"
        },
            ["thumbnail"] = {
                ["url"] = "https://cdn.discordapp.com/attachments/926465631770005514/958798583992287272/POLICE-GARAGE.png",
            },
    }
}
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = embed, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end