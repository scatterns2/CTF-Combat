// ======= Copyright (c) 2013, Unknown Worlds Entertainment, Inc. All rights reserved. ==========
//
// lua\ClientUI.lua
//
//    Created by:   Brian Cronin (brianc@unknownworlds.com)
//
// Creates and evaluates validity of UI scripts on the Client.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

ClientUI = { }

// Below are the rules for what scripts should be active when the local player is on certain teams.
local kTeamTypes = { "all", kTeamReadyRoom, kTeam1Index, kTeam2Index, kSpectatorIndex }
local kShowOnTeam = { }
kShowOnTeam["all"] = { GUIGameEnd = true, GUIScoreboard = true, GUIDeathMessages = true, 
                       GUIChat = true, GUIVoiceChat = true, GUIMinimapFrame = true, GUIMapAnnotations = true,
                       GUICommunicationStatusIcons = true, GUIUnitStatus = true, GUIDeathScreen = true,
                       GUIStartVoteMenu = true, GUIVoteMenu = true }

kShowOnTeam[kTeamReadyRoom] = { GUIReadyRoomOrders = true }
kShowOnTeam[kTeam1Index] = {}
kShowOnTeam[kTeam2Index] = {}
kShowOnTeam[kSpectatorIndex] = { GUISpectator = true }

local kBothAlienAndMarine = { GUICrosshair = true, GUINotifications = true, GUIDamageIndicators = true, GUIWorldText = true,
                              GUIPing = true, GUIWaitingForAutoTeamBalance = true, GUIGameTime = true, GUISpectatorHUD = true, }
                              
for n, e in pairs(kBothAlienAndMarine) do

    kShowOnTeam[kTeam1Index][n] = e
    kShowOnTeam[kTeam2Index][n] = e
    
end

function AddClientUIScriptForTeam(showOnTeam, scriptName)
    kShowOnTeam[showOnTeam][scriptName] = true
end

// Below are the rules for what scripts should be active when the local player is a certain class.
local kShowAsClass = { }
kShowAsClass["Marine"] = { ["Hud/Marine/GUIMarineHUD"] = true, GUIPoisonedFeedback = true, GUIPickups = true,
                           GUISensorBlips = true, GUIObjectiveDisplay = true, GUIProgressBar = true, GUIRequestMenu = true,
                           GUIWaypoints = true, GUIExperienceBar = true }
kShowAsClass["JetpackMarine"] = { GUIJetpackFuel = true }
kShowAsClass["Exo"] = { GUIExoThruster = true, ["Hud/Marine/GUIMarineHUD"] = true, ["Hud/Marine/GUIExoHUD"] = true, GUIProgressBar = true, GUIRequestMenu = true, GUIWaypoints = true, GUIExperienceBar = true }
kShowAsClass["MarineSpectator"] = { GUIRequestMenu = true, GUIExperienceBar = true }
kShowAsClass["Alien"] = { GUIObjectiveDisplay = true, GUIProgressBar = true, GUIRequestMenu = true, GUIWaypoints = true, GUIAlienHUD = true,
                          GUIEggDisplay = true, GUIRegenerationFeedback = true, GUIExperienceBar = true, GUIAuraDisplay = true }
kShowAsClass["AlienSpectator"] = { GUIRequestMenu = true, GUIExperienceBar = true }
kShowAsClass["Onos"] = { GUIDevour = true }
kShowAsClass["DevouredPlayer"] = { GUIDevour = true }
kShowAsClass["ReadyRoomPlayer"] = { }
kShowAsClass["TeamSpectator"] = { }
kShowAsClass["Spectator"] = { }


