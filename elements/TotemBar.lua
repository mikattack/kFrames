
local _, addon = ...

local elements = addon.elements

local STATUSBAR  = addon.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING    = 1
local HEIGHT     = 18
local MAX_TOTEMS = 5
local MULTIPLIER = 0.3

local totem_lookup = {
  ["Counterstrike Totem"]     = 1,
  ["Earthbind Totem"]         = 2,
  ["Earthgrab Totem"]         = 2,
  ["Grounding Totem"]         = 1,
  ["Greater Earth Elemental"] = 2,
  ["Greater Fire Elemental"]  = 3,
  ["Healing Stream Totem"]    = 4,
  ["Healing Tide Totem"]      = 4,
  ["Lightning Surge Totem"]   = 1,
  ["Liquid Magma Totem"]      = 3,
  ["Skyfury Totem"]           = 3,
  ["Spirit Link Totem"]       = 4,
  ["Spirit Wolf"]             = 5,
  ["Totem Mastery"]           = 5,
  ["Voodoo Totem"]            = 5,
  ["Windfury Totem"]          = 1,
  ["Windrush Totem"]          = 1,
}
local color_lookup = {
  [1] = {0.41, 0.80, 0.94}, -- air
  [2] = {0.78, 0.61, 0.43}, -- earth
  [3] = {1.00, 0.49, 0.04}, -- fire
  [4] = {0.00, 0.44, 0.87}, -- water
  [5] = {1.00, 0.20, 1.00}, -- special
}


local function onUpdate(self, elapsed)
  local duration = self.duration - elapsed
  self.duration = duration
  self:SetValue(duration)
end


local function UpdateColor(self, slot, name)
  local totem_type = totem_lookup[name]
  if totem_type == nil then
    return
  end
  local r,g,b = unpack(color_lookup[totem_type])
  local mu = MULTIPLIER
  self[slot]:SetStatusBarColor(r,g,b)
  self[slot].bg:SetVertexColor(r * mu, g * mu, b * mu)
end


local function PostUpdate(self, slot, haveTotem, name, start, duration, icon)
  if not duration or duration == 0 then
    self[slot]:SetMinMaxValues(0, 1)
    self[slot]:SetValue(0)
    self[slot]:SetScript('OnUpdate', nil)
  else
    UpdateColor(self, slot, name)
    self[slot].duration = duration
    self[slot]:SetMinMaxValues(0, duration)
    self[slot]:SetValue(duration)
    self[slot]:SetScript('OnUpdate', onUpdate)
  end
end


function elements.TotemBar(frame, position)
  local p1, parent, p2, x, y = ns.util.parsePosition(position)
  local framewidth = ns.defaults.size.width + (PADDING * 2)
  local totemwidth = (framewidth - (MAX_TOTEMS * PADDING)) / MAX_TOTEMS

  local totems = CreateFrame("Frame", nil, frame)
  totems:SetPoint(p1, parent, p2, x, y)
  totems:SetSize(framewidth, HEIGHT + 2)

  totems.bg = totems:CreateTexture(nil, "BACKGROUND")
  totems.bg:SetAllPoints(totems)
  totems.bg:SetColorTexture(0, 0, 0, 0.5)

  frame.TotemFrame = totems
  frame.Totems = {}

  for i = 1, MAX_TOTEMS do
    local totem = CreateFrame("StatusBar", "oUF_Totem"..i, totems)
    totem:SetSize(totemwidth, HEIGHT)
    totem:SetStatusBarTexture(STATUSBAR)
    totem:SetStatusBarColor(100, 0, 0)
    totem:SetPoint('BOTTOMLEFT', totems, 'BOTTOMLEFT', (i-1) * totem:GetWidth() + i, 1)

    totem.bg = totem:CreateTexture(nil, "BACKGROUND")
    totem.bg:SetAllPoints(totem)
    totem.bg:SetTexture(STATUSBAR)
    totem.bg:SetVertexColor(50, 125, 0)

    frame.Totems[i] = totem
  end

  frame.Totems.PostUpdate = PostUpdate  -- Laser is the sauce
end
