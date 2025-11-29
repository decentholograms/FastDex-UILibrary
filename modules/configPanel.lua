local ConfigPanelModule = {}
local TweenService = game:GetService("TweenService")

function ConfigPanelModule.Create(window, theme)
	local panel = {
		_window = window,
		_visible = false
	}

	local frame = Instance.new("Frame")
	frame.Name = "ConfigPanel"
	frame.Size = UDim2.new(0, 340, 0, 420)
	frame.Position = UDim2.new(0.5, -170, 0.5, -210)
	frame.BackgroundColor3 = theme.Background
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.ZIndex = 100
	frame.Parent = window.ScreenGui
	panel.Frame = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Border
	stroke.Thickness = 1
	stroke.Parent = frame

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 42)
	header.BackgroundColor3 = theme.Secondary
	header.BorderSizePixel = 0
	header.Parent = frame

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 10)
	headerCorner.Parent = header

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 15, 0, 0)
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Text = "Settings"
	title.TextColor3 = theme.Text
	title.TextSize = 15
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local close = Instance.new("TextButton")
	close.BackgroundTransparency = 1
	close.Size = UDim2.new(0, 30, 0, 30)
	close.Position = UDim2.new(1, -40, 0.5, -15)
	close.Text = "×"
	close.TextSize = 20
	close.Font = Enum.Font.GothamBold
	close.TextColor3 = theme.Text
	close.Parent = header

	local content = Instance.new("ScrollingFrame")
	content.Name = "Content"
	content.Position = UDim2.new(0, 12, 0, 55)
	content.Size = UDim2.new(1, -24, 1, -67)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 3
	content.ScrollBarImageColor3 = theme.Accent
	content.CanvasSize = UDim2.new(0, 0, 0, 0)
	content.Parent = frame

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 8)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = content

	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
	end)

	local function createSection(name)
		local s = Instance.new("Frame")
		s.Size = UDim2.new(1, 0, 0, 26)
		s.BackgroundTransparency = 1
		s.Parent = content

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.Text = name
		label.TextSize = 14
		label.Font = Enum.Font.GothamBold
		label.TextColor3 = theme.Accent
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.BackgroundTransparency = 1
		label.Parent = s
	end

	local function createButton(text, callback)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 36)
		b.BackgroundColor3 = theme.Secondary
		b.BorderSizePixel = 0
		b.Text = text
		b.TextSize = 13
		b.Font = Enum.Font.GothamMedium
		b.TextColor3 = theme.Text
		b.AutoButtonColor = false
		b.Parent = content

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = b

		b.MouseEnter:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.15), {
				BackgroundColor3 = theme.Accent
			}):Play()
		end)

		b.MouseLeave:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.15), {
				BackgroundColor3 = theme.Secondary
			}):Play()
		end)

		b.MouseButton1Click:Connect(callback)
	end

	createSection("Configuration")

	createButton("Save Config", function()
		window:SaveConfig()
		window._notifier:Show("Config saved", 2)
	end)

	createButton("Load Config", function()
		window:LoadConfig()
		window._notifier:Show("Config loaded", 2)
	end)

	createSection("Theme")

	for themeName in pairs(window._themeModule.GetDefaultThemes()) do
		createButton(themeName:upper(), function()
			window:SetTheme(themeName)
			window._notifier:Show("Theme: " .. themeName, 2)
		end)
	end

	createSection("Actions")

	createButton("Reset UI Position", function()
		window.Frame.Position = UDim2.new(0.5, -260, 0.5, -240)
		window._notifier:Show("Position reset", 2)
	end)

	createButton("Destroy UI", function()
		window:Destroy()
	end)

	function panel:Toggle()
		self._visible = not self._visible
		frame.Visible = true

		if self._visible then
			frame.Size = UDim2.new(0, 0, 0, 0)
			TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Back), {
				Size = UDim2.new(0, 340, 0, 420)
			}):Play()
		else
			local tween = TweenService:Create(frame, TweenInfo.new(0.2), {
				Size = UDim2.new(0, 0, 0, 0)
			})
			tween:Play()
			tween.Completed:Wait()
			frame.Visible = false
		end
	end

	close.MouseButton1Click:Connect(function()
		panel:Toggle()
	end)

	return panel
end

return ConfigPanelModule
