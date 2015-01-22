// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\NetworkMessages_Client.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// See the Messages section of the Networking docs in Spark Engine scripting docs for details.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/InsightNetworkMessages_Client.lua")

function OnCommandPing(pingTable)

    local playerId, ping = ParsePingMessage(pingTable)    
    Scoreboard_SetPing(playerId, ping)
    
end

function OnCommandHitEffect(hitEffectTable)

    local position, doer, surface, target, showtracer, altMode, damage, direction = ParseHitEffectMessage(hitEffectTable)
    HandleHitEffect(position, doer, surface, target, showtracer, altMode, damage, direction)
    
end

// Show damage numbers for players.
function OnCommandDamage(damageTable)

    local target, amount, hitpos = ParseDamageMessage(damageTable)
    if target then
        Client.AddWorldMessage(kWorldTextMessageType.Damage, amount, hitpos, target:GetId())
    end
    
end

function OnCommandHitSound(hitSoundTable)

    local sound = ParseHitSoundMessage(hitSoundTable)
    HitSounds_PlayHitsound( sound )
    
end

function OnCommandAbilityResult(msg)

    // The server will send us this message to tell us an ability succeded.
    player = Client.GetLocalPlayer()
    if player:GetIsCommander() then
        player:OnAbilityResultMessage(msg.techId, msg.success, msg.castTime)
    end

end

function OnCommandScores(scoreTable)

    local status = kPlayerStatus[scoreTable.status]
    if scoreTable.status == kPlayerStatus.Hidden then
        status = "-"
    elseif scoreTable.status == kPlayerStatus.Dead then
        status = Locale.ResolveString("STATUS_DEAD")
    elseif scoreTable.status == kPlayerStatus.Evolving then
        status = Locale.ResolveString("STATUS_EVOLVING")
    elseif scoreTable.status == kPlayerStatus.Embryo then
        status = Locale.ResolveString("STATUS_EMBRYO")
    elseif scoreTable.status == kPlayerStatus.Commander then
        status = Locale.ResolveString("STATUS_COMMANDER")
    elseif scoreTable.status == kPlayerStatus.Exo then
        status = Locale.ResolveString("STATUS_EXO")
    elseif scoreTable.status == kPlayerStatus.GrenadeLauncher then
        status = Locale.ResolveString("STATUS_GRENADE_LAUNCHER")
    elseif scoreTable.status == kPlayerStatus.Rifle then
        status = Locale.ResolveString("STATUS_RIFLE")
	elseif scoreTable.status == kPlayerStatus.LMG then
        status = Locale.ResolveString("STATUS_LMG")
    elseif scoreTable.status == kPlayerStatus.Shotgun then
        status = Locale.ResolveString("STATUS_SHOTGUN")
    elseif scoreTable.status == kPlayerStatus.Flamethrower then
        status = Locale.ResolveString("STATUS_FLAMETHROWER")
	elseif scoreTable.status == kPlayerStatus.Cannon then
        status = Locale.ResolveString("STATUS_CANNON")
    elseif scoreTable.status == kPlayerStatus.Void then
        status = Locale.ResolveString("STATUS_VOID")
    elseif scoreTable.status == kPlayerStatus.Spectator then
        status = Locale.ResolveString("STATUS_SPECTATOR")
    elseif scoreTable.status == kPlayerStatus.Skulk then
        status = Locale.ResolveString("STATUS_SKULK")
    elseif scoreTable.status == kPlayerStatus.Gorge then
        status = Locale.ResolveString("STATUS_GORGE")
    elseif scoreTable.status == kPlayerStatus.Lerk then
        status = Locale.ResolveString("STATUS_LERK")
    elseif scoreTable.status == kPlayerStatus.Fade then
        status = Locale.ResolveString("STATUS_FADE")
    elseif scoreTable.status == kPlayerStatus.Onos then
        status = Locale.ResolveString("STATUS_ONOS")
	elseif scoreTable.status == kPlayerStatus.Assault then
		status = Locale.ResolveString("STATUS_ASSAULT")
	elseif scoreTable.status == kPlayerStatus.Medic then
		status = Locale.ResolveString("STATUS_MEDIC")
	elseif scoreTable.status == kPlayerStatus.Engineer then
		status = Locale.ResolveString("STATUS_ENGINEER")
	elseif scoreTable.status == kPlayerStatus.Scout then
		status = Locale.ResolveString("STATUS_SCOUT")
    elseif scoreTable.status == kPlayerStatus.SkulkEgg then
        status = Locale.ResolveString("SKULK_EGG")
    elseif scoreTable.status == kPlayerStatus.GorgeEgg then
        status = Locale.ResolveString("GORGE_EGG")
    elseif scoreTable.status == kPlayerStatus.LerkEgg then
        status = Locale.ResolveString("LERK_EGG")
    elseif scoreTable.status == kPlayerStatus.FadeEgg then
        status = Locale.ResolveString("FADE_EGG")
    elseif scoreTable.status == kPlayerStatus.OnosEgg then
        status = Locale.ResolveString("ONOS_EGG")
    end
    
    Scoreboard_SetPlayerData(scoreTable.clientId, scoreTable.entityId, scoreTable.playerName, scoreTable.teamNumber, scoreTable.score,
                             scoreTable.kills, scoreTable.deaths, math.floor(scoreTable.resources), scoreTable.isCommander, scoreTable.isRookie,
                             status, scoreTable.isSpectator, scoreTable.assists, scoreTable.clientIndex)
    
