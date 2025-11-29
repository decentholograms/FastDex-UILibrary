local LabelModule = {}

function LabelModule.Create(text, opts, parent, theme)
	opts = opts or {}
	local size = opts.size or 13

	local frame = Instance.new("Frame")
	frame.Name = "label_" .. tostring(text)
	frame.Size = UDim2.new(1, 0, 0, 26)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = opts.accent and theme.accent or theme.subtext
	lbl.TextSize = size
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextWrapped = true
	lbl.Parent = frame

	local api = {}

	function api:SetText(t)
		lbl.Text = t
	end

	api.Frame = frame
	return api
end

return LabelModule
