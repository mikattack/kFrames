
local _, addon = ...

local player  = addon.util.player
local TEXTURE = addon.media.texture.status or "Interface\\TargetingFrame\\UI-StatusBar"
local PADDING = 1
local HEIGHT  = 18

-- sourced from FrameXML/Constants.lua
local SPEC_MONK_BREWMASTER = SPEC_MONK_BREWMASTER or 1


local function UpdateStaggerBarFrame(frame, event)
  if SPEC_MONK_BREWMASTER == GetSpecialization() then
    frame.Stagger:GetParent():Show()
    frame.Stagger:Show()
  else
    frame.Stagger:Hide()
    frame.Stagger:GetParent():Hide()
  end
end


function addon.elements.StaggerBar(frame)
  if player.class ~= "monk" then return end

  local width = addon.defaults.frames.major.width * 0.80

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
  bar:SetStatusBarTexture(TEXTURE)

  bar.bg = bar:CreateTexture(nil, "BACKGROUND")
  bar.bg:SetAllPoints(bar)
  bar.bg:SetTexture(TEXTURE)

  bar.multiplier = 0.3
  bar:SetPoint("BOTTOMLEFT", stagger, "BOTTOMLEFT", 1, 1)

  bar:SetParent(stagger)

  -- Register stagger background frame visibility toggle
  frame:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateStaggerBarFrame)
  frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', UpdateStaggerBarFrame, true)
  
  stagger.bar = bar
  return stagger
end
