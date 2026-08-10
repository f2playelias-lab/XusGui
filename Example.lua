--========================================================--
-- PULSE HUB / XusGui
-- Example
--========================================================--

local repo =
    "https://raw.githubusercontent.com/f2playelias-lab/XusGui/refs/heads/main/"

local Library =
    loadstring(game:HttpGet(repo .. "Library.lua"))()

--========================================================--
-- WINDOW
--========================================================--

local Window = Library:CreateWindow({

    Title = "Pulse Hub",

    Footer = "MM2 - v0.4.2",

    LogoText = "≈",

    ToggleKeybind =
        Enum.KeyCode.RightShift,

})

--========================================================--
-- TABS
--========================================================--

local Tabs = {

    Main =
        Window:AddTab(
            "Main",
            "⚙"
        ),

    Combat =
        Window:AddTab(
            "Combat",
            "✥"
        ),

    Visuals =
        Window:AddTab(
            "Visuals",
            "◉"
        ),

    Settings =
        Window:AddTab(
            "Settings",
            "☷"
        ),

}

--========================================================--
-- MAIN
--========================================================--

local MainLeft =
    Tabs.Main:AddLeftSection(
        "Controls",
        420
    )

MainLeft:AddLabel(
    "Basic controls"
)

MainLeft:AddToggle(
    "ExampleToggle",
    {
        Text = "Example Toggle",

        Default = true,

        Callback = function(Value)

            print(
                "Example Toggle:",
                Value
            )

        end,
    }
)

MainLeft:AddToggle(
    "SecondToggle",
    {
        Text = "Second Toggle",

        Default = false,

        Callback = function(Value)

            print(
                "Second Toggle:",
                Value
            )

        end,
    }
)

MainLeft:AddToggle(
    "ThirdToggle",
    {
        Text = "Third Toggle",

        Default = false,

        Callback = function(Value)

            print(
                "Third Toggle:",
                Value
            )

        end,
    }
)

MainLeft:AddButton({

    Text = "Normal Button",

    Callback = function()

        print(
            "Normal button clicked"
        )

    end,

})

MainLeft:AddButton({

    Text = "Notification",

    Callback = function()

        Window:Notify({

            Title = "Pulse Hub",

            Content =
                "This is an example notification.",

            Duration = 4,

        })

    end,

})

MainLeft:AddDropdown(
    "ExampleDropdown",
    {

        Text = "Example Dropdown",

        Values = {

            "Option 1",
            "Option 2",
            "Option 3",
            "Option 4",

        },

        Default = "Option 1",

        Callback = function(Value)

            print(
                "Dropdown:",
                Value
            )

        end,

    }
)

MainLeft:AddLabel(
    "A polished example section with toggles, buttons and dropdowns."
)

--========================================================--
-- MAIN RIGHT
--========================================================--

local MainRight =
    Tabs.Main:AddRightSection(
        "Examples",
        420
    )

MainRight:AddLabel(
    "More controls"
)

MainRight:AddToggle(
    "RightToggle",
    {

        Text = "Right Side Toggle",

        Default = true,

        Callback = function(Value)

            print(
                "Right toggle:",
                Value
            )

        end,

    }
)

MainRight:AddDropdown(
    "SelectMode",
    {

        Text = "Select Mode",

        Values = {

            "Normal",
            "Advanced",
            "Custom",

        },

        Default = "Normal",

        Callback = function(Value)

            print(
                "Mode:",
                Value
            )

        end,

    }
)

MainRight:AddButton({

    Text = "Print Example",

    Callback = function()

        print(
            "Pulse Hub example button pressed."
        )

    end,

})

MainRight:AddButton({

    Text = "Show Notification",

    Callback = function()

        Window:Notify({

            Title = "Example",

            Content =
                "Everything is working correctly.",

            Duration = 4,

        })

    end,

})

--========================================================--
-- COMBAT
--========================================================--

local CombatLeft =
    Tabs.Combat:AddLeftSection(
        "Sheriff",
        420
    )

CombatLeft:AddLabel(
    "Sheriff controls"
)

CombatLeft:AddToggle(
    "AutoPickup",
    {

        Text = "Auto Pickup Gun",

        Default = true,

        Callback = function(Value)

            print(
                "Auto Pickup:",
                Value
            )

        end,

    }
)

CombatLeft:AddToggle(
    "SilentAim",
    {

        Text = "Silent Aim",

        Default = false,

        Callback = function(Value)

            print(
                "Silent Aim:",
                Value
            )

        end,

    }
)

CombatLeft:AddToggle(
    "AimBot",
    {

        Text = "AimBot FOV",

        Default = false,

        Callback = function(Value)

            print(
                "AimBot FOV:",
                Value
            )

        end,

    }
)

CombatLeft:AddToggle(
    "ShowFOV",
    {

        Text = "Show FOV Circle",

        Default = true,

        Callback = function(Value)

            print(
                "Show FOV:",
                Value
            )

        end,

    }
)

