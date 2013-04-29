--[[

Double-click time 0.2 - 0.6 x 0.05
Mouseover timeout 5 - 60 x 5

]]

local ADDON, ns = ...
local L = ns.L

L.EnhanceSounds = "Enhance sound effects while fishing"
L.EnhanceSounds_Tooltip = "To better hear the fishing bobber splash, turn Sounds up, and Music and Ambience down. Your normal sound levels are restored after fishing."
L.MasterVolume = MASTER_VOLUME
L.MasterVolume_Tooltip = "Adjusts the master volume while fishing."
L.SFXVolume = SOUND_VOLUME
L.SFXVolume_Tooltip = "Adjusts the sound effect volume while fishing."
L.MusicVolume = MUSIC_VOLUME
L.MusicVolume_Tooltip = "Adjusts the music volume while fishing."
L.AmbienceVolume = AMBIENCE_VOLUME
L.AmbienceVolume_Tooltip = "Adjusts the ambient sound volume while fishing."

local Options = CreateFrame("Frame", "GoFishOptions", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
InterfaceOptions_AddCategory(Options)

if LibStub and LibStub("LibAboutPanel", true) then
	Options.About = LibStub("LibAboutPanel").new(Options.name, ADDON)
end

function ns.ShowOptions()
	if Options.About then
		InterfaceOptionsFrame_OpenToCategory(Options.About)
	end
	InterfaceOptionsFrame_OpenToCategory(Options)
end

Options:Hide()
Options:SetScript("OnShow", function()
	local Title = Options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
	Title:SetPoint("TOPLEFT", 16, -16)
	Title:SetText(Options.name)

	local SubText = Options:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
	SubText:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
	SubText:SetPoint("RIGHT", -32, 0)
	SubText:SetHeight(32)
	SubText:SetJustifyH("LEFT")
	SubText:SetJustifyV("TOP")
	SubText:SetText(GetAddOnMetadata(ADDON, "Notes"))

	local EnhanceSounds = CreateFrame("CheckButton", "$parentEnhanceSounds", Options, "InterfaceOptionsCheckButtonTemplate")
	EnhanceSounds:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", -2, -8)
	EnhanceSounds.Text:SetText(L.EnhanceSounds)
	EnhanceSounds.tooltipText = L.EnhanceSounds_Tooltip
	EnhanceSounds:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainmenuOptionCheckBoxOff")
		GoFishDB.EnhanceSounds = checked
		Options:refresh()
	end)

	local function MakeSlider(name)
		local Slider = CreateFrame("Slider", name, Options, "OptionsSliderTemplate")
		Slider:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 6, -30)
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
	MasterVolume.text:SetText(L.MasterVolume)
	MasterVolume.tooltipText = L.MasterVolume_Tooltip
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
	SFXVolume.text:SetText(L.SFXVolume)
	SFXVolume.tooltipText = L.SFXVolume_Tooltip
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
	MusicVolume.text:SetText(L.MusicVolume)
	MusicVolume.tooltipText = L.MusicVolume_Tooltip
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
	AmbienceVolume.text:SetText(L.AmbienceVolume)
	AmbienceVolume.tooltipText = L.AmbienceVolume_Tooltip
	AmbienceVolume:SetScript("OnValueChanged", function(self, value)
		value = floor(value + 0.5)
		self.value:SetText(value .. "%")
		GoFishDB.CVars.Sound_AmbienceVolume = value / 100
	end)

	function Options:refresh()
		print("GoFishOptions refresh")
		EnhanceSounds:SetChecked(GoFishDB.EnhanceSounds)

		MasterVolume:SetEnabled(GoFishDB.EnhanceSounds)
		MasterVolume:SetValue(GoFishDB.CVars.Sound_MasterVolume * 100)

		SFXVolume:SetEnabled(GoFishDB.EnhanceSounds)
		SFXVolume:SetValue(GoFishDB.CVars.Sound_SFXVolume * 100)

		MusicVolume:SetEnabled(GoFishDB.EnhanceSounds)
		MusicVolume:SetValue(GoFishDB.CVars.Sound_MusicVolume * 100)

		AmbienceVolume:SetEnabled(GoFishDB.EnhanceSounds)
		AmbienceVolume:SetValue(GoFishDB.CVars.Sound_AmbienceVolume * 100)
	end

	Options:refresh()
	Options:SetScript("OnShow", nil)
end)