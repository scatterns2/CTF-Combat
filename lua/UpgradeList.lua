//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// UpgradeList.lua

// Detail about the different kinds of upgrades.
kAllCombatUpgrades = {}
kCombatUpgrade = {}
// Load utility functions
Script.Load("lua/Utility.lua")

// Load the upgrade base classes
Script.Load("lua/Upgrade.lua")
Script.Load("lua/UpgradeAlienClass.lua")
Script.Load("lua/UpgradeAlienAbility.lua")
Script.Load("lua/UpgradeMarineClass.lua")
Script.Load("lua/UpgradeAlien.lua")
Script.Load("lua/UpgradeUnlock.lua")
Script.Load("lua/UpgradeWeapon.lua")
Script.Load("lua/UpgradeTimed.lua")
Script.Load("lua/UpgradeDrop.lua")
Script.Load("lua/UpgradeTiedToLevel.lua")
Script.Load("lua/UpgradeResupplyableWeapon.lua")
Script.Load("lua/UpgradeBuildable.lua")

// Used to merge all values from one table into another.
local function RegisterNewUpgrades(newValuesTable)

	for index, value in ipairs(newValuesTable) do
		// Save the factions upgrades in a regular table
		// Don't register the base classes.
		local instantiatedUpgrade = _G[value]()
		instantiatedUpgrade:Initialize()
		if not instantiatedUpgrade:GetIsBaseUpgrade() then
			table.insert(kAllCombatUpgrades, value)
		end
	end

end

// build the upgrade list
local function BuildAllUpgrades()

    if #kAllCombatUpgrades == 0 then
        // load all upgrade files
        local upgradeFiles = { }
        local upgradeDirectory = "lua/Upgrades/"
        Shared.GetMatchingFileNames( upgradeDirectory .. "*.lua", true, upgradeFiles)

        for _, upgradeFile in pairs(upgradeFiles) do
            Script.Load(upgradeFile)      
        end
        
        // save all upgrades in a table
        kAllCombatUpgrades = {}
        RegisterNewUpgrades(Script.GetDerivedClasses("CombatAlienClassUpgrade"))
        RegisterNewUpgrades(Script.GetDerivedClasses("CombatMarineClassUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatAlienAbilityUpgrade"))
        RegisterNewUpgrades(Script.GetDerivedClasses("CombatAlienUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatWeaponUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatUnlockUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatTimedUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatDropUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatLevelTiedUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatResupplyableWeaponUpgrade"))
		RegisterNewUpgrades(Script.GetDerivedClasses("CombatBuildableUpgrade"))
		
		table.sort(kAllCombatUpgrades)
	
		for index, upgradeClass in ipairs(kAllCombatUpgrades) do
			local upgrade = _G[upgradeClass]()
			upgrade:Initialize()
			local serverOrClient = "(Predict)"
			if Server then
				serverOrClient = "(Server)"
			elseif Client then
				serverOrClient = "(Client)"
			end
			//Shared.Message(serverOrClient .. " Upgrade ID: " .. upgrade:GetId() .. " Title: " .. upgrade:GetUpgradeTitle())
		end
    end
    
end

if #kAllCombatUpgrades == 0 then
    BuildAllUpgrades()
end

class 'UpgradeList'

function UpgradeList:Initialize()
	self.UpgradeTable = {}
	
	for i, upgrade in ipairs(kAllCombatUpgrades) do
		local newUpgrade = _G[upgrade]()
		newUpgrade:Initialize()
		self.UpgradeTable[newUpgrade:GetId()] = newUpgrade
    end
	
	self:RebuildCacheTables()
end

function UpgradeList:RebuildCacheTables()

	// Build caches
	self.UpgradeNameCache = {}
	self.UpgradeClassNameCache = {}
	self.UpgradeTechIdCache = {}
	self.UpgradeSlotCache = {}
	for index, upgrade in ipairs(self:GetAllUpgrades()) do
		// These are simple caches
		self.UpgradeClassNameCache[upgrade:GetClassName()] = upgrade
		self.UpgradeNameCache[upgrade:GetUpgradeName()] = upgrade
		self.UpgradeTechIdCache[upgrade:GetUpgradeTechId()] = upgrade
		
		// This is a cache of value->table pairs
		local uniqueSlot = upgrade:GetUniqueSlot()
		if uniqueSlot then
		
			if self.UpgradeSlotCache[uniqueSlot] == nil then
				self.UpgradeSlotCache[uniqueSlot] = {}
			end
			
			local alreadyContains = false
			for	i,existingUpgrade in ipairs(self.UpgradeSlotCache[uniqueSlot]) do
				if existingUpgrade:GetId() == upgrade:GetId() then
					alreadyContains = true
					break
				end
			end
			if not alreadyContains then
				table.insert(self.UpgradeSlotCache[uniqueSlot], upgrade)
			end
		end
	end
	
