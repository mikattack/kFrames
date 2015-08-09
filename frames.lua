--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015 Kellen <addons@mikitik.net>. All rights reserved.
  https://github.com/mikattack/oUF_Kellen
---------------------------------------------------------------------------]]


local _, ns = ...
local _, playerClass = UnitClass("player")

local config    = ns.config
local media     = ns.media
local decor     = ns.decorators
local elements  = ns.elements

ns.factory = {}

local LARGE_FONT = media.largeFont or STANDARD_TEXT_FONT
local SMALL_FONT = media.smallFont or STANDARD_TEXT_FONT
local PIXEL_FONT = media.pixelFont or STANDARD_TEXT_FONT

local STATUS_BAR = media.statusBar or [[Interface\TargetingFrame\UI-StatusBar]]
local PRIME_BAR  = media.primeBar  or [[Interface\TargetingFrame\UI-StatusBar]]
local FLAT_BAR   = media.flatBar   or [[Interface\TargetingFrame\UI-StatusBar]]


-----------------------------------------------------------------------------


-- 
-- Creates a string for a given frame.
-- 
-- @param frame     Frame to create string for.
-- @param font      Path of the font file.
-- @param size      Font size.
-- @return FontString
-- 
local function CreateString(frame, font, size, position, outline)
  outline = outline or "OUTLINE"

  local fs = frame:CreateFontString(nil, "OVERLAY")
  fs:SetFont(font, size, outline)
  fs:SetShadowColor(0, 0, 0, 0.8)
  fs:SetShadowOffset(1, -1)
  return fs
end


-- 
-- Creates a StatusBar for a given frame.
-- 
-- @param frame       Frame to create bar for.
-- @param width       Flavor of chocolate.
-- @param height      Clog size.
-- @param fg          Path to texture for bar foreground.
-- @param bg          [optional] Path to texture for bar background.
--                    If texture is not set, the background bar is to
--                    foreground texture.
-- @return StatusBar,
--         Texture    The foreground bar and background texture.
-- 
local function CreateBar(frame, width, height, fg, bg)
  bg = bg or fg

  local s = CreateFrame("StatusBar", nil, frame)
  s:SetHeight(height)
  s:SetWidth(width)
  s:SetStatusBarTexture(fg)
  s:GetStatusBarTexture():SetHorizTile(true)
  s:SetFrameStrata("MEDIUM")

  local b = s:CreateTexture(nil, "BACKGROUND")
  b:SetAllPoints(s)
  if bg ~= nil then
    b:SetTexture(bg)
  else
    b:SetTexture(fg)
  end

  return s, b
end



-- 
-- Creates a black background for a frame.
-- 
-- The background frame is positioned to fill the entirety of the parent
-- frame's.
-- 
-- @param frame   The frame the background is created for
-- @return Frame  The created background frame.
-- 
local function CreateBackground(frame)
  local bg = frame:CreateTexture(nil, "BACKGROUND")
  bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
  bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  bg:SetTexture(0, 0, 0, 1)
  return bg
end


-----------------------------------------------------------------------------

--
-- Base Unit Frame
-- 
-- Generates the base frame cluster for any particular, non-raid/non-party
-- unit.  Specific frames (like "player", "target", or "pet") should add,
-- remove, or decorate these base elements.
-- 
local function UnitFrame(frame, width, height)
  frame:SetSize(width, height + 7) -- 3 * 1px borders + 4px power bar
  frame.background = CreateBackground(frame)

  -- Health bar 
  local hfg, hbg = CreateBar(frame, width - 3, height, STATUS_BAR)
  frame.Health = hfg
  frame.Health.bg = hbg
  frame.Health:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -6)
  frame.Health:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 1)

  -- Power bar
  local pfg, pbg = CreateBar(frame, width - 2, 4, FLAT_BAR)
  frame.Power = pfg
  frame.Power.bg = pbg
  frame.Power:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
  frame.Power:SetPoint("BOTTOMRIGHT", frame.Health, "TOPRIGHT", 0, 1)

  -- Text readouts
  local percent, power

  percent = CreateString(frame.Health, LARGE_FONT, 30)
  percent:SetPoint("RIGHT", frame, "RIGHT", -4, -2)
  percent.frequentUpdates = true

  power = CreateString(frame.Health, PIXEL_FONT, 10, "NONE")
  power:SetPoint("BOTTOMRIGHT", percent, "BOTTOMLEFT", 0, 3)

  frame:Tag(percent, "[perhp]%")
  frame:Tag(power, "|cFF40E2F1[kln:power]|r")

  frame.HealthReadout = percent -- For decorator attachment
  frame.PowerReadout = power    -- For decorator attachment

  frame.Health.frequentUpdates = true
  frame.Health.colorTapping = true
  frame.Health.colorDisconnected = true
  frame.Health.colorClass = true
  frame.Health.colorReaction = true
  frame.Health.bg.multiplier = 0.5

  frame.Power.frequentUpdates = true
  frame.Power.colorPower = true
  frame.Power.bg.multiplier = 0.3
