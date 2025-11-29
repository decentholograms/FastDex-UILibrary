local ButtonModule = {}
local TweenService = game:GetService("TweenService")

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
	
	local btnFrame = Instance.new("TextButton")
	btnFrame.Size = UDim2.new(1, 0, 1, 0)
	btnFrame.BackgroundColor3 = theme.Accent
	btnFrame.BorderSizePixel = 0
	btnFrame.Text = text
	btnFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnFrame.TextSize = 14
	btnFrame.Font = Enum.Font.GothamBold
	btnFrame.AutoButtonColor = false
	btnFrame.Parent = frame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btnFrame
	
	btnFrame.MouseEnter:Connect(function()
		TweenService:Create(btnFrame, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(
				math.clamp(theme.Accent.R * 255 + 20, 0, 255),
				math.clamp(theme.Accent.G * 255 + 20, 0, 255),
				math.clamp(theme.Accent.B * 255 + 20, 0, 255)
			)
		}):Play()
	end)
	
	btnFrame.MouseLeave:Connect(function()
		TweenService:Create(btnFrame, TweenInfo.new(0.15), {
			BackgroundColor3 = theme.Accent
		}):Play()
	end)
	
	btnFrame.MouseButton1Click:Connect(function()
		callback()
	end)
	
	return button
end

return ButtonModule
