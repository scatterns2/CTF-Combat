//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// HealGunUpgrade.lua
						
class 'HealGunUpgrade' (CombatWeaponUpgrade)

HealGunUpgrade.cost	 		= { 0 }                           				// cost of the upgrade in points
HealGunUpgrade.upgradeName 	= "healgun"                       				// Text code of the upgrade if using it via console
HealGunUpgrade.upgradeTitle 	= "HEALGUN"               						// Title of the upgrade, e.g. Submachine Gun
HealGunUpgrade.upgradeDesc 	= "HEALGUN_TOOLTIP"	// Description of the upgrade
HealGunUpgrade.upgradeTechId = kTechId.HealGun 	    						// TechId of the upgrade, default is kTechId.Move cause its the first entry
HealGunUpgrade.hudSlot 		= kWelderHUDSlot								// Is this a primary weapon?
HealGunUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Welder_Active.dds")
HealGunUpgrade.vidDesc		= "videos/Marines_Welder1.webm"
HealGunUpgrade.requirements	= { "medic","marine"}

function HealGunUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = HealGunUpgrade.cost
	self.upgradeName = HealGunUpgrade.upgradeName
	self.upgradeTitle = HealGunUpgrade.upgradeTitle
	self.upgradeDesc = HealGunUpgrade.upgradeDesc
	self.upgradeTechId = HealGunUpgrade.upgradeTechId
	self.hudSlot = HealGunUpgrade.hudSlot
	self.texture = HealGunUpgrade.texture
	self.vidDesc = HealGunUpgrade.vidDesc
	self.upgradeType = HealGunUpgrade.upgradeType
	self.requirements = HealGunUpgrade.requirements
	
end

function HealGunUpgrade:GetClassName()
	return "HealGunUpgrade"
end