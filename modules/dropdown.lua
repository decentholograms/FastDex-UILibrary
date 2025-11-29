local DropdownModule = {}
local TweenService = game:GetService("TweenService")

function DropdownModule.Create(id, opts, parent, theme)
	opts = opts or {}
	local options = opts.options or {}
	local default = opts.default or (options[1] or "None")
	local callback = opts.callback or function() end

	local dropdown = {
		ID = id,
		_value = default,
		_options = options,
		_callback = callback,
		_expanded = false
	}

	local frame = Instance.new("Frame")
	frame.Name = "Dropdown_" .. id
	frame.Size = UDim2.new(1, 0, 0, 38)
	frame.BackgroundTransparency = 1
	frame.ClipsDescendants = true
	frame.Parent = parent

	local mainButton = Instance.new("TextButton")
	mainButton.Size = UDim2.new(1, 0, 0, 38)
	mainButton.BackgroundColor3 = theme.Secondary
	mainButton.BorderSizePixel = 0
	mainButton.Text = ""
	mainButton.AutoButtonColor = false
	mainButton.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = mainButton

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Border
	stroke.Thickness = 1
	stroke.Parent = mainButton

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -40, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = default
	label.TextColor3 = theme.Text
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = mainButton

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 22, 1, 0)
	arrow.Position = UDim2.new(1, -28, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = theme.SubText
	arrow.TextSize = 12
	arrow.Font = Enum.Font.GothamBold
	arrow.Parent = mainButton

	local optionsFrame = Instance.new("ScrollingFrame")
	optionsFrame.Size = UDim2.new(1, 0, 0, 0)
	optionsFrame.Position = UDim2.new(0, 0, 0, 40)
	optionsFrame.BackgroundColor3 = theme.Secondary
	optionsFrame.BorderSizePixel = 0
	optionsFrame.ScrollBarThickness = 3
	optionsFrame.ScrollBarImageColor3 = theme.Accent
	optionsFrame.Visible = false
	optionsFrame.ClipsDescendants = true
	optionsFrame.Parent = frame

	local optionsCorner = Instance.new("UICorner")
	optionsCorner.CornerRadius = UDim.new(0, 6)
	optionsCorner.Parent = optionsFrame

	local optionsStroke = Instance.new("UIStroke")
	optionsStroke.Color = theme.Border
	optionsStroke.Thickness = 1
	optionsStroke.Parent = optionsFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 3)
	listLayout.Parent = optionsFrame

	local function collapse()
		dropdown._expanded = false

		TweenService:Create(optionsFrame, TweenInfo.new(0.20), {
			Size = UDim2.new(1, 0, 0, 0)
		}):Play()

		TweenService:Create(arrow, TweenInfo.new(0.20), {
			Rotation = 0
		}):Play()

		task.delay(0.18, function()
			optionsFrame.Visible = false
			frame.Size = UDim2.new(1, 0, 0, 38)
		end)
	end

	local function expand()
		dropdown._expanded = true
		optionsFrame.Visible = true

		local targetHeight = math.min(#dropdown._options * 32, 150)

		frame.Size = UDim2.new(1, 0, 0, 40 + targetHeight)

		TweenService:Create(optionsFrame, TweenInfo.new(0.20), {
			Size = UDim2.new(1, 0, 0, targetHeight)
		}):Play()

		TweenService:Create(arrow, TweenInfo.new(0.20), {
			Rotation = 180
		}):Play()
	end

	mainButton.MouseButton1Click:Connect(function()
		if dropdown._expanded then
			collapse()
		else
			expand()
		end
	end)

	local function buildOptions()
		optionsFrame:ClearAllChildren()
		listLayout.Parent = optionsFrame

		for _, option in ipairs(dropdown._options) do
			local optionBtn = Instance.new("TextButton")
			optionBtn.Size = UDim2.new(1, -4, 0, 30)
			optionBtn.BackgroundColor3 = theme.Background
			optionBtn.BorderSizePixel = 0
			optionBtn.Text = option
			optionBtn.TextColor3 = theme.Text
			optionBtn.TextSize = 12
			optionBtn.Font = Enum.Font.Gotham
			optionBtn.AutoButtonColor = false
			optionBtn.Parent = optionsFrame

			local oc = Instance.new("UICorner")
			oc.CornerRadius = UDim.new(0, 4)
			oc.Parent = optionBtn

			optionBtn.MouseEnter:Connect(function()
				TweenService:Create(optionBtn, TweenInfo.new(0.12), {
					BackgroundColor3 = theme.Border
				}):Play()
			end)

			optionBtn.MouseLeave:Connect(function()
				TweenService:Create(optionBtn, TweenInfo.new(0.12), {
					BackgroundColor3 = theme.Background
				}):Play()
			end)

			optionBtn.MouseButton1Click:Connect(function()
				dropdown._value = option
				label.Text = option
				callback(option)
				collapse()
			end)
		end
	end

	buildOptions()

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		optionsFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
	end)

	function dropdown:SetValue(value)
		self._value = value
		label.Text = value
	end

	function dropdown:GetValue()
		return self._value
	end

	function dropdown:SetOptions(list)
		self._options = list
		buildOptions()
	end

	return dropdown
end

return DropdownModule
