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
  print("oUF_ComboPoints: oUF required but not found")
  return
end

local playerClass = ns.util.playerClass
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
local STATUSBAR = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"


function Update(self, event, unit, powerType)
  if (self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS")) then return end

  local ss = self.SoulShards
  if ss.PreUpdate then ss:PreUpdate(unit) end

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


function Visibility(self, event)
  local ss = self.SoulShards

  if UnitHasVehicleUI("player") then
    self:UnregisterEvent("UNIT_POWER", Path)
    self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)

    for i = 1, #ss do
      ss[i]:Hide()
    end
    if ss.Hide then
      ss:Hide()
    end

    return
  end

  self:RegisterEvent("UNIT_POWER", Path)
  self:RegisterEvent("UNIT_DISPLAYPOWER", Path)

  Update(self, "Visibility", "player")
end


function Enable(self)
  local ss = self.SoulShards
  if ss and self.unit == "player" then
    ss.__owner = self
    ss.ForceUpdate = ForceUpdate

    self:RegisterEvent("UNIT_ENTERING_VEHICLE", Visibility)
    self:RegisterEvent("UNIT_EXITED_VEHICLE", Visibility)

    for index = 1, #ss do
      local element = ss[index]
      if(element:IsObjectType'Texture' and not element:GetTexture()) then
        element:SetTexture[[Interface\ComboFrame\ComboPoint]]
        element:SetTexCoord(0, 0.375, 0, 1)
      end
    end

    Visibility(self, "Enable")
    return true
  end
end


function Disable(self)
  local ss = self.SoulShards
  if ss then
    self:UnregisterEvent("UNIT_POWER", Path)
    self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)

    self:UnregisterEvent("UNIT_ENTERING_VEHICLE", Visibility)
    self:UnregisterEvent("UNIT_EXITED_VEHICLE", Visibility)

    for i = 1, #ss do
      ss[i].Hide()
    end
    if ss.Hide then
      ss.Hide()
    end
  end
end


oUF:AddElement("SoulShards", Path, Enable, Disable)