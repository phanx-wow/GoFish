--[[--------------------------------------------------------------------
	GoFish
	Click-cast fishing and enhanced fishing sounds.
	Copyright (c) 2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info22270-GoFish.html
	http://www.curse.com/addons/wow/gofish
----------------------------------------------------------------------]]

if GetLocale() ~= "ruRU" then return end
local _, ns = ...
local L, F = ns.L, ns.F

------------------------------------------------------------------------

--L.FishingModeOff = "Fishing mode {ON}"
--L.FishingModeOn = "Fishing mode {OFF}"
--L.ToggleFishingMode = "Toggle fishing mode"

--L.ActivateOnMouseover = "Activate when mousing over a fish pool"
--L.ActivateOnMouseover_Tooltip = "Automatically turn on fishing mode when you mouse over a fish poo--L. When activated this way, fishing mode is disabled after 10 seconds if you don't cast."
--L.ActivateOnEquip = "Activate when equipping a fishing pole"
--L.ActivateOnEquip_Tooltip = "Automatically turn on fishing mode while you have a fishing pole equipped."
--L.EnhanceSounds = "Enhance sound effects while fishing"
--L.EnhanceSounds_Tooltip = "To better hear the fishing bobber splash, turn Sounds up, and Music and Ambience down. Your normal sound levels are restored after fishing."
--L.MasterVolume_Tooltip = "Adjusts the master volume while fishing."
--L.SFXVolume_Tooltip = "Adjusts the sound effect volume while fishing."
--L.MusicVolume_Tooltip = "Adjusts the music volume while fishing."
--L.AmbienceVolume_Tooltip = "Adjusts the ambient sound volume while fishing."

------------------------------------------------------------------------

F["Abundant Bloodsail Wreckage"] = "Крупные обломки кораблекрушения шайки Кровавого Паруса"
F["Abundant Firefin Snapper School"] = "Крупный косяк огнеперого луциана"
F["Abundant Oily Blackmouth School"] = "Крупный косяк масляного черноротика"
F["Albino Cavefish School"] = "Косяк слепоглазок-альбиносов"
F["Algaefin Rockfish School"] = "Косяк водорослевых скорпен"
F["Blackbelly Mudfish School"] = "Косяк илистого чернобрюха"
F["Bloodsail Wreckage"] = "Обломки кораблекрушения шайки Кровавого Паруса"
F["Bloodsail Wreckage Pool"] = "Обломки кораблекрушения Кровавого Паруса"
F["Bluefish School"] = "Косяк луфаря"
F["Borean Man O' War School"] = "Косяк борейского медузника"
F["Brackish Mixed School"] = "Косяк сквернохвоста"
--F["Brew Frenzied Emperor Salmon"] = "Brew Frenzied Emperor Salmon"
--F["Crane Yolk Pool"] = "Crane Yolk Pool"
F["Deep Sea Monsterbelly School"] = "Косяк глубоководного чертобрюха"
F["Deepsea Sagefish School"] = "Косяк глубоководного шалфокуня"
F["Dragonfin Angelfish School"] = "Косяк дракоперой рыбы-ангела"
F["Emperor Salmon School"] = "Косяк императорского лосося"
F["Fangtooth Herring School"] = "Косяк сельди-батиприона"
F["Fathom Eel Swarm"] = "Стайка сажневого угря"
F["Feltail School"] = "Косяк сквернохвоста"
F["Firefin Snapper School"] = "Косяк огнеперого луциана"
F["Floating Debris"] = "Плавающий мусор"
F["Floating Debris Pool"] = "Обломки в воде"
F["Floating Shipwreck Debris"] = "Обломки кораблекрушения"
F["Floating Wreckage"] = "Плавающие обломки"
F["Floating Wreckage Pool"] = "Обломки в воде"
F["Giant Mantis Shrimp Swarm"] = "Стая гигантских раков-богомолов"
F["Glacial Salmon School"] = "Косяк ледникового лосося"
F["Glassfin Minnow School"] = "Косяк ледоспинки"
F["Golden Carp School"] = "Косяк золотистого карпа"
F["Greater Sagefish School"] = "Косяк большого шалфокуня"
F["Highland Guppy School"] = "Косяк высокогорных гуппи"
F["Highland Mixed School"] = "Смешанный косяк нагорья"
F["Imperial Manta Ray School"] = "Косяк императорского морского дьявола"
F["Jade Lungfish School"] = "Косяк нефритовой двоякодышащей рыбы"
F["Jewel Danio School"] = "Косяк бриллиантового данио"
F["Krasarang Paddlefish School"] = "Косяк красарангского веслоноса"
F["Lesser Firefin Snapper School"] = "Малый косяк огнеперого луциана"
F["Lesser Floating Debris"] = "Малый плавающий мусор"
F["Lesser Oily Blackmouth School"] = "Малый косяк масляного черноротика"
F["Lesser Sagefish School"] = "Малый косяк шалфокуня"
--F["Mixed Ocean School"] = "Mixed Ocean School"
F["Moonglow Cuttlefish School"] = "Стая каракатиц лунного сияния"
F["Mountain Trout School"] = "Косяк горной форели"
F["Muddy Churning Water"] = "Грязный водоворот"
F["Mudfish School"] = "Косяк ильной рыбы"
F["Musselback Sculpin School"] = "Косяк бычка-щитоспинки"
F["Nettlefish School"] = "Стайка медуз"
F["Oil Spill"] = "Нефтяное пятно"
F["Oily Blackmouth School"] = "Косяк масляного черноротика"
F["Patch of Elemental Water"] = "Участок стихийной воды"
F["Pool of Fire"] = "Лужа огня"
F["Pure Water"] = "Чистая вода"
F["Redbelly Mandarin School"] = "Косяк краснобрюхой мандаринки"
F["Reef Octopus Swarm"] = "Стая рифовых осьминогов"
F["Sagefish School"] = "Косяк шалфокуня"
F["School of Darter"] = "Косяк змеешейки"
F["School of Deviate Fish"] = "Косяк загадочной рыбы"
F["School of Tastyfish"] = "Косяк вкуснорыбы"
F["Schooner Wreckage"] = "Разбитая шхуна"
F["Schooner Wreckage Pool"] = "Разбитая шхуна"
F["Shipwreck Debris"] = "Обломки кораблекрушения"
F["Sparse Firefin Snapper School"] = "Небольшой косяк огнеперого луциана"
F["Sparse Oily Blackmouth School"] = "Небольшой косяк масляного черноротика"
F["Sparse Schooner Wreckage"] = "Небольшая разбитая шхуна"
F["Spinefish School"] = "Косяк иглоспинки"
F["Sporefish School"] = "Косяк спороуса"
F["Steam Pump Flotsam"] = "Обломки парового насоса"
F["Stonescale Eel Swarm"] = "Стайка каменного угря"
F["Strange Pool"] = "Странный водоем"
--F["Swarm of Panicked Paddlefish"] = "Swarm of Panicked Paddlefish"
F["Teeming Firefin Snapper School"] = "Большой косяк огнеперого луциана"
F["Teeming Floating Wreckage"] = "Большие плавающие обломки"
F["Teeming Oily Blackmouth School"] = "Большой косяк масляного черноротика"
F["Tiger Gourami School"] = "Косяк тигрового гурами"
F["Waterlogged Wreckage"] = "Плавающие обломки"
F["Waterlogged Wreckage Pool"] = "Плавающие обломки"
