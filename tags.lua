-----------------------------------------------------------------------------
-- Tags - Custom oUF tags.
-----------------------------------------------------------------------------


local _, addon = ...

local tags = oUF.Tags

local GetTime = GetTime
local format = string.format
local len = string.len
local sub = string.sub
local si = addon.util.si

local DEFAULT_MAX_NAME_LENGTH = 30

-- REMINDER: String color is |cAARRGGBBtext|r


-----------------------------------------------------------------------------


-- Auto-shortened Unit Name
tags.Events["klnFrames:name"] = "UNIT_NAME_UPDATE"
tags.Methods["klnFrames:name"] = function(u, r)
  local n = UnitName(r or u)
  if len(n) >= DEFAULT_MAX_NAME_LENGTH then
    n = format('%s...', sub(n, 1, DEFAULT_MAX_NAME_LENGTH))
  end
  return n
end


-- AFK/DnD
tags.Events["klnFrames:afkdnd"] = 'PLAYER_FLAGS_CHANGED'
tags.Methods["klnFrames:afkdnd"] = function(unit) 
  return UnitIsAFK(unit) and "|cffCFCFCFafk|r" or UnitIsDND(unit) and "|cffCFCFCFdnd|r" or ""
end


-- Combat
tags.Events["klnFrames:combat"] = "PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED"
oUF.Tags.SharedEvents["PLAYER_REGEN_DISABLED"] = true
oUF.Tags.SharedEvents["PLAYER_REGEN_ENABLED"] = true
tags.Methods["klnFrames:combat"] = function (unit)
  if unit == "player" and UnitAffectingCombat("player") then
    return "Combat"
  else
    return ""
  end
end


-- Ready check
tags.Events["klnFrames:readycheck"] = "READY_CHECK READY_CHECK_CONFIRM READY_CHECK_FINISHED"
tags.Methods["klnFrames:readycheck"] = function (unit)
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
