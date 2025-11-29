local FloatingIconModule = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function FloatingIconModule.Create(parent, theme, onClickCallback)
	local floatingIcon = {}
	
	local iconFrame = Instance.new("TextButton")
	iconFrame.Name = "FloatingIcon"
	iconFrame.Size = UDim2.new(0, 60, 0, 60)
	iconFrame.Position = UDim2.new(1, -80, 0, 20)
	iconFrame.BackgroundColor3 = theme.Accent
	iconFrame.BorderSizePixel = 0
	iconFrame.Text = "≡"
	iconFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconFrame.TextSize = 28
	iconFrame.Font = Enum.Font.GothamBold
	iconFrame.AutoButtonColor = false
	iconFrame.Parent = parent
	
	floatingIcon.Frame = iconFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = iconFrame
	
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, 10, 1, 10)
	shadow.Position = UDim2.new(0, -5, 0, -5)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.7
	shadow.ZIndex = iconFrame.ZIndex - 1
	shadow.Parent = iconFrame
	
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	iconFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = iconFrame.Position
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			iconFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if dragging then
				local moved = (input.Position - dragStart).Magnitude > 5
				dragging = false
				
				if not moved and onClickCallback then
					onClickCallback()
				end
			end
		end
	end)
	
	iconFrame.MouseEnter:Connect(function()
		TweenService:Create(iconFrame, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 66, 0, 66)
		}):Play()
	end)
	
	iconFrame.MouseLeave:Connect(function()
		TweenService:Create(iconFrame, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 60, 0, 60)
		}):Play()
	end)
	
	function floatingIcon:Destroy()
		iconFrame:Destroy()
	end
	
	return floatingIcon
end

return FloatingIconModule
