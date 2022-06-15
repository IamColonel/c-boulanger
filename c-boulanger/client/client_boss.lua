ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyboulangeriemoney = nil

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

---------------- BLANCHIMENT ------------------

function PourBlanchir()
    local TKTPOTO = RageUI.CreateMenu("Compte Offshore", "Luxembourg Exchange System")
    TKTPOTO:SetRectangleBanner(0, 0, 0)
        RageUI.Visible(TKTPOTO, not RageUI.Visible(TKTPOTO))
            while TKTPOTO do
            Citizen.Wait(0)
            RageUI.IsVisible(TKTPOTO, true, true, true, function()


                RageUI.ButtonWithStyle("Insérer le montant à blanchir..", nil, {RightLabel = ""}, true, function(_, _, s)
                    if s then
                        local revefr = KeyboardInput("Montant", "", 10)
                        revefr = tonumber(revefr)
                        if revefr == nil then
                            RageUI.Popup({message = "Montant invalide ⛔"})
                        else
                        TriggerServerEvent('Colonel:blanchiment', revefr)	
                        ESX.ShowColoredNotification('Action effectuée ✅ ', 18) 
                        end
                    end
                end)
                
                end, function()
                end)
            if not RageUI.Visible(TKTPOTO) then
            TKTPOTO = RMenu:DeleteType("TKTPOTO", true)
        end
    end
end

---------------- FONCTIONS ------------------

function Bossboulangerie()
    local Cboulangerie = RageUI.CreateMenu("Actions Patron", "Boulangerie")
  
      RageUI.Visible(Cboulangerie, not RageUI.Visible(Cboulangerie))
  
              while Cboulangerie do
                  Citizen.Wait(0)
                      RageUI.IsVisible(Cboulangerie, true, true, true, function()
  
            if societyboulangeriemoney ~= nil then
                RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societyboulangeriemoney}, true, function()
                end)
            end

            RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:withdrawMoney', 'boulangerie', amount)
                        RefreshboulangerieMoney()
                    end
                end
            end)

            RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:depositMoney', 'boulangerie', amount)
                        RefreshboulangerieMoney()
                    end
                end
            end) 

            RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    aboss()
                    RageUI.CloseAll()
                end
            end)

                RageUI.ButtonWithStyle("En savoir plus...",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if boulangerie.blanchi then
                        PourBlanchir()
                        RageUI.CloseAll()
                        else
                            RageUI.Popup({message = "Compte Offshore Désactivé par l'Etat !"})
                    end
                end
                end)


        end, function()
        end)
        if not RageUI.Visible(Cboulangerie) then
        Cboulangerie = RMenu:DeleteType("Cboulangerie", true)
    end
end
end


----------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boulangerie' and ESX.PlayerData.job.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, boulangerie.position.boss.position.x, boulangerie.position.boss.position.y, boulangerie.position.boss.position.z)
        if dist3 <= 7.0 and boulangerie.marker then
            Timer = 0
            DrawMarker(20, boulangerie.position.boss.position.x, boulangerie.position.boss.position.y, boulangerie.position.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            RefreshboulangerieMoney()           
                            Bossboulangerie()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshboulangerieMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyboulangerieMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietyboulangerieMoney(money)
    societyboulangeriemoney = ESX.Math.GroupDigits(money)
end

function aboss()
    TriggerEvent('esx_society:openBossMenu', 'boulangerie', function(data, menu)
        menu.close()
    end, {wash = false})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

