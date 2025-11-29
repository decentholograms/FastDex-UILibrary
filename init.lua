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

local BASE_URL = "https://raw.githubusercontent.com/decentholograms/FastDex-UILibrary/blob/main/"

local function loadModule(path)
	local success, result = pcall(function()
		return loadstring(game:HttpGet(BASE_URL .. path))()
	end)
	if success then
		return result
	else
		warn("Failed to load module: " .. path)
		return nil
	end
end

local ThemeModule = loadModule("modules/theme.lua")
local WindowModule = loadModule("modules/window.lua")
local NotifierModule = loadModule("modules/notifier.lua")

if ThemeModule then
	FastDexUI._THEMES = ThemeModule.GetDefaultThemes()
end

function FastDexUI.RegisterTheme(name, themeData)
	if not name or not themeData then return end
	FastDexUI._THEMES[name] = themeData
end

function FastDexUI.CreateUI(name, opts)
	opts = opts or {}
	local theme = opts.theme or "dark"
	
	if not FastDexUI._THEMES[theme] then
		theme = "dark"
	end
	
	local instance = WindowModule.Create(name, FastDexUI._THEMES[theme], opts)
	table.insert(FastDexUI._INSTANCES, instance)
	
	instance._themeModule = ThemeModule
	instance._notifier = NotifierModule.Create(instance.ScreenGui)
	
	instance.SetTheme = function(self, themeName)
		if FastDexUI._THEMES[themeName] then
			self._currentTheme = FastDexUI._THEMES[themeName]
			ThemeModule.ApplyTheme(self, self._currentTheme)
		end
	end
	
	instance.Notify = function(self, message, duration, persistent)
		if self._notifier then
			self._notifier:Show(message, duration, persistent)
		end
	end
	
	return instance
end

return FastDexUI


