-----------------------------------------------------------------------------
-- Util - Function grab bag.
-----------------------------------------------------------------------------


local _, addon = ...
local format = string.format
local util = addon.util


-----------------------------------------------------------------------------


-- 
-- Solid debugger.
-- 
function util.print(pattern, ...)
  print(format(pattern, ...))
end


-- 
-- Player information.
-- 
-- Includes (all normalized to lowercase):
-- 
--    class - Player class
--    role  - Player role ("tank", "healer", "damager", "none")
--    spec  - Player specialization (ex. "balance", "protection", "brewmaster")
-- 
util.player = { class=UnitClass("player"):lower() }

-- Automatically update "util.player" table information when
-- the player's specialization or role changes.
local roleupdate = CreateFrame("frame",nil)
roleupdate:RegisterEvent("LFG_ROLE_UPDATE")
roleupdate:RegisterEvent("PLAYER_ROLES_ASSIGNED")
roleupdate:RegisterEvent("ROLE_CHANGED_INFORM")
roleupdate:RegisterEvent("PVP_ROLE_UPDATE")
roleupdate:SetScript("OnEvent", function(self, event, arg)
  local spec = GetSpecialization() or 0
  local _, spec, _, _, _, role = GetSpecializationInfo(spec)
  util.player.role = role
  util.player.spec = spec:lower()
end)


-- 
-- Integer shortening (for easy-to-read number readouts).
-- 
function util.si(value, raw)
  if not value then return "" end
  local absvalue = abs(value)
  local str, val

  if absvalue >= 1e10 then
    str, val = "%.0fb", value / 1e9
  elseif absvalue >= 1e9 then
    str, val = "%.1fb", value / 1e9
  elseif absvalue >= 1e7 then
    str, val = "%.1fm", value / 1e6
  elseif absvalue >= 1e6 then
    str, val = "%.2fm", value / 1e6
  elseif absvalue >= 1e5 then
    str, val = "%.0fk", value / 1e3
  elseif absvalue >= 1e3 then
    str, val = "%.1fk", value / 1e3
  else
    str, val = "%d", value
  end

  if raw then
    return str, val
  else
    return format(str, val)
  end
end


-- 
-- Format large numbers with comma's for readability.
-- 
function util.comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


-- 
-- Convert textual position into individual values.
-- 
-- The anchor position of a UI object is difficult to pass around unless
-- you know the string name the object is referenced by. Without planning
-- and diligence, this is often not the case when creating UI objects.
-- 
-- This function allow you to pass around position information in a single
-- variable. You can pass just the positional information as string,
-- or you may pass it as a table, with the position and an anchor object
-- reference.
-- 
-- When passing a string, the following format is accepted:
-- 
--    "LEFT 10 5 RIGHT"
--     ---- -- - -----
--      p1  x  y  p2
--
-- This yields the following values (in order):
--    p1 - Anchor point of the object you are positioning.
--    a  - String or table of the object you are aligning against.
--         By default, this is always "UIParent".
--    p2 - Anchor point of the object you are aligning against.
--    x  - Horizontal offset.
--    y  - Vertical offset.
-- 
-- You may instead pass the position as an ordered table with two elements:
-- 
--    {"LEFT 10 5 RIGHT", my_frame}
-- 
-- This will yield the same output, except the returned anchor value ("a")
-- will be a reference to `my_frame`.
-- 
function util.parse_position(p)
  local p1, p2, x, y, parent
  anchor = "UIParent"
  if type(p) == "table" then
    anchor = p[2]
    p1, x, y, p2 = string.split(" ", p[1])
  else
    p1, x, y, p2 = string.split(" ", p)
  end
  return p1, anchor, p2, tonumber(x), tonumber(y)
end


-- 
-- Configure right-click menu of a frame.
-- 
function util.rightClickMenu(self)
  local unit = self.unit:sub(1, -2)
  local cunit = self.unit:gsub("^%l", string.upper)
  if(cunit == 'Vehicle') then
    cunit = 'Pet'
  end
  if unit == "party" or unit == "partypet" then
    ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
  elseif _G[cunit.."FrameDropDown"] then
    ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
  end
end


-- 
-- Register a function to execute upon a role change.  For example, when
-- moving from DAMAGER to HEALER.
-- 
function util.registerForRoleChange(self, func)
  if not self.updateOnRoleChange then
    self.updateOnRoleChange = {}
  else
    for i = 1, #self.updateOnRoleChange do
      if self.updateOnRoleChange[i] == func then
        return
      end
    end
  end
  tinsert(self.updateOnRoleChange, func)
end
