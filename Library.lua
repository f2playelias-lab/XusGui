--========================================================--
-- XusGui / PulseHub Library
-- Roblox LocalPlayer UI Library
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.Version = "1.3.0"

--========================================================--
-- THEME
--========================================================--

local Theme = {
    Window = Color3.fromRGB(17, 18, 20),
    Sidebar = Color3.fromRGB(19, 20, 22),

    Panel = Color3.fromRGB(27, 28, 30),
    Panel2 = Color3.fromRGB(31, 32, 35),
    Hover = Color3.fromRGB(41, 42, 46),

    Border = Color3.fromRGB(63, 64, 69),
    BorderSoft = Color3.fromRGB(48, 49, 53),

    Text = Color3.fromRGB(238, 238, 240),
    TextSoft = Color3.fromRGB(205, 205, 209),
    TextMuted = Color3.fromRGB(145, 146, 152),

    -- GREEN ENABLED STATE
    Accent = Color3.fromRGB(48, 211, 92),

    ToggleOff = Color3.fromRGB(87, 88, 96),
    ToggleKnob = Color3.fromRGB(248, 248, 249),

    Selected = Color3.fromRGB(91, 93, 100),

    Search = Color3.fromRGB(10, 11, 13),
}

--========================================================--
-- HELPERS
--========================================================--

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 7)
    corner.Parent = object

    return corner
end

local function Stroke(object, color, transparency)
    local stroke = Instance.new("UIStroke")

    stroke.Color = color or Theme.Border
    stroke.Thickness = 1
    stroke.Transparency = transparency or 0

    stroke.Parent = object

    return stroke
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.12,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()

    return tween
end

local function Text(parent, value, size, color, font)
    return Create("TextLabel", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        Text = tostring(value or ""),
        TextSize = size or 10,
        TextColor3 = color or Theme.TextSoft,

        Font = font or Enum.Font.Gotham,

        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,

        TextWrapped = false,
    }, parent)
end

local function Button(parent, value)
    return Create("TextButton", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        Text = value or "",
        TextSize = 10,
        TextColor3 = Theme.TextSoft,

        Font = Enum.Font.Gotham,

        AutoButtonColor = false,
    }, parent)
end

--========================================================--
-- BASE ELEMENT
--========================================================--

local ElementMethods = {}

function ElementMethods:SetVisible(value)
    self.Container.Visible = value == true
    return self
end

function ElementMethods:SetDisabled(value)
    self.Disabled = value == true

    if self.Label then
        self.Label.TextTransparency = self.Disabled and 0.5 or 0
    end

    return self
end

--========================================================--
-- TOGGLE
--========================================================--

local ToggleMethods = {}

setmetatable(ToggleMethods, {
    __index = ElementMethods
})

function ToggleMethods:SetValue(value, fireCallback)
    self.Value = value == true

    if self.Value then

        --========================================--
        -- ENABLED = GREEN
        --========================================--

        Tween(self.Track, {
            BackgroundColor3 = Theme.Accent,
        }, 0.12)

        Tween(self.Knob, {
            Position = UDim2.new(1, -20, 0, 2),
        }, 0.12)

    else

        --========================================--
        -- DISABLED = GREY
        --========================================--

        Tween(self.Track, {
            BackgroundColor3 = Theme.ToggleOff,
        }, 0.12)

        Tween(self.Knob, {
            Position = UDim2.new(0, 3, 0, 2),
        }, 0.12)

    end

    if fireCallback ~= false and self.Callback then
        self.Callback(self.Value)
    end

    return self
end

function ToggleMethods:GetValue()
    return self.Value
end

ToggleMethods.Set = ToggleMethods.SetValue
ToggleMethods.Get = ToggleMethods.GetValue

--========================================================--
-- DROPDOWN
--========================================================--

local DropdownMethods = {}

setmetatable(DropdownMethods, {
    __index = ElementMethods
})

function DropdownMethods:SetValue(value, fireCallback)
    self.Value = value

    self.Button.Text = tostring(value) .. "  ﹀"

    if fireCallback ~= false and self.Callback then
        self.Callback(value)
    end

    return self
end

function DropdownMethods:GetValue()
    return self.Value
end