CombatLeft:AddDropdown(
    "AimMode",
    {

        Text = "Aim Mode",

        Values = {

            "Closest",
            "FOV",
            "Target",
            "Random",

        },

        Default = "Closest",

        Callback = function(Value)

            print(
                "Aim mode:",
                Value
            )

        end,

    }
)

CombatLeft:AddDropdown(
    "Hitbox",
    {

        Text = "Hitbox",

        Values = {

            "Head",
            "Torso",
            "HumanoidRootPart",

        },

        Default = "Head",

    }
)

--========================================================--
-- MURDER
--========================================================--

local CombatRight =
    Tabs.Combat:AddRightSection(
        "Murder",
        420
    )

CombatRight:AddLabel(
    "Murder controls"
)

CombatRight:AddToggle(
    "KillAura",
    {

        Text = "Kill Aura",

        Default = false,

        Callback = function(Value)

            print(
                "Kill Aura:",
                Value
            )

        end,

    }
)

CombatRight:AddToggle(
    "KillAll",
    {

        Text = "Kill All",

        Default = false,

        Callback = function(Value)

            print(
                "Kill All:",
                Value
            )

        end,

    }
)

CombatRight:AddToggle(
    "KillSheriff",
    {

        Text = "Kill Only Sheriff",

        Default = false,

        Callback = function(Value)

            print(
                "Kill Sheriff:",
                Value
            )

        end,

    }
)

CombatRight:AddToggle(
    "KnifeThrow",
    {

        Text = "Knife Throw",

        Default = false,

        Callback = function(Value)

            print(
                "Knife Throw:",
                Value
            )

        end,

    }
)

CombatRight:AddDropdown(
    "KnifeMode",
    {

        Text = "Knife Mode",

        Values = {

            "Closest",
            "Random",
            "Crosshair",

        },

        Default = "Closest",

    }
)

CombatRight:AddButton({

    Text = "Test Action",

    Callback = function()

        print(
            "Test action"
        )

    end,

})

--========================================================--
-- VISUALS
--========================================================--

local VisualLeft =
    Tabs.Visuals:AddLeftSection(
        "ESP",
        420
    )

VisualLeft:AddToggle(
    "ESP",
    {

        Text = "Player ESP",

        Default = false,

    }
)

VisualLeft:AddToggle(
    "Boxes",
    {

        Text = "ESP Boxes",

        Default = false,

    }
)

VisualLeft:AddToggle(
    "Names",
    {

        Text = "ESP Names",

        Default = true,

    }
)

VisualLeft:AddToggle(
    "Distance",
    {

        Text = "ESP Distance",

        Default = true,

    }
)

VisualLeft:AddDropdown(
    "ESPMode",
    {

        Text = "ESP Mode",

        Values = {

            "2D",
            "Highlight",
            "Tracers",

        },

        Default = "Highlight",

    }
)

--========================================================--
-- WORLD
--========================================================--

local VisualRight =
    Tabs.Visuals:AddRightSection(
        "World",
        420
    )

VisualRight:AddToggle(
    "Fullbright",
    {

        Text = "Fullbright",

        Default = false,

    }
)

VisualRight:AddToggle(
    "NoFog",
    {

        Text = "Remove Fog",

        Default = false,

    }
)

VisualRight:AddToggle(
    "ThirdPerson",
    {

        Text = "Third Person",

        Default = false,

    }
)

VisualRight:AddDropdown(
    "Time",
    {

        Text = "Time",

        Values = {

            "Day",
            "Night",
            "Sunset",
            "Custom",

        },

        Default = "Day",

    }
)

--========================================================--
-- SETTINGS
--========================================================--

local Settings =
    Tabs.Settings:AddLeftSection(
        "Interface",
        420
    )

Settings:AddToggle(
    "Notifications",
    {

        Text = "Notifications",

        Default = true,

    }
)

Settings:AddToggle(
    "UIAnimation",
    {

        Text = "UI Animations",

        Default = true,

    }
)

Settings:AddToggle(
    "FloatingToggle",
    {

        Text = "Floating Toggle Button",

        Default = true,

        Callback = function(Value)

            Window:SetToggleButton(
                Value
            )

        end,

    }
)

Settings:AddDropdown(
    "Theme",
    {

        Text = "Theme",

        Values = {

            "Pulse",
            "Dark",
            "Midnight",

        },

        Default = "Pulse",

    }
)

Settings:AddButton({

    Text = "Show Notification",

    Callback = function()

        Window:Notify({

            Title = "Settings",

            Content =
                "Notification test successful.",

            Duration = 4,

        })

    end,

})

--========================================================--
-- TOGGLE BUTTON DEMO
--========================================================--
-- The Library creates the floating Pulse Hub button
-- automatically.
--
-- Clicking it:
--     Opens / closes the UI
--
-- RightShift:
--     Opens / closes the UI
--
-- The button remains visible when the UI is hidden.
--========================================================--

Window:SetToggleButton(true)

--========================================================--
-- START ON MAIN
--========================================================--

Window:SelectTab("Main")
