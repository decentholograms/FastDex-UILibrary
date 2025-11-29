local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Section = require(script.Parent.section)
local Theme = require(script.Parent.theme)
local ConfigPanel = require(script.Parent.configPanel)
local FloatingIcon = require(script.Parent.floatingIcon)

local Window = {}
Window.__index = Window

function Window.new(title, opts)
    local self = setmetatable({}, Window)

    self.Theme = Theme.GetActive()
    self.Sections = {}
    self.Minimized = false

    local screen = Instance.new("ScreenGui")
    screen.Name = title .. "_UI"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.Parent = opts.parent or game.CoreGui

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 420, 0, 420)
    main.Position = UDim2.new(0.5, -210, 0.5, -210)
    main.BackgroundColor3 = self.Theme.bg
    main.BorderSizePixel = 0
    main.Parent = screen
    self.Main = main

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 32)
    header.BackgroundColor3 = self.Theme.header
    header.BorderSizePixel = 0
    header.Parent = main

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = self.Theme.text
    titleLabel.Text = title
    titleLabel.Parent = header

    local close = Instance.new("TextButton")
    close.Name = "Close"
    close.Size = UDim2.new(0, 32, 1, 0)
    close.Position = UDim2.new(1, -32, 0, 0)
    close.BackgroundTransparency = 1
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.TextColor3 = self.Theme.text
    close.Text = "×"
    close.Parent = header

    local settings = Instance.new("TextButton")
    settings.Name = "Settings"
    settings.Size = UDim2.new(0, 32, 1, 0)
    settings.Position = UDim2.new(1, -64, 0, 0)
    settings.BackgroundTransparency = 1
    settings.Font = Enum.Font.Gotham
    settings.TextSize = 16
    settings.TextColor3 = self.Theme.text
    settings.Text = "⚙"
    settings.Parent = header

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.FillDirection = Enum.FillDirection.Vertical
    list.HorizontalAlignment = Enum.HorizontalAlignment.Left
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = main

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 40)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = main

    self.Screen = screen

    close.MouseButton1Click:Connect(function()
        FloatingIcon.Minimize(self)
    end)

    settings.MouseButton1Click:Connect(function()
        ConfigPanel.Toggle(self)
    end)

    local dragging = false
    local dragStart
    local startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local delta = UserInputService:GetMouseLocation() - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return self
end

function Window:Section(name)
    local section = Section.new(self, name)
    table.insert(self.Sections, section)
    return section
end

function Window:SetTheme(t)
    Theme.SetActive(t)
    self.Theme = Theme.GetActive()
end

function Window:Destroy()
    if self.Screen then
        self.Screen:Destroy()
    end
end

return Window
