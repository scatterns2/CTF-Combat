//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'ScanUpgrade' (CombatTimedUpgrade)

// Define these statically so we can easily access them without instantiating too.
ScanUpgrade.cost 			= { 1 }                              	// Cost of the upgrade in upgrade points
ScanUpgrade.upgradeName 	= "scan"	                     			// Text code of the upgrade if using it via console
ScanUpgrade.upgradeTitle 	= "SCAN"	               					// Title of the upgrade, e.g. Submachine Gun
ScanUpgrade.upgradeDesc 	= "SCAN_TOOLTIP"	// Description of the upgrade
ScanUpgrade.upgradeTechId 	= kTechId.Scan								// TechId of the upgrade, default is kTechId.Move cause its the first entry
ScanUpgrade.triggerInterval = { 17 } 								// Specify the timer interval (in seconds) per level.
ScanUpgrade.teamType 		= kCombatUpgradeTeamType.MarineTeam			// Team Type
ScanUpgrade.minPlayerLevel 	= 2											// Controls whether this upgrade requires the recipient to be a minimum level
ScanUpgrade.rowOrder 		= 0											// Controls the horizontal position on the menu
ScanUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Scan_Active.dds")
ScanUpgrade.vidDesc			= "videos/Marines_Scan.webm"
ScanUpgrade.compatibleWithExo = true
ScanUpgrade.disallowedGameModes = { kCombatGameType.Infection }
ScanUpgrade.hideUpgrade = false
ScanUpgrade.requirements		= {"engineer"}

function ScanUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.cost = ScanUpgrade.cost
	self.upgradeName = ScanUpgrade.upgradeName
	self.upgradeTitle = ScanUpgrade.upgradeTitle
	self.upgradeDesc = ScanUpgrade.upgradeDesc
	self.upgradeTechId = ScanUpgrade.upgradeTechId
	self.triggerInterval = ScanUpgrade.triggerInterval
	self.teamType = ScanUpgrade.teamType
	self.minPlayerLevel = ScanUpgrade.minPlayerLevel
	self.rowOrder = ScanUpgrade.rowOrder
	self.texture = ScanUpgrade.texture
	self.vidDesc = ScanUpgrade.vidDesc
	self.compatibleWithExo = ScanUpgrade.compatibleWithExo
	self.hideUpgrade = ScanUpgrade.hideUpgrade
	self.disallowedGameModes = ScanUpgrade.disallowedGameModes
	self.requirements = ScanUpgrade.requirements
end

function ScanUpgrade:GetClassName()
	return "ScanUpgrade"
end

function ScanUpgrade:GetTimerDescription(player)
	return "Lifeform scans will occur every "
end

function ScanUpgrade:OnTrigger(player)

	if player and player:GetIsAlive() then
		CreateEntity(Scan.kMapName, player:GetOrigin(), player:GetTeamNumber())
		StartSoundEffectAtOrigin(Observatory.kCommanderScanSound, player:GetOrigin())  
	end

end

function ScanUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "Scan every " .. self:GetTimerInterval() .. " seconds for Kharaa lifeforms." }
end