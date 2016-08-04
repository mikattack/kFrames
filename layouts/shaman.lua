--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...
ns.layouts["SHAMAN"] = {}
local layout = ns.layouts["SHAMAN"]

local FLAT_BAR = ns.media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]


function layout.onCreate(frame)
  -- Alternate Power (Druid mana)
  local fg = CreateFrame("StatusBar", nil, frame)
  fg:SetHeight(4)
  fg:SetStatusBarTexture(FLAT_BAR)
  fg:GetStatusBarTexture():SetHorizTile(true)
  fg:SetFrameStrata("MEDIUM")
  fg.colorPower = true

  local bg = fg:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(fg)
  bg:SetTexture(FLAT_BAR)
  bg:SetColorTexture(.75, 0, 0, 1)

  fg.background = fg:CreateTexture(nil, "BACKGROUND")
  fg.background:SetPoint("TOPLEFT", fg, "TOPLEFT", -1, 1)
  fg.background:SetPoint("BOTTOMRIGHT", fg, "BOTTOMRIGHT", 1, 0)
  fg.background:SetColorTexture(0, 0, 0, 1)

  frame.DruidMana = fg
  frame.DruidMana.bg = bg
  frame.DruidMana:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 1, 0)
  frame.DruidMana:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -1, 0)
end


function layout.postCreate(frames)
  -- Reposition cast bar above alternate power
  ns.elements.repositionCastbar(
    frames["player"].Castbar,
    frames["player"].DruidMana,
    "BOTTOMLEFT _ TOPLEFT -2 5")
end