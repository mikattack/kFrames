-----------------------------------------------------------------------------
-- Auras - Default buff/debuff sets used for filtering.
-----------------------------------------------------------------------------

local _, addon = ...
addon.auras = {}


-----------------------------------------------------------
-- Raid-related debuffs. These appear on players.
----------------------------------------------------------- 

addon.auras.raid = {
  "Grievous Wound",

  -- Emerald Nightmare ------------------------------------

  -- Nythendra
  "Infested Ground",
  "Volatile Rot",
  "Rot",
  "Burst of Corruption",
  "Infested Breath",
  
  -- Illgynoth
  "Spew Corruption",
  "Eye of Fate",
  "Cursed Blood",
  "Death Blossom",
  "Dispersed Spores",
  "Touch of Corruption",
  
  -- Renferal
  "Web of Pain",
  "Necrotic Venom",
  "Dripping Fangs",
  "Raking Talons",
  "Twisting Shadows",
  "Web of Pain",
  "Tangled Webs",
  
  -- Ursoc
  "Focused Gaze",
  "Overwhelm",
  "Rend Flesh",
  
  -- Dragons
  "Nightmare Bloom",
  "Slumbering Nightmare",
  "Defiled Vines",
  "Sleeping Fog",
  "Shadow Burst",
  
  -- Cenarius
  "Nightmare Javelin",
  "Scorned Touch",
  "Spear of Nightmares",
  "Nightmare Brambles",
  
  -- Xavius
  "Dream Simulacrum",
  "Blackening Soul", 
  "Darkening Soul",  
  "Tainted Discharge", 
  'Corruption: Decent into Madness', 
  "Bonds of Terror", 
  "Tormenting Fixation", 
  
  -- Trash
  "Befoulment",
  
  -- Trial of Valor ---------------------------------------

  -- Odyn
  "Shield of Light",
  "Arcing Storm",
  "Expel Light",
  
  -- Guarm
  "Frost Lick",
  "Flame Lick",
  "Shadow Lick",
  
  "Flaming Volatile Foam",
  "Briney Volatile Foam",
  "Shadowy Volatile Foam",
  
  -- Helya
  "Orb of Corruption",
  "Orb of Corrosion",
  "Taint of the Sea",
  "Fetid Rot",
  "Corrupted Axiom",
  
  -- Trash
  "Unholy Reckoning",
  
  -- Nighthold --------------------------------------------

  -- Skorpyron
  "Energy Surge",
  "Broken Shard",
  "Focused Blast",
  
  -- Chromatic Anomaly
  "Time Bomb",
  "Temporal Charge",
  "Time Release",
  
  -- Trilliax
  "Arcing Bonds",
  "Sterilize",
  "Annihilation",
  
  -- Aluriel
  "Frostbitten",
  "Annihilated",
  "Searing Brand",
  "Entombed in Ice",
  "Mark of Frost",
  
  -- Tichondrius
  "Carrion Plague",
  "Feast of Blood",
  "Essence of Night",
  
  -- Krosus
  "Orb of Destruction",
  "Searing Brand",
  
  -- Botanist
  "Parasitic Fixate",
  "Parasitic Fetter",
  "Toxic Spores",
  "Call of Night",
  
  -- Augor
  "Icy Ejection",
  "Chilled",
  "Voidburst",
  "Gravitational Pull",
  "Witness the Void",
  "Absolute Zero",
  "Felflame",
  
  -- Elisande
  "Ablation",
  "Arcanetic Ring",
  "Spanning Singularity",
  "Delphuric Beam",
  "Permeliative Torment",
  
  -- Gul'dan
  "Drain",
  "Fel Efflux",
  "Soul Sever",
  "Chaos Seed",
  "Bonds of Fel",
  "Soul Siphon",
  "Flames of Sargeras",
  "Soul Corrosion",
  "Eye of Gul'dan",
  "Empowered Eye of Gul'dan",
  "Empowered Bonds of Fel",
  "Bonds of Fel",
  "Parasitic Wound",
  "Chaos Seed",
  "Severed Soul",
  "Severed",
  "Time Stop",
  "Scattering Field",
  "Shadowy Gaze",
  
  -- Trash
  "Arcanic Release",
  "Necrotic Strike",
  "Surpress",
  "Sanguine Ichor",
  "Thunderstrike",
  "Will of the Legion",

  
  -- Tomb of Sargeras -------------------------------------

  -- Gorth
  "Melted Armor",
  "Burning Armor",
  "Crashing Comet",
  "Fel Pool",
  "Shattering Star",
  
  -- Demonic Inquisition
  "Suffocating Dark",
  "Calcified Quills",
  "Unbearable Torment",
  
  -- Harjatan
  "Jagged Abrasion",
  "Aqueous Burst",
  "Drenching Waters",
  "Driven Assault",
  
  -- Sisters of the Moon
  "Moon Burn",
  "Twilight Volley",
  "Twilight Glaive",
  "Incorporeal Shot",
  
  -- Mistress Sassz'ine
  "Consuming Hunger",
  "Delicious Bufferfish",
  "Slicing Tornado",
  "Hydra Shot",
  "Slippery",
  
  -- Desolate Host
  "Soul Bind",
  "Spirit Chains",
  "Soul Rot",
  "Spear of Anguish",
  "Shattering Scream",
  
  -- Maiden of Vigilance
  "Unstable Soul",
  
  -- Fallen Avatar
  "Tainted Essence",
  "Black Winds",
  "Dark Mark",
  
  -- Kil'jaedan
  "Felclaws",
  'Shadow Reflection: Erupting',
  'Shadow Reflection: Wailing',
  'Shadow Reflection: Hopeless',
  "Armageddon Rain",
  "Lingering Eruption",
  "Lingering Wail",
  "Soul Anguish",
  "Focused Dreadflame",

  -- Antorus the Burning Throne ---------------------------

  -- Garothi
  "Fel Bombardment",
  "Haywire Decimation",
  "Decimation",

  -- Felhounds
  "Smouldering",
  "Siphoned",
  "Enflamed",
  "Singed",
  "Weight of Darkness",
  "Desolate Gaze",
  "Burning Remnant",
  "Molten Touch",
  "Consuming Sphere",

  -- High Command
  "Exploit Weakness",
  "Psychic Scarring",
  "Psychic Assault",
  "Shocked",
  "Shock Grenade",

  -- Portal Keeper
  "Reality Tear",
  "Cloying Shadows",
  "Caustic Slime",
  "Everburning Flames",
  "Fiery Detonation",
  "Mind Fog",
  "Flames of Xoroth",
  "Acidic Web",
  "Delusions",
  "Hungering Gloom",
  "Felsilk Wrap",

  -- Eonar
  "Feedback - Arcane Singularity",
  "Feedback - Targeted",
  "Feedback - Burning Embers",
  "Feedback - Foul Steps",
  "Fel Wake",
  "Rain of Fel",

  -- Imonar
  "Sever",
  "Charged Blasts",
  "Empowered Pulse Grenade",
  "Shrapnel Blast",
  "Shock Lance",
  "Empowered Shock Lance",
  "Shocked",
  "Conflagration",
  "Slumber Gas",
  "Sleep Canister",
  "Seared Skin",
  "Infernal Rockets",

  -- Kin'gorath
  "Forging Strike",
  "Ruiner",
  "Purging Protocol",

  -- Varimathras
  "Misery",
  "Echoes of Doom",
  "Necrotic Embrace",
  "Dark Fissure",
  "Marked Prey",

  -- Coven
  "Fiery Strike",
  "Flashfreeze",
  "Fury of Golganneth",
  "Fulminating Pulse",
  "Chilled Blood",
  "Cosmic Glare",
  "Spectral Army of Norgannon",
  "Whirling Saber",

  -- Aggramar
  "Taeshalach's Reach",
  "Empowered Flame Rend",
  "Foe Breaker",
  "Ravenous Blaze",
  "Wake of Flame",
  "Blazing Eruption",
  "Scorching Blaze",
  "Molten Remnants",

  -- Argus
  "Sweeping Scythe",
  "Avatar of Aggramar",
  "Soulburst",
  "Soulbomb",
  "Death Fog",
  "Soulblight",
  "Cosmic Ray",
  "Edge of Obliteration",
  "Gift of the Sea",
  "Gift of the Sky",
  "Cosmic Beacon",
  "Cosmic Smash",
  "Ember of Rage",
  "Deadly Scythe",
  "Sargeras' Rage",
  "Sargeras' Fear",
  "Unleashed Rage",
  "Crushing Fear",
  "Sentence of Sargeras",
  "Shattered Bonds",
  "Soul Detonation"
}