end

function UpgradeList:GetUpgradeById(upgradeId)
    if upgradeId then
        return self.UpgradeTable[upgradeId]
    end
end

function UpgradeList:GetUpgradeByTechId(techId)
	if techId then
        local upgradeTemp = self.UpgradeTechIdCache[techId]
		local upgrade = self:GetUpgradeById(upgradeTemp:GetId())
		return upgrade
    end
end

function UpgradeList:GetUpgradeByClassName(upgradeClassName)
    if upgradeClassName then
        local upgradeTemp = self.UpgradeClassNameCache[upgradeClassName]
		local upgrade = self:GetUpgradeById(upgradeTemp:GetId())
		return upgrade
    end
end

function UpgradeList:GetUpgradeByName(upgradeName)
    if upgradeName then
        local upgradeTemp = self.UpgradeNameCache[upgradeName]
		if upgradeTemp then
			local upgrade = self:GetUpgradeById(upgradeTemp:GetId())
			return upgrade
		end
    end
end

function UpgradeList:GetUpgradesBySlot(upgradeSlot)
	local upgradeSlotList = {}

    if upgradeSlot and self.UpgradeSlotCache[upgradeSlot] then
        return self.UpgradeSlotCache[upgradeSlot]
    end
	
	return upgradeSlotList
end


function UpgradeList:GetAvailableUpgradesByType(playerTeamNumber, upgradeType)
	local upgradeClassList = {}

    if upgradeType then
        for upgradeId, upgrade in ipairs(self:GetAvailableUpgrades(playerTeamNumber)) do
            if upgradeType == upgrade:GetUpgradeType() then
                table.insert(upgradeClassList, upgrade)
            end
        end
    end
	
	return upgradeClassList
end

function UpgradeList:GetAllUpgrades()
	return self.UpgradeTable
end

function UpgradeList:SetUpgradeLevel(upgradeId, upgradeLevel, timeLastBought)
	local upgrade = self:GetUpgradeById(upgradeId)
	local success = false
	if upgrade then
		upgrade:SetLevel(upgradeLevel)
		upgrade:SetTimeLastBought(timeLastBought)
		success = true
	end
	return success	
end

function UpgradeList:GetHasUpgrade(upgradeId)
	local upgrade = self:GetUpgradeById(upgradeId)
	if upgrade and upgrade:GetCurrentLevel() > 0 then
		return true
	else
		return false
	end
end

function UpgradeList:GetHasUpgradeTechId(techId)
	local upgrade = self:GetUpgradeByTechId(techId)
	if upgrade and upgrade:GetCurrentLevel() > 0 then
		return true
	else
		return false
	end
end

function UpgradeList:GetHasUpgradeByName(upgradeName)
	local upgrade = self:GetUpgradeByName(upgradeName)
	if upgrade and upgrade:GetCurrentLevel() > 0 then
		return true
	else
		return false
	end
end

function UpgradeList:GetUpgradeLevel(upgradeId)
	local upgrade = self:GetUpgradeById(upgradeId)
	if upgrade then 
		return upgrade:GetCurrentLevel()
	else
		return 0
	end
end

function UpgradeList:GetHasPrerequisites(upgrade, list)
	local requirements = upgrade:GetRequirements()
	if #requirements == 0 then return true end
	if list == nil then
		for index, requirement in ipairs(requirements) do
			local requirementUpgrade = self:GetUpgradeByName(requirement)
			if requirementUpgrade and requirementUpgrade:GetCurrentLevel() > 0 then
				return true
			end
		end
	else
		for index, requirement in ipairs(requirements) do
			local requirementUpgrade = self:GetUpgradeByName(requirement)
			if requirementUpgrade then
				local requirementId = requirementUpgrade:GetId()
				for i, upgradeInList in pairs(list) do
					if upgradeInList:GetId() == requirementId then
						return true
					end
				end
			end
		end
	end
	return false
