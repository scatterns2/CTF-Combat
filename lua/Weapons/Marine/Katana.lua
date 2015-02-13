//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________


Script.Load("lua/Weapons/Weapon.lua")

class 'Katana' (Weapon)

Katana.kMapName = "katana"

Katana.kModelName = PrecacheAsset("models/marine/knife/knife.model")
Katana.kViewModelName = PrecacheAsset("models/marine/knife/knife_view.model")
// local kViewModels = GenerateMarineViewModelPaths("knife")
local kAnimationGraph = PrecacheAsset("models/marine/axe/axe_view.animation_graph")

local networkVars =
{
    sprintAllowed = "boolean",
}

function Katana:OnCreate()

    Weapon.OnCreate(self)
    
    self.sprintAllowed = true
    
end

function Katana:OnInitialized()

    Weapon.OnInitialized(self)
    
    self:SetModel(Katana.kModelName)
    
end

function Katana:GetViewModelName(sex, variant)
    return Katana.kViewModelName
end

function Katana:GetAnimationGraphName()
    return kAnimationGraph
end

function Katana:GetHUDSlot()
    return kTertiaryWeaponSlot
end

function Katana:GetRange()
    return kKatanaRange
end

function Katana:GetShowDamageIndicator()
    return true
end

function Katana:GetSprintAllowed()
    return self.sprintAllowed
end

function Katana:GetDeathIconIndex()
    return kDeathMessageIcon.Knife
end

function Katana:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    
    // Attach weapon to parent's hand
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    
end

function Katana:OnHolster(player)

    Weapon.OnHolster(self, player)
    
    self.sprintAllowed = true
    self.primaryAttacking = false
    
end

function Katana:OnPrimaryAttack(player)

    if not self.attacking then
        
        self.sprintAllowed = false
        self.primaryAttacking = true
        
    end

end

function Katana:OnPrimaryAttackEnd(player)
    self.primaryAttacking = false
end

function Katana:OnTag(tagName)
	
	if tagName == "swipe_sound" then
        local player = self:GetParent()
        if player then
            player:TriggerEffects("knife_attack")
        end
    elseif tagName == "hit" then
    
        local player = self:GetParent()
        if player then
            AttackMeleeCapsule(self, player, kKatanaDamage, self:GetRange())
        end
        
    elseif tagName == "attack_end" then
        self.sprintAllowed = true
    end
	
end

function Katana:OnUpdateAnimationInput(modelMixin)

    PROFILE("Katana:OnUpdateAnimationInput")

    local activity = "none"
    if self.primaryAttacking then
        activity = "primary"
    end
    modelMixin:SetAnimationInput("activity", activity)
    
end

function Katana:OverrideWeaponName()
    return "axe"
end

Shared.LinkClassToMap("Katana", Katana.kMapName, networkVars)