DropdownMethods.Set = DropdownMethods.SetValue
DropdownMethods.Get = DropdownMethods.GetValue

--========================================================--
-- SECTION
--========================================================--

local SectionMethods = {}

function SectionMethods:AddLabel(value)

    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, self.Container)

    local label = Text(
        row,
        value,
        9,
        Theme.TextMuted,
        Enum.Font.Gotham
    )

    label.Position = UDim2.fromOffset(2, 0)
    label.Size = UDim2.new(1, -4, 1, 0)

    label.TextWrapped = true

    return label
end

function SectionMethods:AddToggle(id, options)

    options = options or {}

    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, self.Container)

    local label = Text(
        row,
        options.Text or id,
        10,
        Theme.TextSoft,
        Enum.Font.Gotham
    )

    label.Position = UDim2.fromOffset(2, 0)
    label.Size = UDim2.new(1, -90, 1, 0)

    --========================================--
    -- SWITCH
    --========================================--

    local track = Button(row, "")

    track.Size = UDim2.fromOffset(43, 22)
    track.Position = UDim2.new(1, -43, 0, 8)

    track.BackgroundTransparency = 0

    -- DEFAULT STATE
    if options.Default == true then
        track.BackgroundColor3 = Theme.Accent
    else
        track.BackgroundColor3 = Theme.ToggleOff
    end

    Corner(track, 11)

    --========================================--
    -- KNOB
    --========================================--

    local knob = Create("Frame", {
        Size = UDim2.fromOffset(18, 18),

        Position = options.Default == true
            and UDim2.new(1, -20, 0, 2)
            or UDim2.new(0, 3, 0, 2),

        BackgroundColor3 = Theme.ToggleKnob,

        BorderSizePixel = 0,
    }, track)

    Corner(knob, 10)

    --========================================--
    -- OBJECT
    --========================================--

    local toggle = setmetatable({

        Type = "Toggle",

        ID = id,

        Container = row,

        Label = label,

        Track = track,

        Knob = knob,

        Value = options.Default == true,

        Callback = options.Callback,

        Disabled = false,

    }, {
        __index = ToggleMethods
    })

    --========================================--
    -- CLICK
    --========================================--

    track.MouseButton1Click:Connect(function()

        if toggle.Disabled then
            return
        end

        toggle:SetValue(
            not toggle.Value,
            true
        )

    end)

    self.Elements[id] = toggle

    return toggle
end

function SectionMethods:AddButton(options)

    if type(options) == "string" then
        options = {
            Text = options
        }
    end

    options = options or {}

    local button = Button(
        self.Container,
        options.Text or "Button"
    )

    button.Size = UDim2.new(1, 0, 0, 34)

    button.BackgroundTransparency = 0
    button.BackgroundColor3 = Theme.Panel2

    button.TextColor3 = Theme.TextSoft
    button.TextSize = 10

    button.Font = Enum.Font.Gotham

    Corner(button, 7)
    Stroke(button, Theme.BorderSoft, 0.25)

    button.MouseEnter:Connect(function()

        Tween(button, {
            BackgroundColor3 = Theme.Hover
        })

    end)

    button.MouseLeave:Connect(function()

        Tween(button, {
            BackgroundColor3 = Theme.Panel2
        })

    end)

    button.MouseButton1Click:Connect(function()

        if options.Callback then
            options.Callback()
        end

    end)

    local element = setmetatable({

        Type = "Button",

        ID = options.Text or "Button",

        Container = button,

        Label = button,

        Callback = options.Callback,

        Disabled = false,

    }, {
        __index = ElementMethods
    })

    self.Elements[options.Text or "Button"] = element

    return element
end

