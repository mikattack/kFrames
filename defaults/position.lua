--[[-------------------------------------------------------------------------
Position -  Positional settings for interfaces clusters. Compatible with
            the `util.parsePosition()` function.
---------------------------------------------------------------------------]]

local _, ns = ...
local config = ns.config

config.position = {
  primaryCluster    = "BOTTOM UIParent BOTTOM 0 0",
  secondaryCluster  = "TOPLEFT UIParent TOPLEFT 10 50",
  classbar          = "BOTTOM UIParent BOTTOM 0 5"
}
