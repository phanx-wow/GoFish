--[[--------------------------------------------------------------------
	GoFish
	A World of Warcraft user interface addon
	Copyright (c) 2013 Phanx
	Some portions based on FishermansFriend by Ammo and Archy by Torhal.
----------------------------------------------------------------------]]

-- DONE: Enhance SFX and lower other sounds while fishing.
-- TODO: Key binding and slash command to toggle quick casting.
-- TODO: Auto enable quick casting when equipping a fishing pole.
-- TODO: Auto enable quick casting when mousing over a fish pool. Disable after 2 seconds.

local ADDON, ns = ...
local L = {
	ToggleFishingMode = "Toggle fishing mode",
}

BINDING_HEADER_GOFISH = GetAddOnMetadata(ADDON, "Title") or ADDON
BINDING_NAME_GOFISH_TOGGLE = L.ToggleFishingMode

------------------------------------------------------------------------

local autoInteract		-- was autoInteract enabled before we started fishing mode?
local clearBinding		-- was combat started mid-click, leaving us stuck in fishing mode?
local isFishing			-- is fishing mode on?
local hasBinding		-- are we in the middle of a double-click to fish?
local autoStopTime      -- GetTime() to turn off auto-enabled fishing mode

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

local fishingPools = {
	["Abundant Firefin Snapper School"] = true,
	["Abundant Oily Blackmouth School"] = true,
	["Albino Cavefish School"] = true,
	["Algaefin Rockfish School"] = true,
	["Blackbelly Mudfish School"] = true,
	["Bloodsail Wreckage"] = true,
	["Bloodsail Wreckage Pool"] = true,
	["Bluefish School"] = true,
	["Borean Man O' War School"] = true,
	["Brackish Mixed School"] = true,
	["Deep Sea Monsterbelly School"] = true,
	["Deepsea Sagefish School"] = true,
	["Dragonfin Angelfish School"] = true,
	["Emperor Salmon School"] = true,
	["Fangtooth Herring School"] = true,
	["Fathom Eel Swarm"] = true,
	["Feltail School"] = true,
	["Firefin Snapper School"] = true,
	["Floating Debris"] = true,
	["Floating Debris Pool"] = true,
	["Floating Shipwreck Debris"] = true,
	["Floating Wreckage"] = true,
	["Floating Wreckage Pool"] = true,
	["Giant Mantis Shrimp Swarm"] = true,
	["Glacial Salmon School"] = true,
	["Glassfin Minnow School"] = true,
	["Golden Carp School"] = true,
	["Greater Sagefish School"] = true,
	["Highland Guppy School"] = true,
	["Highland Mixed School"] = true,
	["Imperial Manta Ray School"] = true,
	["Jade Lungfish School"] = true,
	["Jewel Danio School"] = true,
	["Krasarang Paddlefish School"] = true,
	["Lesser Firefin Snapper School"] = true,
	["Lesser Floating Debris"] = true,
	["Lesser Oily Blackmouth School"] = true,
	["Lesser Sagefish School"] = true,
	["Moonglow Cuttlefish School"] = true,
	["Mountain Trout School"] = true,
	["Muddy Churning Water"] = true,
	["Mudfish School"] = true,
	["Musselback Sculpin School"] = true,
	["Nettlefish School"] = true,
	["Oil Spill"] = true,
	["Oily Blackmouth School"] = true,
	["Patch of Elemental Water"] = true,
	["Pool of Fire"] = true,
	["Pure Water"] = true,
	["Redbelly Mandarin School"] = true,
	["Reef Octopus Swarm"] = true,
	["Sagefish School"] = true,
	["School of Darter"] = true,
	["School of Deviate Fish"] = true,
	["School of Tastyfish"] = true,
	["Schooner Wreckage"] = true,
	["Schooner Wreckage Pool"] = true,
	["Shipwreck Debris"] = true,
	["Sparse Firefin Snapper School"] = true,
	["Sparse Oily Blackmouth School"] = true,
	["Sparse Schooner Wreckage"] = true,
	["Spinefish School"] = true,
	["Sporefish School"] = true,
	["Steam Pump Flotsam"] = true,
	["Stonescale Eel Swarm"] = true,
	["Strange Pool"] = true,
	["Teeming Firefin Snapper School"] = true,
	["Teeming Floating Wreckage"] = true,
	["Teeming Oily Blackmouth School"] = true,
	["Tiger Gourami School"] = true,
	["Waterlogged Wreckage"] = true,
	["Waterlogged Wreckage Pool"] = true,
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
	if isFishing then return end
	if not GetSpellInfo(FISHING) then
		return
	end
	if self.SetupClickHook then
		self:SetupClickHook()
		self:RegisterEvent("PLAYER_LOGOUT")
	end
	if GetCVarBool("autointeract") then
		SetCVar("autointeract", 0)
		autoInteract = 1
	end
	isFishing = true
	print("Fishing mode ON")
end

function GoFish:DisableFishingMode()
	if not isFishing then return end
	isFishing = nil
	if autoInteract then
		SetCVar("autointeract", 1)
		autoInteract = nil
	end
	print("Fishing mode OFF")
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
	self:RegisterUnitEvent("UNIT_CHANNEL_START", "player")
	self:RegisterUnitEvent("UNIT_CHANNEL_STOP", "player")
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
			autoStopTime = GetTime() + 1000
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
			autoStopTime = GetTime() + 10
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
		self:EnableFishingMode()
	elseif isFishing and not hasPole then
		self:DisableFishingMode()
	end
end

------------------------------------------------------------------------

local autoStop = GoFish:CreateAnimationGroup()
autoStop.anim = autoStop:CreateAnimation()
autoStop.anim:SetDuration(1)
autoStop:SetScript("OnFinished", function(self, forced)
	if not isFishing or not autoStopTime then return end
	if GetTime() > autoStopTime then
		self:StopFishing()
		autoStopTime = nil
	else
		self:Play()
	end
end)

hooksecurefunc(GameTooltip, "Show", function(self)
	if not isFishing then return end
	if self:GetItem() or self:GetUnit() then return end

	local text = GameTooltipTextLeft1:GetText()
	if not text or not fishingPools[text] then return end

	self:EnableFishingMode()
	if not isFishing then return end

	autoStopTime = GetTime() + 10
	autoStop:Play()
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