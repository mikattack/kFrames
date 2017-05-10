
local _, ns = ...

local playerClass = ns.util.playerClass

local defaults   = ns.defaults
local elements = ns.elements
local frames   = ns.frames
local media    = ns.media

local LARGE_FONT = media.largeFont or STANDARD_TEXT_FONT

local FLATBAR = media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]

local PADDING = defaults.padding
local POWER_HEIGHT = 5


function frames.PlayerFrame(frame)
  elements.InitializeUnitFrame(frame)

  -- Additional Power (eg. Druid mana while shapeshifted)
  local altfg, altbg = elements.NewStatusBar(frame, {
    height  = POWER_HEIGHT,
    width   = math.floor(defaults.size.width * 0.5),
    fg      = FLATBAR,
    bg      = FLATBAR,
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
  elements.AddHealPrediction(frame)
  elements.AddDispelHighlight(frame)
  elements.AddHighlight(frame)

  -- Castbar
  elements.NewCastbar(frame)

  -- Class-specific additions
  local cbpos = {"BOTTOM xxx TOP 0 5", frame}
  local attach = frame
  if playerClass == "DEATHKNIGHT" then
    elements.RuneBar(frame, cbpos)
    attach = frame.Runes
  elseif playerClass == "SHAMAN" then
    elements.ComboPoints(frame, cbpos)
    attach = frame.klnComboPoints
  else
    elements.ClassPower(frame, cbpos)
    attach = frame.ClassPower
  end
  elements.repositionCastbar(frame, {"BOTTOMLEFT xxx TOPLEFT 0 5", attach})

  -- Icons
  elements.TextIcon(frame, "Combat",  {"BOTTOMLEFT xxx BOTTOMLEFT 5 -6", frame.Health}, 18, frame.Health)

  elements.TextIcon(frame, "Status",  {"BOTTOMLEFT xxx TOPLEFT 2 4", attach}, 18)
  elements.TextIcon(frame, "AFKDND",  {"BOTTOMLEFT xxx BOTTOMRIGHT 4 0", frame.kStatus}, 18)
  elements.TextIcon(frame, "PvP",     {"BOTTOMLEFT xxx BOTTOMRIGHT 4 0", frame.kAFKDND}, 18)

  --elements.RaidMarkIcon(frame,        {"LEFT xxx RIGHT 5 0", name})
  --elements.LFDRoleIcon(frame,         {"RIGHT xxx LEFT -5 0", frame.RaidIcon}, {20,20})
  --elements.ReadyCheckIcon(frame,      {"LEFT xxx RIGHT 5 0", frame.LFDRole}, {20,20})

  elements.RaidLeaderIcon(frame,      {"BOTTOMRIGHT xxx TOPRIGHT -2 4", attach})
  elements.RaidAssistIcon(frame,      {"RIGHT xxx LEFT -3 0", frame.kLeader})
  elements.RaidLootMasterIcon(frame,  {"RIGHT xxx LEFT -3 0", frame.kAssistant})

  -- Position frame(s)
  frame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 10)
end
