//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// GUICombatBuyMenu.lua

Script.Load("lua/menu/WindowManager.lua")
Script.Load("lua/GUIAnimatedScript.lua")
Script.Load("lua/menu/MenuMixin.lua")
Script.Load("lua/menu/Link.lua")
Script.Load("lua/menu/SlideBar.lua")
Script.Load("lua/menu/ProgressBar.lua")
Script.Load("lua/menu/ContentBox.lua")
Script.Load("lua/menu/Image.lua")
Script.Load("lua/menu/Table.lua")
Script.Load("lua/menu/Ticker.lua")
Script.Load("lua/ServerBrowser.lua")
Script.Load("lua/menu/Form.lua")
Script.Load("lua/menu/ServerList.lua")
Script.Load("lua/menu/GatherFrame.lua")
Script.Load("lua/menu/ServerTabs.lua")
Script.Load("lua/menu/PlayerEntry.lua")
Script.Load("lua/dkjson.lua")
Script.Load("lua/Globals_Combat.lua")
Script.Load("lua/UpgradeMixin.lua")
Script.Load("lua/UpgradeMixin_Client.lua")

class 'GUICombatBuyMenu' (GUIAnimatedScript)



local fadeAlpha = 0
local fadeTime = .25
local alphaLimit = 1
local lastUpdatedtime = 0
local playAnimation = "show"

k_buyMenu_BackgroundColor = Color(0,0,0,fadeAlpha)
k_buyMenu_MarineBgAlpha = 1
k_buyMenu_AlienBgAlpha = 1

k_buyMenu_WindowWidthAlien = 768
k_buyMenu_WindowHeightAlien = 768
k_buyMenu_WindowWidthMarine = 1024
k_buyMenu_WindowHeightMarine = 576
k_buyMenu_WindowWidthExo = 1024
k_buyMenu_WindowHeightExo = 576

k_buyMenu_DescTextWidth = 200
k_buyMenu_DescTextHeight = 300

k_buyMenu_IconFrameSize = Vector(112,112,0)


k_buyMenu_ClassTextureWidth = 128
k_buyMenu_ClassTextureHeight = 128

k_buyMenu_UpgradeRowBufferHeight = 4


--[[
	Localize often used functions here for the sake of performance 
]]
local TableInsert = table.insert
local kPi = math.pi
local StringFormat = string.format
local ToString = tostring

--#$#$-- End Constants

function GUICombatBuyMenu:Initialize()
	--this must only be called ONCE per mapcycle.
	GUIAnimatedScript.Initialize(self)
	LoadCSSFile("lua/menu/main_menu.css")
	LoadCSSFile("lua/menu/buy_menu.css")
	AddMenuMixin(self)
	
	self.playerId = Client.GetLocalPlayer():GetId()
	
	self.close = false
	self.selectedUpgradeType = kCombatUpgradeTypes.Offense
	self.screenSize = Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0)
	self:SetWindowLayer(kWindowLayerBuyMenu)
	self.mainWindow = self:CreateWindow()
	self.mainWindow:SetCSSClass("buy_frame")
	self.mainWindow:SetBackgroundSize(Vector(k_buyMenu_WindowWidthAlien, k_buyMenu_WindowHeightAlien, 0))
	--self.mainWindow:GetContentBox():SetIsScaling(false)
	--self.mainWindow:SetIsScaling(false)
	self.mainWindow:DisableTitleBar()
	self.mainWindow:DisableResizeTile()
	self.mainWindow:DisableSlideBar()
	self.mainWindow:DisableCloseButton()
	self.mainWindow:DisableEscape()
	self.mainWindow:SetBackgroundPosition(Vector((Client.GetScreenWidth() - self.mainWindow:GetWidth())/2, (Client.GetScreenHeight() - self.mainWindow:GetHeight())/2, 0))
    self.mainWindow:SetBackgroundColor(k_buyMenu_BackgroundColor)

	
	self.refundButton = CreateMenuElement(self.mainWindow:GetContentBox(), "MenuButton")
	self.refundButton:SetIsVisible(false)
	self.refundButton:AddEventCallbacks(
					{
						OnMouseDown = function(self)
							Client.GetLocalPlayer():RefundAllUpgrades(false)
						end,
						
						OnMouseIn = function(self)
							g_buyMenu:MouseOverRefund()
						end,
						
						OnMouseOut = function(self)
							g_buyMenu:MouseOverRefundExit()
						end
					}
				)
	self.refundButton:SetCanHighlight(true)
	self.refundButton:SetParent(self.mainWindow)
	self.refundButton:SetBackgroundSize(Vector(k_buyMenu_DescTextWidth, 100, 0))
	self.refundButton:SetBackgroundColor(Color(0,0,0,0))
	self.refundButton:SetBackgroundPosition(Vector(self.mainWindow:GetWidth() - self.refundButton:GetWidth(), self.mainWindow:GetHeight() - self.refundButton:GetHeight(), 0))
	self.refundButton:SetIsScaling(false)
	self.refundButton.buttonText:SetInheritsParentAlpha(true)
	--self.refundButton:GetBackground():SetInheritsParentAlpha(true)
	self.refundButton:SetBorderWidth(0)
	self.refundButton:DisableMouseClickSound()
	
	self.pointDisplayBg = GUIManager():CreateGraphicItem()
	self.pointDisplayBg:SetInheritsParentAlpha(true)
	self.pointDisplayBg:SetSize(Vector(38, 38, 0))
	self.mainWindow:GetBackground():AddChild(self.pointDisplayBg)
	
	self.levelDisplayBg = GUIManager():CreateGraphicItem()
	self.levelDisplayBg:SetSize(Vector(80, 36, 0))
	self.levelDisplayBg:SetAnchor(GUIItem.Middle, GUIItem.Center)
	self.levelDisplayBg:SetInheritsParentAlpha(true)
	self.mainWindow:GetBackground():AddChild(self.levelDisplayBg)
		
	self.levelDisplayText = GetGUIManager():CreateTextItem()
	self.levelDisplayText:SetFontName("fonts/AgencyFB_huge.fnt")
	self.levelDisplayText:SetFontIsBold(false)
	self.levelDisplayText:SetAnchor(GUIItem.Middle, GUIItem.Center)
	self.levelDisplayText:SetTextAlignmentX(GUIItem.Align_Center)
	self.levelDisplayText:SetTextAlignmentY(GUIItem.Align_Center)
	self.levelDisplayText:SetInheritsParentAlpha(true)
	self.levelDisplayBg:AddChild(self.levelDisplayText)
	
	self.pointTextDisplayBg = GUIManager():CreateGraphicItem()
	self.pointTextDisplayBg:SetSize(Vector(100, 36, 0))
	self.pointTextDisplayBg:SetAnchor(GUIItem.Middle, GUIItem.Center)
	self.pointTextDisplayBg:SetInheritsParentAlpha(true)
	self.mainWindow:GetBackground():AddChild(self.pointTextDisplayBg)

	self.pointPrefixText = GetGUIManager():CreateTextItem()
	self.pointPrefixText:SetFontName(Fonts.kAgencyFB_Medium)
	self.pointPrefixText:SetFontIsBold(true)
	self.pointPrefixText:SetText(Locale.ResolveString("POINTS_TO_SPEND"))
	self.pointPrefixText:SetAnchor(GUIItem.Middle, GUIItem.Center)
	self.pointPrefixText:SetTextAlignmentX(GUIItem.Align_Center)
	self.pointPrefixText:SetTextAlignmentY(GUIItem.Align_Center)
	self.pointPrefixText:SetInheritsParentAlpha(true)
	self.pointTextDisplayBg:AddChild(self.pointPrefixText)	
	
	self.pointDisplayText = GetGUIManager():CreateTextItem()
	self.pointDisplayText:SetFontName(Fonts.kAgencyFB_Medium)
	self.pointDisplayText:SetInheritsParentAlpha(true)
	self.pointDisplayText:SetFontIsBold(true)
	self.pointDisplayText:SetAnchor(GUIItem.Middle, GUIItem.Middle)
	self.pointDisplayText:SetTextAlignmentX(GUIItem.Align_Center)
	self.pointDisplayText:SetTextAlignmentY(GUIItem.Align_Center)
	self.pointDisplayBg:AddChild(self.pointDisplayText)
	
	
	self.mouseOverToolTip = GetGUIManager():CreateGUIScriptSingle("menu/BuyMenuHoverTooltip")
	self.mouseOverToolTip:SetMouseFollow(false)
	self.mouseOverToolTip.tooltip:SetFontName(Fonts.kAgencyFB_Small)
	self.switchTime = Shared.GetTime()
	self:OnUpgradesChanged()
	self:Close()
	self:SetIsVisible(false)
