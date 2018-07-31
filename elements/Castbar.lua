
local _, addon = ...

local defaults = addon.defaults
local elements = addon.elements
local media    = addon.media

local parse_position = addon.util.parse_position

local FONT      = media.smallFont or STANDARD_TEXT_FONT
local TEXTURE   = media.statusBar or "Interface\\TargetingFrame\\UI-StatusBar"


elements.Castbar = {}
elements.Castbar.__index = Castbar


function elements.Castbar:Create(frame, opts)
  local opts = opts or {}
  local height = opts.height or defaults.size.height
  local width  = opts.width or defaults.size.width
  local ICONSIZE = height

  local castbar, cbg = elements.NewStatusBar(frame, {
    height = height,
    width  = width - ICONSIZE - 1,
  })
  castbar:SetStatusBarColor(0.5, 0.5, 1, 1)

  -- Make "Castbar" handle function lookups
  setmetatable(castbar, Castbar)

  cbg:SetDrawLayer("BORDER")
  cbg:SetVertexColor(0.5 * 0.2, 1 * 0.2, 1 * 0.2, 1)

  -- Black Frame Background
  castbar.backdrop = elements.NewBackground(castbar, {
    height = height + 2,
    width  = width + 2,
  })
  castbar.backdrop:SetDrawLayer("BACKGROUND")
  castbar.backdrop:SetPoint("RIGHT", castbar, "RIGHT", 1, 0)

  -- Color
  castbar.CastingColor    = { 0.5,  0.5,  1 }
  castbar.CompleteColor   = { 0.5,  1,    0 }
  castbar.FailColor       = { 1.0,  0.5,  0 }
  castbar.ChannelingColor = { 0.5,  0.5,  1 }

  -- Spark
  local spark = castbar:CreateTexture(nil, "OVERLAY")
  spark:SetSize(10, ICONSIZE * 1.5)
  spark:SetBlendMode("ADD")

  -- Timer
  local timer = castbar:CreateFontString(nil, "OVERLAY")
  timer:SetFont(FONT, 14, "THINOUTLINE")
  timer:SetPoint("RIGHT", castbar, -5, 0)

  -- Spell/Ability Name
  local text = castbar:CreateFontString(nil, "OVERLAY")
  text:SetFont(FONT, 14, "THINOUTLINE")
  text:SetPoint("LEFT", castbar, 5, -1)

  -- Icon
  local icon = castbar:CreateTexture(nil, "OVERLAY")
  icon:SetSize(ICONSIZE, ICONSIZE)
  icon:SetPoint("RIGHT", castbar, "LEFT", -1, 0)
  icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

  -- Shield
  local shield = castbar:CreateTexture(nil, "OVERLAY")
  shield:SetSize(20, 20)
  shield:SetPoint("TOPRIGHT", castbar, -10, -10)

  -- Safezone
  local safezone = castbar:CreateTexture(nil, "OVERLAY")
  safezone:SetTexture(TEXTURE)
  safezone:SetVertexColor(1, 0, 0, 0.7)

  -- Options/registration
  castbar.bg = cbg
  castbar.Spark = spark
  castbar.Time = timer
  castbar.Text = text
  castbar.Icon = icon
  if frame.unit == "player" then
    castbar.SafeZone = safezone
  else
    castbar.Shield = shield
  end

  -- Events
  castbar.PostCastStart       = PostCastStart
  castbar.PostChannelStart    = PostCastStart
  castbar.PostCastStop        = PostCastStop
  castbar.PostChannelStop     = PostChannelStop
  castbar.PostCastFailed      = PostCastFailed
  castbar.PostCastInterrupted = PostCastFailed

  return castbar
end


function elements.Castbar:Reposition(frame, position)
  local ICONSIZE = self.Icon:GetHeight()
  local p1, p2, x, y = parse_position(position)

  -- Determine whether to account for icon size during positioning.
  -- If positioning from the castbar's RIGHT, we only need to account
  -- for the frame padding.
  if p1:find("RIGHT") ~= nil then
    frame.Castbar:SetPoint(p1, frame, p2, x - 1, y)
  else
    frame.Castbar:SetPoint(p1, frame, p2, x + ICONSIZE + 2, y)
  end
end


local function PostCastStart(self, unit, name, rank, text)
  local pcolor = {1, .5, .5}
  local interruptcb = {.5, .5, 1}
  self:SetAlpha(1.0)
  self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
  if unit == "player" then
    local sf = self.SafeZone
    if sf and sf.sendTime ~= nil then
      sf.timeDiff = GetTime() - sf.sendTime
      sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
      sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
      sf:Show()
    end
  elseif (unit == "target" or unit == "focus") and not self.interrupt then
    self:SetStatusBarColor(interruptcb[1],interruptcb[2],interruptcb[3],1)
  else
    self:SetStatusBarColor(pcolor[1], pcolor[2], pcolor[3],1)
  end
end


local function PostCastStop(self, unit, name, rank, castid)
  if not self.fadeOut then 
    self:SetStatusBarColor(unpack(self.CompleteColor))
    self.fadeOut = true
  end
  self:SetValue(self.max)
  self:Show()
end


local function PostChannelStop(self, unit, name, rank)
  self.fadeOut = true
  self:SetValue(0)
  self:Show()
end


local function PostCastFailed(self, event, unit, name, rank, castid)
  self:SetStatusBarColor(unpack(self.FailColor))
  self:SetValue(self.max)
  if not self.fadeOut then
    self.fadeOut = true
  end
  self:Show()
end
