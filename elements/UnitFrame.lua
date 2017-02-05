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

local defaults   = ns.defaults
local elements = ns.elements
local media    = ns.media

local LARGE_FONT = media.largeFont or STANDARD_TEXT_FONT
local SMALL_FONT = media.smallFont or STANDARD_TEXT_FONT

local FLATBAR = media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]

local PADDING = defaults.padding
local POWER_HEIGHT = defaults.powerheight


-- 
-- Adds basic unit frame elements to a given frame.
-- 
-- Basic frame elements include:
--  + Health bar
--  + Power bar
--  + Health percentage readout
--  + Black background
-- 
-- @param frame   Frame to create bar for.
-- 
function elements.InitializeUnitFrame(frame, opts)
  local opts = opts or {}
  local fontsize = opts.fontsize or 44
  local height = opts.height or defaults.size.height
  local width  = opts.width or defaults.size.width

  -- Size the frame
  frame:SetWidth(width + (PADDING * 2))
  frame:SetHeight(math.floor(height + POWER_HEIGHT + (PADDING * 3)))

  -- Health bar
  local hfg, hbg = elements.NewStatusBar(frame, {
    height = height,
    width  = width,
  })
  frame.Health = hfg
  frame.Health.bg = hbg
  frame.Health:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", PADDING, PADDING)

  -- Power bar
  local pfg, pbg = elements.NewStatusBar(frame, {
    height  = POWER_HEIGHT,
    width   = width,
    fg      = FLATBAR,
    bg      = FLATBAR,
  })
  frame.Power = pfg
  frame.Power.bg = pbg
  frame.Power:SetPoint("BOTTOMLEFT", frame.Health, "TOPLEFT", 0, 1)

  -- Text readouts
  frame.HealthText = elements.NewString(frame.Health, { font=LARGE_FONT, size=fontsize })
  frame.HealthText:SetPoint("TOPRIGHT", frame.Health, "TOPRIGHT", -2, 0)
  frame.HealthText:SetDrawLayer("OVERLAY")
  frame.HealthText.frequentUpdates = true
  frame:Tag(frame.HealthText, "[perhp]")

  -- Background
  frame.Background = elements.NewBackground(frame)
  frame.Background:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
  frame.Background:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

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