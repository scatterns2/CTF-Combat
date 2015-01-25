//=============================================================================
//
// lua/MainMenu.lua
// 
// Created by Max McGuire (max@unknownworlds.com)
// Copyright 2011, Unknown Worlds Entertainment
//
//=============================================================================

Script.Load("lua/InterfaceSounds_Client.lua")
Script.Load("lua/ServerBrowser.lua")
Script.Load("lua/CreateServer.lua")
Script.Load("lua/OptionsDialog.lua")
Script.Load("lua/BindingsDialog.lua")
Script.Load("lua/Update.lua")
Script.Load("lua/MenuManager.lua")
Script.Load("lua/DSPEffects.lua")
Script.Load("lua/SoundEffect.lua")
Script.Load("lua/ServerPerformanceData.lua")

CreateDSPs()

// Change this to false if loading the main menu is slowing down debugging too much
local kAllowDebuggingMainMenu = true

local mainMenuMusic = nil
local mainMenuAlertMessage  = nil

mods = { "co", "cp", "ctf" }
mapnames, maps = GetInstalledMapList()

local loadLuaMenu = true
local gMainMenu = nil
local gForceJoin = false

function MainMenu_GetIsOpened()

    // Don't load or open main menu while debugging (too slow).
    if not GetIsDebugging() or kAllowDebuggingMainMenu then
    
        if loadLuaMenu then
        
            if not gMainMenu then
                return false
            else
                return gMainMenu:GetIsVisible()
            end
            
        else
            return MenuManager.GetMenu() ~= nil
        end
        
    end
    
    return false
    
end

function LeaveMenu()

    MainMenu_OnCloseMenu()
    
    if gMainMenu then
        gMainMenu:SetIsVisible(false)
    end
    
    //MenuManager.SetMenuCinematic(nil)
    MenuMenu_PlayMusic(nil)
    
end

/**
 * Plays background music in the main menu. The music will be automatically stopped
 * when the menu is left.
 */
function MenuMenu_PlayMusic(fileName)

end

/**
 * Called when the user selects the "Host Game" button in the main menu.
 */
function MainMenu_HostGame(mapFileName, modName)

    local port = 27015
    local maxPlayers = Client.GetOptionInteger("playerLimit", 16)
    local password = Client.GetOptionString("serverPassword", "")
    local serverName = Client.GetOptionString("serverName", "Listen Server")
    
    MainMenu_OnConnect()
    
    if Client.StartServer(mapFileName, serverName, password, port, maxPlayers) then
        LeaveMenu()
    end
    
end

function MainMenu_SelectServer(serverNum, serverData)
    gSelectedServerNum = serverNum
    gSelectedServerData = serverData
end

function MainMenu_SelectServerAddress(address)
    gSelectedServerAddress = address
end

function MainMenu_GetSelectedServer()
    return gSelectedServerNum
end

function MainMenu_GetSelectedServerData()
    return gSelectedServerData
end

function MainMenu_SetSelectedServerPassword(password)
    gPassword = password
end

function MainMenu_GetSelectedRequiresPassword()

    if gSelectedServerNum and gSelectedServerData then
        return gSelectedServerData.requiresPassword
    end
    
    return false
    
end

function MainMenu_GetSelectedIsFull()
    
    if gSelectedServerNum and gSelectedServerData then
        local numReservedSlots = GetNumServerReservedSlots(gSelectedServerData.serverId)
        return Client.GetServerNumPlayers(gSelectedServerNum) >= Client.GetServerMaxPlayers(gSelectedServerNum) - numReservedSlots
    end
	
end

function MainMenu_GetSelectedIsFullWithNoRS()
    
    if gSelectedServerNum and gSelectedServerNum >0 then
        return Client.GetServerNumPlayers(gSelectedServerNum) >= Client.GetServerMaxPlayers(gSelectedServerNum)
    end
    
end

