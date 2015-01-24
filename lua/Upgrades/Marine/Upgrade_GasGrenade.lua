//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// GasGrenadeUpgrade.lua
						
class 'GasGrenadeUpgrade' (CombatResupplyableWeaponUpgrade)

GasGrenadeUpgrade.cost			 = { 1 }                           				// cost of the upgrade in points
GasGrenadeUpgrade.upgradeName 	 = "gasgrenade"                 				// Text code of the upgrade if using it via console
GasGrenadeUpgrade.upgradeTitle	 = "GAS_GRENADE"              					// Title of the upgrade, e.g. Submachine Gun
GasGrenadeUpgrade.upgradeDesc 	 = "TIPVIDEO_1_MARINE_NERVE_GAS_GRENADE"	// Description of the upgrade
GasGrenadeUpgrade.upgradeTechId  = kTechId.GasGrenade 							// TechId of the upgrade, default is kTechId.Move cause its the first entry
GasGrenadeUpgrade.hudSlot		 = kGrenadesHUDSlot             				// Is this a primary weapon?
GasGrenadeUpgrade.uniqueSlot     = kUpgradeUniqueSlot.Weapon4
GasGrenadeUpgrade.minPlayerLevel = 3											// Controls whether this upgrade requires the recipient to be a minimum level
GasGrenadeUpgrade.rowOrder 		 = 1											// Controls the horizontal position on the menu
GasGrenadeUpgrade.texture 		 = PrecacheAsset("ui/buymenu/Icons/Icon_Grenade2_Active.dds")
GasGrenadeUpgrade.vidDesc		 = "videos/Marines_NerveGasGrenade.webm"
GasGrenadeUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Gas.dds"
GasGrenadeUpgrade.requirements		= { "medic" }

function GasGrenadeUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = GasGrenadeUpgrade.cost
	self.upgradeName = GasGrenadeUpgrade.upgradeName
	self.upgradeTitle = GasGrenadeUpgrade.upgradeTitle
	self.upgradeDesc = GasGrenadeUpgrade.upgradeDesc
	self.upgradeTechId = GasGrenadeUpgrade.upgradeTechId
	self.hudSlot = GasGrenadeUpgrade.hudSlot
	self.minPlayerLevel = GasGrenadeUpgrade.minPlayerLevel
	self.rowOrder = GasGrenadeUpgrade.rowOrder
	self.texture = GasGrenadeUpgrade.texture
	self.vidDesc = GasGrenadeUpgrade.vidDesc
	self.detailImage = GasGrenadeUpgrade.detailImage
	self.requirements = GasGrenadeUpgrade.requirements
end

function GasGrenadeUpgrade:GetClassName()
	return "GasGrenadeUpgrade"
end