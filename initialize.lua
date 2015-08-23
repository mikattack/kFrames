--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015 Kellen <addons@mikitik.net>. All rights reserved.
  https://github.com/mikattack/oUF_Kellen
---------------------------------------------------------------------------]]


local _, ns = ...

local config = ns.config
local position = ns.position
local width  = config.width
local height = config.height

local factory = ns.factory

local sprint = ns.util.print
local parsePosition = ns.util.parsePosition

ns.frames = {}


-----------------------------------------------------------------------------


-- 
-- Define which frames we spawn via oUF and the functions we use to
-- decorate them.
-- 
local supportedFrames = {
  player        = factory.PlayerFrame,
  target        = factory.TargetFrame,
  targettarget  = factory.TargetTargetFrame,
  pet           = factory.PetFrame,
  -- raid          = factory.RaiderFrame,  -- Someday maybe
  boss          = factory.BossFrame,
  maintank      = factory.MainTankFrame,
}


-- Redelare colors
--[[
oUF.colors.runes = {
  {0.87, 0.12, 0.23},
  {0.40, 0.95, 0.20},
  {0.14, 0.50, 1},
  {.70, .21, 0.94},
}
--]]
oUF.colors.power.MANA = {0, 0.8, 1}


-----------------------------------------------------------------------------


-- 
-- These "styles" define common setup code for groups of frames.
-- 


-- 
-- Common unit frames
-- 
local function UnitStyle(self, unit, isSingle)
  if supportedFrames[unit] == nil then
    sprint("Cannot create unsupported frame \[\]", unit)
    return
  end

  self.menu = ns.RightClickMenu
  self:RegisterForClicks("AnyUp")
  self.RegisterForRoleChange = ns.util.RegisterForRoleChange

  self.unit = unit
  ns.frames[unit] = supportedFrames[unit](self, width, height)

  local p1, parent, p2, x, y = parsePosition(position[unit])
  if parent ~= "UIParent" and ns.frames[parent] then
    parent = ns.frames[parent]
  elseif parent ~= "UIParent" then
    sprint("Cannot attatch to unknown frame \[%s\]", parent)
    parent = "UIParent"   -- Your position was The Wrong
  end
  self:SetPoint(p1, parent, p2, x, y)
end


-- 
-- Boss unit frames
-- 
local function BossStyle(self, unit, isSingle)
  baseunit = gsub(unit, "%d", "")
  self.RegisterForRoleChange = ns.util.RegisterForRoleChange
  self.unit = unit
  ns.frames[unit] = supportedFrames[baseunit](self, width, height)
end


-- 
-- Tank unit frames
-- 
local function TankStyle(self, unit, isSingle)
  baseunit = gsub(unit, "%d", "")
  self.RegisterForRoleChange = ns.util.RegisterForRoleChange
  self.unit = unit
  ns.frames[unit] = supportedFrames[baseunit](self, width, height)
end


-----------------------------------------------------------------------------


oUF:RegisterStyle("klnUnit", UnitStyle)
oUF:RegisterStyle("klnBoss", BossStyle)
--oUF:RegisterStyle("klnTank", TankStyle)


-- 
-- The oUF factory spawns the frames you specify just once. Any other
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
  self:SetActiveStyle("klnUnit")
  local units = {"player", "target", "targettarget", "pet"}
  for i = 1, #units do
    ns.frames[units[i]] = oUF:Spawn(units[i])
  end

  -- Boss
  self:SetActiveStyle("klnBoss")
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
    ns.frames["boss"..i] = b
  end

  -- Decorate MirrorTimers
  for i = 1, 3 do
    local barname = "MirrorTimer" .. i
    local bar = _G[barname]
    ns.factory.DecorateMirrorFrame(bar)
  end
end)


oUF:DisableBlizzard('party')
