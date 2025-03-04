local QBCore = exports['qb-core']:GetCoreObject()


CreateThread(function()
    for _, npc in pairs(Config.NpcSat) do
        RequestModel(GetHashKey(npc.model))
        while not HasModelLoaded(GetHashKey(npc.model)) do
            Wait(100)
        end
        local ped = CreatePed(4, GetHashKey(npc.model), npc.coords.x, npc.coords.y, npc.coords.z - 1.0, npc.heading,
            false, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
    end
end)

CreateThread(function()
    while true do
        local sleep = 2000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        for _, npc in pairs(Config.NpcSat) do
            local dist = #(PlayerCoords - npc.coords)
            if dist < 5 then
                sleep = 0
                QBCore.Functions.DrawText3D(npc.coords.x, npc.coords.y, npc.coords.z, npc.txt)
            end
            if dist < 1.5 then
                if IsControlJustPressed(0, 38) then
                    OpenMenu(npc)
                end
            end
        end
        Wait(sleep)
    end
end)

function OpenMenu(npc)
    local items = {}
    for _, v in pairs(npc.items) do
        items[#items + 1] = {
            header = v.name .. " - $" .. v.price,
            txt = "Elinizdeki İtemleri Satmak İçin Kullanın",
            params = {
                event = "wonev:openInput",
                args = { item = v.item, price = v.price }
            }
        }
    end
    exports['qb-menu']:openMenu(items)
end

RegisterNetEvent('wonev:openInput', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = "Miktarı Girin",
        submitText = "Kaydet",
        inputs = {
            {
                type = "number",
                isRequired = true,
                name = "İtem Miktari",
                text = "Miktarı Girin"
            }
        }
    })

    if dialog then
        local amount = tonumber(dialog["İtem Miktari"])
        if amount and amount > 0 then
            TriggerServerEvent("wonev:CheckMiktar", data.item, amount, data.price)
        else
            QBCore.Functions.Notify("Geçersiz Miktar Girdiniz", "error", 2000)
        end
    end
end)
