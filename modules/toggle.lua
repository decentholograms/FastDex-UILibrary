local ToggleModule = {}
local TweenService = game:GetService("TweenService")

function ToggleModule.Create(id, opts, parent, theme)
	opts = opts or {}
	local text = opts.text or id
	local default = opts.default or false
	local callback = opts.callback or function() end

	local toggle = {ID = id, _value = default, _callback = callback}

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

	local c1 = Instance.new("UICorner")
	c1.CornerRadius = UDim.new(1, 0)
	c1.Parent = btn

	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0,18,0,18)
	dot.Position = default and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
	dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
	dot.BorderSizePixel = 0
	dot.Parent = btn

	local c2 = Instance.new("UICorner")
	c2.CornerRadius = UDim.new(1, 0)
	c2.Parent = dot

	local function update(v, anim)
		toggle._value = v
		if anim then
			TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = v and theme.Success or theme.Border}):Play()
			TweenService:Create(dot, TweenInfo.new(0.18), {Position = v and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
		else
			btn.BackgroundColor3 = v and theme.Success or theme.Border
			dot.Position = v and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
		end
		callback(v)
	end

	btn.MouseButton1Click:Connect(function()
		update(not toggle._value, true)
	end)

	function toggle:SetValue(v) update(v,false) end
	function toggle:GetValue() return toggle._value end

	return toggle
end

return ToggleModule
