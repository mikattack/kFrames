--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


--[[--------------------------------------------------------------------
  This is actually just a custom version of oUF's combopoint library that
  adds visibility options for Druids (to hide combo points of cat form).
----------------------------------------------------------------------]]


local _, ns = ...
local oUF = ns.oUF or oUF
if not oUF then
  print("oUF_ComboPoints: oUF required but not found")
  return
end

local playerClass = ns.util.playerClass
local GetComboPoints = GetComboPoints
local MAX_COMBO_POINTS = MAX_COMBO_POINTS


local function Update(self, event, unit)
  if (unit == 'pet') then return end

  local cpoints = self.klnComboPoints
  if (cpoints.PreUpdate) then
    cpoints:PreUpdate()
  end

  local cp
  if (UnitHasVehicleUI'player') then
    cp = GetComboPoints('vehicle', 'target')
  else
    cp = GetComboPoints('player', 'target')
  end

  for i=1, MAX_COMBO_POINTS do
    if(i <= cp) then
      cpoints[i]:Show()
    else
      cpoints[i]:Hide()
    end
  end

  if (cpoints.PostUpdate) then
    return cpoints:PostUpdate(cp)
  end
end


local function Path(self, ...)
  return (self.klnComboPoints.Override or Update) (self, ...)
end


local function ForceUpdate(element)
  return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end


local function UpdateVisibility(self, event, unit)
  local element = self.klnComboPoints
  local form = GetShapeshiftFormID()
  local hidden = UnitHasVehicleUI("player")

  if playerClass == "DRUID" and form ~= 1 then
    hidden = hidden and true
  end
  
  if element.hidden == hidden then return end
  element.hidden = hidden

  if hidden then
    element:Hide()
  else
    element:Show()
  end
end


local function Enable(self)
  local cpoints = self.klnComboPoints
  if (cpoints) then
    cpoints.__owner = self
    cpoints.ForceUpdate = ForceUpdate

    self:RegisterEvent('UNIT_POWER_FREQUENT', Path, true)
    self:RegisterEvent('PLAYER_TARGET_CHANGED', Path, true)

    if playerClass == "DRUID" then
      self:RegisterEvent("PLAYER_TALENT_UPDATE", UpdateVisibility, true)
      self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", UpdateVisibility, true)
      self:RegisterEvent("UNIT_ENTERING_VEHICLE", UpdateVisibility)
      self:RegisterEvent("UNIT_EXITED_VEHICLE", UpdateVisibility)
    end

    for index = 1, MAX_COMBO_POINTS do
      local cpoint = cpoints[index]
      if(cpoint:IsObjectType'Texture' and not cpoint:GetTexture()) then
        cpoint:SetTexture[[Interface\ComboFrame\ComboPoint]]
        cpoint:SetTexCoord(0, 0.375, 0, 1)
      end
    end

    UpdateVisibility(self, nil, nil)
    return true
  end
end


local function Disable(self)
  local cpoints = self.klnComboPoints
  if(cpoints) then
    for index = 1, MAX_COMBO_POINTS do
      cpoints[index]:Hide()
    end
    self:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
    self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)

    if playerClass == "DRUID" then
      self:UnregisterEvent("PLAYER_TALENT_UPDATE", UpdateVisibility)
      self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM", UpdateVisibility)
      self:UnregisterEvent("UNIT_ENTERING_VEHICLE", UpdateVisibility)
      self:UnregisterEvent("UNIT_EXITED_VEHICLE", UpdateVisibility)
    end

    UpdateVisibility(self, nil, nil)
  end
end


oUF:AddElement('klnComboPoints', Path, Enable, Disable)
