--[[
    PulseHub Library
    A reusable Roblox UI library styled after the supplied Pulse Hub design.

    Usage:
        local Library = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL/Library.lua"))()

        local Window = Library:CreateWindow({
            Title = "Pulse Hub",
            Footer = "MM2 - v0.4.2",
            ToggleKeybind = Enum.KeyCode.RightShift,
        })

        local Tabs = {
            Combat = Window:AddTab("Combat", "✥"),
            Visuals = Window:AddTab("Visuals", "◉"),
        }

        local Sheriff = Tabs.Combat:AddLeftSection("Sheriff")

        Sheriff:AddToggle("SilentAim", {
            Text = "Silent Aim",
            Default = false,
            Callback = function(Value)
                print(Value)
            end,
        })

    This library is a UI layer. Put actual game logic in your own callbacks/modules.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Library = {
    Version = "1.0.0",
    Tabs = {},
    ActiveTab = nil,
    ScreenGui = nil,
    Window = nil,
}

local COLORS = {
    Window = Color3.fromRGB(20, 21, 23),
    Sidebar = Color3.fromRGB(22, 23, 25),
    Panel = Color3.fromRGB(28, 29, 31),
    Border = Color3.fromRGB(68, 69, 74),
    BorderDark = Color3.fromRGB(47, 48, 52),

    Text = Color3.fromRGB(228, 228, 231),
    Text2 = Color3.fromRGB(185, 185, 190),
    Muted = Color3.fromRGB(112, 113, 118),

    Blue = Color3.fromRGB(69, 141, 239),
    Green = Color3.fromRGB(48, 211, 92),
    ToggleOff = Color3.fromRGB(91, 92, 101),
    Selected = Color3.fromRGB(91, 93, 100),

    Button = Color3.fromRGB(25, 26, 29),
    ButtonHover = Color3.fromRGB(34, 35, 39),
}

local function New(ClassName, Properties, Parent)
    local Object = Instance.new(ClassName)

    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end

    if Parent then
        Object.Parent = Parent
    end

    return Object
end

local function Round(Object, Radius)
    New("UICorner", {
        CornerRadius = UDim.new(0, Radius or 8),
    }, Object)
end

local function Stroke(Object, Color, Thickness, Transparency)
    New("UIStroke", {
        Color = Color or COLORS.Border,
        Thickness = Thickness or 1,
        Transparency = Transparency or 0,
    }, Object)
end

local function Text(Parent, String, Size, Color, Font)
    return New("TextLabel", {
        BackgroundTransparency = 1,
        Text = String,
        TextSize = Size or 10,
        TextColor3 = Color or COLORS.Text,
        Font = Font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, Parent)
end

local function Button(Parent, String)
    return New("TextButton", {
        BackgroundTransparency = 1,
        Text = String or "",
        AutoButtonColor = false,
    }, Parent)
end

local function Tween(Object, Properties, Time)
    TweenService:Create(
        Object,
        TweenInfo.new(Time or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Properties
    ):Play()
end

local function GetOption(Table, Name, Default)
    if Table and Table[Name] ~= nil then
        return Table[Name]
    end
    return Default
end

------------------------------------------------------------
-- ELEMENT BASE
------------------------------------------------------------

local ElementMethods = {}

function ElementMethods:SetVisible(Value)
    self.Base.Visible = Value
    return self
end

function ElementMethods:SetDisabled(Value)
    self.Disabled = Value

    if self.Base then
        self.Base.Active = not Value
        self.Base.AutoButtonColor = false

        if self.Label then
            self.Label.TextTransparency = Value and 0.45 or 0
        end
    end

    return self
end

------------------------------------------------------------
-- TOGGLE
------------------------------------------------------------

local ToggleMethods = setmetatable({}, {__index = ElementMethods})

function ToggleMethods:SetValue(Value, FireCallback)
    self.Value = Value == true

    Tween(self.Switch, {
        BackgroundColor3 = self.Value and COLORS.Green or COLORS.ToggleOff,
    })

    Tween(self.Knob, {
        Position = self.Value
            and UDim2.fromOffset(22, 2)
            or UDim2.fromOffset(3, 2),
    })

    if FireCallback ~= false and self.Callback then
        self.Callback(self.Value)
    end

    return self
end

function ToggleMethods:GetValue()
    return self.Value
end

function ToggleMethods:Set(Value)
    return self:SetValue(Value, true)
end

function ToggleMethods:Get()
    return self:GetValue()
end

------------------------------------------------------------
-- SECTION
------------------------------------------------------------

local SectionMethods = {}

function SectionMethods:AddToggle(Identifier, Options)
    Options = Options or {}

    local TextValue = GetOption(Options, "Text", Identifier)
    local Default = GetOption(Options, "Default", false)
    local Callback = GetOption(Options, "Callback", function() end)

    local Row = New("Frame", {
        Size = UDim2.new(1, -24, 0, 31),
        BackgroundTransparency = 1,
    }, self.Container)

    local Label = Text(Row, TextValue, 10, COLORS.Text2)
    Label.Position = UDim2.fromOffset(3, 0)
    Label.Size = UDim2.new(1, -75, 1, 0)

    local Switch = Button(Row, "")
    Switch.Position = UDim2.new(1, -43, 0, 4)
    Switch.Size = UDim2.fromOffset(43, 22)
    Switch.BackgroundColor3 = Default and COLORS.Green or COLORS.ToggleOff
    Round(Switch, 11)

    local Knob = New("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = Default
            and UDim2.fromOffset(22, 2)
            or UDim2.fromOffset(3, 2),
        BackgroundColor3 = Color3.fromRGB(247,247,248),
        BorderSizePixel = 0,
    }, Switch)
    Round(Knob, 10)

    local Toggle = setmetatable({
        Type = "Toggle",
        Identifier = Identifier,
        Base = Row,
        Label = Label,
        Switch = Switch,
        Knob = Knob,
        Value = Default == true,
        Callback = Callback,
        Disabled = false,
    }, {__index = ToggleMethods})

    Switch.MouseButton1Click:Connect(function()
        if Toggle.Disabled then
            return
        end

        Toggle:SetValue(not Toggle.Value, true)
    end)

    self.Elements[Identifier] = Toggle
    return Toggle
end

function SectionMethods:AddButton(Options)
    if type(Options) == "string" then
        Options = {Text = Options}
    end

    Options = Options or {}

    local TextValue = GetOption(Options, "Text", "Button")
    local Callback = GetOption(Options, "Callback", function() end)

    local ButtonObject = Button(self.Container, TextValue)

    ButtonObject.Size = UDim2.new(1, -24, 0, 35)
    ButtonObject.BackgroundColor3 = COLORS.Button
    ButtonObject.TextColor3 = COLORS.Text2
    ButtonObject.TextSize = 10
    ButtonObject.Font = Enum.Font.Gotham

    Round(ButtonObject, 8)
    Stroke(ButtonObject, COLORS.BorderDark, 1, 0.15)

    ButtonObject.MouseEnter:Connect(function()
        Tween(ButtonObject, {BackgroundColor3 = COLORS.ButtonHover})
    end)

    ButtonObject.MouseLeave:Connect(function()
        Tween(ButtonObject, {BackgroundColor3 = COLORS.Button})
    end)

    ButtonObject.MouseButton1Click:Connect(function()
        Callback()
    end)

    local Element = setmetatable({
        Type = "Button",
        Base = ButtonObject,
        Callback = Callback,
        Label = ButtonObject,
        Disabled = false,
    }, {__index = ElementMethods})

    self.Elements[TextValue] = Element

    return Element
end

function SectionMethods:AddDropdown(Identifier, Options)
    Options = Options or {}

    local TextValue = GetOption(Options, "Text", Identifier)
    local Values = GetOption(Options, "Values", {})
    local Default = GetOption(Options, "Default", Values[1] or "")
    local Callback = GetOption(Options, "Callback", function() end)

    local Holder = New("Frame", {
        Size = UDim2.new(1, -24, 0, 40),
        BackgroundTransparency = 1,
    }, self.Container)

    local Label = Text(Holder, TextValue, 9, COLORS.Text2)
    Label.Position = UDim2.fromOffset(3, 0)
    Label.Size = UDim2.fromOffset(95, 40)

    local Drop = Button(Holder, tostring(Default) .. "  ﹀")
    Drop.Position = UDim2.new(1, -82, 0, 7)
    Drop.Size = UDim2.fromOffset(82, 26)
    Drop.TextSize = 9
    Drop.TextColor3 = COLORS.Text2
    Drop.Font = Enum.Font.Gotham
    Drop.TextXAlignment = Enum.TextXAlignment.Right

    local Current = Default
    local Open = false

    local Menu = New("Frame", {
        Position = UDim2.new(0, 0, 1, 2),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 20,
    }, Holder)

    Round(Menu, 7)
    Stroke(Menu, COLORS.Border, 1, .2)

    local Layout = New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Menu)

    local function RefreshMenu()
        for _, Child in ipairs(Menu:GetChildren()) do
            if Child:IsA("TextButton") then
                Child:Destroy()
            end
        end

        for Index, Value in ipairs(Values) do
            local Item = Button(Menu, tostring(Value))
            Item.LayoutOrder = Index
            Item.Size = UDim2.new(1, -6, 0, 25)
            Item.Position = UDim2.fromOffset(3, 0)
            Item.TextSize = 9
            Item.TextColor3 = COLORS.Text2
            Item.Font = Enum.Font.Gotham
            Item.TextXAlignment = Enum.TextXAlignment.Left

            Item.MouseEnter:Connect(function()
                Tween(Item, {BackgroundColor3 = COLORS.ButtonHover})
            end)

            Item.MouseLeave:Connect(function()
                Tween(Item, {BackgroundColor3 = COLORS.Panel})
            end)

            Item.MouseButton1Click:Connect(function()
                Current = Value
                Drop.Text = tostring(Value) .. "  ﹀"
                Open = false
                Menu.Visible = false
                Menu.Size = UDim2.new(1,0,0,0)
                Callback(Value)
            end)
        end
    end

    RefreshMenu()

    Drop.MouseButton1Click:Connect(function()
        Open = not Open
        Menu.Visible = Open

        local Height = math.min(#Values, 6) * 27

        Tween(Menu, {
            Size = Open
                and UDim2.new(1, 0, 0, Height)
                or UDim2.new(1, 0, 0, 0)
        }, .15)
    end)

    self.Elements[Identifier] = {
        Type = "Dropdown",
        Base = Holder,
        Get = function()
            return Current
        end,
        Set = function(_, Value)
            Current = Value
            Drop.Text = tostring(Value) .. "  ﹀"
            Callback(Value)
        end,
    }

    return self.Elements[Identifier]
end

function SectionMethods:AddLabel(TextValue)
    local Label = Text(self.Container, TextValue, 10, COLORS.Text2)

    Label.Size = UDim2.new(1, -6, 0, 28)

    return Label
end

------------------------------------------------------------
-- TAB
------------------------------------------------------------

local TabMethods = {}

function TabMethods:AddLeftSection(Title, Height)
    return self:_AddSection(self.Left, Title, Height)
end

function TabMethods:AddRightSection(Title, Height)
    return self:_AddSection(self.Right, Title, Height)
end

function TabMethods:AddSection(Title, Height)
    return self:_AddSection(self.Left, Title, Height)
end

function TabMethods:_AddSection(Column, Title, Height)
    local SectionFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, Height or 355),
        BackgroundColor3 = COLORS.Panel,
        BackgroundTransparency = .12,
        BorderSizePixel = 0,
    }, Column)

    Round(SectionFrame, 11)
    Stroke(SectionFrame, COLORS.Border, 1, .32)

    local Header = Text(SectionFrame, Title, 12, COLORS.Text, Enum.Font.GothamMedium)
    Header.Position = UDim2.fromOffset(14, 0)
    Header.Size = UDim2.new(1, -28, 0, 34)

    local Container = New("Frame", {
        Position = UDim2.fromOffset(12, 38),
        Size = UDim2.new(1, -24, 1, -46),
        BackgroundTransparency = 1,
    }, SectionFrame)

    local Layout = New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Container)

    local Section = setmetatable({
        Name = Title,
        Frame = SectionFrame,
        Container = Container,
        Elements = {},
        Layout = Layout,
    }, {__index = SectionMethods})

    table.insert(self.Sections, Section)

    return Section
