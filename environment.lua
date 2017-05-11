--[[-------------------------------------------------------------------------
Environment - Initialize addon-wide containers.
---------------------------------------------------------------------------]]

local _, ns = ...

ns.defaults = {}  -- Configuration fallbacks
ns.elements = {}  -- Element factory functions
ns.frames   = {}  -- Specific frame factories
ns.media    = {}  -- Media path constants
ns.tags     = {}  -- Custom oUF tags
ns.util     = {}  -- Function grab bag