end

function UpgradeList:GetMissingReqsMessage(upgrade)
	local missingReqs = self:GetMissingPrerequisites(upgrade)
	if not missingReqs[1] then return end
	
	local title = missingReqs[1]:GetUpgradeTitle():lower()
	local aAn = "a"
	if title[1] == "a" or title[1] == "e" or title[1] == "i" or title[1] == "o" or title[1] == "u" or title[1] == "y" then
		aAn = "an"
	end
	local message =  "Must be " .. aAn .. " "
	for i, v in ipairs(missingReqs) do
		if i == #missingReqs then
			if i == 1 then
				message = message .. v:GetUpgradeTitle()
			else
				message = message .. "or " .. v:GetUpgradeTitle()
			end
		else
			message = message .. v:GetUpgradeTitle()
			if #missingReqs == 2 then
				message = message .. " "
			else
				message = message .. ", "
			end
		end
	end
	
	return message
end

function UpgradeList:GetMissingPrerequisites(upgrade)
	local requirements = upgrade:GetRequirements()
	local missingReqs = {}
	for index, requirement in ipairs(requirements) do
		local reqUpgrade = self:GetUpgradeByName(requirement)

		if reqUpgrade and not self:GetHasUpgrade(reqUpgrade:GetId()) then
			table.insert(missingReqs, reqUpgrade)
		end
	end
	return missingReqs
end

// Cache these values as they don't change during the game.
local kAvailableUpgradesCache = {}
function UpgradeList:GetAvailableUpgrades(playerTeamNumber)
	
	local lookupKey = "Team"..playerTeamNumber
	
	if kAvailableUpgradesCache[lookupKey] == nil then
	
		local availableUpgrades = {}
		
		for index, upgrade in ipairs(self:GetAllUpgrades()) do
			if  upgrade:GetIsAllowedForTeam(playerTeamNumber) then
				
				table.insert(availableUpgrades, upgrade)
			end
		end
		
		kAvailableUpgradesCache[lookupKey] = availableUpgrades
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return kAvailableUpgradesCache[lookupKey]
end

// Get all the upgrades which are tied to the player's level and automatically increase.
// Cache these values as they don't change during the game.
local kCombatLevelTiedUpgradesCache = {}
function UpgradeList:GetCombatLevelTiedUpgrades(playerTeamNumber)
	
	local lookupKey = "Team"..playerTeamNumber
	
	if kCombatLevelTiedUpgradesCache[lookupKey] == nil then
		local levelTiedUpgrades = {}
		
		for upgradeId, upgrade in pairs(self:GetAvailableUpgrades(playerTeamNumber)) do
		
			if  upgrade:GetIsTiedToPlayerLvl() then
				
				table.insert(levelTiedUpgrades, upgrade)
				
			end
			
		end
		
		kCombatLevelTiedUpgradesCache[lookupKey] = levelTiedUpgrades
	end
	
	return kCombatLevelTiedUpgradesCache[lookupKey]
end

function UpgradeList:GetActiveUpgrades()
	local activeUpgrades = {}
	for index, upgrade in ipairs(self:GetAllUpgrades()) do
		if upgrade:GetCurrentLevel() > 0 then
			table.insert(activeUpgrades, upgrade)
		end
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return activeUpgrades
end

// Copy the data and the caches
function UpgradeList:CopyUpgradeDataFrom(cloneList)
	if cloneList then
		table.clear(self.UpgradeTable)
		self.UpgradeTable = Table_deepcopy(cloneList.UpgradeTable, self.UpgradeTable)
		table.clear(cloneList.UpgradeTable)
		
		self:RebuildCacheTables()
	end
end

function UpgradeList:GetActiveUpgrades()
	local activeUpgrades = {}
	for index, upgrade in ipairs(self:GetAllUpgrades()) do
		if upgrade:GetCurrentLevel() > 0 then
			table.insert(activeUpgrades, upgrade)
		end
	end
	
	// TODO: Order these correctly by priority before returning to the user
	return activeUpgrades
end