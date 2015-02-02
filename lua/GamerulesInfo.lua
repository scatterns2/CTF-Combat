//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// GamerulesInfo.lua

// Global gamerules accessors. When GamerulesInfo is initialized by map they should call SetGamerules(). 
globalGamerulesInfo = globalGamerulesInfo or nil

function GetHasGamerulesInfo()

    return globalGamerulesInfo ~= nil
	
end

function SetGamerulesInfo(GamerulesInfo)

    if GamerulesInfo ~= globalGamerulesInfo then
        globalGamerulesInfo = GamerulesInfo
    end
    
end

function GetGamerulesInfo()

    return globalGamerulesInfo
	
end

Script.Load("lua/Entity.lua")

class 'CombatGamerulesInfo' (Entity)

CombatGamerulesInfo.kMapName = "gamerules_info"

local networkVars =
{
	gameType = "enum kCombatGameType",
	isMarinevsMarine = "boolean",
	isCompetitive = "boolean",
	isInSuddenDeath = "boolean",
	isInOvertime = "boolean",
	lightsStartOff = "boolean",
	powerPointsTakeDamage = "boolean",
	startWithArmory = "boolean",
	startWithPhaseGate = "boolean",
	startWithCommandChair = "boolean",
	startWithCrag = "boolean",
	startWithShift = "boolean",
	startWithHive = "boolean",
	commandStructuresTakeDamage = "boolean",
	timeLimit = "time",
	gameStarted = "boolean",
	team1Score = "integer (0 to 65535)",
	team2Score = "integer (0 to 65535)",
	team1Armor = "integer (0 to 100)",
	team2Armor = "integer (0 to 100)",
	hasHadBots = "boolean",
	hasHadCheats = "boolean",
	startWithFlag = "boolean",
}

function CombatGamerulesInfo:OnCreate()
	// Set global gamerules info whenever gamerules info is built
	SetGamerulesInfo(self)
	self.isMapEntity = true
	self:Reset()
end

function CombatGamerulesInfo:Reset()
	self.isInSuddenDeath = false
	self.isInOvertime = false
	self.gameStarted = false
	self.hasHadBots = false
	self.hasHadCheats = false
end

if Server then
	function CombatGamerulesInfo:SetGameType(value)
		self.gameType = value
	end

	function CombatGamerulesInfo:SetIsCompetitive(value)
		self.isCompetitive = value
	end

	function CombatGamerulesInfo:SetIsMarinevsMarine(value)
		self.isMarinevsMarine = value
	end
	
	function CombatGamerulesInfo:SetIsInSuddenDeath(value)
		self.isInSuddenDeath = value
	end
	
	function CombatGamerulesInfo:SetTimeLimit(value)
		self.timeLimit = value
	end
	
	function CombatGamerulesInfo:SetLightsStartOff(value)
		self.lightsStartOff = value
	end
	
	function CombatGamerulesInfo:SetPowerPointsTakeDamage(value)
		self.powerPointsTakeDamage = value
	end
	
	function CombatGamerulesInfo:SetStartWithArmory(value)
		self.startWithArmory = value
	end
	
	function CombatGamerulesInfo:SetStartWithPhaseGate(value)
		self.startWithPhaseGate = value
	end
	
	function CombatGamerulesInfo:SetStartWithCommandChair(value)
		self.startWithCommandChair = value
	end

	function CombatGamerulesInfo:SetStartWithShift(value)
		self.startWithShift = value
	end

	function CombatGamerulesInfo:SetStartWithCrag(value)
		self.startWithCrag = value
	end
	
	function CombatGamerulesInfo:SetStartWithFlag(value)
		self.startWithFlag = value
	end

	function CombatGamerulesInfo:SetStartWithHive(value)
		self.startWithHive = value
	end
	
	function CombatGamerulesInfo:SetCommandStructuresTakeDamage(value)
		self.commandStructuresTakeDamage = value
	end
	
	function CombatGamerulesInfo:SetIsInOvertime(value)
		self.isInOvertime = value
	end
	
	function CombatGamerulesInfo:SetGameStarted(value)
		self.gameStarted = value
	end
	
	function CombatGamerulesInfo:SetTeamScores(newTeam1Health, newTeam2Health, newTeam1Armor, newTeam2Armor)
		self.team1Score = newTeam1Health
		self.team2Score = newTeam2Health
		self.team1Armor = newTeam1Armor
		self.team2Armor = newTeam2Armor
	end
	
	function CombatGamerulesInfo:SetHasHadBots(value)
		if not self.hasHadBots and value == true then
			//Shared.Message("WARNING: This game has had bots enabled. Stats and matchmaking are disabled until the next round starts.")
		end
		self.hasHadBots = value
	end
	
	function CombatGamerulesInfo:SetHasHadCheats(value)
		if not self.hasHadCheats and value == true then
			//Shared.Message("WARNING: This game has had cheats enabled. Stats and matchmaking are disabled until the next round starts.")
		end
		self.hasHadCheats = value
	end
