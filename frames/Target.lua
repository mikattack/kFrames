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
local defaults  = ns.defaults
local elements  = ns.elements
local frames    = ns.frames
local media     = ns.media

local LARGE_FONT = media.largeFont or STANDARD_TEXT_FONT

local FLATBAR = media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]

local POWER_HEIGHT = 4


function frames.TargetFrame(frame)
  local height = defaults.altsize.height
  local width = defaults.size.width * 0.75

  elements.InitializeUnitFrame(frame, {
    fontsize  = 30,
    height    = height,
    width     = width,
  })

  -- Name
  local name = elements.NewString(frame, { font=LARGE_FONT, size=22 })
  name:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 2)
  frame:Tag(name, "|cFFFFF200[level]|r [kFrames:name]")

  -- Reposition the health readout
  frame.HealthText:ClearAllPoints()
  frame.HealthText:SetPoint("TOPRIGHT", frame.Health, "TOPRIGHT", -2, 0)
  
  -- Icons
  elements.TextIcon(frame, "Combat",  {"BOTTOMLEFT xxx BOTTOMLEFT 5 -6", frame.Health}, 18, frame.Health)

  --elements.TextIcon(frame, "Status",  {"TOPLEFT xxx TOPLEFT 2 "..ioffset, frame}, 18)
  elements.TextIcon(frame, "AFKDND",  {"LEFT xxx RIGHT 4 0", frame.kCombat}, 18, frame.Health)
  elements.TextIcon(frame, "PvP",     {"LEFT xxx RIGHT 4 0", frame.kAFKDND}, 18, frame.Health)

  elements.RaidMarkIcon(frame,        {"LEFT xxx RIGHT 5 0", name})

  elements.LFDRoleIcon(frame,         {"LEFT xxx RIGHT 5 0", frame.RaidIcon}, {20,20})
  elements.ReadyCheckIcon(frame,      {"LEFT xxx RIGHT 5 0", frame.LFDRole}, {20, 20})
  --[[
  elements.RaidLeaderIcon(frame,      {"LEFT xxx TOPLEFT 4 0", frame.Infobar})
  elements.RaidAssistIcon(frame,      {"LEFT xxx RIGHT 4 0", frame.Infobar})
  elements.RaidLootMasterIcon(frame,  {"LEFT xxx RIGHT 5 0", frame.Assistant})
  --]]

  -- Niceties
  elements.AddHealPrediction(frame)
  elements.AddDebuffHighlight(frame)
  elements.AddHighlight(frame)

  -- Castbar
  elements.NewCastbar(frame, { width=width, height=height })
  elements.repositionCastbar(frame, {"TOPRIGHT xxx BOTTOMRIGHT 0 -8", frame})

  -- Position frame(s)
  frame:SetPoint("RIGHT", UIParent, "BOTTOM", -155, 175)
end
