local ConfigPanelModule = {}
local TweenService = game:GetService("TweenService")

function ConfigPanelModule.Create(window, theme)
	local configPanel = {
		_window = window,
		_visible = false
	}
	
	local panelFrame = Instance.new("Frame")
	panelFrame.Name = "ConfigPanel"
	panelFrame.Size = UDim2.new(0, 340, 0, 420)
	panelFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
	panelFrame.BackgroundColor3 = theme.Background
	panelFrame.BorderSizePixel = 0
	panelFrame.Visible = false
	panelFrame.ZIndex = 100
	panelFrame.Parent = window.ScreenGui
	
	configPanel.Frame = panelFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = panelFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Border
	stroke.Thickness = 2
	stroke.Parent = panelFrame
	
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 45)
	header.BackgroundColor3 = theme.Secondary
	header.BorderSizePixel = 0
	header.Parent = panelFrame
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 10)
	headerCorner.Parent = header
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -50, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "⚙ Settings"
	title.TextColor3 = theme.Text
	title.TextSize = 16
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 35, 0, 35)
	closeBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = theme.Text
	closeBtn.TextSize = 18
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = header
	
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, -20, 1, -65)
	contentFrame.Position = UDim2.new(0, 10, 0, 55)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.ScrollBarThickness = 4
	contentFrame.ScrollBarImageColor3 = theme.Accent
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentFrame.Parent = panelFrame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = contentFrame
	
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		contentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
	end)
	
	local function createSection(name)
		local sectionFrame = Instance.new("Frame")
		sectionFrame.Size = UDim2.new(1, 0, 0, 35)
		sectionFrame.BackgroundTransparency = 1
		sectionFrame.Parent = contentFrame
		
		local sectionLabel = Instance.new("TextLabel")
		sectionLabel.Size = UDim2.new(1, 0, 1, 0)
		sectionLabel.BackgroundTransparency = 1
		sectionLabel.Text = name
		sectionLabel.TextColor3 = theme.Accent
		sectionLabel.TextSize = 14
		sectionLabel.Font = Enum.Font.GothamBold
		sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
		sectionLabel.Parent = sectionFrame
		
		local divider = Instance.new("Frame")
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Position = UDim2.new(0, 0, 1, -5)
		divider.BackgroundColor3 = theme.Border
		divider.BorderSizePixel = 0
		divider.Parent = sectionFrame
		
		return sectionFrame
	end
	
	local function createButton(text, callback)
		local btnFrame = Instance.new("TextButton")
		btnFrame.Size = UDim2.new(1, 0, 0, 38)
		btnFrame.BackgroundColor3 = theme.Secondary
		btnFrame.BorderSizePixel = 0
		btnFrame.Text = text
		btnFrame.TextColor3 = theme.Text
		btnFrame.TextSize = 13
		btnFrame.Font = Enum.Font.GothamBold
		btnFrame.AutoButtonColor = false
		btnFrame.Parent = contentFrame
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btnFrame
		
		local btnStroke = Instance.new("UIStroke")
		btnStroke.Color = theme.Border
		btnStroke.Thickness = 1
		btnStroke.Parent = btnFrame
		
		btnFrame.MouseEnter:Connect(function()
			TweenService:Create(btnFrame, TweenInfo.new(0.15), {
				BackgroundColor3 = theme.Border
			}):Play()
		end)
		
		btnFrame.MouseLeave:Connect(function()
			TweenService:Create(btnFrame, TweenInfo.new(0.15), {
				BackgroundColor3 = theme.Secondary
			}):Play()
		end)
		
		btnFrame.MouseButton1Click:Connect(callback)
		
		return btnFrame
	end
	
	createSection("Configuration")
	
	createButton("💾 Save Config", function()
		window:SaveConfig()
		if window._notifier then
			window._notifier:Show("Configuration saved successfully!", 2)
		end
	end)
	
	createButton("📂 Load Config", function()
		window:LoadConfig()
		if window._notifier then
			window._notifier:Show("Configuration loaded successfully!", 2)
		end
	end)
	
	createSection("Theme")
	
	for themeName, _ in pairs(window._themeModule and window._themeModule.GetDefaultThemes() or {}) do
		createButton("🎨 " .. themeName:upper(), function()
			window:SetTheme(themeName)
			if window._notifier then
				window._notifier:Show("Theme changed to " .. themeName, 2)
			end
		end)
	end
	
	createSection("Actions")
	
	createButton("🔄 Reset UI Position", function()
		window.Frame.Position = UDim2.new(0.5, -260, 0.5, -240)
		if window._notifier then
			window._notifier:Show("UI position reset", 2)
		end
	end)
	
	createButton("🗑 Destroy UI", function()
		window:Destroy()
	end)
	
	closeBtn.MouseButton1Click:Connect(function()
		configPanel:Toggle()
	end)
	
	function configPanel:Toggle()
		self._visible = not self._visible
		panelFrame.Visible = self._visible
		
		if self._visible then
			panelFrame.Size = UDim2.new(0, 0, 0, 0)
			panelFrame.Visible = true
			TweenService:Create(panelFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
				Size = UDim2.new(0, 340, 0, 420)
			}):Play()
		else
			TweenService:Create(panelFrame, TweenInfo.new(0.2), {
				Size = UDim2.new(0, 0, 0, 0)
			}):Play()
			task.delay(0.2, function()
				panelFrame.Visible = false
			end)
		end
	end
	
	function configPanel:Destroy()
		panelFrame:Destroy()
	end
	
	return configPanel
end

return ConfigPanelModule
