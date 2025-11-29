local InputModule = {}

function InputModule.Create(id, opts, parent, theme)
	opts = opts or {}
	local placeholder = opts.placeholder or "Enter text..."
	local default = opts.default or ""
	local callback = opts.callback or function() end
	
	local input = {
		ID = id,
		_value = default,
		_callback = callback
	}
	
	local frame = Instance.new("Frame")
	frame.Name = "Input_" .. id
	frame.Size = UDim2.new(1, 0, 0, 36)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	
	local inputBox = Instance.new("TextBox")
	inputBox.Size = UDim2.new(1, 0, 1, 0)
	inputBox.BackgroundColor3 = theme.Secondary
	inputBox.BorderSizePixel = 0
	inputBox.Text = default
	inputBox.PlaceholderText = placeholder
	inputBox.TextColor3 = theme.Text
	inputBox.PlaceholderColor3 = theme.SubText
	inputBox.TextSize = 13
	inputBox.Font = Enum.Font.Gotham
	inputBox.TextXAlignment = Enum.TextXAlignment.Left
	inputBox.ClearTextOnFocus = false
	inputBox.Parent = frame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = inputBox
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Border
	stroke.Thickness = 1
	stroke.Parent = inputBox
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = inputBox
	
	inputBox.FocusLost:Connect(function(enterPressed)
		input._value = inputBox.Text
		if enterPressed then
			callback(inputBox.Text)
		end
	end)
	
	function input:SetValue(value)
		self._value = value
		inputBox.Text = value
	end
	
	function input:GetValue()
		return self._value
	end
	
	return input
end

return InputModule
