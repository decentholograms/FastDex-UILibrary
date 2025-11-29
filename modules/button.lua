local ButtonModule = {}
local TweenService = game:GetService("TweenService")

local function brightenColor(c, amt)
	local r = math.clamp(math.floor(c.R * 255 + amt), 0, 255)
	local g = math.clamp(math.floor(c.G * 255 + amt), 0, 255)
	local b = math.clamp(math.floor(c.B * 255 + amt), 0, 255)
	return Color3.fromRGB(r, g, b)
end

function ButtonModule.Create(id, opts, parent, theme)
	opts = opts or {}
	local text = opts.text or id
	local callback = opts.callback or function() end

	local button = {
		ID = id,
		_callback = callback
	}

	local frame = Instance.new("Frame")
	frame.Name = "Button_" .. id
	frame.Size = UDim2.new(1, 0, 0, 36)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	button.Frame = frame

	local btnFrame = Instance.new("TextButton")
	btnFrame.Name = "ButtonInner"
	btnFrame.Size = UDim2.new(1, 0, 1, 0)
	btnFrame.BackgroundColor3 = theme.Accent
	btnFrame.BorderSizePixel = 0
	btnFrame.Text = text
	btnFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnFrame.TextSize = 14
	btnFrame.Font = Enum.Font.GothamBold
	btnFrame.AutoButtonColor = false
	btnFrame.Parent = frame
	button.Button = btnFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btnFrame

	local hoverColor = brightenColor(theme.Accent, 18)

	btnFrame.MouseEnter:Connect(function()
		TweenService:Create(btnFrame, TweenInfo.new(0.15), {
			BackgroundColor3 = hoverColor
		}):Play()
	end)

	btnFrame.MouseLeave:Connect(function()
		TweenService:Create(btnFrame, TweenInfo.new(0.15), {
			BackgroundColor3 = theme.Accent
		}):Play()
	end)

	btnFrame.MouseButton1Click:Connect(function()
		pcall(callback)
	end)

	return button
end

return ButtonModule
