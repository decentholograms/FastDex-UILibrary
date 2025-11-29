local ToggleModule = {}
local TweenService = game:GetService("TweenService")

function ToggleModule.Create(id, opts, parent, theme)
	opts = opts or {}

	local text = opts.text or id
	local default = opts.default == true
	local callback = opts.callback or function() end

	local toggle = {
		ID = id,
		_value = default,
		_callback = callback
	}

	local frame = Instance.new("Frame")
	frame.Name = "Toggle_"..id
	frame.Size = UDim2.new(1, 0, 0, 32)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	toggle.Frame = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = theme.Text
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 44, 0, 24)
	btn.Position = UDim2.new(1, -44, 0.5, -12)
	btn.BackgroundColor3 = default and theme.Success or theme.Border
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = btn

	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0,18,0,18)
	dot.Position = default and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
	dot.BackgroundColor3 = Color3.new(1,1,1)
	dot.BorderSizePixel = 0
	dot.Parent = btn

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot

	local animInfo = TweenInfo.new(0.18)

	local function update(v, animate)
		toggle._value = v

		local goalBtn = {BackgroundColor3 = v and theme.Success or theme.Border}
		local goalDot = {Position = v and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}

		if animate then
			TweenService:Create(btn, animInfo, goalBtn):Play()
			TweenService:Create(dot, animInfo, goalDot):Play()
		else
			for k,val in pairs(goalBtn) do btn[k] = val end
			for k,val in pairs(goalDot) do dot[k] = val end
		end

		callback(v)
	end

	btn.MouseButton1Click:Connect(function()
		update(not toggle._value, true)
	end)

	function toggle:SetValue(v)
		update(v, false)
	end

	function toggle:GetValue()
		return toggle._value
	end

	return toggle
end

return ToggleModule
