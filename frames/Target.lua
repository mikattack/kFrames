
local _, ns = ...

local playerClass = ns.util.playerClass
local defaults  = ns.defaults
local elements  = ns.elements
local frames    = ns.frames
local media     = ns.media

local LARGE_FONT = media.largeFont or STANDARD_TEXT_FONT

local FLATBAR = media.flatBar or [[Interface\TargetingFrame\UI-StatusBar]]

local POWER_HEIGHT = 4


function frames.TargetFrame(frame)
  local height = defaults.size.height
  local width = defaults.size.width

  elements.InitializeUnitFrame(frame)

  -- Name
  local name = elements.NewString(frame, { font=LARGE_FONT, size=22 })
  name:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -2)
  frame:Tag(name, "|cFFFFF200[level]|r [kFrames:name]")

  -- Reposition the health readout
  frame.HealthText:ClearAllPoints()
  frame.HealthText:SetPoint("TOPLEFT", frame.Health, "TOPLEFT", 2, 0)
  
  -- Icons
  --elements.TextIcon(frame, "Combat",  {"LEFT xxx LEFT 40 14", frame.Health}, 18, frame.Health)
  --elements.TextIcon(frame, "Status",  {"LEFT xxx RIGHT 4 0 ", frame.kCombat}, 18, frame.Health)
  elements.TextIcon(frame, "AFKDND",  {"BOTTOMLEFT xxx BOTTOMLEFT 55 -6", frame.Health}, 18, frame.Health)
  elements.TextIcon(frame, "PvP",     {"LEFT xxx RIGHT 4 0", frame.kAFKDND}, 18, frame.Health)

  elements.RaidMarkIcon(frame,        {"RIGHT xxx LEFT 5 0", name})

  elements.LFDRoleIcon(frame,         {"RIGHT xxx LEFT 5 0", frame.RaidIcon}, {20,20})
  elements.ReadyCheckIcon(frame,      {"RIGHT xxx LEFT 5 0", frame.LFDRole}, {20, 20})
  --[[
  elements.RaidLeaderIcon(frame,      {"LEFT xxx TOPLEFT 4 0", frame.Infobar})
  elements.RaidAssistIcon(frame,      {"LEFT xxx RIGHT 4 0", frame.Infobar})
  elements.RaidLootMasterIcon(frame,  {"LEFT xxx RIGHT 5 0", frame.Assistant})
  --]]

  -- Niceties
  elements.AddHealPrediction(frame)
  elements.AddDispelHighlight(frame)
  elements.AddHighlight(frame)

  -- Castbar
  elements.NewCastbar(frame, { width=width, height=height })
  elements.repositionCastbar(frame, {"BOTTOMLEFT xxx TOPLEFT 0 5", frame})

  -- Auras
  frame.AuraBars = elements.AuraBar(frame)
  frame.AuraBars:SetPoint("BOTTOM", frame, "TOP", 0, frame.Castbar:GetHeight() + 5)

  -- Position frame(s)
  --frame:SetPoint("RIGHT", UIParent, "BOTTOM", -155, 175)
  local offset = defaults.size.width + 5
  frame:SetPoint("BOTTOM", "UIParent", "BOTTOM", offset, defaults.size.height)
end
