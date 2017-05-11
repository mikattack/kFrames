--[[-------------------------------------------------------------------------
Position -  Positional settings for interfaces clusters. Compatible with
            the `util.parsePosition()` function.
---------------------------------------------------------------------------]]

local _, ns = ...
local config = ns.config

config.position = {
  player  = "BOTTOM UIParent BOTTOM 0 10",
  target  = "RIGHT UIParent BOTTOM -155 175",
  tot     = "LEFT UIParent BOTTOM 155 175"
  pet     = "TOPLEFT UIParent TOPLEFT 15 -75",
  boss    = "TOPLEFT UIParent TOPLEFT 15 -115",
  tank    = "",
}
