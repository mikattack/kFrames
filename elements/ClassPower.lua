
local _, ns = ...

local playerClass = ns.util.playerClass
local STATUSBAR   = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING     = 1
local HEIGHT      = 18
local MAX_POWER   = 6


function ns.elements.ClassPower(frame, position)
  local frameWidth = ns.defaults.size.width + (PADDING * 2)
  local p1, parent, p2, x, y = ns.util.parsePosition(position)

  -- Container of the entire ClassPower display
  local cpower = CreateFrame("Frame", "classpower", frame)
  cpower:SetPoint(p1, parent, p2, x, y)
  cpower:SetHeight(HEIGHT + (PADDING * 2))
  cpower:SetWidth(frameWidth)

  -- Useful information for PostUpdate handler
  cpower.height = HEIGHT
  cpower.width = frameWidth
  cpower.padding = PADDING

  -- Dark frame background
  cpower.background = cpower:CreateTexture(nil, "BACKGROUND")
  cpower.background:SetAllPoints(cpower)
  cpower.background:SetColorTexture(0, 0, 0, 0.5)

  local pips = {}
  local multiplier = 0.3
  for i = 1, MAX_POWER do
    -- Actual pip
    local pip = cpower:CreateTexture("oUF_ClassPower_"..i, "BORDER")
    pip:SetTexture(STATUSBAR)
    pip:SetHeight(HEIGHT)
    pip:SetPoint("LEFT", cpower, "LEFT", PADDING, 0)

    -- Pip's background
    pip.bg = cpower:CreateTexture(nil, "BACKGROUND")
    pip.bg:SetAllPoints(pip)
    pip:SetTexture(STATUSBAR)

    pips[i] = pip
  end

  pips.PostUpdate = PostUpdateClassPowerIcons

  self.ClassPower = cpower
  self.ClassIcons = pips
end


local PostUpdateClassPowerIcons = function(element, power, maxPower, maxPowerChanged)
  if (not maxPowerChanged) then return end

  local height = element.height
  local padding = element.padding

  local width = (element.width - (maxPower * padding - padding)) / maxPower
  padding = width + padding

  for i = 1, maxPower do
    element[i]:SetSize(width, height)
    if (i > 1)
      element[i]:SetPoint("BOTTOMLEFT", element[i-1], "BOTTOMRIGHT", PADDING, 0)
    end
  end
end
