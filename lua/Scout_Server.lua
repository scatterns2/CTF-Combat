// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Scout_Server.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

function Scout:InitWeapons()

    Player.InitWeapons(self)
    
    self:GiveItem(LightMachineGun.kMapName)
    self:GiveItem(Pistol.kMapName)
    self:GiveItem(Knife.kMapName)
    self:GiveItem(Builder.kMapName)
    
    self:SetQuickSwitchTarget(Pistol.kMapName)
    self:SetActiveWeapon(LightMachineGun.kMapName)

end

