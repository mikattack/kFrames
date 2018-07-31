
local _, addon = ...

local elements = addon.elements
local media = addon.media

local DEFAULT_FONT_FAMILY   = media.largeFont
local DEFAULT_FONT_SIZE     = 18
local DEFAULT_OUTLINE_STYLE = "OUTLINE"


-- 
-- Creates a string for a given frame.
-- 
-- @param frame     Frame to create string for.
-- @param font      Path of the font file.
-- @param size      Font size.
-- @param outline   [optional] Outline style (default: OUTLINE).
-- @param opts      Layout, sizing, and positioning options. Each is optional
--                  as default are defined for all parameters:
--                    font    [string] Path of a font file.
--                    size    [int] Font size.
--                    outline [string] Outline style identifier.
-- @return FontString
-- 
function elements.NewString(frame, opts)
  local opts = opts or {}
  local font = opts.font or DEFAULT_FONT_FAMILY
  local size = opts.size or DEFAULT_FONT_SIZE
  local outline = opts.outline or DEFAULT_OUTLINE_STYLE

  local fs = frame:CreateFontString(nil, "OVERLAY")
  fs:SetFont(font, size, outline)
  fs:SetShadowColor(0, 0, 0, 0.8)
  fs:SetShadowOffset(1, -1)
  return fs
end
