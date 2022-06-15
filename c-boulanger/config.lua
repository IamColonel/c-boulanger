boulangerie             = {}


boulangerie.blanchi = false

boulangerie.marker = true 

boulangerie.blips = true 

boulangerie.prime = 50 --- prix de la prime de vente

boulangerie.venteminimum = 100 --- vente minimum
boulangerie.ventemaximum = 200 --- vente maximale

boulangerie.position = {
	coffre = {
		position = {x = 387.14, y = -796.29, z = 29.27}
	},
		garage = {
		position = {x = 391.09, y = -768.49, z = 29.29}
	},
		spawnvoiture = {
		position = {x = 387.94, y = -767.68, z = 28.88, h = 359.76}
	},
		boss = {
		position = {x = 391.83, y = -796.17, z = 29.27}
	},
	blips = {
		position = {x = 394.85, y = -793.47, z = 29.29}
	},
	recolte = {
		position = {x = 694.42, y = 6470.16, z = 30.32}
	},
	traitement = {
		position = {x = 383.50, y = -796.42, z = 29.27}
	},
	transformation = {
		position = {x = 383.39, y = -792.03, z = 29.27}
	},
	vente = {
		position = {x = 1119.77, y = -983.86, z = 46.3}
	},
}

Garageboulangerievoiture = {
	{nom = "Bison", modele = "bison"},
}


boulangerie.tenus = {
	male = {
		['bags_1'] = 0, ['bags_2'] = 0,
		['tshirt_1'] = 41, ['tshirt_2'] = 0,
		['torso_1'] = 25, ['torso_2'] = 0,
		['arms'] = 15,
		['pants_1'] = 54, ['pants_2'] = 0,
		['shoes_1'] = 12, ['shoes_2'] = 6,
},

female = {
	['bags_1'] = 0, ['bags_2'] = 0,
	['tshirt_1'] = 3,['tshirt_2'] = 0,
	['torso_1'] = 3, ['torso_2'] = 2,
	['arms'] = 3,
	['pants_1'] = 2, ['pants_2'] = 2,
	['shoes_1'] = 7, ['shoes_2'] = 3,
}
}