-----------------------------------------------------------
-- Buffs and Debuffs casted by players that SHOULD be
-- displayed. These auras appear on targets.
-----------------------------------------------------------

addon.auras.whitelist = {
  -- Warriors
  "Die by the Sword",
  "Shield Wall",
  "Demoralizing Shout",
  "Safeguard",
  "Vigilance",
  "Shockwave",
  
  -- Druids
  "Barkskin",
  "Survival Instincts",
  "Ironbark",
  "Bristling Fur",
  "Cyclone",
  "Entangling Roots",
  "Rapid Innervation",
  "Mark of Ursol",
  "Ironfur",
  "Frenzied Regeneration",

  -- Shamans
  "Shamanistic Rage",
  "Astral Shift",
  "Stone Bulwark Totem",
  "Hex",
  "Reincarnation",
  
  -- Death Knights
  "Icebound Fortitude",
  "Anti-Magic Shell",
  "Anti-Magic Zone",
  "Vampiric Blood",
  "Rune Tap",
  "Strangulate",
  
  -- Rogues
  "Feint",
  "Cloak of Shadows",
  "Riposte",
  "Smoke Bomb",
  "Between the Eyes",
  "Sap",
  "Evasion",
  "Crimson Vial",
  
  -- Mages
  "Ice Block",
  "Temporal Shield",
  "Cauterize",
  "Greater Invisibility",
  "Amplify Magic",
  "Evanesce",
  "Polymorph",
  "Polymorph: Fish",
  
  -- Warlocks
  "Dark Bargain",
  "Unending Resolve",
  
  -- Paladins
  "Divine Shield",
  "Divine Protection",
  "Blessing of Freedom",
  "Blessing of Sacrifice",
  "Ardent Defender",
  "Guardian of Ancient Kings",
  "Forbearance",
  "Hammer of Justice",
  
  -- Monks
  "Fortifying Brew",
  "Zen Meditation",
  "Diffuse Magic",
  "Dampen Harm",
  "Touch of Karma",
  "Paralysis",
  
  -- Hunters
  "Aspect of the Turtle",
  "Roar of Sacrifice",
  
  -- Priests
  "Dispersion",
  "Spectral Guise",
  "Pain Suppression",
  "Fear",
  "Mind Bomb",
  "Surrender Soul",
  "Guardian Spirit",
  
  -- Demon hunters
  "Blur",
  "Demon Spikes",
  "Metamorphosis",
  "Empower Wards",
  "Netherwalk",
  
  -- All Palyers
  "Draenic Channeled Mana Potion",
  "Leytorrent Potion",
  "Sanguine Ichor",
}


