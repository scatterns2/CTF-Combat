//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'EMPUpgrade' (CombatTimedUpgrade)

// Define these statically so we can easily access them without instantiating too.
EMPUpgrade.cost 			= { 1, 1, 1 }                              		// Cost of the upgrade in upgrade points
EMPUpgrade.levels 			= 3												// How many levels are there to this upgrade
EMPUpgrade.upgradeName 		= "emp"                     					// Text code of the upgrade if using it via console
EMPUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_EMP"               							// Title of the upgrade, e.g. Submachine Gun
EMPUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_EMP_TOOLTIP"					// Description of the upgrade
EMPUpgrade.upgradeTechId 	= kTechId.MACEMP								// TechId of the upgrade, default is kTechId.Move cause its the first entry
EMPUpgrade.triggerInterval 	= { 12, 10, 8 } 								// Specify the timer interval (in seconds) per level.
EMPUpgrade.teamType 		= kCombatUpgradeTeamType.MarineTeam				// Team Type
EMPUpgrade.minPlayerLevel 	= 10											// Controls whether this upgrade requires the recipient to be a minimum level
EMPUpgrade.rowOrder 		= 0												// Controls the horizontal position on the menu
EMPUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Reload_Active.dds")
EMPUpgrade.hideUpgrade  	= true
EMPUpgrade.vidDesc			= "videos/Marines_PulseGrenade.webm"
EMPUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Pulse.dds"
EMPUpgrade.requirements		= {"engineer"}

function EMPUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.cost = EMPUpgrade.cost
	self.levels = EMPUpgrade.levels
	self.upgradeName = EMPUpgrade.upgradeName
	self.upgradeTitle = EMPUpgrade.upgradeTitle
	self.upgradeDesc = EMPUpgrade.upgradeDesc
	self.upgradeTechId = EMPUpgrade.upgradeTechId
	self.triggerInterval = EMPUpgrade.triggerInterval
	self.teamType = EMPUpgrade.teamType
	self.minPlayerLevel = EMPUpgrade.minPlayerLevel
	self.rowOrder = EMPUpgrade.rowOrder
	self.texture = EMPUpgrade.texture
	self.hideUpgrade = EMPUpgrade.hideUpgrade
	self.vidDesc = EMPUpgrade.vidDesc
	self.detailImage = EMPUpgrade.detailImage
	self.requirements = EMPUpgrade.requirements
end

function EMPUpgrade:GetClassName()
	return "EMPUpgrade"
end

function EMPUpgrade:GetTimerDescription(player)
	return "EMP will be available every "
end

local function EMPAvailable(self, player)
	player:SetEMPAvailable(true)
	player:SendDirectMessage("EMP is available!")
	player:PauseTimer("EMPUpgrade")
end

function EMPUpgrade:CanApplyUpgrade(player)

	local baseText = CombatTimedUpgrade.CanApplyUpgrade(self, player)
	
	if baseText ~= "" then
		return baseText
	elseif not player:isa("Marine") and not player:isa("Exo") then
		return "Player needs to be a Marine or an Exo!"
	else
		return ""
	end
	
end

function EMPUpgrade:OnAdd(player, isReapply)
	CombatTimedUpgrade.OnAdd(self, player, isReapply)
	
	EMPAvailable(self, player)
end

function EMPUpgrade:OnTrigger(player)
	EMPAvailable(self, player)
end