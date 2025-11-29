local NotifierModule = {}
local TweenService = game:GetService("TweenService")

function NotifierModule.Create(parent)
	local notifier = {
		_notifications = {},
		_container = nil
	}

	local container = Instance.new("Frame")
	container.Name = "NotificationContainer"
	container.Size = UDim2.new(0, 320, 1, -20)
	container.Position = UDim2.new(1, -330, 0, 10)
	container.BackgroundTransparency = 1
	container.Parent = parent
	notifier._container = container

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.Parent = container

	function notifier:Show(message, duration, persistent)
		duration = duration or 3
		persistent = persistent or false

		local notifFrame = Instance.new("Frame")
		notifFrame.Size = UDim2.new(1, 0, 0, 0)
		notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		notifFrame.BorderSizePixel = 0
		notifFrame.BackgroundTransparency = 1
		notifFrame.Parent = container

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = notifFrame

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(88, 101, 242)
		stroke.Thickness = 2
		stroke.Transparency = 1
		stroke.Parent = notifFrame

		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, 12)
		padding.PaddingBottom = UDim.new(0, 12)
		padding.PaddingLeft = UDim.new(0, 15)
		padding.PaddingRight = UDim.new(0, 15)
		padding.Parent = notifFrame

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, persistent and -30 or 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = message
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextSize = 13
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextWrapped = true
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		textLabel.Parent = notifFrame

		local finalHeight = textLabel.TextBounds.Y + 24

		if persistent then
			local closeBtn = Instance.new("TextButton")
			closeBtn.Size = UDim2.new(0, 20, 0, 20)
			closeBtn.Position = UDim2.new(1, -20, 0, 0)
			closeBtn.BackgroundTransparency = 1
			closeBtn.Text = "✕"
			closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
			closeBtn.TextSize = 14
			closeBtn.Font = Enum.Font.GothamBold
			closeBtn.Parent = notifFrame

			closeBtn.MouseButton1Click:Connect(function()
				self:Remove(notifFrame)
			end)
		end

		TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(1, 0, 0, finalHeight),
			BackgroundTransparency = 0
		}):Play()

		TweenService:Create(stroke, TweenInfo.new(0.3), {
			Transparency = 0
		}):Play()

		table.insert(self._notifications, notifFrame)

		if not persistent then
			task.delay(duration, function()
				self:Remove(notifFrame)
			end)
		end
	end

	function notifier:Remove(notifFrame)
		if not notifFrame or not notifFrame.Parent then return end

		TweenService:Create(notifFrame, TweenInfo.new(0.2), {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1
		}):Play()

		local stroke = notifFrame:FindFirstChild("UIStroke")
		if stroke then
			TweenService:Create(stroke, TweenInfo.new(0.2), {
				Transparency = 1
			}):Play()
		end

		task.delay(0.25, function()
			notifFrame:Destroy()
			for i, notif in ipairs(self._notifications) do
				if notif == notifFrame then
					table.remove(self._notifications, i)
					break
				end
			end
		end)
	end

	return notifier
end

return NotifierModule
