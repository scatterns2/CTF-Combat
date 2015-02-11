//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//    original code from lua\Weapons\Alien\Metabolize.lua
//    Created by:  twiliteblue
//
//________________________________

Script.Load("lua/Weapons/Alien/Ability.lua")
Script.Load("lua/Weapons/Alien/Blink.lua")

class 'VoidShield' (Blink)

VoidShield.kMapName = "voidshield"

local networkVars =
{
    lastPrimaryAttackTime = "time"
}

local kVoidShieldDelay = 4.0  //7.5
local kVoidShieldHealthRegain = 120 //15
local kVoidShieldShieldAmount = 100
kVoidShieldEnergyCost = 30

kVoidShieldUpgradeEnergyCost = 20

local kAnimationGraph = PrecacheAsset("models/alien/fade/fade_view.animation_graph")

function VoidShield:OnCreate()

    Blink.OnCreate(self)
    
    self.primaryAttacking = false
    self.lastPrimaryAttackTime = 0
end

function VoidShield:GetAnimationGraphName()
    return kAnimationGraph
end

function VoidShield:GetEnergyCost(player)
    return kVoidShieldEnergyCost
end

function VoidShield:GetHUDSlot()
    return kVoidShieldHUDSlot
end

function VoidShield:GetDeathIconIndex()
    return kDeathMessageIcon.Metabolize
end

function VoidShield:GetBlinkAllowed()
    return true
end

function VoidShield:GetAttackDelay()
    return kVoidShieldDelay
end

function VoidShield:GetLastAttackTime()
    return self.lastPrimaryAttackTime
end

function VoidShield:GetSecondaryTechId()
    return kTechId.Blink
end

function VoidShield:GetHasAttackDelay()
	local parent = self:GetParent()
    return self.lastPrimaryAttackTime + kVoidShieldDelay > Shared.GetTime() or parent and parent:GetIsStabbing()
end

function VoidShield:OnPrimaryAttack(player)

    if player:GetEnergy() >= self:GetEnergyCost() and not self:GetHasAttackDelay() then
        self.primaryAttacking = true
        player.timeVoidShield = Shared.GetTime()
    else
        self:OnPrimaryAttackEnd()
    end
    
end

function VoidShield:OnPrimaryAttackEnd()
    
    Blink.OnPrimaryAttackEnd(self)
    self.primaryAttacking = false
    
end

function VoidShield:OnHolster(player)

    Blink.OnHolster(self, player)
    self.primaryAttacking = false
    
end

function VoidShield:OnTag(tagName)

    PROFILE("VoidShield:OnTag")
	
    if tagName == "vortex_start" and not self:GetHasAttackDelay() then		
        local player = self:GetParent()
        if player then
            player:DeductAbilityEnergy(kVoidShieldEnergyCost)
			player:TriggerEffects("metabolize")
            //player:SetOpacity(0.5, "hallucination") //"vortexDissolve")     // player:TriggerEffects("metabolize")
			
			/*local viewModelEnt = player:GetViewModelEntity()       
			if viewModelEnt then
				viewModelEnt:SetOpacity(0.5, "hallucination")
			end	*/
			
			local shieldedAmount = 0
			if player.SetShield then
				shieldedAmount = player:SetShield(kVoidShieldShieldAmount)
			end
			if Client and shieldedAmount > 0 then
				--Print("Shield On!")
				local GUIRegenerationFeedback = ClientUI.GetScript("GUIRegenerationFeedback")
				GUIRegenerationFeedback:TriggerRegenEffect()
				local cinematic = Client.CreateCinematic(RenderScene.Zone_ViewModel)
				cinematic:SetCinematic(kRegenerationViewCinematic)
			end
		
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

function VoidShield:OnUpdateAnimationInput(modelMixin)

    PROFILE("VoidShield:OnUpdateAnimationInput")

    Blink.OnUpdateAnimationInput(self, modelMixin)
    
    modelMixin:SetAnimationInput("ability", "vortex")
    
    local player = self:GetParent()
    local activityString = (self.primaryAttacking and "primary") or "none"
    if player and player:GetHasVoidShieldAnimationDelay() then
        activityString = "primary"
    end
    
    modelMixin:SetAnimationInput("activity", activityString)
    
end

Shared.LinkClassToMap("VoidShield", VoidShield.kMapName, networkVars)