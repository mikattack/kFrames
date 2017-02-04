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


function frames.PlayerFrame(frame)
  local offset = 0 - (config.size.classBarWidth / 2) - 10
  local ioffset = 0 - (config.size.castBarHeight / 2) + 8

  frames.MajorFrame(frame)

  -- Name
  local name = elements.CreateString(frame, LARGE_FONT, 22)
  name:SetPoint("BOTTOMLEFT", frame.Identifier, "TOPLEFT", 2, -8)
  frame:Tag(name, "[kFrames:name]")

  -- Icons
  elements.CombatIcon(frame,          {"TOP xxx TOP 0 4", frame})
  --elements.TextIcon(frame, "Combat",  {"TOPRIGHT xxx TOPRIGHT -4 -3", frame}, 18)
  elements.TextIcon(frame, "Status",  {"TOPRIGHT xxx TOPRIGHT -2 "..ioffset, frame}, 18)
  elements.TextIcon(frame, "AFKDND",  {"RIGHT xxx LEFT -4 0", frame.kStatus}, 18)
  elements.TextIcon(frame, "PvP",     {"RIGHT xxx LEFT -4 0", frame.kAFKDND}, 18)

  elements.RaidMarkIcon(frame,        {"LEFT xxx RIGHT 5 0", name})
  elements.LFDRoleIcon(frame,         {"RIGHT xxx LEFT -5 0", frame.RaidIcon}, {20,20})
  elements.ReadyCheckIcon(frame,      {"LEFT xxx RIGHT 5 0", frame.LFDRole}, {20,20})
  elements.RaidLeaderIcon(frame,      {"RIGHT xxx TOPRIGHT -4 0", frame.Identifier})
  elements.RaidAssistIcon(frame,      {"RIGHT xxx LEFT -4 0", frame.Identifier})
  elements.RaidLootMasterIcon(frame,  {"RIGHT xxx LEFT -5 0", frame.Assistant})

  -- Alternate Power (Druid mana)
  local fg = CreateFrame("StatusBar", nil, frame)
  fg:SetHeight(POWER_HEIGHT)
  fg:SetWidth(math.floor(config.size.primaryCluster.width * 0.5))
  fg:SetStatusBarTexture(FLATBAR)
  fg:GetStatusBarTexture():SetHorizTile(true)
  fg:SetFrameLevel(50)
  fg.colorPower = true

  local bg = fg:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(fg)
  bg:SetTexture(FLATBAR)
  bg:SetColorTexture(.75, 0.2, 0.2, 1)

  fg.background = fg:CreateTexture(nil, "BACKGROUND")
  fg.background:SetPoint("TOPLEFT", fg, "TOPLEFT", -1, 1)
  fg.background:SetPoint("BOTTOMRIGHT", fg, "BOTTOMRIGHT", 1, -1)
  fg.background:SetColorTexture(0, 0, 0, 1)

  frame.DruidMana = fg
  frame.DruidMana.bg = bg
  frame.DruidMana:SetPoint("CENTER", frame.Health, "BOTTOM", 0, 0)

  -- Niceties
  elements.HealPrediction(frame)
  elements.DebuffHighlight(frame)
  elements.Highlight(frame)

  -- Castbar
  elements.Castbar(frame)
  frame.Castbar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)

  -- Class-specific additions
  if layouts[playerClass] and layouts[playerClass].onCreate then
    layouts[playerClass].onCreate(frame)
  end

  -- Position frame(s)
  frame:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOM", offset, 30)
  frame.Identifier:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOM", offset, 0)
end
