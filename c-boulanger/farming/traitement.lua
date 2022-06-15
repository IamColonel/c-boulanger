ESX = nil

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

function OpenboulangerieTraitement()
    local boulangerieTraitement = RageUI.CreateMenu("Traitement farine", "boulangerie")
    
    RageUI.Visible(boulangerieTraitement, not RageUI.Visible(boulangerieTraitement))
    
    while boulangerieTraitement do
        Citizen.Wait(0)
        RageUI.IsVisible(boulangerieTraitement, true, true, true, function()
                RageUI.ButtonWithStyle("Traitement farine", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RageUI.CloseAll()
                    traitementboulangerie()
                    end
                end)
        end)
    
        if not RageUI.Visible(boulangerieTraitement) then
            boulangerieTraitement = RMenu:DeleteType("boulangerieTraitement", true)
            end
        end
    end

local traitementpossible = false
Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        while true do
            local Timer = 500
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local playerCoords = GetEntityCoords(PlayerPedId())
            zoneDistance = GetDistanceBetweenCoords(playerCoords, boulangerie.position.traitement.position.x, boulangerie.position.traitement.position.y, boulangerie.position.traitement.position.z)
                if IsEntityAtCoord(PlayerPedId(), 0.0, -0.0, -0.0, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    Timer = 0
                        if IsControlJustPressed(1, 51) then
                            OpenboulangerieTraitement()
                        end
                    end
                    if zoneDistance ~= nil then
                        if zoneDistance > 1.5 then
                            traitementpossible = false
                        end
                    end
                Wait(Timer)
            end    
        end)

function traitementboulangerie()
    if not traitementpossible then
        traitementpossible = true
    while traitementpossible do
        Citizen.Wait(2000)
        TriggerServerEvent('farine')
    end
    else
        traitementpossible = false
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boulangerie' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, boulangerie.position.traitement.position.x, boulangerie.position.traitement.position.y, boulangerie.position.traitement.position.z)
        if dist3 <= 10.0 and boulangerie.marker then
            Timer = 0
            DrawMarker(20, boulangerie.position.traitement.position.x, boulangerie.position.traitement.position.y, boulangerie.position.traitement.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 3.0 then
                Timer = 0   
                RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour transformer en farine", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            OpenboulangerieTraitement()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)