//
// lua\Weapons\Alien\Metabolize.lua

Script.Load("lua/Weapons/Alien/Ability.lua")
Script.Load("lua/Weapons/Alien/Blink.lua")

class 'Metabolize' (Blink)

Metabolize.kMapName = "metabolize"

local networkVars =
{
    lastPrimaryAttackTime = "time"
}

local kMetabolizeDelay = 3.0  //7.5
local kMetabolizeEnergyRegain = 0 //35
local kMetabolizeHealthRegain = 120 //15
local kMetabolizeShieldAmount = 60
kMetabolizeEnergyCost = 30

kMetabolizeUpgradeEnergyCost = 20

local kAnimationGraph = PrecacheAsset("models/alien/fade/fade_view.animation_graph")

function Metabolize:OnCreate()

    Blink.OnCreate(self)
    
    self.primaryAttacking = false
    self.lastPrimaryAttackTime = 0
end

function Metabolize:GetAnimationGraphName()
    return kAnimationGraph
end

function Metabolize:GetEnergyCost(player)
    return kMetabolizeEnergyCost
end

function Metabolize:GetHUDSlot()
    return 2
end

function Metabolize:GetDeathIconIndex()
    return kDeathMessageIcon.Metabolize
end

function Metabolize:GetBlinkAllowed()
    return true
end

function Metabolize:GetAttackDelay()
    return kMetabolizeDelay
end

function Metabolize:GetLastAttackTime()
    return self.lastPrimaryAttackTime
end

function Metabolize:GetSecondaryTechId()
    return kTechId.Blink
end

function Metabolize:GetHasAttackDelay()
	local parent = self:GetParent()
    return self.lastPrimaryAttackTime + kMetabolizeDelay > Shared.GetTime() or parent and parent:GetIsStabbing()
end

function Metabolize:OnPrimaryAttack(player)

    if player:GetEnergy() >= self:GetEnergyCost() and not self:GetHasAttackDelay() then
        self.primaryAttacking = true
        player.timeMetabolize = Shared.GetTime()
    else
        self:OnPrimaryAttackEnd()
    end
    
end

function Metabolize:OnPrimaryAttackEnd()
    
    Blink.OnPrimaryAttackEnd(self)
    self.primaryAttacking = false
    
end

function Metabolize:OnHolster(player)

    Blink.OnHolster(self, player)
    self.primaryAttacking = false
    
end

function Metabolize:OnTag(tagName)

    PROFILE("Metabolize:OnTag")
	
    if tagName == "vortex_start" and not self:GetHasAttackDelay() then		
        local player = self:GetParent()
        if player then
            player:DeductAbilityEnergy(kMetabolizeEnergyCost)
            player:TriggerEffects("metabolize")
            --if player:GetCanMetabolizeHealth() then
                --local totalHealed = player:AddHealth(kMetabolizeHealthRegain, false, false)
				local shieldedAmount = 0
				if player.SetShield then
					shieldedAmount = player:SetShield(kMetabolizeShieldAmount)
				end
				if Client and shieldedAmount > 0 then
					--Print("Shield On!")
					local GUIRegenerationFeedback = ClientUI.GetScript("GUIRegenerationFeedback")
					GUIRegenerationFeedback:TriggerRegenEffect()
					local cinematic = Client.CreateCinematic(RenderScene.Zone_ViewModel)
					cinematic:SetCinematic(kRegenerationViewCinematic)
				end
            --end 
            --player:AddEnergy(kMetabolizeEnergyRegain)			
            self.lastPrimaryAttackTime = Shared.GetTime()
            self.primaryAttacking = false
        end
    elseif tagName == "vortex_hit" then
        local player = self:GetParent()
        if player then
            self.primaryAttacking = false
        end
    end
    
end

function Metabolize:OnUpdateAnimationInput(modelMixin)

    PROFILE("Metabolize:OnUpdateAnimationInput")

    Blink.OnUpdateAnimationInput(self, modelMixin)
    
    modelMixin:SetAnimationInput("ability", "vortex")
    
    local player = self:GetParent()
    local activityString = (self.primaryAttacking and "primary") or "none"
    if player and player:GetHasMetabolizeAnimationDelay() then
        activityString = "primary"
    end
    
    modelMixin:SetAnimationInput("activity", activityString)
    
end

Shared.LinkClassToMap("Metabolize", Metabolize.kMapName, networkVars)