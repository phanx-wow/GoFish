--[[--------------------------------------------------------------------
	GoFish
	A World of Warcraft user interface addon
	Copyright (c) 2013 Phanx
	Some portions based on FishermansFriend by Ammo and Archy by Torhal.
----------------------------------------------------------------------]]

-- DONE: Enhance SFX and lower other sounds while fishing.
-- TODO: Key binding and slash command to toggle quick casting.
-- TODO: Auto enable quick casting when equipping a fishing pole.
-- TODO: Auto enable quick casting when mousing over a fish pool. Disable after 10 seconds.

local ADDON, ns = ...

local L = ns.L
L.FishingModeOff = L.FishingModeOff:gsub("{", GRAY_FONT_COLOR_CODE):gsub("}", FONT_COLOR_CODE_CLOSE)
L.FishingModeOn  = L.FishingModeOn:gsub("{", GREEN_FONT_COLOR_CODE):gsub("}", FONT_COLOR_CODE_CLOSE)

BINDING_HEADER_GOFISH      = GetAddOnMetadata(ADDON, "Title") or ADDON
BINDING_NAME_GOFISH_TOGGLE = L.ToggleFishingMode

------------------------------------------------------------------------

local fishingPools = {
	[ns.F["Abundant Firefin Snapper School"]] = true,
	[ns.F["Abundant Oily Blackmouth School"]] = true,
	[ns.F["Albino Cavefish School"]] = true,
	[ns.F["Algaefin Rockfish School"]] = true,
	[ns.F["Blackbelly Mudfish School"]] = true,
	[ns.F["Bloodsail Wreckage"]] = true,
	[ns.F["Bloodsail Wreckage Pool"]] = true,
	[ns.F["Bluefish School"]] = true,
	[ns.F["Borean Man O' War School"]] = true,
	[ns.F["Brackish Mixed School"]] = true,
	[ns.F["Deep Sea Monsterbelly School"]] = true,
	[ns.F["Deepsea Sagefish School"]] = true,
	[ns.F["Dragonfin Angelfish School"]] = true,
	[ns.F["Emperor Salmon School"]] = true,
	[ns.F["Fangtooth Herring School"]] = true,
	[ns.F["Fathom Eel Swarm"]] = true,
	[ns.F["Feltail School"]] = true,
	[ns.F["Firefin Snapper School"]] = true,
	[ns.F["Floating Debris"]] = true,
	[ns.F["Floating Debris Pool"]] = true,
	[ns.F["Floating Shipwreck Debris"]] = true,
	[ns.F["Floating Wreckage"]] = true,
	[ns.F["Floating Wreckage Pool"]] = true,
	[ns.F["Giant Mantis Shrimp Swarm"]] = true,
	[ns.F["Glacial Salmon School"]] = true,
	[ns.F["Glassfin Minnow School"]] = true,
	[ns.F["Golden Carp School"]] = true,
	[ns.F["Greater Sagefish School"]] = true,
	[ns.F["Highland Guppy School"]] = true,
	[ns.F["Highland Mixed School"]] = true,
	[ns.F["Imperial Manta Ray School"]] = true,
	[ns.F["Jade Lungfish School"]] = true,
	[ns.F["Jewel Danio School"]] = true,
	[ns.F["Krasarang Paddlefish School"]] = true,
	[ns.F["Lesser Firefin Snapper School"]] = true,
	[ns.F["Lesser Floating Debris"]] = true,
	[ns.F["Lesser Oily Blackmouth School"]] = true,
	[ns.F["Lesser Sagefish School"]] = true,
	[ns.F["Moonglow Cuttlefish School"]] = true,
	[ns.F["Mountain Trout School"]] = true,
	[ns.F["Muddy Churning Water"]] = true,
	[ns.F["Mudfish School"]] = true,
	[ns.F["Musselback Sculpin School"]] = true,
	[ns.F["Nettlefish School"]] = true,
	[ns.F["Oil Spill"]] = true,
	[ns.F["Oily Blackmouth School"]] = true,
	[ns.F["Patch of Elemental Water"]] = true,
	[ns.F["Pool of Fire"]] = true,
	[ns.F["Pure Water"]] = true,
	[ns.F["Redbelly Mandarin School"]] = true,
	[ns.F["Reef Octopus Swarm"]] = true,
	[ns.F["Sagefish School"]] = true,
	[ns.F["School of Darter"]] = true,
	[ns.F["School of Deviate Fish"]] = true,
	[ns.F["School of Tastyfish"]] = true,
	[ns.F["Schooner Wreckage"]] = true,
	[ns.F["Schooner Wreckage Pool"]] = true,
	[ns.F["Shipwreck Debris"]] = true,
	[ns.F["Sparse Firefin Snapper School"]] = true,
	[ns.F["Sparse Oily Blackmouth School"]] = true,
	[ns.F["Sparse Schooner Wreckage"]] = true,
	[ns.F["Spinefish School"]] = true,
	[ns.F["Sporefish School"]] = true,
	[ns.F["Steam Pump Flotsam"]] = true,
	[ns.F["Stonescale Eel Swarm"]] = true,
	[ns.F["Strange Pool"]] = true,
	[ns.F["Teeming Firefin Snapper School"]] = true,
	[ns.F["Teeming Floating Wreckage"]] = true,
	[ns.F["Teeming Oily Blackmouth School"]] = true,
	[ns.F["Tiger Gourami School"]] = true,
	[ns.F["Waterlogged Wreckage"]] = true,
	[ns.F["Waterlogged Wreckage Pool"]] = true,
}

