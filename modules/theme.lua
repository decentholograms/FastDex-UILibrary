local ThemeModule = {}

function ThemeModule.GetDefaultThemes()
	return {
		dark = {
			Background = Color3.fromRGB(20, 20, 25),
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
	local function apply(e)
		if e:IsA("Frame") or e:IsA("ScrollingFrame") then
			if e.Name:lower():match("main") or e.Name:lower():match("background") then
				e.BackgroundColor3 = theme.Background
			else
				e.BackgroundColor3 = theme.Secondary
			end
			if e:FindFirstChild("UIStroke") then e.UIStroke.Color = theme.Border end
		elseif e:IsA("TextLabel") or e:IsA("TextButton") then
			e.TextColor3 = theme.Text
		end
		for _, v in ipairs(e:GetChildren()) do apply(v) end
	end
	if instance.Frame then apply(instance.Frame) end
	instance._currentTheme = theme
end

return ThemeModule
