local WindowModule = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local BASE_URL = "https://raw.githubusercontent.com/decentholograms/FastDex-UILibrary/main/modules/"

local function loadModule(path)
	local ok, result = pcall(function()
		return loadstring(game:HttpGet(BASE_URL .. path))()
	end)
	return ok and result or nil
end

local SectionModule = loadModule("section.lua")
local ConfigPanelModule = loadModule("configPanel.lua")
local FloatingIconModule = loadModule("floatingIcon.lua")

function WindowModule.Create(name, theme, opts)
	opts = opts or {}

	local window = {
		Name = name,
		Sections = {},
		_currentTheme = theme
	}

	local player = Players.LocalPlayer

	local gui = Instance.new("ScreenGui")
	gui.Name = "FastDexUI_" .. name
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = player:WaitForChild("PlayerGui")

	window.ScreenGui = gui

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, 520, 0, 480)
	main.Position = UDim2.new(0.5, -260, 0.5, -240)
	main.BackgroundColor3 = theme.Background
	main.BorderSizePixel = 0
	main.Parent = gui

	window.Frame = main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = main

	local topbar = Instance.new("Frame")
	topbar.Name = "TopBar"
	topbar.Size = UDim2.new(1, 0, 0, 40)
	topbar.BackgroundColor3 = theme.Secondary
	topbar.Parent = main

	local drag = Instance.new("TextLabel")
	drag.Size = UDim2.new(1, -80, 1, 0)
	drag.BackgroundTransparency = 1
	drag.Text = name
	drag.TextColor3 = theme.Text
	drag.TextSize = 16
	drag.Font = Enum.Font.GothamBold
	drag.TextXAlignment = Enum.TextXAlignment.Left
	drag.Parent = topbar

	local close = Instance.new("TextButton")
	close.Text = "X"
	close.Size = UDim2.new(0, 40, 1, 0)
	close.Position = UDim2.new(1, -40, 0, 0)
	close.BackgroundTransparency = 1
	close.TextColor3 = theme.Error
	close.TextSize = 16
	close.Font = Enum.Font.GothamBold
	close.Parent = topbar

	close.MouseButton1Click:Connect(function()
		main.Visible = false
		if not window._floating then
			window._floating = FloatingIconModule.Create(gui, theme, function()
				main.Visible = true
			end)
		end
	end)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "Scroll"
	scroll.Size = UDim2.new(1, 0, 1, -40)
	scroll.Position = UDim2.new(0, 0, 0, 40)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ScrollBarThickness = 4
	scroll.BackgroundTransparency = 1
	scroll.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = scroll

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
	end)

	function window:Section(name)
		local s = SectionModule.Create(self, name, self._currentTheme, scroll)
		table.insert(self.Sections, s)
		return s
	end

	return window
end

return WindowModule
