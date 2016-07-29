--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...
ns.layouts["PRIEST"] = {}
local layout = ns.layouts["PRIEST"]

local FLAT_BAR = ns.media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]


function layout.onCreate(frame)
  -- Alternate Power (Druid mana)
  local s = CreateFrame("StatusBar", nil, frame)
  s:SetHeight(4)
  s:SetStatusBarTexture(FLAT_BAR)
  s:GetStatusBarTexture():SetHorizTile(true)
  s:SetFrameStrata("MEDIUM")
  s.colorPower = true

  local b = s:CreateTexture(nil, "BACKGROUND")
  b:SetAllPoints(s)
  b:SetTexture(FLAT_BAR)
  b:SetColorTexture(.75, 0, 0, 1)

  frame.DruidMana = s
  frame.DruidMana.bg = b
  frame.DruidMana:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 1, -1)
  frame.DruidMana:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -1, -1)
  print("CREATE PRIEST ALT POWER")
end