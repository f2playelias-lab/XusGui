-- Example.client.lua
-- Replace the URL with your GitHub raw Library.lua URL.

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPOSITORY/main/Library.lua"
))()

local Window = Library:CreateWindow({
    Title = "Pulse Hub",
    Footer = "MM2 - v0.4.2",
    LogoText = "≈",
    ToggleKeybind = Enum.KeyCode.RightShift,
})

local Tabs = {
    Main = Window:AddTab("Main", "⚙"),
    Combat = Window:AddTab("Combat", "✥"),
    AutoFarm = Window:AddTab("Auto Farm", "▾"),
    Teleport = Window:AddTab("Teleport", "♧"),
    Troll = Window:AddTab("Troll Fun", "•"),
    Free = Window:AddTab("Free animes", "♟"),
    Fling = Window:AddTab("Fling Players", "ϟ"),
    Visuals = Window:AddTab("Visuals", "◉"),
    Settings = Window:AddTab("Settings", "☷"),
    Server = Window:AddTab("Server", "◎"),
}

local Sheriff = Tabs.Combat:AddLeftSection("Sheriff", 355)

Sheriff:AddToggle("AutoPickupGun", {
    Text = "Auto Pickup Gun",
    Default = true,

    Callback = function(Value)
        print("Auto Pickup Gun:", Value)
    end,
})

Sheriff:AddToggle("SilentAim", {
    Text = "Silent Aim",
    Default = false,

    Callback = function(Value)
        print("Silent Aim:", Value)
    end,
})

Sheriff:AddToggle("AimBotFOV", {
    Text = "AimBot FOV",
    Default = false,
})

Sheriff:AddToggle("ShowFOV", {
    Text = "Show FOV Circle",
    Default = true,
})

Sheriff:AddDropdown("ShotSound", {
    Text = "Shot Sound",
    Values = {
        "Silence",
        "Default",
        "Custom",
    },
    Default = "Silence",

    Callback = function(Value)
        print("Shot sound:", Value)
    end,
})

Sheriff:AddButton({
    Text = "Preview Shot",

    Callback = function()
        Window:Notify({
            Title = "Pulse Hub",
            Content = "Preview button clicked.",
            Duration = 3,
        })
    end,
})

local Murder = Tabs.Combat:AddRightSection("Murder", 430)

Murder:AddToggle("KillAura", {
    Text = "Kill Aura",
    Default = false,
})

Murder:AddToggle("KillAll", {
    Text = "Kill All",
    Default = false,
})

Murder:AddToggle("KnifeThrow", {
    Text = "Knife Throw",
    Default = false,
})

local Visuals = Tabs.Visuals:AddLeftSection("Visuals", 220)

Visuals:AddToggle("ExampleVisual", {
    Text = "Example Visual",
    Default = false,

    Callback = function(Value)
        print("Visual:", Value)
    end,
})

Window:SelectTab("Combat")