end

--this should never be called.  nevadl, evadlldldl
function GUICombatBuyMenu:Uninitialize()
end

function GUICombatBuyMenu:GetEntityId()
	return self.playerId
end

function GUICombatBuyMenu:SetEntityId(id)
	-- Shared.Message("Id set to " .. id)
	self.playerId = id
	-- if id ~= nil then
		-- Shared.Message("(" .. Shared.GetEntity(id):GetClassName() .. ")")
	-- end
end

function GUICombatBuyMenu:InitializeAllContent()
	self.allUpgrades = {}
	self.allForms = {}
	if self:GetTeamType() == "Marines" then
		if self:GetPlayer():isa("Exo") then
			self:InitializeExoContent()
		else
			self:InitializeMarineContent()
		end
	elseif self:GetTeamType() == "Aliens" then
		self:InitializeAlienContent()
	end
	
end

function GUICombatBuyMenu:UninitializeAllContent()
	if self.allUpgrades then
		for i, v in ipairs(self.allUpgrades) do
			v = nil
		end	
		self.allUpgrades = nil
	end
	
	if self.allForms then
		for i, v in ipairs(self.allForms) do
			v:Uninitialize()
			v = nil
		end
		self.allForms = nil
	end
	
	-- if self.tentacles then
		-- for i, tentacle in pairs(self.tentacles) do
			-- GUI.DestroyItem(tentacle)
			-- table.remove(self.tentacles, i)
		-- end
	-- end
end

function GUICombatBuyMenu:InitializeMarineContent()
	if self.tentacles and #self.tentacles > 0 then
		for i = 1, #self.tentacles do
			GUI.DestroyItem(self.tentacles[i])
			self.tentacles[i] = nil
		end
	end
	
	Client.SetCursor(k_buyMenu_CursorMarine, 0, 0)
	
	k_buyMenu_BackgroundColor = Color(1,1,1,fadeAlpha)
	self.mainWindow:SetBackgroundTexture(k_buyMenu_MarineBgTexture)
	self.mainWindow:SetBackgroundSize(Vector(k_buyMenu_WindowWidthMarine, k_buyMenu_WindowHeightMarine, 0))
	self.mainWindow:GetContentBox():SetBackgroundSize(Vector(k_buyMenu_WindowWidthMarine * 1920/self.screenSize.x,k_buyMenu_WindowHeightMarine * 1080/self.screenSize.y, 0), true)
	self.mainWindow:SetBackgroundPosition(Vector((Client.GetScreenWidth() - self.mainWindow:GetWidth())/2, (Client.GetScreenHeight() - self.mainWindow:GetHeight())/2, 0))
	self.refundButton:SetBackgroundTexture(k_buyMenu_MarineRefundTexture)
	self.refundButton:SetBackgroundColor(Color(1,1,1,1))
	self.refundButton:SetBackgroundPosition(Vector(389,521,0))
	self.refundButton:SetBackgroundSize(Vector(256,64,0))
	self.refundButton:SetText("Refund All")
	
	local mainWindowBackground = self.mainWindow:GetBackground()
	
	self.levelDisplayText:SetFontName(Fonts.kAgencyFB_Medium)
	
	self.levelDisplayBg:SetTexture(k_buyMenu_MarineLevelTextBacking)
	self.pointTextDisplayBg:SetTexture(k_buyMenu_MarinePointTextBacking)
	self.levelDisplayBg:SetPosition(Vector(-236,-142, 0))
	
	self.pointDisplayBg:SetTexture(k_buyMenu_MarinePointBacking)
	self.pointDisplayBg:SetPosition(Vector(mainWindowBackground:GetSize().x/4 * 3 - 27,mainWindowBackground:GetSize().y/4, 0))
	
	self.pointTextDisplayBg:SetPosition(Vector(130,-142, 0))
	
	self.levelDisplayText:SetColor(Color(0,1,1,1))
	
	if self.weaponDetail == nil then
		self.weaponDetail = GUIManager.CreateGraphicItem()
		self.weaponDetail:SetInheritsParentAlpha(true)
		self.weaponDetail:SetPosition(Vector(286, 147, 0))
		self.weaponDetail:SetSize(Vector(480, 260, 0))
		self.weaponDetail:SetIsVisible(false)
		mainWindowBackground:AddChild(self.weaponDetail)
	end
	
	mainWindowBackground:SetShader(k_buyMenu_MarineBgShader)
	mainWindowBackground:SetFloatParameter("texRatio", k_buyMenu_WindowWidthMarine/k_buyMenu_WindowHeightMarine)
	self.mouseOverToolTip:SetResizableBackground("ui/buymenu/Marines_TT_Full.dds")
	--Keys are upgrades, filled out below.  Values are the buttons representing them, filled out in the CreateUpgradesForms--
	self.upgrades_building = {}
	self.upgrades_slot1 = {}
	self.upgrades_utility = {}
	self.upgrades_slot4 = {}
	self.upgrades_stats = {}
	self.upgrades_class = {}
	TableInsert(self.allUpgrades, self.upgrades_building)
	TableInsert(self.allUpgrades, self.upgrades_slot1)
	TableInsert(self.allUpgrades, self.upgrades_utility)
	TableInsert(self.allUpgrades, self.upgrades_slot4)
	TableInsert(self.allUpgrades, self.upgrades_stats)
	TableInsert(self.allUpgrades, self.upgrades_class)
	
	local player = self:GetPlayer()
	for i, v in ipairs(UpgradeMixin.GetAvailableUpgrades(player)) do
		if v:GetUpgradeTechId() and not v:GetHideUpgrade(player:GetCombatUpgradeList()) then
			if v:GetUpgradeType() == kCombatUpgradeTypes.Structure then
				TableInsert(self.upgrades_building, {Upgrade = v})
			elseif v:GetUniqueSlot() == kUpgradeUniqueSlot.Weapon1 or v:GetUniqueSlot() == kUpgradeUniqueSlot.Weapon2 then
				TableInsert(self.upgrades_slot1, {Upgrade = v})
			elseif v:GetUniqueSlot() == kUpgradeUniqueSlot.Weapon4 then
				TableInsert(self.upgrades_slot4, {Upgrade = v})
			elseif v:GetUpgradeType() == kCombatUpgradeTypes.Lifeform and (v:GetIsAtMaxLevel() or v:GetCostForNextLevel(player, true) >= 0) then
				TableInsert(self.upgrades_class, {Upgrade = v})
			else
				local name = v:GetUpgradeName()
				if name == "welder" or name == "resupply" or name == "jetpack" or name == "scan" or name == "nanoarmor" then
					TableInsert(self.upgrades_utility, {Upgrade = v})
				elseif name ~= "knife" and name ~= "axe" then
					TableInsert(self.upgrades_stats, {Upgrade = v})
				end
			end
		end
	end
	
	local windowBox = self.mainWindow:GetContentBox()
	
	--targetForm, upgrades, parent, maxRows, maxColumns, backColor, curvature, spacing
	self.classForm = self:CreateUpgradesForm{targetForm = self.classForm, upgrades = self.upgrades_class, parent = windowBox, maxRows = 0, maxColumns = 1, spacing = Vector(6,20,0)}
	self.classForm:SetBackgroundPosition(Vector(0, (self.mainWindow:GetHeight() - self.classForm:GetHeight())/2, 0))
	TableInsert(self.allForms, self.classForm)
	
	self.slot1Form = self:CreateUpgradesForm{targetForm = self.slot1Form, upgrades = self.upgrades_slot1, parent = windowBox, maxRows = 0, maxColumns = 1, spacing = Vector(6,3,0)}
	self.slot1Form:SetBackgroundPosition(Vector(self.classForm:GetWidth() + 50,  (self.mainWindow:GetHeight() - self.slot1Form:GetHeight())/2, 0))
	TableInsert(self.allForms, self.slot1Form)
	
	self.utilityForm = self:CreateUpgradesForm{targetForm = self.utilityForm, upgrades = self.upgrades_utility, parent = windowBox, maxRows = 0, maxColumns = 1, spacing = Vector(6,3,0)}
	self.utilityForm:SetBackgroundPosition(Vector(self.mainWindow:GetWidth() - self.utilityForm:GetWidth() * 3, (self.mainWindow:GetHeight() - self.utilityForm:GetHeight())/2, 0))
	TableInsert(self.allForms, self.utilityForm)
	
	self.slot4Form = self:CreateUpgradesForm{targetForm = self.slot4Form, upgrades = self.upgrades_slot4, parent = windowBox, maxRows = 1, maxColumns = 0, spacing = Vector(6,3,0)}
	self.slot4Form:SetBackgroundPosition(Vector((self.mainWindow:GetWidth() - self.slot4Form:GetWidth())/2, self.mainWindow:GetHeight() - 150, 0))
	TableInsert(self.allForms, self.slot4Form)
		
	self.statsForm = self:CreateUpgradesForm{targetForm = self.statsForm, upgrades = self.upgrades_stats, parent = windowBox, maxRows = 0, maxColumns = 4, spacing = Vector(12,3,0)}
	self.statsForm:SetBackgroundPosition(Vector((self.mainWindow:GetWidth() - self.statsForm:GetWidth())/2, 50, 0))
	TableInsert(self.allForms, self.statsForm)
	
	self.buildingsForm = self:CreateUpgradesForm{targetForm = self.buildingsForm, upgrades = self.upgrades_building, parent = windowBox, maxRows = 0, maxColumns = 1, spacing = Vector(6,3,0)}
	self.buildingsForm:SetBackgroundPosition(Vector(self.mainWindow:GetWidth() - self.buildingsForm:GetWidth() * 1.5, (self.mainWindow:GetHeight() - self.buildingsForm:GetHeight())/2, 0))
	TableInsert(self.allForms, self.buildingsForm)
	
	
