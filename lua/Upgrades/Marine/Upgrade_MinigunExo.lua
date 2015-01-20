//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'MinigunExoUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
MinigunExoUpgrade.upgradeType 		= kCombatUpgradeTypes.Lifeform      		// The type of the upgrade
MinigunExoUpgrade.cost 				= { 5 }                              		// cost of the upgrade in points
MinigunExoUpgrade.upgradeName 		= "minigunexo"                     			// Text code of the upgrade if using it via console
MinigunExoUpgrade.upgradeTitle 		= "UPGRADE_MINIGUN_NAME"               			// Title of the upgrade, e.g. Submachine Gun
MinigunExoUpgrade.upgradeDesc 		= "UPGRADE_MINIGUN_TIPDESC"			// Description of the upgrade
MinigunExoUpgrade.upgradeTechId 	= kTechId.Exo							// TechId of the upgrade, default is kTechId.Move cause its the first entry
MinigunExoUpgrade.teamType 			= kCombatUpgradeTeamType.MarineTeam			// Team Type
MinigunExoUpgrade.minPlayerLevel 	= 11										// Controls whether this upgrade requires the recipient to be a minimum level
MinigunExoUpgrade.rowOrder 			= 0											// Controls the horizontal position on the menu
MinigunExoUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Exo_Active.dds")
MinigunExoUpgrade.mustBeNearTechPoint = true
MinigunExoUpgrade.uniqueSlot 		= kUpgradeUniqueSlot.Class
MinigunExoUpgrade.vidDesc			= "videos/Marines_MinigunExo.webm"
MinigunExoUpgrade.compatiblewithExo = true
MinigunExoUpgrade.rebuyCooldownTime = 60
MinigunExoUpgrade.requirements = {"marine", "minigunexo"}
MinigunExoUpgrade.disallowedGameModes = { kCombatGameType.Infection }
MinigunExoUpgrade.hideUpgrade  	= true

function MinigunExoUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.upgradeType = MinigunExoUpgrade.upgradeType
	self.cost = MinigunExoUpgrade.cost
	self.upgradeName = MinigunExoUpgrade.upgradeName
	self.upgradeTitle = MinigunExoUpgrade.upgradeTitle
	self.upgradeDesc = MinigunExoUpgrade.upgradeDesc
	self.upgradeTechId = MinigunExoUpgrade.upgradeTechId
	self.teamType = MinigunExoUpgrade.teamType
	self.minPlayerLevel = MinigunExoUpgrade.minPlayerLevel
	self.rowOrder = MinigunExoUpgrade.rowOrder
	self.texture = MinigunExoUpgrade.texture
	self.mustBeNearTechPoint = MinigunExoUpgrade.mustBeNearTechPoint
	self.uniqueSlot = MinigunExoUpgrade.uniqueSlot
	self.vidDesc = MinigunExoUpgrade.vidDesc
	self.compatiblewithExo = MinigunExoUpgrade.compatiblewithExo
	self.requirements = MinigunExoUpgrade.requirements
	self.rebuyCooldownTime = MinigunExoUpgrade.rebuyCooldownTime 
	self.disallowedGameModes = MinigunExoUpgrade.disallowedGameModes
	self.hideUpgrade = MinigunExoUpgrade.hideUpgrade
	
end

function MinigunExoUpgrade:GetClassName()
	return "MinigunExoUpgrade"
end

function MinigunExoUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Exo_mask.dds", ""
end

function MinigunExoUpgrade:CanApplyUpgrade(player)
	
	if player:isa("Exo") then
		return "You cannot switch between Exosuits!"
	end
    
	return CombatUpgrade.CanApplyUpgrade(self, player)
end

function MinigunExoUpgrade:OnAdd(player)
	if player.layout ~= "ClawMinigun" then
		local percent = player:GetLifePercent()
		local position = player:GetOrigin()
		
		local newPlayer = player:Replace(Exo.kMapName, player:GetTeamNumber(), false, nil, { layout = "ClawMinigun" })
		
		if not newPlayer:SpaceClearForEntity(position) then
			local newPlayerExtents = LookupTechData(newPlayer:GetTechId(), kTechDataMaxExtents)
			local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(newPlayerExtents) 
			position = GetRandomSpawnForCapsule(newPlayerExtents.y, capsuleRadius, newPlayer:GetModelOrigin(), 0.5, 5)
		end
		
		newPlayer:SetOrigin(position)
		newPlayer:SetArmor(newPlayer:GetMaxArmor() * percent)
		newPlayer:ReapplyUpgrades()
		
		return newPlayer
	end
end

function MinigunExoUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = self:GetUpgradeTitle() .. " equipped!" }
end

function MinigunExoUpgrade:CausesEntityChange()
	return true
end

function MinigunExoUpgrade:GetRespawnExtraValues()
	return { layout = "ClawMinigun" }
end