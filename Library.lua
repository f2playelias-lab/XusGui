-- PulseHub Library
-- Polished UI implementation based on the supplied Pulse Hub reference.
-- UI-only library: callbacks are left to the consumer script.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local Library = {
    Version = "1.1.0",
    Window = nil,
}

local C = {
    Window = Color3.fromRGB(18, 19, 21),
    Sidebar = Color3.fromRGB(19, 20, 22),
    Surface = Color3.fromRGB(27, 28, 30),
    Surface2 = Color3.fromRGB(31, 32, 35),
    SurfaceHover = Color3.fromRGB(38, 39, 43),

    Border = Color3.fromRGB(61, 62, 67),
    BorderSoft = Color3.fromRGB(47, 48, 52),

    Text = Color3.fromRGB(232, 232, 235),
    Text2 = Color3.fromRGB(183, 184, 190),
    Muted = Color3.fromRGB(112, 113, 119),

    Accent = Color3.fromRGB(48, 211, 92),
    AccentBlue = Color3.fromRGB(70, 145, 240),
    Selected = Color3.fromRGB(89, 91, 98),

    ToggleOff = Color3.fromRGB(87, 88, 96),
    White = Color3.fromRGB(246, 246, 247),
}

local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do
        o[k] = v
    end
    o.Parent = parent
    return o
end

local function Corner(o, r)
    New("UICorner", {CornerRadius = UDim.new(0, r or 7)}, o)
end

local function Stroke(o, color, transparency)
    New("UIStroke", {
        Color = color or C.Border,
        Thickness = 1,
        Transparency = transparency or 0,
    }, o)
end

local function Label(parent, text, size, color, font)
    return New("TextLabel", {
        BackgroundTransparency = 1,
        Text = text or "",
        TextSize = size or 10,
        TextColor3 = color or C.Text,
        Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
end

local function Tween(o, props, t)
    TweenService:Create(
        o,
        TweenInfo.new(t or .12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

local function MakeButton(parent, text)
    return New("TextButton", {
        BackgroundTransparency = 1,
        Text = text or "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, parent)
end

local ElementMethods = {}

function ElementMethods:SetVisible(v)
    self.Container.Visible = v
    return self
end

function ElementMethods:SetDisabled(v)
    self.Disabled = v
    self.Container.Active = not v
    if self.Label then
        self.Label.TextTransparency = v and .5 or 0
    end
    return self
end

local ToggleMethods = setmetatable({}, {__index = ElementMethods})

function ToggleMethods:SetValue(v, fire)
    self.Value = v == true
    Tween(self.Track, {
        BackgroundColor3 = self.Value and C.Accent or C.ToggleOff
    })
    Tween(self.Knob, {
        Position = self.Value
            and UDim2.new(1, -20, 0, 2)
            or UDim2.fromOffset(3, 2)
    })
    if fire ~= false and self.Callback then
        self.Callback(self.Value)
    end
    return self
end

function ToggleMethods:GetValue()
    return self.Value
end

ToggleMethods.Set = ToggleMethods.SetValue
ToggleMethods.Get = ToggleMethods.GetValue

local SectionMethods = {}

function SectionMethods:AddLabel(text)
    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
    }, self.Container)

    local l = Label(row, text, 9, C.Text2)
    l.Position = UDim2.fromOffset(2, 0)
    l.Size = UDim2.new(1, -4, 1, 0)
    l.TextWrapped = true

    return l
end

function SectionMethods:AddDivider()
    local line = New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = C.BorderSoft,
        BackgroundTransparency = .25,
        BorderSizePixel = 0,
    }, self.Container)
    return line
end

function SectionMethods:AddToggle(id, opt)
    opt = opt or {}

    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
    }, self.Container)

    local text = opt.Text or id
    local l = Label(row, text, 10, C.Text2)
    l.Position = UDim2.fromOffset(2, 0)
    l.Size = UDim2.new(1, -72, 1, 0)

    local gear
    if opt.HasSettings then
        gear = Label(row, "⚙", 15, C.Muted)
        gear.Position = UDim2.new(1, -67, 0, 0)
        gear.Size = UDim2.fromOffset(24, 38)
        gear.TextXAlignment = Enum.TextXAlignment.Center
    end

    local track = MakeButton(row, "")
    track.Size = UDim2.fromOffset(43, 22)
    track.Position = UDim2.new(1, -43, 0, 8)
    track.BackgroundTransparency = 0
    track.BackgroundColor3 = opt.Default and C.Accent or C.ToggleOff
    Corner(track, 11)

    local knob = New("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = opt.Default
            and UDim2.new(1, -20, 0, 2)
            or UDim2.fromOffset(3, 2),
        BackgroundColor3 = C.White,
        BorderSizePixel = 0,
    }, track)
    Corner(knob, 10)

    local toggle = setmetatable({
        Type = "Toggle",
        ID = id,
        Container = row,
        Label = l,
        Track = track,
        Knob = knob,
        Value = opt.Default == true,
        Callback = opt.Callback,
        Disabled = false,
    }, {__index = ToggleMethods})

    track.MouseButton1Click:Connect(function()
        if not toggle.Disabled then
            toggle:SetValue(not toggle.Value, true)
        end
    end)

    self.Elements[id] = toggle
    return toggle
