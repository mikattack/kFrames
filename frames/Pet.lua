
local _, ns = ...

local defaults  = ns.defaults
local elements  = ns.elements
local frames    = ns.frames

local PADDING = defaults.padding
local FONT    = ns.media.smallFont or STANDARD_TEXT_FONT


function frames.PetFrame(frame)
  local height = defaults.altsize.height
  local width  = defaults.altsize.width

  elements.InitializeUnitFrame(frame, {
    fontsize = 34,
    height   = height,
    width    = width
  })

  -- Name
  local name = elements.NewString(frame.Health, { font=FONT, size=22 })
  name:SetPoint("LEFT", frame.Health, "LEFT", 5, -6)
  frame:Tag(name, "[kFrames:name]")

  -- Reposition health text
  frame.HealthText:ClearAllPoints()
  frame.HealthText:SetPoint("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", -2, -10)

  -- Niceties
  elements.AddDispelHighlight(frame)
  elements.AddHighlight(frame)

  -- Position
  frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -75)
end
