//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________
// GenericGamerules.lua

Script.Load("lua/TimerMixin.lua")
Script.Load("lua/bots/CombatBotManager.lua")

class 'GenericGamerules' (NS2Gamerules)

GenericGamerules.kMapName = "generic_gamerules"

local networkVars =
{
}

AddMixinNetworkVars(TimerMixin, networkVars)

if Server then
	
	// We need this here so that the new logic in NS2Gamerules is not called.
	function GenericGamerules:OnCreate()

		// COPIED THE LOGIC FROM NS2Gamerules.lua HERE!
        // Calls SetGamerules()
        Gamerules.OnCreate(self)

        self.sponitor = ServerSponitor()
        self.sponitor:Initialize(self)
        
        self.playerRanking = PlayerRanking()
        
        self.techPointRandomizer = Randomizer()
        self.techPointRandomizer:randomseed(Shared.GetSystemTime())
        
        // Create team objects
        self.team1 = self:BuildTeam(kTeam1Type)
        self.team1:Initialize(kTeam1Name, kTeam1Index)
        self.sponitor:ListenToTeam(self.team1)
        
        self.team2 = self:BuildTeam(kTeam2Type)
        self.team2:Initialize(kTeam2Name, kTeam2Index)
        self.sponitor:ListenToTeam(self.team2)
        
        self.worldTeam = ReadyRoomTeam()
        self.worldTeam:Initialize("World", kTeamReadyRoom)
        
        self.spectatorTeam = SpectatingTeam()
        self.spectatorTeam:Initialize("Spectator", kSpectatorIndex)
        
        self.gameInfo = Server.CreateEntity(GameInfo.kMapName)
        
        self:SetGameState(kGameState.NotStarted)
        
        self.allTech = false
        self.orderSelf = false
        self.autobuild = false
        self.teamsReady = false
        self.tournamentMode = false
        
        self:SetIsVisible(false)
        self:SetPropagate(Entity.Propagate_Never)
        
        // Track how much pres clients have when they switch a team or disconnect
        self.clientpres = {}
        
        self.justCreated = true
		// END OF COPIED LOGIC
		
		InitMixin(self, TimerMixin)
		
		self.overtime = false
		
		// Normalise any missing boolean values here.
		if self.isMarinevsMarine == nil then self.isMarinevsMarine = false end
		if self.isCompetitive == nil then self.isCompetitive = false end
		if self.rebalanceXp == nil then self.rebalanceXp = true end
		if self.lightsStartOff == nil then self.lightsStartOff = false end
		if self.powerPointsTakeDamage == nil then self.powerPointsTakeDamage = false end
		if self.startWithArmory == nil then self.startWithArmory = true end
		if self.startWithPhaseGate == nil then self.startWithPhaseGate = true end
		if self.startWithCommandChair == nil then self.startWithCommandChair = true end
		if self.startWithShift == nil then self.startWithShift = true end
		if self.startWithCrag == nil then self.startWithCrag = true end
		if self.startWithHive == nil then self.startWithHive = true end
		if self.startWithFlag == nil then self.startWithFlag = true end
		if self.commandStructuresTakeDamage == nil then self.commandStructuresTakeDamage = true end
		
		local gameInfo = GetGamerulesInfo()
		gameInfo:SetIsMarinevsMarine(self.isMarinevsMarine)
		gameInfo:SetIsCompetitive(self.isCompetitive)
		gameInfo:SetGameType(self.combatGameType)
		gameInfo:SetLightsStartOff(self.lightsStartOff)
		gameInfo:SetPowerPointsTakeDamage(self.powerPointsTakeDamage)
		gameInfo:SetStartWithArmory(self.startWithArmory)
		gameInfo:SetStartWithArmory(self.startWithFlag)
		gameInfo:SetStartWithPhaseGate(self.startWithPhaseGate)
		gameInfo:SetStartWithCommandChair(self.startWithCommandChair)
		gameInfo:SetStartWithShift(self.startWithShift)
		gameInfo:SetStartWithCrag(self.startWithCrag)
		gameInfo:SetStartWithHive(self.startWithHive)
		gameInfo:SetStartWithFlag(self.startWithFlag)
		gameInfo:SetCommandStructuresTakeDamage(self.commandStructuresTakeDamage)
		gameInfo:SetIsInSuddenDeath(false)
		gameInfo:SetIsInOvertime(false)
		gameInfo:SetTimeLimit(self.timeLimit)
		
		self.numHumansConnected = 0
		
		Shared.Message("******************")
		Shared.Message("Server is running NS2:Combat // Build " .. kCombatVersion .. "!")
		Shared.Message("Current Game Mode: " .. self:GetGameModeName())
		Shared.Message("******************")
		
		if kCombatXPRebalanceEnabled and Server.GetIsRookieFriendly() and self.rebalanceXp then
			self:AddTimer("RebalanceXP", self, GenericGamerules.RebalanceXP, kCombatXPRebalanceInterval)
		end
		
		self:AddTimedCallback(GenericGamerules.UpdateUpgradeCounts, 1)
		self:AddTimedCallback(GenericGamerules.UpdateTeamScores, 0.1)
		self:AddTimedCallback(GenericGamerules.UpdateBots, 0.5)
		self:AddTimedCallback(GenericGamerules.UpdateSecurity, 0.2)
		self:AddTimedCallback(GenericGamerules.UpdateSeasonal, 5)
        
    end
	
	function GenericGamerules:OnGameStart()
	
	end
	
	function GenericGamerules:SetGameState(state)
	
		NS2Gamerules.SetGameState(self, state)
		
		if state == kGameState.Started then
			GetGamerulesInfo():SetGameStarted(true)
			self:OnGameStart()
		else
			GetGamerulesInfo():SetGameStarted(false)
		end
		
		if state == kGameState.NotStarted or state == kGameState.Countdown then
			for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
				if HasMixin(player, "Xp") then 
					player:ResetXp()
					player:ResetScores()
				end
			end
		end
		
	end
	
	function GenericGamerules:UpdateUpgradeCounts()	
	
        self.team1:UpdateUpgradeCounts()
		self.team2:UpdateUpgradeCounts()
		
		// Return true to keep the loop going.
		return true
		
	end
	
	function GenericGamerules:UpdateTeamScores()
		
		GetGamerulesInfo():SetTeamScores(self:GetTeamScores())
		
		-- Events that trigger based on team scores go here
		if self.OnUpdateTeamScores then
			self.OnUpdateTeamScores()
		end		
	
		// Return true to keep the loop going.
		return true
		
	end
	
	function GenericGamerules:UpdateSecurity()
	
		if gServerBots and #gServerBots > 0 then
			GetGamerulesInfo():SetHasHadBots(true)
		end
		
		if Shared.GetCheatsEnabled() then
			GetGamerulesInfo():SetHasHadCheats(true)
		end
		
		// Return true to keep the loop going.
		return true
	
	end
	
	function GenericGamerules:UpdateBots()
	
        CombatBotManager.UpdateBots()
		
		// Return true to keep the loop going.
		return true
	
	end
	
	function GenericGamerules:UpdateSeasonal()
	
		if self:GetGameState() == kGameState.Started then 
			Seasonal_CheckTime()
		end
	
		return true
	
	end
	
	function GenericGamerules:RebalanceXP()
		Shared.Message("Rebalancing XP...")
		for i, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
			player:AwardCatchUpXP()
		end
		
		return true
	end
	
	/**
     * Starts a new game by resetting the map and all of the players. Keep everyone on current teams (readyroom, playing teams, etc.) but 
     * respawn playing players.
     */
    function GenericGamerules:ResetGame()
    
        // speed back to normal
        Shared.ConsoleCommand("speed 1")
        self.overtime = false
        self.oneMinuteReminder = false
		
		// Reset bots
		CombatBotManager:ResetBots()
        
        // Reset timers
		if kCombatXPRebalanceEnabled and Server.GetIsRookieFriendly() and self.rebalanceXp then
			self:ResetTimer("RebalanceXP")
		end
        
        // call base class ResetGame
        NS2Gamerules.ResetGame(self)
		
		// Give players orders
		self:GiveAllPlayersStartingOrders()

    end       
    
    function GenericGamerules:GetWinnerStatus()
    	local statusMessage = ""
    	local team1Score, team2Score = self:GetTeamScores()
        	
    	if team1Score > team2Score then
        	statusMessage = "Marines are winning by " .. (team1Score - team2Score) .. "%"
    	elseif team1Score < team2Score then
        	statusMessage = "Aliens are winning by " .. (team2Score - team1Score) .. "%"
		else
			statusMessage = "Both teams are at " .. team1Score .. "%!"
    	end
    	
    	return statusMessage
    end
	
	function GenericGamerules:GetNumHumansConnected()
		return self.numHumansConnected
	end
	
	function GenericGamerules:GetNumHumansPlaying()
		local playersInGame = 0
		for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
		    local teamNumber = player:GetTeamNumber()
			if Server.GetOwner(player) ~= nil and (teamNumber == kTeam1Index or teamNumber == kTeam2Index) and not player:GetIsBot() then
				playersInGame = playersInGame + 1
			end
		end
		
		return playersInGame
	end
	
	// Override the game start condition. The games should start when both teams have players.
	function GenericGamerules:CheckGameStart()

		if self:GetGameState() == kGameState.NotStarted or self:GetGameState() == kGameState.PreGame then
			
			// Start pre-game when both teams have players or when once side does if cheats are enabled
			local team1Players = self.team1:GetNumPlayers()
			local team2Players = self.team2:GetNumPlayers()
				
			if (team1Players > 0 and team2Players > 0) or (Shared.GetCheatsEnabled() and (team1Players > 0 or team2Players > 0)) then
				
				if self:GetGameState() == kGameState.NotStarted then
					self:SetGameState(kGameState.PreGame)
				end
					
			elseif self:GetGameState() == kGameState.PreGame then
				self:SetGameState(kGameState.NotStarted)
			end
				
		end
        
    end
	
	local kMarineStartingUps = {}
	table.insert(kMarineStartingUps, "marine") 
	
	function GenericGamerules:GetMarineStartingUpgrades()
		return kMarineStartingUps
	end
	
	local kAlienStartingUps = {}
	table.insert(kAlienStartingUps, "skulk") 
	
	function GenericGamerules:GetAlienStartingUpgrades()
		return kAlienStartingUps
	end
    
	// Spawn protection
	function GenericGamerules:JoinTeam(player, newTeamNumber, force)
	
		local success, newPlayer = NS2Gamerules.JoinTeam(self, player, newTeamNumber, force)
		
		if success then
		
			//set spawn protect
			if HasMixin(newPlayer, "SpawnProtect") then
				newPlayer:SetSpawnProtect()
			end
			
			// Give players orders
			self:GivePlayerStartingOrders(newPlayer)
			
		end
		
		return success, newPlayer
	
	end
	
	function GenericGamerules:OnInitialSpawn(player, teamNumber)
	
	end
	// Make sure to override these in your child class
	function GenericGamerules:GetGameModeName()
		return "No mode name"
	end
	
	// Note use of a table of messages here.
	function GenericGamerules:GetGameModeText()
		return { "No mode description" }
	end
	
	// Send a message to players when they connect.
	function GenericGamerules:OnClientConnect(client)

		NS2Gamerules.OnClientConnect(self, client)
		local player = client:GetControllingPlayer()
		
		// Give the player the average XP of all players on the server.
    	if self:GetGameStarted() then
			player:GiveAvgXpOnJoinTeam(true)
			local avgXp = self:GetCatchupXp()
			// Send the avg as a message to the player (%d doesn't work with SendDirectMessage)
			if avgXp > 0 then
		    		player:SendDirectMessage("You joined the game late... you will get some free XP when you join a team!")
        	end
        end
		
		if not client:GetIsVirtual() then
			self.numHumansConnected = self.numHumansConnected + 1
		end
		
		self:SendGameInfoMessage(player)
		
	end
	
	function GenericGamerules:SendGameInfoMessage(player)
	
		player:BuildAndSendDirectMessage("Current Game Mode: " .. self:GetGameModeName())
		for index, message in ipairs(self:GetGameModeText()) do
			player:BuildAndSendDirectMessage(message)
		end
		
	end
	
	// We may need to add some more logic here.
	function GenericGamerules:OnClientDisconnect(client)
		if not client:GetIsVirtual() then
			self.numHumansConnected = self.numHumansConnected - 1
		end
	
		NS2Gamerules.OnClientDisconnect(self, client)
	end
	
	// Useful for locking the command chairs on game start.
	function GenericGamerules:LockCommandChairs()
	
		for index, commandStructure in ientitylist(Shared.GetEntitiesWithClassname("CommandStructure")) do
			commandStructure:LockCommandChair()
		end
	
	end
	
	// Reveal the command chair locations with this.
	function GenericGamerules:RevealCommandChairLocations()
	
		for index, commandStructure in ientitylist(Shared.GetEntitiesWithClassname("CommandStructure")) do
			commandStructure:RevealObjective()
		end
	
	end
	
	function GenericGamerules:AllowOvertime()
	    return false
	end
	
	function GenericGamerules:GetCatchupXp(ignorePlayer)

		local avgXp = 0
		local numPlayers = 0
		for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
			if player ~= ignorePlayer and 
				(player:GetTeamNumber() == kTeam1Index or player:GetTeamNumber() == kTeam2Index) and 
				HasMixin(player, "Xp") then
				local playerXp = player:GetXp()
				avgXp = avgXp + playerXp
				numPlayers = numPlayers + 1
			end
		end
		avgXp = avgXp / numPlayers
		local catchupXp = avgXp * .5
    	return math.floor(catchupXp)
    
    end
	
	function GenericGamerules:GetTeamCommandStructures()
	
		local team1Structure = nil
		local team2Structure = nil
		
		for index, commandStructure in ientitylist(Shared.GetEntitiesWithClassname("CommandStructure")) do
			if commandStructure:GetTeamNumber() == kTeam1Index then
				team1Structure = commandStructure
			elseif commandStructure:GetTeamNumber() == kTeam2Index then
				team2Structure = commandStructure
			end
		end
		
		return team1Structure, team2Structure
		
	end
	
	function GenericGamerules:GetTeamScores()
	
		local team1Health = 100
		local team2Health = 100
		local team1Armor = 100
		local team2Armor = 100
		if GetGamerulesInfo():GetGameStarted() then
			local team1Structure, team2Structure = self:GetTeamCommandStructures()
			if team1Structure then
				team1Health = team1Structure:GetHealthFraction() * 100
				team1Health = math.ceil(team1Health)
				team1Armor = team1Structure:GetArmorFraction() * 100
				team1Armor = math.ceil(team1Armor)
			else
				team1Health = 0
				team1Armor = 0
			end
			
			if team2Structure then
				team2Health = team2Structure:GetHealthFraction() * 100
				team2Health = math.ceil(team2Health)
				team2Armor = team2Structure:GetArmorFraction() * 100
				team2Armor = math.ceil(team2Armor)
			else
				team2Health = 0
				team2Armor = 0
			end
		end
		return team1Health, team2Health, team1Armor, team2Armor
		
	end
	
	
	function GenericGamerules:GiveAllPlayersStartingOrders()
	
		local team1Structure, team2Structure = self:GetTeamCommandStructures()
		
		for i, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
		
			self:GivePlayerStartingOrders(player, team1Structure, team2Structure)
			
		end
	
	end
	
	function GenericGamerules:GivePlayerStartingOrders(player, team1Structure, team2Structure)
	
		if team1Structure == nil then
			team1Structure, team2Structure = self:GetTeamCommandStructures()
		end
				
		local commandStructure = nil
		if player:GetTeamNumber() == kTeam1Index then
			commandStructure = team2Structure
		elseif player:GetTeamNumber() == kTeam2Index then
			commandStructure = team1Structure
		end
		
		if commandStructure ~= nil and player:GetIsAlive() and not player:GetIsBot() then
			local origin = commandStructure:GetOrigin()
			player:GiveOrder(kTechId.Attack, commandStructure:GetId(), origin, nil, nil)
		end
			
	end

end

Shared.LinkClassToMap("GenericGamerules", GenericGamerules.kMapName, networkVars)