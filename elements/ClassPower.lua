
local _, ns = ...

local elements = ns.elements

local playerClass = ns.util.playerClass
local STATUSBAR   = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING     = 1
local HEIGHT      = 18
local MAX_POWER   = 6


-- Repositions and hides the ClassPower backdrop if the bar doesn't exist
-- for the current spec. This ensures there isn't a transparent black box
-- isn't just floating there and the Castbar is correctly positioned.
local function PreUpdateClassPower(event)
  local p1, parent, p2, x, y = ns.util.parsePosition(event.position)
  if event.isEnabled then
    event.backdrop:SetHeight(event.height + (event.padding * 2))
    event.backdrop:SetPoint(p1, parent, p2, x, y)
    event.backdrop:SetAlpha(1)
  else
    event.backdrop:SetHeight(1)
    event.backdrop:SetPoint(p1, parent, p2, x, 0)
    event.backdrop:SetAlpha(0)
  end
  event.backdrop.background:SetAllPoints(event.backdrop)
end


-- Sizes and positions the ClassPower pips dynamically.
local function PostUpdateClassPower(element, power, maxPower, maxPowerChanged)
  if (not maxPowerChanged) then return end

  local height = element.height
  local padding = element.padding

  local width = (element.width - padding * (maxPower + 1)) / maxPower
  padding = width + padding

  for i = 1, maxPower do
    element[i]:SetSize(width, height)
    if (i > 1) then
      element[i]:SetPoint("LEFT", element[i-1], "RIGHT", PADDING, 0)
    end
  end
end


function elements.ClassPower(frame, position)
  local frameWidth = ns.defaults.size.width + (PADDING * 2)
  local p1, parent, p2, x, y = ns.util.parsePosition(position)

  -- Container of the entire ClassPower display
  local cpower = CreateFrame("Frame", "classpower", frame)
  cpower:SetPoint(p1, parent, p2, x, y)
  cpower:SetHeight(HEIGHT + (PADDING * 2))
  cpower:SetWidth(frameWidth)

  -- Dark frame background
  cpower.background = cpower:CreateTexture(nil, "BACKGROUND")
  cpower.background:SetAllPoints(cpower)
  cpower.background:SetColorTexture(0, 0, 0, 0.5)

  local pips = {}
  local multiplier = 0.3
  for i = 1, MAX_POWER do
    -- Actual pip
    local pip = CreateFrame("StatusBar", "oUF_ClassPower_"..i, cpower)
    pip:SetStatusBarTexture(STATUSBAR)
    pip:SetHeight(HEIGHT)
    pip:SetWidth(HEIGHT)  -- Overridden post update
    pip:SetPoint("LEFT", cpower, "LEFT", PADDING, 0)

    -- Pip's background
    pip.bg = pip:CreateTexture(nil, "BACKGROUND")
    pip.bg:SetAllPoints(pip)
    pip.bg:SetTexture(STATUSBAR)
    pip.bg.multiplier = multiplier

    pips[i] = pip
  end

  -- Useful information for PostUpdate handler
  pips.height = HEIGHT
  pips.width = frameWidth
  pips.padding = PADDING
  pips.backdrop = cpower
  pips.position = position

  pips.PreUpdate  = PreUpdateClassPower
  pips.PostUpdate = PostUpdateClassPower

  frame.ClassPower = pips
  frame.ClassPowerFrame = cpower

  -- TODO: Resize ClassPowerFrame when ClassPower is hidden
end