end

function OnCommandClearTechTree()
    ClearTechTree()
end

function OnCommandTechNodeBase(techNodeBaseTable)
    GetTechTree():CreateTechNodeFromNetwork(techNodeBaseTable)
end

function OnCommandTechNodeUpdate(techNodeUpdateTable)
    GetTechTree():UpdateTechNodeFromNetwork(techNodeUpdateTable)
end

function OnCommandOnResetGame()

    Scoreboard_OnResetGame()
    ResetLights()
    
end

function OnCommandDebugLine(debugLineMessage)
    DebugLine(ParseDebugLineMessage(debugLineMessage))
end

function OnCommandDebugCapsule(debugCapsuleMessage)
    DebugCapsule(ParseDebugCapsuleMessage(debugCapsuleMessage))
end

function OnCommandMinimapAlert(message)

    local player = Client.GetLocalPlayer()
    if player then
        player:AddAlert(message.techId, message.worldX, message.worldZ, message.entityId, message.entityTechId)
    end
    
end

function OnCommandCommanderNotification(message)

    local player = Client.GetLocalPlayer()
    if player:isa("Marine") then
        player:AddNotification(message.locationId, message.techId)
    end
    
end

kWorldTextResolveStrings = { }
kWorldTextResolveStrings[kWorldTextMessageType.Resources] = "RESOURCES_ADDED"
kWorldTextResolveStrings[kWorldTextMessageType.Resource] = "RESOURCE_ADDED"
kWorldTextResolveStrings[kWorldTextMessageType.Damage] = "DAMAGE_TAKEN"
function OnCommandWorldText(message)

    local messageStr = string.format(Locale.ResolveString(kWorldTextResolveStrings[message.messageType]), message.data)
    Client.AddWorldMessage(message.messageType, messageStr, message.position)
    
end

function OnCommandCommanderError(message)

    local messageStr = Locale.ResolveString(message.data)
    Client.AddWorldMessage(kWorldTextMessageType.CommanderError, messageStr, message.position)
    
end

function OnCommandJoinError(message)
    ChatUI_AddSystemMessage( Locale.ResolveString("JOIN_ERROR_TOO_MANY") )
end

function OnVoteConcedeCast(message)

    local text = string.format(Locale.ResolveString("VOTE_CONCEDE_BROADCAST"), message.voterName, message.votesMoreNeeded)
    ChatUI_AddSystemMessage(text)
    
end

