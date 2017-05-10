
local _, ns = ...

local playerClass = ns.util.playerClass
local STATUSBAR   = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING     = 1
local HEIGHT      = 18


function ns.elements.StaggerBar(frame, position)
  if playerClass ~= "MONK" then return end

  local width  = ns.defaults.size.width
  local height = HEIGHT
  local p1, parent, p2, x, y = ns.util.parsePosition(position)

  -- Background frame
  local stagger = CreateFrame("Frame", nil, frame)
  stagger:SetPoint(p1, parent, p2, x, y)
  stagger:SetHeight(height + + (PADDING * 2))
  stagger:SetWidth(width + (PADDING * 2))

  stagger.background = stagger:CreateTexture(nil, "BACKGROUND")
  stagger.background:SetAllPoints(stagger)
  stagger.background:SetColorTexture(0, 0, 0, 0.5)

  stagger:SetPoint(p1, parent, p2, x, y)

  -- Stagger bar itself
  local bar = CreateFrame("StatusBar", nil, frame)
  bar:SetWidth(width)
  bar:SetHeight(height)
  bar:SetStatusBarTexture(STATUSBAR)

  bar.bg = bar:CreateTexture(nil, "BACKGROUND")
  bar.bg:SetAllPoints(bar)
  bar.bg:SetTexture(STATUSBAR)

  bar.multiplier = 0.3
  bar:SetPoint("BOTTOMLEFT", stagger, "BOTTOMLEFT", 1, -1)

  frame.Stagger = bar
  frame.StaggerFrame = stagger
end
