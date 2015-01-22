//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// Upgrade.lua

// Base class for all upgrades
class 'CombatUpgrade'

kCostsOn = true

// Offense = Upgrades for attacking.
// Defense = Upgrades that help defend, or improve survivability.
// Other = Anything that doesn't fit.
kCombatUpgradeTypes = enum({'Lifeform', 'Offense', 'Defense', 'Other', 'Structure'})
kFactionsTriggerTypes = enum({'NoTrigger', 'ByTime', 'ByKey'})
kCombatUpgradeTeamType = enum({'MarineTeam', 'AlienTeam', 'AnyTeam'})
kUpgradeUniqueSlot = enum({'None', 'Weapon1', 'Weapon2', 'Weapon3', 'Weapon4', 'Weapon5', 'Class', 'LessReloads' })
kClassImageSize = Vector(128, 128,0)

kAlienMaxColor = Color(1,.5,0,1)
kAlienCantBuyColor = Color(.1,.1,.1,1)
kMarineMaxColor = Color(0,.2,1,.5)
kMarineCantBuyColor = Color(.1,.1,.1,1)

kRefundPercentage = 1.0 // 0% is taken away from any refunded amount of upgrade points.

CombatUpgrade.upgradeType = kCombatUpgradeTypes.Other       	// The type of the upgrade
CombatUpgrade.triggerType = kFactionsTriggerTypes.NoTrigger  	// How the upgrade is gonna be triggered
CombatUpgrade.currentLevel = 0                               	// The default level of the upgrade. This is incremented when we buy the upgrade
CombatUpgrade.cost = { 1 }                                	// Cost of each level of the upgrade in xp
CombatUpgrade.upgradeName = "nil"                         	// Name of the upgrade as used in the console, e.g. smg
CombatUpgrade.upgradeTitle = "nil"                         	// Title of the upgrade, e.g. Submachine Gun
CombatUpgrade.upgradeDesc = "No description"                // Description of the upgrade
CombatUpgrade.upgradeTechId = kTechId.Move             		// Table of the techIds of the upgrade
CombatUpgrade.requirements = { "marine","medic","assault","engineer","scout", "jetpack", "railgunexo", "minigunexo", "skulk", "gorge", "lerk", "fade", "onos" }                        	// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
CombatUpgrade.permanent = true								// Controls whether you get the upgrade back when you respawn
CombatUpgrade.disallowedGameModes = { }						// Controls which game modes this applies to
CombatUpgrade.teamType = kCombatUpgradeTeamType.AnyTeam		// Controls which team type this applies to
CombatUpgrade.uniqueSlot = kUpgradeUniqueSlot.None			// Use this to specify that an upgrade occupies a unique slot. When you buy another upgrade in this slot you get a refund for any previous ones.
CombatUpgrade.mutuallyExclusive = false						// Cannot buy another upgrade in this slot when you have this one.
CombatUpgrade.hardCapScale = 0                               	// How many people of your team can max. take this upgrade, 1/5 for 1 upgrade per 5 player
CombatUpgrade.minPlayerLevel = 1								// Controls whether this upgrade requires the recipient to be a minimum level
CombatUpgrade.rowOrder = 0								// Controls how close to the inner circle the upgrade is displayed on its level row
CombatUpgrade.isLevelTied = false							// Upgrade is tied to player level
CombatUpgrade.texture  = ""									// How to draw this upgrade on the menu.
CombatUpgrade.mustBeNearTechPoint = false						// Only available near the tech point
CombatUpgrade.CompatibleWithExo = false
CombatUpgrade.isClassUpgrade = false						--Lifeforms, Marine and Exo are all classes
CombatUpgrade.imageSize = Vector(75, 75, 0)						--Lifeforms, Marine and Exo are all classes
CombatUpgrade.notLevelYetOverlay = "ui/buymenu/Icons/Icon_Overlay_Inactive.dds"
CombatUpgrade.missingPrereqOverlay = "ui/buymenu/Icons/Icon_Overlay_Restricted.dds"
CombatUpgrade.boughtOverlay = "ui/buymenu/Icons/Icon_Overlay_Bought.dds"
CombatUpgrade.rebuyCooldownTime = 0                     // cooldown in sec
CombatUpgrade.detailImage = ""
CombatUpgrade.mustBeNearArmory = false