------------------------------------------------------------------------

local autoInteract		-- was autoInteract ON before we started fishing mode?
local autoLoot          -- was autoLoot OFF before we started fishing mode?
local autoStopTime      -- GetTime() to turn off auto-enabled fishing mode
local clearBinding		-- was combat started mid-click, leaving us stuck in fishing mode?
local isFishing			-- is fishing mode on?
local hasBinding		-- are we in the middle of a double-click to fish?

------------------------------------------------------------------------

local FISHING = GetSpellInfo(131474)
local FISHING_POLE = select(7, GetItemInfo(6256))

------------------------------------------------------------------------

local normalValues = {}

local fishingValues = {
	Sound_EnableAllSound = 1,
	Sound_EnableSFX = 1,
	Sound_EnableErrorSpeech = 0,
	Sound_EnableEmoteSounds = 0,
	Sound_EnablePetSounds = 0,
	Sound_MasterVolume = 0.25,
	Sound_SFXVolume = 0.5,
	Sound_MusicVolume = 1,
	Sound_AmbienceVolume = 0.25,
}

------------------------------------------------------------------------

local function IsInCombat()
	return InCombatLockdown() or UnitAffectingCombat("player") or UnitAffectingCombat("pet")
end

------------------------------------------------------------------------

local GoFish = CreateFrame("Button", "GoFish", UIParent, "SecureActionButtonTemplate")

GoFish:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
GoFish:RegisterEvent("PLAYER_LOGIN")

GoFish:EnableMouse(true)
GoFish:RegisterForClicks("RightButtonUp")
GoFish:SetPoint("LEFT", UIParent, "RIGHT", 10000, 0)
GoFish:Hide()

GoFish:SetAttribute("action", nil) -- wat?
GoFish:SetAttribute("type", "spell")
GoFish:SetAttribute("spell", FISHING)

------------------------------------------------------------------------

GoFish:SetScript("PostClick", function(self, button, down)
	--print("Fished")
	if IsInCombat() then
		--print("In combat")
		clearBinding = true
	elseif hasBinding then
		ClearOverrideBindings(self)
		hasBinding = nil
		--print("Override binding cleared")
	end
end)

function GoFish:SetupClickHook()
	local lastClickTime = 0
	WorldFrame:HookScript("OnMouseDown", function(self, button, down)
		if not isFishing or button ~= "RightButton" or IsInCombat() then return end

		local numLoots = GetNumLootItems()
		if numLoots and numLoots > 0 then return end

		--print("OnMouseDown")

		local goFish
		local clickTime = GetTime()
		local clickDiff = clickTime - lastClickTime
		lastClickTime = clickTime

		if clickDiff > 0.05 and clickDiff < 0.4 then
			--print("GoFish!")
			if IsMouselooking() then
				MouselookStop()
			end
			SetOverrideBindingClick(GoFish, true, "BUTTON2", "GoFish")
			hasBinding = true
		end
	end)
	self.SetupClickHook = nil
end

------------------------------------------------------------------------

function GoFish:EnableFishingMode()
	if isFishing then
		return --print("Already fishing")
	end
	if not GetSpellInfo(FISHING) then
		return --print("Fishing not learned")
	end
	if self.SetupClickHook then
		self:SetupClickHook()
		self:RegisterEvent("PLAYER_LOGOUT")
	end
	if GetCVarBool("autointeract") then
		SetCVar("autointeract", 0)
		autoInteract = 1
	end
	if not GetCVarBool("autoLootDefault") then
		SetCVar("autoLoot", 1)
		autoLoot = 1
	end
	isFishing = true
	print("|cff00ddbaGoFish:|r", L.FishingModeOn)
