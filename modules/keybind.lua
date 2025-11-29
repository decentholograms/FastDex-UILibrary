local KeybindModule = {}
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

function KeybindModule.Create(id, opts, parent, theme)
	opts = opts or {}
	local default = opts.default or "none"
	local callback = opts.callback or function() end
	
	local keybind = {
		ID = id,
		_value = default,
		_callback = callback,
		_listening = false,
		_conn = nil
	}

	local frame = Instance.new("Frame")
	frame.Name = "keybind_" .. id
	frame.Size = UDim2.new(1, 0, 0, 34)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(.55, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = id
	label.TextColor3 = theme.text
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(.4, 0, 0, 28)
	btn.Position = UDim2.new(.58, 0, .5, -14)
	btn.BackgroundColor3 = theme.secondary
	btn.BorderSizePixel = 0
	btn.Text = default
	btn.TextColor3 = theme.text
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.Parent = frame

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.border
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = btn
	
	local function stop()
		keybind._listening = false
		btn.Text = keybind._value
		ts:Create(btn, TweenInfo.new(.15), {BackgroundColor3 = theme.secondary}):Play()

		if keybind._conn then
			keybind._conn:Disconnect()
			keybind._conn = nil
		end
	end

	btn.MouseButton1Click:Connect(function()
		if keybind._listening then
			stop()
			return
		end

		keybind._listening = true
		btn.Text = "..."
		ts:Create(btn, TweenInfo.new(.15), {BackgroundColor3 = theme.accent}):Play()

		keybind._conn = uis.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local name = input.KeyCode.Name
				keybind._value = name
				callback(name)
				stop()
			end
		end)
	end)

	function keybind:SetValue(v)
		self._value = v
		if not self._listening then
			btn.Text = v
		end
	end

	function keybind:GetValue()
		return self._value
	end

	function keybind:Destroy()
		stop()
	end

	return keybind
end

return KeybindModule
