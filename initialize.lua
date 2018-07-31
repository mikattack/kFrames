-----------------------------------------------------------------------------
-- Initialize -  Set up all frames for the layout. Only loaded after
--               initializing everything else.
-----------------------------------------------------------------------------


local _, addon = ...

local defaults = addon.defaults
local elements = addon.elements
local frames   = addon.frames

local sprint = addon.util.print

-- Disable Blizzard frames
oUF:DisableBlizzard('party')


-----------------------------------------------------------------------------


-- 
-- Define decorator functions for frames supported by the layout.
-- 
local decorators = {
  player = frames.PlayerFrame,
  target = frames.TargetFrame,
  pet    = frames.PetFrame,
  boss   = frames.Boss
  --targettarget  = frames.TargetOfTargetFrame,
}


-----------------------------------------------------------------------------


-- 
-- Decoration function applied to each unit frame.
-- 
local function ApplyUnitStyle(self, unit, isSingle)
  self:RegisterForClicks("AnyUp")
  self.menu = addon.util.rightClickMenu
  self.unit = unit

  fn = unit
  if string.find(unit, "boss") then fn = "boss" end

  if decorators[fn] then
    decorators[fn](self)
  end
end


-----------------------------------------------------------------------------


--[[
oUF How-To:
  To spawn the unit frames for your layout, you must define a "style".
  A style is essentially a named function that frame for each individual
  unit will be passed to. Your function must decorate and position all
  elements of that frame.

  As there can be multiple styles, you must set which will be used by
  the factory function. This is done with SetActiveStyle().

  If you want to do any other frame-related setup, it's best to do it
  in the factory function (example: decorating the MirrorTimers).
--]]
oUF:RegisterStyle("klnFrames", ApplyUnitStyle)
oUF:Factory(function(self)
  self:SetActiveStyle("klnFrames")

  -- Remove irrelevant rightclick menu entries
  for _, menu in pairs(UnitPopupMenus) do
    for i = #menu, 1, -1 do
      local name = menu[i]
      if name == "SET_FOCUS" or name == "CLEAR_FOCUS" or name:match("^LOCK_%u+_FRAME$") or name:match("^UNLOCK_%u+_FRAME$") or name:match("^MOVE_%u+_FRAME$") or name:match("^RESET_%u+_FRAME_POSITION") then
        tremove(menu, i)
      end
    end
  end

  -- Main frames (decorators are assumed to position them)
  oUF:Spawn("player")
  oUF:Spawn("target")
  oUF:Spawn("pet")

  -- Boss frames
  local boss_anchor = CreateFrame("frame", "klnFrames Boss Anchor", UIParent)
  boss_anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -110)
  boss_anchor.bosses = {}
  for i = 1, 5 do
    local b = oUF:Spawn("boss"..i, "oUF_Boss"..i)
    b:SetParent(boss_anchor)
    if i == 1 then
      b:SetPoint("TOPLEFT", boss_anchor, "TOPLEFT", 0, 0)
    else
      b:SetPoint("TOP", boss_anchor.bosses[i-1], "BOTTOM", 0, 5)
    end
    boss_anchor.bosses[i] = b
  end

  -- Decorate MirrorTimers
  for i = 1, 3 do
    local barname = "MirrorTimer" .. i
    elements.DecorateMirrorFrame(_G[barname])
  end
end)


-- 
-- Perform additional setup when player first enters world.
-- 
local function OnLoad(self, event, ...),
  -- Disable Blizzard raid controls
  CompactRaidFrameManager:UnregisterAllEvents()
  CompactRaidFrameManager:Hide()
  CompactRaidFrameContainer:UnregisterAllEvents()
  CompactRaidFrameContainer:Hide() 
end
local onLoad = CreateFrame("Frame", nil, UIParent)
onLoad:SetScript("OnEvent", OnLoad)
onLoad:RegisterEvent("PLAYER_ENTERING_WORLD")
