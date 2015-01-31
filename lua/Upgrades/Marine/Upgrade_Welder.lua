//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// WelderUpgrade.lua
						
class 'WelderUpgrade' (CombatWeaponUpgrade)

WelderUpgrade.cost	 		= { 1 }                           				// cost of the upgrade in points
WelderUpgrade.upgradeName 	= "welder"                       				// Text code of the upgrade if using it via console
WelderUpgrade.upgradeTitle 	= "WELDER"               						// Title of the upgrade, e.g. Submachine Gun
WelderUpgrade.upgradeDesc 	= "WELDER_TOOLTIP"	// Description of the upgrade
WelderUpgrade.upgradeTechId = kTechId.Welder 	    						// TechId of the upgrade, default is kTechId.Move cause its the first entry
WelderUpgrade.hudSlot 		= kWelderHUDSlot								// Is this a primary weapon?
WelderUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Welder_Active.dds")
WelderUpgrade.vidDesc		= "videos/Marines_Welder1.webm"
WelderUpgrade.requirements	= { "engineer"}

function WelderUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = WelderUpgrade.cost
	self.upgradeName = WelderUpgrade.upgradeName
	self.upgradeTitle = WelderUpgrade.upgradeTitle
	self.upgradeDesc = WelderUpgrade.upgradeDesc
	self.upgradeTechId = WelderUpgrade.upgradeTechId
	self.hudSlot = WelderUpgrade.hudSlot
	self.texture = WelderUpgrade.texture
	self.vidDesc = WelderUpgrade.vidDesc
	self.upgradeType = WelderUpgrade.upgradeType
	self.requirements = WelderUpgrade.requirements
	
end

function WelderUpgrade:GetClassName()
	return "WelderUpgrade"
end