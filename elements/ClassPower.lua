
local _, addon = ...

local elements = addon.elements
local player   = addon.util.player

local STATUSBAR = addon.media.texture.status or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING   = 1
local HEIGHT    = 14
local MAX_POWER = 6


-- Hides the ClassPower backdrop if the bar doesn't exist for the
-- current spec. This ensures there isn't a black box just floating there.
local function PreUpdateClassPower(event)
  if event.isEnabled then
    event:Show()
    --event.backdrop:SetHeight(event.height + (event.padding * 2))
    --event.backdrop:SetAlpha(1)
  else
    event:Hide()
    --event.backdrop:SetHeight(1)
    --event.backdrop:SetAlpha(0)
  end
end


-- Sizes and positions the ClassPower pips dynamically.
local function PostUpdateClassPower(element, power, maxPower, maxPowerChanged)
  if (not maxPowerChanged) then return end

  local height = element.info.height
  local padding = element.info.padding

  local width = (element.info.width - padding * (maxPower + 1)) / maxPower

  -- Update pip width
  for i = 1, maxPower do
    element[i]:SetSize(width, height)
    if (i > 1) then
      element[i]:SetPoint("LEFT", element[i-1], "RIGHT", PADDING, 0)
    end
  end

  -- Update empty pip width and visibility
  for i = 1, MAX_POWER do
    element.empty[i]:SetSize(width, height)
    if i <= maxPower and i > 1 then
      -- Resize empty pips
      element.empty[i]:Show()
      element.empty[i]:SetPoint("LEFT", element.empty[i-1], "RIGHT", PADDING, 0)
    elseif i > 1 then
      -- Hide extra empty pips
      element.empty[i]:Hide()
    end
  end
end


-- Updates pip/empty pip colors
local function UpdateColor(element, powerType)
  local color = element.__owner.colors.power[powerType]
  local r, g, b = color[1], color[2], color[3]
  for i = 1, #element do
    local bar = element[i]
    bar:SetStatusBarColor(r, g, b)

    local bg = bar.bg
    local mu = 0.5
    if(bg) then
      mu = bg.multiplier or 0.5
      bg:SetVertexColor(r * mu, g * mu, b * mu)
    end

    if element.empty and element.empty[i] then
      element.empty[i]:SetVertexColor(r * mu, g * mu, b * mu)
    end
  end
end


-- Creates a display which shows a number of "pips" based on a class'
-- resources. Supported classes include:
-- 
--   All     - Combo Points
--   Rogue   - Combo Points
--   Mage    - Arcane Charges
--   Monk    - Chi Orbs
--   Paladin - Holy Power
--   Warlock - Soul Shards
-- 
function elements.ClassPower(frame)
  local defaultWidth = addon.defaults.frames.major.width
  local frameWidth = defaultWidth * 0.8 + (PADDING * 2)

  -- Note about layering:
  --  This element (and several others) layer multiple textures
  --  on the same drawing level (ex: BACKGROUND). The order in
  --  which those elements are rendered is unspecified. This
  --  results in strange or "broken" behaviors. Fixing it only
  --  requires that textures be on a different draw layer
  --  (BACKGROUND, ARTWORK, etc) or have a differing "sublayer"
  --  specified (forth argument of CreateTexture).

  -- The root element is a Frame that has an ordered collection
  -- of pips. It will be "table-like" in that looping over it
  -- will yield the pips, as expected by oUF
  local cpower = CreateFrame("Frame", "classpower", frame)
  cpower:SetHeight(HEIGHT + (PADDING * 2))
  cpower:SetWidth(frameWidth)

  -- Dark frame background
  cpower.bg = cpower:CreateTexture(nil, "BACKGROUND", nil, 1)
  cpower.bg:SetAllPoints(cpower)
  cpower.bg:SetColorTexture(0, 0, 0, 1)

  pipWidth = (frameWidth - PADDING * (MAX_POWER + 1)) / MAX_POWER

  cpower.empty = {}
  local multiplier = 0.4
  for i = 1, MAX_POWER do
    -- Actual pip
    local pip = CreateFrame("StatusBar", "oUF_ClassPower_"..i, cpower)
    pip:SetStatusBarTexture(STATUSBAR)
    pip:SetHeight(HEIGHT)
    pip:SetWidth(pipWidth)
    if i == 1 then
      pip:SetPoint("LEFT", cpower, "LEFT", PADDING, 0)
    else
      pip:SetPoint("LEFT", cpower[i-1], "RIGHT", PADDING, 0)
    end

    -- Size and positioning may be overridden during PostUpdate.
    -- We need them correct first however if the character starts
    -- with the maximum number of pips (like an Ascension Monk).

    -- Pip's background (which appears if foreground pip is filling)
    pip.bg = pip:CreateTexture(nil, "BACKGROUND", nil, 4)
    pip.bg:SetAllPoints()
    pip.bg:SetTexture(STATUSBAR)
    pip.bg.multiplier = multiplier

    -- Show a blank pip when regular one is absent. Unlike
    -- Death Knight runes, when a pip isn't filled, it simply
    -- isn't shown.
    local ep = cpower:CreateTexture(nil, "BACKGROUND", nil, 2)
    ep:SetTexture(STATUSBAR)
    ep:SetVertexColor(0.6, 0.6, 0.6, 1)
    ep:SetHeight(HEIGHT)
    ep:SetWidth(pipWidth)
    if i == 1 then
      ep:SetPoint("LEFT", cpower, "LEFT", PADDING, 0)
    else
      ep:SetPoint("LEFT", cpower.empty[i-1], "RIGHT", PADDING, 0)
    end

    -- Add pip
    cpower[i] = pip
    cpower.empty[i] = ep
  end

  -- Useful information for PostUpdate handler
  cpower.info = {}
  cpower.info.height = HEIGHT
  cpower.info.width = frameWidth
  cpower.info.padding = PADDING

  cpower.PreUpdate  = PreUpdateClassPower
  cpower.PostUpdate = PostUpdateClassPower
  cpower.UpdateColor = UpdateColor

  return cpower
end