end


-----------------------------------------------------------------------------


function ns.factory.PlayerFrame(frame, width, height)
  UnitFrame(frame, width, height)

  frame:SetHeight(height + 28)

  -- Swap health texture
  frame.Health:SetStatusBarTexture(PRIME_BAR)
  frame.Health.bg:SetTexture(0, 0, 0, 1)
  frame.Health.bg.multiplier = 0

  -- Resize health bar
  frame.Health:ClearAllPoints()
  frame.Health:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -6)
  frame.Health:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -6)
  frame.Health:SetHeight(height)

  -- Name
  name = CreateString(frame.Health, LARGE_FONT, 22)
  name:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -5)
  frame:Tag(name, "[kln:name]")

  -- Castbar
  elements.Castbar(frame, "BOTTOM UIParent BOTTOM 10 200")

  -- Icons
  decor.RaidMarkIcon(frame,   {"RIGHT xxx LEFT -5 0", name})
  decor.RaidLeaderIcon(frame, {"RIGHT xxx LEFT -10 0", frame.PowerReadout})
  decor.RaidAssistIcon(frame, {"RIGHT xxx LEFT -10 0", frame.PowerReadout})
  decor.RaidLootMasterIcon(frame, {"RIGHT xxx LEFT -27 0", frame.PowerReadout})
  decor.LFDRoleIcon(frame,    {"RIGHT xxx LEFT -44 0", frame.PowerReadout})
  decor.ReadyCheckIcon(frame, {"RIGHT xxx LEFT -61 0", frame.PowerReadout})

  decor.TextIcon(frame, "Combat",    {"BOTTOMLEFT xxx BOTTOMLEFT 8 -6", frame}, 18)
  decor.TextIcon(frame, "Status",    {"BOTTOMLEFT xxx BOTTOMLEFT 8 -6", frame}, 18)
  decor.TextIcon(frame, "PvP",       {"BOTTOMLEFT xxx BOTTOMLEFT 60 -6", frame}, 18)
  decor.TextIcon(frame, "AFKDND",    {"BOTTOMLEFT xxx BOTTOMLEFT 90 -6", frame}, 18)
  --decor.TextIcon(frame, "PhaseIcon", {"LEFT xxx TOPLEFT 4 -2", frame.Power}, 18)  

  -- Niceties
  decor.HealPredict(frame)
  decor.DebuffHighlight(frame)
  decor.Highlight(frame)
end


function ns.factory.TargetFrame(frame, width, height)
  UnitFrame(frame, width, height)

  frame:SetHeight(height + 28)

  -- Swap health texture
  frame.Health:SetStatusBarTexture(PRIME_BAR)
  frame.Health.bg:SetTexture(0, 0, 0, 1)
  frame.Health.bg.multiplier = 0

  -- Resize health bar
  frame.Health:ClearAllPoints()
  frame.Health:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -6)
  frame.Health:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -6)
  frame.Health:SetHeight(height)

  -- Reposition health and power readouts
  frame.HealthReadout:ClearAllPoints()
  frame.PowerReadout:ClearAllPoints()
  frame.HealthReadout:SetPoint("LEFT", frame, "LEFT", 4, -2)
  frame.PowerReadout:SetPoint("BOTTOMLEFT", frame.HealthReadout, "BOTTOMRIGHT", 0, 3)

  -- Name
  name = CreateString(frame.Health, LARGE_FONT, 22)
  name:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -5)
  frame:Tag(name, "|cFFFFF200[level]|r [kln:name]")

  -- Castbar
  elements.Castbar(frame, "TOP oUF_kFrameCastbar_player BOTTOM 0 -5")

  -- Icons
  decor.RaidMarkIcon(frame,   {"LEFT xxx RIGHT 5 0", name})
  decor.RaidLeaderIcon(frame, {"LEFT xxx RIGHT -10 0", frame.PowerReadout})
  decor.RaidAssistIcon(frame, {"LEFT xxx RIGHT -10 0", frame.PowerReadout})
  decor.RaidLootMasterIcon(frame, {"LEFT xxx RIGHT -27 0", frame.PowerReadout})
  decor.LFDRoleIcon(frame,    {"LEFT xxx RIGHT -44 0", frame.PowerReadout})
  decor.ReadyCheckIcon(frame, {"LEFT xxx RIGHT -61 0", frame.PowerReadout})

  decor.TextIcon(frame, "Combat",    {"BOTTOMRIGHT xxx BOTTOMRIGHT -8 -6", frame}, 18)
  decor.TextIcon(frame, "Status",    {"BOTTOMRIGHT xxx BOTTOMRIGHT -8 -6", frame}, 18)
  decor.TextIcon(frame, "PvP",       {"BOTTOMRIGHT xxx BOTTOMRIGHT -60 -6", frame}, 18)
  decor.TextIcon(frame, "AFKDND",    {"BOTTOMRIGHT xxx BOTTOMRIGHT -90 -6", frame}, 18)
  --decor.TextIcon(frame, "PhaseIcon", {"RIGHT xxx TOPRIGHT -4 -2", frame.Power}, 18)
  decor.TextIcon(frame, "QuestIcon", {"RIGHT xxx TOPRIGHT -12 -2", frame.Power}, 18)

  -- Niceties
  decor.HealPredict(frame)
  decor.DebuffHighlight(frame)
  decor.Highlight(frame)
