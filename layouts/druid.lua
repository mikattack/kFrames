--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...


function ns.layouts.druid(frames)

  -- ComboPoint interface
  ns.elements.ComboPoints(frames["player"], ns.position.classbars)
end
