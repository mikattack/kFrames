local _, addon = ...

local defaults = addon.defaults
local elements = addon.elements
local media    = addon.media

local player = addon.util.player

local BAR  = media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local FONT = media.smallFont

local BAR_HEIGHT = 20


local function AuraFilter(name, _, _, _, duration, _, caster)
  -- Default: Filter out ALL auras (blacklisted)
  local allow = false

  local selfCast = (caster and caster == "player")
  
  -- Allow/disallow auras on various lists
  -- addon.util.print("%s: %s (self cast: %s)", playerClass, name, tostring(selfCast))
  if addon.auras.whitelist[name] then
    allow = true
  elseif addon.auras.raid[name] then
    allow = true
  elseif selfCast and addon.auras.healer[name] then
    allow = true
  elseif selfCast and addon.auras.class[player.class][name] then
    allow = true
  elseif addon.auras.blacklist[name] then
    allow = false
  end

  -- Finally, filter out all personal buffs over 5min.
  if (caster and caster == "player") and (duration == 0 or duration > 300) then
    allow = false
  end
  
  return allow
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


function elements.AuraBar(frame)
  f = CreateFrame("Frame", nil, frame)
  f:SetSize(frame:GetWidth(),1)
  
  -- Options
  f.auraBarTexture = BAR
  f.spacing = 1
  f.gap = 1
  f.auraBarHeight = BAR_HEIGHT
  --f.auraBarColor = .4,.4,.5
  f.filter = AuraFilter
  f.PostCreateBar = function(bar)
    -- Add black outlines to bar
    SetBackground(bar)

    -- Add black outlines to icon
    bar.icon.bg = bar.icon.bg or CreateFrame("frame", nil, bar)
    bar.icon.bg:SetAllPoints(bar.icon)
    bar.icon.bg:SetFrameLevel(0)
    bar.icon:SetDrawLayer('OVERLAY')
    SetBackground(bar.icon.bg)
    
    -- Prettify fonts
    bar.spellname:SetPoint("LEFT", bar, "LEFT", 4, 0)
    bar.spellname:SetFont(FONT, 13, "OUTLINE")

    bar.spelltime:SetPoint("RIGHT", bar, "RIGHT", -4, 0)
    bar.spelltime:SetFont(FONT, 13, "OUTLINE")

    -- TO DO: Custom colors?
  end

  return f
end
