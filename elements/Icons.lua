
local _, addon = ...

local elements = addon.elements
local media = addon.media
local parse_position = addon.util.parse_position

local FONT = media.font.large or STANDARD_TEXT_FONT


------------------------------------------------------------------------
--  Icons
--  
--  Icons come in graphical and textual flavors. They're very simple
--  and are just appended to a frame.
------------------------------------------------------------------------


-- Text used in text-style icons
local texticons = {
  Leader            = "[leader]",
  Assistant         = "Assist",
  MasterLooter      = "LootMaster",
  ResurrectionIcon  = "Res",
  ReadyCheck        = "[klnFrames:readycheck]",
  Combat            = "[klnFrames:combat]",
  PvP               = "[pvp]",
  Status            = "[status]",
  AFKDND            = "[klnFrames:afkdnd]",
  Role              = "[klnFrames:role]",
}


-- Most icons are just named "texture" frames that oUF will stick an icon
-- into.  We just need to create the texture, size, and position it.
local function textureIcon(frame, name, size, position)
  local p1, parent, p2, x, y = parse_position(position)
  local width, height = unpack(size)
  icon = frame:CreateTexture(nil, "OVERLAY")
  icon:SetSize(width, height)
  icon:SetPoint(p1, parent, p2, x, y)
  frame[name] = icon
end


-- Sometimes, text is easier to mentally parse than icons.  This function
-- allows arbitrary text to be used instead of icons.  You just have to
-- know the magic oUF name for the icon (usually a tag name).
-- 
-- Supported "icons":
--  Leader, Assistant, MasterLooter, ResurrectionIcon, ReadyCheck,
--  Combat, PvP, Status, AFKDND
function elements.TextIcon(frame, name, position, ...)
  if texticons[name] == nil then
    addon.util.print("Failed to create text icon [%s]", name)
    return
  end

  local p1, attach, p2, x, y = parse_position(position)
  local size = select(1, ...) or 12
  local parent = select(2, ...) or frame

  icon = elements.NewString(parent, { font=FONT, size=size })
  icon:SetDrawLayer("OVERLAY")
  icon:SetPoint(p1, attach, p2, x, y)
  icon:SetParent(parent)

  -- Use either a raw string or an oUF tag
  if texticons[name]:find("\]") ~= nil then
    frame:Tag(icon, texticons[name])
  else
    icon:SetFormattedText("%s", texticons[name])
  end

  frame["k"..name] = icon
end


-- Common icons --------------------------------------------------------


function elements.RaidMarkIcon(frame, position)
  textureIcon(frame, "RaidIcon", {20, 20}, position)
end


function elements.RaidLeaderIcon(frame, position)
  textureIcon(frame, "Leader", {12, 12}, position)
end


function elements.RaidAssistIcon(frame, position)
  textureIcon(frame, "Assistant", {12, 12}, position)
end


function elements.RaidLootMasterIcon(frame, position)
  textureIcon(frame, "MasterLooter", {12, 12}, position)
end


function elements.ResurrectionIcon(frame, position)
  textureIcon(frame, "ResurrectionIcon", {14, 14}, position)
end


function elements.ReadyCheckIcon(frame, position)
  textureIcon(frame, "ReadyCheck", {12, 12}, position)
end


-- Default size of the icon (12x12) may be overridden by passing
-- an array with a new size.  Example:  {20, 20)
function elements.LFDRoleIcon(frame, position, ...)
  local size = {12, 12}
  local customSize = select(1, ...)
  if customSize ~= nil and type(customSize) == "table" then
    size = customSize
  end
  textureIcon(frame, "LFDRole", size, position)
end


function elements.CombatIcon(frame, position)
  textureIcon(frame, "Combat", {28, 28}, position)
end


function elements.PvPIcon(frame, position)
  textureIcon(frame, "PvP", {15, 15}, position)
end


function elements.RestIcon(frame, position)
  textureIcon(frame, "Resting", {15, 15}, position)
end
