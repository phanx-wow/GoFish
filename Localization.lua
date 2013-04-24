--[[--------------------------------------------------------------------
	GoFish
	Click-cast fishing and enhanced fishing sounds.
	Copyright (c) 2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info-GoFish.html
	http://www.curse.com/addons/wow/gofish
----------------------------------------------------------------------]]

local _, ns = ...
local L, F = {}, setmetatable({}, { __index = function(t,k) t[k] = k return k end })
ns.L, ns.F = L, F

------------------------------------------------------------------------

L.FishingModeOff = "Quick fishing {OFF}"
L.FishingModeOn = "Quick fishing {ON}"
L.ToggleFishingMode = "Toggle quick fishing"

------------------------------------------------------------------------

F["Abundant Firefin Snapper School"] = "Abundant Firefin Snapper School"
F["Abundant Oily Blackmouth School"] = "Abundant Oily Blackmouth School"
F["Albino Cavefish School"] = "Albino Cavefish School"
F["Algaefin Rockfish School"] = "Algaefin Rockfish School"
F["Blackbelly Mudfish School"] = "Blackbelly Mudfish School"
F["Bloodsail Wreckage"] = "Bloodsail Wreckage"
F["Bloodsail Wreckage Pool"] = "Bloodsail Wreckage Pool"
F["Bluefish School"] = "Bluefish School"
F["Borean Man O' War School"] = "Borean Man O' War School"
F["Brackish Mixed School"] = "Brackish Mixed School"
F["Crane Yolk Pool"] = "Crane Yolk Pool"
F["Deep Sea Monsterbelly School"] = "Deep Sea Monsterbelly School"
F["Deepsea Sagefish School"] = "Deepsea Sagefish School"
F["Dragonfin Angelfish School"] = "Dragonfin Angelfish School"
F["Emperor Salmon School"] = "Emperor Salmon School"
F["Fangtooth Herring School"] = "Fangtooth Herring School"
F["Fathom Eel Swarm"] = "Fathom Eel Swarm"
F["Feltail School"] = "Feltail School"
F["Firefin Snapper School"] = "Firefin Snapper School"
F["Floating Debris"] = "Floating Debris"
F["Floating Debris Pool"] = "Floating Debris Pool"
F["Floating Shipwreck Debris"] = "Floating Shipwreck Debris"
F["Floating Wreckage"] = "Floating Wreckage"
F["Floating Wreckage Pool"] = "Floating Wreckage Pool"
F["Giant Mantis Shrimp Swarm"] = "Giant Mantis Shrimp Swarm"
F["Glacial Salmon School"] = "Glacial Salmon School"
F["Glassfin Minnow School"] = "Glassfin Minnow School"
F["Golden Carp School"] = "Golden Carp School"
F["Greater Sagefish School"] = "Greater Sagefish School"
F["Highland Guppy School"] = "Highland Guppy School"
F["Highland Mixed School"] = "Highland Mixed School"
F["Imperial Manta Ray School"] = "Imperial Manta Ray School"
F["Jade Lungfish School"] = "Jade Lungfish School"
F["Jewel Danio School"] = "Jewel Danio School"
F["Krasarang Paddlefish School"] = "Krasarang Paddlefish School"
F["Lesser Firefin Snapper School"] = "Lesser Firefin Snapper School"
F["Lesser Floating Debris"] = "Lesser Floating Debris"
F["Lesser Oily Blackmouth School"] = "Lesser Oily Blackmouth School"
F["Lesser Sagefish School"] = "Lesser Sagefish School"
F["Moonglow Cuttlefish School"] = "Moonglow Cuttlefish School"
F["Mountain Trout School"] = "Mountain Trout School"
F["Muddy Churning Water"] = "Muddy Churning Water"
F["Mudfish School"] = "Mudfish School"
F["Musselback Sculpin School"] = "Musselback Sculpin School"
F["Nettlefish School"] = "Nettlefish School"
F["Oil Spill"] = "Oil Spill"
F["Oily Blackmouth School"] = "Oily Blackmouth School"
F["Patch of Elemental Water"] = "Patch of Elemental Water"
F["Pool of Fire"] = "Pool of Fire"
F["Pure Water"] = "Pure Water"
F["Redbelly Mandarin School"] = "Redbelly Mandarin School"
F["Reef Octopus Swarm"] = "Reef Octopus Swarm"
F["Sagefish School"] = "Sagefish School"
F["School of Darter"] = "School of Darter"
F["School of Deviate Fish"] = "School of Deviate Fish"
F["School of Tastyfish"] = "School of Tastyfish"
F["Schooner Wreckage"] = "Schooner Wreckage"
F["Schooner Wreckage Pool"] = "Schooner Wreckage Pool"
F["Shipwreck Debris"] = "Shipwreck Debris"
F["Sparse Firefin Snapper School"] = "Sparse Firefin Snapper School"
F["Sparse Oily Blackmouth School"] = "Sparse Oily Blackmouth School"
F["Sparse Schooner Wreckage"] = "Sparse Schooner Wreckage"
F["Spinefish School"] = "Spinefish School"
F["Sporefish School"] = "Sporefish School"
F["Steam Pump Flotsam"] = "Steam Pump Flotsam"
F["Stonescale Eel Swarm"] = "Stonescale Eel Swarm"
F["Strange Pool"] = "Strange Pool"
F["Teeming Firefin Snapper School"] = "Teeming Firefin Snapper School"
F["Teeming Floating Wreckage"] = "Teeming Floating Wreckage"
F["Teeming Oily Blackmouth School"] = "Teeming Oily Blackmouth School"
F["Tiger Gourami School"] = "Tiger Gourami School"
F["Waterlogged Wreckage"] = "Waterlogged Wreckage"
F["Waterlogged Wreckage Pool"] = "Waterlogged Wreckage Pool"
