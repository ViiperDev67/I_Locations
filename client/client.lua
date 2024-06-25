local display = false
local pedHandle = nil

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end
AddEventHandler("I_Location:OpenUI", function ()
    SetDisplay(true)
end)
RegisterNUICallback("closeUI", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("spawnVehicle", function(data)
    local vehicleName = data.vehicle
    if vehicleName then
        Citizen.CreateThread(function()
            local vehicleConfig = GetVehicleConfig(vehicleName)

            if vehicleConfig then
                RequestModel(vehicleConfig.spawnName)
                while not HasModelLoaded(vehicleConfig.spawnName) do
                    Citizen.Wait(0)
                end

                local spawnPoint = Config.SpawnPoint
                local vehicle = CreateVehicle(vehicleConfig.spawnName, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.heading, true, false)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end
        end)

        SetDisplay(false)
        TriggerServerEvent('I_Location:WithDrawMoney', vehicleName)
    end
end)


function GetVehicleConfig(name)
    for _, vehicle in pairs(Config.Vehicles) do
        if vehicle.name == name then
            return vehicle
        end
    end
    return nil
end

function SpawnPed()
    local pedConfig = Config.Ped
    RequestModel(pedConfig.model)
    while not HasModelLoaded(pedConfig.model) do
        Citizen.Wait(0)
    end
    pedHandle = CreatePed(4, pedConfig.model, pedConfig.position.x, pedConfig.position.y, pedConfig.position.z, pedConfig.position.heading, false, true)
    SetEntityAsMissionEntity(pedHandle, true, true)
    FreezeEntityPosition(pedHandle, true)
    SetEntityInvincible(pedHandle, true)
    SetBlockingOfNonTemporaryEvents(pedHandle, true)

    print(pedHandle)

    exports.ox_target:addBoxZone({
        coords = vector3(Config.Ped.position.x, Config.Ped.position.y, Config.Ped.position.z + 1),
        size = vec3(2, 2, 2),
        rotation = 45,
        options = {
            {
                name = 'box',
                icon = 'fa-solid fa-car',
                label = "Location",
                distance = 2,
                onSelect = function(data)
                    TriggerEvent('I_Location:OpenUI')
                end
            }
        }
    })


end

function DeletePed()
    if DoesEntityExist(pedHandle) then
        DeleteEntity(pedHandle)
    end
end


function CreateBlips()
    blips = AddBlipForCoord(Config.Blips.position.x, Config.Blips.position.y, Config.Blips.position.z)
    SetBlipSprite(blips, Config.Blips.sprite)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 1.0)
    SetBlipColour(blips, Config.Blips.color)
    SetBlipAsShortRange(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blips.name)
    EndTextCommandSetBlipName(blips)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Citizen.Wait(1000)
        SpawnPed()
        if(Config.Blips.blips) then
            CreateBlips()
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeletePed()
    end
end)