-----------------------------------------------------------
-- Buffs and Debuffs casted by players that SHOULD NOT
-- be displayed. These auras appear on targets.
-----------------------------------------------------------

addon.auras.blacklist = {
  -- Paladins
  "Unyielding Faith",
  "Glyph of Templar's Verdict",
  "Beacon's Tribute",
  
  -- Warlocks
  "Soul Leech",
  "Empowered Grasp",
  "Twilight Ward",
  "Shadow Trance",
  "Dark Refund",
  
  -- Warriors
  "Bloody Healing",
  "Flurry",
  "Victorious",
  "Deep Wounds",
  "Mortal Wounds",
  "Enrage",
  "Blood Craze",
  "Ultimatum",
  "Sword and Board",
  
  -- Death Knights
  "Purgatory",

  -- Priests
  "Weakened Soul",
  
  -- Misc.
  "Honorless Target",
  "Spirit Heal",
  "Capacitance",
  
  "Sated",
  "Exhaustion",
  "Insanity",
  "Temporal Displacement",
  "Void-Touched",
  "Awesome!",
  "Griefer",
  "Vivianne Defeated",
  "Recently Mass Resurrected",
}


-----------------------------------------------------------
-- Auras helpful for healers. These appear on targets.
-----------------------------------------------------------

addon.auras.healer = {
  -- Warlock
  "Soulstone",

  -- Monk
  "Renewing Mist",
  "Soothing Mist",
  "Essence Font",
  "Enveloping Mist",

  -- Shamans
  "Riptide",
  "Healing Rain",

  -- Druids
  "Efflorenscence",
  "Lifebloom",
  "Rejuvenation",
  "Regrowth",
  "Wild Growth",
  "Cenarion Ward",
  "Rejuvenation (Germination)",
  
  -- Paladin
  "Bestow Faith",
  "Beacon of Virtue",
  "Beacon of Light",
  "Beacon of Faith",
  "Tyr's Deliverance",
  
  -- Priest
  "Weakened Soul",
  "Renew",
  "Prayer of Mending",
  "Atonement",
  "Penance",
  "Shadow Mend",
  "Power Word: Shield",
}


-----------------------------------------------------------
-- Class-specific auras cast by the player.
-- 
-- Example: Warlock curses could appear here. Only those
--          debuffs cast by the player would be visible.
--          Whitelisting the debuffs would cause curses
--          from ALL Warlocks to appear (multiples).
-- 
-- These appear on players and targets.
-----------------------------------------------------------

addon.auras.class = {
  priest = {
    "Weakened Soul",
  },
  ["death knight"] = { },
  ["demon hunter"] = { },
  druid = { },
  hunter = { },
  mage = { },
  monk = { },
  paladin = { },
  rogue = { },
  shaman = {
    "Earth Shield",
  },
  warlock = {
    "Corruption",
    "Agony",
    "Unstable Affliction",
  },
  warrior = { },
}


-- Now translate each table into an unordered table. This allows
-- for efficient lookups later. We do this conversion so the
-- tables above can be written as simple lists.
for _, table in pairs({"raid","whitelist","blacklist","healer"}) do
  local tmp = {}
  for _, aura in pairs(addon.auras[table]) do
    tmp[aura] = true
  end
  addon.auras[table] = tmp
end

-- Also translate for class-specific auras.
for class, table in pairs(addon.auras.class) do
  local tmp = {}
  for _, aura in pairs(table) do
    tmp[aura] = true
  end
  addon.auras.class[class] = tmp
end
