Script.Load("lua/GenericGamerules.lua")

class "CombatCTFGamerules.lua" (GenericGamerules)

CombatCTFGamerules.kMapName = "combatctf_gamerules"

local networkVars =
{
}

if Server then

    function CombatCTFGamerules:OnCreate()
        GenericGamerules.OnCreate(self)
        
        self.startsWithFlag = true
        self.commandStructuresTakeDamage = false
        