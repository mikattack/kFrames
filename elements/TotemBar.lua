
local _, ns = ...

local elements = ns.elements

local playerClass = ns.util.playerClass
local STATUSBAR   = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING     = 1
local HEIGHT      = 18
local MAX_TOTEMS  = 5


local function PostUpdateTotems(totems, _, numShown)
  if numShown <= 0 then return end
  local xMult = numShown / 2
  local xPos = -(xMult * width + (xMult - 0.5) * spacing)
  local first = totems[1]
  first:SetPoint("LEFT", self.Overlay, "CENTER", xPos, 0)
  local lastVisible
  for slot = 1, #totems do
    local totem = totems[slot]
    if totem:IsVisible() then
      if lastVisible then
        totem:SetPoint("LEFT", lastVisible, "RIGHT", spacing, 0)
      elseif slot > 1 then
        for i = 1, first:GetNumPoints() do
          local point, relativeTo, relativePoint, x, y = first:GetPoint(i)
          if point == "LEFT" then
            totem:SetPoint(point, relativeTo, relativePoint, x, y)
            break
          end
        end
      end
      lastVisible = totem
    end
  end
end

function elements.TotemBar(frame, position)
  local framewidth = ns.defaults.size.width + (PADDING * 2)
  local width = (framewidth - (MAX_TOTEMS + 1) * spacing) / MAX_TOTEMS

  local totems = CreateFrame("Frame", nil, frame)
  totems:SetPoint(p1, parent, p2, x, y)
  totems:SetHeight(runeHeight)
  totems:SetWidth(frameWidth)

  totems.background = totems:CreateTexture(nil, "BACKGROUND")
  totems.background:SetAllPoints(totems)
  totems.background:SetColorTexture(0, 0, 0, 0.5)

  local pips = {}
  for i = 1, MAX_TOTEMS do
    local pip = CreateFrame("StatusBar", "oUF_Totem"..i, self.Overlay)
    pip:SetSize(width, height)
    pip:SetPoint(playerClass == "SHAMAN" and "BOTTOM" or "TOP", 0, 1)

    local icon = pip:CreateTexture(nil, "ARTWORK")
    icon:SetSize(width, width)
    icon:SetPoint("BOTTOM", pip, "TOP", 0, 1)
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon:Hide()
    pip.Icon = icon

    pips[i] = totem
  end

  pips.PostUpdate = PostUpdateTotems
  frame.CustomTotems = pips
  frame.TotemFrame = totems
end
