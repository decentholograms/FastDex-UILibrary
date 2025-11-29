# FastDexUI

A complete, modern, and lightweight UI library for Roblox (Luau) that loads directly from GitHub.

## Features

- 🚀 **Zero Dependencies** - Pure Luau implementation
- 📦 **Direct GitHub Loading** - No need to copy files manually
- 🎨 **Multiple Themes** - Dark, Light, and Midnight themes included
- ⚙️ **Config Panel** - Built-in settings management
- 🔔 **Notification System** - Temporary and persistent notifications
- 👥 **Real-time Players Dropdown** - Auto-updates with player joins/leaves
- 🎯 **Floating Icon** - Minimizes to draggable floating button
- 💾 **Save/Load Configs** - Persistent configuration storage
- 🎹 **Keybind Support** - Global and component-level keybinds
- ⚡ **Performance Optimized** - Event-driven, no heavy loops

## Installation

Load FastDexUI directly from GitHub:

```lua
local FastDexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/decentholograms/FastDex-UILibrary/refs/heads/main/init.lua"))()
```

## Quick Start

```lua
local FastDexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/decentholograms/FastDex-UILibrary/refs/heads/main/init.lua"))()

local ui = FastDexUI.CreateUI("My Panel", { theme = "dark" })

local mainSection = ui:Section("Main")

mainSection:AddToggle("auto_farm", {
    text = "Auto Farm",
    default = false,
    callback = function(value)
        print("Auto Farm:", value)
    end
})

mainSection:AddSlider("speed", {
    min = 0,
    max = 200,
    default = 60,
    suffix = " WS",
    callback = function(value)
        print("Speed:", value)
    end
})

mainSection:AddPlayersDropdown("target", function(player)
    print("Selected:", player.Name)
end)

ui:BindKey("RightShift", function()
    ui:SaveConfig()
    ui:Notify("Config saved!", 2)
end)
```

## API Reference

### Core Functions

#### `FastDexUI.CreateUI(name, opts)`
Creates a new UI instance.
- `name` (string): Window title
- `opts` (table): Configuration options
  - `theme` (string): Initial theme (default: "dark")

Returns: UI instance

#### `FastDexUI.RegisterTheme(name, themeData)`
Register a custom theme.
- `name` (string): Theme name
- `themeData` (table): Theme color configuration

### UI Instance Methods

#### `ui:Section(name)`
Creates a new section container.
- `name` (string): Section title

Returns: Section instance

#### `ui:SetTheme(themeName)`
Changes the active theme.
- `themeName` (string): Theme to apply

#### `ui:BindKey(key, callback)`
Binds a global keyboard shortcut.
- `key` (string): Key name (e.g., "RightShift")
- `callback` (function): Function to execute

#### `ui:SaveConfig()`
Saves current configuration to file.

#### `ui:LoadConfig()`
Loads configuration from file.

#### `ui:Notify(message, duration, persistent)`
Shows a notification.
- `message` (string): Notification text
- `duration` (number): Display time in seconds (default: 3)
- `persistent` (boolean): If true, requires manual close

#### `ui:Destroy()`
Completely removes the UI and cleans up all connections.

### Section Methods

#### `section:AddToggle(id, opts)`
Adds a toggle switch.
- `id` (string): Unique identifier
- `opts` (table):
  - `text` (string): Display text
  - `default` (boolean): Initial state
  - `callback` (function): Called on toggle

#### `section:AddLabel(text, opts)`
Adds a text label.
- `text` (string): Label text
- `opts` (table):
  - `size` (number): Font size
  - `accent` (boolean): Use accent color

#### `section:AddButton(id, opts)`
Adds a clickable button.
- `id` (string): Unique identifier
- `opts` (table):
  - `text` (string): Button text
  - `callback` (function): Click handler

#### `section:AddSlider(id, opts)`
Adds a slider control.
- `id` (string): Unique identifier
- `opts` (table):
  - `min` (number): Minimum value
  - `max` (number): Maximum value
  - `default` (number): Initial value
  - `suffix` (string): Value suffix (e.g., " %")
  - `callback` (function): Value change handler

