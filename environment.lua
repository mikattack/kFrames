-----------------------------------------------------------------------------
-- Environment - Initialize addon-wide containers.
-----------------------------------------------------------------------------

local _, addon = ...

addon.defaults = {}  -- Configuration defaults
addon.elements = {}  -- Element factory functions
addon.frames   = {}  -- Specific unit frame factories
addon.media    = {}  -- Embedded media
addon.tags     = {}  -- Custom oUF tags
addon.util     = {}  -- Function grab bag