end


function ns.factory.TargetTargetFrame(frame, width, height)
  UnitFrame(frame, width, height)

  -- Resize frame
  --frame:SetHeight(height)
  frame:SetWidth(math.floor(width * 0.4))

  -- Swap health texture
  frame.Health:SetStatusBarTexture(PRIME_BAR)
  frame.Health.bg:SetTexture(0, 0, 0, 1)
  frame.Health.bg.multiplier = 0

  -- Name
  name = CreateString(frame.Health, LARGE_FONT, 14)
  name:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, -4)
  frame:Tag(name, "[kln:shortname]")

  -- Shrink health readout and hide power
  frame.HealthReadout:SetFont(LARGE_FONT, 24, "OUTLINE")
  frame.HealthReadout:ClearAllPoints()
  frame.HealthReadout:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, -8)
  frame.PowerReadout:Hide()
end


function ns.factory.PetFrame(frame, width, height)
  UnitFrame(frame, width, height)

  -- Alter existing elements
  frame.HealthReadout:Hide()
  frame.PowerReadout:Hide()
  frame:SetHeight(height + 12)
end


--[[
local function ns.factory.FocusFrame(frame, width, height)
  RaidFrame(frame, "pet", width, height)
end
--]]


function ns.factory.BossFrame(frame, width, height)
  UnitFrame(frame, width, height)
  local fontsize = 18

  -- Name
  name = CreateString(frame.Health, LARGE_FONT, fontsize)
  name:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 5, 15)
  frame:Tag(name, "[kln:name]")

  -- Hide power, and shorten frame height, color health by reaction,
  -- add raid marks
  frame.PowerReadout:Hide()
  frame:SetHeight(height + 12)
  decor.RaidMarkIcon(frame, {"LEFT xxx RIGHT 10 0", name})

  frame.Health.colorTapping = false
  frame.Health.colorDisconnected = false
  frame.Health.colorClass = false
end


function ns.factory.MainTankFrame(frame, width, height)
  --RaidFrame(frame, unit, width, height)
end


-----------------------------------------------------------------------------


--
-- Mirror Frames
--
-- The mirror frames are already in the global set of frames.  We simply want
-- to style them accordingly.
--
function ns.factory.DecorateMirrorFrame(frame)
  for _, region in pairs({ frame:GetRegions() }) do
    if region.GetTexture and region:GetTexture() == "SolidTexture" then
      region:Hide()
    end
  end

  frame:SetParent(UIParent)
  frame:SetWidth(225)
  frame:SetHeight(config.height)

  frame.bar = frame:GetChildren()
  frame.bg, frame.text, frame.border = frame:GetRegions()

  frame.bar:SetAllPoints(frame)
  frame.bar:SetStatusBarTexture(BAR_TEXTURE)

  frame.bg:ClearAllPoints()
  frame.bg:SetAllPoints(frame)
  frame.bg:SetTexture(BAR_TEXTURE)
  frame.bg:SetVertexColor(0.2, 0.2, 0.2, 1)

  frame.text:ClearAllPoints()
  frame.text:SetPoint("LEFT", frame, 4, 0)
  frame.text:SetFont(SMALL_FONT, 16, "OUTLINE")

  frame.border:Hide()
end
