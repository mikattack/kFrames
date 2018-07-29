local _, addon = ...

local defaults = addon.defaults
local elements = addon.elements
local media    = addon.media

local BORDER    = media.flatBar or "Interface\\TargetingFrame\\UI-StatusBar"
local BAR       = media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local FONT      = media.smallFont
local ICON_SIZE = 40
local MAX_ICONS = 7

local BUFF_COLOR   = {0.2, 0.0, 0.8, 1.0}
local DEBUFF_COLOR = {0.8, 0.0, 0.2, 1.0}


local function AuraFilter(name, _, _, _, duration, _, caster)
  -- Default: Filter out ALL auras (blacklisted)
  local allow = false
  
  -- Allow/disallow auras on various lists
  if addon.auras.whitelist[name] then
    allow = true
  elseif addon.auras.raid[name] then
    allow = true
  elseif addon.auras.healer[name] and caster and caster == "player" then
    allow = true
  elseif addon.auras.blacklist[name] then
    allow = false
  end

  -- Finally, filter out all personal buffs over 5min.
  if (caster and caster == "player") and (duration == 0 or duration > 300) then
    allow = false
  end
  
  return allow
  --]]
end


local function SetBackground(frame, color)
  if (frame.background) then return end

  if color == nil then
    color = {0,0,0,1}
  end

  frame.background = frame:CreateTexture(nil, "BACKGROUND", nil)
  frame.background:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
  frame.background:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
  frame.background:SetColorTexture(unpack(color))
end


function elements.AuraBar(frame, opts)
  f = CreateFrame("Frame", nil, frame)
  f:SetSize(frame:GetWidth(),1)
  
  -- Options
  f.auraBarTexture = BAR
  f.spacing = 1
  f.gap = 1
  f.auraBarHeight = 20
  --f.auraBarColor = .4,.4,.5
  f.filter = AuraFilter
  f.PostCreateBar = function(bar)
    SetBackground(bar)

    bar.icon.bg = bar.icon.bg or CreateFrame("frame", nil, bar)
    bar.icon.bg:SetAllPoints(bar.icon)
    bar.icon.bg:SetFrameLevel(0)
    bar.icon:SetDrawLayer('OVERLAY')
    SetBackground(bar.icon.bg)
    
    bar.spellname:SetPoint("LEFT", bar, "LEFT", 4, 0)
    bar.spellname:SetFont(FONT, 14)
    bar.spelltime:SetPoint("RIGHT", bar, "RIGHT", -4, 0)

    -- TO DO: Custom colors?
  end

  return f
end
