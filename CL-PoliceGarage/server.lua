local QBCore = exports['qb-core']:GetCoreObject()

function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

RegisterServerEvent("Dox-Garage:server:saveVehicle", function(mods, vehicle)
    local src = source;
    local playerD = QBCore.Functions.GetPlayer(src);
    if(playerD ~= nil and playerD) then
        exports.oxmysql:execute('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            playerD.PlayerData.license,
            playerD.PlayerData.citizenid,
            vehicle,
            GetHashKey(vehicle),
            json.encode(mods),
            plate,
            0
        })
    end
end)

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
    else
        TriggerClientEvent('QBCore:Notify', src, 'You Dont Have Enough Money !', "error")              
    end    
end)