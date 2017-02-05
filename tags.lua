--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
---------------------------------------------------------------------------]]


local _, ns = ...
local tags = oUF.Tags
local config = ns.config
local GetTime = GetTime
local si = ns.util.si

local format = string.format
local len = string.len
local sub = string.sub
local si = ns.util.si

local DEFAULT_MAX_NAME_LENGTH = 30

-- REMINDER: String color is |cAARRGGBBtext|r


-----------------------------------------------------------------------------


-- Auto-shortened Unit Name
tags.Events["kFrames:name"] = "UNIT_NAME_UPDATE"
tags.Methods["kFrames:name"] = function(u, r)
  local n = UnitName(r or u)
  if len(n) >= DEFAULT_MAX_NAME_LENGTH then
    n = format('%s...', sub(n, 1, DEFAULT_MAX_NAME_LENGTH))
  end
  return n
end


-- AFK/DnD
tags.Events["kFrames:afkdnd"] = 'PLAYER_FLAGS_CHANGED'
tags.Methods["kFrames:afkdnd"] = function(unit) 
  return UnitIsAFK(unit) and "|cffCFCFCFafk|r" or UnitIsDND(unit) and "|cffCFCFCFdnd|r" or ""
end


-- Combat
tags.Events["kFrames:combat"] = "PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED"
oUF.Tags.SharedEvents["PLAYER_REGEN_DISABLED"] = true
oUF.Tags.SharedEvents["PLAYER_REGEN_ENABLED"] = true
tags.Methods["kFrames:combat"] = function (unit)
  if unit == "player" and UnitAffectingCombat("player") then
    return "Combat"
  else
    return ""
  end
end


-- Ready check
tags.Events["kFrames:readycheck"] = "READY_CHECK READY_CHECK_CONFIRM READY_CHECK_FINISHED"
tags.Methods["kFrames:readycheck"] = function (unit)
  local status = GetReadyCheckStatus(unit)
  if UnitExists(unit) and status then
    if status == 'ready' then
      return "Ready"
    elseif(status == 'notready') then
      return "Unready"
    else
      return "Waiting"
    end
  end
end
