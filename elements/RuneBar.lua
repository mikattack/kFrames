
local _, addon = ...

local player    = addon.util.player
local TEXTURE   = addon.media.texture.status or "Interface\\TargetingFrame\\UI-StatusBar"
local MAX_RUNES = 6
local PADDING   = 1
local HEIGHT    = 18
local r, g, b   = 106/255, 184/255, 247/255


function addon.elements.RuneBar(frame)
  if player.class ~= "death knight" then return end

  local defaultWidth = addon.defaults.frames.major.width * 0.80
  local frameWidth = defaultWidth + (PADDING * 2)
  local runeWidth  = (frameWidth - PADDING * (MAX_RUNES + 1)) / MAX_RUNES
  local runeHeight = HEIGHT

  local runes = CreateFrame("Frame", nil, frame)
  runes:SetHeight(runeHeight)
  runes:SetWidth(frameWidth)

  runes.background = runes:CreateTexture(nil, "BACKGROUND")
  runes.background:SetAllPoints(runes)
  runes.background:SetColorTexture(0, 0, 0, 0.5)

  for i = 1, MAX_RUNES do
    local rune = CreateFrame("StatusBar", nil, frame)
    rune:SetWidth(runeWidth)
    rune:SetHeight(runeHeight - PADDING * 2)
    rune:SetStatusBarTexture(TEXTURE)

    rune.bg = rune:CreateTexture(nil, "BACKGROUND")
    rune.bg:SetAllPoints(rune)
    rune.bg:SetTexture(TEXTURE)

    if (i == 1) then
      rune:SetPoint('LEFT', runes, 'LEFT', PADDING, 0)
    else
      rune:SetPoint('TOPLEFT', runes[i-1], 'TOPRIGHT', PADDING, 0)
    end

    runes[i] = rune
  end
  
  runes.colorSpec = true
  runes.multiplier = 0.3
  frame.Runes = runes
end
