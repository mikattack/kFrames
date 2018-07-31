
local _, addon = ...

local defaults = addon.defaults
local elements = addon.elements
local frames   = addon.frames
local media    = addon.media

local FONT = media.font.large or STANDARD_TEXT_FONT


function frames.TargetFrame(frame)
  elements.InitializeUnitFrame(frame)

  -- Name
  local name = elements.NewString(frame, { font=FONT, size=22 })
  name:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -2)
  frame:Tag(name, "|cFFFFF200[level]|r [kFrames:name]")

  -- Reposition the health readout
  frame.HealthText:ClearAllPoints()
  frame.HealthText:SetPoint("TOPLEFT", frame.Health, "TOPLEFT", 2, 0)
  
  -- Icons
  --elements.TextIcon(frame, "Combat",  {"LEFT xxx LEFT 40 14", frame.Health}, 18, frame.Health)
  --elements.TextIcon(frame, "Status",  {"LEFT xxx RIGHT 4 0 ", frame.kCombat}, 18, frame.Health)
  elements.TextIcon(frame, "AFKDND", {"BOTTOMLEFT 55 -6 BOTTOMLEFT", frame.Health}, 18, frame.Health)
  elements.TextIcon(frame, "PvP",    {"LEFT 4 0 RIGHT", frame.kAFKDND}, 18, frame.Health)
  elements.RaidMarkIcon(frame,       {"RIGHT 5 0 LEFT", name})

  -- Niceties
  frame.HealthPrediction = elements.HealPrediction(frame)
  frame.DispelHighlight  = elements.DispelHighlight(frame)
  elements.AddHighlight(frame)

  -- Castbar
  --elements.NewCastbar(frame, { width=width, height=height })
  frame.Castbar = elements.Castbar:Create(frame)
  frame.Castbar:Reposition(frame, "BOTTOMLEFT 0 5 TOPLEFT")

  -- Auras
  frame.AuraBars = elements.AuraBar(frame)
  frame.AuraBars:SetPoint("BOTTOM", frame, "TOP", 0, frame.Castbar:GetHeight() + 5)

  -- Position frame cluster in the bottom right of the center screen
  local offset = defaults.frames.major.width + 5
  local height = defaults.frames.major.health_height
  frame:SetPoint("BOTTOM", "UIParent", "BOTTOM", offset, height)
end
