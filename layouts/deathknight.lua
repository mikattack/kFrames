--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...
ns.layouts["DEATHKNIGHT"] = {}
layout = ns.layouts["DEATHKNIGHT"]


function layout.onCreate(frame)
  -- Combo Point interface
  ns.elements.RuneBar(frame, ns.config.position.classbar)
end
