--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]

local _, ns = ...

local config = ns.config
local elements = ns.elements
local media = ns.media
local parsePosition = ns.util.parsePosition

local FONT      = media.smallFont or STANDARD_TEXT_FONT
local TEXTURE   = media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local ICONSIZE  = config.size.castBarHeight


function elements.Castbar(frame)
  if not frame.Infobar then return end

  local width  = config.size.primaryCluster.width

  local castbar = CreateFrame("StatusBar", "oUF_kFrameCastbar_"..frame.unit, frame)
  castbar:SetStatusBarTexture(TEXTURE)
  castbar:SetStatusBarColor(0.5, 0.5, 1, 1)
  castbar:SetSize(width - ICONSIZE, ICONSIZE)
  castbar:SetFrameLevel(100)

  -- Position ought to be set by a layout
  -- castbar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)

  -- Color
  castbar.CastingColor    = { 0.5,  0.5,  1 }
  castbar.CompleteColor   = { 0.5,  1,    0 }
  castbar.FailColor       = { 1.0,  0.5,  0 }
  castbar.ChannelingColor = { 0.5,  0.5,  1 }

  -- Black Frame Background
  --[[
  castbar.background = castbar:CreateTexture(nil, "BACKGROUND")
  castbar.background:SetPoint("TOPRIGHT", castbar, "TOPRIGHT", 1, 1)
  castbar.background:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 0, -1)
  castbar.background:SetWidth(width)
  castbar.background:SetColorTexture(0, 0, 0, 1)
  --]]

  -- Statusbar Background
  local cbg = castbar:CreateTexture(nil, "BACKGROUND")
  cbg:SetTexture(TEXTURE)
  cbg:SetVertexColor(0.5 * 0.2, 1 * 0.2, 1 * 0.2, 1)
  cbg:SetAllPoints(castbar)

  -- Spark
  local spark = castbar:CreateTexture(nil, "OVERLAY")
  spark:SetSize(10, ICONSIZE)
  spark:SetBlendMode("ADD")

  -- Timer
  local timer = castbar:CreateFontString(nil, "OVERLAY")
  timer:SetFont(FONT, 14, "THINOUTLINE")
  timer:SetPoint("RIGHT", castbar, -5, 0)


  -- Spell/Ability Name
  local text = castbar:CreateFontString(nil, "OVERLAY")
  text:SetFont(FONT, 14, "THINOUTLINE")
  text:SetPoint("LEFT", castbar, 5, -1)

  -- Icon
  local icon = castbar:CreateTexture(nil, "OVERLAY")
  icon:SetSize(ICONSIZE - 1, ICONSIZE)
  icon:SetPoint("RIGHT", castbar, "LEFT", -1, 0)
  icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

  -- Shield
  local shield = castbar:CreateTexture(nil, "OVERLAY")
  shield:SetSize(20, 20)
  shield:SetPoint("TOPRIGHT", castbar, -10, -10)

  -- Safezone
  local safezone = castbar:CreateTexture(nil, "OVERLAY")
  safezone:SetTexture(TEXTURE)
  safezone:SetVertexColor(1, 0, 0, 0.7)

  -- Registration
  frame.Castbar = castbar
  frame.Castbar.bg = cbg
  frame.Castbar.Spark = spark
  frame.Castbar.Time = timer
  frame.Castbar.Text = text
  frame.Castbar.Icon = icon
  if frame.unit == "player" then
    frame.Castbar.SafeZone = safezone
  else
    frame.Castbar.Shield = shield
  end

  -- Events
  castbar.PostCastStart       = PostCastStart
  castbar.PostChannelStart    = PostCastStart
  castbar.PostCastStop        = PostCastStop
  castbar.PostChannelStop     = PostChannelStop
  castbar.PostCastFailed      = PostCastFailed
  castbar.PostCastInterrupted = PostCastFailed
end


function elements.repositionCastbar(frame, attachment, position)
  local p1, _, p2, x, y = parsePosition(position)
  frame:SetPoint(p1, attachment, p2, x + ICONSIZE, y)
end


local function PostCastStart(self, unit, name, rank, text)
  local pcolor = {1, .5, .5}
  local interruptcb = {.5, .5, 1}
  self:SetAlpha(1.0)
  self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
  if unit == "player" then
    local sf = self.SafeZone
    if sf and sf.sendTime ~= nil then
      sf.timeDiff = GetTime() - sf.sendTime
      sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
      sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
      sf:Show()
    end
  elseif (unit == "target" or unit == "focus") and not self.interrupt then
    self:SetStatusBarColor(interruptcb[1],interruptcb[2],interruptcb[3],1)
  else
    self:SetStatusBarColor(pcolor[1], pcolor[2], pcolor[3],1)
  end
end


local function PostCastStop(self, unit, name, rank, castid)
  if not self.fadeOut then 
    self:SetStatusBarColor(unpack(self.CompleteColor))
    self.fadeOut = true
  end
  self:SetValue(self.max)
  self:Show()
end


local function PostChannelStop(self, unit, name, rank)
  self.fadeOut = true
  self:SetValue(0)
  self:Show()
end


local function PostCastFailed(self, event, unit, name, rank, castid)
  self:SetStatusBarColor(unpack(self.FailColor))
  self:SetValue(self.max)
  if not self.fadeOut then
    self.fadeOut = true
  end
  self:Show()
end
