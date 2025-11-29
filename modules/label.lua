local LabelModule = {}

function LabelModule.Create(text, opts, parent, theme)
	opts = opts or {}
	local size = opts.size or 13
	
	local frame = Instance.new("Frame")
	frame.Name = "Label"
	frame.Size = UDim2.new(1, 0, 0, 28)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = opts.accent and theme.Accent or theme.SubText
	label.TextSize = size
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = frame
	
	return {
		Frame = frame,
		SetText = function(self, newText)
			label.Text = newText
		end
	}
end

return LabelModule
