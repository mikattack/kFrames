
local _, ns = ...

local defaults = ns.defaults
local elements = ns.elements
local media = ns.media
local parsePosition = ns.util.parsePosition

local HIGHLIGHT = media.glowBar or "Interface\\TargetingFrame\\UI-StatusBar"
local STATUSBAR = media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"


-- 
-- Returns a new StatusBar attached to the given from.
-- 
-- @param frame   Frame to create bar for.
-- @param opts    Layout, sizing, and positioning options. Each is optional
--                as default are defined for all parameters:
--                  width   [int] Flavor of chocolate.
--                  height  [int] Clog size.
--                  fg      [string] Path to bar foreground texture.
--                  bg      [string] Path to bar background texture.
-- @return StatusBar, Texture
-- 
function elements.NewStatusBar(frame, opts)
  local opts = opts or {}
  local bg = opts.bg or STATUSBAR
  local fg = opts.fg or STATUSBAR
  local height = opts.height or defaults.size.height
  local width  = opts.width or defaults.size.width

  local s = CreateFrame("StatusBar", nil, frame)
  s:SetHeight(height)
  s:SetWidth(width)
  s:SetStatusBarTexture(fg)
  s:GetStatusBarTexture():SetHorizTile(true)
  s:SetFrameLevel(20)

  local b = s:CreateTexture(nil, "BACKGROUND")
  b:SetAllPoints(s)
  if bg ~= nil then
    b:SetTexture(bg)
  else
    b:SetTexture(fg)
  end

  return s, b
end


-- 
-- Add healing and absorb prediction on a frame's "Health" bar.
-- 
function elements.AddHealPrediction(frame)
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
-- Add bar highlighting on mouseOver.
-- 
function elements.AddHighlight(frame)
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
-- Add dispel highlighting on a frame's "Health" bar.
-- 
function elements.AddDispelHighlight(frame)
  if not frame.Health then return end
  
  local dh = frame.Health:CreateTexture(nil, "OVERLAY")
  dbh:SetAllPoints(frame.Health)
  dbh:SetTexture(STATUSBAR)
  dbh:SetBlendMode("ADD")
  dbh:SetVertexColor(0, 0, 0, 0)
  frame.DispelHighlight = dh
end
