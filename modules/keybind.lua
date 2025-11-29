local KeybindModule = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function KeybindModule.Create(id, opts, parent, theme)
	opts = opts or {}
	local default = opts.default or "None"
	local callback = opts.callback or function() end
	
	local keybind = {
		ID = id,
		_value = default,
		_callback = callback,
		_listening = false,
		_connection = nil
	}
	
	local frame = Instance.new("Frame")
	frame.Name = "Keybind_" .. id
	frame.Size = UDim2.new(1, 0, 0, 36)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = id
	label.TextColor3 = theme.Text
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	
	local keybindBtn = Instance.new("TextButton")
	keybindBtn.Size = UDim2.new(0.35, 0, 0, 30)
	keybindBtn.Position = UDim2.new(0.65, 0, 0.5, -15)
	keybindBtn.BackgroundColor3 = theme.Secondary
	keybindBtn.BorderSizePixel = 0
	keybindBtn.Text = default
	keybindBtn.TextColor3 = theme.Text
	keybindBtn.TextSize = 12
	keybindBtn.Font = Enum.Font.GothamBold
	keybindBtn.AutoButtonColor = false
	keybindBtn.Parent = frame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = keybindBtn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Border
	stroke.Thickness = 1
	stroke.Parent = keybindBtn
	
	local function stopListening()
		keybind._listening = false
		keybindBtn.Text = keybind._value
		TweenService:Create(keybindBtn, TweenInfo.new(0.15), {
			BackgroundColor3 = theme.Secondary
		}):Play()
		if keybind._connection then
			keybind._connection:Disconnect()
			keybind._connection = nil
		end
	end
	
	keybindBtn.MouseButton1Click:Connect(function()
		if keybind._listening then
			stopListening()
			return
		end
		
		keybind._listening = true
		keybindBtn.Text = "..."
		TweenService:Create(keybindBtn, TweenInfo.new(0.15), {
			BackgroundColor3 = theme.Accent
		}):Play()
		
		keybind._connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local keyName = input.KeyCode.Name
				keybind._value = keyName
				callback(keyName)
				stopListening()
			end
		end)
	end)
	
	function keybind:SetValue(value)
		self._value = value
		if not self._listening then
			keybindBtn.Text = value
		end
	end
	
	function keybind:GetValue()
		return self._value
	end
	
	function keybind:Destroy()
		stopListening()
	end
	
	return keybind
end

return KeybindModule
