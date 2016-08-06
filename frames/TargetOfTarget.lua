--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...

local config    = ns.config
local elements  = ns.elements
local frames    = ns.frames


function frames.TargetOfTargetFrame(frame)
  frames.MinorFrame(frame)

  -- Hide the power bar
  frame.Power:Hide()

  -- Resize the frame
  frame:SetHeight(math.floor(config.size.primaryCluster.height * 0.65) + 2)
  frame:SetWidth(config.size.primaryCluster.width + 2)

  frame.Health:ClearAllPoints()
  frame.Health:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
  frame.Health:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)

  -- Reposition the health and name
  frame.HealthReadout:ClearAllPoints()
  frame.HealthReadout:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 4)

  frame.Name:ClearAllPoints()
  frame.Name:SetPoint("LEFT", frame, "TOPLEFT", 4, -2)

  -- Niceties
  elements.HealPrediction(frame)
  elements.DebuffHighlight(frame)
  elements.Highlight(frame)

  -- Position
  frame:SetPoint("BOTTOM", ns.generated.target, "TOP", 0, 45)
end