end

function GoFish:DisableFishingMode()
	if not isFishing then return end
	isFishing = nil
	if autoInteract then
		SetCVar("autointeract", 1)
		autoInteract = nil
	end
	if autoLoot then
		SetCVar("autoLoot", 0)
		autoLoot = nil
	end
	if autoStopTime then
		autoStopTime = nil
	end
	print("|cff00ddbaGoFish:|r", L.FishingModeOff)
end

function GoFish:ToggleFishingMode()
	if isFishing then
		self:DisableFishingMode()
	else
		self:EnableFishingMode()
	end
end

------------------------------------------------------------------------

function GoFish:PLAYER_LOGIN()
	--print("LOGIN")
	FISHING = GetSpellInfo(131474)
	FISHING_POLE = select(7, GetItemInfo(6256))

	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
	self:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
end

function GoFish:PLAYER_LOGOUT()
	--print("LOGOUT")
	if isFishing then
		-- Restore cvars
		self:UNIT_SPELLCAST_CHANNEL_STOP("player", FISHING)
		-- Clear binding
		self:DisableFishingMode()
	end
end

------------------------------------------------------------------------

function GoFish:PLAYER_REGEN_DISABLED()
	--print("Combat START")
	self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	if UnitChannelInfo("unit") == FISHING then
		self:UNIT_SPELLCAST_CHANNEL_STOP("player", FISHING)
	end
	if isFishing then
		self:DisableFishingMode()
	end
end

function GoFish:PLAYER_REGEN_ENABLED()
	--print("Combat STOP")
	if clearBinding then
		ClearOverrideBindings(self)
		clearBinding = nil
		hasBinding = nil
		--print("Override binding cleared")
	end
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
end

------------------------------------------------------------------------

function GoFish:UNIT_SPELLCAST_CHANNEL_START(unit, spell)
	if spell == FISHING then
		--print("Fishing START")
		if autoStopTime then
			autoStopTime = GetTime() + 1000 --print("Fishing...")
		end
		for k, v in pairs(fishingValues) do
			normalValues[k] = GetCVar(k)
			SetCVar(k, v)
		end
	end
end

function GoFish:UNIT_SPELLCAST_CHANNEL_STOP(unit, spell)
	if spell == FISHING then
		--print("Fishing STOP")
		if autoStopTime then
			autoStopTime = GetTime() + 10 --print("Ending in 10 seconds")
		end
		for k, v in pairs(normalValues) do
			SetCVar(k, v)
		end
	end
end

------------------------------------------------------------------------

local hasPole

function GoFish:UNIT_INVENTORY_CHANGED(unit)
	local pole = IsEquippedItemType(FISHING_POLE)
	if pole == hasPole then return end
	hasPole = pole

	if hasPole and not isFishing then
		--print("Pole equipped!")
		self:EnableFishingMode()
	elseif isFishing and not hasPole then
		--print("Pole removed!")
		self:DisableFishingMode()
	end
end

------------------------------------------------------------------------

local timerFrame = CreateFrame("Frame")
local timerGroup = timerFrame:CreateAnimationGroup()
local timer = timerGroup:CreateAnimation()
timer:SetDuration(1)
timerGroup:SetScript("OnFinished", function(self, requested)
	if not isFishing or not autoStopTime then return end
	if GetTime() > autoStopTime then
		GoFish:DisableFishingMode()
		autoStopTime = nil
	else
		self:Play()
	end
end)

GameTooltip:HookScript("OnShow", function(self)
	if isFishing then return end

	local text = GameTooltipTextLeft1:GetText()
	if not text or not fishingPools[text] or IsMounted() or IsInCombat() or self:GetItem() or self:GetUnit() then return end

	GoFish:EnableFishingMode()
	if not isFishing then return end

	autoStopTime = GetTime() + 10 --print("Ending in 10 seconds")
	timerGroup:Play()
end)

------------------------------------------------------------------------

SLASH_GOFISH1 = "/gofish"
SlashCmdList.GOFISH = function(cmd)
	cmd = cmd and strtrim(strlower(cmd))
	if cmd == "options" then
		-- open options
	elseif not IsInCombat() then
		GoFish:ToggleFishingMode()
	end
end