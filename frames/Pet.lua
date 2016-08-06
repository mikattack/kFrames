--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...

local elements  = ns.elements
local frames    = ns.frames


function frames.PetFrame(frame)
  frames.MinorFrame(frame)

  -- Niceties
  elements.HealPrediction(frame)
  elements.DebuffHighlight(frame)
  elements.Highlight(frame)

  -- Position
  frame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 5, -55)
end
