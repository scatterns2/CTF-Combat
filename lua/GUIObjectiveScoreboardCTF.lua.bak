//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// GUIObjectiveScoreboardCTF.lua

Script.Load("lua/Utility.lua")

class 'GUIObjectiveScoreboardCTF' (GUIAnimatedScript)

GUIObjectiveScoreboardCTF.kMarinesIcon = PrecacheAsset("ui/Combat/cp/cp_score_bar.dds")
GUIObjectiveScoreboardCTF.kAliensIcon = PrecacheAsset("ui/Combat/cp/cp_score_bar_alien.dds")
GUIObjectiveScoreboardCTF.kGlowIcon = PrecacheAsset("ui/Combat/cp/capped_cp_glow.dds")        

GUIObjectiveScoreboardCTF.kMarinesBackgroundTexture = PrecacheAsset("ui/Combat/cp/cp_score_bar_bg.dds")
GUIObjectiveScoreboardCTF.kBackgroundNoiseTexture = PrecacheAsset("ui/alien_commander_bg_smoke.dds")
GUIObjectiveScoreboardCTF.kAlienBackgroundTexture = PrecacheAsset("ui/alien_HUD_presbg.dds")

GUIObjectiveScoreboardCTF.kCommandChairOffsetX = GUIScale(-300)
GUIObjectiveScoreboardCTF.kCommandChairOffsetY = GUIScale(5)
GUIObjectiveScoreboardCTF.kCommandChairTextOffset = Vector(GUIScale(10), 0, 0)

GUIObjectiveScoreboardCTF.kHiveOffsetX = GUIScale(300)
GUIObjectiveScoreboardCTF.kHiveOffsetY = GUIScale(5)
GUIObjectiveScoreboardCTF.kHiveTextOffset = Vector(-GUIScale(100), 0, 0)

GUIObjectiveScoreboardCTF.kCaptureIconNeutralTexture = PrecacheAsset("ui/Combat/cp/p1.dds")
GUIObjectiveScoreboardCTF.kCaptureIconWidth = GUIScale(80)
GUIObjectiveScoreboardCTF.kCaptureIconHeight = GUIScale(80)
GUIObjectiveScoreboardCTF.kCaptureOffsetTop = GUIScale(40)
GUIObjectiveScoreboardCTF.kCaptureOffsetRight = GUIScale(30)
GUIObjectiveScoreboardCTF.kCaptureIconOffset = Vector(-GUIScale(50), 
                                                            GUIObjectiveScoreboardCTF.kCaptureIconHeight + GUIObjectiveScoreboardCTF.kCaptureOffsetTop , 0)
                                                            
GUIObjectiveScoreboardCTF.kTopCaptureIconWidth = GUIScale(384)
GUIObjectiveScoreboardCTF.kTopCaptureIconHeight = GUIScale(48)

GUIObjectiveScoreboardCTF.kCurrentCaptureIconWidth = GUIScale(100)
GUIObjectiveScoreboardCTF.kCurrentCaptureIconHeight = GUIScale(100)                                                            
GUIObjectiveScoreboardCTF.kCurrentCaptureYOffset = GUIScale(200)

GUIObjectiveScoreboardCTF.kHealthFontName = Fonts.kAgencyFB_Small
GUIObjectiveScoreboardCTF.kHealthFontSize = 18
GUIObjectiveScoreboardCTF.kHealthFontBold = true
GUIObjectiveScoreboardCTF.kHealthFondColor = kMarineFontColor

GUIObjectiveScoreboardCTF.kBackgroundColor = Color(1, 1, 1, 0.7)
GUIObjectiveScoreboardCTF.kMarineTextColor = kMarineFontColor
GUIObjectiveScoreboardCTF.kAlienTextColor = kAlienFontColor
GUIObjectiveScoreboardCTF.kGlowColor = Color(1, 1, 0, 1)

GUIObjectiveScoreboardCTF.height = 128
GUIObjectiveScoreboardCTF.width = 128

GUIObjectiveScoreboardCTF.glowHeight = 160
GUIObjectiveScoreboardCTF.glowWidth = 160

