--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
---------------------------------------------------------------------------]]

local _, ns = ...
local config = ns.config

config.maxNameLength = 25

config.size = {}

config.size.classBarWidth = 234
config.size.castBarHeight = 24

config.size.primaryCluster = {
  width   = 300,  -- Width of primary cluster bars
  height  = 30,   -- Actually just the height of the health bar
}
config.size.secondaryCluster = {
  width   = 275,
  height  = 22,
}

