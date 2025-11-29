local PlayersDropdownModule = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

function PlayersDropdownModule.Create(parent, label, callback, theme)
	local dd = { _open = false, _items = {}, _callback = callback }

	local holder = Instance.new("Frame")
	holder.Name = "players_dd"
	holder.Size = UDim2.new(1, -20, 0, 38)
	holder.BackgroundColor3 = theme.Background
	holder.BorderSizePixel = 0
	holder.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = holder

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Border
	stroke.Parent = holder

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(.8, -10, 1, 0)
	lbl.Position = UDim2.new(0, 10, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.Text = label
	lbl.TextColor3 = theme.Text
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = holder

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 30, 1, 0)
	arrow.Position = UDim2.new(1, -30, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = theme.Text
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 14
	arrow.Parent = holder

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1, 0, 0, 0)
	list.Position = UDim2.new(0, 0, 1, 0)
	list.BackgroundColor3 = theme.Background2
	list.BorderSizePixel = 0
	list.ClipsDescendants = true
	list.Parent = holder

	local listc = Instance.new("UICorner")
	listc.CornerRadius = UDim.new(0, 6)
	listc.Parent = list

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list

	local function refresh()
		for _, v in ipairs(dd._items) do v:Destroy() end
		dd._items = {}

		for _, plr in ipairs(Players:GetPlayers()) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -10, 0, 28)
			b.Position = UDim2.new(0, 5, 0, 0)
			b.BackgroundColor3 = theme.Secondary
			b.TextColor3 = theme.Text
			b.Text = plr.Name
			b.TextSize = 13
			b.Font = Enum.Font.Gotham
			b.Parent = list

			table.insert(dd._items, b)

			b.MouseButton1Click:Connect(function()
				dd._callback(plr)
				dd._open = false
				TweenService:Create(list, TweenInfo.new(.2), { Size = UDim2.new(1, 0, 0, 0) }):Play()
				arrow.Text = "▼"
			end)
		end
	end

	local function toggle()
		dd._open = not dd._open

		if dd._open then
			refresh()
			local h = (#dd._items * 30) + 6
			TweenService:Create(list, TweenInfo.new(.2), { Size = UDim2.new(1, 0, 0, h) }):Play()
			arrow.Text = "▲"
		else
			TweenService:Create(list, TweenInfo.new(.2), { Size = UDim2.new(1, 0, 0, 0) }):Play()
			arrow.Text = "▼"
		end
	end

	holder.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			toggle()
		end
	end)

	Players.PlayerAdded:Connect(function()
		if dd._open then refresh() end
	end)

	Players.PlayerRemoving:Connect(function()
		if dd._open then refresh() end
	end)

	return dd
end

return PlayersDropdownModule