// Any lua file loaded on demand should be listed here to avoid being loaded after game has started
local kMiscPreloads = {
    'Babbler',
    'GUIActionIcon',
    'GUIAlienTeamMessage',
    'GUIAnimatedScript',
    'GUIBabblerMoveIndicator',
    'GUIBorderBackground',
    'GUICommanderAlerts',
    'GUICommanderButtons',
    'GUICommanderButtonsAliens',
    'GUICommanderLogout',
    'GUICommanderManager',
    'GUICommanderTooltip',
	'GUIDevour',
    'GUIDial',
    'GUIEvolveHelp',
	'GUIExperienceBar',
    'GUIFadeBlinkHelp',
    'GUIFadeShadowStepHelp',
    'GUIGorgeHealHelp',
    'GUIHotkeyIcons',
    'GUIIncrementBar',
    'GUIList',
    'GUIMarineTeamMessage',
    'GUIMinimapButtons',
    'GUIParticleSystem',
    'GUIProduction',
    'GUIResourceDisplay',
    'GUIScript',
    'GUISelectionPanel',
    'GUISkulkParasiteHelp',
    'GUIXenocideFeedback',
    'Hud/Commander/AlienGhostModel',
    'Hud/Commander/CystGhostModel',
    'Hud/Commander/GhostModel',
    'Hud/Commander/TeleportAlienGhostModel',
    'menu/GUIHoverTooltip',
    'tweener/Tweener',
    'GUICommanderButtonsMarines',
    'GUICommanderButtons',
    'Hud/Commander/MarineGhostModel',
    'GUIObjectiveScoreboard',
    'GUIObjectiveScoreboardCapture',
    'GUIBuyHelp',
    'GUIDevour',
    'GUIExperienceBar',
    'GUIMarineBuildMenu',
    

}

function AddClientUIScriptForClass(className, scriptName)

    kShowAsClass[className] = kShowAsClass[className] or { }
    kShowAsClass[className][scriptName] = true
    
end

local scripts = { }
local scriptCreationEventListeners = { }

function ClientUI.GetScript(name)
    return scripts[name]
end

function ClientUI.DestroyUIScripts()

    for name, script in pairs(scripts) do
        GetGUIManager():DestroyGUIScript(script)
    end
    scripts = { }
    
end

function ClientUI.AddScriptCreationEventListener(listener)
    table.insert(scriptCreationEventListeners, listener)
end

local function CheckPlayerIsOnTeam(forPlayer, teamType)
    return teamType == "all" or forPlayer:GetTeamNumber() == teamType
end

local removeScripts = { }
local function RemoveScripts(forPlayer)

    for name, script in pairs(scripts) do
    
        local shouldExist = false
        if forPlayer then
        
            // Determine if this script should exist based on the team the forPlayer is on.
            for t = 1, #kTeamTypes do
            
                local teamType = kTeamTypes[t]
                if CheckPlayerIsOnTeam(forPlayer, teamType) or MainMenu_GetIsOpened() then
                
                    if kShowOnTeam[teamType][name] then
                    
                        shouldExist = true
						if MainMenu_GetIsOpened() and teamType ~= "all" then
							shouldExist = false
						end

                        break
                        
                    end
                    
                end
                
            end
            
            // Determine if this script should exist based on the class the forPlayer is.
            if not shouldExist then
            
                for class, scriptTable in pairs(kShowAsClass) do
                
                    if forPlayer:isa(class) or MainMenu_GetIsOpened() then
                    
                        if scriptTable[name] then
                        
                            // Most scripts are not allowed in the Ready Room regardless of player class.
                            shouldExist = true
                            if CheckPlayerIsOnTeam(forPlayer, kTeamReadyRoom) then
                                shouldExist = kShowOnTeam[kTeamReadyRoom][name] and not MainMenu_GetIsOpened() or kShowOnTeam["all"][name]
							// Special logic for devoured players too
							elseif forPlayer:isa("DevouredPlayer") then
								shouldExist = kShowAsClass["DevouredPlayer"][name] or kShowOnTeam["all"][name]
                            elseif MainMenu_GetIsOpened() and not kShowOnTeam["all"][name] then
								shouldExist = false
							end
                            
                            break
                            
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
        if not shouldExist then
            table.insert(removeScripts, name)
        end
        
    end
    
    if #removeScripts > 0 then
    
        for s = 1, #removeScripts do
        
            local script = scripts[removeScripts[s]]
            GetGUIManager():DestroyGUIScript(script)
            scripts[removeScripts[s]] = nil
            
        end
        removeScripts = { }
        
    end
    
end

local function NotifyListenersOfScriptCreation(scriptName, script)

    for i = 1, #scriptCreationEventListeners do
        scriptCreationEventListeners[i](scriptName, script)
    end
    
end

