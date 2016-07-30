--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...
ns.layouts["ROGUE"] = {}
layout = ns.layouts["ROGUE"]


function layout.onCreate(frame)
  -- Combo Point interface
  ns.elements.ComboPoints(frame, ns.position.classbars)
  print("COMBO POINTS INITIALIZED")
end
