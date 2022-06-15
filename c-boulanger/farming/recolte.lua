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

function OpenboulangerieRecolte()
    local boulangerieRecolte = RageUI.CreateMenu("Recolte blé", "boulangerie")
    
    RageUI.Visible(boulangerieRecolte, not RageUI.Visible(boulangerieRecolte))
    
    while boulangerieRecolte do
        Citizen.Wait(0)
        RageUI.IsVisible(boulangerieRecolte, true, true, true, function()
                RageUI.ButtonWithStyle("Récolte blé", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RageUI.CloseAll()
                    recolteboulangerie()
                    end
                end)
        end)
    
        if not RageUI.Visible(boulangerieRecolte) then
            boulangerieRecolte = RMenu:DeleteType("boulangerieRecolte", true)
            end
        end
    end

local recoltepossible = false
Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        while true do
            local Timer = 500
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local playerCoords = GetEntityCoords(PlayerPedId())
            zoneDistance = GetDistanceBetweenCoords(playerCoords, boulangerie.position.recolte.position.x, boulangerie.position.recolte.position.y, boulangerie.position.recolte.position.z)
                if IsEntityAtCoord(PlayerPedId(), 0.0, -0.0, -0.0, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    Timer = 0
                        if IsControlJustPressed(1, 51) then
                            OpenboulangerieRecolte()
                        end
            end
            if zoneDistance ~= nil then
                if zoneDistance > 1.5 then
                    recoltepossible = false
                end
            end
        Wait(Timer)
    end    
end)

function recolteboulangerie()
    if not recoltepossible then
        recoltepossible = true
    while recoltepossible do
        Citizen.Wait(2000)
        TriggerServerEvent('ble')
    end
    else
        recoltepossible = false
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boulangerie' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, boulangerie.position.recolte.position.x, boulangerie.position.recolte.position.y, boulangerie.position.recolte.position.z)
        if dist3 <= 10.0 and boulangerie.marker then
            Timer = 0
            DrawMarker(20, boulangerie.position.recolte.position.x, boulangerie.position.recolte.position.y, boulangerie.position.recolte.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour récolter du blé", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            OpenboulangerieRecolte()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)