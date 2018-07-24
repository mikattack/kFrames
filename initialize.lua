--[[--------------------------------------------------------------------
Initialize -  Set up all frames of the layout. Only loaded after
              initializing everything else.
----------------------------------------------------------------------]]


local _, ns = ...

local defaults = ns.defaults
local elements = ns.elements
local frames = ns.frames
local position = defaults.position

local sprint = ns.util.print
local parsePosition = ns.util.parsePosition

ns.generated = {}


-----------------------------------------------------------------------------


-- 
-- Define which frames we spawn via oUF and the functions we use to
-- decorate them.
-- 
local supportedFrames = {
  player        = frames.PlayerFrame,
  target        = frames.TargetFrame,
  --targettarget  = frames.TargetOfTargetFrame,
  pet           = frames.PetFrame,
  --raid          = frames.RaiderFrame,  -- Someday maybe
  --boss          = frames.BossFrame,
  --maintank      = frames.MainTankFrame,
}


-----------------------------------------------------------------------------


-- 
-- These "styles" define common setup code for groups of frames.
-- 


-- 
-- Common unit frames
-- 
local function UnitStyle(self, unit, isSingle)
  if supportedFrames[unit] == nil then
    sprint("Cannot create unsupported frame \[%s\]", unit)
    return
  end

  self.menu = ns.util.rightClickMenu
  self:RegisterForClicks("AnyUp")
  self.RegisterForRoleChange = ns.util.registerForRoleChange

  self.unit = unit
  ns.generated[unit] = supportedFrames[unit](self)

--[[
  local p1, parent, p2, x, y = parsePosition(position[unit])
  if parent ~= "UIParent" and ns.frames[parent] then
    parent = ns.frames[parent]
  elseif parent ~= "UIParent" then
    sprint("Cannot attatch to unknown frame \[%s\]", parent)
    parent = "UIParent"   -- Your position was The Wrong
  end
  self:SetPoint(p1, parent, p2, x, y)
--]]
end


-- 
-- Boss unit frames
-- 
local function BossStyle(self, unit, isSingle)
  baseunit = gsub(unit, "%d", "")
  self.RegisterForRoleChange = ns.util.RegisterForRoleChange
  self.unit = unit
  ns.generated[unit] = supportedFrames[baseunit](self)
end


-- 
-- Tank unit frames
-- 
local function TankStyle(self, unit, isSingle)
  baseunit = gsub(unit, "%d", "")
  self.RegisterForRoleChange = ns.util.RegisterForRoleChange
  self.unit = unit
  ns.generated[unit] = supportedFrames[baseunit](self)
end


-----------------------------------------------------------------------------


oUF:RegisterStyle("kUnit", UnitStyle)
--oUF:RegisterStyle("kBoss", BossStyle)
--oUF:RegisterStyle("kTank", TankStyle)


-- 
-- The oUF frames spawns the frames you specify just once. Any other
-- general frame-related setup should also go here (for example, the
-- prexisting MirrorTimers are modified here).
-- 
oUF:Factory(function(self)

  -- Remove irrelevant rightclick menu entries
  for _, menu in pairs(UnitPopupMenus) do
    for i = #menu, 1, -1 do
      local name = menu[i]
      if name == "SET_FOCUS" or name == "CLEAR_FOCUS" or name:match("^LOCK_%u+_FRAME$") or name:match("^UNLOCK_%u+_FRAME$") or name:match("^MOVE_%u+_FRAME$") or name:match("^RESET_%u+_FRAME_POSITION") then
        tremove(menu, i)
      end
    end
  end

  -- Units
  self:SetActiveStyle("kUnit")
  local units = {"player", "target", "pet"}
  for i = 1, #units do
    ns.generated[units[i]] = oUF:Spawn(units[i])
  end

--[[
  -- Boss
  self:SetActiveStyle("kBoss")
  local boss = {}
  for i = 1, 5 do
    local b = oUF:Spawn("boss"..i, "oUF_Boss"..i)
    if i == 1 then
      local p1, parent, p2, x, y = parsePosition(position["boss"])
      b:SetPoint(p1, parent, p2, x, y)
    else
      b:SetPoint("TOP", boss[i-1], "BOTTOM", 0, 5)
    end
    boss[i] = b
    ns.generated["boss"..i] = b
  end
--]]

  -- Decorate MirrorTimers
  for i = 1, 3 do
    local barname = "MirrorTimer" .. i
    elements.DecorateMirrorFrame(_G[barname])
  end
end)


-- Disable Blizzard frames
oUF:DisableBlizzard('party')


-- When addon loads
local function OnLoad(self, event, ...)
  -- Create a false Target frame to show when no target is selected
  --frames.FalseTargetFrame(defaults.width, defaults.height)

  -- Disable Blizzard raid controls
  CompactRaidFrameManager:UnregisterAllEvents()
  CompactRaidFrameManager:Hide()
  CompactRaidFrameContainer:UnregisterAllEvents()
  CompactRaidFrameContainer:Hide() 
end

local addon = CreateFrame("Frame", nil, UIParent)
addon:SetScript("OnEvent", OnLoad)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
  
