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