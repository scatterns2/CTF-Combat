// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\SentryBattery.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
//    Powers up to three sentries. Required for building them.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Mixins/ModelMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/ScriptActor.lua")
Script.Load("lua/Flags/FlagMixin.lua")
Script.Load("lua/LiveMixin.lua")


class 'SentryBattery' (ScriptActor)
SentryBattery.kMapName = "sentrybattery"
SentryBattery.kRange = 4.0

SentryBattery.kModelName = PrecacheAsset("models/props/flag/flag.model")
local kAnimationGraph = PrecacheAsset("models/props/flag/flag.animation_graph")



local networkVars =
{
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(FlagMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)

local kReturnDelay = 60


function SentryBattery:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, TeamMixin)
	InitMixin(self, FlagMixin, { kRecipientType = "Player" })
    InitMixin(self, LiveMixin)

	
    if Client then
        InitMixin(self, CommanderGlowMixin)
    end
    
    self:SetLagCompensated(false)
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.BigStructuresGroup)
    
end

function SentryBattery:OnInitialized()

    ScriptActor.OnInitialized(self)
        
    self:SetModel(SentryBattery.kModelName, kAnimationGraph)

	self.kAtBase = true
    self.kCarried = false
    self.kReturning = false
    self.kDropTime = Shared.GetTime() 
	
end

function SentryBattery:GetIsValidRecipient(recipient)
    local sameTeam = (recipient:GetTeamNumber() == self:GetTeamNumber())
    local enemyTeam = (recipient:GetTeamNumber() ~= self:GetTeamNumber())
    if HasMixin(recipient, "Live") and recipient:GetIsAlive() then
        if sameTeam and self.kReturning and not self.kAtBase then
            return true 
        elseif sameTeam and self.kAtBase and recipient.hasFlag then
            if Server then
                recipient:OnCaptureFlag()
            end
            return false
        elseif enemyTeam and (self.kAtBase or self.kReturning) then
            return true
        end
    else
        return false
    end
end

function SentryBattery:OnTouchEnemy(player)
    player:AttachFlag(self)
    self.kCarried = true
    if self.kAtBase then
        self.kAtBase = false
    end
    if self.kReturning then
        self.kReturning = false
    end
    self:OnTaken(player)    
end

function SentryBattery:OnTouchFriendly(player)
    self:OnPlayerReturn(player)
end

function SentryBattery:GetIsPermanent()
    return true
end

function SentryBattery:OnUpdate(deltaTime)
    ScriptActor.OnUpdate(self, deltaTime)
    now = Shared.GetTime()
    if self.kReturning then 
        if now >= (self.kDropTime + kReturnDelay) then
            self:ReturnFlag()
        end
    end
end

function SentryBattery:OnUpdateAnimationInput(modelMixin)
    
	//Print("%s", self.kAtBase)
	//Print("%s", self.kCarried)
	modelMixin:SetAnimationInput("deploy", self.kAtBase)
    modelMixin:SetAnimationInput("pack", self.kCarried)
	modelMixin:SetAnimationInput("deploy", self.kReturning)

end

if Server then
    function SentryBattery:SetConstructionComplete() 
    end
end   

Shared.LinkClassToMap("SentryBattery", SentryBattery.kMapName, networkVars)