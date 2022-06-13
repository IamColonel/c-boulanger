# c-boulanger
Lorsque vous êtes boulanger, votre but est d'aller récolter du blé, transformer en farine et de cuire en pain chaud puis de vendre le tout.

Votre agence se trouve au plein coeur de Los Santos avec un très beau mapping.

Vous avez à votre disposition un véhicule de fonction.

Ce job peut être utilisé dans le pôle emploi pour plus de diversité.

# Nécessaire
Les scripts de base pour le bon fonctionnement des autres jobs.

# Installation
Copie le dossier dans ressources 

Start le mapping et le job

importer le fichier SQL dans votre base de donnée

# Rendre les pains chauds uitilisable
Aller dans votre esx_basicneeds sous server/main.lua et ajoutez :
````
-- Pain Chaud

ESX.RegisterUsableItem('pain_chaud', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pain_chaud', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_pain_chaud'))
end)

```
