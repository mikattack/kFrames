--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]

local _, ns = ...

local playerClass = ns.util.playerClass
local STATUSBAR = ns.media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"


function ns.elements.SoulShards(frame, position)
  local MAX_SHARDS = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)

  local frameWidth  = ns.config.classbarWidth
  local pointWidth  = (frameWidth - 6 * 4) / MAX_SHARDS
  local pointHeight = 18
  local p1, parent, p2, x, y = ns.util.parsePosition(position)

  local ss = CreateFrame("Frame", "shards", frame)
  ss:SetPoint(p1, parent, p2, x, y)
  ss:SetHeight(pointHeight)
  ss:SetWidth(frameWidth)
  ss.hidden = false

  ss.background = ss:CreateTexture(nil, "BACKGROUND")
  ss.background:SetAllPoints(ss)
  ss.background:SetColorTexture(0, 0, 0, 0.5)

  local multiplier = 0.3
  local r, g, b = 209/255, 51/255, 188/255
  for i = 1, MAX_SHARDS do
    local shard = ss:CreateTexture(nil, "BORDER")
    shard:SetWidth(pointWidth)
    shard:SetHeight(pointHeight - 8) -- 2 * 4px borders
    shard:SetTexture(STATUSBAR)
    shard:SetVertexColor(r, g, b)

    shard.bg = ss:CreateTexture(nil, "BACKGROUND")
    shard.bg:SetAllPoints(shard)
    shard.bg:SetTexture(STATUSBAR)
    shard.bg:SetVertexColor(r * multiplier, g * multiplier, b * multiplier)

    if (i == 1) then
      shard:SetPoint('LEFT', ss, 'LEFT', 4, 0)
    else
      shard:SetPoint('TOPLEFT', ss[i-1], 'TOPRIGHT', 4, 0)
    end

    ss[i] = shard
  end
  
  frame.SoulShards = ss
end
