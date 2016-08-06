--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...
ns.layouts["WARLOCK"] = {}
layout = ns.layouts["WARLOCK"]


function layout.onCreate(frame)
  -- Soul Shard interface
  ns.elements.SoulShards(frame, ns.config.position.classbar)
end
