--[[--------------------------------------------------------------------
	GoFish
	Click-cast fishing and enhanced fishing sounds.
	Copyright (c) 2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info22270-GoFish.html
	http://www.curse.com/addons/wow/gofish
----------------------------------------------------------------------]]

if GetLocale() ~= "deDE" then return end
local _, ns = ...
local L, F = ns.L, ns.F

------------------------------------------------------------------------

--L.FishingModeOff = "Fishing mode {ON}"
--L.FishingModeOn = "Fishing mode {OFF}"
--L.ToggleFishingMode = "Toggle fishing mode"

------------------------------------------------------------------------

F["Abundant Bloodsail Wreckage"] = "Blutsegelwrackteile"
F["Abundant Firefin Snapper School"] = "Ein ergiebiger Schwarm Feuerflossenschnapper"
F["Abundant Oily Blackmouth School"] = "Ergiebiger Schwarm öliger Schwarzmaulfische"
F["Albino Cavefish School"] = "Ein Schwarm Albinohölhenfische"
F["Algaefin Rockfish School"] = "Ein Schwarm Algenflossenbarsche"
F["Blackbelly Mudfish School"] = "Ein Schwarm Schwarzbauchmatschflosser"
F["Bloodsail Wreckage"] = "Blutsegelwrackteile"
F["Bloodsail Wreckage Pool"] = "Ein Schwarm Blutsegelwrackteile"
F["Bluefish School"] = "Blauflossenschwarm"
F["Borean Man O' War School"] = "Ein Schwarm boreanischer Galeeren"
F["Brackish Mixed School"] = "Brackwasserschwarm"
--F["Crane Yolk Pool"] = "Crane Yolk Pool"
F["Deep Sea Monsterbelly School"] = "Ein Schwarm Tiefseemonsterbäuche"
F["Deepsea Sagefish School"] = "Ein Schwarm Tiefseeweisenfische"
F["Dragonfin Angelfish School"] = "Engelsdrachenfischschwarm"
F["Emperor Salmon School"] = "Ein Schwarm Kaiserlachse"
F["Fangtooth Herring School"] = "Ein Schwarm Fangzahnheringe"
F["Fathom Eel Swarm"] = "Klafteraalschwarm"
F["Feltail School"] = "Teufelsfinnenschwarm"
F["Firefin Snapper School"] = "Feuerflossenschnapperschwarm"
F["Floating Debris"] = "Schwimmende Trümmer"
F["Floating Debris Pool"] = "Ein Schwarm Schwimmende Trümmer"
F["Floating Shipwreck Debris"] = "Schwimmende Schiffswrack Trümmer"
F["Floating Wreckage"] = "Treibende Wrackteile"
F["Floating Wreckage Pool"] = "Floating Wreckage Pool"
F["Giant Mantis Shrimp Swarm"] = "Ein Schwarm riesiger Mantisgarnelen"
F["Glacial Salmon School"] = "Ein Schwarm Winterlachse"
F["Glassfin Minnow School"] = "Ein Schwarm Glasflossenelritzen"
F["Golden Carp School"] = "Ein Schwarm Goldkarpfen"
F["Greater Sagefish School"] = "Großer Schwarm Weisenfische"
F["Highland Guppy School"] = "Ein Schwarm Hochlandguppys"
F["Highland Mixed School"] = "Mischschwarm des Hochlands"
F["Imperial Manta Ray School"] = "Ein Schwarm imperialer Mantarochen"
F["Jade Lungfish School"] = "Ein Schwarm Jadelungenfische"
F["Jewel Danio School"] = "Ein Schwarm Juwelendanios"
F["Krasarang Paddlefish School"] = "Ein Schwarm Krasaranglöffelstöre"
F["Lesser Firefin Snapper School"] = "Kleiner Feuerflossenschnapperschwarm"
F["Lesser Floating Debris"] = "Lesser Floating Debris"
F["Lesser Oily Blackmouth School"] = "Kleiner Schwarm öliger Schwarzmaulfische"
F["Lesser Sagefish School"] = "Kleiner Weisenfischschwarm"
--F["Mixed Ocean School"] = "Mixed Ocean School"
F["Moonglow Cuttlefish School"] = "Ein Schwarm Mondlichtsepia"
F["Mountain Trout School"] = "Ein Schwarm Bergforellen"
F["Muddy Churning Water"] = "Schlammiges aufgewühltes Wasser"
F["Mudfish School"] = "Matschflosserschwarm"
F["Musselback Sculpin School"] = "Muschelrückengropperschwarm"
F["Nettlefish School"] = "Ein Schwarm Nesselfische"
F["Oil Spill"] = "Ölfleck"
F["Oily Blackmouth School"] = "Schwarm öliger Schwarzmaulfische"
F["Patch of Elemental Water"] = "Stelle mit Elementarwasser"
F["Pool of Fire"] = "Feuerteich"
F["Pure Water"] = "Reines Wasser"
F["Redbelly Mandarin School"] = "Ein Schwarm Rotbauchmandarine"
F["Reef Octopus Swarm"] = "Ein Schwarm Riffkraken"
F["Sagefish School"] = "Weisenfischschwarm"
F["School of Darter"] = "Stachelflosserschwarm"
F["School of Deviate Fish"] = "Deviatfischschwarm"
F["School of Tastyfish"] = "Leckerfischschwarm"
F["Schooner Wreckage"] = "Schiffswrackteile"
F["Schooner Wreckage Pool"] = "Ein Schwarm Schiffswrackteile"
F["Shipwreck Debris"] = "Schiffswracktrümmer"
F["Sparse Firefin Snapper School"] = "Spärlicher Feuerflossenschnapperschwarm"
F["Sparse Oily Blackmouth School"] = "Spärlicher Schwarm öliger Schwarzmaulfische"
F["Sparse Schooner Wreckage"] = "Sparse Schooner Wreckage"
F["Spinefish School"] = "Ein Schwarm Stachelfische"
F["Sporefish School"] = "Sporenfischschwarm"
F["Steam Pump Flotsam"] = "Treibgut der Dampfpumpe"
F["Stonescale Eel Swarm"] = "Steinschuppenaalschwarm"
F["Strange Pool"] = "Strange Pool"
F["Teeming Firefin Snapper School"] = "Wimmelnder Feuerflossenschnapperschwarm"
F["Teeming Floating Wreckage"] = "Teeming Floating Wreckage"
F["Teeming Oily Blackmouth School"] = "Wimmelnder Schwarm öliger Schwarzmaulfische"
F["Tiger Gourami School"] = "Ein Schwarm Tigerguramis"
F["Waterlogged Wreckage"] = "Treibholzwrackteile"
F["Waterlogged Wreckage Pool"] = "Ein Schwarm Schwimmende Wrackteile"