local function AddScripts(forPlayer)

    if forPlayer then
    
        for t = 1, #kTeamTypes do
        
            local teamType = kTeamTypes[t]
			// Devoured players ignore team-specific HUD.
            if CheckPlayerIsOnTeam(forPlayer, teamType) and not forPlayer:isa("DevouredPlayer") then
            
                for name, exists in pairs(kShowOnTeam[teamType]) do
                
                    if exists and scripts[name] == nil and not MainMenu_GetIsOpened() then
                    
                        scripts[name] = GetGUIManager():CreateGUIScript(name)
                        NotifyListenersOfScriptCreation(name, scripts[name])
                        
                    end
                    
                end
                
            end
            
        end
        
        for class, scriptTable in pairs(kShowAsClass) do
        
            if forPlayer:isa(class) and not MainMenu_GetIsOpened() then
            
                for name, exists in pairs(scriptTable) do
                
                    // Most scripts are not allowed in the Ready Room regardless of player class.
                    local allowed = exists
                    if CheckPlayerIsOnTeam(forPlayer, kTeamReadyRoom) then
                        allowed = allowed and (not MainMenu_GetIsOpened() and kShowOnTeam[kTeamReadyRoom][name]) or kShowOnTeam["all"][name]
					// Special logic for devoured players too
					elseif forPlayer:isa("DevouredPlayer") then
						allowed = allowed and (kShowAsClass["DevouredPlayer"][name] or kShowOnTeam["all"][name])
                    elseif MainMenu_GetIsOpened() and not kShowOnTeam["all"][name] then
						shouldExist = false
                    end
                    
                    if allowed and scripts[name] == nil then
                    
                        scripts[name] = GetGUIManager():CreateGUIScript(name)
                        NotifyListenersOfScriptCreation(name, scripts[name])
                        
                    end
                    
                end
                
            end
            
        end
       
        // different gameRules GUIs
        local gameRulesGuis = {}
        
        local gameType = GetGamerulesInfo():GetGameType()
        if gameType == kCombatGameType.CombatDeathmatch then
        
            if CheckPlayerIsOnTeam(forPlayer, kTeam1Index) or  CheckPlayerIsOnTeam(forPlayer, kTeam2Index) then   
                gameRulesGuis = {  
                                "GUIObjectiveScoreboard"
                                }
            end
            
        elseif gameType == kCombatGameType.CombatCapture then
        
            if CheckPlayerIsOnTeam(forPlayer, kTeam1Index) or  CheckPlayerIsOnTeam(forPlayer, kTeam2Index) then   
                gameRulesGuis = {  
                                "GUIObjectiveScoreboardCapture"
                                }
            end        
               
	    elseif gameType == kCombatGameType.CombatCTF then
        
            if CheckPlayerIsOnTeam(forPlayer, kTeam1Index) or  CheckPlayerIsOnTeam(forPlayer, kTeam2Index) then   
                gameRulesGuis = {  
                                "GUIObjectiveScoreboard"
                                }
            end        
        
        end
        
        for i, name in ipairs(gameRulesGuis) do
            scripts[name] = GetGUIManager():CreateGUIScript(name)
            NotifyListenersOfScriptCreation(name, scripts[name])
        end
        
        
    end
    
end

local function NotifyScriptsOfPlayerChange(forPlayer)

    for name, script in pairs(scripts) do
    
        if script.OnLocalPlayerChanged then
            script:OnLocalPlayerChanged(forPlayer)
        end
        
    end
    
end

function ClientUI.EvaluateUIVisibility(forPlayer)

    RemoveScripts(forPlayer)
    AddScripts(forPlayer)
    
    NotifyScriptsOfPlayerChange(forPlayer)
    
end

local function PrintUIScripts()

    for name, script in pairs(scripts) do
        Shared.Message(name)
    end
    
end
Event.Hook("Console_print_client_ui", PrintUIScripts)

function PreLoadGUIScripts()

    for team, uiScripts in pairs(kShowOnTeam) do
    
        for name, enabled in pairs(uiScripts) do
            
            if enabled then
                Script.Load("lua/" .. name .. ".lua")
            end
            
        end 

    end   

    for name, enabled in pairs(kBothAlienAndMarine) do
        
        if enabled then
            Script.Load("lua/" .. name .. ".lua")
        end
        
    end
    
    for class, uiScripts in pairs(kShowAsClass) do

        for name, enabled in pairs(uiScripts) do
            
            if enabled then
                Script.Load("lua/" .. name .. ".lua")
            end
            
        end
    
    end
    
    local showSorted = false
    table.sort(kMiscPreloads)
    local duplicateSet = {}
    for _, name in ipairs(kMiscPreloads) do
        if showSorted then
            if not duplicateSet[name] then
                Print("    '%s',", name)
                duplicateSet[name] = true
            end
        end
        Script.Load("lua/" .. name .. ".lua")
    end

end
