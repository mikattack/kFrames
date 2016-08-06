--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...

local elements = ns.elements
local media = ns.media
local parsePosition = ns.util.parsePosition

local FONT      = media.smallFont or STANDARD_TEXT_FONT
local HIGHLIGHT = media.glowBar or "Interface\\TargetingFrame\\UI-StatusBar"
local STATUSBAR = media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"


-- 
-- Enables healing and absorb prediction on a frame's "Health" bar.
-- 
function elements.HealPrediction(frame)
  local myBar = CreateFrame('StatusBar', nil, frame.Health)
  myBar:SetPoint('TOP')
  myBar:SetPoint('BOTTOM')
  myBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
  myBar:SetWidth(200)
  myBar:SetStatusBarTexture(STATUSBAR)
  myBar:SetStatusBarColor(0, 1, 0, 0.5)
  myBar.maxOverflow = 0
  
  local otherBar = CreateFrame('StatusBar', nil, frame.Health)
  otherBar:SetPoint('TOP')
  otherBar:SetPoint('BOTTOM')
  otherBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
  otherBar:SetWidth(200)
  otherBar:SetStatusBarTexture(STATUSBAR)
  otherBar:SetStatusBarColor(0.5, 1, 0.5, 0.5)

  local absorbBar = CreateFrame('StatusBar', nil, frame.Health)
  absorbBar:SetPoint('TOP')
  absorbBar:SetPoint('BOTTOM')
  absorbBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
  absorbBar:SetWidth(200)
  absorbBar:SetStatusBarTexture(STATUSBAR)
  absorbBar:SetStatusBarColor(0, 0.8, 1, 0.5)

  local healAbsorbBar = CreateFrame('StatusBar', nil, frame.Health)
  healAbsorbBar:SetPoint('TOP')
  healAbsorbBar:SetPoint('BOTTOM')
  healAbsorbBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
  healAbsorbBar:SetWidth(200)
  healAbsorbBar:SetStatusBarTexture(STATUSBAR)
  healAbsorbBar:SetStatusBarColor(0.5, 0.5, 1, 0.5)
  
  frame.HealPrediction = {
     myBar = myBar,
     otherBar = otherBar,
     absorbBar = absorbBar,
     healAbsorbBar = healAbsorbBar,
     maxOverflow = 1.05,
     frequentUpdates = true,
  }
end


-- 
-- Enables bar highlighting on mouseOver.
-- 
function elements.Highlight(frame)
  local OnEnter = function(f)
    UnitFrame_OnEnter(f)
    f.Highlight:Show()
    if f.mystyle == "raid" then
      GameTooltip:Hide()
      f.LFDRole:SetAlpha(1)
    end
  end

  local OnLeave = function(f)
    UnitFrame_OnLeave(f)
    f.Highlight:Hide()
    if f.mystyle == "raid" then
      f.LFDRole:SetAlpha(0)
    end
  end

  frame:SetScript("OnEnter", OnEnter)
  frame:SetScript("OnLeave", OnLeave)
  
  local hl = frame.Health:CreateTexture(nil, "OVERLAY")
  hl:SetAllPoints(frame.Health)
  hl:SetTexture(HIGHLIGHT)
  hl:SetVertexColor(.5, .5, .5, .1)
  hl:SetBlendMode("ADD")
  hl:Hide()
  frame.Highlight = hl
end


-- 
-- Enables debuff highlighting on frame's "Health" bar.
-- 
function elements.DebuffHighlight(frame)
  if not frame.Health then return end
  
  local dbh = frame.Health:CreateTexture(nil, "OVERLAY")
  dbh:SetAllPoints(frame.Health)
  dbh:SetTexture(STATUSBAR)
  dbh:SetBlendMode("ADD")
  dbh:SetVertexColor(0, 0, 0, 0)
  frame.DebuffHighlight = dbh
end
