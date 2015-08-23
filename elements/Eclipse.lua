--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015 Kellen <addons@mikitik.net>. All rights reserved.
  https://github.com/mikattack/oUF_Kellen
---------------------------------------------------------------------------]]


local _, ns = ...

oUF.colors.power.ECLIPSE_LUNAR = { 0,   0.6,  1 }
oUF.colors.power.ECLIPSE_SOLAR = { 0.8, 0.5,  0 }

local ECLIPSE_MARKER_COORDS = ECLIPSE_MARKER_COORDS
local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE

local LUNAR_COLOR = oUF.colors.power.ECLIPSE_LUNAR
local SOLAR_COLOR = oUF.colors.power.ECLIPSE_SOLAR

local BRIGHT = 1.2
local NORMAL = 0.8
local DIMMED = 0.5

local TEXTURE = ns.media.statusBar
local FONT = ns.media.smallFont


local function PostUpdateVisibility(frame, unit)
  frame.isHidden = not frame:IsShown()
  frame:PostUnitAura(unit)
end


local function PostUpdatePower(frame, unit, power, maxPower)
  if not power or frame.isHidden then return end
  local x = (power / maxPower) * (frame:GetWidth() / 2)
  frame.lunarBG:SetPoint("RIGHT", frame, "CENTER", x, 0)
end


local function PostUnitAura(frame, unit)
  if frame.isHidden then return end
  local hasLunarEclipse, hasSolarEclipse = frame.hasLunarEclipse, frame.hasSolarEclipse

  if hasLunarEclipse then
    frame.lunarBG:SetVertexColor(LUNAR_COLOR[1] * DIMMED, LUNAR_COLOR[2] * DIMMED, LUNAR_COLOR[3] * DIMMED)
    frame.solarBG:SetVertexColor(LUNAR_COLOR[1] * BRIGHT, LUNAR_COLOR[2] * BRIGHT, LUNAR_COLOR[3] * BRIGHT)
  elseif hasSolarEclipse then
    frame.lunarBG:SetVertexColor(SOLAR_COLOR[1] * BRIGHT, SOLAR_COLOR[2] * BRIGHT, SOLAR_COLOR[3] * BRIGHT)
    frame.solarBG:SetVertexColor(SOLAR_COLOR[1] * DIMMED, SOLAR_COLOR[2] * DIMMED, SOLAR_COLOR[3] * DIMMED)
  else
    frame.lunarBG:SetVertexColor(LUNAR_COLOR[1] * NORMAL, LUNAR_COLOR[2] * NORMAL, LUNAR_COLOR[3] * NORMAL)
    frame.solarBG:SetVertexColor(SOLAR_COLOR[1] * NORMAL, SOLAR_COLOR[2] * NORMAL, SOLAR_COLOR[3] * NORMAL)
  end
end


local function PostDirectionChange(frame, unit)
  if frame.isHidden then return end
  local direction = GetEclipseDirection()

  local coords = ECLIPSE_MARKER_COORDS[direction]
  frame.directionArrow:SetTexCoord(coords[1], coords[2], coords[3], coords[4])

  if direction == "moon" then
    frame.directionArrow:SetPoint("CENTER", frame.lunarBG, "RIGHT", 1, 1)
  elseif direction == "sun" then
    frame.directionArrow:SetPoint("CENTER", frame.lunarBG, "RIGHT", -1, 1)
  else
    frame.directionArrow:SetPoint("CENTER", frame.lunarBG, "RIGHT", 0, 1)
  end
end


function ns.elements.Eclipse(frame, position)
  if ns.util.playerClass ~= "DRUID" then return end

  local frameWidth  = ns.config.classbarWidth
  local frameHeight = 16
  local p1, parent, p2, x, y = ns.util.parsePosition(position)

  local EclipseBar = CreateFrame("Frame", nil, frame)
  EclipseBar:SetPoint(p1, parent, p2, x, y)
  EclipseBar:SetSize(frameWidth, frameHeight)

--[[
  local bg = EclipseBar:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(EclipseBar)
  bg:SetTexture(TEXTURE)
  bg:SetVertexColor(0, 0, 0, 1)
  EclipseBar.bg = bg
--]]

  local lunarBar = CreateFrame('StatusBar', nil, EclipseBar)
  lunarBar:SetPoint('LEFT', EclipseBar, 'LEFT', 0, 0)
  lunarBar:SetSize(EclipseBar:GetWidth(), EclipseBar:GetHeight())
  lunarBar:SetStatusBarTexture(TEXTURE)
  lunarBar:SetStatusBarColor(.1, .3, .7)
  --lunarBar:SetFrameLevel(5)

--[[
  local lunarBG = EclipseBar:CreateTexture(nil, "BACKGROUND", nil, 1)
  lunarBG:SetPoint("TOPLEFT", EclipseBar, 1, -1)
  lunarBG:SetPoint("BOTTOMLEFT", EclipseBar, 1, 0)
  lunarBG:SetPoint("RIGHT", EclipseBar, "CENTER")
  lunarBG:SetTexture(TEXTURE)
  EclipseBar.lunarBG = lunarBG
--]]

  EclipseBar.LunarBar = lunarBar

  local solarBar = CreateFrame('StatusBar', nil, EclipseBar)
  solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
  solarBar:SetSize(EclipseBar:GetWidth(), EclipseBar:GetHeight())
  solarBar:SetStatusBarTexture(TEXTURE)
  solarBar:SetStatusBarColor(1,.85,.13)
  --solarBar:SetFrameLevel(5)

--[[
  local solarBG = EclipseBar:CreateTexture(nil, "BACKGROUND", nil, 1)
  solarBG:SetPoint("TOPRIGHT", EclipseBar, 1, 1)
  solarBG:SetPoint("BOTTOMRIGHT", EclipseBar, 1, 0)
  solarBG:SetPoint("LEFT", lunarBG, "RIGHT")
  solarBG:SetTexture(TEXTURE)
  EclipseBar.solarBG = solarBG
--]]

  EclipseBar.SolarBar = solarBar

  local eclipseArrow = EclipseBar:CreateTexture(nil, "OVERLAY")
  eclipseArrow:SetPoint("CENTER", lunarBG, "RIGHT", 0, 1)
  eclipseArrow:SetSize(24, 24)
  eclipseArrow:SetTexture([[Interface\PlayerFrame\UI-DruidEclipse]])
  eclipseArrow:SetBlendMode("ADD")
  EclipseBar.directionArrow = eclipseArrow

  local eclipseText = EclipseBar:CreateFontString(nil, "OVERLAY")
  eclipseText:SetFont(FONT, 16, "THINOUTLINE")
  eclipseText:SetPoint("CENTER", EclipseBar, "CENTER", 0, 1)
  eclipseText:Hide()
  frame:Tag(eclipseText, "[pereclipse]%")
  EclipseBar.value = eclipseText
  
  EclipseBar.frequentUpdates = true

--[[
  EclipseBar.PostDirectionChange  = PostDirectionChange
  EclipseBar.PostUnitAura         = PostUnitAura
  EclipseBar.PostUpdatePower      = PostUpdatePower
  EclipseBar.PostUpdateVisibility = PostUpdateVisibility
--]]

  frame.EclipseBar = EclipseBar
end