end

function CombatGamerulesInfo:GetGameType()
	if self.gameType == nil then
		return kCombatGameType.CombatDeathmatch
	else
		return self.gameType
	end
end

function CombatGamerulesInfo:GetIsMarinevsMarine()
	return self.isMarinevsMarine
end

function CombatGamerulesInfo:GetIsCompetitive()
	return self.isCompetitive
end

function CombatGamerulesInfo:GetIsInSuddenDeath()
	return self.isInSuddenDeath
end

function CombatGamerulesInfo:GetIsInOvertime()
	return self.isInOvertime
end

function CombatGamerulesInfo:GetTimeLimit()
	return self.timeLimit
end

function CombatGamerulesInfo:GetLightsStartOff()
	return self.lightsStartOff
end

function CombatGamerulesInfo:GetStartWithFlag()
	return self.startWithFlag
end

function CombatGamerulesInfo:GetPowerPointsTakeDamage()
	return self.powerPointsTakeDamage
end

function CombatGamerulesInfo:GetStartWithArmory()
	return self.startWithArmory
end

function CombatGamerulesInfo:GetStartWithPhaseGate()
	return self.startWithPhaseGate
end

function CombatGamerulesInfo:GetStartWithCommandChair()
	return self.startWithCommandChair
end

function CombatGamerulesInfo:GetStartWithShift()
	return self.startWithShift
end

function CombatGamerulesInfo:GetStartWithCrag()
	return self.startWithCrag
end

function CombatGamerulesInfo:GetStartWithHive()
	return self.startWithHive
end

function CombatGamerulesInfo:GetCommandStructuresTakeDamage()
	return self.commandStructuresTakeDamage
end

function CombatGamerulesInfo:GetTimeSinceGameStart()
	if Server then
		return Shared.GetTime() - GetGamerules():GetGameStartTime()
	else
		return math.floor(Shared.GetTime()) - PlayerUI_GetGameStartTime()
	end
end

function CombatGamerulesInfo:GetTimeRemaining()
	if self.timeLimit == 0 then
		return -1
	else
		local timeLeft = self.timeLimit - self:GetTimeSinceGameStart()
		if timeLeft < 0 and kOvertimeLimit > 0 then
			timeLeft = self.timeLimit + kOvertimeLimit - self:GetTimeSinceGameStart()
		elseif timeLeft < 0 then
			timeLeft = 0
		end
		return timeLeft
	end
end

function CombatGamerulesInfo:GetTimeRemainingText()
	return GetTimeText(self:GetTimeRemaining())
end

function CombatGamerulesInfo:GetTimeRemainingDigital()
	return GetTimeDigital(self:GetTimeRemaining())
end

function CombatGamerulesInfo:GetTimeElapsedDigital()
	return GetTimeDigital(self:GetTimeSinceGameStart())
end

function CombatGamerulesInfo:GetGameStarted()
	return self.gameStarted
end

function CombatGamerulesInfo:GetTeamScores()
    return self.team1Score, self.team2Score, self.team1Armor, self.team2Armor
end

function CombatGamerulesInfo:GetHasHadBots(value)
	return self.hasHadBots
end

function CombatGamerulesInfo:GetHasHadCheats()
	return self.hasHadCheats
end

function CombatGamerulesInfo:GetIsMapEntity()
    return true
end

local cacheGetTeamType = { }
function CombatGamerulesInfo:GetTeamType(teamNumber)

    if not teamNumber then
        teamNumber = 0
    end

	local returnType = cacheGetTeamType[teamNumber]
	if returnType == nil then
	
		if teamNumber == kTeam1Index then
			returnType = kMarineTeamType
		elseif teamNumber == kTeam2Index then
			if self.isMarinevsMarine then
				returnType = kMarineTeamType
			else
				returnType = kAlienTeamType
			end
		else
			returnType = kNeutralTeamType
		end
	
		cacheGetTeamType[teamNumber] = returnType
	
	end
	
	return returnType
	
end
	
Shared.LinkClassToMap("CombatGamerulesInfo", CombatGamerulesInfo.kMapName, networkVars)