end

function GUICombatBuyMenu:InitializeExoContent()
	k_buyMenu_BackgroundColor = Color(1,1,1,fadeAlpha)
	self.mainWindow:SetBackgroundTexture(k_buyMenu_ExoBgTexture)
	self.mainWindow:SetBackgroundSize(Vector(k_buyMenu_WindowWidthExo, k_buyMenu_WindowHeightExo, 0))
	self.mainWindow:GetContentBox():SetBackgroundSize(Vector(k_buyMenu_WindowWidthExo * 1920/self.screenSize.x,k_buyMenu_WindowHeightExo * 1080/self.screenSize.y, 0), true)
	self.mainWindow:SetBackgroundPosition(Vector((Client.GetScreenWidth() - self.mainWindow:GetWidth())/2, (Client.GetScreenHeight() - self.mainWindow:GetHeight())/2, 0))
	self.refundButton:SetBackgroundTexture(k_buyMenu_ExoRefundTexture)
	self.refundButton:SetBackgroundColor(Color(1,1,1,1))
	self.refundButton:SetBackgroundPosition(Vector(79,493,0))
	self.refundButton:SetBackgroundSize(Vector(256,64,0))
	self.refundButton:SetText("")
	local mainWindowBackground = self.mainWindow:GetBackground()
	mainWindowBackground:SetShader("shaders/GUIBasic.surface_shader")
	-- mainWindowBackground:SetFloatParameter("texRatio", k_buyMenu_WindowWidthMarine/k_buyMenu_WindowHeightMarine)
	self.mouseOverToolTip:SetResizableBackground("ui/buymenu/Marines_TT_Full.dds")
	--Keys are upgrades, filled out below.  Values are the buttons representing them, filled out in the CreateUpgradesForms--
	
	--xp points, level points, & bgs for both
	self.levelDisplayBg:SetTexture(k_buyMenu_ExoLevelTextBacking)
	self.pointTextDisplayBg:SetTexture(k_buyMenu_ExoPointTextBacking)
	
	self.levelDisplayBg:SetPosition(Vector(-450,-134, 0))
	
	self.pointDisplayBg:SetTexture(k_buyMenu_MarinePointBacking)
	self.pointDisplayBg:SetPosition(Vector(900, 92, 0))
	
	self.pointTextDisplayBg:SetPosition(Vector(265,-194, 0))
	
	self.upgrades_all = {}
	self.upgrades_class = {}
	TableInsert(self.allUpgrades, self.upgrades_all)
	TableInsert(self.allUpgrades, self.upgrades_class)
	
	local player = self:GetPlayer()
	for i, v in ipairs(UpgradeMixin.GetAvailableUpgrades(player)) do
		if v:GetUpgradeTechId() and not v:GetHideUpgrade(player:GetCombatUpgradeList()) then
			if v:GetUpgradeType() == kCombatUpgradeTypes.Lifeform and (v:GetIsAtMaxLevel() or v:GetCostForNextLevel(player, true) >= 0) then
				TableInsert(self.upgrades_class, {Upgrade = v})
			elseif v:GetUpgradeType() ~= kCombatUpgradeTypes.Lifeform then
				TableInsert(self.upgrades_all, {Upgrade = v})
			end
		end
	end
	
	local windowBox = self.mainWindow:GetContentBox()
	
	--targetForm, upgrades, parent, maxRows, maxColumns, backColor, curvature, spacing
	self.classForm = self:CreateUpgradesForm{targetForm = self.classForm, upgrades = self.upgrades_class, parent = windowBox, maxRows = 0, maxColumns = 1, spacing = Vector(6,20,0)}
	self.classForm:SetBackgroundPosition(Vector(0, (self.mainWindow:GetHeight() - self.classForm:GetHeight())/2, 0))
	TableInsert(self.allForms, self.classForm)
	
	self.allForm = self:CreateUpgradesForm{targetForm = self.allForm, upgrades = self.upgrades_all, parent = windowBox, maxRows = 0, maxColumns = 1, spacing = Vector(6,8,0)}
	self.allForm:SetBackgroundPosition(Vector(831, 174, 0))
	TableInsert(self.allForms, self.allForm)
	
end

