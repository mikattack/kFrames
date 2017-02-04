--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...

local playerClass = ns.util.playerClass
local config    = ns.config
local frames    = ns.frames
local media     = ns.media

local LARGE_FONT = media.largeFont or STANDARD_TEXT_FONT
local SMALL_FONT = media.smallFont or STANDARD_TEXT_FONT

local STATUSBAR = media.statusBar or [[Interface\TargetingFrame\UI-StatusBar]]
local FLATBAR   = media.flatBar   or [[Interface\TargetingFrame\UI-StatusBar]]

local POWER_HEIGHT = 4
local PADDING = 1


------------------------------------------------------------------------
-- Element generators
------------------------------------------------------------------------


-- 
-- Creates a string for a given frame.
-- 
-- @param frame     Frame to create string for.
-- @param font      Path of the font file.
-- @param size      Font size.
-- @param outline   [optional] Outline style (default: OUTLINE).
-- @return FontString
-- 
local function CreateString(frame, font, size, outline)
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
  s:SetFrameLevel(20)
  --s:SetFrameStrata("MEDIUM")

  local b = s:CreateTexture(nil, "BACKGROUND")
  b:SetAllPoints(s)
  if bg ~= nil then
    b:SetTexture(bg)
  else
    b:SetTexture(fg)
  end

  return s, b
end


ns.elements.CreateString = CreateString
ns.elements.CreateBar = CreateBar


------------------------------------------------------------------------
-- Factories for Player and Target frame clusters ("primary" frames)
------------------------------------------------------------------------


--
-- Major Frame
-- 
-- Generates the base frame cluster for non-raid/non-party player and
-- target units.  Specific frames should add, remove, or decorate these
-- base elements.
-- 
function frames.MajorFrame(frame)
  local height = config.size.primaryCluster.height
  local width  = config.size.primaryCluster.width
  local cheight = config.size.castBarHeight

  -- Size the main part of the frame
  frame:SetWidth(width + (PADDING * 2))
  frame:SetHeight(math.floor(height + POWER_HEIGHT + cheight + (PADDING * 4)))

    -- Health bar 
  local hfg, hbg = CreateBar(frame, width, height, STATUSBAR)
  frame.Health = hfg
  frame.Health.bg = hbg
  frame.Health:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", PADDING, PADDING)
  
  -- Power bar
  local pfg, pbg = CreateBar(frame, width, POWER_HEIGHT, FLATBAR)
  frame.Power = pfg
  frame.Power.bg = pbg
  frame.Power:SetPoint("BOTTOMRIGHT", frame.Health, "TOPRIGHT", 0, 1)

  -- Text readouts
  local health, power

  health = CreateString(frame.Health, LARGE_FONT, 44)
  health:SetPoint("TOPRIGHT", frame.Health, "TOPRIGHT", -2, 0)
  health:SetDrawLayer("OVERLAY")
  health.frequentUpdates = true

  power = CreateString(frame.Health, SMALL_FONT, 12)
  power:SetPoint("LEFT", frame, "TOPLEFT", 5, -14)
  power.frequentUpdates = true

  frame:Tag(health, "[perhp]")
  frame:Tag(power, "|cFF40E2F1[kFrames:power]|r")

  frame.HealthReadout = health -- For decorator attachment
  frame.PowerReadout = power    -- For decorator attachment

  -- Create identifier background
  frame.Identifier = frame:CreateTexture(nil, "BACKGROUND")
  frame.Identifier:SetHeight(POWER_HEIGHT * 2)
  frame.Identifier:SetWidth(width + (PADDING * 2))
  frame.Identifier:SetColorTexture(0, 0, 0, 1)

  -- Create Health/Power/Info/Castbar background
  frame.Infobar = frame:CreateTexture(nil, "BACKGROUND")
  frame.Infobar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
  frame.Infobar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  frame.Infobar:SetColorTexture(0, 0, 0, 1)

  -- oUF options
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


------------------------------------------------------------------------
-- Factories for Pet, Boss, etc. frame clusters ("secondary" frames)
------------------------------------------------------------------------


--
-- Minor Frame
-- 
-- Generates the base frame cluster for pet, focus,  and
-- target-of-target units.  Specific frames should add, remove, or
-- decorate these base elements.
-- 
function frames.MinorFrame(frame)
  local height = config.size.secondaryCluster.height
  local width  = config.size.secondaryCluster.width

  -- Size the frame
  frame:SetHeight(height + POWER_HEIGHT + (PADDING * 3))
  frame:SetWidth(width + (PADDING * 2))

  -- Create background
  frame.Background = frame:CreateTexture(nil, "BACKGROUND")
  frame.Background:SetAllPoints()
  frame.Background:SetColorTexture(0, 0, 0, 1)

  -- Health bar 
  local hfg, hbg = CreateBar(frame, width, height, STATUSBAR)
  frame.Health = hfg
  frame.Health.bg = hbg
  frame.Health:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)

  -- Power bar
  local pfg, pbg = CreateBar(frame, width, POWER_HEIGHT, FLATBAR)
  frame.Power = pfg
  frame.Power.bg = pbg
  frame.Power:SetPoint("BOTTOMLEFT", frame.Health, "TOPLEFT", 0, 1)

  -- Text readouts
  local health, name

  health = CreateString(frame.Health, LARGE_FONT, 32)
  health:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, 5)
  health.frequentUpdates = true

  name = CreateString(frame.Health, SMALL_FONT, 18)
  name:SetPoint("LEFT", frame, "BOTTOMLEFT", 5, 4)

  frame:Tag(name, "[kFrames:name]")
  frame:Tag(health, "[perhp]")

  frame.HealthReadout = health
  frame.Name = name

  -- oUF options
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
