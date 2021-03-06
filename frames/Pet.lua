
local _, addon = ...

local defaults = addon.defaults
local elements = addon.elements
local frames   = addon.frames

local PADDING = defaults.padding
local FONT    = addon.media.font.small or STANDARD_TEXT_FONT


function frames.PetFrame(frame)
  local height = defaults.frames.minor.health_height
  local width  = defaults.frames.minor.width

  elements.InitializeUnitFrame(frame, {
    fontsize = 34,
    height   = height,
    width    = width
  })

  -- Name
  local name = elements.NewString(frame.Health, { font=FONT, size=22 })
  name:SetPoint("LEFT", frame.Health, "LEFT", 5, -6)
  frame:Tag(name, "[klnFrames:name]")

  -- Reposition health text
  frame.HealthText:ClearAllPoints()
  frame.HealthText:SetPoint("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", -2, -10)

  -- Niceties
  frame.DispelHighlight  = elements.DispelHighlight(frame)
  elements.AddHighlight(frame)

  -- Position
  frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 5, -50)
end