function GUICombatBuyMenu:InitializeAlienContent()
	
	Client.SetCursor(k_buyMenu_CursorAlien, 0, 0)
	
	self.mainWindow:SetBackgroundTexture(k_buyMenu_AlienBgTexture)
	self.mainWindow:SetBackgroundSize(Vector(k_buyMenu_WindowWidthAlien, k_buyMenu_WindowHeightAlien, 0))
	self.mainWindow:GetContentBox():SetBackgroundSize(Vector(k_buyMenu_WindowWidthAlien * 1920/self.screenSize.x,k_buyMenu_WindowHeightAlien * 1080/self.screenSize.y, 0), true)
	self.mainWindow:SetBackgroundPosition(Vector((Client.GetScreenWidth() - self.mainWindow:GetWidth())/2, (Client.GetScreenHeight() - self.mainWindow:GetHeight())/2, 0))
	k_buyMenu_BackgroundColor = Color(1,1,1,fadeAlpha)
	self.mainWindow:SetBackgroundColor(k_buyMenu_BackgroundColor)
	self.refundButton:SetBackgroundTexture(k_buyMenu_AlienRefundTexture)
	self.refundButton:SetBackgroundColor(Color(1,1,1,1))
	self.refundButton:SetBackgroundSize(Vector(328, 84, 0))
	self.refundButton:SetBackgroundPosition(Vector((self.mainWindow:GetWidth() - self.refundButton:GetWidth())/2, self.mainWindow:GetHeight() - 100, 0))
	self.refundButton:SetText("")
	local mainWindowBackground = self.mainWindow:GetBackground()
	
	self.levelDisplayText:SetFontName(Fonts.kAgencyFB_Medium)
	
	self.levelDisplayBg:SetTexture(k_buyMenu_AlienLevelTextBacking)
	self.pointTextDisplayBg:SetTexture(k_buyMenu_AlienPointTextBacking)
	self.levelDisplayBg:SetPosition(Vector(-46, 0, 0))
	self.pointTextDisplayBg:SetPosition(Vector(-95, 55, 0))	

	self.pointDisplayBg:SetTexture(k_buyMenu_AlienPointBacking)
	self.pointDisplayBg:SetPosition(mainWindowBackground:GetSize()/2 + Vector(40, 75,0) - self.pointDisplayBg:GetSize()/2)
	
	self.levelDisplayText:SetColor(Color(.5,.25,0,1))
	
	mainWindowBackground:SetShader("shaders/health_bar.surface_shader")
	mainWindowBackground:SetFloatParameter("mirror", 1.0)
	self.mouseOverToolTip:SetResizableBackground("ui/buymenu/Aliens_TT_Full.dds")
	
	--Keys are upgrades, filled out below.  Values are the buttons representing them, filled out in the CreateUpgradesForms--
	self.upgrades_defense = {}
	self.upgrades_offense = {}
	self.upgrades_lifeform = {}
	self.upgrades_classSpecific = {}
	TableInsert(self.allUpgrades, self.upgrades_defense)
	TableInsert(self.allUpgrades, self.upgrades_offense)
	TableInsert(self.allUpgrades, self.upgrades_lifeform)
	TableInsert(self.allUpgrades, self.upgrades_classSpecific)
	
	local player = self:GetPlayer()
	for i, v in ipairs(UpgradeMixin.GetAvailableUpgrades(player)) do
		if v:GetUpgradeTechId() and not v:GetHideUpgrade(player:GetCombatUpgradeList()) then
			if v:GetUpgradeType() == kCombatUpgradeTypes.Defense then
				TableInsert(self.upgrades_defense, {Upgrade = v})
			elseif v:GetUpgradeType() == kCombatUpgradeTypes.Offense then
				TableInsert(self.upgrades_offense, {Upgrade = v})
			elseif v:GetUpgradeType() == kCombatUpgradeTypes.Lifeform and (v:GetIsAtMaxLevel() or v:GetCostForNextLevel(player, true) >= 0) then
				TableInsert(self.upgrades_lifeform, {Upgrade = v})
			elseif v:GetUpgradeType() == kCombatUpgradeTypes.Other then
				TableInsert(self.upgrades_classSpecific, {Upgrade = v})
			end
		end
	end
	local windowBox = self.mainWindow:GetContentBox()
	
	self.LifeformForm = self:CreateUpgradesForm{targetForm = self.LifeformForm, upgrades = self.upgrades_lifeform, parent = windowBox, maxRows = 1, maxColumns = 0, spacing = Vector(10,0,0), curvature = 0.0005}
	self.LifeformForm:SetBackgroundPosition(Vector((self.mainWindow:GetWidth() - self.LifeformForm:GetWidth())/2, 0, 0))
	TableInsert(self.allForms, self.LifeformForm)
	
	self.classSpecificForm = self:CreateUpgradesForm{targetForm = self.classSpecificForm, upgrades = self.upgrades_classSpecific, parent = windowBox, maxRows = 1, maxColumns = 0, spacing = Vector(10,0,0), curvature = -0.002}
	self.classSpecificForm:SetBackgroundPosition(Vector((self.mainWindow:GetWidth() - self.classSpecificForm:GetWidth())/2, self.mainWindow:GetHeight() - 290 , 0))
	TableInsert(self.allForms, self.classSpecificForm)
	
	local sideCurvature = 300
	self.offenseForm = self:CreateUpgradesForm{targetForm = self.offenseForm, upgrades = self.upgrades_offense, parent = windowBox, maxRows = 0, maxColumns = 1, spacing = Vector(0,10,0), curvature = -sideCurvature}
	self.offenseForm:SetBackgroundPosition(Vector(100, (self.mainWindow:GetHeight() - self.offenseForm:GetHeight())/2 + 40, 0))
	TableInsert(self.allForms, self.offenseForm)

	self.defenseForm = self:CreateUpgradesForm{targetForm = self.defenseForm, upgrades = self.upgrades_defense, parent = windowBox, maxRows = 0, maxColumns = 1, spacing = Vector(0,10,0), curvature = sideCurvature}
	self.defenseForm:SetBackgroundPosition(Vector(self.mainWindow:GetWidth() - self.defenseForm:GetWidth() - 120, (self.mainWindow:GetHeight() - self.defenseForm:GetHeight())/2 + 40, 0))
	TableInsert(self.allForms, self.defenseForm)

	--Make the tentacles
	if not self.tentacles or #self.tentacles == 0 then
		self.tentacles = {}
		for i, tentacleInfo in ipairs(k_buyMenu_TentaclePositions) do
			local tex = tentacleInfo.tex
			local mask = tentacleInfo.mask
			local pos = Vector(tentacleInfo.x, tentacleInfo.y, 0)
			local size = Vector(tentacleInfo.width, tentacleInfo.height, 0)
			
			local tentacle = GUIManager.CreateGraphicItem()
			tentacle:SetPosition(pos)
			tentacle:SetInheritsParentAlpha(true)
			tentacle:SetShader("shaders/GUIAlien.surface_shader")
			tentacle:SetTexture(tex)
			tentacle:SetAdditionalTexture("wavyMask", mask)
			tentacle:SetSize(size)
			tentacle:SetLayer(20-i)
			tentacle:SetFloatParameter("periodParam", math.random())	
			mainWindowBackground:AddChild(tentacle)
			
			self.tentacles[i] = tentacle
		end
	end
	
end