#### `section:AddDropdown(id, opts)`
Adds a dropdown menu.
- `id` (string): Unique identifier
- `opts` (table):
  - `options` (table): Array of option strings
  - `default` (string): Initial selection
  - `callback` (function): Selection handler

#### `section:AddPlayersDropdown(id, callback)`
Adds a real-time updating players dropdown.
- `id` (string): Unique identifier
- `callback` (function): Player selection handler

#### `section:AddInput(id, opts)`
Adds a text input field.
- `id` (string): Unique identifier
- `opts` (table):
  - `placeholder` (string): Placeholder text
  - `default` (string): Initial value
  - `callback` (function): Enter key handler

#### `section:AddKeybind(id, opts)`
Adds a keybind selector.
- `id` (string): Unique identifier
- `opts` (table):
  - `default` (string): Initial keybind
  - `callback` (function): Key change handler

## Themes

Built-in themes:
- `dark` (default)
- `light`
- `midnight`

### Creating Custom Themes

```lua
FastDexUI.RegisterTheme("custom", {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(88, 101, 242),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 190),
    Border = Color3.fromRGB(50, 50, 60),
    Success = Color3.fromRGB(67, 181, 129),
    Warning = Color3.fromRGB(250, 166, 26),
    Error = Color3.fromRGB(237, 66, 69)
})
```

## Advanced Example

```lua
local FastDexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/FastDexCorporation/FastDexUI/main/init.lua"))()

local ui = FastDexUI.CreateUI("Advanced Panel", { theme = "dark" })

local combatSection = ui:Section("Combat")

combatSection:AddToggle("aimbot", {
    text = "Aimbot",
    default = false,
    callback = function(enabled)
        print("Aimbot:", enabled)
    end
})

combatSection:AddPlayersDropdown("target", function(player)
    print("Targeting:", player.Name)
end)

combatSection:AddSlider("fov", {
    min = 50,
    max = 360,
    default = 180,
    suffix = "°",
    callback = function(value)
        print("FOV:", value)
    end
})

local miscSection = ui:Section("Misc")

miscSection:AddInput("username", {
    placeholder = "Enter username...",
    callback = function(text)
        print("Username set to:", text)
    end
})

miscSection:AddKeybind("toggle_ui", {
    default = "RightControl",
    callback = function(key)
        print("UI keybind changed to:", key)
    end
})

miscSection:AddButton("test_notification", {
    text = "Test Notification",
    callback = function()
        ui:Notify("This is a test notification!", 3)
    end
})

ui:BindKey("F1", function()
    ui:SaveConfig()
    ui:Notify("Configuration saved!", 2)
end)

ui:BindKey("F2", function()
    ui:LoadConfig()
    ui:Notify("Configuration loaded!", 2)
end)
```

## Repository Structure

```
FastDexUI/
├── init.lua                  # Main entry point
├── README.md                 # This file
├── modules/
│   ├── window.lua           # Main window system
│   ├── section.lua          # Section container
│   ├── toggle.lua           # Toggle component
│   ├── label.lua            # Label component
│   ├── button.lua           # Button component
│   ├── slider.lua           # Slider component
│   ├── dropdown.lua         # Dropdown component
│   ├── playersDropdown.lua  # Players dropdown
│   ├── input.lua            # Text input
│   ├── keybind.lua          # Keybind selector
│   ├── theme.lua            # Theme system
│   ├── configPanel.lua      # Settings panel
│   ├── floatingIcon.lua     # Floating minimize icon
│   └── notifier.lua         # Notification system
└── assets/
    └── icons/               # Placeholder for icons
```

## Performance Notes

- All components are event-driven (no RunService loops)
- Real-time player dropdown uses `PlayerAdded`/`PlayerRemoving` events
- Automatic cleanup on `Destroy()`
- Optimized tweening for smooth animations
- Minimal memory footprint

## License

MIT License - Free to use for any project

## Support

For issues or feature requests, please open an issue on GitHub.

---

Made with ❤️ by FastDex Corporation