GUIObjectiveScoreboardCTF.kAttentionTexture = "ui/commanderping.dds"
GUIObjectiveScoreboardCTF.kAttentionIconHeight = 70
GUIObjectiveScoreboardCTF.kAttentionIconWidth = 80
GUIObjectiveScoreboardCTF.kAttentionIconOffset = Vector(GUIScale(0), GUIObjectiveScoreboardCTF.kCaptureIconHeight + GUIObjectiveScoreboardCTF.kCaptureOffsetTop , 0)


function GUIObjectiveScoreboardCTF:Initialize()    

	GUIAnimatedScript.Initialize(self)
    
	// Used for Global Offset
	self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetPosition( Vector(0, 0, 0) ) 
    self.background:SetIsVisible(true)
    self.background:SetLayer(kGUILayerPlayerHUDBackground)
    self.background:SetColor( Color(1, 1, 1, 0) )
	
    // team1CaptureBackground	
    self.team1CaptureBackground = self:CreateAnimatedGraphicItem()
    self.team1CaptureBackground:SetSize( Vector(GUIObjectiveScoreboardCTF.kTopCaptureIconWidth, GUIObjectiveScoreboardCTF.kTopCaptureIconHeight, 0) )
    self.team1CaptureBackground:SetPosition(Vector(GUIObjectiveScoreboardCTF.kCommandChairOffsetX - (GUIObjectiveScoreboardCTF.kTopCaptureIconWidth / 2), GUIObjectiveScoreboardCTF.kCommandChairOffsetY, 0))
    self.team1CaptureBackground:SetAnchor(GUIItem.Middle, GUIItem.Top) 
    self.team1CaptureBackground:SetLayer(kGUILayerPlayerHUDBackground)    
	self.team1CaptureBackground:SetIsVisible(true)
	
	self.team1CaptureTexture = self:CreateAnimatedGraphicItem()
    self.team1CaptureTexture:SetSize( Vector(GUIObjectiveScoreboardCTF.kTopCaptureIconWidth, GUIObjectiveScoreboardCTF.kTopCaptureIconHeight, 0) )
    //self.team1CaptureTexture:SetPosition(Vector(GUIObjectiveScoreboardCTF.kCommandChairOffsetX - (GUIObjectiveScoreboardCTF.kTopCaptureIconWidth / 2), GUIObjectiveScoreboardCTF.kCommandChairOffsetY, 0))
    //self.team1CaptureTexture:SetAnchor(GUIItem.Middle, GUIItem.Top) 
    self.team1CaptureTexture:SetLayer(kGUILayerPlayerHUD)    
    self.team1CaptureTexture:SetTexturePixelCoordinates(0, 32, 255, 64)
	self.team1CaptureTexture:SetIsVisible(true)
	self.team1CaptureBackground:AddChild(self.team1CaptureTexture)

	// commandChairLifeRemainingText
    self.commandChairLifeRemainingText = self:CreateAnimatedTextItem()
    self.commandChairLifeRemainingText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.commandChairLifeRemainingText:SetPosition(GUIObjectiveScoreboardCTF.kCommandChairTextOffset)
	self.commandChairLifeRemainingText:SetLayer(kGUILayerPlayerHUDForeground4)
	//self.commandChairLifeRemainingText:SetTextAlignmentX(GUIItem.Align_Center)
    self.commandChairLifeRemainingText:SetTextAlignmentY(GUIItem.Align_Center)
	self.commandChairLifeRemainingText:SetText("")	
	self.commandChairLifeRemainingText:SetFontSize(GUIObjectiveScoreboardCTF.kHealthFontSize)
    self.commandChairLifeRemainingText:SetFontName(GUIObjectiveScoreboardCTF.kHealthFontName)
	self.commandChairLifeRemainingText:SetFontIsBold(GUIObjectiveScoreboardCTF.kHealthFontBold)
	self.commandChairLifeRemainingText:SetIsVisible(true)
	
	// team2CaptureBackground
    self.team2CaptureBackground = self:CreateAnimatedGraphicItem()
    self.team2CaptureBackground:SetSize( Vector( GUIObjectiveScoreboardCTF.kTopCaptureIconWidth, GUIObjectiveScoreboardCTF.kTopCaptureIconHeight, 0) )
    self.team2CaptureBackground:SetPosition(Vector(GUIObjectiveScoreboardCTF.kHiveOffsetX - (GUIObjectiveScoreboardCTF.kTopCaptureIconWidth / 2), GUIObjectiveScoreboardCTF.kHiveOffsetY, 0))
    self.team2CaptureBackground:SetAnchor(GUIItem.Middle, GUIItem.Top) 
    self.team2CaptureBackground:SetLayer(kGUILayerPlayerHUDBackground)
	self.team2CaptureBackground:SetIsVisible(true)
	
	self.team2CaptureTexture = self:CreateAnimatedGraphicItem()
    self.team2CaptureTexture:SetSize( Vector( GUIObjectiveScoreboardCTF.kTopCaptureIconWidth, GUIObjectiveScoreboardCTF.kTopCaptureIconHeight, 0) )
    //self.team1CaptureTexture:SetPosition(Vector(GUIObjectiveScoreboardCTF.kCommandChairOffsetX - (GUIObjectiveScoreboardCTF.kTopCaptureIconWidth / 2), GUIObjectiveScoreboardCTF.kCommandChairOffsetY, 0))
    //self.team1CaptureTexture:SetAnchor(GUIItem.Middle, GUIItem.Top) 
    self.team2CaptureTexture:SetLayer(kGUILayerPlayerHUD)   
    self.team2CaptureTexture:SetTexturePixelCoordinates(1, 0, 255, 32)
	self.team2CaptureTexture:SetIsVisible(true)
	self.team2CaptureBackground:AddChild(self.team2CaptureTexture)
	
	// hiveLifeRemainingText
    self.hiveLifeRemainingText = self:CreateAnimatedTextItem()
    self.hiveLifeRemainingText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.hiveLifeRemainingText:SetPosition(GUIObjectiveScoreboardCTF.kHiveTextOffset)
	self.hiveLifeRemainingText:SetLayer(kGUILayerPlayerHUDForeground4)
	//self.hiveLifeRemainingText:SetTextAlignmentX(GUIItem.Align_Center)
    self.hiveLifeRemainingText:SetTextAlignmentY(GUIItem.Align_Center)
	self.hiveLifeRemainingText:SetText("")
	self.hiveLifeRemainingText:SetFontSize(GUIObjectiveScoreboardCTF.kHealthFontSize)
    self.hiveLifeRemainingText:SetFontName(GUIObjectiveScoreboardCTF.kHealthFontName)
	self.hiveLifeRemainingText:SetFontIsBold(GUIObjectiveScoreboardCTF.kHealthFontBold)
	self.hiveLifeRemainingText:SetIsVisible(true)
	 
	self.background:AddChild(self.team1CaptureBackground)
    self.team1CaptureBackground:AddChild(self.commandChairLifeRemainingText)
	self.background:AddChild(self.team2CaptureBackground)
	self.team2CaptureBackground:AddChild(self.hiveLifeRemainingText)
	
    // current capture point icon
    self.currentCapturePointIcon = self:CreateAnimatedGraphicItem()
    self.currentCapturePointIcon:SetSize( Vector(GUIObjectiveScoreboardCTF.kCurrentCaptureIconWidth, GUIObjectiveScoreboardCTF.kCurrentCaptureIconHeight, 0) )
    self.currentCapturePointIcon:SetAnchor(GUIItem.Middle, GUIItem.Center) 
    self.currentCapturePointIcon:SetPosition(GUIObjectiveScoreboardCTF.kCaptureIconOffset + Vector(0, GUIObjectiveScoreboardCTF.kCurrentCaptureYOffset, 0))
    self.currentCapturePointIcon:SetLayer(kGUILayerPlayerHUDForeground2)
    self.currentCapturePointIcon:SetTexture(GUIObjectiveScoreboardCTF.kCaptureIconNeutralTexture)
    self.currentCapturePointIcon:SetTexturePixelCoordinates(0, 0, GUIObjectiveScoreboardCTF.width, GUIObjectiveScoreboardCTF.height)
    self.currentCapturePointIcon:SetColor( CapturePoint.kNeutralTeamColor )
    self.currentCapturePointIcon.lastColor = CapturePoint.kNeutralTeamColor 
    self.currentCapturePointIcon:SetIsVisible(false)
    
    self.currentCapturePointIconGlow = self:CreateAnimatedGraphicItem()
    self.currentCapturePointIconGlow:SetSize( Vector(GUIObjectiveScoreboardCTF.kCurrentCaptureIconWidth, GUIObjectiveScoreboardCTF.kCurrentCaptureIconHeight, 0) )
    self.currentCapturePointIconGlow:SetAnchor(GUIItem.Left, GUIItem.Top) 
    //self.currentCapturePointIconGlow:SetPosition(GUIObjectiveScoreboardCTF.kCaptureIconOffset + Vector(0, GUIObjectiveScoreboardCTF.kCurrentCaptureYOffset, 0))    
    self.currentCapturePointIconGlow:SetLayer(kGUILayerPlayerHUDForeground3)
    self.currentCapturePointIconGlow:SetTexture(GUIObjectiveScoreboardCTF.kGlowIcon)
    self.currentCapturePointIconGlow:SetTexturePixelCoordinates(0, 0, GUIObjectiveScoreboardCTF.glowWidth, GUIObjectiveScoreboardCTF.glowHeight)
    self.currentCapturePointIconGlow:SetColor( GUIObjectiveScoreboardCTF.kGlowColor )    
    //self.currentCapturePointIconGlow:SetBlendTechnique(GUIItem.Add)
    //self.currentCapturePointIconGlow:SetStencilFunc(GUIItem.NotEqual)    
    self.currentCapturePointIconGlow:SetIsVisible(true)

    self.currentCapturePointIcon2 = self:CreateAnimatedGraphicItem()
    self.currentCapturePointIcon2:SetSize( Vector(GUIObjectiveScoreboardCTF.kCurrentCaptureIconWidth, GUIObjectiveScoreboardCTF.kCurrentCaptureIconHeight, 0) )
    self.currentCapturePointIcon2:SetAnchor(GUIItem.Left, GUIItem.Top) 
    //self.currentCapturePointIcon2:SetPosition(GUIObjectiveScoreboardCTF.kCaptureIconOffset + Vector(offset,0,0))
    self.currentCapturePointIcon2:SetLayer(kGUILayerPlayerHUDForeground3)
    self.currentCapturePointIcon2:SetTexture(GUIObjectiveScoreboardCTF.kCaptureIconNeutralTexture)
    self.currentCapturePointIcon2:SetTexturePixelCoordinates(0, 0, GUIObjectiveScoreboardCTF.width, GUIObjectiveScoreboardCTF.height)
    self.currentCapturePointIcon2:SetColor( CapturePoint.kMarineTeamColor )                
    self.currentCapturePointIcon2:SetIsVisible(true)     

    self.currentCatpureChar = self:CreateAnimatedTextItem()
    self.currentCatpureChar:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.currentCatpureChar:SetLayer(kGUILayerPlayerHUDForeground4)
    self.currentCatpureChar:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentCatpureChar:SetTextAlignmentY(GUIItem.Align_Center)    
    self.currentCatpureChar:SetColor(Color(1,1,1,1))
    self.currentCatpureChar:SetFontSize(GUIObjectiveScoreboardCTF.kHealthFontSize)
    self.currentCatpureChar:SetFontName(GUIObjectiveScoreboardCTF.kHealthFontName)
    self.currentCatpureChar:SetFontIsBold(GUIObjectiveScoreboardCTF.kHealthFontBold)
    self.currentCatpureChar:SetIsVisible(true)

    self.currentCapturePointIcon:AddChild(self.currentCapturePointIcon2)
    self.currentCapturePointIcon:AddChild(self.currentCatpureChar)
    self.background:AddChild(self.currentCapturePointIcon)
    self.currentCapturePointIcon:AddChild(self.currentCapturePointIconGlow)
    
    if self:GetTeamType() == "Marines" then
        self.team1CaptureBackground:SetTexture(GUIObjectiveScoreboardCTF.kMarinesBackgroundTexture)
        self.team1CaptureBackground:SetTexturePixelCoordinates(0, 32, 255, 64)
        
        self.team2CaptureBackground:SetTexture(GUIObjectiveScoreboardCTF.kMarinesBackgroundTexture)
        self.team2CaptureBackground:SetTexturePixelCoordinates(1, 0, 255, 32)
        
        self.team1CaptureTexture:SetTexture(GUIObjectiveScoreboardCTF.kMarinesIcon)
        self.team2CaptureTexture:SetTexture(GUIObjectiveScoreboardCTF.kMarinesIcon)
        
        self.commandChairLifeRemainingText:SetColor(GUIObjectiveScoreboardCTF.kMarineTextColor)
		self.hiveLifeRemainingText:SetColor(GUIObjectiveScoreboardCTF.kMarineTextColor)
        
    elseif self:GetTeamType() == "Aliens"then
        self.team1CaptureBackground:SetTexture(GUIObjectiveScoreboardCTF.kAlienBackgroundTexture)
	    self.team1CaptureBackground:SetShader("shaders/GUISmokeHUD.surface_shader")
        self.team1CaptureBackground:SetAdditionalTexture("noise", GUIObjectiveScoreboardCTF.kBackgroundNoiseTexture)
        self.team1CaptureBackground:SetFloatParameter("correctionX", 1)
        self.team1CaptureBackground:SetFloatParameter("correctionY", 0.3)
        
        self.team2CaptureBackground:SetTexture(GUIObjectiveScoreboardCTF.kAlienBackgroundTexture)
	    self.team2CaptureBackground:SetShader("shaders/GUISmokeHUD.surface_shader")
        self.team2CaptureBackground:SetAdditionalTexture("noise", GUIObjectiveScoreboardCTF.kBackgroundNoiseTexture)
        self.team2CaptureBackground:SetFloatParameter("correctionX", 1)
        self.team2CaptureBackground:SetFloatParameter("correctionY", 0.3)
        
        self.team1CaptureTexture:SetTexture(GUIObjectiveScoreboardCTF.kAliensIcon)        
        self.team2CaptureTexture:SetTexture(GUIObjectiveScoreboardCTF.kAliensIcon)
        
        self.commandChairLifeRemainingText:SetColor(GUIObjectiveScoreboardCTF.kAlienTextColor)
		self.hiveLifeRemainingText:SetColor(GUIObjectiveScoreboardCTF.kAlienTextColor)
		
    end
	
	
	self.capturePoints = {}
	
	local sortedCapturePoints =  EntityListToTable(Shared.GetEntitiesWithClassname("CapturePoint")) 
  
    local function comp(entity1,entity2)
        if entity1.captureId < entity2.captureId then
            return true
        end
    end    
    table.sort(sortedCapturePoints,comp)
    
    /*
    
	local team1Start = nil
	for index, techPoint in ientitylist(Shared.GetEntitiesWithClassname("TechPoint")) do
	    if techPoint.occupiedTeam and  techPoint.occupiedTeam  == 1 then
	        team1Start = techPoint:GetOrigin()
	    end
	end
	
	if team1Start then
        Shared.SortEntitiesByDistance(team1Start, sortedList)
    end
    */
	    
	if sortedCapturePoints then
	
        local numberPoints = table.count(sortedCapturePoints)
        
        if numberPoints > 0 then
        
            local offset = 0
            if numberPoints % 2 == 0 then
              offset = offset - (GUIObjectiveScoreboardCTF.kCaptureOffsetRight + GUIObjectiveScoreboardCTF.kCaptureIconWidth * (numberPoints / 2))
            else                
                offset = offset - (GUIObjectiveScoreboardCTF.kCaptureIconWidth + GUIObjectiveScoreboardCTF.kCaptureOffsetRight) * math.floor(numberPoints / 2)
            end                                

            for index, capturePoint in ipairs(sortedCapturePoints) do
            
                local capturePointIcon = self:CreateAnimatedGraphicItem()
                capturePointIcon:SetSize( Vector(GUIObjectiveScoreboardCTF.kCaptureIconWidth, GUIObjectiveScoreboardCTF.kCaptureIconHeight, 0) )
                capturePointIcon:SetAnchor(GUIItem.Middle, GUIItem.Top) 
                capturePointIcon:SetPosition(GUIObjectiveScoreboardCTF.kCaptureIconOffset + Vector(offset,0,0))
                capturePointIcon:SetLayer(kGUILayerPlayerHUDForeground2)
                capturePointIcon:SetTexture(GUIObjectiveScoreboardCTF.kCaptureIconNeutralTexture)
                capturePointIcon:SetTexturePixelCoordinates(0, 0, GUIObjectiveScoreboardCTF.width, GUIObjectiveScoreboardCTF.height)
                capturePointIcon:SetColor( CapturePoint.kNeutralTeamColor )
                capturePointIcon.lastColor = CapturePoint.kNeutralTeamColor 
                capturePointIcon:SetIsVisible(true)
                
                capturePointIconGlow = self:CreateAnimatedGraphicItem()
                capturePointIconGlow:SetSize( Vector(GUIObjectiveScoreboardCTF.kCaptureIconWidth, GUIObjectiveScoreboardCTF.kCaptureIconHeight, 0) )
                capturePointIconGlow:SetAnchor(GUIItem.Left, GUIItem.Top)                 
                capturePointIconGlow:SetLayer(kGUILayerPlayerHUDForeground3)
                capturePointIconGlow:SetTexture(GUIObjectiveScoreboardCTF.kGlowIcon)
                capturePointIconGlow:SetTexturePixelCoordinates(0, 0, GUIObjectiveScoreboardCTF.glowWidth, GUIObjectiveScoreboardCTF.glowHeight)
                capturePointIconGlow:SetColor( GUIObjectiveScoreboardCTF.kGlowColor )       
                capturePointIconGlow:SetIsVisible(true)

                local capturePointIcon2 = self:CreateAnimatedGraphicItem()
                capturePointIcon2:SetSize( Vector(GUIObjectiveScoreboardCTF.kCaptureIconWidth, GUIObjectiveScoreboardCTF.kCaptureIconHeight, 0) )
                capturePointIcon2:SetAnchor(GUIItem.Left, GUIItem.Top) 
                //capturePointIcon2:SetPosition(GUIObjectiveScoreboardCTF.kCaptureIconOffset + Vector(offset,0,0))
                capturePointIcon2:SetLayer(kGUILayerPlayerHUDForeground3)
                capturePointIcon2:SetTexture(GUIObjectiveScoreboardCTF.kCaptureIconNeutralTexture)
                capturePointIcon2:SetTexturePixelCoordinates(0, 0, GUIObjectiveScoreboardCTF.width, GUIObjectiveScoreboardCTF.height)
                capturePointIcon2:SetColor( CapturePoint.kMarineTeamColor )                
                capturePointIcon2:SetIsVisible(true)     

                /*
                local attentionIcon = self:CreateAnimatedGraphicItem()
                attentionIcon:SetSize( Vector(GUIObjectiveScoreboardCTF.kAttentionIconWidth, GUIObjectiveScoreboardCTF.kAttentionIconHeight, 0) )
                attentionIcon:SetAnchor(GUIItem.Left, GUIItem.Top) 
                //attentionIcon:SetPosition(GUIObjectiveScoreboardCTF.kAttentionIconOffset)
                attentionIcon:SetLayer(kGUILayerPlayerHUDForeground4)
                attentionIcon:SetTexture(GUIObjectiveScoreboardCTF.kAttentionTexture)
                attentionIcon:SetTexturePixelCoordinates(172, 40, 212, 80)
                //attentionIcon:SetColor( CapturePoint.kMarineTeamColor )                
                attentionIcon:SetIsVisible(false)      
                */                   
                
                
                local catpureChar = self:CreateAnimatedTextItem()
                catpureChar:SetAnchor(GUIItem.Middle, GUIItem.Center)
                catpureChar:SetLayer(kGUILayerPlayerHUDForeground4)
                catpureChar:SetTextAlignmentX(GUIItem.Align_Center)
                catpureChar:SetTextAlignmentY(GUIItem.Align_Center)
                catpureChar:SetText(string.char(capturePoint.captureId + 64))
                catpureChar:SetText(string.char(capturePoint.captureId + 64))
                catpureChar:SetColor(Color(1,1,1,1))
                catpureChar:SetFontSize(GUIObjectiveScoreboardCTF.kHealthFontSize)
                catpureChar:SetFontName(GUIObjectiveScoreboardCTF.kHealthFontName)
                catpureChar:SetFontIsBold(GUIObjectiveScoreboardCTF.kHealthFontBold)
                catpureChar:SetIsVisible(true)
                
                capturePointIcon.ID = capturePoint:GetId()
                capturePointIcon.Glow = capturePointIconGlow
                capturePointIcon.Icon2 = capturePointIcon2
                capturePointIcon.Char = catpureChar
                //capturePointIcon.attentionIcon = attentionIcon
                
                capturePointIcon:AddChild(capturePointIconGlow)
                capturePointIcon:AddChild(capturePointIcon2)
                //capturePointIcon:AddChild(attentionIcon)
                capturePointIcon:AddChild(catpureChar)
                
                table.insert(self.capturePoints, capturePointIcon)
                self.background:AddChild(capturePointIcon)
                
                offset = offset + GUIObjectiveScoreboardCTF.kCaptureIconWidth + GUIObjectiveScoreboardCTF.kCaptureOffsetRight
            end	
            
        end
        
    end
	
    self:Update(0)

