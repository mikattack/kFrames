--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...
ns.layouts["DRUID"] = {}
layout = ns.layouts["DRUID"]


function layout.onCreate(frame)
  -- ComboPoint interface
  ns.elements.ComboPoints(frame, ns.position.classbars)
end
