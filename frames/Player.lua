
local _, addon = ...

local player = addon.util.player

local defaults = addon.defaults
local elements = addon.elements
local frames   = addon.frames
local media    = addon.media

local TEXTURE = media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]

local POWER_HEIGHT = defaults.power_height


function frames.PlayerFrame(frame)
  elements.InitializeUnitFrame(frame)

  -- Additional Power (eg. Druid mana while shapeshifted)
  local altfg, altbg = elements.NewStatusBar(frame, {
    height  = POWER_HEIGHT,
    width   = math.floor(defaults.frames.major.width * 0.5),
    fg      = TEXTURE,
    bg      = TEXTURE,
  })
  altfg:SetFrameLevel(50)
  altfg.colorPower = true
  altbg.multiplier = 0.5

  altfg.background = elements.NewBackground(altfg)
  altfg.background:SetPoint("TOPLEFT", altfg, "TOPLEFT", -1, 1)
  altfg.background:SetPoint("BOTTOMRIGHT", altfg, "BOTTOMRIGHT", 1, -1)
  altfg.background:SetColorTexture(0, 0, 0, 1)

  frame.AdditionalPower = altfg
  frame.AdditionalPower.bg = altbg
  frame.AdditionalPower:SetPoint("CENTER", frame.Health, "BOTTOM", 0, 0)

  -- Niceties
  frame.HealthPrediction = elements.HealPrediction(frame)
  frame.DispelHighlight  = elements.DispelHighlight(frame)
  elements.AddHighlight(frame)

  -- Castbar
  local castbar = elements.Castbar(frame)
  castbar:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 1, 5)
  frame.Castbar = castbar.bar

  -- Auras
  frame.AuraBars = elements.AuraBar(frame)
  frame.AuraBars:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, frame.Castbar:GetHeight() + 5)

  -- Class-specific resources
  local p1,a,p2,x,y = addon.util.parse_position("TOPLEFT 0 -7 BOTTOMLEFT")
  frame.ClassPower = elements.ClassPower(frame)
  frame.ClassPower:SetPoint(p1, frame, p2, x, y)

  if player.class == "death knight" then
    frame.Runes = elements.RuneBar(frame)
    frame.Runes:SetPoint(p1, frame, p2, x, y)
  elseif player.class == "monk" then
    local stagger = elements.StaggerBar(frame)
    stagger:SetPoint(p1, frame, p2, x, y)
    frame.Stagger = stagger.bar
  end
  
  -- We don't make a Totem display here because Blizzard changes them
  -- too much to make a display worth anything. Better to track the
  -- buffs/debuffs via auras.

  -- Icons
  elements.TextIcon(frame, "Combat",  {"BOTTOMLEFT 5 -6 BOTTOMLEFT", frame.Health}, 18, frame.Health)
  elements.TextIcon(frame, "Status",  {"BOTTOMLEFT 4 0 BOTTOMRIGHT", frame.kCombat}, 18, frame.Health)
  elements.TextIcon(frame, "AFKDND",  {"BOTTOMLEFT 4 0 BOTTOMRIGHT", frame.kStatus}, 18, frame.Health)
  elements.TextIcon(frame, "PvP",     {"BOTTOMLEFT 4 0 BOTTOMRIGHT", frame.kAFKDND}, 18, frame.Health)
  --elements.RaidMarkIcon(frame,        {"LEFT xxx RIGHT 5 0", name})

  -- Position frame cluster in the bottom left of the center screen
  local offset = 0 - defaults.frames.major.width - 5
  local height = defaults.frames.major.health_height
  frame:SetPoint("BOTTOM", "UIParent", "BOTTOM", offset, height)
end
