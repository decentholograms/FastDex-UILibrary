local Section = {}
Section.__index = Section

function Section.new(parent, name, theme)
	local self = setmetatable({}, Section)

	self.Container = Instance.new("Frame")
	self.Container.Name = name
	self.Container.Size = UDim2.new(1, -10, 0, 40)
	self.Container.BackgroundColor3 = theme.Background2
	self.Container.BorderSizePixel = 0
	self.Container.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = self.Container

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -20, 0, 20)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = theme.Text
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = self.Container

	self.List = Instance.new("Frame")
	self.List.Name = "List"
	self.List.Size = UDim2.new(1, -20, 0, 0)
	self.List.Position = UDim2.new(0, 10, 0, 35)
	self.List.BackgroundTransparency = 1
	self.List.ClipsDescendants = false
	self.List.Parent = self.Container

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
	layout.Parent = self.List

	return self
end

function Section:AddElement(element)
	element.Parent = self.List
	self.Container.Size = UDim2.new(1, -10, 0, 35 + self.List.UIListLayout.AbsoluteContentSize.Y + 10)
	self.List.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.Container.Size = UDim2.new(1, -10, 0, 35 + self.List.UIListLayout.AbsoluteContentSize.Y + 10)
	end)
end

return Section
