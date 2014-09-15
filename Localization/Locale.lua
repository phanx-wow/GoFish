--[[--------------------------------------------------------------------
	GoFish
	Click-cast fishing and enhanced fishing sounds.
	Copyright (c) 2013-2014 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info22270-GoFish.html
	http://www.curse.com/addons/wow/gofish
----------------------------------------------------------------------]]

local _, ns = ...
local L, F = {}, setmetatable({}, { __index = function(t,k) t[k] = k return k end })
ns.L, ns.F = L, F

------------------------------------------------------------------------

L.FishingModeOn = "Quick fishing {ON}"
L.FishingModeOff = "Quick fishing {OFF}"
L.ToggleFishingMode = "Toggle quick fishing"

L.ActivateOnMouseover = "Activate when mousing over a fish pool"
L.ActivateOnMouseover_Tooltip = "Automatically turn on fishing mode when you mouse over a fish pool. When activated this way, fishing mode is disabled after 10 seconds if you don't cast."
L.ActivateOnEquip = "Activate when equipping a fishing pole"
L.ActivateOnEquip_Tooltip = "Automatically turn on fishing mode while you have a fishing pole equipped."
L.EnhanceSounds = "Enhance sound effects while fishing"
L.EnhanceSounds_Tooltip = "To better hear the fishing bobber splash, turn Sounds up, and Music and Ambience down. Your normal sound levels are restored after fishing."
L.MasterVolume_Tooltip = "Adjusts the master volume while fishing."
L.SFXVolume_Tooltip = "Adjusts the sound effect volume while fishing."
L.MusicVolume_Tooltip = "Adjusts the music volume while fishing."
L.AmbienceVolume_Tooltip = "Adjusts the ambient sound volume while fishing."