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

-- REMINDER: String color is |cAARRGGBBtext|r


-----------------------------------------------------------------------------


-- Auto-shortened Unit Name
tags.Events["kFrames:name"] = "UNIT_NAME_UPDATE"
tags.Methods["kFrames:name"] = function(u, r)
  local n = UnitName(r or u)
  local l = config.maxNameLength or 25
  if len(n) >= l then
    n = format('%s...', sub(n, 1, l))
  end
  return n
end


-- Very short unit name
tags.Events["kFrames:shortname"] = "UNIT_NAME_UPDATE"
tags.Methods["kFrames:shortname"] = function(u, r)
  local n = UnitName(r or u)
  local l = 14
  if len(n) >= l then
    n = format('%s...', sub(n, 1, l))
  end
  return n
end


-- AFK/DnD
tags.Events["kFrames:afkdnd"] = 'PLAYER_FLAGS_CHANGED'
tags.Methods["kFrames:afkdnd"] = function(unit) 
  return UnitIsAFK(unit) and "|cffCFCFCFafk|r" or UnitIsDND(unit) and "|cffCFCFCFdnd|r" or ""
end


-- Shortened Health
tags.Events["kFrames:health"] = 'UNIT_MAXHEALTH UNIT_HEALTH'
tags.Methods["kFrames:health"] = function(u) 
  return si(UnitHealth(u))
end


-- Shortened Power
tags.Events["kFrames:power"] = 'UNIT_MAXPOWER UNIT_POWER'
tags.Methods["kFrames:power"] = function(u) 
  local min, max = UnitPower(u), UnitPowerMax(u)
  if max == 100 then
    return min
  elseif min <= 0 then
    return 0
  else
    return si(min)
  end
end

-- Combat
tags.Events["kFrames:combat"] = "PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED"
tags.Methods["kFrames:combat"] = function (unit)
  if UnitAffectingCombat(unit) then
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
