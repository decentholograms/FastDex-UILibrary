local NotifierModule = {}
local TweenService = game:GetService("TweenService")

function NotifierModule.Create(parent)
	local n = {}
	n._list = {}

	local container = Instance.new("Frame")
	container.Name = "notif_container"
	container.Size = UDim2.new(0, 300, 1, -20)
	container.Position = UDim2.new(1, -310, 0, 10)
	container.BackgroundTransparency = 1
	container.Parent = parent
	n._c = container

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = container

	function n:Show(msg, time, sticky)
		time = time or 3

		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 0)
		f.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
		f.BackgroundTransparency = 1
		f.BorderSizePixel = 0
		f.Parent = container

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = f

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(90, 110, 255)
		stroke.Thickness = 2
		stroke.Transparency = 1
		stroke.Parent = f

		local pad = Instance.new("UIPadding")
		pad.PaddingTop = UDim.new(0, 12)
		pad.PaddingBottom = UDim.new(0, 12)
		pad.PaddingLeft = UDim.new(0, 14)
		pad.PaddingRight = UDim.new(0, 14)
		pad.Parent = f

		local text = Instance.new("TextLabel")
		text.BackgroundTransparency = 1
		text.Size = UDim2.new(1, sticky and -25 or 0, 1, 0)
		text.Text = msg
		text.TextColor3 = Color3.new(1, 1, 1)
		text.TextSize = 13
		text.Font = Enum.Font.Gotham
		text.TextWrapped = true
		text.TextXAlignment = Enum.TextXAlignment.Left
		text.TextYAlignment = Enum.TextYAlignment.Top
		text.Parent = f

		local h = text.TextBounds.Y + 24

		if sticky then
			local cbtn = Instance.new("TextButton")
			cbtn.BackgroundTransparency = 1
			cbtn.Size = UDim2.new(0, 20, 0, 20)
			cbtn.Position = UDim2.new(1, -20, 0, 0)
			cbtn.Font = Enum.Font.GothamBold
			cbtn.Text = "✕"
			cbtn.TextSize = 14
			cbtn.TextColor3 = Color3.fromRGB(200, 200, 200)
			cbtn.Parent = f

			cbtn.MouseButton1Click:Connect(function()
				self:Remove(f)
			end)
		end

		TweenService:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
			Size = UDim2.new(1, 0, 0, h),
			BackgroundTransparency = 0
		}):Play()

		TweenService:Create(stroke, TweenInfo.new(0.25), { Transparency = 0 }):Play()

		table.insert(self._list, f)

		if not sticky then
			task.delay(time, function()
				self:Remove(f)
			end)
		end
	end

	function n:Remove(f)
		if not f or not f.Parent then return end

		local s = f:FindFirstChildOfClass("UIStroke")

		TweenService:Create(f, TweenInfo.new(0.2), {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1
		}):Play()

		if s then
			TweenService:Create(s, TweenInfo.new(0.2), { Transparency = 1 }):Play()
		end

		task.delay(0.23, function()
			f:Destroy()
			for i, v in ipairs(self._list) do
				if v == f then table.remove(self._list, i) break end
			end
		end)
	end

	return n
end

return NotifierModule
