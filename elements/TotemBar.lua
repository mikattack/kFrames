
local _, ns = ...

local elements = ns.elements

local playerClass = ns.util.playerClass
local STATUSBAR   = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING     = 1
local HEIGHT      = ns.defaults.size.height
local MAX_TOTEMS  = 5


function elements.TotemBar(frame, position)
  local p1, parent, p2, x, y = ns.util.parsePosition(position)
  local framewidth = ns.defaults.size.width + (PADDING * 2)
  local width = (framewidth - (MAX_TOTEMS + 1) * PADDING) / MAX_TOTEMS

  local totems = CreateFrame("Frame", nil, frame)
  totems:SetPoint(p1, parent, p2, x, y + HEIGHT + 5)
  totems:SetHeight(HEIGHT)
  totems:SetWidth(framewidth)

  local pips = {}
  for i = 1, MAX_TOTEMS do
    local pip = CreateFrame("Button", "oUF_Totem"..i, frame.Overlay)
    pip:SetSize(HEIGHT, HEIGHT)
    pip:SetPoint('BOTTOMLEFT', totems, 'BOTTOMLEFT', (i-1) * pip:GetWidth(), 0)

    local icon = pip:CreateTexture(nil, "OVERLAY")
    icon:SetAllPoints()
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    pip.Icon = icon

    local cooldown = CreateFrame('Cooldown', nil, pip, 'CooldownFrameTemplate')
    cooldown:SetAllPoints()
    pip.Cooldown = cooldown

    pips[i] = pip
  end

  frame.Totems = pips
  frame.TotemFrame = totems
end
