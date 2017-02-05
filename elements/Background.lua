--[[--------------------------------------------------------------------
  oUF_Kellen
  Kellen's PVE-oriented layout for oUF.
  Copyright (c) 2015-2016
    Kellen <addons@mikitik.com>
    All rights reserved.
  https://github.com/mikattack/kFrames
----------------------------------------------------------------------]]


local _, ns = ...

local elements = ns.elements
local media = ns.media

local DEFAULT_COLOR = {0, 0, 0, 1}
local DEFAULT_SIZE  = 50


-- 
-- Creates a black background texture for a given frame.
-- 
-- @param frame     Frame to create string for.
-- @param opts      Optional parameters (each has a default):
--                    width   [int]
--                    height  [int]
--                    color   [array] R, G, B, A.
-- @return Texture
-- 
function elements.NewBackground(frame, opts)
  local opts   = opts or {}
  local height = opts.height or DEFAULT_SIZE
  local width  = opts.width or DEFAULT_SIZE
  local color  = opts.color or DEFAULT_COLOR

  local bg = frame:CreateTexture(nil, "BACKGROUND")
  bg:SetHeight(height)
  bg:SetWidth(width)
  bg:SetColorTexture(unpack(color))
  return bg
end