function MainMenu_GetSelectedIsHighPlayerCount()
    
    if gSelectedServerNum and gSelectedServerData then
        return gSelectedServerData.maxPlayers > 24 and Client.GetOptionBoolean( kRookieOptionsKey, false ) == true
    end
    
end

function MainMenu_GetSelectedIsNetworkModded()
    if gSelectedServerNum and gSelectedServerData then
        return gSelectedServerData.customNetworkSettings
    end
end

function MainMenu_ForceJoin(forceJoin)
	if forceJoin ~= nil then
		gForceJoin = forceJoin
	end
	return gForceJoin
end

function MainMenu_GetSelectedServerName()
    
    if gSelectedServerNum then
        return Client.GetServerName(gSelectedServerNum)
    end
    
end

function MainMenu_JoinSelected()

    local address = nil
    local mapName = nil
    local entry = nil
    
    if gSelectedServerNum >= 0 then
    
        address = Client.GetServerAddress(gSelectedServerNum)
        mapName = Client.GetServerMapName(gSelectedServerNum)
        entry = BuildServerEntry(gSelectedServerNum)
        
    else
    
        local storedServers = GetStoredServers()
    
        address = storedServers[-gSelectedServerNum].address
        entry = storedServers[-gSelectedServerNum]

    end
    
    if entry then
        AddServerToHistory(entry)
    end
    
    MainMenu_SBJoinServer(address, gPassword, mapName)
    
end

function GetModName(mapFileName)

    for index, mapEntry in ipairs(maps) do
    
        if mapEntry.fileName == mapFileName then
            return mapEntry.modName
        end
        
    end
    
    return nil
    
end

/**
 * Returns true if we hit ESC while playing to display menu, false otherwise. 
 * Indicates to display the "Back to game" button.
 */
function MainMenu_IsInGame()
    return Client.GetIsConnected()    
end

/**
 * Called when button clicked to return to game.
 */
function MainMenu_ReturnToGame()
    LeaveMenu()
end

/**
 * Set a message that will be displayed in window in the main menu the next time
 * it's updated.
 */
function MainMenu_SetAlertMessage(alertMessage)
    mainMenuAlertMessage = alertMessage
end

/**
 * Called every frame to see if a dialog should be popped up.
 * Return string to show (one time, message should not continually be returned!)
 * Return "" or nil for no message to pop up
 */
function MainMenu_GetAlertMessage()

    local alertMessage = mainMenuAlertMessage
    mainMenuAlertMessage = nil
    
    return alertMessage
    
end

function MainMenu_CreateSplashScreen()

	if not MainMenu_IsInGame() then
		splashScript = GetGUIManager():CreateGUIScript("menu/GUISplashScreen")
		splashScript:SetPlayAnimation("show")
		local autoStart = false
		if Shared.GetDevMode() then
			if Client.StartServer("co_testmap", "DevServer", "mydevserver", 27015, 24) then
				autoStart = true
			end
		end
			
		if not autoStart then
			MainMenu_Open()
			gMainMenu:SetIsVisible(false)
		end
	end

end

function MainMenu_Open()

    // Don't load or open main menu while debugging (too slow).
    if not GetIsDebugging() or kAllowDebuggingMainMenu then
    
        // Load and set default sound levels
        OptionsDialogUI_OnInit()
        
        if loadLuaMenu then
        
            if not gMainMenu then
                gMainMenu = GetGUIManager():CreateGUIScript("menu/GUIMainMenu")
            else
				gMainMenu:SetIsVisible(true)
			end
            
        else
        
            MenuManager.SetMenu(kMainMenuFlash)
            MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", false)
            
        end
        
    end
    
end

function MainMenu_SetVisible()
    gMainMenu:SetIsVisible(true)
end

function MainMenu_GetMapNameList()
    return mapnames
end

function MainMenu_OnServerRefreshed(serverIndex)
    gMainMenu:OnServerRefreshed(serverIndex)
end

