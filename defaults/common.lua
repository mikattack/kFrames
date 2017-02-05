--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
---------------------------------------------------------------------------]]

local _, ns = ...
local defaults = ns.defaults

-- Default bar sizing
defaults.size = {
  height = 30,  -- Actually, just the height of the health bar
  width  = 300,
}

-- Secondary bar sizing
defaults.altsize = {
  height = 20,
  width  = 275,
}

defaults.padding = 1
defaults.powerheight = 5

-- Re-colors
oUF.colors.power.MANA     = {0, 0.8, 1}
oUF.colors.power.INSANITY = {1, 0.2, 1}
--[[
oUF.colors.runes = {
  {0.87, 0.12, 0.23},
  {0.40, 0.95, 0.20},
  {0.14, 0.50, 1},
  {.70, .21, 0.94},
}
--]]
