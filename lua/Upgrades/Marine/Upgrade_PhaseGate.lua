//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// PhaseGateUpgrade.lua
						
class 'PhaseGateUpgrade' (CombatBuildableUpgrade)

PhaseGateUpgrade.cost 	 		= { 2 }                           			// cost of the upgrade in points
PhaseGateUpgrade.upgradeName  	= "phasegate"                       		// Text code of the upgrade if using it via console
PhaseGateUpgrade.upgradeTitle 	= "PHASE_GATE"               				// Title of the upgrade, e.g. Submachine Gun
PhaseGateUpgrade.upgradeDesc  	= "PHASE_GATE_TOOLTIP"			// Description of the upgrade
PhaseGateUpgrade.upgradeTechId 	= kTechId.PhaseGate 	    				// TechId of the upgrade, default is kTechId.Move cause its the first item
PhaseGateUpgrade.teamType 		= kCombatUpgradeTeamType.MarineTeam			// Team Type
PhaseGateUpgrade.minPlayerLevel = 5											// Controls whether this upgrade requires the recipient to be a minimum level
PhaseGateUpgrade.rowOrder 		= 0											// Controls the horizontal position on the menu
PhaseGateUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Phase_Active.dds")
PhaseGateUpgrade.vidDesc		= "videos/Marines_PhaseGate.webm"
PhaseGateUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Phase.dds"
PhaseGateUpgrade.requirements		= {"engineer"}

function PhaseGateUpgrade:Initialize()

	CombatBuildableUpgrade.Initialize(self)
	
	self.cost = PhaseGateUpgrade.cost
	self.upgradeName = PhaseGateUpgrade.upgradeName
	self.upgradeTitle = PhaseGateUpgrade.upgradeTitle
	self.upgradeDesc = PhaseGateUpgrade.upgradeDesc
	self.upgradeTechId = PhaseGateUpgrade.upgradeTechId
	self.teamType = PhaseGateUpgrade.teamType
	self.minPlayerLevel = PhaseGateUpgrade.minPlayerLevel
	self.rowOrder = PhaseGateUpgrade.rowOrder
	self.texture = PhaseGateUpgrade.texture
	self.vidDesc = PhaseGateUpgrade.vidDesc
	self.detailImage = PhaseGateUpgrade.detailImage
	self.requirements = PhaseGateUpgrade.requirements
end

function PhaseGateUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "MarineStructureUpgrade") and not player:isa("Spectator") then
		return "Entity needs MarineStructureUpgrade mixin"
	else
		return CombatBuildableUpgrade.CanApplyUpgrade(self, player)
	end
end

function PhaseGateUpgrade:OnAdd(player, isReapply)
	CombatBuildableUpgrade.OnAdd(self, player, isReapply)
	player:UpdatePhaseGateLevel(self:GetCurrentLevel())
end

function PhaseGateUpgrade:GetClassName()
	return "PhaseGateUpgrade"
end

function PhaseGateUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You can now build Phase Gates!")
end