/**
 * Called when the user types the "map" command at the console.
 */
local function OnCommandMap(mapFileName)

	if mapFileName ~= nil then
        MainMenu_HostGame(mapFileName)
        
        if Client then
            Client.SetOptionString("lastServerMapName", mapFileName)
        end
    end

end

/**
 * Called when the user types the "connect" command at the console.
 */
local function OnCommandConnect(address, password)
    MainMenu_SBJoinServer(address, password)
end

/**
 * This is called if the user tries to join a server through the
 * Steam UI.
 */
local function OnConnectRequested(address, password)
    MainMenu_SBJoinServer(address, password)
end

/**
 * Sound events
 */
local kMouseInSound = "sound/combat.fev/combat/main_menu/marine/on_hover"
local kMouseOutSound = "sound/NS2.fev/common/tooltip"
local kClickSound = "sound/combat.fev/combat/main_menu/marine/on_click"
local kCheckboxOnSound = "sound/NS2.fev/common/checkbox_off"
local kCheckboxOffSound = "sound/NS2.fev/common/checkbox_on"
local kConnectSound = "sound/NS2.fev/common/connect"
local kOpenMenuSound = "sound/NS2.fev/common/menu_confirm"
local kCloseMenuSound = "sound/NS2.fev/common/menu_confirm"
local kLoopingMenuSound = "sound/combat.fev/combat/main_menu/marine/loadin"
local kWindowOpenSound = "sound/combat.fev/combat/main_menu/marine/menu_open"
local kDropdownSound = "sound/NS2.fev/common/button_enter"
local kArrowSound = "sound/NS2.fev/common/arrow"
local kButtonSound = "sound/NS2.fev/common/tooltip_off"
local kButtonClickSound = "sound/NS2.fev/common/button_click"
local kTooltip = "sound/NS2.fev/common/tooltip_on"
local kPlayButtonSound = "sound/NS2.fev/marine/commander/give_order"
local kSlideSound = "sound/NS2.fev/marine/commander/hover_ui"
local kTrainingLinkSound = "sound/NS2.fev/common/tooltip"
local kLoadingSound = "sound/NS2.fev/common/loading"
local kCustomizeHoverSound = "sound/NS2.fev/alien/fade/vortex_start_2D"
local kMainMenuSound = "sound/combat.fev/combat/main_menu/marine/theme"

local kAlienMouseInSound = "sound/combat.fev/combat/main_menu/alien/on_hover" 					//Mouse in sound
local kAlienClickSound = "sound/combat.fev/combat/main_menu/alien/on_click"						//Current sound that globally plays when you click most things
local kAlienCheckboxOnSound = "sound/combat.fev/combat/main_menu/alien/checkbox_off"					//Sound when clicking a checkbox
local kAlienCheckboxOffSound = "sound/combat.fev/combat/main_menu/alien/checkbox_on"					//Sound when clicking a checkbox
local kAlienLoopingMenuSound = "sound/combat.fev/combat/main_menu/alien/loadin"			//Sound when you first start the same
local kAlienWindowOpenSound = "sound/combat.fev/combat/main_menu/alien/menu_open"		//Sound when window animation finishes and window opens
local kAlienButtonClickSound = "sound/combat.fev/combat/main_menu/alien/button_click"	//Sound that plays when you click buttons in game.
local kAlienTooltip = "sound/combat.fev/combat/main_menu/alien/tooltip"					//Sound when alert window pops up (new build released message)
local kAlienPlayButtonSound = "sound/combat.fev/combat/main_menu/alien/link_click"		//Clicking any links in the menu
local kAlienSlideSound = "sound/combat.fev/combat/main_menu/alien/on_slide"				//Global scrolling sound
local kAlienTrainingLinkSound = "sound/combat.fev/main_menu/combat/alien/tooltip"		//Clicked on a training link video and video opens
local kAlienMainMenuSound = "sound/combat.fev/combat/main_menu/alien/theme"				//Main Menu Theme