--fills the targetForm with menubuttons, storing references in upgrades.  either maxRows or maxColumns must be zero (the other one determines the shape)
function GUICombatBuyMenu:CreateUpgradesForm(options)
	local targetForm = options.targetForm
	local upgrades = options.upgrades
	local parent = options.parent
	local maxRows = options.maxRows
	local maxColumns = options.maxColumns
	local backColor = options.backColor
	local curvature = options.curvature
	local spacing = options.spacing
	
	assert(maxRows == 0 or maxColumns == 0)
	
	--GetWindowManager():SetElementInactive() -- shit sucks, gotta do what i gotta do son
	
	if targetForm ~= nil then
		targetForm:Uninitialize()
	end
	targetForm = CreateMenuElement(parent, "Form", false)
	
	
	local maxRowIndex = 0
	local maxColIndex = 0
	
	if maxColumns ~= 0 then
		maxRows = math.ceil(#upgrades/maxColumns)
	else
		maxColumns = math.ceil(#upgrades/maxRows)
	end
	maxColIndex = maxColumns - 1
	maxRowIndex = maxRows - 1
	
	local horizontal = maxColIndex >= maxRowIndex
	
	table.sort(upgrades, function(a, b) return a.Upgrade:GetMinPlayerLevel() < b.Upgrade:GetMinPlayerLevel() end)
	
	
	local currentRow = 0
	local currentCol = 0
	for i, upgradeItem in ipairs(upgrades) do
		local upgrade = upgradeItem.Upgrade
		local upButton = CreateMenuElement(targetForm, "MenuButton")
		upButton:DisableMouseClickSound()
		upButton:SetIsVisible(false)
		upButton:SetCSSClass("upgrade_button")
		local size = upgrade:GetImageSize()
		upButton:SetBackgroundSize(size)
		upButton:SetBackgroundTexture(upgrade:GetTexture())
		local upBg = upButton:GetBackground()
		--upBg:SetInheritsParentAlpha(true)
		upBg:SetShader(k_buyMenu_IconShader)
		local mask, glow = upgrade:GetOverlayTextures()
		upBg:SetAdditionalTexture("maskMap", mask)
		upBg:SetAdditionalTexture("glowMap", glow)
		upBg:SetFloatParameter("marines", upgrade.teamType == kCombatUpgradeTeamType.MarineTeam and 1 or 0)
		local frame = ""
		local rotation = 0
		upButton:GetText():SetLayer(100)
		local costBacking = GUIManager:CreateGraphicItem()
		costBacking:SetInheritsParentAlpha(true)
		costBacking:SetSize(Vector(20, 21, 0))
		costBacking:SetPosition(Vector(0,0,0))
		if self:GetTeamType() == "Aliens" then
			costBacking:SetTexture(k_buyMenu_AlienPointBacking)
		else
			costBacking:SetTexture(k_buyMenu_MarinePointBacking)	
		end
		upBg:AddChild(costBacking)
		upButton.CostBacking = costBacking
		
		local costText = GUIManager:CreateTextItem()
		costText:SetInheritsParentAlpha(true)
		costText:SetFontName(Fonts.kAgencyFB_Tiny)
		costText:SetTextAlignmentX(GUIItem.Align_Center)
		costText:SetTextAlignmentY(GUIItem.Align_Min)
		costText:SetAnchor(GUIItem.Left, GUIItem.Top)
		costText:SetText(ToString(upgrade:GetCostForNextLevel(self:GetPlayer())))
		costText:SetInheritsParentAlpha(true)
		costText:SetPosition(Vector(10,1,0))
		upBg:AddChild(costText)
		upButton.CostText = costText
		
		if maxRows == 1 or maxColumns == 1 then
			if horizontal then
				if currentCol ~= 0 and currentCol ~= maxColIndex then
					frame = k_buyMenu_StraightMultiFrame
				else
					frame = k_buyMenu_WrapFrame
					if currentCol == maxColIndex then
						rotation = kPi
					end
				end
			else
				rotation = -kPi/2
				if currentRow ~= 0 and currentRow ~= maxRowIndex then
					frame = k_buyMenu_StraightMultiFrame
				else
					frame = k_buyMenu_WrapFrame
					if currentRow == maxRowIndex then
						rotation = rotation + kPi
					end
				end
			end
		else
			if currentCol == 0 then
				if currentRow ~= 0 and currentRow ~= maxRowIndex then
					frame = k_buyMenu_StraightFrame
					rotation = kPi/2
				else
					frame = k_buyMenu_CornerFrame
					if currentRow == 0 then
						rotation = -kPi/2
					end
				end
			elseif currentCol == maxColIndex then
				if currentRow ~= 0 and currentRow ~= maxRowIndex then
					frame = k_buyMenu_StraightFrame
					rotation = -kPi/2
				else
					rotation = kPi
					frame = k_buyMenu_CornerFrame
					if currentRow == maxRowIndex then
						rotation = kPi/2
					end
				end
			else
				if currentRow == 0 or currentRow == maxRowIndex then
					frame = k_buyMenu_StraightFrame
					if currentRow == maxRowIndex then
						rotation = kPi
					end
				end
			end
		end
		
		-- upButton:SetFrameTexture(frame)
		-- if frame ~= "" then
			-- upButton:GetFrame():SetRotation(Vector(0,0,rotation))
			-- upButton:SetFrameSize(k_buyMenu_IconFrameSize)
		-- end
		upButton:SetBackgroundPosition(Vector((size.x + spacing.x) * currentCol, (size.y + spacing.y) * currentRow, 0))
		upButton:AddEventCallbacks(
					{
						OnMouseDown = function(self)
							if fadeAlpha > .1 then -- ramification of click hack on line 524
								g_buyMenu:GetPlayer():BuyUpgrade(upgrade:GetId())
							end
						end,
						OnMouseIn = function(self)
							if g_buyMenu:GetIsVisible() then
								g_buyMenu:MouseOverChanged(upgrade, self)
							end
						end,
						OnMouseOut = function(self)
							if g_buyMenu:GetIsVisible() then
								g_buyMenu:MouseOverExit()
							end
						end
					}
				)
				
		local buttonText = upButton:GetText()
		local textPos = buttonText:GetPosition()
		textPos.y = textPos.y + 8
		buttonText:SetPosition(textPos)
		-- buttonText:SetAnchor(GUIItem.Left, GUIItem.Top)
		-- buttonText:SetTextAlignmentX(GUIItem.Align_Center)
		-- buttonText:SetTextAlignmentY(GUIItem.Align_Center)
		
		
			local litLevelTicks = {}
			local unlitLevelTicks = {}
			local maxLevels = upgrade:GetMaxLevels()
			if(maxLevels > 1) then
				for level = 1, maxLevels do
					local litTick = GUIManager:CreateGraphicItem()
					litTick:SetInheritsParentAlpha(true)
					litTick:SetLayer(102)
					litTick:SetSize(Vector(upButton:GetWidth(), upButton:GetHeight(), 0))
					litTick:SetAnchor(GUIItem.Left, GUIItem.Top)
					local unlitTick = GUIManager:CreateGraphicItem()
					unlitTick:SetInheritsParentAlpha(true)
					unlitTick:SetSize(Vector(upButton:GetWidth(), upButton:GetHeight(), 0))
					unlitTick:SetAnchor(GUIItem.Left, GUIItem.Top)
					unlitTick:SetLayer(101)
					if upgrade:GetTeamType() == kAlienTeamType then
						unlitTick:SetTexture(k_buyMenu_AlienLevelTicksOff[level])
						unlitTick:SetColor(Color(1,1,0,1))
						litTick:SetTexture(k_buyMenu_AlienLevelTicksOn[level])
					else
						local tickPos = Vector(upButton:GetWidth()*.96, -8 * level + 12, 0)
						unlitTick:SetTexture(k_buyMenu_MarineLevelTickOff)
						unlitTick:SetPosition(tickPos)
						litTick:SetTexture(k_buyMenu_MarineLevelTickOn)
						litTick:SetPosition(tickPos)
					end
					unlitTick:SetTexturePixelCoordinates(0, 0, 128,128)
					litTick:SetTexturePixelCoordinates(0, 0, 128,128)
					litTick:SetIsVisible(false)
					upButton:GetBackground():AddChild(unlitTick)
					upButton:GetBackground():AddChild(litTick)
					TableInsert(litLevelTicks, litTick)
					TableInsert(unlitLevelTicks, unlitTick)
				end
				if upgrade:GetTeamType() == kAlienTeamType then
					-- local startTick = GUIManager:CreateGraphicItem()
					-- startTick:SetSize(Vector(upButton:GetWidth(), upButton:GetHeight(), 0))
					-- startTick:SetAnchor(GUIItem.Left, GUIItem.Top)
					-- startTick:SetTexture(k_buyMenu_AlienLevelTicksStart)
					-- startTick:SetTexturePixelCoordinates(0, 0, 128,128)
					-- upButton:GetBackground():AddChild(startTick)

					-- local endTick = GUIManager:CreateGraphicItem()
					-- endTick:SetSize(Vector(upButton:GetWidth(), upButton:GetHeight(), 0))
					-- endTick:SetAnchor(GUIItem.Left, GUIItem.Top)
					-- endTick:SetRotation(Vector(0,0, (maxLevels - 5) *  2 * kPi * .1))
					-- endTick:SetTexture(k_buyMenu_AlienLevelTicksEnd)
					-- endTick:SetTexturePixelCoordinates(0, 0, 128,128)
					-- upButton:GetBackground():AddChild(endTick)
				end
			end		
		upButton.LitTicks = litLevelTicks
		upButton.UnlitTicks = unlitLevelTicks
		upgradeItem.Button = upButton
		
		if horizontal then
			currentCol = currentCol + 1
			if currentCol == maxColumns then
				currentCol = 0
				currentRow = currentRow + 1
			end
		else
			currentRow = currentRow + 1
			if currentRow == maxRows then
				currentRow = 0
				currentCol = currentCol + 1
			end
		end

	end
	
	local maxExtents = Vector(0,0,0)
	local minExtents = Vector(0,0,0)
	for i, v in pairs(targetForm:GetChildren()) do
		local thisMaxX = v:GetBackgroundPosition().x + v:GetWidth()
		if thisMaxX > maxExtents.x then
			maxExtents.x = thisMaxX
		end
		local thisMaxY = v:GetBackgroundPosition().y + v:GetHeight()
		if thisMaxY > maxExtents.y then
			maxExtents.y = thisMaxY
		end
		local thisMinX = v:GetBackgroundPosition().x
		if thisMinX < minExtents.x then
			minExtents.x = thisMinX
		end
		local thisMinY = v:GetBackgroundPosition().y
		if thisMinY < minExtents.y then
			minExtents.y = thisMinY
		end
	end
	
	if curvature and #targetForm:GetChildren() > 0 then
		local curvSqrd = curvature*curvature
		local sign = 1 
		if (curvature ~= math.abs(curvature)) then
			sign = -1
		end
		
		if horizontal then
			local iconSize = Vector(targetForm:GetChildren()[1]:GetWidth(), targetForm:GetChildren()[1]:GetHeight(), 0)
			local xZero = minExtents.x + (maxExtents.x - minExtents.x)/2 -- center of the form
			local yZero = minExtents.y + (maxExtents.y - minExtents.y)/2 -- baseline for y calcs
			local numChildren = #targetForm:GetChildren()
			for i, v in pairs(targetForm:GetChildren()) do
				local xPos = xZero - (v:GetBackgroundPosition().x + v:GetWidth()/2)
				local yPos = yZero + curvature*xPos*xPos
				v:SetBackgroundPosition(Vector(v:GetBackgroundPosition().x, yPos, 0))
			end
		else
			local iconSize = Vector(targetForm:GetChildren()[1]:GetWidth(), targetForm:GetChildren()[1]:GetHeight(), 0)
			local yZero = (maxExtents.y - minExtents.y)/2 -- center of the form
			if curvature > 0 then
				local xZero = math.sqrt(curvSqrd - (math.pow(yZero - iconSize.y/2, 2))) - iconSize.x/2 --subtract this off from all future x calcs
				local numChildren = #targetForm:GetChildren()
				for i, v in pairs(targetForm:GetChildren()) do
					local yPos = yZero - (v:GetBackgroundPosition().y + v:GetHeight()/2)
					local xPos = math.sqrt(curvSqrd - yPos*yPos) - xZero
					v:SetBackgroundPosition(Vector(xPos - v:GetWidth()/2, v:GetBackgroundPosition().y, 0))
				end
			else
				local numChildren = #targetForm:GetChildren()
				for i, v in pairs(targetForm:GetChildren()) do
					local yPos = yZero - (v:GetBackgroundPosition().y + v:GetHeight()/2)
					local xPos = -(curvature + math.sqrt(curvSqrd - yPos*yPos)) + iconSize.x/2
					v:SetBackgroundPosition(Vector(xPos - v:GetWidth()/2, v:GetBackgroundPosition().y, 0))
				end
			end
		end
	end
	
	--recalculate extents again after curvature
	for i, v in pairs(targetForm:GetChildren()) do
		local thisMaxX = v:GetBackgroundPosition().x + v:GetWidth()
		if thisMaxX > maxExtents.x then
			maxExtents.x = thisMaxX
		end
		local thisMaxY = v:GetBackgroundPosition().y + v:GetHeight()
		if thisMaxY > maxExtents.y then
			maxExtents.y = thisMaxY
		end
		local thisMinX = v:GetBackgroundPosition().x
		if thisMinX < minExtents.x then
			minExtents.x = thisMinX
		end
		local thisMinY = v:GetBackgroundPosition().y
		if thisMinY < minExtents.y then
			minExtents.y = thisMinY
		end
	end
	
	
	targetForm:SetCSSClass("upgrades")
	targetForm:SetBackgroundSize(maxExtents - minExtents, true)
	if backColor ~= nil then
		--targetForm:SetBackgroundColor(backColor)
	end
	return targetForm
end

function GUICombatBuyMenu:MouseOverChanged(upgrade, upButton)
	self.selectedUpgrade = upgrade
	self.selectedButton = upButton
	local title = upgrade:GetUpgradeTitle()
	local cost = upgrade:GetCostForNextLevel(self:GetPlayer(), true)	
	title = StringFormat("%s: %s %s", title, (cost == 0 and Locale.ResolveString("FREE"))	or (cost > 0 and cost < 10 and cost) or Locale.ResolveString("MAXED"), cost > 0 and cost < 10 and ( cost < 2 and "PT" or "PTS") or "", descText )
	
	local descText = upgrade:GetUpgradeDesc(self:GetPlayer())
	local name = upgrade:GetUpgradeName()
	if upgrade:GetUpgradeType() == kCombatUpgradeTypes.Lifeform or name == "jetpack" or name == "minigunexo" or name == "railgunexo" then
		local extraTime = kSpawnLifeformPenalties[upgrade:GetUpgradeTitle()]
		if name == "jetpack" then
			extraTime = kSpawnLifeformPenalties["JetpackMarine"]
		elseif name == "minigunexo" or name == "railgunexo" then
			extraTime = kSpawnLifeformPenalties["Exo"]
		end
		if extraTime and extraTime > 0 then
			descText = GetTranslationString( "RESPAWN_TIME_EXTEND", { upDesc = descText, secs = extraTime })
		end
	end
	self.mouseOverToolTip:SetText(title)
	self.mouseOverToolTip:SetDescription(descText)
	
	local buttonPos = self.mainWindow:GetBackgroundPosition() + upButton:GetParent():GetBackgroundPosition() + upButton:GetBackgroundPosition()
	local targetPos
	if buttonPos.x > self.screenSize.x/2 then
		targetPos = Vector(buttonPos.x + upButton:GetBackground():GetSize().x, buttonPos.y + upButton:GetBackground():GetSize().y, 0)
	else
		targetPos = Vector(buttonPos.x - 256, buttonPos.y + upButton:GetBackground():GetSize().y, 0)
	end
	
	self.mouseOverToolTip:SetPosition(targetPos)	
	if upgrade:GetDetailImage() ~= "" and self.weaponDetail then
		self.weaponDetail:SetTexture(upgrade:GetDetailImage())
		self.weaponDetail:SetIsVisible(true)
	end
end

function GUICombatBuyMenu:MouseOverExit()
	self.selectedUpgrade = nil
	self.mouseOverToolTip:SetText("")
	if self.mouseOverToolTip then
		self.mouseOverToolTip:SetIsVisible(false)
	end
    if self.weaponDetail then
        self.weaponDetail:SetIsVisible(false)
    end
end

function GUICombatBuyMenu:MouseOverRefund()
	local title = Locale.ResolveString("REFUND_ALL")
	local descText = Locale.ResolveString("REFUND_ALL_DESCRIPTION")
	local timeRemaining = self:GetPlayer():RefundCooldownRemaining()
	if timeRemaining ~= 0 then
		descText = GetTranslationString( "REFUND_ALL_TIME_REMAINING" , { descText = descText, time = string.DigitalTime(timeRemaining) })
	end
	
	local buttonPos = self.mainWindow:GetBackgroundPosition() + self.refundButton:GetBackgroundPosition()
	local targetPos
	if buttonPos.x > self.screenSize.x/2 then
		targetPos = Vector(buttonPos.x + self.refundButton:GetBackground():GetSize().x, buttonPos.y + self.refundButton:GetBackground():GetSize().y, 0)
	else
		targetPos = Vector(buttonPos.x - 256, buttonPos.y + self.refundButton:GetBackground():GetSize().y, 0)
	end
	
	self.mouseOverToolTip:SetPosition(targetPos)	
	
	self.mouseOverToolTip:SetText(title)
	self.mouseOverToolTip:SetDescription(descText)
end

function GUICombatBuyMenu:MouseOverRefundExit()
	self.mouseOverToolTip:SetText("")
end

function GUICombatBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)
	self.screenSize = Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0)
	self.mainWindow:SetBackgroundPosition(Vector((self.screenSize.x - self.mainWindow:GetWidth())/2, (self.screenSize.y - self.mainWindow:GetHeight())/2, 0))
