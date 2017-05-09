
local _, ns = ...

local playerClass = ns.util.playerClass
local STATUSBAR = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING = 1
local HEIGHT = 18


function ns.elements.ComboPoints(frame, position)
  if playerClass ~= "ROGUE" and playerClass ~= "DRUID" then return end

  local frameWidth  = ns.defaults.size.width + (PADDING * 2)
  local pointWidth  = (frameWidth - PADDING * (MAX_COMBO_POINTS + 1)) / MAX_COMBO_POINTS
  local pointHeight = HEIGHT
  local p1, parent, p2, x, y = ns.util.parsePosition(position)

  local cp = CreateFrame("Frame", nil, frame)
  cp:SetPoint(p1, parent, p2, x, y)
  cp:SetHeight(pointHeight)
  cp:SetWidth(frameWidth)
  cp.hidden = false

  cp.background = cp:CreateTexture(nil, "BACKGROUND")
  cp.background:SetAllPoints(cp)
  cp.background:SetColorTexture(0, 0, 0, 0.5)

  local multiplier = 0.3
  for i = 1, MAX_COMBO_POINTS do
    local r, g, b = 0.3, 0.9, 0.3
    if i == 4 then
      r, g, b = 0.9, 0.9, 0
    elseif i == 5 then
      r, g, b = 0.9, 0.3, 0.3
    end

    local point = cp:CreateTexture(nil, "BORDER")
    point:SetWidth(pointWidth)
    point:SetHeight(pointHeight - 2 * PADDING)
    point:SetTexture(STATUSBAR)
    point:SetVertexColor(r, g, b)

    point.bg = cp:CreateTexture(nil, "BACKGROUND")
    point.bg:SetAllPoints(point)
    point.bg:SetTexture(STATUSBAR)
    point.bg:SetVertexColor(r * multiplier, g * multiplier, b * multiplier)

    if (i == 1) then
      point:SetPoint('LEFT', cp, 'LEFT', PADDING, 0)
    else
      point:SetPoint('TOPLEFT', cp[i-1], 'TOPRIGHT', PADDING, 0)
    end

    cp[i] = point
  end
  
  frame.klnComboPoints = cp
end