local kMaleTauntSound = "sound/NS2.fev/marine/voiceovers/taunt"
local kFemaleTauntSound = "sound/NS2.fev/marine/voiceovers/taunt_female"

 // --Unused--
local kAlienDropdownSound = "sound/combat.fev/combat/main_menu/on_click"
local kAlienArrowSound = "sound/combat.fev/combat/main_menu/on_click"
local kAlienButtonSound = "sound/combat.fev/combat/main_menu/on_click"
local kAlienLoadingSound = "sound/NS2.fev/common/loading"
local kAlienMouseOutSound = "sound/NS2.fev/common/tooltip"
local kAlienOpenMenuSound = "sound/NS2.fev/alien/common/vision_on"
local kAlienCloseMenuSound = "sound/NS2.fev/alien/common/vision_off"
local kAlienConnectSound = "sound/NS2.fev/common/connect"
 // --Unused--
 
Client.PrecacheLocalSound(kMouseInSound)
Client.PrecacheLocalSound(kMouseOutSound)
Client.PrecacheLocalSound(kClickSound)
Client.PrecacheLocalSound(kCheckboxOnSound)
Client.PrecacheLocalSound(kCheckboxOffSound)
Client.PrecacheLocalSound(kConnectSound)
Client.PrecacheLocalSound(kOpenMenuSound)
Client.PrecacheLocalSound(kCloseMenuSound)
Client.PrecacheLocalSound(kLoopingMenuSound)
Client.PrecacheLocalSound(kWindowOpenSound)
Client.PrecacheLocalSound(kDropdownSound)
Client.PrecacheLocalSound(kArrowSound)
Client.PrecacheLocalSound(kButtonSound)
Client.PrecacheLocalSound(kButtonClickSound)
Client.PrecacheLocalSound(kTooltip)
Client.PrecacheLocalSound(kPlayButtonSound)
Client.PrecacheLocalSound(kSlideSound)
Client.PrecacheLocalSound(kTrainingLinkSound)
Client.PrecacheLocalSound(kLoadingSound)
Client.PrecacheLocalSound(kCustomizeHoverSound)
Client.PrecacheLocalSound(kMainMenuSound)
Client.PrecacheLocalSound(kMaleTauntSound)
Client.PrecacheLocalSound(kFemaleTauntSound)

/* -- Unused for now
Client.PrecacheLocalSound(kAlienMouseInSound)
Client.PrecacheLocalSound(kAlienMouseOutSound)
Client.PrecacheLocalSound(kAlienClickSound)
Client.PrecacheLocalSound(kAlienCheckboxOnSound)
Client.PrecacheLocalSound(kAlienCheckboxOffSound)
Client.PrecacheLocalSound(kAlienConnectSound)
Client.PrecacheLocalSound(kAlienOpenMenuSound)
Client.PrecacheLocalSound(kAlienCloseMenuSound)
Client.PrecacheLocalSound(kAlienLoopingMenuSound)
Client.PrecacheLocalSound(kAlienWindowOpenSound)
Client.PrecacheLocalSound(kAlienDropdownSound)
Client.PrecacheLocalSound(kAlienArrowSound)
Client.PrecacheLocalSound(kAlienButtonSound)
Client.PrecacheLocalSound(kAlienButtonClickSound)
Client.PrecacheLocalSound(kAlienTooltip)
Client.PrecacheLocalSound(kAlienPlayButtonSound)
Client.PrecacheLocalSound(kAlienSlideSound)
Client.PrecacheLocalSound(kAlienTrainingLinkSound)
Client.PrecacheLocalSound(kAlienLoadingSound)
Client.PrecacheLocalSound(kAlienMainMenuSound)
*/

function MainMenu_OnMouseIn()
    PlayMenuSoundTheme(kMouseInSound, kAlienMouseInSound)
end

