--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...

local defaults  = ns.defaults
local elements  = ns.elements
local frames    = ns.frames

local PADDING = defaults.padding


function frames.TargetOfTargetFrame(frame)
  local height = defaults.size.height
  local width  = defaults.size.width * 0.75

  elements.InitializeUnitFrame(frame, { width=width })

  -- Hide the power bar
  frame.Power:Hide()
  frame:SetHeight(math.floor(height + (PADDING * 2)))

  -- Reposition the health readout
  frame.HealthText:ClearAllPoints()
  frame.HealthText:SetPoint("TOPLEFT", frame.Health, "TOPLEFT", 2, 0)

  -- Name
  local name = elements.NewString(frame.Health, { size=22 })
  name:SetPoint("RIGHT", frame.Health, "RIGHT", -5, 0)
  frame:Tag(name, "[kFrames:name]")

  -- Niceties
  elements.AddHealPrediction(frame)
  elements.AddDebuffHighlight(frame)
  elements.AddHighlight(frame)

  -- Position
  frame:SetPoint("LEFT", UIParent, "BOTTOM", 155, 175)
  -- ns.generated.target
end
