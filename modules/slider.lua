local UserInputService = game:GetService("UserInputService")

local Slider = {}
Slider.__index = Slider

function Slider.new(name, min, max, default, theme, callback)
	local self = setmetatable({}, Slider)

	self.Min = min or 0
	self.Max = max or 100
	self.Value = default or self.Min
	self.Callback = callback or function() end
	self.Dragging = false

	self.Frame = Instance.new("Frame")
	self.Frame.Name = name
	self.Frame.Size = UDim2.new(1, 0, 0, 40)
	self.Frame.BackgroundColor3 = theme.Background2
	self.Frame.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = self.Frame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -60, 0, 18)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = name .. ": " .. tostring(self.Value)
	title.TextColor3 = theme.Text
	title.Font = Enum.Font.Gotham
	title.TextSize = 13
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = self.Frame

	local bar = Instance.new("Frame")
	bar.Name = "Bar"
	bar.Size = UDim2.new(1, -20, 0, 6)
	bar.Position = UDim2.new(0, 10, 0, 28)
	bar.BackgroundColor3 = theme.Background3
	bar.BorderSizePixel = 0
	bar.Parent = self.Frame

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = bar

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new((self.Value - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = theme.Accent
	fill.BorderSizePixel = 0
	fill.Parent = bar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill
	
	local function update(mouseX)
		local absPos = bar.AbsolutePosition.X
		local absSize = bar.AbsoluteSize.X
		local pos = math.clamp((mouseX - absPos) / absSize, 0, 1)

		local value = math.floor(min + (max - min) * pos)
		self.Value = value

		title.Text = name .. ": " .. tostring(value)
		fill.Size = UDim2.new(pos, 0, 1, 0)

		self.Callback(value)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = true
			update(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = false
		end
	end)

	return self.Frame
end

return Slider
