local ThemeModule = {}

function ThemeModule.GetDefaultThemes()
	return {
		dark = {
			Background = Color3.fromRGB(20, 20, 25),
			Background2 = Color3.fromRGB(25, 25, 30),
			Background3 = Color3.fromRGB(32, 32, 38),
			Secondary = Color3.fromRGB(30, 30, 35),

			Accent = Color3.fromRGB(88, 101, 242),

			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(180, 180, 190),

			Border = Color3.fromRGB(50, 50, 60),

			Success = Color3.fromRGB(67, 181, 129),
			Warning = Color3.fromRGB(250, 166, 26),
			Error = Color3.fromRGB(237, 66, 69)
		}
	}
end

function ThemeModule.ApplyTheme(instance, theme)
	if not instance or not theme then return end

	local function apply(element)
		local n = element.Name:lower()

		if element:IsA("Frame") or element:IsA("ScrollingFrame") then

			if n:find("main") then
				element.BackgroundColor3 = theme.Background

			elseif n:find("background3") or n == "bar" then
				element.BackgroundColor3 = theme.Background3

			elseif n:find("background2") or n == "list" then
				element.BackgroundColor3 = theme.Background2

			elseif n:find("fill") then
				element.BackgroundColor3 = theme.Accent

			else
				element.BackgroundColor3 = theme.Secondary
			end

			local stroke = element:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = theme.Border
			end

		elseif element:IsA("TextLabel") or element:IsA("TextButton") then
			
			if element.Name:lower():find("subtitle") then
				element.TextColor3 = theme.SubText
			else
				element.TextColor3 = theme.Text
			end

		end

		for _, child in ipairs(element:GetChildren()) do
			apply(child)
		end
	end

	if instance.Frame then
		apply(instance.Frame)
	else
		apply(instance)
	end

	instance._currentTheme = theme
end

return ThemeModule