function SectionMethods:AddDropdown(id, options)

    options = options or {}

    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,
    }, self.Container)

    local label = Text(
        row,
        options.Text or id,
        9,
        Theme.TextSoft,
        Enum.Font.Gotham
    )

    label.Position = UDim2.fromOffset(2, 0)
    label.Size = UDim2.new(1, -115, 1, 0)

    local values = options.Values or {}

    local current =
        options.Default
        or values[1]
        or ""

    local dropdown = Button(row, "")

    dropdown.Size = UDim2.fromOffset(108, 28)

    dropdown.Position =
        UDim2.new(1, -108, 0, 5)

    dropdown.BackgroundTransparency = 0

    dropdown.BackgroundColor3 =
        Theme.Panel2

    dropdown.Text =
        tostring(current) .. "  ﹀"

    dropdown.TextColor3 =
        Theme.TextMuted

    dropdown.TextSize = 9

    dropdown.TextXAlignment =
        Enum.TextXAlignment.Right

    Corner(dropdown, 6)

    --========================================--
    -- DROPDOWN MENU
    --========================================--

    local menu = Create("Frame", {

        Position = UDim2.new(0, 0, 1, 3),

        Size = UDim2.new(1, 0, 0, 0),

        BackgroundColor3 =
            Theme.Panel,

        BorderSizePixel = 0,

        Visible = false,

        ZIndex = 100,

    }, dropdown)

    Corner(menu, 6)

    Stroke(
        menu,
        Theme.Border,
        0.15
    )

    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, menu)

    for index, value in ipairs(values) do

        local option = Button(
            menu,
            tostring(value)
        )

        option.LayoutOrder = index

        option.Size =
            UDim2.new(1, -6, 0, 25)

        option.Position =
            UDim2.fromOffset(3, 0)

        option.TextSize = 9

        option.TextColor3 =
            Theme.TextSoft

        option.TextXAlignment =
            Enum.TextXAlignment.Left

        option.ZIndex = 101

        option.MouseEnter:Connect(function()

            option.BackgroundTransparency = 0
            option.BackgroundColor3 =
                Theme.Hover

            Corner(option, 5)

        end)

        option.MouseLeave:Connect(function()

            option.BackgroundTransparency = 1

        end)

        option.MouseButton1Click:Connect(function()

            current = value

            dropdown.Text =
                tostring(value) .. "  ﹀"

            menu.Visible = false

            menu.Size =
                UDim2.new(1, 0, 0, 0)

            if options.Callback then
                options.Callback(value)
            end

        end)

    end

    local opened = false

    dropdown.MouseButton1Click:Connect(function()

        opened = not opened

        menu.Visible = opened

        local height =
            math.min(#values, 6) * 27

        Tween(menu, {
            Size = opened
                and UDim2.new(1, 0, 0, height)
                or UDim2.new(1, 0, 0, 0)
        }, 0.12)

    end)

    local dropdownObject = setmetatable({

        Type = "Dropdown",

        ID = id,

        Container = row,

        Label = label,

        Button = dropdown,

        Value = current,

        Callback = options.Callback,

    }, {
        __index = DropdownMethods
    })

    self.Elements[id] = dropdownObject

    return dropdownObject
end

--========================================================--
-- TAB
--========================================================--

local TabMethods = {}

function TabMethods:_CreateSection(column, title, height)

    local section = Create("Frame", {

        Size = UDim2.new(
            1,
            0,
            0,
            height or 355
        ),

        BackgroundColor3 =
            Theme.Panel,

        BorderSizePixel = 0,

    }, column)

    Corner(section, 10)

    Stroke(
        section,
        Theme.Border,
        0.28
    )

    local heading = Text(
        section,
        title,
        11,
        Theme.Text,
        Enum.Font.GothamMedium
    )

    heading.Position =
        UDim2.fromOffset(13, 0)

    heading.Size =
        UDim2.new(1, -26, 0, 38)

    local body = Create("Frame", {

        Position =
            UDim2.fromOffset(13, 38),

        Size =
            UDim2.new(1, -26, 1, -47),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

    }, section)

    Create("UIListLayout", {

        Padding =
            UDim.new(0, 1),

        SortOrder =
            Enum.SortOrder.LayoutOrder,

    }, body)

    local sectionObject = setmetatable({

        Name = title,

        Frame = section,

        Container = body,

        Elements = {},

    }, {
        __index = SectionMethods
    })

    table.insert(
        self.Sections,
        sectionObject
    )

    return sectionObject
end

function TabMethods:AddLeftSection(title, height)
    return self:_CreateSection(
        self.Left,
        title,
        height
    )
end

function TabMethods:AddRightSection(title, height)
    return self:_CreateSection(
        self.Right,
        title,
        height
    )
end

function TabMethods:AddSection(title, height)
    return self:_CreateSection(
        self.Left,
        title,
        height
    )
end

--========================================================--
-- WINDOW
--========================================================--

local WindowMethods = {}

function WindowMethods:AddTab(name, icon)

    local page = Create("Frame", {

        Position =
            UDim2.fromOffset(10, 59),

        Size =
            UDim2.new(1, -20, 1, -68),

        BackgroundTransparency = 1,

        Visible = false,

    }, self.Content)

    --========================================--
    -- SCROLL
    --========================================--

    local scroll = Create("ScrollingFrame", {

        Size = UDim2.fromScale(1, 1),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ScrollBarThickness = 2,

        ScrollBarImageColor3 =
            Theme.TextMuted,

        CanvasSize =
            UDim2.new(0, 0, 0, 0),

        AutomaticCanvasSize =
            Enum.AutomaticSize.Y,

    }, page)

    --========================================--
    -- COLUMNS
    --========================================--

    local left = Create("Frame", {

        Position =
            UDim2.fromOffset(0, 0),

        Size =
            UDim2.new(0.5, -5, 0, 600),

        BackgroundTransparency = 1,

    }, scroll)

    local right = Create("Frame", {

        Position =
            UDim2.new(0.5, 5, 0, 0),

        Size =
            UDim2.new(0.5, -5, 0, 600),

        BackgroundTransparency = 1,

    }, scroll)

    Create("UIListLayout", {

        Padding =
            UDim.new(0, 8),

        SortOrder =
            Enum.SortOrder.LayoutOrder,

    }, left)

    Create("UIListLayout", {

        Padding =
            UDim.new(0, 8),

        SortOrder =
            Enum.SortOrder.LayoutOrder,

    }, right)

    --========================================--
    -- NAV BUTTON
    --========================================--

    local navButton = Button(
        self.Nav,
        ""
    )

    navButton.Size =
        UDim2.fromOffset(141, 32)

    navButton.LayoutOrder =
        #self.TabOrder + 1

    navButton.BackgroundTransparency = 1

    Corner(navButton, 6)

    local iconLabel = Text(
        navButton,
        icon or "•",
        14,
        Theme.TextMuted,
        Enum.Font.Gotham
    )

    iconLabel.Position =
        UDim2.fromOffset(8, 0)

    iconLabel.Size =
        UDim2.fromOffset(25, 32)

    iconLabel.TextXAlignment =
        Enum.TextXAlignment.Center

    local nameLabel = Text(
        navButton,
        name,
        10,
        Theme.TextSoft,
        Enum.Font.GothamMedium
    )

    nameLabel.Position =
        UDim2.fromOffset(39, 0)

    nameLabel.Size =
        UDim2.fromOffset(82, 32)

    local arrow = Text(
        navButton,
        "›",
        17,
        Theme.TextMuted,
        Enum.Font.Gotham
    )

    arrow.Position =
        UDim2.fromOffset(122, 0)

    arrow.Size =
        UDim2.fromOffset(14, 32)

    arrow.TextXAlignment =
        Enum.TextXAlignment.Center

    --========================================--
    -- TAB OBJECT
    --========================================--

    local tab = setmetatable({

        Name = name,

        Icon = icon,

        Page = page,

        Scroll = scroll,

        Left = left,

        Right = right,

        NavButton = navButton,

        IconLabel = iconLabel,

        NameLabel = nameLabel,

        Arrow = arrow,

        Sections = {},

        Window = self,

    }, {
        __index = TabMethods
    })

    self.Tabs[name] = tab

    table.insert(
        self.TabOrder,
        tab
    )

    --========================================--
    -- NAV HOVER
    --========================================--

    navButton.MouseEnter:Connect(function()

        if self.ActiveTab ~= tab then

            Tween(navButton, {
                BackgroundTransparency = 0,
                BackgroundColor3 = Theme.Hover,
            })

        end

    end)

    navButton.MouseLeave:Connect(function()

        if self.ActiveTab ~= tab then

            Tween(navButton, {
                BackgroundTransparency = 1,
            })

        end

    end)

    --========================================--
    -- ACTUAL TAB SWITCHING
    --========================================--

    navButton.MouseButton1Click:Connect(function()

        self:SelectTab(name)

    end)

    -- First tab automatically selected.
    if not self.ActiveTab then
        self:SelectTab(name)
    end

    return tab
end

--========================================================--
-- SELECT TAB
--========================================================--

function WindowMethods:SelectTab(name)

    local selectedTab =
        self.Tabs[name]

    if not selectedTab then
        return false
    end

    for _, tab in ipairs(self.TabOrder) do

        tab.Page.Visible = false

        tab.NavButton.BackgroundTransparency = 1

        tab.NameLabel.TextColor3 =
            Theme.TextSoft

        tab.IconLabel.TextColor3 =
            Theme.TextMuted

        tab.Arrow.TextColor3 =
            Theme.TextMuted

    end

    selectedTab.Page.Visible = true

    selectedTab.NavButton.BackgroundTransparency = 0

    selectedTab.NavButton.BackgroundColor3 =
        Theme.Selected

    selectedTab.NameLabel.TextColor3 =
        Theme.Text

    selectedTab.IconLabel.TextColor3 =
        Theme.Text

    selectedTab.Arrow.TextColor3 =
        Theme.Text

    self.ActiveTab = selectedTab

    return true
end

--========================================================--
-- NOTIFICATION
--========================================================--

function WindowMethods:Notify(options)

    options = options or {}

    local duration =
        options.Duration or 4

    local notification = Create("Frame", {

        AnchorPoint =
            Vector2.new(1, 1),

        Position =
            UDim2.new(
                1,
                -16,
                1,
                -16
            ),

        Size =
            UDim2.fromOffset(
                290,
                72
            ),

        BackgroundColor3 =
            Theme.Panel,

        BorderSizePixel = 0,

        ZIndex = 1000,

    }, self.Gui)

    Corner(notification, 8)

    Stroke(
        notification,
        Theme.Border,
        0.15
    )

    local title = Text(
        notification,
        options.Title or "Pulse Hub",
        11,
        Theme.Text,
        Enum.Font.GothamMedium
    )

    title.Position =
        UDim2.fromOffset(12, 6)

    title.Size =
        UDim2.new(1, -24, 0, 20)

    local content = Text(
        notification,
        options.Content or "",
        9,
        Theme.TextSoft,
        Enum.Font.Gotham
    )

    content.Position =
        UDim2.fromOffset(12, 28)

    content.Size =
        UDim2.new(1, -24, 0, 35)

    content.TextWrapped = true

    task.delay(duration, function()

        if notification.Parent then

            Tween(
                notification,
                {
                    Position =
                        UDim2.new(
                            1,
                            320,
                            1,
                            -16
                        )
                },
                0.2
            )

            task.wait(0.22)

            if notification.Parent then
                notification:Destroy()
            end

        end

    end)

    return notification
end

--========================================================--
-- WINDOW VISIBILITY
--========================================================--

function WindowMethods:Show()
    self.Gui.Enabled = true
end

function WindowMethods:Hide()
    self.Gui.Enabled = false
end

function WindowMethods:Toggle()
    self.Gui.Enabled =
        not self.Gui.Enabled
end

function WindowMethods:Destroy()

    if self.Gui then
        self.Gui:Destroy()
    end

    self.Destroyed = true
end

--========================================================--
-- CREATE WINDOW
--========================================================--

function Library:CreateWindow(options)

    options = options or {}

    local playerGui =
        LocalPlayer:WaitForChild(
            "PlayerGui"
        )

    -- Prevent duplicate windows.
    if self.Window then

        pcall(function()
            self.Window:Destroy()
        end)

    end

    --========================================--
    -- SCREEN GUI
    --========================================--

    local gui = Create("ScreenGui", {

        Name =
            options.Name
            or "XusGui",

        ResetOnSpawn = false,

        IgnoreGuiInset = true,

        DisplayOrder =
            options.DisplayOrder
            or 100,

        ZIndexBehavior =
            Enum.ZIndexBehavior.Sibling,

    }, playerGui)

    --========================================--
    -- MAIN WINDOW
    --========================================--

    local main = Create("Frame", {

        AnchorPoint =
            Vector2.new(0.5, 0.5),

        Position =
            UDim2.fromScale(
                0.5,
                0.5
            ),

        Size =
            UDim2.fromOffset(
                652,
                409
            ),

        BackgroundColor3 =
            Theme.Window,

        BorderSizePixel = 0,

        ClipsDescendants = true,

    }, gui)

    Corner(main, 10)

    Stroke(
        main,
        Theme.Border,
        0.18
    )

    --========================================--
    -- SIDEBAR
    --========================================--

    local sidebar = Create("Frame", {

        Size =
            UDim2.fromOffset(
                153,
                409
            ),

        BackgroundColor3 =
            Theme.Sidebar,

        BorderSizePixel = 0,

    }, main)

    Create("Frame", {

        Position =
            UDim2.new(1, -1, 0, 0),

        Size =
            UDim2.new(0, 1, 1, 0),

        BackgroundColor3 =
            Theme.BorderSoft,

        BorderSizePixel = 0,

    }, sidebar)

    --========================================--
    -- LOGO
    --========================================--

    local logo = Create("Frame", {

        Position =
            UDim2.fromOffset(10, 8),

        Size =
            UDim2.fromOffset(35, 35),

        BackgroundColor3 =
            Color3.fromRGB(
                11,
                44,
                77
            ),

        BorderSizePixel = 0,

    }, sidebar)

    Corner(logo, 8)

    Stroke(
        logo,
        Color3.fromRGB(
            25,
            86,
            140
        ),
        0.2
    )

    local logoText = Text(
        logo,
        options.LogoText or "≈",
        19,
        Color3.fromRGB(
            70,
            145,
            240
        ),
        Enum.Font.GothamBold
    )

    logoText.Size =
        UDim2.fromScale(1, 1)

    logoText.TextXAlignment =
        Enum.TextXAlignment.Center

    --========================================--
    -- TITLE
    --========================================--

    local title = Text(
        sidebar,
        options.Title or "Pulse Hub",
        12,
        Color3.fromRGB(
            70,
            145,
            240
        ),
        Enum.Font.GothamMedium
    )

    title.Position =
        UDim2.fromOffset(52, 7)

    title.Size =
        UDim2.fromOffset(
            92,
            17
        )

    local footer = Text(
        sidebar,
        options.Footer
            or "MM2 - v0.4.2",
        7,
        Theme.TextMuted,
        Enum.Font.Gotham
    )

    footer.Position =
        UDim2.fromOffset(52, 22)

    footer.Size =
        UDim2.fromOffset(
            92,
            12
        )

    --========================================--
    -- NAVIGATION
    --========================================--

    local nav = Create("Frame", {

        Position =
            UDim2.fromOffset(6, 62),

        Size =
            UDim2.fromOffset(
                141,
                339
            ),

        BackgroundTransparency = 1,

    }, sidebar)

    Create("UIListLayout", {

        Padding =
            UDim.new(0, 2),

        SortOrder =
            Enum.SortOrder.LayoutOrder,

    }, nav)

    --========================================--
    -- CONTENT
    --========================================--

    local content = Create("Frame", {

        Position =
            UDim2.fromOffset(
                153,
                0
            ),

        Size =
            UDim2.new(
                1,
                -153,
                1,
                0
            ),

        BackgroundTransparency = 1,

    }, main)

    --========================================--
    -- TOP GENERAL BUTTON
    --========================================--

    local general = Button(
        content,
        "●  General"
    )

    general.Position =
        UDim2.fromOffset(
            20,
            12
        )

    general.Size =
        UDim2.fromOffset(
            76,
            32
        )

    general.BackgroundTransparency = 0

    general.BackgroundColor3 =
        Theme.Selected

    general.TextColor3 =
        Theme.Text

    general.TextSize = 10

    general.Font =
        Enum.Font.GothamMedium

    Corner(general, 7)

    --========================================--
    -- UIS BUTTON
    --========================================--

    local uisButton = Button(
        content,
        "UIS"
    )

    uisButton.Position =
        UDim2.fromOffset(
            99,
            12
        )

    uisButton.Size =
        UDim2.fromOffset(
            44,
            32
        )

    uisButton.TextColor3 =
        Theme.TextMuted

    uisButton.TextSize = 10

    --========================================--
    -- SEARCH
    --========================================--

    local search = Create("Frame", {

        Position =
            UDim2.new(
                1,
                -217,
                0,
                11
            ),

        Size =
            UDim2.fromOffset(
                169,
                30
            ),

        BackgroundColor3 =
            Theme.Search,

        BorderSizePixel = 0,

    }, content)

    Corner(search, 7)

    local searchIcon = Text(
        search,
        "⌕",
        17,
        Theme.TextMuted,
        Enum.Font.Gotham
    )

    searchIcon.Position =
        UDim2.fromOffset(8, 0)

    searchIcon.Size =
        UDim2.fromOffset(
            20,
            30
        )

    searchIcon.TextXAlignment =
        Enum.TextXAlignment.Center

    local searchBox = Create(
        "TextBox",
        {

            Position =
                UDim2.fromOffset(
                    34,
                    0
                ),

            Size =
                UDim2.new(
                    1,
                    -39,
                    1,
                    0
                ),

            BackgroundTransparency = 1,

            Text = "",

            PlaceholderText =
                "Search...",

            PlaceholderColor3 =
                Theme.TextMuted,

            TextColor3 =
                Theme.Text,

            TextSize = 9,

            Font =
                Enum.Font.Gotham,

            ClearTextOnFocus = false,

        },
        search
    )

    --========================================--
    -- CLOSE
    --========================================--

    local close = Button(
        content,
        "×"
    )

    close.Position =
        UDim2.new(
            1,
            -37,
            0,
            10
        )

    close.Size =
        UDim2.fromOffset(
            30,
            32
        )

    close.TextColor3 =
        Theme.Text

    close.TextSize = 22

    close.Font =
        Enum.Font.Gotham

    close.MouseEnter:Connect(function()

        close.BackgroundTransparency = 0

        close.BackgroundColor3 =
            Theme.Hover

        Corner(close, 7)

    end)

    close.MouseLeave:Connect(function()

        close.BackgroundTransparency = 1

    end)

    close.MouseButton1Click:Connect(function()

        gui.Enabled = false

    end)

    --========================================--
    -- WINDOW OBJECT
    --========================================--

    local window = setmetatable({

        Gui = gui,

        Main = main,

        Sidebar = sidebar,

        Nav = nav,

        Content = content,

        SearchBox = searchBox,

        Tabs = {},

        TabOrder = {},

        ActiveTab = nil,

        Destroyed = false,

    }, {
        __index = WindowMethods
    })

    Library.Window = window

    --========================================--
    -- SEARCH
    --========================================--

    searchBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(function()

        local query =
            string.lower(
                searchBox.Text
            )

        for name, tab in pairs(
            window.Tabs
        ) do

            if query == "" then

                tab.NavButton.Visible = true

            else

                tab.NavButton.Visible =
                    string.find(
                        string.lower(name),
                        query,
                        1,
                        true
                    ) ~= nil

            end

        end

    end)

    --========================================--
    -- DRAGGING
    --========================================--

    local dragging = false

    local dragStart

    local startPosition

    main.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        then

            dragging = true

            dragStart =
                input.Position

            startPosition =
                main.Position

        end

    end)

    UserInputService.InputChanged:Connect(
        function(input)

            if not dragging then
                return
            end

            if input.UserInputType ==
                Enum.UserInputType.MouseMovement
            then

                local delta =
                    input.Position
                    - dragStart

                main.Position =
                    UDim2.new(

                        startPosition.X.Scale,

                        startPosition.X.Offset
                            + delta.X,

                        startPosition.Y.Scale,

                        startPosition.Y.Offset
                            + delta.Y

                    )

            end

        end
    )

    UserInputService.InputEnded:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
            then

                dragging = false

            end

        end
    )

    --========================================--
    -- RIGHT SHIFT
    --========================================--

    local toggleKey =
        options.ToggleKeybind
        or Enum.KeyCode.RightShift

    UserInputService.InputBegan:Connect(
        function(input, processed)

            if processed then
                return
            end

            if input.KeyCode == toggleKey then

                window:Toggle()

            end

        end
    )

    return window
end

--========================================================--
-- RETURN LIBRARY
--========================================================--

return Library
