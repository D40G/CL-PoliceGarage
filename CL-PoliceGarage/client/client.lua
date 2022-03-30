local QBCore = exports['qb-core']:GetCoreObject()

local PlayerJob = nil

local InPreview = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('CL-PoliceGarage:Menu', function()
    local Menu = {
        {
            header = "Police Garage",
            txt = "View Vehicles",
            params = {
                event = "CL-PoliceGarage:Catalog",
            }
        }
    }
    Menu[#Menu+1] = {
        header = "Preview Vehicles",
        txt = "View Vehicles",
        params = {
            event = "CL-PoliceGarage:PreviewCarMenu",
        }
    }
    Menu[#Menu+1] = {
        header = "Store Vehicle",
        params = {
            event = "CL-PoliceGarage:StoreVehicle",
        }
    }
    Menu[#Menu+1] = {
        header = "⬅ Close Menu",
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(Menu)
end)

RegisterNetEvent("CL-PoliceGarage:Catalog", function()
    local vehicleMenu = {
        {
            header = "Police Garage",
            isMenuHeader = true,
        }
    }
    for k, v in pairs(Config.Vehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = v.vehiclename,
            txt = "Buy: " .. v.vehiclename .. " For: " .. v.price .. "$",
            params = {
                isServer = true,
                event = "CL-PoliceGarage:TakeMoney",
                args = {
                    price = v.price,
                    vehicle = v.vehicle
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu+1] = {
        header = "⬅ Go Back",
        params = {
            event = "CL-PoliceGarage:Menu"
        }
    }
    exports['qb-menu']:openMenu(vehicleMenu)
end)

RegisterNetEvent('CL-PoliceGarage:PreviewCarMenu', function()
    local PreviewMenu = {
        {
            header = "Preview Menu",
            isMenuHeader = true
        }
    }
    for k, v in pairs(Config.Vehicles) do
        PreviewMenu[#PreviewMenu+1] = {
            header = v.vehiclename,
            txt = "Preview: " .. v.vehiclename,
            params = {
                event = "CL-PoliceGarage:PreviewVehicle",
                args = {
                    vehicle = v.vehicle,
                }
            }
        }
    end
    PreviewMenu[#PreviewMenu+1] = {
        header = "⬅ Go Back",
        params = {
            event = "CL-PoliceGarage:Menu"
        }
    }
    exports['qb-menu']:openMenu(PreviewMenu)
end)

CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)
        local letSleep = true

        QBCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.job.name == Config.Job then
                if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, 441.78894, -1020.011, 28.225797, true) < 10) then
                    letSleep = false
                    DrawMarker(2, 441.78894, -1020.011, 28.225797, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 0, 0, 0, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, 441.78894, -1020.011, 28.225797, true) < 1.5) then
                        DrawText3D(441.78894, -1020.011, 28.225797, "~g~E~w~ - Police Garage") 
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("CL-PoliceGarage:Menu")
                        end
                    end
                end
            end
        end)

        if letSleep then
            Wait(2000)
        end

        Wait(1)
    end
end)

RegisterNetEvent('CL-PoliceGarage:StoreVehicle')
AddEventHandler('CL-PoliceGarage:StoreVehicle', function()
    local ped = PlayerPedId()
    local car = GetVehiclePedIsIn(PlayerPedId(),true)
    if IsPedInAnyVehicle(ped, false) then
        TaskLeaveVehicle(ped, car, 1)
        Citizen.Wait(2000)
        QBCore.Functions.Notify('Vehicle Stored!')
        DeleteVehicle(car)
        DeleteEntity(car)
    else
        QBCore.Functions.Notify("You Are Not In Any Vehicle !", "error")
    end
end)

RegisterNetEvent("CL-PoliceGarage:SpawnVehicle")
AddEventHandler("CL-PoliceGarage:SpawnVehicle", function(vehicle)
    local coords = vector4(438.47174, -1021.936, 28.627538, 96.793121)
    local v = Config.Vehicles
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        SetVehicleNumberPlateText(veh, "POL"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        CloseMenu()
        if Config.UseColors == true then
            SetVehicleCustomPrimaryColour(veh, v.r, v.g, v.b)
            SetVehicleCustomSecondaryColour(veh, v.r, v.g, v.b)
        end
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        TriggerServerEvent("CL-PoliceGarage:AddVehicleSQL", props, vehicle, GetHashKey(veh), QBCore.Functions.GetPlate(veh))
    end, coords, true)
end)

RegisterNetEvent("CL-PoliceGarage:PreviewVehicle")
AddEventHandler("CL-PoliceGarage:PreviewVehicle", function(data)
    InPreview = true
    local coords = vector4(439.22729, -1021.972, 28.610841, 99.184043)
    QBCore.Functions.SpawnVehicle(data.vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "POL"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 0.0)
        CloseMenu()
        SetVehicleEngineOn(veh, false, false)
        DoScreenFadeOut(200)
        Citizen.Wait(500)
        DoScreenFadeIn(200)
        SetVehicleUndriveable(veh, true)
    
        VehicleCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 434.03289, -1022.814, 28.730619, 50, 0.00, 282.17034, 80.00, false, 0)
        SetCamActive(VehicleCam, true)
        RenderScriptCams(true, true, 500, true, true)
        if Config.MS == 'high' then
            Citizen.CreateThread(function()
                while true do
                    if InPreview then
                        ShowHelpNotification("Press ~INPUT_FRONTEND_RRIGHT~ To Close")
                    elseif not InPreview then
                        break
                    end
                    Citizen.Wait(1)
                end
            end)
        elseif Config.MS == 'low' then
            ShowHelpNotification("Press ~INPUT_FRONTEND_RRIGHT~ To Close")
        end


        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(7)
                if IsControlJustReleased(0, 177) then
                    PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    QBCore.Functions.DeleteVehicle(veh)
                    DoScreenFadeOut(200)
                    Citizen.Wait(500)
                    DoScreenFadeIn(200)
                    RenderScriptCams(false, false, 1, true, true)
                    InPreview = false
                    break
                end
                Citizen.Wait(1)
            end
        end)
    end, coords, true)
end)

function CloseMenu()
    exports['qb-menu']:closeMenu()
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end