local repo = "https://raw.githubusercontent.com/f2playelias-lab/XusGui/refs/heads/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Pulse Hub",
    Footer = "MM2 - v0.4.2",
    LogoText = "≈",
    ToggleKeybind = Enum.KeyCode.RightShift,
})

local Tabs = {
    Main = Window:AddTab("Main", "⚙"),
    Combat = Window:AddTab("Combat", "✥"),
    Visuals = Window:AddTab("Visuals", "◉"),
    Settings = Window:AddTab("Settings", "☷"),
}

local MainLeft = Tabs.Main:AddLeftSection("Controls", 420)
MainLeft:AddLabel("Basic controls")
MainLeft:AddToggle("ExampleToggle", {
    Text = "Example Toggle",
    Default = true,
    Callback = function(v) print("Example Toggle:", v) end,
})
MainLeft:AddToggle("SecondToggle", {
    Text = "Second Toggle",
    Default = false,
})
MainLeft:AddToggle("ThirdToggle", {
    Text = "Third Toggle",
    Default = false,
})
MainLeft:AddButton({
    Text = "Normal Button",
    Callback = function() print("Normal button clicked") end,
})
MainLeft:AddButton({
    Text = "Notification",
    Callback = function()
        Window:Notify({
            Title = "Pulse Hub",
            Content = "This is an example notification.",
            Duration = 4,
        })
    end,
})
MainLeft:AddDropdown("ExampleDropdown", {
    Text = "Example Dropdown",
    Values = {"Option 1", "Option 2", "Option 3", "Option 4"},
    Default = "Option 1",
    Callback = function(v) print("Dropdown:", v) end,
})
MainLeft:AddLabel("A polished example section with toggles, buttons and dropdowns.")

local MainRight = Tabs.Main:AddRightSection("Examples", 420)
MainRight:AddLabel("More controls")
MainRight:AddToggle("RightToggle", {
    Text = "Right Side Toggle",
    Default = false,
})
MainRight:AddDropdown("RightDropdown", {
    Text = "Select Mode",
    Values = {"Normal", "Fast", "Slow", "Custom"},
    Default = "Normal",
})
MainRight:AddButton({
    Text = "Print Example",
    Callback = function() print("Pulse Hub example") end,
})
MainRight:AddButton({
    Text = "Show Notification",
    Callback = function()
        Window:Notify({
            Title = "Example",
            Content = "Everything is working!",
            Duration = 3,
        })
    end,
})

local Sheriff = Tabs.Combat:AddLeftSection("Sheriff", 420)
Sheriff:AddLabel("Sheriff controls")
Sheriff:AddToggle("AutoPickup", {
    Text = "Auto Pickup Gun",
    Default = true,
})
Sheriff:AddToggle("SilentAim", {
    Text = "Silent Aim",
    Default = false,
})
Sheriff:AddToggle("ShowFOV", {
    Text = "Show FOV Circle",
    Default = true,
})
Sheriff:AddToggle("TeamCheck", {
    Text = "Team Check",
    Default = true,
})
Sheriff:AddDropdown("AimMode", {
    Text = "Aim Mode",
    Values = {"Closest", "FOV", "Target", "Random"},
    Default = "Closest",
})
Sheriff:AddDropdown("Hitbox", {
    Text = "Hitbox",
    Values = {"Head", "Torso", "HumanoidRootPart"},
    Default = "Head",
})
Sheriff:AddDropdown("ShotSound", {
    Text = "Shot Sound",
    Values = {"Silence", "Default", "Custom"},
    Default = "Silence",
})
Sheriff:AddButton({
    Text = "Preview Shot",
    Callback = function() print("Preview shot") end,
})

local Murder = Tabs.Combat:AddRightSection("Murder", 420)
Murder:AddLabel("Murder controls")
Murder:AddToggle("KillAura", {
    Text = "Kill Aura",
    Default = false,
})
Murder:AddToggle("AutoThrow", {
    Text = "Auto Throw Knife",
    Default = false,
})
Murder:AddToggle("KnifeAura", {
    Text = "Knife Aura",
    Default = false,
})
Murder:AddDropdown("KnifeMode", {
    Text = "Knife Mode",
    Values = {"Closest", "Random", "Crosshair"},
    Default = "Closest",
})
Murder:AddDropdown("TargetPart", {
    Text = "Target Part",
    Values = {"Head", "Torso", "Root"},
    Default = "Head",
})
Murder:AddButton({
    Text = "Test Action",
    Callback = function() print("Murder test") end,
})

local Visuals = Tabs.Visuals:AddLeftSection("Visuals", 420)
Visuals:AddLabel("Player visuals")
Visuals:AddToggle("ESP", {Text = "Player ESP", Default = false})
Visuals:AddToggle("Boxes", {Text = "ESP Boxes", Default = false})
Visuals:AddToggle("Names", {Text = "ESP Names", Default = true})
Visuals:AddToggle("Distance", {Text = "ESP Distance", Default = true})
Visuals:AddToggle("Health", {Text = "Health Bars", Default = false})
Visuals:AddDropdown("ESPMode", {
    Text = "ESP Mode",
    Values = {"2D", "Highlight", "Tracers", "Full"},
    Default = "Highlight",
})

local World = Tabs.Visuals:AddRightSection("World", 420)
World:AddLabel("World visuals")
World:AddToggle("Fullbright", {Text = "Fullbright", Default = false})
World:AddToggle("NoFog", {Text = "Remove Fog", Default = false})
World:AddToggle("NoShadows", {Text = "Remove Shadows", Default = false})
World:AddToggle("Ambient", {Text = "Custom Ambient", Default = false})
World:AddDropdown("Time", {
    Text = "Time",
    Values = {"Day", "Night", "Sunset", "Sunrise", "Custom"},
    Default = "Day",
})

local Settings = Tabs.Settings:AddLeftSection("Interface", 420)
Settings:AddLabel("Interface settings")
Settings:AddToggle("Notifications", {Text = "Notifications", Default = true})
Settings:AddToggle("UIAnimation", {Text = "UI Animations", Default = true})
Settings:AddToggle("SearchEnabled", {Text = "Search Bar", Default = true})
Settings:AddDropdown("Theme", {
    Text = "Theme",
    Values = {"Pulse", "Dark", "Midnight"},
    Default = "Pulse",
})
Settings:AddDropdown("Scale", {
    Text = "UI Scale",
    Values = {"Small", "Normal", "Large"},
    Default = "Normal",
})
Settings:AddButton({
    Text = "Show Notification",
    Callback = function()
        Window:Notify({
            Title = "Settings",
            Content = "Notification test successful.",
            Duration = 4,
        })
    end,
})

local LibraryControls = Tabs.Settings:AddRightSection("Library", 420)
LibraryControls:AddLabel("Library controls")
LibraryControls:AddButton({
    Text = "Show Window",
    Callback = function() Window:Show() end,
})
LibraryControls:AddButton({
    Text = "Toggle Window",
    Callback = function() Window:Toggle() end,
})
LibraryControls:AddButton({
    Text = "Select Main Tab",
    Callback = function() Window:SelectTab("Main") end,
})
LibraryControls:AddButton({
    Text = "Select Combat Tab",
    Callback = function() Window:SelectTab("Combat") end,
})
LibraryControls:AddButton({
    Text = "Select Visuals Tab",
    Callback = function() Window:SelectTab("Visuals") end,
})
LibraryControls:AddButton({
    Text = "Test Notification",
    Callback = function()
        Window:Notify({
            Title = "Pulse Hub",
            Content = "Library notification system is working.",
            Duration = 5,
        })
    end,
})

Window:SelectTab("Main")