end

function GUICombatBuyMenu:SendKeyEvent(key, down)

	local closeMenu = false
	local inputHandled = false

	if not self:GetIsVisible() then
		return false
	end

	if key == InputKey.MouseButton0 and down then

		inputHandled = true
		closeMenu = not self:GetIsMouseOver()

	end

	-- if (key == InputKey.MouseWheelDown or key == InputKey.MouseWheelUp) and self:GetIsMouseOver() then
		-- inputHandled = true
	-- end

	if closeMenu then
		self:GetPlayer():CloseMenu()
	end

	return inputHandled

end

function GUICombatBuyMenu:Update(deltaTime)
	local player = self:GetPlayer()
	local team = self:GetTeamType()
	self.close = self.close or (player == nil or player:isa("Spectator") or team == "Spectator" or not Client.GetIsControllingPlayer())

	
	local newTeam = false
	if (self.playerTeam ~= self:GetTeamType()) then
		self.playerTeam = self:GetTeamType()
		newTeam = true
	end
	
	if newTeam then
		self:UninitializeAllContent()
		self:InitializeAllContent()
	end
	
	if player == nil or (self.close and not self:GetIsVisible()) then
		return
	end
	
	self.levelDisplayText:SetText(StringFormat("Level %s", player:GetLvl()))
	local points = player:GetUpgradePointsAvailable()
    self.pointDisplayText:SetText(ToString(points))
	if points > 0 then
		if self:GetTeamType() == "Aliens" then
			self.pointDisplayText:SetColor(Color(.65,1,0,1))
			self.pointPrefixText:SetColor(Color(.65,1,0,1))
		else
			self.pointDisplayText:SetColor(Color(0,1,.5,1))
			self.pointPrefixText:SetColor(Color(0,1,.5,1))
		end
	else
		self.pointDisplayText:SetColor(Color(1,0,0,1))
		self.pointPrefixText:SetColor(Color(1,0,0,1))
	end
	
	for i, upgradeSet in ipairs(self.allUpgrades) do
		self:UpdateOverlays(upgradeSet)
	end
	
	if self:GetIsMouseOver() and GUIItemContainsPoint(self.refundButton.background, Client.GetCursorPosScreen()) then
		self:MouseOverRefund()
	end
	
	
    self:PlayFadeAnimation()

    if self.close then
		self:Close()
	    self:SetPlayAnimation("hide")
		if (fadeAlpha == 0 or not self:GetIsVisible()) then
			fadeAlpha = 0
			self:SetIsVisible(false)
		end
	else
	    self:SetPlayAnimation("show")
	end	
