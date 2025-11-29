local FastDexUI = {
	_VERSION = "1.0.0",
	_THEMES = {},
	_INSTANCES = {}
}

local HttpService = game:GetService("HttpService")

local BASE_URL = "https://raw.githubusercontent.com/decentholograms/FastDex-UILibrary/main/modules/"

local function loadModule(file)
	local ok, result = pcall(function()
		local code = game:HttpGet(BASE_URL .. file)
		return loadstring(code)()
	end)

	if not ok then
		warn("Failed loading module:", file, result)
		return nil
	end

	if type(result) ~= "table" then
		warn("Module did not return a table:", file)
		return nil
	end

	return result
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

function FastDexUI.CreateUI(name, opts)
	opts = opts or {}

	if not WindowModule then
		error("Window module is NIL — window.lua no existe, o no retorna nada.")
	end

	if not WindowModule.Create then
		error("Window module NO TIENE 'Create' — revisá el return del archivo window.lua.")
	end

	local theme = opts.theme or "dark"
	if not FastDexUI._THEMES[theme] then
		theme = "dark"
	end

	local ui = WindowModule.Create(name, FastDexUI._THEMES[theme], opts)

	if not ui then
		error("WindowModule.Create devolvió NIL — hay errores dentro de window.lua.")
	end

	ui._themeModule = ThemeModule
	ui._notifier = NotifierModule and NotifierModule.Create and NotifierModule.Create(ui.ScreenGui)

	ui.NewSection = function(self, title)
		return SectionModule.Create(self, title)
	end

	ui.Notify = function(self, msg, duration, persistent)
		if self._notifier then
			self._notifier:Show(msg, duration, persistent)
		end
	end

	return ui
end

return FastDexUI