end

function GUIObjectiveScoreboardCTF:GetTeamType()

	local player = Client.GetLocalPlayer()
	
	if not player:isa("ReadyRoomPlayer") then	
		local teamnumber = player:GetTeamNumber()
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
	else
		return "Ready Room"
	end
	
end



function GUIObjectiveScoreboardCTF:Update(deltaTime)

    local player = Client.GetLocalPlayer()
	
	// Alter the display based on team, status.
	if player and player:GetIsAlive() and not player:isa("DevouredPlayer") then
		self.background:SetIsVisible(true)
		
	   local marineFlagScore, alienFlagScore = GetGamerulesInfo():GetTeamScores()	
		--Print("%s", marineFlagScore)
	   local maxScore = " / " .. kCaptureWinTotal
		
		self.commandChairLifeRemainingText:SetText(ToString(marineFlagScore .. maxScore))
		self.hiveLifeRemainingText:SetText(ToString(alienFlagScore .. maxScore))
				
		// update capture points
		if self.capturePoints then
		
		    local origin = player:GetOrigin()
		    local nearCaptureEntityIcon = nil
		    local nearCaptureEntityReduceAmount = 1
		    
            for i, capturePointIcon in ipairs(self.capturePoints) do
                local captureEntity = Shared.GetEntity(capturePointIcon.ID)
                if captureEntity and captureEntity.captureScalar then
                    local captureOrigin = captureEntity:GetOrigin()
                    //captureEntity.occupiedTeam
                    
                    if captureEntity.occupiedTeam == 1 then
                        capturePointIcon.Icon2:SetColor( CapturePoint.kMarineTeamColor )
                        capturePointIcon.Icon2.lastColor = CapturePoint.kMarineTeamColor
                    elseif captureEntity.occupiedTeam == 2 then
                        capturePointIcon.Icon2:SetColor( CapturePoint.kAlienTeamColor ) 
                        capturePointIcon.Icon2.lastColor = CapturePoint.kAlienTeamColor                      
                    end
                    
                    local reduceAmount = captureEntity.captureScalar / 100                    
                    capturePointIcon.Icon2:SetTexturePixelCoordinates(0, 0, GUIObjectiveScoreboardCTF.width * reduceAmount, GUIObjectiveScoreboardCTF.height)
                    capturePointIcon.Icon2:SetSize(Vector(GUIObjectiveScoreboardCTF.kCaptureIconWidth * reduceAmount, GUIObjectiveScoreboardCTF.kCaptureIconHeight, 0))
                    //local textureCoords = capturePointIcon:GetTexturePixelCoordinates()                    
                    
                    if reduceAmount >= 1 then
                        capturePointIcon.Glow:SetIsVisible(true)                         
                    else 
                        capturePointIcon.Glow:SetIsVisible(false)
                    end
                    
                    local resetPulse = false
                    if captureEntity.captureScalar >= 100 then
                        resetPulse = true  
                    
                    elseif captureEntity.captureScalar < 1 then
                        capturePointIcon.Icon2:SetColor(CapturePoint.kNeutralTeamColor)     
                        capturePointIcon.Icon2.lastColor = CapturePoint.kNeutralTeamColor                    
                        resetPulse = true
                        
                    elseif captureEntity.gettingCaptured then                    
                        if not captureEntity.timeLastImpulse then
                            captureEntity.timeLastImpulse = Shared.GetTime()
                        end
                        
                        self:SetAlpha(capturePointIcon, captureEntity.timeLastImpulse)
                        self:SetAlpha(capturePointIcon.Icon2, captureEntity.timeLastImpulse)
                        //self:SetAlpha(capturePointIcon.attentionIcon, captureEntity.timeLastImpulse)
                        
                        if captureEntity.oldCaptureScalar > captureEntity.captureScalar then
                           //capturePointIcon.attentionIcon:SetIsVisible(true)
                        else
                            //capturePointIcon.attentionIcon:SetIsVisible(false)
                        end
                        
                    else
                        local currentColor = capturePointIcon.Icon2.lastColor                   
                        currentColor.a = capturePointIcon.Icon2.lastColor.a
                        capturePointIcon.Icon2:SetColor(currentColor) 

                        capturePointIcon:SetColor(CapturePoint.kNeutralTeamColor )                     
                    end
                    
                    if resetPulse then
                        captureEntity.timeLastImpulse  = nil
                        //capturePointIcon.attentionIcon:SetIsVisible(false)
                    end
                    
                    local distance = captureOrigin:GetDistance(origin)
                    
                    if (captureOrigin:GetDistance(origin) <= CapturePoint.kCaptureRadius ) then    
                        nearCaptureEntityIcon = capturePointIcon
                        nearCaptureEntityReduceAmount = captureEntity.captureScalar / 100  
                    end                    
                    
                end
            end
            
            if nearCaptureEntityIcon then
                self.currentCapturePointIcon:SetIsVisible(true)
                self:UpdatePersonalCaptureIcon(nearCaptureEntityIcon, nearCaptureEntityReduceAmount)                
            else
                self.currentCapturePointIcon:SetIsVisible(false)
            end
            
        end
        
	else
		self.background:SetIsVisible(false)
	end	