function CombatUpgrade:Initialize()
	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "CombatUpgrade") then
		self.hideUpgrade = true
		self.baseUpgrade = true
	end
	self.upgradeType = CombatUpgrade.upgradeType
	self.triggerType = CombatUpgrade.triggerType
	self.currentLevel = CombatUpgrade.currentLevel
	self.cost = CombatUpgrade.cost
	self.upgradeName = CombatUpgrade.upgradeName
	self.upgradeTitle = CombatUpgrade.upgradeTitle
	self.upgradeDesc = CombatUpgrade.upgradeDesc
	self.upgradeTechId = CombatUpgrade.upgradeTechId
	self.requirements = CombatUpgrade.requirements
	self.permanent = CombatUpgrade.permanent
	self.disallowedGameModes = CombatUpgrade.disallowedGameModes
	self.teamType = CombatUpgrade.teamType
	self.uniqueSlot = CombatUpgrade.uniqueSlot
	self.mutuallyExclusive = CombatUpgrade.mutuallyExclusive
	self.hardCapScale = CombatUpgrade.hardCapScale
	self.isHardCapped = false
	self.teamCount = 0
	self.minPlayerLevel = CombatUpgrade.minPlayerLevel
	self.isLevelTied = CombatUpgrade.isLevelTied
	self.menuPositionX = CombatUpgrade.menuPositionX
	self.menuPositionY = CombatUpgrade.menuPositionY
	self.texture = CombatUpgrade.texture
	self.rowOrder = CombatUpgrade.rowOrder
	self.mustBeNearTechPoint = CombatUpgrade.mustBeNearTechPoint
	self.vidDesc = CombatUpgrade.vidDesc
	self.compatibleWithExo = false
	self.isClassUpgrade = CombatUpgrade.isClassUpgrade
	self.imageSize = CombatUpgrade.imageSize
	self.notLevelYetOverlay = CombatUpgrade.notLevelYetOverlay
	self.missingPrereqOverlay = CombatUpgrade.missingPrereqOverlay
	self.boughtOverlay = CombatUpgrade.boughtOverlay
	self.rebuyCooldownTime = CombatUpgrade.rebuyCooldownTime
	self.ignoreCooldown = false
	self.needsNetworkMessage = false
	self.timeLastBought = 0
	self.mustBeNearArmory = CombatUpgrade.mustBeNearArmory
	
end

function CombatUpgrade:GetIsBaseUpgrade()
	// Convert nil to false!
	if self.baseUpgrade then
		return true
	else
		return false
	end
end

function CombatUpgrade:GetHideUpgrade(upgradeList)
	// Convert nil to false!
	if self.hideUpgrade then
		return true
	else
		return false
	end
end

function CombatUpgrade:GetUpgradeType()
    return self.upgradeType
end

function CombatUpgrade:GetTriggerType()
    return self.triggerType
end

function CombatUpgrade:GetMaxLevels()
    return #self.cost
end

function CombatUpgrade:GetCurrentLevel()
    return self.currentLevel
end

function CombatUpgrade:GetNextLevel()
	if self:GetIsAtMaxLevel() then
		return self:GetMaxLevels()
	else
		return self.currentLevel + 1
	end
end

function CombatUpgrade:GetIsAtMaxLevel()
	return self.currentLevel == self:GetMaxLevels()
end

function CombatUpgrade:AddLevel()
	if self.currentLevel < self:GetMaxLevels() then
		self.currentLevel = self.currentLevel + 1
	end
end

function CombatUpgrade:SetLevel(newLevel)
	self.currentLevel = newLevel
end

function CombatUpgrade:GetOverlayTextures()
	local mask = ""
	local glow = ""
	if self.teamType == kCombatUpgradeTeamType.MarineTeam then
		mask = "ui/buymenu/Icons/Icon_Mask1_Active.dds"
		glow = "ui/buymenu/Icons/Icon_Mask1b_Active.dds"
	else	
		mask = "ui/buymenu/Icons/Icon_Mask2_Active.dds"
	end
	return mask, glow
end

function CombatUpgrade:ResetLevel()
	self.currentLevel = 0
end

function CombatUpgrade:GetCostForNextLevel(player, accountForRefunds)

	if self:GetIsAtMaxLevel() then
		return 9999
	else
		local baseCost = self:GetCost(self:GetNextLevel())
		if player and accountForRefunds then
			local refundAmount, refunds = self:GetRefunds(player)
			return baseCost - refundAmount
		else
			return baseCost
		end
	end
end

function CombatUpgrade:GetCompleteRefundAmount()
	local sum = 0
	for i, v in ipairs(self.cost) do
		if i > self:GetCurrentLevel() then
			break
		end
		if kCostsOn then
			sum = sum + v
		else
			sum = sum + 1
		end
	end
	return sum
end

function CombatUpgrade:GetCost(level)
	if level > self:GetMaxLevels() then
		return 9999
	elseif kCostsOn then
		return self.cost[level]
	else
		return 1
	end
end

function CombatUpgrade:GetUpgradeName()
	if self.upgradeName == "nil" or not self.upgradeName then
		return self:GetClassName()
	else
		return self.upgradeName
	end
end

