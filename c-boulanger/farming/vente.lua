CoESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function OpenboulangerieVente()
    local boulangerieVente = RageUI.CreateMenu("Vente pain chaud", "boulangerie")
    
    RageUI.Visible(boulangerieVente, not RageUI.Visible(boulangerieVente))
    
    while boulangerieVente do
        Citizen.Wait(0)
        RageUI.IsVisible(boulangerieVente, true, true, true, function()
                RageUI.ButtonWithStyle("Vente pain chaud", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RageUI.CloseAll()
                    venteboulangerie()
                    end
                end)
    end)  

        if not RageUI.Visible(boulangerieVente) then
            boulangerieVente = RMenu:DeleteType("boulangerieVente", true)
            end
        end
    end

    local ventepossible = false
    Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            while true do
                local Timer = 500
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local playerCoords = GetEntityCoords(PlayerPedId())
                zoneDistance = GetDistanceBetweenCoords(playerCoords, boulangerie.position.vente.position.x, boulangerie.position.vente.position.y, boulangerie.position.vente.position.z)
                    if IsEntityAtCoord(PlayerPedId(), 0.0, -0.0, -0.0, 1.5, 1.5, 1.5, 0, 1, 0) then 
                        Timer = 0
                            if IsControlJustPressed(1, 51) then
                                OpenboulangerieVente()
                            end
                end
                if zoneDistance ~= nil then
                    if zoneDistance > 1.5 then
                        ventepossible = false
                    end
                end
            Wait(Timer)
        end    
    end)

    function venteboulangerie()
        if not ventepossible then
            ventepossible = true
        while ventepossible do
            Citizen.Wait(2000)
            TriggerServerEvent('ventepain_chaud')
        end
        else
            ventepossible = false
        end
    end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boulangerie' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, boulangerie.position.vente.position.x, boulangerie.position.vente.position.y, boulangerie.position.vente.position.z)
        if dist3 <= 7.0 and boulangerie.marker then
            Timer = 0
            DrawMarker(20, boulangerie.position.vente.position.x, boulangerie.position.vente.position.y, boulangerie.position.vente.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour vendre du pain chaud", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            OpenboulangerieVente()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)