end

function GUIObjectiveScoreboardCTF:UpdatePersonalCaptureIcon(capturePointIcon, reduceAmount)
    self.currentCapturePointIcon:SetColor(capturePointIcon:GetColor())
    self.currentCapturePointIcon2:SetColor(capturePointIcon.Icon2:GetColor())
    self.currentCapturePointIcon2:SetTexturePixelCoordinates(capturePointIcon.Icon2:GetTexturePixelCoordinates())
    self.currentCapturePointIcon2:SetSize(Vector(GUIObjectiveScoreboardCTF.kCurrentCaptureIconWidth * reduceAmount, GUIObjectiveScoreboardCTF.kCurrentCaptureIconHeight, 0))
    self.currentCatpureChar:SetText(capturePointIcon.Char:GetText())    
                    
    if reduceAmount >= 1 then
        self.currentCapturePointIconGlow:SetIsVisible(true)
    else
        self.currentCapturePointIconGlow:SetIsVisible(false)
    end
    
end


function GUIObjectiveScoreboardCTF:SetAlpha(captureIcon, timeLastImpulse)
    local currentColor = captureIcon:GetColor()                        
    local destAlpha = 0.25 * math.cos(CapturePoint.kImpulseInterval * (Shared.GetTime() - timeLastImpulse)) + 0.5

    currentColor.a = destAlpha
    captureIcon:SetColor(currentColor)   
end