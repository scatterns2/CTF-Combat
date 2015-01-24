//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// PulseGrenadeUpgrade.lua
						
class 'PulseGrenadeUpgrade' (CombatResupplyableWeaponUpgrade)

PulseGrenadeUpgrade.cost	 		= { 1 }                           									// cost of the upgrade in points
PulseGrenadeUpgrade.upgradeName 	= "pulsegrenade"                 									// Text code of the upgrade if using it via console
PulseGrenadeUpgrade.upgradeTitle 	= "PULSE_GRENADE"              										// Title of the upgrade, e.g. Submachine Gun
PulseGrenadeUpgrade.upgradeDesc 	= "TIPVIDEO_1_HARD_GRENADE_PULSE"	// Description of the upgrade
PulseGrenadeUpgrade.upgradeTechId 	= kTechId.PulseGrenade 												// TechId of the upgrade, default is kTechId.Move cause its the first entry
PulseGrenadeUpgrade.hudSlot 		= kGrenadesHUDSlot             										// Is this a primary weapon?
PulseGrenadeUpgrade.uniqueSlot  	= kUpgradeUniqueSlot.Weapon4
PulseGrenadeUpgrade.minPlayerLevel 	= 3																	// Controls whether this upgrade requires the recipient to be a minimum level
PulseGrenadeUpgrade.rowOrder 		= 2																	// Controls the horizontal position on the menu
PulseGrenadeUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Grenade3_Active.dds")
PulseGrenadeUpgrade.vidDesc			= "videos/Marines_PulseGrenade.webm"
PulseGrenadeUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Pulse.dds"
PulseGrenadeUpgrade.requirements		= {"engineer"}

function PulseGrenadeUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = PulseGrenadeUpgrade.cost
	self.upgradeName = PulseGrenadeUpgrade.upgradeName
	self.upgradeTitle = PulseGrenadeUpgrade.upgradeTitle
	self.upgradeDesc = PulseGrenadeUpgrade.upgradeDesc
	self.upgradeTechId = PulseGrenadeUpgrade.upgradeTechId
	self.hudSlot = PulseGrenadeUpgrade.hudSlot
	self.minPlayerLevel = PulseGrenadeUpgrade.minPlayerLevel
	self.rowOrder = PulseGrenadeUpgrade.rowOrder
	self.texture = PulseGrenadeUpgrade.texture
	self.vidDesc = PulseGrenadeUpgrade.vidDesc
	self.detailImage = PulseGrenadeUpgrade.detailImage
	self.requirements = PulseGrenadeUpgrade.requirements
end

function PulseGrenadeUpgrade:GetClassName()
	return "PulseGrenadeUpgrade"
end