end

function SectionMethods:AddButton(opt)
    if type(opt) == "string" then
        opt = {Text = opt}
    end
    opt = opt or {}

    local b = MakeButton(self.Container, opt.Text or "Button")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = C.Surface2
    b.TextColor3 = C.Text2
    b.TextSize = 10
    b.Font = Enum.Font.Gotham
    Corner(b, 7)
    Stroke(b, C.BorderSoft, .35)

    b.MouseEnter:Connect(function()
        Tween(b, {BackgroundColor3 = C.SurfaceHover})
    end)
    b.MouseLeave:Connect(function()
        Tween(b, {BackgroundColor3 = C.Surface2})
    end)
    b.MouseButton1Click:Connect(function()
        if opt.Callback then
            opt.Callback()
        end
    end)

    local element = setmetatable({
        Type = "Button",
        ID = opt.Text,
        Container = b,
        Label = b,
        Callback = opt.Callback,
        Disabled = false,
    }, {__index = ElementMethods})

    self.Elements[opt.Text or "Button"] = element
    return element
end

function SectionMethods:AddDropdown(id, opt)
    opt = opt or {}

    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
    }, self.Container)

    local l = Label(row, opt.Text or id, 9, C.Text2)
    l.Position = UDim2.fromOffset(2, 0)
    l.Size = UDim2.fromOffset(105, 38)

    local current = opt.Default or (opt.Values and opt.Values[1]) or ""
    local values = opt.Values or {}

    local drop = MakeButton(row, tostring(current) .. "  ﹀")
    drop.Size = UDim2.fromOffset(105, 28)
    drop.Position = UDim2.new(1, -105, 0, 5)
    drop.BackgroundTransparency = 0
    drop.BackgroundColor3 = C.Surface2
    drop.TextColor3 = C.Text2
    drop.TextSize = 9
    drop.Font = Enum.Font.Gotham
    drop.TextXAlignment = Enum.TextXAlignment.Right
    Corner(drop, 6)

    local menu = New("Frame", {
        Position = UDim2.new(0, 0, 1, 3),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.Surface,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 30,
    }, drop)
    Corner(menu, 6)
    Stroke(menu, C.Border, .2)

    New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, menu)

    for i, value in ipairs(values) do
        local item = MakeButton(menu, tostring(value))
        item.LayoutOrder = i
        item.Size = UDim2.new(1, -6, 0, 25)
        item.Position = UDim2.fromOffset(3, 0)
        item.TextSize = 9
        item.TextColor3 = C.Text2
        item.Font = Enum.Font.Gotham
        item.TextXAlignment = Enum.TextXAlignment.Left

        item.MouseEnter:Connect(function()
            item.BackgroundTransparency = 0
            item.BackgroundColor3 = C.SurfaceHover
        end)
        item.MouseLeave:Connect(function()
            item.BackgroundTransparency = 1
        end)
        item.MouseButton1Click:Connect(function()
            current = value
            drop.Text = tostring(value) .. "  ﹀"
            menu.Visible = false
            menu.Size = UDim2.new(1, 0, 0, 0)
            if opt.Callback then
                opt.Callback(value)
            end
        end)
    end

    local open = false
    drop.MouseButton1Click:Connect(function()
        open = not open
        menu.Visible = open
        local h = math.min(#values, 6) * 27
        Tween(menu, {
            Size = open and UDim2.new(1, 0, 0, h) or UDim2.new(1, 0, 0, 0)
        }, .14)
    end)

    local element = {
        Type = "Dropdown",
        ID = id,
        Container = row,
        Label = l,
        GetValue = function()
            return current
        end,
        SetValue = function(_, value, fire)
            current = value
            drop.Text = tostring(value) .. "  ﹀"
            if fire ~= false and opt.Callback then
                opt.Callback(value)
            end
        end,
    }

    self.Elements[id] = element
    return element
end

local TabMethods = {}

function TabMethods:_AddSection(column, title, height)
    local sectionFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, height or 355),
        BackgroundColor3 = C.Surface,
        BackgroundTransparency = .05,
        BorderSizePixel = 0,
    }, column)

    Corner(sectionFrame, 10)
    Stroke(sectionFrame, C.Border, .28)

    local header = Label(sectionFrame, title, 12, C.Text, Enum.Font.GothamMedium)
    header.Position = UDim2.fromOffset(13, 0)
    header.Size = UDim2.new(1, -26, 0, 39)

    local body = New("Frame", {
        Position = UDim2.fromOffset(13, 39),
        Size = UDim2.new(1, -26, 1, -48),
        BackgroundTransparency = 1,
    }, sectionFrame)

    New("UIListLayout", {
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, body)

    local section = setmetatable({
        Name = title,
        Frame = sectionFrame,
        Container = body,
        Elements = {},
    }, {__index = SectionMethods})

    table.insert(self.Sections, section)
    return section
end

function TabMethods:AddLeftSection(title, height)
    return self:_AddSection(self.Left, title, height)
end

function TabMethods:AddRightSection(title, height)
    return self:_AddSection(self.Right, title, height)
end

function TabMethods:AddSection(title, height)
    return self:_AddSection(self.Left, title, height)
end

local WindowMethods = {}

function WindowMethods:AddTab(name, icon)
    local page = New("Frame", {
        Name = name .. "Page",
        Position = UDim2.fromOffset(10, 59),
        Size = UDim2.new(1, -20, 1, -68),
        BackgroundTransparency = 1,
        Visible = false,
    }, self.Content)

    local scroll = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = C.Muted,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, page)

    local left = New("Frame", {
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(.5, -5, 0, 600),
        BackgroundTransparency = 1,
    }, scroll)

    local right = New("Frame", {
        Position = UDim2.new(.5, 5, 0, 0),
        Size = UDim2.new(.5, -5, 0, 600),
        BackgroundTransparency = 1,
    }, scroll)

    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, left)

    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, right)

    local nav = MakeButton(self.Nav, "")
    nav.Size = UDim2.fromOffset(141, 32)
    nav.LayoutOrder = #self.Tabs + 1
    nav.BackgroundTransparency = 1
    Corner(nav, 6)

    local iconLabel = Label(nav, icon or "•", 14, C.Muted)
    iconLabel.Position = UDim2.fromOffset(9, 0)
    iconLabel.Size = UDim2.fromOffset(25, 32)
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center

    local nameLabel = Label(nav, name, 10, C.Text2, Enum.Font.GothamMedium)
    nameLabel.Position = UDim2.fromOffset(39, 0)
    nameLabel.Size = UDim2.fromOffset(82, 32)

    local arrow = Label(nav, "›", 16, C.Muted)
    arrow.Position = UDim2.fromOffset(121, 0)
    arrow.Size = UDim2.fromOffset(14, 32)
    arrow.TextXAlignment = Enum.TextXAlignment.Center

    local tab = setmetatable({
        Name = name,
        Icon = icon,
        Page = page,
        Scroll = scroll,
        Left = left,
        Right = right,
        NavButton = nav,
        IconLabel = iconLabel,
        NameLabel = nameLabel,
        Sections = {},
        Window = self,
    }, {__index = TabMethods})

    self.Tabs[name] = tab

    nav.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            Tween(nav, {
                BackgroundTransparency = 0,
                BackgroundColor3 = C.SurfaceHover,
            })
        end
    end)

    nav.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            Tween(nav, {BackgroundTransparency = 1})
        end
    end)

    nav.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)

    if not self.ActiveTab then
        self:SelectTab(name)
    end

    return tab