end

function GUICombatBuyMenu:Open(instant)
	if self.close == true then		
		self.switchTime = instant and 0 or Shared.GetTime()
		self.close = false
	end
end

function GUICombatBuyMenu:Close(instant)
	if not self.close then	
		self:MouseOverExit()
		self.close = true
		self.switchTime = instant and 0 or Shared.GetTime()
		if self:GetTeamType() == "Marines" then
			StartSoundEffect(CombatClientEffects.kMarineBuyMenuDeSpawn)
		elseif self:GetTeamType() == "Aliens" then
			StartSoundEffect(CombatClientEffects.kAlienBuyMenuDeSpawn)
		end
	end
end

function GUICombatBuyMenu:OnUpgradesChanged()
	--Shared.Message("Buy Menu Refreshed - player id is " .. self:GetPlayer():GetId())
	self:UninitializeAllContent()
	self:InitializeAllContent()
	for i, upgradeSet in ipairs(self.allUpgrades) do
		self:UpdateOverlays(upgradeSet)
		for j, upgradeItem in pairs(upgradeSet) do
			local upgrade = g_localUpgradeList:GetUpgradeById(upgradeItem.Upgrade:GetId())
			local button = upgradeItem.Button
			for k, tick in pairs(button.LitTicks) do
				if upgrade:GetCurrentLevel() >= k then
					tick:SetIsVisible(true)
				else
					tick:SetIsVisible(false)
				end
			end
		end
	end
end

function GUICombatBuyMenu:GetOverlaySetup(upgrade, player)
	local setup = {}
	setup.Font = Fonts.kInsight
	setup.Text = ""
	setup.TextPosition = Vector(0,0,0)
	setup.State = 0--buyable
	if upgrade:GetIsAtMaxLevel() or (upgrade:GetCurrentLevel() > 0 and g_myResources < upgrade:GetCostForNextLevel()) then
		setup.State = 1--maxed, effectively or truly
	elseif upgrade:GetMinPlayerLevel() > g_myLevel then
		setup.State = 2--not a high enough level
		setup.Text = StringFormat("LV %s", upgrade:GetMinPlayerLevel())
	elseif player and not player:GetCanBuyUpgrade(upgrade:GetId()) then
		setup.State = 3--can't buy
	end
	return setup
end

function GUICombatBuyMenu:UpdateOverlays(upgradeItems)
	local player = self:GetPlayer()
	for i, upgradeItem in pairs(upgradeItems) do
		local upgrade = upgradeItem.Upgrade
		local button = upgradeItem.Button
		local overlaySetup = self:GetOverlaySetup(upgrade, player)
		button:SetCanHighlight(overlaySetup.State ~= 2 and overlaySetup.State ~=3)
		local upMsg = player:GetCanBuyUpgradeMessage(upgrade:GetId())
		local costVisible = upMsg == "" or upMsg == "Cannot afford upgrade"

		if overlaySetup.State == 3 then
			button:GetBackground():SetFloatParameter("state", 2)
		else
			button:GetBackground():SetFloatParameter("state", overlaySetup.State)
		end
		if upgrade == self.selectedUpgrade then
			self:MouseOverChanged(upgrade, button)
		end
		button:SetText(overlaySetup.Text)
		if player and upMsg == "Cannot afford upgrade" then
			button.CostText:SetColor(Color(1, 0, 0, 1))
		else
			if self:GetTeamType() == "Aliens" then
				button.CostText:SetColor(Color(1, .75, 0, 1))
			else
				button.CostText:SetColor(Color(.26, 1, 1, 1))
			end
		end
		if overlaySetup.State == 2 then
			if self:GetTeamType() == "Aliens" then
				button:SetOverlayTexture(k_buyMenu_AlienIconLockOverlay)
			else
				button:SetOverlayTexture(k_buyMenu_MarineIconLockOverlay)
			end
		elseif overlaySetup.State == 3 and upMsg == "You must be near an armory or tech point to take this upgrade" then
			button:SetOverlayTexture(k_buyMenu_MarineArmoryIconLockOverlay)
		else		
			button:SetOverlayTexture("")
		end
		button.CostText:SetIsVisible(costVisible)
		button.CostBacking:SetIsVisible(costVisible)
		-- button:SetOverlayTexture(overlaySetup.Overlay)
		-- --button:GetBackground():SetColor(overlaySetup.ButtonColor)
		-- if self:GetTeamType() == "Aliens" then
			-- button:SetTextColor(Color(.75, 1, 0, 1))
		-- else
			-- button:SetTextColor(Color(.26, 1, 1, 1))
		-- end
		-- local buttonText = button:GetText()
		-- --buttonText:SetTextClipped(true, button:GetWidth(true), button:GetHeight(true))
		-- buttonText:SetPosition(overlaySetup.TextPosition)
		-- local textSize = Vector(button:GetBackground():GetTextWidth(buttonText:GetText()), button:GetBackground():GetTextHeight(buttonText:GetText()), 0)
		-- --buttonText:SetPosition(Vector((button:GetWidth(true) - textSize.x)/2, (button:GetHeight(true) - textSize.y)/2, 0))
		-- --buttonText:SetPosition(Vector(0,0,0))
		-- button:SetFontName(overlaySetup.Font)
		-- local overlay = button:GetOverlay()
		-- if overlay then
			-- overlay:SetColor(overlaySetup.OverlayColor)
		-- end
	 end
