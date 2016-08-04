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
  ns.elements.SoulShards(frame, ns.position.classbars)
end


function layout.postCreate(frames)
  -- Position pet frame above health
  frames["pet"]:SetPoint("BOTTOMLEFT", "oUF_kUnitPlayer", "TOPLEFT", 0, 5)

  -- Attach castbar above pet frame
  ns.elements.repositionCastbar(
    frames["player"].Castbar,
    frames["pet"],
    "BOTTOMLEFT _ TOPLEFT -2 5")
end