end

function WindowMethods:SelectTab(name)
    local selected = self.Tabs[name]
    if not selected then
        return
    end

    for _, tab in pairs(self.Tabs) do
        tab.Page.Visible = false
        tab.NavButton.BackgroundTransparency = 1
        tab.NameLabel.TextColor3 = C.Text2
        tab.IconLabel.TextColor3 = C.Muted
    end

    selected.Page.Visible = true
    selected.NavButton.BackgroundTransparency = 0
    selected.NavButton.BackgroundColor3 = C.Selected
    selected.NameLabel.TextColor3 = C.Text
    selected.IconLabel.TextColor3 = C.Text
    self.ActiveTab = selected
end

function WindowMethods:Show()
    self.Gui.Enabled = true
end

function WindowMethods:Hide()
    self.Gui.Enabled = false
end

function WindowMethods:Toggle()
    self.Gui.Enabled = not self.Gui.Enabled
end

function WindowMethods:Notify(opt)
    opt = opt or {}

    local toast = New("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.fromOffset(290, 72),
        BackgroundColor3 = C.Surface,
        BorderSizePixel = 0,
        ZIndex = 100,
    }, self.Gui)

    Corner(toast, 8)
    Stroke(toast, C.Border, .2)

    local title = Label(toast, opt.Title or "Pulse Hub", 11, C.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.fromOffset(12, 7)
    title.Size = UDim2.new(1, -24, 0, 20)

    local content = Label(toast, opt.Content or "", 9, C.Text2)
    content.Position = UDim2.fromOffset(12, 29)
    content.Size = UDim2.new(1, -24, 0, 34)
    content.TextWrapped = true
    content.TextYAlignment = Enum.TextYAlignment.Top

    task.delay(opt.Duration or 4, function()
        if toast.Parent then
            Tween(toast, {Position = UDim2.new(1, 310, 1, -16)}, .2)
            task.wait(.22)
            toast:Destroy()
        end
    end)

    return toast
end

function WindowMethods:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
end

function Library:CreateWindow(opt)
    opt = opt or {}

    if self.Window and self.Window.Gui then
        self.Window:Destroy()
    end

    local gui = New("ScreenGui", {
        Name = opt.Name or "PulseHub",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = opt.DisplayOrder or 100,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, Player:WaitForChild("PlayerGui"))

    local main = New("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .5),
        Size = UDim2.fromOffset(652, 409),
        BackgroundColor3 = C.Window,
        BackgroundTransparency = .02,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, gui)

    Corner(main, 10)
    Stroke(main, C.Border, .2)

    local sidebar = New("Frame", {
        Size = UDim2.fromOffset(153, 409),
        BackgroundColor3 = C.Sidebar,
        BorderSizePixel = 0,
    }, main)

    New("Frame", {
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundColor3 = C.BorderSoft,
        BorderSizePixel = 0,
    }, sidebar)

    -- Logo
    local logo = New("Frame", {
        Position = UDim2.fromOffset(10, 8),
        Size = UDim2.fromOffset(35, 35),
        BackgroundColor3 = Color3.fromRGB(11, 44, 77),
        BorderSizePixel = 0,
    }, sidebar)
    Corner(logo, 8)
    Stroke(logo, Color3.fromRGB(25, 86, 140), .2)

    local logoText = Label(logo, opt.LogoText or "≈", 19, C.AccentBlue, Enum.Font.GothamBold)
    logoText.Size = UDim2.fromScale(1, 1)
    logoText.TextXAlignment = Enum.TextXAlignment.Center

    local title = Label(sidebar, opt.Title or "Pulse Hub", 12, C.AccentBlue, Enum.Font.GothamMedium)
    title.Position = UDim2.fromOffset(52, 7)
    title.Size = UDim2.fromOffset(92, 17)

    local footer = Label(sidebar, opt.Footer or "MM2 - v0.4.2", 7, C.Muted)
    footer.Position = UDim2.fromOffset(52, 22)
    footer.Size = UDim2.fromOffset(92, 12)

    local nav = New("Frame", {
        Position = UDim2.fromOffset(6, 62),
        Size = UDim2.fromOffset(141, 339),
        BackgroundTransparency = 1,
    }, sidebar)

    New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, nav)

    local content = New("Frame", {
        Position = UDim2.fromOffset(153, 0),
        Size = UDim2.new(1, -153, 1, 0),
        BackgroundTransparency = 1,
    }, main)

    -- Top controls: pill + search + close
    local general = MakeButton(content, "●  General")
    general.Position = UDim2.fromOffset(20, 12)
    general.Size = UDim2.fromOffset(76, 32)
    general.BackgroundTransparency = 0
    general.BackgroundColor3 = C.Selected
    general.TextColor3 = C.Text
    general.TextSize = 10
    general.Font = Enum.Font.GothamMedium
    Corner(general, 7)

    local uis = MakeButton(content, "UIS")
    uis.Position = UDim2.fromOffset(99, 12)
    uis.Size = UDim2.fromOffset(44, 32)
    uis.BackgroundTransparency = 1
    uis.TextColor3 = C.Muted
    uis.TextSize = 10
    uis.Font = Enum.Font.Gotham

    local search = New("Frame", {
        Position = UDim2.new(1, -217, 0, 11),
        Size = UDim2.fromOffset(169, 30),
        BackgroundColor3 = Color3.fromRGB(11, 12, 14),
        BorderSizePixel = 0,
    }, content)
    Corner(search, 7)

    local searchIcon = Label(search, "⌕", 17, C.Muted)
    searchIcon.Position = UDim2.fromOffset(8, 0)
    searchIcon.Size = UDim2.fromOffset(20, 30)
    searchIcon.TextXAlignment = Enum.TextXAlignment.Center

    local searchBox = New("TextBox", {
        Position = UDim2.fromOffset(34, 0),
        Size = UDim2.new(1, -39, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = C.Muted,
        TextColor3 = C.Text,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
    }, search)

    local close = MakeButton(content, "×")
    close.Position = UDim2.new(1, -37, 0, 10)
    close.Size = UDim2.fromOffset(30, 32)
    close.TextColor3 = C.Text
    close.TextSize = 22
    close.Font = Enum.Font.Gotham

    close.MouseEnter:Connect(function()
        close.BackgroundTransparency = 0
        close.BackgroundColor3 = C.SurfaceHover
        Corner(close, 7)
    end)
    close.MouseLeave:Connect(function()
        close.BackgroundTransparency = 1
    end)
    close.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    local window = setmetatable({
        Gui = gui,
        Main = main,
        Sidebar = sidebar,
        Nav = nav,
        Content = content,
        SearchBox = searchBox,
        Tabs = {},
        ActiveTab = nil,
        NavButtons = {},
    }, {__index = WindowMethods})

    self.Window = window

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(searchBox.Text)
        for name, tab in pairs(window.Tabs) do
            tab.NavButton.Visible = q == "" or string.find(string.lower(name), q, 1, true) ~= nil
        end
    end)

    -- Dragging
    local dragging = false
    local dragStart
    local startPos

    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end

    main.InputBegan:Connect(beginDrag)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local key = opt.ToggleKeybind or Enum.KeyCode.RightShift
    UIS.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == key then
            window:Toggle()
        end
    end)

    return window
end

return Library
