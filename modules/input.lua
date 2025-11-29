local InputModule = {}

function InputModule.Create(id, opts, parent, theme)
	opts = opts or {}
	local placeholder = opts.placeholder or "enter text..."
	local default = opts.default or ""
	local callback = opts.callback or function() end

	local input = {
		ID = id,
		_value = default,
		_callback = callback
	}

	local frame = Instance.new("Frame")
	frame.Name = "input_" .. id
	frame.Size = UDim2.new(1, 0, 0, 34)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 1, 0)
	box.BackgroundColor3 = theme.secondary
	box.BorderSizePixel = 0
	box.Text = default
	box.PlaceholderText = placeholder
	box.TextColor3 = theme.text
	box.PlaceholderColor3 = theme.subtext
	box.TextSize = 13
	box.Font = Enum.Font.Gotham
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.ClearTextOnFocus = false
	box.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = box

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.border
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = box

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 10)
	pad.Parent = box

	box.FocusLost:Connect(function(enter)
		input._value = box.Text
		if enter then callback(box.Text) end
	end)

	function input:SetValue(v)
		self._value = v
		box.Text = v
	end

	function input:GetValue()
		return self._value
	end

	return input
end

return InputModule
