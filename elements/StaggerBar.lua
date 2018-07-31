
local _, addon = ...

local player    = addon.util.playerClass
local STATUSBAR = addon.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING   = 1
local HEIGHT    = 18

-- sourced from FrameXML/Constants.lua
local SPEC_MONK_BREWMASTER = SPEC_MONK_BREWMASTER or 1


local function UpdateStaggerBarFrame(frame, event)
  if SPEC_MONK_BREWMASTER == GetSpecialization() then
    frame.StaggerFrame:SetHeight(HEIGHT + (PADDING * 2))
    frame.StaggerFrame:SetAlpha(1)
  else
    frame.StaggerFrame:SetHeight(1)
    frame.StaggerFrame:SetAlpha(0)
  end
end


function addon.elements.StaggerBar(frame)
  if player.class ~= "monk" then return end

  local width = addon.defaults.size.width

  -- Background frame
  local stagger = CreateFrame("Frame", nil, frame)
  stagger:SetHeight(HEIGHT + (PADDING * 2))
  stagger:SetWidth(width + (PADDING * 2))

  stagger.background = stagger:CreateTexture(nil, "BACKGROUND")
  stagger.background:SetAllPoints(stagger)
  stagger.background:SetColorTexture(0, 0, 0, 0.5)

  -- Stagger bar itself
  local bar = CreateFrame("StatusBar", nil, frame)
  bar:SetWidth(width)
  bar:SetHeight(HEIGHT)
  bar:SetStatusBarTexture(STATUSBAR)

  bar.bg = bar:CreateTexture(nil, "BACKGROUND")
  bar.bg:SetAllPoints(bar)
  bar.bg:SetTexture(STATUSBAR)

  bar.multiplier = 0.3
  bar:SetPoint("BOTTOMLEFT", stagger, "BOTTOMLEFT", 1, 1)

  -- Register stagger background frame visibility toggle
  frame:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateStaggerBarFrame)
  frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', UpdateStaggerBarFrame, true)
  --frame:RegisterEvent('UPDATE_VEHICLE_ACTION_BAR', UpdateStaggerBarFrame)

  stagger.bar = bar
  return stagger
end
