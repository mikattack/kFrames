-----------------------------------------------------------------------------
-- Unit Frames - Default values for common aspects of the layout.
-----------------------------------------------------------------------------

local _, addon = ...
local defaults = addon.defaults


-- Universal unit frame values
defaults.padding = 1
defaults.power_height = 5

defaults.frames = {
  -- Major unit frame sizing (player, target)
  major = {
    health_height = 30,
    width  = 300,
  }

  -- Minor unit frame sizing (all other frames)
  minor = {
    health_height = 20,
    width  = 275,
  }
}

-- Power bar re-colors
oUF.colors.power.MANA           = {0, 0.8, 1}
oUF.colors.power.INSANITY       = {1, 0.2, 1}
oUF.colors.power.ARCANE_CHARGES = {1, 0.2, 1}
