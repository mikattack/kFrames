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
local frames   = ns.frames
local media    = ns.media

local LARGE_FONT = media.largeFont or STANDARD_TEXT_FONT

local FLATBAR = media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]

local PADDING = defaults.padding
local POWER_HEIGHT = 5


function frames.PlayerFrame(frame)
  elements.InitializeUnitFrame(frame)

  -- Create a "nameplate" in the upper left corner of the screen
  frame.InfoGradient = elements.NewBackground(frame, {
    height  = defaults.size.height * 1.5,
    width   = defaults.size.width * 0.85,
  })
  frame.InfoGradient:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 1)
  frame.InfoGradient:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)

  -- Name
  local name = elements.NewString(frame, { font=LARGE_FONT, size=36 })
  name:SetPoint("TOPLEFT", frame.InfoGradient, "TOPLEFT", 5, -8)
  frame:Tag(name, "[kFrames:name]")

  -- Icons
  elements.TextIcon(frame, "Combat",  {"BOTTOMLEFT xxx BOTTOMLEFT 5 -6", frame.Health}, 18, frame.Health)

  elements.TextIcon(frame, "Status",  {"TOPRIGHT xxx TOPRIGHT -4 -8", frame.InfoGradient}, 18)
  elements.TextIcon(frame, "AFKDND",  {"RIGHT xxx LEFT -4 0", frame.kStatus}, 18)
  elements.TextIcon(frame, "PvP",     {"RIGHT xxx LEFT -4 0", frame.kAFKDND}, 18)

  elements.RaidMarkIcon(frame,        {"LEFT xxx RIGHT 5 0", name})
  --elements.LFDRoleIcon(frame,         {"RIGHT xxx LEFT -5 0", frame.RaidIcon}, {20,20})
  --elements.ReadyCheckIcon(frame,      {"LEFT xxx RIGHT 5 0", frame.LFDRole}, {20,20})

  elements.RaidLeaderIcon(frame,      {"BOTTOMLEFT xxx TOPLEFT 0 1", name})
  elements.RaidAssistIcon(frame,      {"LEFT xxx RIGHT 3 0", frame.kLeader})
  elements.RaidLootMasterIcon(frame,  {"LEFT xxx RIGHT 3 0", frame.kAssistant})

  -- Additional Power (Druid mana)
  local altfg, altbg = elements.NewStatusBar(frame, {
    height  = POWER_HEIGHT,
    width   = math.floor(defaults.size.width * 0.5),
    fg      = FLATBAR,
    bg      = FLATBAR,
  })
  altfg:SetFrameLevel(50)
  altfg.colorPower = true

  altfg.background = elements.NewBackground(altfg)
  altfg.background:SetPoint("TOPLEFT", altfg, "TOPLEFT", -1, 1)
  altfg.background:SetPoint("BOTTOMRIGHT", altfg, "BOTTOMRIGHT", 1, -1)
  altfg.background:SetColorTexture(0, 0, 0, 1)

  frame.AdditionalPower = altfg
  frame.AdditionalPower.bg = altbg
  frame.AdditionalPower:SetPoint("CENTER", frame.Health, "BOTTOM", 0, 0)

  -- Niceties
  elements.AddHealPrediction(frame)
  elements.AddDebuffHighlight(frame)
  elements.AddHighlight(frame)

  -- Castbar
  elements.NewCastbar(frame)

  -- Class-specific additions
  local cbpos = {"BOTTOM xxx TOP 0 5", frame}
  local attach = frame
  if playerClass == "DEATHKNIGHT" then
    elements.RuneBar(frame, cbpos)
    attach = frame.Runes
  elseif playerClass == "DRUID" then
    elements.ComboPoints(frame, cbpos)
    attach = frame.klnComboPoints
  elseif playerClass == "ROGUE" then
    elements.ComboPoints(frame, cbpos)
    attach = frame.klnComboPoints
  elseif playerClass == "WARLOCK" then
    elements.SoulShards(frame, cbpos)
    attach = frame.SoulShards
  end
  elements.repositionCastbar(frame, {"BOTTOMLEFT xxx TOPLEFT 0 5", attach})

  -- Position frame(s)
  frame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 10)
end