function CombatUpgrade:GetVideoStructure()

	local url = "../../../" .. kCombatRootFolder .. "/output/" .. self.vidDesc
	
	local tip = {
					delaySecs = 0,
					videoUrl = url,
					volume = 0
				}
	return tip
end

function CombatUpgrade:GetUpgradeTitle()
	if Locale then 
		return GetTranslationString(self.upgradeTitle)
	else
		return self.upgradeTitle
	end
end

function CombatUpgrade:GetUpgradeDesc(player)

	local descString = ""
	if(self:GetMaxLevels() > 1) then
		local upLvl = self:GetCurrentLevel()
		if upLvl < self:GetMaxLevels() then
			descString = "Next Level: "
		end
		local descLevel = math.min(upLvl + 1, #self.cost)
		descString = descString .. self:GetLevelString(descLevel, player)
	else
		descString = Locale and GetTranslationString(self.upgradeDesc, {}) or self.upgradeDesc
	end
	
	return descString
	
end

function CombatUpgrade:GetLevelString(level, player)
	return "FILL " .. self:GetUpgradeTitle() .. "'s LEVEL DESCRIPTION FUNCTION OUT"
end

function CombatUpgrade:GetUpgradeTechId()
    return self.upgradeTechId
end

function CombatUpgrade:GetUpgradeMapName()
    return LookupTechData(self:GetUpgradeTechId(), kTechDataMapName)
end

function CombatUpgrade:GetIsPermanent()
	return self.permanent
end

function CombatUpgrade:GetRequirements()
	return self.requirements
end

function CombatUpgrade:GetUniqueSlot()
	return self.uniqueSlot
end

function CombatUpgrade:GetMinPlayerLevel()
	return self.minPlayerLevel
end

function CombatUpgrade:GetIsTiedToPlayerLvl()
	return self.isLevelTied
end

function CombatUpgrade:GetMenuPosition(absolute)
	
end

function CombatUpgrade:GetMustBeNearTechPoint()
	return self.mustBeNearTechPoint
end

function CombatUpgrade:GetHardCapScale()
	return self.hardCapScale
end

function CombatUpgrade:SetHardCapScale(newValue)
	self.hardCapScale = newValue
end

function CombatUpgrade:GetIsHardCapped()
	return self.isHardCapped
end

function CombatUpgrade:SetIsHardCapped(newValue)
	self.isHardCapped = newValue
end

function CombatUpgrade:GetTeamCount()
	return self.teamCount
end

function CombatUpgrade:SetTeamCount(newValue)
	self.teamCount = newValue
end

function CombatUpgrade:GetIsMutuallyExclusive()
	return self.mutuallyExclusive
end

function CombatUpgrade:GetDisallowedGameModes()
	return self.disallowedGameModes
end

function CombatUpgrade:GetIsAllowedForThisGameMode()

	for index, gamemode in ipairs(self.disallowedGameModes) do
		if GetGamerulesInfo():GetGameType() == gamemode then
			return false
		end
	end
	
	return true
end

function CombatUpgrade:GetTeamType()
	return self.teamType
end

function CombatUpgrade:GetIsAllowedForTeam(teamNumber)

	local playerTeamType = GetGamerulesInfo():GetTeamType(teamNumber)
	
	if  ((self.teamType == kCombatUpgradeTeamType.MarineTeam and playerTeamType == kMarineTeamType)
		or 
		(self.teamType == kCombatUpgradeTeamType.AlienTeam and playerTeamType == kAlienTeamType)
		or
		(self.teamType == kCombatUpgradeTeamType.AnyTeam)
		or 
		(self.teamType == nil)) then
		return true
	else
		return false
	end
end

if kCombatUpgradeIdCache == nil then
	kCombatUpgradeIdCache = {}
end

// Implement caching to speed up this function call.
function CombatUpgrade:GetId()
	local cachedId = kCombatUpgradeIdCache[self:GetClassName()]
	
	if cachedId == nil then
		for index, upgradeName in ipairs(kAllCombatUpgrades) do
			if upgradeName == self:GetClassName() then
				kCombatUpgradeIdCache[self:GetClassName()] = index
				cachedId = index
			end
		end
	end
	
	return cachedId
end

// IMPORTANT! Override this in every derived class...
// I think that NS2 should fill these in for us but for some reason it isn't...
function CombatUpgrade:GetClassName()
	return "CombatUpgrade"
end

function CombatUpgrade:GetHasRoomToUpgrade(player)
	return true
end

// Check for any prerequisite mixins etc here.
function CombatUpgrade:CanApplyUpgrade(player)
	if player:isa("Spectator") then
		return "Player must not be a spectator"
	elseif not player:GetIsAlive() then
		return "Player must be alive"
	elseif player:GetHasPrerequisites(self) then
		return ""
	else
		return player.UpgradeList:GetMissingReqsMessage(self)
	end
end

// Called from the UpgradeMixin when the upgraded is added to a player, old upgradeFunc
// Use this to perform a custom action on add.
function CombatUpgrade:OnAdd(player, isReapply)
end

function CombatUpgrade:SendAddMessage(player)
	// Provide a sensible default here
	player:SendDirectMessage("Purchased " .. self:GetCurrentLevel() .. " of the " .. self:GetUpgradeTitle() .. " upgrade.")
end

// called when the Player is resetted so we can reset all the changes the upgrade has made
function CombatUpgrade:Reset(player)
end

function CombatUpgrade:GetTexture()
	return self.texture
end

function CombatUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = self:GetUpgradeTitle() .. " unlocked!" }
end

