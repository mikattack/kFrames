
local _, addon = ...

local defaults  = addon.defaults
local elements  = addon.elements
local frames    = addon.frames

local PADDING = defaults.padding


function frames.TargetOfTargetFrame(frame)
  local height = defaults.frames.minor.health_height
  local width  = defaults.frames.minor.width * 0.75

  elements.InitializeUnitFrame(frame, {
    fontsize  = 30,
    height    = height,
    width     = width,
  })

  -- Hide the power bar
  frame.Power:Hide()
  frame:SetHeight(math.floor(height + (PADDING * 2)))

  -- Reposition the health readout
  frame.HealthText:ClearAllPoints()
  frame.HealthText:SetPoint("TOPLEFT", frame.Health, "TOPLEFT", 2, 0)

  -- Name
  local name = elements.NewString(frame.Health, { size=18 })
  name:SetPoint("RIGHT", frame.Health, "RIGHT", -3, 0)
  frame:Tag(name, "[kFrames:name]")

  -- Niceties
  frame.HealthPrediction = elements.HealPrediction(frame)
  frame.DispelHighlight  = elements.DispelHighlight(frame)
  elements.AddHighlight(frame)

  -- Position
  frame:SetPoint("LEFT", UIParent, "BOTTOM", 155, 175)
  -- ns.generated.target
end
