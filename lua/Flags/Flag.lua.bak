Script.Load("lua/Mixins/ModelMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/ScriptActor.lua")
Script.Load("lua/Flags/FlagMixin.lua")

class 'Flag' (ScriptActor)

Flag.kMapName = "flag"

Flag.kModelName = PrecacheAsset("models/props/flag/flag.model")
Flag.kAnimationGraph = PrecacheAsset("models/alien/hydra/hydra.animation_graph")

local networkVars =
{
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(FlagMixin, networkVars)

local kReturnDelay = 60

function Flag:OnCreate()

    ScriptActor.OnCreate(self)

    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, FlagMixin, { kRecipientType = "Player" })
    
    
    self:SetUpdates(true)
    self:SetRelevancyDistance(Math.infinity)

end

function Flag:OnInitialized()
    
    self:SetModel(self.kModelName, /*self.kAnimationGraph*/ nil)
    self.kAtBase = true
    self.kCarried = false
    self.kReturning = false
    self.kDropTime = Shared.GetTime() 

end

function Flag:GetIsValidRecipient(recipient)
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

function Flag:OnTouchEnemy(player)
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

function Flag:OnTouchFriendly(player)
    self:OnPlayerReturn(player)
end

function Flag:GetIsPermanent()
    return true
end

function Flag:OnUpdate(deltaTime)
    ScriptActor.OnUpdate(self, deltaTime)
    now = Shared.GetTime()
    if self.kReturning then 
        if now >= (self.kDropTime + kReturnDelay) then
            self:ReturnFlag()
        end
    end
end

if Server then
    function Flag:SetConstructionComplete() 
    end
end   

Shared.LinkClassToMap("Flag", Flag.kMapName, networkVars)