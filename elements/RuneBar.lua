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
local STATUSBAR = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local MAX_RUNES = 6
local PADDING = 1
local HEIGHT = 18
local r, g, b = 106/255, 184/255, 247/255


function ns.elements.RuneBar(frame, position)
  if playerClass ~= "DEATHKNIGHT" then return end

  local frameWidth  = ns.defaults.size.width + (PADDING * 2)
  local runeWidth  = (frameWidth - PADDING * (MAX_RUNES + 1)) / MAX_RUNES
  local runeHeight = HEIGHT
  local p1, parent, p2, x, y = ns.util.parsePosition(position)

  local runes = CreateFrame("Frame", nil, frame)
  runes:SetPoint(p1, parent, p2, x, y)
  runes:SetHeight(runeHeight)
  runes:SetWidth(frameWidth)
  runes.multiplier = 0.3

  runes.background = runes:CreateTexture(nil, "BACKGROUND")
  runes.background:SetAllPoints(runes)
  runes.background:SetColorTexture(0, 0, 0, 0.5)

  for i = 1, MAX_RUNES do
    local rune = CreateFrame("StatusBar", nil, frame)
    rune:SetWidth(runeWidth)
    rune:SetHeight(runeHeight - PADDING * 2)
    rune:SetStatusBarTexture(STATUSBAR)
    rune:SetStatusBarColor(r, g, b, 1)

    rune.bg = rune:CreateTexture(nil, "BACKGROUND")
    rune.bg:SetAllPoints(rune)
    rune.bg:SetTexture(STATUSBAR)

    if (i == 1) then
      rune:SetPoint('LEFT', runes, 'LEFT', PADDING, 0)
    else
      rune:SetPoint('TOPLEFT', runes[i-1], 'TOPRIGHT', PADDING, 0)
    end

    runes[i] = rune
  end
  
  frame.Runes = runes
end
