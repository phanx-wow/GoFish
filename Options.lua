--[[--------------------------------------------------------------------
	GoFish
	Click-cast fishing and enhanced fishing sounds.
	Copyright (c) 2013-2017 Phanx <addons@phanx.net>. All rights reserved.
	Maintained by Akkorian <armordecai@protonmail.com>
	https://github.com/phanx-wow/GoFish
	https://mods.curse.com/addons/wow/gofish
	https://www.wowinterface.com/downloads/info22270-GoFish.html
----------------------------------------------------------------------]]
-- Double-click time 0.2 - 0.6 x 0.05
-- Mouseover timeout 5 - 60 x 5

local ADDON, ns = ...
local L = ns.L

local SOUND_OFF = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
local SOUND_ON = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON

local Options = CreateFrame("Frame", "GoFishOptions", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
InterfaceOptions_AddCategory(Options)

function ns.ShowOptions()
	InterfaceOptionsFrame_OpenToCategory(Options)
end

Options:Hide()
Options:SetScript("OnShow", function(self)
	local Title = self:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
	Title:SetPoint("TOPLEFT", 16, -16)
	Title:SetText(self.name)

	local SubText = self:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
	SubText:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
	SubText:SetPoint("RIGHT", -32, 0)
	SubText:SetHeight(32)
	SubText:SetJustifyH("LEFT")
	SubText:SetJustifyV("TOP")
	SubText:SetText(GetAddOnMetadata(ADDON, "Notes"))

	local ActivateOnMouseover = CreateFrame("CheckButton", "$parentActivateOnMouseover", self, "InterfaceOptionsCheckButtonTemplate")
	ActivateOnMouseover:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", 0, -12)
	ActivateOnMouseover.Text:SetText(L["Activate when mousing over a fish pool"])
	ActivateOnMouseover.tooltipText = L["Automatically turn on fishing mode when you mouse over a fish pool. When activated this way, fishing mode is disabled after 10 seconds if you don't cast."]
	ActivateOnMouseover:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		GoFishDB.ActivateOnMouseover = checked
	end)

	local ActivateOnEquip = CreateFrame("CheckButton", "$parentActivateOnEquip", self, "InterfaceOptionsCheckButtonTemplate")
	ActivateOnEquip:SetPoint("TOPLEFT", ActivateOnMouseover, "BOTTOMLEFT", 0, -12)
	ActivateOnEquip.Text:SetText(L["Activate when equipping a fishing pole"])
	ActivateOnEquip.tooltipText = L["Automatically turn on fishing mode while you have a fishing pole equipped."]
	ActivateOnEquip:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		GoFishDB.ActivateOnEquip = checked
		if checked then
			GoFish:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
		else
			GoFish:UnregisterEvent("UNIT_INVENTORY_CHANGED")
		end
	end)

	local AutoLoot = CreateFrame("CheckButton", "$parentAutoLoot", self, "InterfaceOptionsCheckButtonTemplate")
	AutoLoot:SetPoint("TOPLEFT", ActivateOnEquip, "BOTTOMLEFT", 0, -12)
	AutoLoot.Text:SetText(L["Enable auto-loot while fishing"])
	AutoLoot.tooltipText = L["Your previous setting is restored when you leave fishing mode."]
	AutoLoot:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		GoFishDB.AutoLoot = checked
	end)

	local SoundInBG = CreateFrame("CheckButton", "$parentAutoLoot", self, "InterfaceOptionsCheckButtonTemplate")
	SoundInBG:SetPoint("TOPLEFT", AutoLoot, "BOTTOMLEFT", 0, -12)
	SoundInBG.Text:SetText(L["Enable sound in background while fishing"])
	SoundInBG.tooltipText = L["Your previous setting is restored when you leave fishing mode."]
	SoundInBG:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		GoFishDB.SoundInBG = checked
	end)

	local EnhanceSounds = CreateFrame("CheckButton", "$parentEnhanceSounds", self, "InterfaceOptionsCheckButtonTemplate")
	EnhanceSounds:SetPoint("TOPLEFT", SoundInBG, "BOTTOMLEFT", 0, -12)
	EnhanceSounds.Text:SetText(L["Enhance sound effects while fishing"])
	EnhanceSounds.tooltipText = L["To better hear the fishing bobber splash, turn Sounds up, and Music and Ambience down. Your normal sound levels are restored after fishing."]
	EnhanceSounds:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		GoFishDB.EnhanceSounds = checked
		self:refresh()
	end)

	local function MakeSlider(name)
		local Slider = CreateFrame("Slider", name, self, "OptionsSliderTemplate")
		Slider:SetWidth(200)

		Slider.low = _G[Slider:GetName().."Low"]
		Slider.low:SetPoint("TOPLEFT", Slider, "BOTTOMLEFT", 0, 0)
		Slider.low:SetFontObject(GameFontNormalSmall)
		Slider.low:Hide()

		Slider.high = _G[Slider:GetName().."High"]
		Slider.high:SetPoint("TOPRIGHT", Slider, "BOTTOMRIGHT", 0, 0)
		Slider.high:SetFontObject(GameFontNormalSmall)
		Slider.high:Hide()

		Slider.value = Slider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		Slider.value:SetPoint("BOTTOMRIGHT", Slider, "TOPRIGHT")

		Slider.text = _G[Slider:GetName().."Text"]
		Slider.text:SetFontObject(GameFontNormal)
		Slider.text:ClearAllPoints()
		Slider.text:SetPoint("BOTTOMLEFT", Slider, "TOPLEFT")
		Slider.text:SetPoint("BOTTOMRIGHT", Slider.value, "BOTTOMLEFT", -4, 0)
		Slider.text:SetJustifyH("LEFT")

		return Slider
	end

	local MasterVolume = MakeSlider("$parentMasterVolume")
	MasterVolume:SetPoint("TOPLEFT", EnhanceSounds, "BOTTOMLEFT", 4, -30)
	MasterVolume:SetMinMaxValues(0, 100)
	MasterVolume:SetValueStep(5)
	MasterVolume.low:SetText("0%")
	MasterVolume.high:SetText("100%")
	MasterVolume.text:SetText(MASTER_VOLUME)
	MasterVolume.tooltipText = L["Adjusts the master volume while fishing."]
	MasterVolume:SetScript("OnValueChanged", function(self, value)
		value = floor(value + 0.5)
		self.value:SetText(value .. "%")
		GoFishDB.CVars.Sound_MasterVolume = value / 100
	end)

	local SFXVolume = MakeSlider("$parentSFXVolume")
	SFXVolume:SetPoint("TOPLEFT", MasterVolume, "BOTTOMLEFT", 0, -30)
	SFXVolume:SetMinMaxValues(0, 100)
	SFXVolume:SetValueStep(5)
	SFXVolume.low:SetText("0%")
	SFXVolume.high:SetText("100%")
	SFXVolume.text:SetText(SOUND_VOLUME)
	SFXVolume.tooltipText = L["Adjusts the sound effect volume while fishing. For best results, turn it up."]
	SFXVolume:SetScript("OnValueChanged", function(self, value)
		value = floor(value + 0.5)
		self.value:SetText(value .. "%")
		GoFishDB.CVars.Sound_SFXVolume = value / 100
	end)

	local MusicVolume = MakeSlider("$parentMusicVolume")
	MusicVolume:SetPoint("TOPLEFT", SFXVolume, "BOTTOMLEFT", 0, -30)
	MusicVolume:SetMinMaxValues(0, 100)
	MusicVolume:SetValueStep(5)
	MusicVolume.low:SetText("0%")
	MusicVolume.high:SetText("100%")
	MusicVolume.text:SetText(MUSIC_VOLUME)
	MusicVolume.tooltipText = L["Adjusts the music volume while fishing. For best results, turn it down."]
	MusicVolume:SetScript("OnValueChanged", function(self, value)
		value = floor(value + 0.5)
		self.value:SetText(value .. "%")
		GoFishDB.CVars.Sound_MusicVolume = value / 100
	end)

	local AmbienceVolume = MakeSlider("$parentAmbienceVolume")
	AmbienceVolume:SetPoint("TOPLEFT", MusicVolume, "BOTTOMLEFT", 0, -30)
	AmbienceVolume:SetMinMaxValues(0, 100)
	AmbienceVolume:SetValueStep(5)
	AmbienceVolume.low:SetText("0%")
	AmbienceVolume.high:SetText("100%")
	AmbienceVolume.text:SetText(AMBIENCE_VOLUME)
	AmbienceVolume.tooltipText = L["Adjusts the ambient sound volume while fishing. For best results, turn it down."]
	AmbienceVolume:SetScript("OnValueChanged", function(self, value)
		value = floor(value + 0.5)
		self.value:SetText(value .. "%")
		GoFishDB.CVars.Sound_AmbienceVolume = value / 100
	end)

	function self:refresh()
		ActivateOnMouseover:SetChecked(GoFishDB.ActivateOnMouseover)
		ActivateOnEquip:SetChecked(GoFishDB.ActivateOnEquip)
		AutoLoot:SetChecked(GoFishDB.AutoLoot)
		SoundInBG:SetChecked(GoFishDB.SoundInBG)

		EnhanceSounds:SetChecked(GoFishDB.EnhanceSounds)
		MasterVolume:SetEnabled(GoFishDB.EnhanceSounds)
		SFXVolume:SetEnabled(GoFishDB.EnhanceSounds)
		MusicVolume:SetEnabled(GoFishDB.EnhanceSounds)
		AmbienceVolume:SetEnabled(GoFishDB.EnhanceSounds)

		MasterVolume:SetValue(GoFishDB.CVars.Sound_MasterVolume * 100)
		SFXVolume:SetValue(GoFishDB.CVars.Sound_SFXVolume * 100)
		MusicVolume:SetValue(GoFishDB.CVars.Sound_MusicVolume * 100)
		AmbienceVolume:SetValue(GoFishDB.CVars.Sound_AmbienceVolume * 100)
	end

	self:refresh()
	self:SetScript("OnShow", nil)
end)
