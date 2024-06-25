ESX = exports["es_extended"]:getSharedObject()


RegisterServerEvent('I_Location:WithDrawMoney')
AddEventHandler('I_Location:WithDrawMoney', function(vehicleName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicleConfig = GetVehicleConfig(vehicleName)

    if vehicleConfig then
        local money = xPlayer.getMoney()
        if money >= vehicleConfig.price then
            xPlayer.removeMoney(vehicleConfig.price)
            TriggerClientEvent('esx:showNotification', source, 'Vous avez été facturé $' .. vehicleConfig.price)
        else
            TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas assez d\'argent')
        end
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
