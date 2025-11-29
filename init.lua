local FastDexUI = {
	_VERSION = "1.0.0",
	_THEMES = {},
	_INSTANCES = {}
}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local BASE_URL = "https://raw.githubusercontent.com/decentholograms/FastDex-UILibrary/main/modules/"

local function loadModule(file)
	local ok, result = pcall(function()
		return loadstring(game:HttpGet(BASE_URL .. file))()
	end)
	return ok and result or nil
end

local ThemeModule           = loadModule("theme.lua")
local WindowModule          = loadModule("window.lua")
local SectionModule         = loadModule("section.lua")
local ToggleModule          = loadModule("toggle.lua")
local SliderModule          = loadModule("slider.lua")
local DropdownModule        = loadModule("dropdown.lua")
local PlayersDropdownModule = loadModule("playersDropdown.lua")
local KeybindModule         = loadModule("keybind.lua")
local InputModule           = loadModule("input.lua")
local LabelModule           = loadModule("label.lua")
local ButtonModule          = loadModule("button.lua")
local ConfigPanelModule     = loadModule("configPanel.lua")
local FloatingIconModule    = loadModule("floatingIcon.lua")
local NotifierModule        = loadModule("notifier.lua")

if ThemeModule then
	FastDexUI._THEMES = ThemeModule.GetDefaultThemes()
end

function FastDexUI.RegisterTheme(name, data)
	if name and data then
		FastDexUI._THEMES[name] = data
	end
end

function FastDexUI.CreateUI(name, opts)
	opts = opts or {}
	local theme = opts.theme or "dark"

	if not FastDexUI._THEMES[theme] then
		theme = "dark"
	end

	local ui = WindowModule.Create(name, FastDexUI._THEMES[theme], opts)
	table.insert(FastDexUI._INSTANCES, ui)

	ui._themeModule = ThemeModule
	ui._notifier = NotifierModule.Create(ui.ScreenGui)

	ui.NewSection = function(self, title)
		return SectionModule.Create(self, title)
	end

	ui.Notify = function(self, msg, duration, persistent)
		if self._notifier then
			self._notifier:Show(msg, duration, persistent)
		end
	end

	ui.SetTheme = function(self, themeName)
		if FastDexUI._THEMES[themeName] then
			self._currentTheme = FastDexUI._THEMES[themeName]
			ThemeModule.ApplyTheme(self, self._currentTheme)
		end
	end

	return ui
end

return FastDexUI
