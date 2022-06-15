ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('esx_phone:registerNumber', 'boulangerie', 'alerte boulangerie', true, true)
TriggerEvent('esx_society:registerSociety', 'boulangerie', 'boulangerie', 'society_boulangerie', 'society_boulangerie', 'society_boulangerie', {type = 'private'})


ESX.RegisterServerCallback('cboulangerie:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_boulangerie', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('cboulangerie:getStockItem')
AddEventHandler('cboulangerie:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_boulangerie', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('cboulangerie:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('cboulangerie:putStockItems')
AddEventHandler('cboulangerie:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_boulangerie', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'boulangerie' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_boulangeriejob:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('esx_boulangeriejob:spawned')
AddEventHandler('esx_boulangeriejob:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'boulangerie' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_boulangeriejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_boulangeriejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'boulangerie')
	end
end)

RegisterServerEvent('esx_boulangeriejob:message')
AddEventHandler('esx_boulangeriejob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('AnnonceboulangerieOuvert')
AddEventHandler('AnnonceboulangerieOuvert', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Boulangerie', '~g~Annonce', 'Venez gouter aux meilleurs pains de la ville!', 'HC_N_KAR', 8)
	end
end)

RegisterServerEvent('AnnonceboulangerieFermer')
AddEventHandler('AnnonceboulangerieFermer', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Boulangerie', '~g~Annonce', 'Le boulangerie est désormais fermé à plus tard!', 'HC_N_KAR', 8)
	end
end)

RegisterServerEvent('boulangerie:prendreitems')
AddEventHandler('boulangerie:prendreitems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_boulangerie', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


RegisterNetEvent('boulangerie:stockitem')
AddEventHandler('boulangerie:stockitem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_boulangerie', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "Objet déposé "..count..""..inventoryItem.label.."")
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


ESX.RegisterServerCallback('boulangerie:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('boulangerie:prendreitem', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_boulangerie', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('boulangerie:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_boulangerie', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('boulangerie:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_boulangerie', function(store)
		local weapons = store.get('weapons') or {}
		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('boulangerie:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_boulangerie', function(store)
		local weapons = store.get('weapons') or {}

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

RegisterNetEvent('ble')
AddEventHandler('ble', function()
    local item = "ble"
    local limiteitem = 50
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "T\'as pas assez de place dans ton inventaire !")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "Récolte en cours...")
    end
end)

RegisterNetEvent('farine')
AddEventHandler('farine', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local ble = xPlayer.getInventoryItem('ble').count
    local farine = xPlayer.getInventoryItem('farine').count

    if farine > 50 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de farine...')
    elseif ble < 1 then
        TriggerClientEvent('esx:showNotification', source, '~r~Pas assez de blé pour traiter...')
    else
        xPlayer.removeInventoryItem('ble', 1)
        xPlayer.addInventoryItem('farine', 1)    
    end
end)

RegisterNetEvent('pain_chaud')
AddEventHandler('pain_chaud', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local farine = xPlayer.getInventoryItem('farine').count
    local pain_chaud = xPlayer.getInventoryItem('pain_chaud').count

    if pain_chaud > 50 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de pain chaud...')
    elseif farine < 5 then
        TriggerClientEvent('esx:showNotification', source, '~r~Pas assez de farine pour traiter...')
    else
        xPlayer.removeInventoryItem('farine', 5)
        xPlayer.addInventoryItem('pain_chaud', 1)    
    end
end)

RegisterNetEvent('ventepain_chaud')
AddEventHandler('ventepain_chaud', function()

    local money = math.random(1000,2000)
    local xPlayer = ESX.GetPlayerFromId(source)
    local societyAccount = nil
    local pain_chaud = 0

    if xPlayer.getInventoryItem('pain_chaud').count <= 0 then
        pain_chaud = 0
    else
        pain_chaud = 1
    end

    if pain_chaud == 0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de pain chaud pour vendre...')
        return
    elseif xPlayer.getInventoryItem('pain_chaud').count <= 0 and argent == 0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de pain chaud pour vendre...')
        pain_chaud = 0
        return
    elseif pain_chaud == 1 then
            local money = math.random(boulangerie.venteminimum,boulangerie.ventemaximum)
            xPlayer.removeInventoryItem('pain_chaud', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_boulangerie', function(account)
                societyAccount = account
            end)
            if societyAccount ~= nil then
                societyAccount.addMoney(money)
				xPlayer.addMoney(money, boulangerie.prime)
                TriggerClientEvent('esx:showNotification', source, "~g~Vendue avec sucess...")
            end
        end
        end) 

		
RegisterServerEvent('Colonel:blanchiment')
AddEventHandler('Colonel:blanchiment', function(revefr)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local taxe = 1.0   

	revefr = ESX.Math.Round(tonumber(revefr))
	pourcentage = revefr * taxe
	Total = ESX.Math.Round(tonumber(pourcentage))

	if revefr > 0 and xPlayer.getAccount('black_money').money >= revefr then
		xPlayer.removeAccountMoney('black_money', revefr)
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Information', 'Offshore', '~r~Blanchiment en cours... ~y~(10s)', 'CHAR_MP_FM_CONTACT', 8)
		Citizen.Wait(10000)
		
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Information', 'Offshore', 'Tu as reçu : ' .. ESX.Math.GroupDigits(Total) .. ' ~g~$', 'CHAR_MP_FM_CONTACT', 8)
		xPlayer.addMoney(Total)
	else
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Information', 'Offshore', '~r~Montant invalide', 'CHAR_MP_FM_CONTACT', 8)
	end	
end)