function MainMenu_OnMouseOut()
    //PlayMenuSoundTheme(kMouseOutSound, kMouseOutSound)
end

function MainMenu_OnMouseOver()
	if MainMenu_GetIsOpened() then
		PlayMenuSoundTheme(kMouseOutSound, kAlienMouseOutSound)
	end
end

function MainMenu_OnMouseClick()
    PlayMenuSoundTheme(kClickSound, kAlienClickSound)
end

function MainMenu_OnWindowOpen()
    PlayMenuSoundTheme(kWindowOpenSound, kAlienWindowOpenSound)
end

function MainMenu_OnCheckboxOn()
    PlayMenuSoundTheme(kCheckboxOnSound, kAlienCheckboxOnSound)
end

function MainMenu_OnCheckboxOff()
    PlayMenuSoundTheme(kCheckboxOffSound, kAlienCheckboxOffSound)
end

function MainMenu_OnConnect()
    PlayMenuSoundTheme(kConnectSound, kAlienConnectSound)
end

function MainMenu_OnOpenMenu()
    PlayMenuSoundTheme(kLoopingMenuSound, kAlienLoopingMenuSound)    
	local musicVol = Client.GetMusicVolume()
	PlayMenuSoundTheme(kMainMenuSound, kAlienMainMenuSound, musicVol)
end

function MainMenu_OnCloseMenu()
    Shared.StopSound(nil, kLoopingMenuSound)
	Shared.StopSound(nil, kMainMenuSound)
	
	Shared.StopSound(nil, kAlienLoopingMenuSound)
	Shared.StopSound(nil, kAlienMainMenuSound)
end

function MainMenu_OnDropdownClicked()
    PlayMenuSoundTheme(kDropdownSound, kAlienDropdownSound)
end

function MainMenu_OnHover()
    PlayMenuSoundTheme(kArrowSound, kAlienArrowSound)
end

function MainMenu_OnButtonEnter()
    PlayMenuSoundTheme(kButtonSound, kAlienButtonSound)
end

function MainMenu_OnButtonClicked()
    PlayMenuSoundTheme(kButtonClickSound, kAlienButtonClickSound)
end

function MainMenu_OnTooltip()
    PlayMenuSoundTheme(kTooltip, kAlienTooltip, 0.5)
end

function MainMenu_OnGenderChanged(newGender)
	if newGender == "Male" then
		StartSoundEffect(kMaleTauntSound, volume or 1)
	else
		StartSoundEffect(kFemaleTauntSound, volume or 1)
    end
end

function MainMenu_OnPlayButtonClicked()
    PlayMenuSoundTheme(kPlayButtonSound, kAlienPlayButtonSound)
end

function MainMenu_OnSlide()
	if MainMenu_GetIsOpened() then
		PlayMenuSoundTheme(kSlideSound, kAlienSlideSound)
	end
end

function MainMenu_OnTrainingLinkedClicked()
	if MainMenu_GetIsOpened() then
		PlayMenuSoundTheme(kTrainingLinkSound, kAlienTrainingLinkSound)
	end
end

function MainMenu_OnLoadingSound()
	if MainMenu_GetIsOpened() then
		PlayMenuSoundTheme(kLoadingSound, kAlienLoadingSound)
	end
end
	
function MainMenu_OnCustomizationHover()
    StartSoundEffect(kCustomizeHoverSound)    
end

local function OnClientDisconnected()
    LeaveMenu()
end

function PlayMenuSoundTheme(sound1, sound2, volume)
    if GetMainMenuThemeName() == "Alien" then
		StartSoundEffect(sound2, volume or 1)
	else
		StartSoundEffect(sound1,volume or 1)
	end
end

Event.Hook("ClientDisconnected", OnClientDisconnected)
Event.Hook("ConnectRequested", OnConnectRequested)

Event.Hook("Console_connect",  OnCommandConnect)
Event.Hook("Console_map",  OnCommandMap)