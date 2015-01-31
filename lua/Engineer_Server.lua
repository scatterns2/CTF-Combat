// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Engineer_Server.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

function Engineer:InitWeapons()

    Player.InitWeapons(self)
    
    self:GiveItem(Revolver.kMapName)
    self:GiveItem(Knife.kMapName)
    self:GiveItem(Builder.kMapName)
    
    self:SetActiveWeapon(Revolver.kMapName)

end

