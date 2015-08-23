--[[-------------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015 Kellen <addons@mikitik.net>. All rights reserved.
  https://github.com/mikattack/oUF_Kellen
---------------------------------------------------------------------------]]

local _, ns = ...

local media = ns.media
local elements = ns.elements

local FONT = media.smallFont or STANDARD_TEXT_FONT
local ICON_HEIGHT = 40
local FRAME_WIDTH = ns.config.width


function ns.elements.AuraFrames(frame, position)
  if frame.unit == "player" then
    local GAP = 0

    frame.Buffs = CreateFrame("Frame", nil, frame)
    frame.Buffs:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 2)
    frame.Buffs:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 2)
    frame.Buffs:SetHeight(ICON_HEIGHT)

    frame.Buffs["growth-x"] = "LEFT"
    frame.Buffs["growth-y"] = "UP"
    frame.Buffs["initialAnchor"] = "BOTTOMRIGHT"
    frame.Buffs["num"] = math.floor(((FRAME_WIDTH / 2) + GAP) / (ICON_HEIGHT + GAP))
    frame.Buffs["size"] = ICON_HEIGHT
    frame.Buffs["spacing-x"] = GAP
    frame.Buffs["spacing-y"] = GAP
    frame.Buffs["showType"] = true

    frame.Buffs.CustomFilter   = elements.Auras.CustomFilters.player
    frame.Buffs.PostCreateIcon = elements.Auras.PostCreateIcon
    frame.Buffs.PostUpdateIcon = elements.Auras.PostUpdateIcon
    frame.Buffs.PostUpdate     = elements.Auras.PostUpdate -- required to detect Dead => Ghost
  elseif frame.unit == "target" then
    local GAP = 0

    local MAX_ICONS = floor((FRAME_WIDTH + GAP) / (ICON_HEIGHT + GAP))
    local NUM_BUFFS = 2
    local NUM_DEBUFFS = MAX_ICONS - 2
    local ROW_HEIGHT = (ICON_HEIGHT * 2) + (GAP * 2)

    frame.Debuffs = CreateFrame("Frame", nil, frame)
    frame.Debuffs:SetHeight(ICON_HEIGHT * 2)
    frame.Debuffs.parent = frame

    frame.Debuffs["growth-y"] = "UP"
    frame.Debuffs["showType"] = true
    frame.Debuffs["size"] = ICON_HEIGHT
    frame.Debuffs["spacing-x"] = GAP
    frame.Debuffs["spacing-y"] = GAP * 2
    frame.Debuffs["showType"] = true

    frame.Debuffs.CustomFilter   = elements.Auras.CustomFilters.target
    frame.Debuffs.PostCreateIcon = elements.Auras.PostCreateIcon
    frame.Debuffs.PostUpdateIcon = elements.Auras.PostUpdateIcon
    frame.Debuffs.PostUpdate     = elements.Auras.PostUpdate -- required to detect Dead => Ghost

    frame.Buffs = CreateFrame("Frame", nil, frame)
    frame.Buffs:SetHeight(ICON_HEIGHT * 2)
    frame.Buffs.parent = frame

    frame.Buffs["growth-y"] = "UP"
    frame.Buffs["showType"] = false
    frame.Buffs["size"] = ICON_HEIGHT
    frame.Buffs["spacing-x"] = GAP
    frame.Buffs["spacing-y"] = GAP * 2
    frame.Buffs["showType"] = true

    frame.Buffs.CustomFilter   = elements.Auras.CustomFilters.target
    frame.Buffs.PostCreateIcon = elements.Auras.PostCreateIcon
    frame.Buffs.PostUpdateIcon = elements.Auras.PostUpdateIcon

    local function UpdateAurasForRole(frame, role, initial)
      --print("Updating auras for new role:", role)

      local a, b
      if role == "HEALER" then
        a, b = frame.Buffs, frame.Debuffs
      else
        a, b = frame.Debuffs, frame.Buffs
      end

      a:ClearAllPoints()
      a:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 1, 2)
      a:SetWidth((ICON_HEIGHT * NUM_DEBUFFS) + (GAP * (NUM_DEBUFFS - 1)))
      a["growth-x"] = "RIGHT"
      a["initialAnchor"] = "BOTTOMLEFT"
      a["num"] = NUM_DEBUFFS

      b:ClearAllPoints()
      b:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -1, 2)
      b:SetWidth((ICON_HEIGHT * NUM_BUFFS) + (GAP * (NUM_BUFFS - 1)))
      b["growth-x"] = "LEFT"
      b["initialAnchor"] = "BOTTOMRIGHT"
      b["num"] = NUM_BUFFS

      if not initial then
        a:ForceUpdate()
        b:ForceUpdate()
      end
    end

    frame:RegisterForRoleChange(UpdateAurasForRole)
    UpdateAurasForRole(frame, ns.GetPlayerRole(), true) -- default is DAMAGER
  end
end
