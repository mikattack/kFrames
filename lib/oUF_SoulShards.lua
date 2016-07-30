--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...
local oUF = ns.oUF or oUF
if not oUF then
  print("oUF_SoulShards: oUF required but not found")
  return
end

local playerClass = ns.util.playerClass
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
local STATUSBAR = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"


function Update(self, event, unit, powerType)
  if (self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS")) then return end

  local ss = self.SoulShards
  if ss.PreUpdate then
    ss:PreUpdate(unit)
  end

  local numShards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
  local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)

  for i = 1, maxShards do
    if i <= numShards then
      ss[i]:Show()
    else
      ss[i]:Hide()
    end
  end

  if ss.PostUpdate then
    return ss:PostUpdate(numShards)
  end
end


function Path(self, ...)
  return (self.SoulShards.Override or Update) (self, ...)
end


function ForceUpdate(element)
  return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end


function UpdateVisibility(self, event)
  local ss = self.SoulShards
  local hidden = UnitHasVehicleUI("player")

  if ss.hidden == hidden then return end
  ss.hidden = hidden

  if hidden then
    ss:Hide()
  else
    ss:Show()
  end
end


function Enable(self)
  local ss = self.SoulShards
  if ss and self.unit == "player" then
    ss.__owner = self
    ss.ForceUpdate = ForceUpdate

    self:RegisterEvent("UNIT_POWER_FREQUENT", Path, true)
    self:RegisterEvent("UNIT_DISPLAYPOWER", Path, true)

    self:RegisterEvent("UNIT_ENTERING_VEHICLE", UpdateVisibility)
    self:RegisterEvent("UNIT_EXITED_VEHICLE", UpdateVisibility)

    for index = 1, #ss do
      local element = ss[index]
      if(element:IsObjectType'Texture' and not element:GetTexture()) then
        element:SetTexture[[Interface\ComboFrame\ComboPoint]]
        element:SetTexCoord(0, 0.375, 0, 1)
      end
    end

    UpdateVisibility(self, nil, nil)
    return true
  end
end


function Disable(self)
  local ss = self.SoulShards
  if ss then
    self:UnregisterEvent("UNIT_POWER_FREQUENT", Path)
    self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)

    self:UnregisterEvent("UNIT_ENTERING_VEHICLE", UpdateVisibility)
    self:UnregisterEvent("UNIT_EXITED_VEHICLE", UpdateVisibility)

    for i = 1, #ss do
      ss[i].Hide()
    end
    if ss.Hide then
      ss.Hide()
    end

    UpdateVisibility(self, nil, nil)
  end
end


oUF:AddElement("SoulShards", Path, Enable, Disable)