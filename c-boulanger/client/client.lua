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

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)


Citizen.CreateThread(function()
    if boulangerie.blips then
    local boulangeriemap = AddBlipForCoord(boulangerie.position.blips.position.x, boulangerie.position.blips.position.y, boulangerie.position.blips.position.z)

    SetBlipSprite(boulangeriemap, 106)
    SetBlipColour(boulangeriemap, 28)
    SetBlipScale(boulangeriemap, 0.65)
    SetBlipAsShortRange(boulangeriemap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Boulangerie")
    EndTextCommandSetBlipName(boulangeriemap)
end
end)


function Menuf6boulangerie()
    local cboulangerief6 = RageUI.CreateMenu("Boulangerie", "Interactions")
    local cboulangerief6sub = RageUI.CreateSubMenu(cboulangerief6, "Boulangerie", "Interactions")
    RageUI.Visible(cboulangerief6, not RageUI.Visible(cboulangerief6))
    while cboulangerief6 do
        Citizen.Wait(0)
            RageUI.IsVisible(cboulangerief6, true, true, true, function()

                RageUI.Separator("↓ Facture ↓")

                RageUI.ButtonWithStyle("Facture",nil, {RightLabel = "→"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        if player ~= -1 and distance <= 3.0 then
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_boulangerie', ('boulangerie'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)


                RageUI.Separator("↓ Annonce ↓")



                RageUI.ButtonWithStyle("Annonces d'ouverture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        TriggerServerEvent('AnnonceboulangerieOuvert')
                    end
                end)
        
                RageUI.ButtonWithStyle("Annonces de fermeture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then      
                        TriggerServerEvent('AnnonceboulangerieFermer')
                    end
                end)
                RageUI.Separator("")

                RageUI.ButtonWithStyle("Menu travail", nil,  {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, cboulangerief6sub)


                end, function() 
                end)
    
                RageUI.IsVisible(cboulangerief6sub, true, true, true, function()

                RageUI.ButtonWithStyle("Récolte blé",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        SetNewWaypoint(boulangerie.position.recolte.position.x, boulangerie.position.recolte.position.y)
                    end
                end)

                RageUI.ButtonWithStyle("Traitement farine",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        SetNewWaypoint(boulangerie.position.traitement.position.x, boulangerie.position.traitement.position.y)
                    end
                end)

                RageUI.ButtonWithStyle("Transformation pain chaud",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        SetNewWaypoint(boulangerie.position.transformation.position.x, boulangerie.position.transformation.position.y)
                    end
                end)

                RageUI.ButtonWithStyle("Vente pain chaud",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        SetNewWaypoint(boulangerie.position.vente.position.x, boulangerie.position.vente.position.y)
                    end
                end)
            end, function() 
            end)

                
    
                if not RageUI.Visible(cboulangerief6) and not RageUI.Visible(cboulangerief6sub) then
                    cboulangerief6 = RMenu:DeleteType("cboulangerief6", true)
        end
    end
end


Keys.Register('F6', 'boulangerie', 'Ouvrir le menu boulangerie', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boulangerie' then
    	Menuf6boulangerie()
	end
end)




function Coffreboulangerie()
    local Cboulangerie = RageUI.CreateMenu("Coffre", "Boulangerie")
        RageUI.Visible(Cboulangerie, not RageUI.Visible(Cboulangerie))
            while Cboulangerie do
            Citizen.Wait(0)
            RageUI.IsVisible(Cboulangerie, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ Vêtements ↓")

                    RageUI.ButtonWithStyle("Tenue de travail",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tenueboulangerie()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("Remettre sa tenue",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            vcivil()
                            RageUI.CloseAll()
                        end
                    end)

                end, function()
                end)
            if not RageUI.Visible(Cboulangerie) then
            Cboulangerie = RMenu:DeleteType("Cboulangerie", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boulangerie' then
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, boulangerie.position.coffre.position.x, boulangerie.position.coffre.position.y, boulangerie.position.coffre.position.z)
            if jobdist <= 10.0 and boulangerie.marker then
                Timer = 0
                DrawMarker(20, boulangerie.position.coffre.position.x, boulangerie.position.coffre.position.y, boulangerie.position.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        Coffreboulangerie()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)


function Garageboulangerie()
    local Gboulangerie = RageUI.CreateMenu("Garage", "boulangerie")
      RageUI.Visible(Gboulangerie, not RageUI.Visible(Gboulangerie))
          while Gboulangerie do
              Citizen.Wait(0)
                  RageUI.IsVisible(Gboulangerie, true, true, true, function()
                      RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                          if (Selected) then   
                          local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                          if dist4 < 4 then
                              DeleteEntity(veh)
                              RageUI.CloseAll()
                              end 
                          end
                      end) 
  
                      for k,v in pairs(Garageboulangerievoiture) do
                      RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                          if (Selected) then
                          Citizen.Wait(1)  
                              spawnuniCarboulangerie(v.modele)
                              RageUI.CloseAll()
                              end
                          end)
                      end
                  end, function()
                  end)
              if not RageUI.Visible(Gboulangerie) then
              Gboulangerie = RMenu:DeleteType("Garage", true)
          end
      end
  end
  
  Citizen.CreateThread(function()
          while true do
              local Timer = 500
              if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boulangerie' then
              local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
              local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, boulangerie.position.garage.position.x, boulangerie.position.garage.position.y, boulangerie.position.garage.position.z)
              if dist3 <= 10.0 and boulangerie.marker then
                  Timer = 0
                  DrawMarker(20, boulangerie.position.garage.position.x, boulangerie.position.garage.position.y, boulangerie.position.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                  end
                  if dist3 <= 3.0 then
                  Timer = 0   
                      RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                      if IsControlJustPressed(1,51) then           
                          Garageboulangerie()
                      end   
                  end
              end 
          Citizen.Wait(Timer)
       end
  end)
  
  function spawnuniCarboulangerie(car)
      local car = GetHashKey(car)
  
      RequestModel(car)
      while not HasModelLoaded(car) do
          RequestModel(car)
          Citizen.Wait(0)
      end
  
      local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
      local vehicle = CreateVehicle(car, boulangerie.position.spawnvoiture.position.x, boulangerie.position.spawnvoiture.position.y, boulangerie.position.spawnvoiture.position.z, boulangerie.position.spawnvoiture.position.h, true, false)
      SetEntityAsMissionEntity(vehicle, true, true)
      local plaque = "boulangerie"..math.random(1,9)
      SetVehicleNumberPlateText(vehicle, plaque) 
      SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
  end



function tenueboulangerie()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = boulangerie.tenus.male
        else
            uniformObject = boulangerie.tenus.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end


function vcivil()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('skinchanger:loadSkin', skin)
       end)
    end

itemstock = {}
function TRetirerobjet()
    local Stockboulangerie = RageUI.CreateMenu("Coffre", "boulangerie")
    ESX.TriggerServerCallback('cboulangerie:getStockItems', function(items) 
    itemstock = items
   
    RageUI.Visible(Stockboulangerie, not RageUI.Visible(Stockboulangerie))
        while Stockboulangerie do
            Citizen.Wait(0)
                RageUI.IsVisible(Stockboulangerie, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('cboulangerie:getStockItem', v.name, tonumber(count))
                                    TRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockboulangerie) then
            Stockboulangerie = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function TDeposerobjet()
    local StockPlayer = RageUI.CreateMenu("Coffre", "boulangerie")
    ESX.TriggerServerCallback('cboulangerie:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('cboulangerie:putStockItems', item.name, tonumber(count))
                                            TDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end

RegisterNetEvent('f:startSmoke')
AddEventHandler('f:startSmoke', function(source)
	SmokeAnimation()
end)

function SmokeAnimation()
	local playerPed = GetPlayerPed(-1)
	
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)               
	end)
end
