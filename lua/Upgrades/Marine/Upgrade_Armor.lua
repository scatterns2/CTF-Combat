//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'ArmorUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
ArmorUpgrade.cost 			= { 1, 1, 1, 1, 1 }                           	-- cost of the upgrade in points
ArmorUpgrade.upgradeType 	= kCombatUpgradeTypes.Defense        			// the type of the upgrade
ArmorUpgrade.upgradeName 	= "armor"                     					-- Text code of the upgrade if using it via console
ArmorUpgrade.upgradeTitle	= "COMBAT_UPGRADE_ARMOR"               				// Title of the upgrade, e.g. Submachine Gun
ArmorUpgrade.upgradeDesc	= "COMBAT_UPGRADE_ARMOR_TOOLTIP"	// Description of the upgrade
ArmorUpgrade.upgradeTechId	= kTechId.Armor1								// TechId of the upgrade, default is kTechId.Move cause its the first entry
ArmorUpgrade.teamType 		= kCombatUpgradeTeamType.MarineTeam
ArmorUpgrade.minPlayerLevel = 1												// Controls whether this upgrade requires the recipient to be a minimum level
ArmorUpgrade.rowOrder 		= 0												// Controls the horizontal position on the menu
ArmorUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Armor_Active.dds")
ArmorUpgrade.vidDesc		= "videos/Marines_Armor.webm"
ArmorUpgrade.compatiblewithExo = true
ArmorUpgrade.requirements		= { "engineer","revolver" }

function ArmorUpgrade:Initialize()

	CombatUpgrade.Initialize(self)
	self.cost = ArmorUpgrade.cost
	self.upgradeType = ArmorUpgrade.upgradeType
	self.upgradeName = ArmorUpgrade.upgradeName
	self.upgradeTitle = ArmorUpgrade.upgradeTitle
	self.upgradeDesc = ArmorUpgrade.upgradeDesc
	self.teamType = ArmorUpgrade.teamType
	self.upgradeTechId = ArmorUpgrade.upgradeTechId
	self.minPlayerLevel = ArmorUpgrade.minPlayerLevel
	self.rowOrder = ArmorUpgrade.rowOrder
	self.texture = ArmorUpgrade.texture
	self.vidDesc = ArmorUpgrade.vidDesc
	self.compatiblewithExo = ArmorUpgrade.compatiblewithExo
	self.requirements = ArmorUpgrade.requirements
	
end

function ArmorUpgrade:GetClassName()
	return "ArmorUpgrade"
end

function ArmorUpgrade:GetLevelString(level, player)
	if player then
		local boost = ArmorUpgrade.marineBoostPerLevel
		if player:isa("Exo") then
			boost = ArmorUpgrade.exoBoostPerLevel
		end
		return GetTranslationString("COMBAT_UPGRADE_ARMOR_LEVEL", { maxArmor = (math.round(((player.GetOriginalMaxArmor and player:GetOriginalMaxArmor() or 30) * (1 + level*boost))/5) * 5) })
	else
		return GetTranslationString("COMBAT_UPGRADE_ARMOR_MAX", { maxArmor = ArmorUpgrade.marineBoostPerLevel })
	end
end

function ArmorUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "ArmorUpgrade") and not player:isa("Spectator") then
		return "Entity needs ArmorUpgrade mixin"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function ArmorUpgrade:OnAdd(player, isReapply)
	player.upgradeArmorLevel = self:GetCurrentLevel()
	player:UpgradeArmor()
end

function ArmorUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Armor upgraded to level " .. self:GetCurrentLevel())
	player:SendDirectMessage("New max armor is: " .. player:GetMaxArmor())
end