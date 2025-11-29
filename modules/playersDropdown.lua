local PlayersDropdownModule = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

function PlayersDropdownModule.Create(parent, label, callback, theme)
	local dropdown = {
		_open = false,
		_items = {},
		_callback = callback
	}

	local holder = Instance.new("Frame")
	holder.Name = "PlayersDropdown"
	holder.Size = UDim2.new(1, -20, 0, 40)
	holder.BackgroundColor3 = theme.Background
	holder.BorderSizePixel = 0
	holder.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = holder

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Border
	stroke.Thickness = 1
	stroke.Parent = holder

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -40, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = label
	title.TextColor3 = theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.Gotham
	title.TextSize = 14
	title.Parent = holder

	local arrow = Instance.new("TextLabel")
	arrow.Name = "Arrow"
	arrow.Size = UDim2.new(0, 35, 1, 0)
	arrow.Position = UDim2.new(1, -35, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = theme.Text
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 14
	arrow.Parent = holder

	local listFrame = Instance.new("Frame")
	listFrame.Name = "List"
	listFrame.Size = UDim2.new(1, 0, 0, 0)
	listFrame.Position = UDim2.new(0, 0, 1, 0)
	listFrame.BackgroundColor3 = theme.Background2
	listFrame.BorderSizePixel = 0
	listFrame.ClipsDescendants = true
	listFrame.Parent = holder

	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 6)
	listCorner.Parent = listFrame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 2)
	layout.Parent = listFrame

	local function refresh()
		for _, v in pairs(dropdown._items) do
			v:Destroy()
		end
		dropdown._items = {}

		for _, plr in ipairs(Players:GetPlayers()) do
			local item = Instance.new("TextButton")
			item.Name = plr.Name
			item.Size = UDim2.new(1, -10, 0, 28)
			item.Position = UDim2.new(0, 5, 0, 0)
			item.BackgroundColor3 = theme.Secondary
			item.TextColor3 = theme.Text
			item.Text = plr.Name
			item.Font = Enum.Font.Gotham
			item.TextSize = 13
			item.AutoButtonColor = true
			item.Parent = listFrame

			table.insert(dropdown._items, item)

			item.MouseButton1Click:Connect(function()
				dropdown._callback(plr)
				dropdown._open = false
				TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
				arrow.Text = "▼"
			end)
		end
	end

	local function toggle()
		dropdown._open = not dropdown._open

		if dropdown._open then
			refresh()
			local height = (#dropdown._items * 30) + 8
			TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, height)}):Play()
			arrow.Text = "▲"
		else
			TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
			arrow.Text = "▼"
		end
	end

	holder.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			toggle()
		end
	end)

	Players.PlayerAdded:Connect(function()
		if dropdown._open then
			refresh()
		end
	end)

	Players.PlayerRemoving:Connect(function()
		if dropdown._open then
			refresh()
		end
	end)

	return dropdown
end

return PlayersDropdownModule
