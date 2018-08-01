
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
    event.backdrop:SetHeight(event.height + (event.padding * 2))
    event.backdrop:SetAlpha(1)
  else
    event.backdrop:SetHeight(1)
    event.backdrop:SetAlpha(0)
  end
end


-- Sizes and positions the ClassPower pips dynamically.
local function PostUpdateClassPower(element, power, maxPower, maxPowerChanged)
  if (not maxPowerChanged) then return end

  local height = element.height
  local padding = element.padding

  local width = (element.width - padding * (maxPower + 1)) / maxPower

  -- Update pip width
  for i = 1, maxPower do
    element[i]:SetSize(width, height)
    if (i > 1) then
      element[i]:SetPoint("LEFT", element[i-1], "RIGHT", PADDING, 0)
    end
  end

  -- Update empty pip width and visibility
  local pframe = element[1]:GetParent()
  for i = 1, MAX_POWER do
    pframe.empty_pips[i]:SetSize(width, height)
    if i <= maxPower and i > 1 then
      -- Resize empty pips
      pframe.empty_pips[i]:Show()
      pframe.empty_pips[i]:SetPoint("LEFT", pframe.empty_pips[i-1], "RIGHT", PADDING, 0)
    elseif i > 1 then
      -- Hide extra empty pips
      pframe.empty_pips[i]:Hide()
    end
  end
end


-- Updates pip/empty pip colors
local function UpdateColor(element, powerType)
  local color = element.__owner.colors.power[powerType]
  local r, g, b = color[1], color[2], color[3]
  local p = element.__owner.ClassPowerBar
  for i = 1, #element do
    local bar = element[i]
    bar:SetStatusBarColor(r, g, b)

    local bg = bar.bg
    local mu = 0.5
    if(bg) then
      mu = bg.multiplier or 0.5
      bg:SetVertexColor(r * mu, g * mu, b * mu)
    end

    if p.empty_pips and p.empty_pips[i] then
      p.empty_pips[i]:SetVertexColor(r * mu, g * mu, b * mu)
    end
  end
end


-- Creates a display which shows a number of "pips" based on a class'
-- resources. Supported classes include:
-- 
--   Rogue   - Combo Points
--   Mage    - Arcane Charges
--   Monk    - Chi Orbs
--   Paladin - Holy Power
--   Warlock - Soul Shards
-- 
function elements.ClassPower(frame)
  local defaultWidth = addon.defaults.frames.major.width
  local frameWidth = defaultWidth * 0.80 + (PADDING * 2)

  -- Container of the entire ClassPower display
  local cpower = CreateFrame("Frame", "classpower", frame)
  cpower:SetHeight(HEIGHT + (PADDING * 2))
  cpower:SetWidth(frameWidth)

  -- Dark frame background
  cpower.background = cpower:CreateTexture(nil, "BACKGROUND")
  cpower.background:SetAllPoints(cpower)
  cpower.background:SetColorTexture(0, 0, 0, 0.6)

  pipWidth = (frameWidth - PADDING * (MAX_POWER + 1)) / MAX_POWER

  local pips = {}
  local empty_pips = {}
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
      pip:SetPoint("LEFT", pips[i-1], "RIGHT", PADDING, 0)
    end

    -- Size and positioning may be overridden during PostUpdate.
    -- We need them correct first however if the character starts
    -- with the maximum number of pips (like an Ascension Monk).

    -- Pip's background (which appears if foreground pip is filling)
    pip.bg = pip:CreateTexture(nil, "BACKGROUND")
    pip.bg:SetAllPoints(pip)
    pip.bg:SetTexture(STATUSBAR)
    pip.bg.multiplier = multiplier

    -- Show a blank pip when regular one is absent
    local ep = cpower:CreateTexture(nil, "BACKGROUND")
    ep:SetTexture(STATUSBAR)
    ep:SetVertexColor(0.6, 0.6, 0.6, 1)
    ep:SetHeight(HEIGHT)
    ep:SetWidth(pipWidth)
    if i == 1 then
      ep:SetPoint("LEFT", cpower, "LEFT", PADDING, 0)
    else
      ep:SetPoint("LEFT", empty_pips[i-1], "RIGHT", PADDING, 0)
    end

    -- Add pip
    pips[i] = pip
    empty_pips[i] = ep
  end

  -- Useful information for PostUpdate handler
  pips.height = HEIGHT
  pips.width = frameWidth
  pips.padding = PADDING
  pips.backdrop = cpower

  pips.PreUpdate  = PreUpdateClassPower
  pips.PostUpdate = PostUpdateClassPower
  pips.UpdateColor = UpdateColor

  cpower.pips = pips  -- Set this as a frame's ClassPower element
  cpower.empty_pips = empty_pips
  return cpower
end
