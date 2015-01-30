//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'InkUpgrade' (CombatTimedUpgrade)

// Define these statically so we can easily access them without instantiating too.
InkUpgrade.cost = { 2 }                              				// Cost of the upgrade in upgrade points
InkUpgrade.levels = 3												// How many levels are there to this upgrade
InkUpgrade.upgradeName 		= "ink"                     			// Text code of the upgrade if using it via console
InkUpgrade.upgradeTitle 	= "INK"									// Title of the upgrade, e.g. Submachine Gun
InkUpgrade.upgradeDesc 		= "UPGRADE_INK_TIPDESC"	// Description of the upgrade
InkUpgrade.upgradeTechId 	= kTechId.ShadeInk						// TechId of the upgrade, default is kTechId.Move cause its the first entry
InkUpgrade.triggerInterval	= { 20 } 								// Specify the timer interval (in seconds) per level.
InkUpgrade.teamType	 		= kCombatUpgradeTeamType.AlienTeam		// Team Type
InkUpgrade.minPlayerLevel 	= 7
InkUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_Ink_Active.dds")
InkUpgrade.vidDesc			= "videos/Aliens_Ink.webm"
InkUpgrade.upgradeType = kCombatUpgradeTypes.Defense

function InkUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.cost = InkUpgrade.cost
	self.levels = InkUpgrade.levels
	self.upgradeName = InkUpgrade.upgradeName
	self.upgradeTitle = InkUpgrade.upgradeTitle
	self.upgradeDesc = InkUpgrade.upgradeDesc
	self.upgradeTechId = InkUpgrade.upgradeTechId
	self.triggerInterval = InkUpgrade.triggerInterval
	self.teamType = InkUpgrade.teamType
	self.minPlayerLevel = InkUpgrade.minPlayerLevel
	self.texture = InkUpgrade.texture
	self.vidDesc = InkUpgrade.vidDesc
	self.upgradeType = InkUpgrade.upgradeType
	
end

function InkUpgrade:GetClassName()
	return "InkUpgrade"
end

function InkUpgrade:GetTimerDescription(player)
	return "Ink will be available every "
end

local function InkAvailable(self, player)
	player:SetInkAvailable(true)
	player:SendDirectMessage("Ink is available!")
	player:PauseTimer("InkUpgrade")
end

function InkUpgrade:CanApplyUpgrade(player)

	local baseText = CombatTimedUpgrade.CanApplyUpgrade(self, player)
	
	if baseText ~= "" then
		return baseText
	elseif not player:isa("Alien") then
		return "Player must be an Alien"
	else
		return ""
	end
end

function InkUpgrade:OnAdd(player, isReapply)
	CombatTimedUpgrade.OnAdd(self, player, isReapply)
	InkAvailable(self, player)
end

function InkUpgrade:OnTrigger(player)
	InkAvailable(self, player)
end