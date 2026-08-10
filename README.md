# PulseHub Library

A single-file Roblox UI library using the Pulse Hub visual design from the supplied reference.

It is designed to be consumed the same way as a GitHub-hosted Roblox UI library:

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPOSITORY/main/Library.lua"
))()
```

## Files

- `Library.lua` — the reusable library
- `Example.lua` — example consumer script

## Basic API

```lua
local Window = Library:CreateWindow({
    Title = "Pulse Hub",
    Footer = "MM2 - v0.4.2",
    ToggleKeybind = Enum.KeyCode.RightShift,
})

local Combat = Window:AddTab("Combat", "✥")

local Sheriff = Combat:AddLeftSection("Sheriff", 355)

Sheriff:AddToggle("SilentAim", {
    Text = "Silent Aim",
    Default = false,

    Callback = function(Value)
        print(Value)
    end,
})

Sheriff:AddButton({
    Text = "Preview",
    Callback = function()
        print("clicked")
    end,
})
```

## Window

### `Library:CreateWindow(options)`

Options:

- `Title`
- `Footer`
- `LogoText`
- `ToggleKeybind`
- `Name`
- `DisplayOrder`

### Window methods

- `Window:AddTab(name, icon)`
- `Window:SelectTab(name)`
- `Window:Toggle()`
- `Window:Show()`
- `Window:Hide()`
- `Window:Notify(options)`
- `Window:Destroy()`

## Tabs

```lua
local Tab = Window:AddTab("Combat", "✥")

local Left = Tab:AddLeftSection("Sheriff", 355)
local Right = Tab:AddRightSection("Murder", 430)
```

Both sections are independent and appear in the two-column layout.

## Sections

### Toggle

```lua
local Toggle = Section:AddToggle("SilentAim", {
    Text = "Silent Aim",
    Default = false,

    Callback = function(Value)
        -- your code
    end,
})

Toggle:Set(true)
Toggle:Get()
```

### Button

```lua
Section:AddButton({
    Text = "Preview Shot",

    Callback = function()
        -- your code
    end,
})
```

### Dropdown

```lua
Section:AddDropdown("ShotSound", {
    Text = "Shot Sound",
    Values = {"Silence", "Default", "Custom"},
    Default = "Silence",

    Callback = function(Value)
        print(Value)
    end,
})
```

### Label

```lua
Section:AddLabel("Custom Sounds")
```

## Tab switching

The library handles tab switching internally:

```lua
Window:SelectTab("Visuals")
```

Only the selected tab's page is visible.

## GitHub

Upload `Library.lua` to the root of a GitHub repository. Once committed, your consumer scripts can use the raw file URL.

Example:

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/Library.lua"
))()
```

Replace `USERNAME/REPOSITORY` with your own repository.