end

------------------------------------------------------------
-- WINDOW
------------------------------------------------------------

local WindowMethods = {}

function WindowMethods:AddTab(Name, Icon)
    if self.Tabs[Name] then
        return self.Tabs[Name]
    end

    local Page = New("Frame", {
        Name = Name .. "Page",
        Position = UDim2.fromOffset(10, 60),
        Size = UDim2.new(1, -18, 1, -67),
        BackgroundTransparency = 1,
        Visible = false,
    }, self.Content)

    local Scroll = New("ScrollingFrame", {
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(80,81,86),
        CanvasSize = UDim2.fromOffset(0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, Page)

    local Left = New("Frame", {
        Position = UDim2.fromOffset(0,0),
        Size = UDim2.fromOffset(232,500),
        BackgroundTransparency = 1,
    }, Scroll)

    local Right = New("Frame", {
        Position = UDim2.fromOffset(242,0),
        Size = UDim2.fromOffset(230,500),
        BackgroundTransparency = 1,
    }, Scroll)

    New("UIListLayout", {
        Padding = UDim.new(0,8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Left)

    New("UIListLayout", {
        Padding = UDim.new(0,8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Right)

    local NavButton = Button(self.Nav, "")
    NavButton.LayoutOrder = #self.NavButtons + 1
    NavButton.Size = UDim2.fromOffset(141,30)
    NavButton.Name = Name
    Round(NavButton, 6)

    local IconLabel = Text(
        NavButton,
        Icon or "•",
        15,
        Color3.fromRGB(145,146,151)
    )

    IconLabel.Position = UDim2.fromOffset(10,0)
    IconLabel.Size = UDim2.fromOffset(23,30)
    IconLabel.TextXAlignment = Enum.TextXAlignment.Center

    local NameLabel = Text(
        NavButton,
        Name,
        11,
        Color3.fromRGB(150,151,156),
        Enum.Font.GothamMedium
    )

    NameLabel.Position = UDim2.fromOffset(39,0)
    NameLabel.Size = UDim2.fromOffset(80,30)

    local Arrow = Text(
        NavButton,
        "›",
        16,
        Color3.fromRGB(105,106,111)
    )

    Arrow.Position = UDim2.fromOffset(121,0)
    Arrow.Size = UDim2.fromOffset(15,30)
    Arrow.TextXAlignment = Enum.TextXAlignment.Center

    NavButton.MouseEnter:Connect(function()
        if self.ActiveTab ~= Tab then
            Tween(NavButton, {
                BackgroundColor3 = Color3.fromRGB(48,49,53),
                BackgroundTransparency = .7,
            })
        end
    end)

    NavButton.MouseLeave:Connect(function()
        if self.ActiveTab ~= Tab then
            Tween(NavButton, {
                BackgroundTransparency = 1,
            })
        end
    end)

    local Tab = setmetatable({
        Name = Name,
        Icon = Icon,
        Page = Page,
        Scroll = Scroll,
        Left = Left,
        Right = Right,
        NavButton = NavButton,
        Sections = {},
        Window = self,
    }, {__index = TabMethods})

    self.Tabs[Name] = Tab
    self.NavButtons[Tab] = NavButton

    NavButton.MouseButton1Click:Connect(function()
        self:SelectTab(Name)
    end)

    if not self.ActiveTab then
        self:SelectTab(Name)
    end

    return Tab
end

function WindowMethods:SelectTab(Name)
    local Tab = self.Tabs[Name]
    if not Tab then
        return
    end

    for _, OtherTab in pairs(self.Tabs) do
        OtherTab.Page.Visible = false
        OtherTab.NavButton.BackgroundTransparency = 1
    end

    Tab.Page.Visible = true
    Tab.NavButton.BackgroundColor3 = COLORS.Selected
    Tab.NavButton.BackgroundTransparency = 0

    self.ActiveTab = Tab
    Library.ActiveTab = Tab
end

function WindowMethods:Toggle()
    self.Gui.Enabled = not self.Gui.Enabled
end

function WindowMethods:Show()
    self.Gui.Enabled = true
end

function WindowMethods:Hide()
    self.Gui.Enabled = false
end

function WindowMethods:Destroy()
    self.Gui:Destroy()
    self.Gui = nil
end

function WindowMethods:Notify(Options)
    Options = Options or {}

    local Title = Options.Title or "Notification"
    local Content = Options.Content or Options.Description or ""
    local Duration = Options.Duration or 4

    local Holder = New("Frame", {
        Position = UDim2.new(1, -15, 1, -15),
        AnchorPoint = Vector2.new(1,1),
        Size = UDim2.fromOffset(285, 72),
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
    }, self.Gui)

    Round(Holder, 9)
    Stroke(Holder, COLORS.Border, 1, .25)

    local TitleLabel = Text(Holder, Title, 11, COLORS.Text, Enum.Font.GothamMedium)
    TitleLabel.Position = UDim2.fromOffset(13,8)
    TitleLabel.Size = UDim2.fromOffset(255,20)

    local ContentLabel = Text(Holder, Content, 9, COLORS.Text2)
    ContentLabel.Position = UDim2.fromOffset(13,29)
    ContentLabel.Size = UDim2.fromOffset(255,30)
    ContentLabel.TextWrapped = true
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top

    task.delay(Duration, function()
        if Holder.Parent then
            Tween(Holder, {
                Position = UDim2.new(1, 310, 1, -15)
            }, .2)
            task.wait(.22)
            Holder:Destroy()
        end
    end)

    return Holder
end

------------------------------------------------------------
-- CREATE WINDOW
------------------------------------------------------------

function Library:CreateWindow(Options)
    Options = Options or {}

    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end

    self.Tabs = {}
    self.ActiveTab = nil

    local Gui = New("ScreenGui", {
        Name = Options.Name or "PulseHubUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = Options.DisplayOrder or 100,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, LocalPlayer:WaitForChild("PlayerGui"))

    self.ScreenGui = Gui

    local Main = New("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.5),
        Size = UDim2.fromOffset(652,409),
        BackgroundColor3 = COLORS.Window,
        BackgroundTransparency = .08,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, Gui)

    Round(Main,11)
    Stroke(Main,COLORS.Border,1,.35)

    local Sidebar = New("Frame", {
        Size = UDim2.fromOffset(153,409),
        BackgroundColor3 = COLORS.Sidebar,
        BackgroundTransparency = .05,
        BorderSizePixel = 0,
    }, Main)

    New("Frame", {
        Position = UDim2.new(1,-1,0,0),
        Size = UDim2.new(0,1,1,0),
        BackgroundColor3 = COLORS.BorderDark,
        BorderSizePixel = 0,
    }, Sidebar)

    local Logo = New("Frame", {
        Position = UDim2.fromOffset(11,8),
        Size = UDim2.fromOffset(34,34),
        BackgroundColor3 = Color3.fromRGB(11,43,76),
        BorderSizePixel = 0,
    }, Sidebar)

    Round(Logo,8)
    Stroke(Logo,Color3.fromRGB(23,76,125),1,.15)

    local LogoText = Text(
        Logo,
        Options.LogoText or "≈",
        22,
        Color3.fromRGB(44,151,255),
        Enum.Font.GothamBold
    )

    LogoText.Size = UDim2.fromScale(1,1)
    LogoText.TextXAlignment = Enum.TextXAlignment.Center

    local Title = Text(
        Sidebar,
        Options.Title or "Pulse Hub",
        13,
        COLORS.Blue,
        Enum.Font.GothamMedium
    )

    Title.Position = UDim2.fromOffset(52,8)
    Title.Size = UDim2.fromOffset(90,17)

    local Footer = Text(
        Sidebar,
        Options.Footer or "MM2 - v0.4.2",
        8,
        Color3.fromRGB(101,102,108)
    )

    Footer.Position = UDim2.fromOffset(52,23)
    Footer.Size = UDim2.fromOffset(90,12)

    local Nav = New("Frame", {
        Position = UDim2.fromOffset(6,61),
        Size = UDim2.fromOffset(141,340),
        BackgroundTransparency = 1,
    }, Sidebar)

    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,2),
    }, Nav)

    local Content = New("Frame", {
        Position = UDim2.fromOffset(153,0),
        Size = UDim2.new(1,-153,1,0),
        BackgroundTransparency = 1,
    }, Main)

    local Search = New("Frame", {
        Position = UDim2.fromOffset(283,11),
        Size = UDim2.fromOffset(169,30),
        BackgroundColor3 = Color3.fromRGB(11,12,14),
        BorderSizePixel = 0,
    }, Content)

    Round(Search,7)

    local SearchIcon = Text(Search,"⌕",19,Color3.fromRGB(105,106,111))
    SearchIcon.Position = UDim2.fromOffset(9,0)
    SearchIcon.Size = UDim2.fromOffset(20,30)
    SearchIcon.TextXAlignment = Enum.TextXAlignment.Center

    local SearchBox = New("TextBox", {
        Position = UDim2.fromOffset(36,0),
        Size = UDim2.new(1,-41,1,0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Color3.fromRGB(103,104,109),
        TextColor3 = COLORS.Text,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
    }, Search)

    local Close = Button(Main,"×")
    Close.Position = UDim2.fromOffset(612,11)
    Close.Size = UDim2.fromOffset(31,31)
    Close.BackgroundColor3 = Color3.fromRGB(54,55,60)
    Close.TextColor3 = Color3.fromRGB(225,225,228)
    Close.TextSize = 23
    Close.Font = Enum.Font.Gotham

    Round(Close,8)

    Close.MouseEnter:Connect(function()
        Tween(Close,{BackgroundColor3=Color3.fromRGB(73,74,80)})
    end)

    Close.MouseLeave:Connect(function()
        Tween(Close,{BackgroundColor3=Color3.fromRGB(54,55,60)})
    end)

    Close.MouseButton1Click:Connect(function()
        Gui.Enabled = false
    end)

    local Window = setmetatable({
        Gui = Gui,
        Main = Main,
        Sidebar = Sidebar,
        Nav = Nav,
        Content = Content,
        Search = Search,
        SearchBox = SearchBox,
        Close = Close,

        Tabs = {},
        NavButtons = {},
        ActiveTab = nil,
    }, {__index = WindowMethods})

    self.Window = Window

    --------------------------------------------------------
    -- SEARCH
    --------------------------------------------------------

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local Query = string.lower(SearchBox.Text)

        for Tab, NavButton in pairs(Window.NavButtons) do
            NavButton.Visible =
                Query == ""
                or string.find(string.lower(Tab.Name), Query, 1, true) ~= nil
        end
    end)

    --------------------------------------------------------
    -- DRAG
    --------------------------------------------------------

    local Dragging = false
    local DragStart
    local StartPosition

    Main.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - DragStart

            Main.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    --------------------------------------------------------
    -- TOGGLE KEY
    --------------------------------------------------------

    local ToggleKeybind = Options.ToggleKeybind or Enum.KeyCode.RightShift

    UserInputService.InputBegan:Connect(function(Input, Processed)
        if Processed then
            return
        end

        if Input.KeyCode == ToggleKeybind then
            Window:Toggle()
        end
    end)

    return Window
end

return Library
