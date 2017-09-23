--[[--------------------------------------------------------------------
	GoFish
	Click-cast fishing and enhanced fishing sounds.
	Copyright (c) 2013-2017 Phanx <addons@phanx.net>. All rights reserved.
	Maintained by Akkorian <armordecai@protonmail.com>
	https://github.com/phanx-wow/GoFish
	https://mods.curse.com/addons/wow/gofish
	https://www.wowinterface.com/downloads/info22270-GoFish.html
----------------------------------------------------------------------]]

local ADDON, ns = ...
local FISHING = GetSpellInfo(131474)
local FISHING_POLE = select(7, GetItemInfo(6256))
local FROSTWOLF_WAR_WOLF = GetSpellInfo(164222)
local TELAARI_TALBUK = GetSpellInfo(165803)

local L = ns.L
L["Quick fishing {OFF}"] = L["Quick fishing {OFF}"]:gsub("{",  GRAY_FONT_COLOR_CODE):gsub("}", FONT_COLOR_CODE_CLOSE)
L["Quick fishing {ON}"]  = L["Quick fishing {ON}" ]:gsub("{", GREEN_FONT_COLOR_CODE):gsub("}", FONT_COLOR_CODE_CLOSE)

BINDING_HEADER_GOFISH = GetAddOnMetadata(ADDON, "Title") or ADDON
BINDING_NAME_GOFISH_TOGGLE = L["Toggle quick fishing"]

local F = {}
for k, v in pairs(ns.F) do
	if v == true then
		F[k] = true
	else
		F[v] = true
	end
end
ns.F = F

------------------------------------------------------------------------

local autoInteract -- was autoInteract ON before we started fishing mode?
local autoLoot     -- was autoLootDefault OFF before we started fishing mode?
local soundInBg    -- was autoLootDefault OFF before we started fishing mode?
local autoStopTime -- GetTime() to turn off auto-enabled fishing mode
local clearBinding -- was combat started mid-click, leaving us stuck in fishing mode?
local isFishing    -- is fishing mode on?
local hasBinding   -- are we in the middle of a double-click to fish?

local normalCVars = {}
local extraCVars = { -- extra things to disable in fishing mode if sound was globally disabled
	Sound_EnablePetSounds = 0,
	Sound_EnableEmoteSounds = 0,
	Sound_EnableMusic = 0,
	Sound_EnableAmbience = 0,
	Sound_EnableDialog = 0,
}

local defaults = {
	ActivateOnEquip = true,
	ActivateOnMouseover = true,
	AutoLoot = true,
	EnhanceSounds = true,
	MouseoverTimeout = 10,
	SoundInBG = true,
	CVars = {
		Sound_EnableAllSound = 1,
		Sound_EnableSFX = 1,
		Sound_EnableErrorSpeech = 0,
		Sound_EnableEmoteSounds = 0,
		Sound_EnablePetSounds = 0,
		Sound_MasterVolume = 0.5,
		Sound_SFXVolume = 1,
		Sound_MusicVolume = 0.25,
		Sound_AmbienceVolume = 0,
	}
}

------------------------------------------------------------------------

local function IsInCombat()
	return InCombatLockdown() or UnitAffectingCombat("player") or UnitAffectingCombat("pet")
end

local function IsFishingPoleEquipped()
	-- Some people's game clients are broken?
	if not FISHING_POLE then
		FISHING_POLE = select(7, GetItemInfo(6256))
	end
	return IsEquippedItemType(FISHING_POLE or UNKNOWN)
end

local function EnhanceSounds()
	if GoFishDB.SoundInBG then
		soundInBg = GetCVar("Sound_EnableSoundWhenGameIsInBG")
		SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
	end

	if not GoFishDB.EnhanceSounds or next(normalCVars) then
		return
	end
	if GoFishDB.CVars.Sound_EnableAllSound and not GetCVarBool("Sound_EnableAllSound") then
		for cvar, value in pairs(extraCVars) do
			normalCVars[cvar] = GetCVar(cvar)
			SetCVar(cvar, 0)
		end
	end
	for cvar, value in pairs(GoFishDB.CVars) do
		normalCVars[cvar] = GetCVar(cvar)
		SetCVar(cvar, value)
	end
end

