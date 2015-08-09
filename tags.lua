--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015 Kellen <addons@mikitik.net>. All rights reserved.
  https://github.com/mikattack/oUF_Kellen
---------------------------------------------------------------------------]]


local _, ns = ...
local tags = oUF.Tags
local config = ns.config
local GetTime = GetTime

local format = string.format
local len = string.len
local sub = string.sub
local si = ns.util.si


-----------------------------------------------------------------------------


-- Auto-shortened Unit Name
tags.Events["kln:name"] = "UNIT_NAME_UPDATE"
tags.Methods["kln:name"] = function(u, r)
  local n = UnitName(r or u)
  local l = config.maxNameLength or 25
  if len(n) >= l then
    n = format('%s...', sub(n, 1, l))
  end
  return n
end


-- Very short unit name
tags.Events["kln:shortname"] = "UNIT_NAME_UPDATE"
tags.Methods["kln:shortname"] = function(u, r)
  local n = UnitName(r or u)
  local l = 14
  if len(n) >= l then
    n = format('%s...', sub(n, 1, l))
  end
  return n
end


-- AFK/DnD
tags.Events["kln:afkdnd"] = 'PLAYER_FLAGS_CHANGED'
tags.Methods["kln:afkdnd"] = function(unit) 
  return UnitIsAFK(unit) and "|cffCFCFCFafk|r" or UnitIsDND(unit) and "|cffCFCFCFdnd|r" or ""
end


-- Power as a percent (when it's more than [max == 100])
tags.Events["kln:power"] = 'UNIT_MAXPOWER UNIT_POWER'
tags.Methods["kln:power"] = function(u) 
  local min, max = UnitPower(u), UnitPowerMax(u)
  if max == 100 then
    return min
  elseif min == 0 then
    return 0
  else
    return math.floor(min / max * 100 + 0.5)
  end
end


-- Combat
tags.Events["kln:combat"] = "PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED"
tags.Methods["kln:combat"] = function (unit)
  if UnitAffectingCombat(unit) then
    return "Combat"
  else
    return ""
  end
end


-- Phased
tags.Events["kln:phase"] = "UNIT_PHASE"
tags.Methods["kln:phase"] = function (unit)
  if UnitInPhase(unit) then
    return "P"
  else
    return ""
  end
end


-- Quest objective
tags.Events["kln:quest"] = "UNIT_CLASSIFICATION_CHANGED"
tags.Methods["kln:quest"] = function (unit)
  if UnitIsQuestBoss(unit) then
    return "Q"
  else
    return ""
  end
end


-- Ready check
tags.Events["kln:readycheck"] = "READY_CHECK READY_CHECK_CONFIRM READY_CHECK_FINISHED"
tags.Methods["kln:readycheck"] = function (unit)
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