function OnVoteEjectCast(message)

    local text = string.format(Locale.ResolveString("VOTE_EJECT_BROADCAST"), message.voterName, message.votesMoreNeeded)
    ChatUI_AddSystemMessage(text)
    
end

function OnTeamConceded(message)

    if message.teamNumber == kMarineTeamType then
        ChatUI_AddSystemMessage(Locale.ResolveString("TEAM_MARINES_CONCEDED"))
    else
        ChatUI_AddSystemMessage(Locale.ResolveString("TEAM_ALIENS_CONCEDED"))
    end
    
end

local function OnCommandCreateDecal(message)
    
    local normal, position, materialName, scale = ParseCreateDecalMessage(message)
    
    local coords = Coords.GetTranslation(position)
    coords.yAxis = normal
    
    local randomAxis = Vector(math.random() * 2 - 0.9, math.random() * 2 - 1.1, math.random() * 2 - 1)
    randomAxis:Normalize()
    
    coords.zAxis = randomAxis
    coords.xAxis = coords.yAxis:CrossProduct(coords.zAxis)
    coords.zAxis = coords.xAxis:CrossProduct(coords.yAxis)
    
    coords.xAxis:Normalize()
    coords.yAxis:Normalize()
    
    Shared.CreateTimeLimitedDecal(materialName, coords, scale)

end
Client.HookNetworkMessage("CreateDecal", OnCommandCreateDecal)

local function OnSetClientIndex(message)
    Client.localClientIndex = message.clientIndex
end
Client.HookNetworkMessage("SetClientIndex", OnSetClientIndex)

local function OnSetServerHidden(message)
    Client.serverHidden = message.hidden
end
Client.HookNetworkMessage("ServerHidden", OnSetServerHidden)

local function OnSetClientTeamNumber(message)
    Client.localClientTeamNumber = message.teamNumber
end
Client.HookNetworkMessage("SetClientTeamNumber", OnSetClientTeamNumber)

local function OnScoreUpdate(message)
    ScoreDisplayUI_SetNewScore(message.points, message.wasKill)
end
Client.HookNetworkMessage("ScoreUpdate", OnScoreUpdate)

local function OnMessageAutoConcedeWarning(message)

    local warningText = StringReformat(Locale.ResolveString("AUTO_CONCEDE_WARNING"), { time = message.time, teamName = message.team1Conceding and "Marines" or "Aliens" })
    ChatUI_AddSystemMessage(warningText)
    
end

local function OnCommandCameraShake(message)

    local intensity = ParseCameraShakeMessage(message)
    
    local player = Client.GetLocalPlayer()
    if player and player.SetCameraShake then
        player:SetCameraShake(intensity * 0.1, 5, 0.25)    
    end

end

function OnCommandUpdateUpgrade(msg)
    // The server will send us this message to tell us an ability succeded.
	local player = Client.GetLocalPlayer()
	local previousLevel = player:GetUpgradeLevel(msg.upgradeId)
    local success = player:SetUpgradeLevel(msg.upgradeId, msg.upgradeLevel, msg.timeLastBought)
	--Shared.Message("Received upgrade update for " .. player:GetUpgradeById(msg.upgradeId):GetUpgradeTitle() .. " to level " .. msg.upgradeLevel)
	-- if success then
		-- Client.SendNetworkMessage("ReceivedUpgrade", msg, true)
	-- end
	if g_buyMenu ~= nil and g_buyMenu:GetIsVisible() and msg.upgradeLevel > previousLevel then
		local upgrade = player:GetUpgradeById(msg.upgradeId)
		if upgrade:GetUpgradeName() == "skulk" or upgrade:GetUpgradeName() == "marine" then
			return
		end
		if upgrade:GetIsAtMaxLevel() then
			if player:isa("Alien") then
				StartSoundEffect(CombatClientEffects.kAlienBuyMenuMaxed)
			else
				StartSoundEffect(CombatClientEffects.kMarineBuyMenuMaxed)
			end
		else
			if player:isa("Alien") then
				StartSoundEffect(CombatClientEffects.kAlienBuyMenuUse)
			else
				StartSoundEffect(CombatClientEffects.kMarineBuyMenuUse)
			end
		end
	end