end

function GUICombatBuyMenu:PlayFadeAnimation()

	if playAnimation == "show" then
		self:ShowAnimation()
	elseif playAnimation == "hide" then
		self:HideAnimation()
	end
	
   
end

function GUICombatBuyMenu:SetPlayAnimation(animType)
    playAnimation = animType
	if self.mouseOverToolTip and self.mouseOverToolTip:GetPlayAnimation() == "show" then
		self.mouseOverToolTip:SetPlayAnimation(animType)
	end
end

function GUICombatBuyMenu:ShowAnimation()
	if not self.switchTime or self.close then return end
	
	if not self:GetIsVisible() then 
		if Client and self:GetTeamType() == "Marines" then
			StartSoundEffect(CombatClientEffects.kMarineBuyMenuSpawn)
		else
			StartSoundEffect(CombatClientEffects.kAlienBuyMenuSpawn)
		end
		self:SetIsVisible(true)
		MouseTracker_SendKeyEvent(InputKey.MouseButton0, false) --hack, for some reason the window won't be active until we click on it
	end
		
	local timeRemaining = fadeTime - (Shared.GetTime() - self.switchTime)
	if timeRemaining >= 0 then
		fadeAlpha = alphaLimit * (1 - timeRemaining/fadeTime)
	else
		fadeAlpha = alphaLimit
	end
	self:UpdateTransparency()
end

function GUICombatBuyMenu:SetIsVisible(state)
	GUIAnimatedScript.SetIsVisible(self, state)
	if self.mouseOverToolTip then
		self.mouseOverToolTip:SetIsVisible(state)
	end
	
	if state == false then
		self:MouseOverExit()
	end
end

function GUICombatBuyMenu:HideAnimation()
	if not self.switchTime then return end
	local timeRemaining = fadeTime - (Shared.GetTime() - self.switchTime)
	if timeRemaining >= 0 then
		fadeAlpha = alphaLimit * timeRemaining/fadeTime
	else
		self:SetIsVisible(false)
		fadeAlpha = 0
	end
	self:UpdateTransparency()
end

function GUICombatBuyMenu:UpdateTransparency()
	-- Check for missing player and deal with it
	if not self:GetPlayer() then 
		return
	end
	k_buyMenu_BackgroundColor.a = fadeAlpha
	local bgCol = k_buyMenu_BackgroundColor
	if self.playerTeam == "Marines" then
		bgCol.a = bgCol.a * k_buyMenu_MarineBgAlpha;
	else
		bgCol.a = bgCol.a * k_buyMenu_AlienBgAlpha;
	end
	self.mainWindow:SetBackgroundColor(bgCol)
	self.refundButton:SetIsVisible(fadeAlpha > 0)
	self.refundButton:GetBackground():SetColor(Color(1,1,1,fadeAlpha))
	-- self.pointDisplayBg:SetColor(Color(1,1,1,fadeAlpha))
	
	-- local levelTextCol = self.levelDisplayText:GetColor()
	-- levelTextCol.a = fadeAlpha
	-- self.levelDisplayText:SetColor(levelTextCol)
	
	-- local pointTextCol = self.pointDisplayText:GetColor()
	-- pointTextCol.a = fadeAlpha
	-- self.pointDisplayText:SetColor(pointTextCol)
	
	-- if self.lifeFormImage~= nil then
		-- self.lifeFormImage:SetColor(k_buyMenu_BackgroundColor)
	-- end
	for i, upgradeSet in ipairs(self.allUpgrades) do
		for j, upgradeItem in pairs(upgradeSet) do
			local upgrade = g_localUpgradeList:GetUpgradeById(upgradeItem.Upgrade:GetId())
			local button = upgradeItem.Button
			button:SetIsVisible(fadeAlpha > 0)
			local buttonColor = button:GetBackground():GetColor()
			buttonColor.a = fadeAlpha
			button:SetBackgroundColor(buttonColor)
			
			button:SetOverlayAlpha(fadeAlpha)
			
			local text = button:GetText()
			local textCol = text:GetColor()
			textCol.a = fadeAlpha
			text:SetColor(textCol)
			
			button.CostBacking:SetColor(Color(1,1,1,fadeAlpha))
			local costCol = button.CostText:GetColor()
			costCol.a = fadeAlpha
			button.CostBacking:SetColor(costCol)
			
			for k, tick in pairs(button.LitTicks) do
				local tickColor = tick:GetColor()
				tickColor.a = fadeAlpha
				tick:SetColor(tickColor)
			end
			for k, tick in pairs(button.UnlitTicks) do
				local tickColor = tick:GetColor()
				tickColor.a = fadeAlpha
				tick:SetColor(tickColor)
			end
		end
		--self:UpdateOverlays(upgradeSet)
	end
	-- if self.tentacles then
		-- for i, tentacle in ipairs(self.tentacles) do
			-- local color = tentacle:GetColor()
			-- color.a = fadeAlpha
			-- tentacle:SetColor(color)
		-- end
	-- end	
end

--#$#$-- Helper Functions --#$#$--
function GUICombatBuyMenu:GetIsMouseOver()
	return GUIItemContainsPoint(self.mainWindow, Client.GetCursorPosScreen())
end

function GUICombatBuyMenu:GetTeamType()

	local teamnumber = g_lastPlayerTeamNumber
	if teamnumber == nil then return "Unknown" end
	local teamType = GetGamerulesInfo():GetTeamType(teamnumber)
	if teamType == kMarineTeamType then
		return "Marines"
	elseif teamType == kAlienTeamType then
		return "Aliens"
	elseif teamType == kNeutralTeamType then
		return "Spectator"
	else
		return "Unknown"
	end

end

function GUICombatBuyMenu:GetScreenScale() -- multiply this by your texture sizes and wrap the whole operation in GUIScale()

	local screenSize = Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0)
	local ratio = screenSize.x / screenSize.y
	local bgScale = Vector(0,0,0)

	if math.abs(ratio - k_buyMenu_DesignRatio) > .01 then --if it's not a 16:9 ratio
		if ratio > k_buyMenu_DesignRatio then -- use the vertical as the max extents
			bgScale = Vector(screenSize.y * k_buyMenu_DesignRatio, screenSize.y, 0)
		else -- use the horizontal as the max extents
			bgScale = Vector(screenSize.x, screenSize.x/k_buyMenu_DesignRatio, 0)
		end
	else
		bgScale = Vector(screenSize.x, screenSize.y, 0)
	end

	return Vector(bgScale.x/k_buyMenu_DesignWidth * .87, bgScale.y/k_buyMenu_DesignHeight * .87, 0)

end

function GUICombatBuyMenu:GetPlayer()
	
	-- Return localplayer for now until we have time to fix the real deal.
	return Client.GetLocalPlayer()
	
end

--#$#$-- End Helper Functions --#$#$--