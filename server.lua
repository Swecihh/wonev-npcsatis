local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("wonev:CheckMiktar", function(item, amount, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then

        if Player.Functions.GetItemByName(item) and Player.Functions.GetItemByName(item).amount >= amount then

            Player.Functions.RemoveItem(item, amount)

            Player.Functions.AddMoney("cash", price * amount)
            TriggerClientEvent("QBCore:Notify", src, "Başarıyla " .. amount .. "x " .. item .. " sattınız!", "success")
        else
            TriggerClientEvent("QBCore:Notify", src, "Üzerinizde yeterli " .. item .. " yok!", "error")
        end
    end
end)