end

function OnCommandShowUpgradeEvent(msg)
    // The server will send us this message to tell us an ability succeded.
    local player = Client.GetLocalPlayer()
    player:SetLastPurchasedUpgrade(msg.upgradeId)
	if player.clientIndex == Client.localClientIndex then
		g_myResources = msg.newResources
	end
end

function OnCommandBuyFailed(msg)

    // The server will send us this message to tell us an ability failed.
    local player = Client.GetLocalPlayer()
	if Client then
		Shared.Message("Got Buy Failed Message!" .. msg.reason)
		if player:isa("Alien") then
			StartSoundEffect(CombatClientEffects.kAlienUpgradeFail)
		else
			StartSoundEffect(CombatClientEffects.kMarineUpgradeFail)
		end
	end

end

function OnCommandHardCapUpdate(message)

    // The server will send us this message to tell us it's finished sending any updates.
	local player = Client.GetLocalPlayer()
    player:UpdateHardCap(message.UpgradeId, message.HardCapScale, message.IsHardCapped, message.Count)

end

function OnCommandAnnouncerSound(message)

	local announcerSounds = GetAnnouncerSounds()
	local sound = announcerSounds[message.sound]
	Shared.Message("Received announcer sound" .. EnumToString(kAnnouncerEffects, message.sound))
	if sound then
		--Shared.Message("Sound Found - " .. sound)
		StartSoundEffect(sound)
	end
	
end

function OnCommandDevourEscape(message)

	local player = Client.GetLocalPlayer()
	player:DevourEscape()

end

Client.HookNetworkMessage("AutoConcedeWarning", OnMessageAutoConcedeWarning)

Client.HookNetworkMessage("Ping", OnCommandPing)
Client.HookNetworkMessage("HitEffect", OnCommandHitEffect)
Client.HookNetworkMessage("Damage", OnCommandDamage)
Client.HookNetworkMessage("HitSound", OnCommandHitSound)
Client.HookNetworkMessage("AbilityResult", OnCommandAbilityResult)
Client.HookNetworkMessage("JoinError", OnCommandJoinError)

// Do nothing when get the normal ns2 networkmessages, should save some performance
Client.HookNetworkMessage("ClearTechTree", function() end)
Client.HookNetworkMessage("TechNodeBase", function() end)
Client.HookNetworkMessage("TechNodeUpdate", function() end)

// Combat updates 
Client.HookNetworkMessage("UpdateUpgrade", OnCommandUpdateUpgrade)
Client.HookNetworkMessage("HardCapUpdate", OnCommandHardCapUpdate)
Client.HookNetworkMessage("BuyFailed", OnCommandBuyFailed)
Client.HookNetworkMessage("ShowUpgradeEvent", OnCommandShowUpgradeEvent)

// Devour escape
Client.HookNetworkMessage("DevourEscape", OnCommandDevourEscape)

// Announcers
Client.HookNetworkMessage("PlayAnnouncerSound", OnCommandAnnouncerSound)

Client.HookNetworkMessage("MinimapAlert", OnCommandMinimapAlert)
Client.HookNetworkMessage("CommanderNotification", OnCommandCommanderNotification)

Client.HookNetworkMessage("ResetGame", OnCommandOnResetGame)

Client.HookNetworkMessage("DebugLine", OnCommandDebugLine)
Client.HookNetworkMessage("DebugCapsule", OnCommandDebugCapsule)

Client.HookNetworkMessage("WorldText", OnCommandWorldText)
Client.HookNetworkMessage("CommanderError", OnCommandCommanderError)

Client.HookNetworkMessage("VoteConcedeCast", OnVoteConcedeCast)
Client.HookNetworkMessage("VoteEjectCast", OnVoteEjectCast)
Client.HookNetworkMessage("TeamConceded", OnTeamConceded)
Client.HookNetworkMessage("CameraShake", OnCommandCameraShake)

