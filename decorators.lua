--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015 Kellen <addons@mikitik.net>. All rights reserved.
  https://github.com/mikattack/oUF_Kellen
---------------------------------------------------------------------------]]


local _, ns = ...
ns.decorators = {}

local media = ns.media
local parsePosition = ns.util.parsePosition

local INDICATOR_FONT = media.largeFont or STANDARD_TEXT_FONT
local HIGHLIGHT      = media.glowBar or "Interface\\TargetingFrame\\UI-StatusBar"
local CASTBAR        = media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"


--[[-------------------------------------------------------------------------
  Frame/Unit Decorators

  Add common elements to a given frame.  Behavior of these elements may
  differ depending on the unit type of the frame.
---------------------------------------------------------------------------]]


-- Text used in text-style icons
local texticons = {
  Leader            = "[leader]",
  Assistant         = "Assist",
  MasterLooter      = "LootMaster",
  ResurrectionIcon  = "Res",
  ReadyCheck        = "[kln:readycheck]",
  Combat            = "[kln:combat]",
  PvP               = "[pvp]",
  Status            = "[status]",
  PhaseIcon         = "[kln:phase]",
  QuestIcon         = "[kln:quest]",
  AFKDND            = "[kln:afkdnd]"
}


-----------------------------------------------------------------------------
--  Icons
-----------------------------------------------------------------------------


-- Most icons are just named "texture" frames that oUF will stick an icon
-- into.  We just need to create the texture, size, and position it.
local function textureIcon(frame, name, size, position)
  local p1, parent, p2, x, y = parsePosition(position)
  local width, height = unpack(size)
  icon = frame:CreateTexture(nil, "OVERLAY")
  icon:SetSize(width, height)
  icon:SetPoint(p1, parent, p2, x, y)
  frame[name] = icon
end


-- Sometimes, text is easier to mentally parse than icons.  This function
-- allows arbitrary text to be used instead of icons.  You just have to
-- know the magic oUF name for the icon.
-- 
-- Supported "icons":
--  Leader, Assistant, MasterLooter, ResurrectionIcon, ReadyCheck,
--  Combat, PvP, Status, PhaseIcon, QuestIcon, AFKDND
function ns.decorators.TextIcon(frame, text, position, ...)
  if texticons[text] == nil then
    ns.util.print("Failed to create text icon [%s]", text)
    return
  end

  local p1, parent, p2, x, y = parsePosition(position)
  local size = select(1, ...) or 12

  icon = frame:CreateFontString(nil, "OVERLAY")
  icon:SetFont(INDICATOR_FONT, size, "OUTLINE")
  icon:SetPoint(p1, parent, p2, x, y)
  icon:SetParent(parent)

  -- Use either a raw string or a tag
  if texticons[text]:find("\]") ~= nil then
    frame:Tag(icon, texticons[text])
  else
    icon:SetFormattedText("%s", texticons[text])
    frame[name] = icon
  end
end


function ns.decorators.RaidMarkIcon(frame, position)
  textureIcon(frame, "RaidIcon", {20, 20}, position)
end


function ns.decorators.RaidLeaderIcon(frame, position)
  textureIcon(frame, "Leader", {12, 12}, position)
end


function ns.decorators.RaidAssistIcon(frame, position)
  textureIcon(frame, "Assistant", {12, 12}, position)
end


function ns.decorators.RaidLootMasterIcon(frame, position)
  textureIcon(frame, "MasterLooter", {12, 12}, position)
end


function ns.decorators.ResurrectionIcon(frame, position)
  textureIcon(frame, "ResurrectionIcon", {14, 14}, position)
end


function ns.decorators.ReadyCheckIcon(frame, position)
  textureIcon(frame, "ReadyCheck", {12, 12}, position)
end


-- Size of the icon (12x12) may be overridden by passing an array
-- with a new size.  Example:  {15, 15)
function ns.decorators.LFDRoleIcon(frame, position, ...)
  local size = {12, 12}
  local customSize = select(3, ...)
  if customSize ~= nil and type(customSize) == "table" then
    size = select(3, ...)
  end
  textureIcon(frame, "LFDRole", size, position)
end


function ns.decorators.CombatIcon(frame, position)
  textureIcon(frame, "Combat", {15, 15}, position)
end


function ns.decorators.PvPIcon(frame, position)
  textureIcon(frame, "PvP", {15, 15}, position)
end


function ns.decorators.RestIcon(frame, position)
  textureIcon(frame, "Resting", {15, 15}, position)
end


function ns.decorators.PhaseIcon(frame, position)
  textureIcon(frame, "PhaseIcon", {15, 15}, position)
end


function ns.decorators.QuestIcon(frame, position)
  textureIcon(frame, "QuestIcon", {15, 15}, position)
end


-----------------------------------------------------------------------------


-- 
-- Enables healing and absorb prediction on a frame's "Health" bar.
-- 
function ns.decorators.HealPredict(frame)
  local myBar = CreateFrame('StatusBar', nil, frame.Health)
  myBar:SetPoint('TOP')
  myBar:SetPoint('BOTTOM')
  myBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
  myBar:SetWidth(200)
  myBar:SetStatusBarTexture(CASTBAR)
  myBar:SetStatusBarColor(0, 1, 0, 0.5)
  
  local otherBar = CreateFrame('StatusBar', nil, frame.Health)
  otherBar:SetPoint('TOP')
  otherBar:SetPoint('BOTTOM')
  otherBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
  otherBar:SetWidth(200)
  otherBar:SetStatusBarTexture(CASTBAR)
  otherBar:SetStatusBarColor(0.5, 1, 0.5, 0.5)

  local absorbBar = CreateFrame('StatusBar', nil, frame.Health)
  absorbBar:SetPoint('TOP')
  absorbBar:SetPoint('BOTTOM')
  absorbBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
  absorbBar:SetWidth(200)
  absorbBar:SetStatusBarTexture(CASTBAR)
  absorbBar:SetStatusBarColor(0, 0.8, 1, 0.5)

  local healAbsorbBar = CreateFrame('StatusBar', nil, frame.Health)
  healAbsorbBar:SetPoint('TOP')
  healAbsorbBar:SetPoint('BOTTOM')
  healAbsorbBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
  healAbsorbBar:SetWidth(200)
  healAbsorbBar:SetStatusBarTexture(CASTBAR)
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


-----------------------------------------------------------------------------


-- 
-- Enables bar highlighting on mouseOver.
-- 
function ns.decorators.Highlight(frame)
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


-----------------------------------------------------------------------------


-- 
-- Enables debuff highlighting on frame's "Health" bar.
-- 
function ns.decorators.DebuffHighlight(frame)
  if not frame.Health then return end
  
  local dbh = frame.Health:CreateTexture(nil, "OVERLAY")
  dbh:SetAllPoints(frame.Health)
  dbh:SetTexture(bar_common)
  dbh:SetBlendMode("ADD")
  dbh:SetVertexColor(0, 0, 0, 0)
  frame.DebuffHighlight = dbh
end
