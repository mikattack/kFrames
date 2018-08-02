
local _, addon = ...

local player    = addon.util.player
local TEXTURE   = addon.media.texture.status or "Interface\\TargetingFrame\\UI-StatusBar"
local MAX_RUNES = 6
local PADDING   = 1
local HEIGHT    = 18


function addon.elements.RuneBar(frame)
  if player.class ~= "death knight" then return end

  local defaultWidth = addon.defaults.frames.major.width * 0.8
  local frameWidth = defaultWidth + (PADDING * 2)
  local runeWidth  = (frameWidth - PADDING * (MAX_RUNES + 1)) / MAX_RUNES
  local runeHeight = HEIGHT

  local runes = CreateFrame("Frame", nil, frame)
  runes:SetHeight(runeHeight)
  runes:SetWidth(frameWidth)

  runes.background = runes:CreateTexture(nil, "BACKGROUND", nil, 1)
  runes.background:SetAllPoints(runes)
  runes.background:SetColorTexture(0, 0, 0, 1)

  local multiplier = 0.4
  for i = 1, MAX_RUNES do
    local rune = CreateFrame("StatusBar", nil, frame)
    rune:SetWidth(runeWidth)
    rune:SetHeight(runeHeight - PADDING * 2)
    rune:SetStatusBarTexture(TEXTURE)
    if (i == 1) then
      rune:SetPoint('LEFT', runes, 'LEFT', PADDING, 0)
    else
      rune:SetPoint('LEFT', runes[i-1], 'RIGHT', PADDING, 0)
    end

    rune.bg = rune:CreateTexture(nil, "BACKGROUND", nil, 4)
    rune.bg:SetAllPoints()
    rune.bg:SetTexture(TEXTURE)
    rune.bg.multiplier = multiplier

    runes[i] = rune
  end
  
  runes.colorSpec = true
  return runes
end