function CombatUpgrade:GetEventTitle()
	if self:GetMaxLevels() > 1 then
		return self:GetUpgradeTitle() .. " Lv. " .. self:GetCurrentLevel()
	else
		return self:GetUpgradeTitle()
	end
end

function CombatUpgrade:GetIsClassUpgrade()
	return self.isClassUpgrade
end

function CombatUpgrade:GetImageSize()
	if self:GetUpgradeType() == kCombatUpgradeTypes.Lifeform then
		return kClassImageSize
	end
	return self.imageSize
end

--returns the amount you'll be refunded, plus all the upgrades that will be refunded if this upgrade is purchased
function CombatUpgrade:GetRefunds(player)
	
	local refund = 0
	local refundedUpgrades = {}

	--these are unique, so you shouldn't ever have more than one active in the slot
	local mutualUps = player:GetActiveUpgradesBySlot(self:GetUniqueSlot(), self:GetId())
	if #mutualUps > 1 then
		return refund, refundedUpgrades
	end
	if #mutualUps == 1 then
		local upgradeToBeReplaced = player:GetUpgradeById(mutualUps[1]:GetId())
		
		refund = refund + upgradeToBeReplaced:GetCompleteRefundAmount()
		
		local upsPotentiallyDependentOnReplaced = {}
		for i, up in pairs(player:GetActiveUpgrades()) do
			for j, req in pairs(up:GetRequirements()) do
				if req == upgradeToBeReplaced:GetUpgradeName() then
					table.insert(upsPotentiallyDependentOnReplaced, player:GetUpgradeById(up:GetId()))
				end
			end
		end
		
		local playerUpsAfterReplacement = {}
		for i, up in pairs(player:GetActiveUpgrades()) do
			if up:GetId() ~= upgradeToBeReplaced:GetId() then
				table.insert(playerUpsAfterReplacement, player:GetUpgradeById(up:GetId()))
			end
		end
		table.insert(playerUpsAfterReplacement, player:GetUpgradeById(self:GetId()))
		for i, upgrade in pairs(upsPotentiallyDependentOnReplaced) do
			if player:GetHasPrerequisites(upgrade, playerUpsAfterReplacement) then
				--this upgrade will still be available after the replacement
			else
				refund = refund + upgrade:GetCompleteRefundAmount()
				table.insert(refundedUpgrades, upgrade)
			end
		end
	end
	
	return refund, refundedUpgrades
end

function CombatUpgrade:GetCantBuyColor()
	if self.teamType == "MarineTeam" then
		return kMarineCantBuyColor
	else
		return kAlienCantBuyColor
	end
end

function CombatUpgrade:GetMaxColor()
	if self.teamType == "MarineTeam" then
		return kMarineMaxColor
	else
		return kAlienMaxColor
	end
end

function CombatUpgrade:GetRebuyCooldownTime()
	return self.rebuyCooldownTime
end

function CombatUpgrade:GetTimeLastBought()
	return self.timeLastBought
end

function CombatUpgrade:SetTimeLastBought(time)
	self.timeLastBought = time
end

function CombatUpgrade:SetCanIgnoreCoolDown(value)
	self.ignoreCooldown = value
end

function CombatUpgrade:GetCanIgnoreCoolDown()
	return true
end

function CombatUpgrade:GetRemainingCoolDown()
    if not self:GetCanIgnoreCoolDown() and self:GetRebuyCooldownTime() > 0 and self:GetTimeLastBought() > 0 then
        return math.max(0, self:GetTimeLastBought() + self:GetRebuyCooldownTime() - Shared.GetTime())
    else
        return 0
    end
end

function CombatUpgrade:GetDetailImage()
	return self.detailImage
end

function CombatUpgrade:NeedsNetworkMessage()
    return self.needsNetworkMessage
end

function CombatUpgrade:GetMustBeNearArmory()
	return self.mustBeNearArmory
end

function CombatUpgrade:CausesEntityChange()
	return false
end

function CombatUpgrade:GetRespawnExtraValues()
	return nil
end