//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'FocusUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
FocusUpgrade.cost 			= { 1, 1, 1 }                              			// Cost of the upgrade in upgrade points
FocusUpgrade.upgradeName 	= "focus"                     						// Text code of the upgrade if using it via console
FocusUpgrade.upgradeTitle 	= "UPGRADE_FOCUS_NAME"		           				// Title of the upgrade, e.g. Submachine Gun
FocusUpgrade.upgradeDesc 	= "UPGRADE_FOCUS_TIPDESC"							// Description of the upgrade
FocusUpgrade.upgradeTechId 	= kTechId.Bite										// TechId of the upgrade, default is kTechId.Move cause its the first entry
FocusUpgrade.minPlayerLevel = 5													// Controls whether this upgrade requires the recipient to be a minimum level
FocusUpgrade.rowOrder 		= 1													// Controls the horizontal position on the menu
FocusUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Focus_Active.dds")
FocusUpgrade.teamType 		= kCombatUpgradeTeamType.AlienTeam
FocusUpgrade.vidDesc 		= "videos/Aliens_Focus.webm"
FocusUpgrade.upgradeType 	= kCombatUpgradeTypes.Offense
FocusUpgrade.disallowedGameModes = { kCombatGameType.CombatCTF }

function FocusUpgrade:Initialize()

	CombatUpgrade.Initialize(self)
	
	self.cost = FocusUpgrade.cost
	self.upgradeName = FocusUpgrade.upgradeName
	self.upgradeTitle = FocusUpgrade.upgradeTitle
	self.upgradeDesc = FocusUpgrade.upgradeDesc
	self.upgradeTechId = FocusUpgrade.upgradeTechId
	self.minPlayerLevel = FocusUpgrade.minPlayerLevel
	self.rowOrder = FocusUpgrade.rowOrder
	self.texture = FocusUpgrade.texture
	self.teamType = FocusUpgrade.teamType
	self.vidDesc = FocusUpgrade.vidDesc
	self.upgradeType = FocusUpgrade.upgradeType
	self.disallowedGameModes = FocusUpgrade.disallowedGameModes
	
end

function FocusUpgrade:GetClassName()
	return "FocusUpgrade"
end

function FocusUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "Focus") and not player:isa("Spectator") then
		return "Entity needs Focus mixin"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function FocusUpgrade:GetLevelString(level, player)
	return "Increases all damage and healing by " .. FocusMixin.damageBoostPercentagePerLevel * level .. "%, but abilities cost"  .. FocusMixin.energyIncreasePercentagePerLevel * level .. "% more energy."
end

function FocusUpgrade:OnAdd(player, isReapply)
	player:SetFocusLevel(self:GetCurrentLevel())
end

function FocusUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You feel more focused!")
end

function FocusUpgrade:Reset(player)
	player:SetFocusLevel(0)
end

function FocusUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "Increased damage!" }
end