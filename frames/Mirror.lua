
local _, addon = ...

local defaults = addon.defaults
local elements = addon.elements
local media    = addon.media

local FONT     = media.font.small or STANDARD_TEXT_FONT
local TEXTURE  = media.texture.status or [[Interface\TargetingFrame\UI-StatusBar]]


--
-- Mirror Frames
--
-- The mirror frames are already in the global set of frames.  We simply want
-- to style them accordingly.
--
function elements.DecorateMirrorFrame(frame)
  for _, region in pairs({ frame:GetRegions() }) do
    if region.GetTexture and region:GetTexture() == "SolidTexture" then
      region:Hide()
    end
  end

  local height = defaults.frames.minor.health_height +
                 defaults.power_height

  frame:SetParent(UIParent)
  frame:SetWidth(defaults.frames.minor.width)
  frame:SetHeight(height)

  frame.bar = frame:GetChildren()
  frame.bg, frame.text, frame.border = frame:GetRegions()

  frame.bar:SetAllPoints(frame)
  frame.bar:SetStatusBarTexture(TEXTURE)

  frame.bg:ClearAllPoints()
  frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
  frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
  frame.bg:SetTexture(TEXTURE)
  frame.bg:SetVertexColor(0.2, 0.2, 0.2, 1)

  frame.text:ClearAllPoints()
  frame.text:SetPoint("LEFT", frame, 4, 0)
  frame.text:SetFont(FONT, 16, "OUTLINE")

  frame.border:Hide()
end