local function RestoreSounds()
	if soundInBg and GoFishDB.SoundInBG then
		SetCVar("Sound_EnableSoundWhenGameIsInBG", soundInBg)
		soundInBg = nil
	end

	if not GoFishDB.EnhanceSounds or not next(normalCVars) then
		return
	end
	for cvar, value in pairs(normalCVars) do
		SetCVar(cvar, value)
		normalCVars[cvar] = nil
	end
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

		if clickDiff > 0.05 and clickDiff < 0.25 then
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

	autoInteract = GetCVar("autointeract")
	SetCVar("autointeract", "0")

	if GoFishDB.AutoLoot then
		autoLoot = GetCVar("autoLootDefault")
		SetCVar("autoLootDefault", "1")
	end

	isFishing = true
	print("|cff00ddbaGoFish:|r", L["Quick fishing {ON}"])
end

function GoFish:DisableFishingMode()
	if not isFishing then return end
	isFishing = nil
	RestoreSounds()

	SetCVar("autointeract", autoInteract)
	autoInteract = nil

	if GoFishDB.AutoLoot and autoLoot then
		SetCVar("autoLootDefault", autoLoot)
		autoLoot = nil
	end

	autoStopTime = nil
	print("|cff00ddbaGoFish:|r", L["Quick fishing {OFF}"])
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
	local function initDB(a, b)
		if type(a) ~= "table" then return {} end
		if type(b) ~= "table" then b = {} end
		for k, v in pairs(a) do
			if type(v) == "table" then
				b[k] = initDB(v, b[k])
			elseif type(b[k]) ~= type(v) then
				b[k] = v
			end
		end
		return b
	end
	GoFishDB = initDB(defaults, GoFishDB)

	-- Call again in case they weren't cached before:
	FISHING = GetSpellInfo(131474)
	FISHING_POLE = select(7, GetItemInfo(6256))

	self:UnregisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
	if GoFishDB.ActivateOnEquip then
		self:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	end
	self:RegisterEvent("PET_BATTLE_OPENING_START")
end

function GoFish:PLAYER_LOGOUT()
	--print("LOGOUT")
	self:DisableFishingMode()
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

	if GoFishDB.ActivateOnEquip and IsFishingPoleEquipped() then
		self:EnableFishingMode()
	end
end

------------------------------------------------------------------------

function GoFish:UNIT_SPELLCAST_CHANNEL_START(unit, spell)
	if spell == FISHING then
		--print("Fishing START")
		EnhanceSounds()
		if autoStopTime then
			autoStopTime = GetTime() + 1000000
		end
	end
end

function GoFish:UNIT_SPELLCAST_CHANNEL_STOP(unit, spell)
	if spell == FISHING then
		--print("Fishing STOP")
		RestoreSounds()
		if autoStopTime then
			autoStopTime = GetTime() + GoFishDB.MouseoverTimeout
		end
	end
end

------------------------------------------------------------------------

local hasPole

function GoFish:UNIT_INVENTORY_CHANGED(unit)
	local pole = IsFishingPoleEquipped()
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

function GoFish:PET_BATTLE_OPENING_START()
	if isFishing then
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

local okparents = { -- ignore minimap tooltips
	[WorldFrame] = true,
	[UIParent] = true,
}
local farSight = {
	[(GetSpellInfo(6197))] = true, -- Eagle Eye
	[(GetSpellInfo(126))]  = true, -- Eye of Kilrogg
	[(GetSpellInfo(6196))] = true, -- Far Sight
	[(GetSpellInfo(2096))] = true, -- Mind Vision
}
local allowedForms = {
	[0]  = true, -- none
	[31] = true, -- Druid Moonkin Form
	[30] = true, -- Rogue Stealth
}

GameTooltip:HookScript("OnShow", function(self)
	if isFishing or not GoFishDB or not GoFishDB.ActivateOnMouseover or not okparents[self:GetOwner()] then return end

	local text = GameTooltipTextLeft1:GetText()

	if not text or not F[text]
	or (IsMounted() and not (UnitBuff("player", FROSTWOLF_WAR_WOLF) or UnitBuff("player", TELAARI_TALBUK)))
	or IsInCombat()
	or C_PetBattles.IsInBattle()
	or UnitInVehicle("player")
	or UnitIsDeadOrGhost("player")
	or not allowedForms[GetShapeshiftFormID() or 0]
	or farSight[UnitChannelInfo("player") or ""] then
		return
	end

	GoFish:EnableFishingMode()
	if not isFishing then return end

	autoStopTime = GetTime() + GoFishDB.MouseoverTimeout
	timerGroup:Play()
end)

------------------------------------------------------------------------

SLASH_GOFISH1 = "/gofish"
SlashCmdList.GOFISH = function(cmd)
	cmd = cmd and strtrim(strlower(cmd))
	if cmd == "options" then
		ns.ShowOptions()
	elseif not IsInCombat() then
		GoFish:ToggleFishingMode()
	end
end
