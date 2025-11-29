local FloatingIconModule = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function FloatingIconModule.Create(parent, theme, onClick)
	local floating = {}

	local btn = Instance.new("TextButton")
	btn.Name = "FloatingIcon"
	btn.Size = UDim2.new(0, 56, 0, 56)
	btn.Position = UDim2.new(1, -80, 0, 20)
	btn.BackgroundColor3 = theme.Accent
	btn.Text = "≡"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 26
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.ZIndex = 20
	btn.Parent = parent

	floating.Frame = btn

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = btn

	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, 14, 1, 14)
	shadow.Position = UDim2.new(0, -7, 0, -7)
	shadow.BackgroundTransparency = 1
	shadow.ZIndex = 19
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.75
	shadow.ScaleType = Enum.ScaleType.Stretch
	shadow.Parent = btn

	local dragging = false
	local dragStart, startPos
	local moved = false

	local function startDrag(input)
		dragging = true
		moved = false
		dragStart = input.Position
		startPos = btn.Position
	end

	local function updateDrag(input)
		if dragging then
			local delta = input.Position - dragStart
			if delta.Magnitude > 4 then
				moved = true
			end

			btn.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end

	local function stopDrag(input)
		if dragging then
			dragging = false

			if not moved and onClick then
				onClick()
			end
		end
	end

	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			startDrag(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			updateDrag(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			stopDrag(input)
		end
	end)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 62, 0, 62)
		}):Play()

		TweenService:Create(shadow, TweenInfo.new(0.18), {
			ImageTransparency = 0.65
		}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 56, 0, 56)
		}):Play()

		TweenService:Create(shadow, TweenInfo.new(0.18), {
			ImageTransparency = 0.75
		}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		local shrink = TweenService:Create(btn, TweenInfo.new(0.08), {
			Size = UDim2.new(0, 50, 0, 50)
		})
		local grow = TweenService:Create(btn, TweenInfo.new(0.12), {
			Size = UDim2.new(0, 56, 0, 56)
		})

		shrink:Play()
		shrink.Completed:Connect(function()
			grow:Play()
		end)
	end)

	function floating:SetIcon(text)
		btn.Text = text
	end

	function floating:SetColor(color)
		btn.BackgroundColor3 = color
	end

	function floating:Destroy()
		btn:Destroy()
	end

	return floating
end

return FloatingIconModule
