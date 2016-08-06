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
local elements  = ns.elements
local frames    = ns.frames
local layouts   = ns.layouts
local media     = ns.media
local position  = ns.position

local LARGE_FONT = media.largeFont or STANDARD_TEXT_FONT
local SMALL_FONT = media.smallFont or STANDARD_TEXT_FONT

local FLATBAR = media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]

local POWER_HEIGHT = 4


function frames.TargetFrame(frame)
  local offset = (config.size.classBarWidth / 2) + 10
  local ioffset = 0 - (config.size.castBarHeight / 2) + 8

  frames.MajorFrame(frame)

  -- Name
  local name = elements.CreateString(frame, LARGE_FONT, 22)
  name:SetPoint("BOTTOMRIGHT", frame.Identifier, "TOPRIGHT", -2, -8)
  frame:Tag(name, "|cFFFFF200[level]|r [kFrames:name]")
  
  -- Icons
  elements.CombatIcon(frame,          {"TOP xxx TOP 0 4", frame})
  --elements.TextIcon(frame, "Status",  {"TOPLEFT xxx TOPLEFT 2 "..ioffset, frame}, 18)
  elements.TextIcon(frame, "AFKDND",  {"TOPLEFT xxx TOPLEFT 3 "..ioffset, frame}, 18)
  elements.TextIcon(frame, "PvP",     {"LEFT xxx RIGHT 4 0", frame.kAFKDND}, 18)

  elements.RaidMarkIcon(frame,        {"RIGHT xxx LEFT -5 0", name})
  elements.LFDRoleIcon(frame,         {"RIGHT xxx LEFT -5 0", frame.RaidIcon}, {20,20})
  elements.ReadyCheckIcon(frame,      {"RIGHT xxx LEFT 5 0", frame.LFDRole}, {20, 20})
  elements.RaidLeaderIcon(frame,      {"LEFT xxx TOPLEFT 4 0", frame.Infobar})
  elements.RaidAssistIcon(frame,      {"LEFT xxx RIGHT 4 0", frame.Infobar})
  elements.RaidLootMasterIcon(frame,  {"LEFT xxx RIGHT 5 0", frame.Assistant})

  -- Add numerical health readout
  health = elements.CreateString(frame.Health, SMALL_FONT, 12)
  health:SetPoint("RIGHT", frame, "TOPRIGHT", -4, -14)
  health.frequentUpdates = true
  frame:Tag(health, "|cFFFF5555[kFrames:health]|r")
  frame.HealthNumber = health

  -- Reposition health and power readouts
  frame.HealthReadout:ClearAllPoints()
  frame.HealthReadout:SetPoint("TOPLEFT", frame.Health, "TOPLEFT", 2, 0)

  frame.PowerReadout:ClearAllPoints()
  frame.PowerReadout:SetPoint("RIGHT", frame.HealthNumber, "LEFT", -4, 0)

  -- Auras
  elements.AuraFrames(frame, "")

  -- Niceties
  elements.HealPrediction(frame)
  elements.DebuffHighlight(frame)
  elements.Highlight(frame)

  -- Castbar
  elements.Castbar(frame)
  frame.Castbar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)

  -- Position frame(s)
  frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOM", offset, 30)
  frame.Identifier:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOM", offset, 0)
end
