//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// CombatCTFGamerules.lua

Script.Load("lua/GenericGamerules.lua")

class 'CombatCTFGamerules' (GenericGamerules)

CombatCTFGamerules.kMapName = "combatctf_gamerules"
CombatCTFGamerules.kDefaultTimeLimit = 0

local networkVars =
{
	timelimit = "time"
}

if Server then

	function CombatCTFGamerules:OnCreate()
	
		self.isCompetitive = true
		self.lightsStartOff = false
		self.powerPointsTakeDamage = true
		self.startWithArmory = true
		self.startWithPhaseGate = true
		self.startWithFlag = true
		self.startWithCommandChair = true
		self.startWithShift = true
		self.startWithCrag = true
		self.startWithHive = true
		self.commandStructuresTakeDamage = false
		self.combatGameType = kCombatGameType.CombatCTF
		self.timeLimit = CombatCTFGamerules.kDefaultTimeLimit
	
		GenericGamerules.OnCreate(self)
		
	end

	function CombatCTFGamerules:GetGameModeName()
		return "Combat CTF"
	end
	
	function CombatCTFGamerules:GetGameModeText()
		return { "Capture the Enemy Flag, Protect your own!" }
	end
	
    function CombatCTFGamerules:EndGame(winningTeam)
	    self.team1Won = nil
        self.team2Won = nil
        GenericGamerules.EndGame(self, winningTeam)
    end
	
	function CombatCTFGamerules:CheckGameEnd()
	
	    GenericGamerules.CheckGameEnd(self)
        if self:GetGameStarted() and self.timeGameEnded == nil and not Shared.GetCheatsEnabled() and not self.preventGameEnd then

            local time = Shared.GetTime()
            if not self.timeDrawWindowEnds or time < self.timeDrawWindowEnds then

                local team1Won = self.team1Won or self.team1:GetHasTeamWon()
                local team2Won = self.team2Won or self.team2:GetHasTeamWon()

                if team1Won or team2Won then
                    -- After a team has entered a win condition, they can not lose
                    self.team1Won = team1Won
                    self.team2Won = team2Won

                    -- Continue checking for a draw for kDrawGameWindow seconds
                    if not self.timeDrawWindowEnds then
                        self.timeDrawWindowEnds = time + kDrawGameWindow
                    end                          
                end
            else

                if self.team2Won and self.team1Won then
                    -- It's a draw
                    self:DrawGame() 
                elseif self.team1Won then
                    -- Still no draw after kDrawGameWindow, count the win
                    self:EndGame( self.team1 )
                elseif self.team2Won then
                    -- Still no draw after kDrawGameWindow, count the win
                    self:EndGame( self.team2 )                   
                end
            end
        end
    end

	function CombatCaptureGamerules:GetTeamScores()
	
		local team1Points = GetGamerules():GetTeam1():GetNumFlagsCaptured()
		local team2Points = GetGamerules():GetTeam2():GetNumFlagsCaptured()

		return team1Points, team2Points
		
	end
	
	function CombatCTFGamerules:ResetGame()
		
		GenericGamerules.ResetGame(self)
		
		// Lock the command chairs and reveal the objectives.
		self:RevealCommandChairLocations()
		self:LockCommandChairs()
		
	end
	
end

Shared.LinkClassToMap("CombatCTFGamerules", CombatCTFGamerules.kMapName, networkVars)