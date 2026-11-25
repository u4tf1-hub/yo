-- ╔═════════════════════════════════════════════════════════════════╗
-- ║                  THA BRONX 3 — BRONX HUB (V2.2)                 ║
-- ║         Teleport • Dupe • ESP • Combat (Aimbot/Silent)         ║
-- ║         Press [RightShift] to Toggle UI                         ║
-- ╚═════════════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local RS               = game:GetService("ReplicatedStorage")

-- ══════════════════════════════════════════
--  ANTI-GLIDE
-- ══════════════════════════════════════════
local function disableAntiGlide()
    local char = LocalPlayer.Character
    if char then
        local ag = char:FindFirstChild("Anti-Glide")
        if ag then ag.Disabled = true end
    end
end
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5) disableAntiGlide() end)
disableAntiGlide()

-- ══════════════════════════════════════════
--  TELEPORT LOGIC
-- ══════════════════════════════════════════
local isTeleporting = false

local function teleportTo(pos)
    if isTeleporting then return end
    isTeleporting = true

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then isTeleporting = false return end

    disableAntiGlide()

    pcall(function()
        local runnin = char:FindFirstChild("Runnin")
        if runnin then runnin.Value = false end

        local fdConn = RunService.RenderStepped:Connect(function()
            if hum and hum.Parent then
                hum:ChangeState(Enum.HumanoidStateType.FallingDown)
            end
        end)

        task.wait(1.0)

        hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(pos)
        end

        fdConn:Disconnect()

        task.wait(2.0)
        local runnin2 = char:FindFirstChild("Runnin")
        if runnin2 then runnin2.Value = true end
    end)

    task.wait(0.3)
    isTeleporting = false
end

-- ══════════════════════════════════════════
--  LOCATIONS
-- ══════════════════════════════════════════
local locations = {
    {"Crafting Roof",     Vector3.new(-387.9578,  340.3467,    -558.864)},
    {"Construction Site", Vector3.new(-1731.8307, 370.8123,    -1176.8387)},
    {"Backpack Shop",     Vector3.new(-734.8655,  255.0299,    -706.6967)},
    {"Ice Box",           Vector3.new(-202.5236,  284.0315,    -1169.4497)},
    {"Bank",              Vector3.new(-1188.1654, 253.7809,    -3615.3091)},
    {"Pent House",        Vector3.new(-1491.7125, 476.3004,    -3749.1086)},
    {"Pawn Shop",         Vector3.new(-1049.6431, 253.5367,    -814.2697)},
    {"Sell Juice",        Vector3.new(-1463.4895, 253.8436,    -3383.6636)},
    {"Hospital",          Vector3.new(-1590.2389, 254.2722,    27.2879)},
    {"Car Dealer",        Vector3.new(-379.0562,  253.2626,    -1246.4066)},
    {"Money Wash",        Vector3.new(-977.1771,  253.6838,    -692.5855)},
    {"Chicken Wings",     Vector3.new(-957.9142,  253.5367,    -815.9442)},
    {"Deli Grocery",      Vector3.new(-1038.9905, 254.8519,    -1132.7462)},
    {"GunShop 1",         Vector3.new(-1002.6972, 253.8149,    -803.5169)},
    {"GunShop 2",         Vector3.new(66197.125,  123615.7188, 5749.2305)},
    {"GunShop 3",         Vector3.new(60820.3086, 87609.1484,  -351.4746)},
    {"GunShop 4",         Vector3.new(-955.9661,  260.1871,    -4248.2451)},
    {"Studio",            Vector3.new(93408.375,  14484.8984,  570.9003)},
    {"Drip Shop",         Vector3.new(67462.6953, 10489.0352,  549.5895)},
    {"Sewer",             Vector3.new(81069.0078, 133133.0313, 168.0926)},
    {"Truck Place",       Vector3.new(-1552.83,   258.20,      -1204.20)},
}

-- ══════════════════════════════════════════
--  DESIGN SYSTEM & THEME
-- ══════════════════════════════════════════
local THEME = {
    BG_MAIN       = Color3.fromRGB(11, 13, 19),
    BG_SIDEBAR    = Color3.fromRGB(16, 18, 27),
    BG_CARD       = Color3.fromRGB(21, 24, 36),
    BG_CARD_HOVER = Color3.fromRGB(28, 32, 48),
    BORDER        = Color3.fromRGB(35, 40, 60),
    ACCENT        = Color3.fromRGB(59, 130, 246),
    ACCENT_GLOW   = Color3.fromRGB(37, 99, 235),
    TEXT_MAIN     = Color3.fromRGB(240, 243, 250),
    TEXT_MUTED    = Color3.fromRGB(130, 140, 165),
    SUCCESS       = Color3.fromRGB(16, 185, 129),
    WARNING       = Color3.fromRGB(245, 158, 11),
    DANGER        = Color3.fromRGB(239, 68, 68),
    PURPLE        = Color3.fromRGB(139, 92, 246),
}

-- ══════════════════════════════════════════
--  UI INITIALIZATION
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "BronxHubPro"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name             = "MainFrame"
MainFrame.Size             = UDim2.new(0, 540, 0, 410)
MainFrame.Position         = UDim2.new(0.5, -270, 0.5, -205)
MainFrame.BackgroundColor3 = THEME.BG_MAIN
MainFrame.BorderSizePixel  = 0
MainFrame.Active           = true
MainFrame.Parent           = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = THEME.BORDER
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Outer Glow Shadow
local GlowShadow = Instance.new("ImageLabel")
GlowShadow.Size               = UDim2.new(1, 40, 1, 40)
GlowShadow.Position           = UDim2.new(0, -20, 0, -20)
GlowShadow.BackgroundTransparency = 1
GlowShadow.Image              = "rbxassetid://5028857084"
GlowShadow.ImageColor3        = THEME.ACCENT
GlowShadow.ImageTransparency  = 0.88
GlowShadow.ScaleType          = Enum.ScaleType.Slice
GlowShadow.SliceCenter        = Rect.new(24, 24, 276, 276)
GlowShadow.ZIndex             = 0
GlowShadow.Parent             = MainFrame

-- Smooth Window Dragging Logic
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    }):Play()
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- ══════════════════════════════════════════
--  SIDEBAR NAVIGATION
-- ══════════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Name             = "Sidebar"
Sidebar.Size             = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = THEME.BG_SIDEBAR
Sidebar.BorderSizePixel  = 0
Sidebar.Parent           = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SidebarFix = Instance.new("Frame")
SidebarFix.Size             = UDim2.new(0, 10, 1, 0)
SidebarFix.Position         = UDim2.new(1, -10, 0, 0)
SidebarFix.BackgroundColor3 = THEME.BG_SIDEBAR
SidebarFix.BorderSizePixel  = 0
SidebarFix.Parent           = Sidebar

local LogoText = Instance.new("TextLabel")
LogoText.Size               = UDim2.new(1, -20, 0, 36)
LogoText.Position           = UDim2.new(0, 12, 0, 12)
LogoText.BackgroundTransparency = 1
LogoText.Text               = "BRONX HUB"
LogoText.TextColor3         = THEME.TEXT_MAIN
LogoText.Font               = Enum.Font.GothamBold
LogoText.TextSize           = 14
LogoText.TextXAlignment     = Enum.TextXAlignment.Left
LogoText.Parent             = Sidebar



local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size             = UDim2.new(1, -16, 1, -110)
TabContainer.Position         = UDim2.new(0, 8, 0, 56)
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel  = 0
TabContainer.ScrollBarThickness = 2
TabContainer.ScrollBarImageColor3 = THEME.ACCENT
TabContainer.CanvasSize       = UDim2.new(0, 0, 0, 0)
TabContainer.Parent           = Sidebar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabContainer

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 4)
end)

local StatusFooter = Instance.new("Frame")
StatusFooter.Size             = UDim2.new(1, -16, 0, 34)
StatusFooter.Position         = UDim2.new(0, 8, 1, -42)
StatusFooter.BackgroundColor3 = THEME.BG_CARD
StatusFooter.BorderSizePixel  = 0
StatusFooter.Parent           = Sidebar
Instance.new("UICorner", StatusFooter).CornerRadius = UDim.new(0, 8)

local StatusDot = Instance.new("Frame")
StatusDot.Size             = UDim2.new(0, 6, 0, 6)
StatusDot.Position         = UDim2.new(0, 10, 0.5, -3)
StatusDot.BackgroundColor3 = THEME.SUCCESS
StatusDot.BorderSizePixel  = 0
StatusDot.Parent           = StatusFooter
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusText = Instance.new("TextLabel")
StatusText.Size               = UDim2.new(1, -24, 1, 0)
StatusText.Position           = UDim2.new(0, 22, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text               = "Ready"
StatusText.TextColor3         = THEME.TEXT_MUTED
StatusText.Font               = Enum.Font.GothamMedium
StatusText.TextSize           = 10
StatusText.TextXAlignment     = Enum.TextXAlignment.Left
StatusText.Parent             = StatusFooter

local function setStatus(msg, color)
    StatusText.Text = msg
    StatusText.TextColor3 = color or THEME.TEXT_MUTED
    StatusDot.BackgroundColor3 = color or THEME.SUCCESS
end

-- ══════════════════════════════════════════
--  RIGHT MAIN CANVAS & HEADER
-- ══════════════════════════════════════════
local MainCanvas = Instance.new("Frame")
MainCanvas.Size             = UDim2.new(1, -150, 1, 0)
MainCanvas.Position         = UDim2.new(0, 150, 0, 0)
MainCanvas.BackgroundTransparency = 1
MainCanvas.Parent           = MainFrame

local TopHeader = Instance.new("Frame")
TopHeader.Size             = UDim2.new(1, 0, 0, 48)
TopHeader.BackgroundTransparency = 1
TopHeader.Parent           = MainCanvas

local PageTitle = Instance.new("TextLabel")
PageTitle.Size               = UDim2.new(1, -80, 1, 0)
PageTitle.Position           = UDim2.new(0, 16, 0, 0)
PageTitle.BackgroundTransparency = 1
PageTitle.Text               = "Teleports"
PageTitle.TextColor3         = THEME.TEXT_MAIN
PageTitle.Font               = Enum.Font.GothamBold
PageTitle.TextSize           = 15
PageTitle.TextXAlignment     = Enum.TextXAlignment.Left
PageTitle.Parent             = TopHeader

local CloseButton = Instance.new("TextButton")
CloseButton.Size               = UDim2.new(0, 28, 0, 28)
CloseButton.Position           = UDim2.new(1, -38, 0.5, -14)
CloseButton.BackgroundColor3   = THEME.BG_CARD
CloseButton.Text               = "✕"
CloseButton.TextColor3         = THEME.TEXT_MUTED
CloseButton.Font               = Enum.Font.GothamBold
CloseButton.TextSize           = 12
CloseButton.BorderSizePixel    = 0
CloseButton.AutoButtonColor    = false
CloseButton.Parent             = TopHeader
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

local function toggleUI(visible)
    if visible == nil then
        visible = not ScreenGui.Enabled
    end
    ScreenGui.Enabled = visible
    MainFrame.Visible = visible
end

CloseButton.MouseButton1Click:Connect(function() 
    toggleUI(false) 
end)
CloseButton.MouseEnter:Connect(function() 
    TweenService:Create(CloseButton, TweenInfo.new(0.12), {BackgroundColor3 = THEME.DANGER, TextColor3 = Color3.fromRGB(255,255,255)}):Play() 
end)
CloseButton.MouseLeave:Connect(function() 
    TweenService:Create(CloseButton, TweenInfo.new(0.12), {BackgroundColor3 = THEME.BG_CARD, TextColor3 = THEME.TEXT_MUTED}):Play() 
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if inp.KeyCode == Enum.KeyCode.RightShift then
        if not UserInputService:GetFocusedTextBox() then
            toggleUI()
        end
    end
end)

local PageContainer = Instance.new("Frame")
PageContainer.Size             = UDim2.new(1, -32, 1, -60)
PageContainer.Position         = UDim2.new(0, 16, 0, 48)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent           = MainCanvas

-- ══════════════════════════════════════════
--  TAB & PAGE REGISTRATION SYSTEM
-- ══════════════════════════════════════════
local tabs = {}
local pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name                   = name .. "Page"
    page.Size                   = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel        = 0
    page.ScrollBarThickness     = 3
    page.ScrollBarImageColor3   = THEME.ACCENT
    page.CanvasSize             = UDim2.new(0, 0, 0, 0)
    page.Visible                = false
    page.Parent                 = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    pages[name] = page
    return page
end

local function addTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Name             = name .. "Tab"
    btn.Size             = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = THEME.BG_SIDEBAR
    btn.Text             = ""
    btn.AutoButtonColor  = false
    btn.BorderSizePixel  = 0
    btn.LayoutOrder      = order
    btn.Parent           = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(1, -20, 1, 0)
    lbl.Position           = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = name
    lbl.TextColor3         = THEME.TEXT_MUTED
    lbl.Font               = Enum.Font.GothamMedium
    lbl.TextSize           = 11
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Parent             = btn

    local activeBar = Instance.new("Frame")
    activeBar.Size             = UDim2.new(0, 3, 0, 16)
    activeBar.Position         = UDim2.new(0, 0, 0.5, -8)
    activeBar.BackgroundColor3 = THEME.ACCENT
    activeBar.BorderSizePixel  = 0
    activeBar.BackgroundTransparency = 1
    activeBar.Parent           = btn
    Instance.new("UICorner", activeBar).CornerRadius = UDim.new(0, 2)

    local page = createPage(name)
    tabs[name] = {btn = btn, label = lbl, bar = activeBar, page = page}

    btn.MouseButton1Click:Connect(function()
        for tName, tData in pairs(tabs) do
            if tName == name then
                tData.page.Visible = true
                PageTitle.Text = tName
                TweenService:Create(tData.btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.BG_CARD}):Play()
                TweenService:Create(tData.label, TweenInfo.new(0.15), {TextColor3 = THEME.TEXT_MAIN}):Play()
                TweenService:Create(tData.bar, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
            else
                tData.page.Visible = false
                TweenService:Create(tData.btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.BG_SIDEBAR}):Play()
                TweenService:Create(tData.label, TweenInfo.new(0.15), {TextColor3 = THEME.TEXT_MUTED}):Play()
                TweenService:Create(tData.bar, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            end
        end
    end)
end

addTab("Teleports", 1)
addTab("Dupe",      2)
addTab("ESP",       3)
addTab("Combat",    4)
addTab("Player",    5)
addTab("Car Mods",  6)
addTab("Theme",     7)
addTab("Configs",   8)

-- Set Default Active Tab
tabs["Teleports"].page.Visible = true
tabs["Teleports"].btn.BackgroundColor3 = THEME.BG_CARD
tabs["Teleports"].label.TextColor3 = THEME.TEXT_MAIN
tabs["Teleports"].bar.BackgroundTransparency = 0

-- ══════════════════════════════════════════
--  UI FACTORIES (Cards, Toggles, Sliders, Buttons)
-- ══════════════════════════════════════════
local function createCard(parent, title, height)
    local card = Instance.new("Frame")
    card.Size             = UDim2.new(1, 0, 0, height or 48)
    card.BackgroundColor3 = THEME.BG_CARD
    card.BorderSizePixel  = 0
    card.Parent           = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.BORDER
    stroke.Thickness = 1
    stroke.Parent = card

    if title then
        local lbl = Instance.new("TextLabel")
        lbl.Size               = UDim2.new(1, -24, 0, 20)
        lbl.Position           = UDim2.new(0, 12, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text               = title
        lbl.TextColor3         = THEME.TEXT_MAIN
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextSize           = 11
        lbl.TextXAlignment     = Enum.TextXAlignment.Left
        lbl.Parent             = card
    end

    return card
end

local function createToggle(parent, title, desc, default, callback)
    local card = createCard(parent, nil, 46)

    local label = Instance.new("TextLabel")
    label.Size               = UDim2.new(1, -70, 0, 18)
    label.Position           = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text               = title
    label.TextColor3         = THEME.TEXT_MAIN
    label.Font               = Enum.Font.GothamBold
    label.TextSize           = 11
    label.TextXAlignment     = Enum.TextXAlignment.Left
    label.Parent             = card

    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size               = UDim2.new(1, -70, 0, 14)
        descLabel.Position           = UDim2.new(0, 12, 0, 24)
        descLabel.BackgroundTransparency = 1
        descLabel.Text               = desc
        descLabel.TextColor3         = THEME.TEXT_MUTED
        descLabel.Font               = Enum.Font.Gotham
        descLabel.TextSize           = 9
        descLabel.TextXAlignment     = Enum.TextXAlignment.Left
        descLabel.Parent             = card
    end

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size             = UDim2.new(0, 40, 0, 22)
    toggleBtn.Position         = UDim2.new(1, -52, 0.5, -11)
    toggleBtn.BackgroundColor3 = default and THEME.ACCENT or THEME.BG_MAIN
    toggleBtn.Text             = ""
    toggleBtn.AutoButtonColor  = false
    toggleBtn.Parent           = card
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local toggleDot = Instance.new("Frame")
    toggleDot.Size             = UDim2.new(0, 16, 0, 16)
    toggleDot.Position         = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.BorderSizePixel  = 0
    toggleDot.Parent           = toggleBtn
    Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

    local state = default
    local function setToggleState(newState)
        state = newState
        TweenService:Create(toggleBtn, TweenInfo.new(0.18), {BackgroundColor3 = state and THEME.ACCENT or THEME.BG_MAIN}):Play()
        TweenService:Create(toggleDot, TweenInfo.new(0.18), {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
        callback(state)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        setToggleState(not state)
    end)

    return {
        SetState = setToggleState,
        GetState = function() return state end
    }
end

local function createSlider(parent, title, min, max, default, suffix, callback)
    local card = createCard(parent, nil, 52)

    local label = Instance.new("TextLabel")
    label.Size               = UDim2.new(0.7, 0, 0, 18)
    label.Position           = UDim2.new(0, 12, 0, 8)
    label.BackgroundTransparency = 1
    label.Text               = title
    label.TextColor3         = THEME.TEXT_MAIN
    label.Font               = Enum.Font.GothamBold
    label.TextSize           = 11
    label.TextXAlignment     = Enum.TextXAlignment.Left
    label.Parent             = card

    local valLabel = Instance.new("TextLabel")
    valLabel.Size               = UDim2.new(0.3, -12, 0, 18)
    valLabel.Position           = UDim2.new(0.7, 0, 0, 8)
    valLabel.BackgroundTransparency = 1
    valLabel.Text               = tostring(default) .. (suffix or "")
    valLabel.TextColor3         = THEME.ACCENT
    valLabel.Font               = Enum.Font.GothamBold
    valLabel.TextSize           = 11
    valLabel.TextXAlignment     = Enum.TextXAlignment.Right
    valLabel.Parent             = card

    local track = Instance.new("TextButton")
    track.Size             = UDim2.new(1, -24, 0, 8)
    track.Position         = UDim2.new(0, 12, 0, 32)
    track.BackgroundColor3 = THEME.BG_MAIN
    track.Text             = ""
    track.AutoButtonColor  = false
    track.Parent           = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    local startAlpha = (default - min) / (max - min)
    fill.Size             = UDim2.new(startAlpha, 0, 1, 0)
    fill.BackgroundColor3 = THEME.ACCENT
    fill.BorderSizePixel  = 0
    fill.Parent           = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local currentVal = default
    local draggingSlider = false

    local function setSliderValue(newVal)
        currentVal = math.clamp(math.floor(newVal), min, max)
        local alpha = (currentVal - min) / (max - min)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        valLabel.Text = tostring(currentVal) .. (suffix or "")
        callback(currentVal)
    end

    track.MouseButton1Down:Connect(function() draggingSlider = true end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)

    RunService.RenderStepped:Connect(function()
        if draggingSlider then
            local m = UserInputService:GetMouseLocation()
            local ap = track.AbsolutePosition
            local as = track.AbsoluteSize
            local alpha = math.clamp((m.X - ap.X) / as.X, 0, 1)
            currentVal = math.floor(min + alpha * (max - min))
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            valLabel.Text = tostring(currentVal) .. (suffix or "")
            callback(currentVal)
        end
    end)

    return {
        SetValue = setSliderValue,
        GetValue = function() return currentVal end
    }
end

local function createButton(parent, title, callback)
    local card = createCard(parent, nil, 40)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, -24, 1, -12)
    btn.Position         = UDim2.new(0, 12, 0, 6)
    btn.BackgroundColor3 = THEME.BG_MAIN
    btn.Text             = title
    btn.TextColor3       = THEME.TEXT_MAIN
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 11
    btn.AutoButtonColor  = false
    btn.Parent           = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.BORDER
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.ACCENT, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.12), {Color = THEME.ACCENT}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.BG_MAIN, TextColor3 = THEME.TEXT_MAIN}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.12), {Color = THEME.BORDER}):Play()
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createColorPicker(parent, title, defaultColor, callback)
    local card = createCard(parent, title, 70)
    
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 24, 0, 24)
    preview.Position = UDim2.new(1, -36, 0, 5)
    preview.BackgroundColor3 = defaultColor
    preview.Parent = card
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)
    local pStroke = Instance.new("UIStroke")
    pStroke.Color = THEME.BORDER
    pStroke.Thickness = 1
    pStroke.Parent = preview

    local track = Instance.new("TextButton")
    track.Size             = UDim2.new(1, -24, 0, 14)
    track.Position         = UDim2.new(0, 12, 0, 40)
    track.BackgroundColor3 = Color3.new(1,1,1)
    track.Text             = ""
    track.AutoButtonColor  = false
    track.Parent           = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    gradient.Parent = track
    
    local marker = Instance.new("Frame")
    marker.Size = UDim2.new(0, 4, 1, 4)
    marker.Position = UDim2.new(0, 0, 0, -2)
    marker.BackgroundColor3 = Color3.new(1,1,1)
    marker.BorderSizePixel = 0
    marker.Parent = track
    local mStroke = Instance.new("UIStroke")
    mStroke.Color = Color3.new(0,0,0)
    mStroke.Thickness = 1
    mStroke.Parent = marker

    local dragging = false
    track.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local m = UserInputService:GetMouseLocation()
            local ap = track.AbsolutePosition
            local as = track.AbsoluteSize
            local alpha = math.clamp((m.X - ap.X) / as.X, 0, 1)
            marker.Position = UDim2.new(alpha, -2, 0, -2)
            
            local col = Color3.fromHSV(alpha, 1, 1)
            preview.BackgroundColor3 = col
            callback(col)
        end
    end)
end

-- ══════════════════════════════════════════
--  PAGE 1: TELEPORTS CONTENT (WITH SEARCH BAR)
-- ══════════════════════════════════════════
local telePage = pages["Teleports"]

-- Search Bar Container
local searchCard = createCard(telePage, nil, 36)

local searchBox = Instance.new("TextBox")
searchBox.Size                  = UDim2.new(1, -40, 1, 0)
searchBox.Position              = UDim2.new(0, 12, 0, 0)
searchBox.BackgroundTransparency= 1
searchBox.PlaceholderText       = "Search teleports..."
searchBox.PlaceholderColor3     = THEME.TEXT_MUTED
searchBox.Text                  = ""
searchBox.TextColor3            = THEME.TEXT_MAIN
searchBox.Font                  = Enum.Font.GothamMedium
searchBox.TextSize              = 11
searchBox.TextXAlignment        = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus      = false
searchBox.Parent                = searchCard

local clearSearchBtn = Instance.new("TextButton")
clearSearchBtn.Size               = UDim2.new(0, 20, 0, 20)
clearSearchBtn.Position           = UDim2.new(1, -26, 0.5, -10)
clearSearchBtn.BackgroundTransparency = 1
clearSearchBtn.Text               = "✕"
clearSearchBtn.TextColor3         = THEME.TEXT_MUTED
clearSearchBtn.Font               = Enum.Font.GothamBold
clearSearchBtn.TextSize           = 10
clearSearchBtn.Visible            = false
clearSearchBtn.Parent             = searchCard

local teleCards = {}

for i, loc in ipairs(locations) do
    local card = Instance.new("Frame")
    card.Name             = loc[1]
    card.Size             = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = THEME.BG_CARD
    card.BorderSizePixel  = 0
    card.Parent           = telePage
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.BORDER
    stroke.Thickness = 1
    stroke.Parent = card

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size               = UDim2.new(0.65, 0, 1, 0)
    nameLabel.Position           = UDim2.new(0, 12, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text               = loc[1]
    nameLabel.TextColor3         = THEME.TEXT_MAIN
    nameLabel.Font               = Enum.Font.GothamMedium
    nameLabel.TextSize           = 11
    nameLabel.TextXAlignment     = Enum.TextXAlignment.Left
    nameLabel.Parent             = card

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size             = UDim2.new(0, 80, 0, 24)
    tpBtn.Position         = UDim2.new(1, -88, 0.5, -12)
    tpBtn.BackgroundColor3 = THEME.BG_MAIN
    tpBtn.Text             = "Teleport"
    tpBtn.TextColor3       = THEME.TEXT_MAIN
    tpBtn.Font             = Enum.Font.GothamBold
    tpBtn.TextSize         = 10
    tpBtn.AutoButtonColor  = false
    tpBtn.Parent           = card
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

    local tpStroke = Instance.new("UIStroke")
    tpStroke.Color = THEME.BORDER
    tpStroke.Thickness = 1
    tpStroke.Parent = tpBtn

    tpBtn.MouseEnter:Connect(function()
        TweenService:Create(tpBtn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.ACCENT, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        TweenService:Create(tpStroke, TweenInfo.new(0.12), {Color = THEME.ACCENT}):Play()
    end)
    tpBtn.MouseLeave:Connect(function()
        TweenService:Create(tpBtn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.BG_MAIN, TextColor3 = THEME.TEXT_MAIN}):Play()
        TweenService:Create(tpStroke, TweenInfo.new(0.12), {Color = THEME.BORDER}):Play()
    end)

    tpBtn.MouseButton1Click:Connect(function()
        if isTeleporting then return end
        setStatus("Teleporting: " .. loc[1], THEME.WARNING)
        task.spawn(function()
            teleportTo(loc[2])
            setStatus("Arrived: " .. loc[1], THEME.SUCCESS)
            task.wait(1.5)
            setStatus("Ready", THEME.TEXT_MUTED)
        end)
    end)

    table.insert(teleCards, {card = card, name = loc[1]:lower()})
end

local function filterTeleports(query)
    query = query:lower()
    clearSearchBtn.Visible = (query ~= "")
    for _, item in ipairs(teleCards) do
        if query == "" or item.name:find(query, 1, true) then
            item.card.Visible = true
        else
            item.card.Visible = false
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    filterTeleports(searchBox.Text)
end)

clearSearchBtn.MouseButton1Click:Connect(function()
    searchBox.Text = ""
    filterTeleports("")
end)

-- ══════════════════════════════════════════
--  PAGE 2: DUPE CONTENT (CLEAN & NO EMOJIS)
-- ══════════════════════════════════════════
local dupePage = pages["Dupe"]

local guideCard = createCard(dupePage, "DUPLICATION INSTRUCTIONS", 75)
local guideText = Instance.new("TextLabel")
guideText.Size               = UDim2.new(1, -24, 0, 40)
guideText.Position           = UDim2.new(0, 12, 0, 28)
guideText.BackgroundTransparency = 1
guideText.Text               = "1. Hold the weapon or item you want to duplicate in your character's hand.\n2. Click the Manual Dupe button below."
guideText.TextColor3         = THEME.TEXT_MUTED
guideText.Font               = Enum.Font.Gotham
guideText.TextSize           = 10
guideText.TextXAlignment     = Enum.TextXAlignment.Left
guideText.TextYAlignment     = Enum.TextYAlignment.Top
guideText.Parent             = guideCard

local dupeStatusCard = createCard(dupePage, nil, 36)
local dupeStatusText = Instance.new("TextLabel")
dupeStatusText.Size               = UDim2.new(1, -24, 1, 0)
dupeStatusText.Position           = UDim2.new(0, 12, 0, 0)
dupeStatusText.BackgroundTransparency = 1
dupeStatusText.Text               = "Status: Ready - Equip a weapon and press Manual Dupe"
dupeStatusText.TextColor3         = THEME.TEXT_MUTED
dupeStatusText.Font               = Enum.Font.GothamMedium
dupeStatusText.TextSize           = 10
dupeStatusText.TextXAlignment     = Enum.TextXAlignment.Left
dupeStatusText.Parent             = dupeStatusCard

local function setDupeStatus(msg, color)
    dupeStatusText.Text = "Status: " .. msg
    dupeStatusText.TextColor3 = color or THEME.TEXT_MUTED
end

local isDuping = false

local function getPing()
    local t0 = tick() task.wait(0.05)
    return math.clamp((tick()-t0)*1000, 50, 300)
end

local function performDupe(targetName)
    if isDuping then return end
    isDuping = true
    local Player    = LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Backpack  = Player:WaitForChild("Backpack")
    local Tool
    if targetName then
        Tool = Character:FindFirstChild(targetName) or Backpack:FindFirstChild(targetName)
    else
        Tool = Character:FindFirstChildOfClass("Tool")
    end
    if not Tool then
        setDupeStatus("Equip a weapon first!", THEME.DANGER)
        isDuping = false return
    end
    setDupeStatus("Processing " .. Tool.Name .. "...", THEME.ACCENT)
    Tool.Parent = Backpack
    task.wait(0.5)
    local ToolName  = Tool.Name
    local ToolId    = nil
    local ping      = getPing()
    local delayTime = 0.25 + ((math.clamp(ping,0,300)/300)*0.03)
    local marketConn = RS.MarketItems.ChildAdded:Connect(function(item)
        if item.Name == ToolName then
            local owner = item:WaitForChild("owner", 2)
            if owner and owner.Value == Player.Name then
                ToolId = item:GetAttribute("SpecialId")
            end
        end
    end)
    task.spawn(function() RS.ListWeaponRemote:FireServer(ToolName, 99999) end)
    task.wait(delayTime)
    task.spawn(function() RS.BackpackRemote:InvokeServer("Store", ToolName) end)
    task.wait(3)
    if ToolId then
        task.spawn(function() RS.BuyItemRemote:FireServer(ToolName, "Remove", ToolId) end)
        setDupeStatus("Successfully Duped: " .. ToolName, THEME.SUCCESS)
    else
        setDupeStatus("Retrying SpecialId retrieval...", THEME.WARNING)
    end
    task.spawn(function() RS.BackpackRemote:InvokeServer("Grab", ToolName) end)
    marketConn:Disconnect()
    task.wait(5)
    isDuping = false
end

local manualBtn = Instance.new("TextButton")
manualBtn.Size             = UDim2.new(1, 0, 0, 36)
manualBtn.BackgroundColor3 = THEME.DANGER
manualBtn.Text             = "Manual Dupe"
manualBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
manualBtn.Font             = Enum.Font.GothamBold
manualBtn.TextSize         = 11
manualBtn.AutoButtonColor  = false
manualBtn.Parent           = dupePage
Instance.new("UICorner", manualBtn).CornerRadius = UDim.new(0, 8)
manualBtn.MouseButton1Click:Connect(function() task.spawn(performDupe) end)

-- ──────────────────────────────────────────
--  ANTI-LOSE ITEMS
-- ──────────────────────────────────────────
local antiLoseEnabled = false
local ExemptItems = {
    "Phone",
    "Fist",
    "Shiesty",
    "Bandage",
    "Lemonade",
    "Car keys",
    ".Drum",
    "5.56",
    ".9mm",
    ".Extended",
    ".FNMag",
    ".MacMag",
    ".TecMag",
    ".UziMag",
    "7.62",
    ".308",
    ".10mm"}

local function MarketHasItem(toolName)
    local market = RS:FindFirstChild("MarketItems")
    if not market then return false end
    for _, item in ipairs(market:GetChildren()) do
        if item.Name == toolName and item:FindFirstChild("owner") and item.owner.Value == LocalPlayer.Name then
            return true
        end
    end
    return false
end

local function BackpackHasItem(toolName)
    if not LocalPlayer:FindFirstChild("Backpack") then return false end
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolName then
            return true
        end
    end
    return false
end

local function ForcePutToMarket(toolName)
    local endTime = os.clock() + 12
    while os.clock() < endTime do
        if MarketHasItem(toolName) then return true end
        pcall(function()
            RS.ListWeaponRemote:FireServer(toolName, 999999)
        end)
        task.wait(0.15)
    end
    return false
end

local function ForceRetrieveFromMarket(toolName)
    local market = RS:WaitForChild("MarketItems", 10)
    if not market then return false end
    local endTime = os.clock() + 12
    while os.clock() < endTime do
        for _, item in ipairs(market:GetChildren()) do
            if item.Name == toolName and item:FindFirstChild("owner") and item.owner.Value == LocalPlayer.Name and item:GetAttribute("SpecialId") then
                local special = item:GetAttribute("SpecialId")
                pcall(function()
                    RS.BuyItemRemote:FireServer(toolName, "Remove", special)
                end)
                task.wait(0.2)
                pcall(function()
                    RS.BackpackRemote:InvokeServer("Grab", toolName)
                end)
                task.wait(0.2)
                if BackpackHasItem(toolName) then return true end
            end
        end
        task.wait(0.3)
    end
    return false
end

local function HookAntiLoseCharacter(char)
    local humanoid = char:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.Died:Connect(function()
            if not antiLoseEnabled then return end
            task.wait(0.25)
            if LocalPlayer:FindFirstChild("Backpack") then
                for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and not table.find(ExemptItems, tool.Name) then
                        task.spawn(ForcePutToMarket, tool.Name)
                    end
                end
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    HookAntiLoseCharacter(char)
    if not antiLoseEnabled then return end
    task.delay(2.5, function()
        if not antiLoseEnabled then return end
        local market = RS:FindFirstChild("MarketItems")
        if market then
            for _, item in ipairs(market:GetChildren()) do
                if item:FindFirstChild("owner") and item.owner.Value == LocalPlayer.Name then
                    task.spawn(ForceRetrieveFromMarket, item.Name)
                end
            end
        end
    end)
end)

if LocalPlayer.Character then
    HookAntiLoseCharacter(LocalPlayer.Character)
end

local antiLoseToggle = createToggle(dupePage, "Anti-Lose Items", "Auto-lists weapons on death and retrieves on respawn", false, function(v)
    antiLoseEnabled = v
end)

-- ══════════════════════════════════════════
--  PAGE 3: ESP CONTENT
-- ══════════════════════════════════════════
local espPage = pages["ESP"]

local espEnabled   = false
local espHighlight = false
local espNames     = false
local espHealth    = false
local espDistance  = false
local espObjects   = {}
local espRenderConns = {}

local function cleanESP()
    for _,obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
    espObjects = {}
    for _,conn in pairs(espRenderConns) do pcall(function() conn:Disconnect() end) end
    espRenderConns = {}
end

local function updateESP()
    cleanESP()
    if not espEnabled then return end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character if not char then continue end
        local hrp  = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildWhichIsA("Humanoid")
        local head = char:FindFirstChild("Head")
        if not hrp or not hum or not head then continue end
        if espHighlight then
            local hl = Instance.new("Highlight")
            hl.FillColor = THEME.DANGER
            hl.OutlineColor = THEME.DANGER
            hl.FillTransparency = 1
            hl.OutlineTransparency = 0
            hl.Adornee = char
            hl.Parent = char
            table.insert(espObjects, hl)
        end
        if espNames or espHealth or espDistance then
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 130, 0, 45)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = head
            bb.Parent = char
            table.insert(espObjects, bb)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = THEME.DANGER
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextStrokeTransparency = 0
            lbl.TextStrokeColor3 = Color3.new(0,0,0)
            lbl.Parent = bb

            local conn = RunService.RenderStepped:Connect(function()
                if not lbl.Parent then return end
                local lines = {}
                if espNames then table.insert(lines, plr.Name) end
                if espHealth then table.insert(lines, "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)) end
                if espDistance then
                    local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if lhrp then table.insert(lines, math.floor((hrp.Position - lhrp.Position).Magnitude) .. "m") end
                end
                lbl.Text = table.concat(lines, "\n")
            end)
            table.insert(espRenderConns, conn)
        end
    end
end

local espToggle          = createToggle(espPage, "Enable Esp", "Enable overlay rendering", espEnabled, function(v) espEnabled = v updateESP() end)
local espHighlightToggle = createToggle(espPage, "Player Highlights", "Render red character glow outlines", espHighlight, function(v) espHighlight = v updateESP() end)
local espNamesToggle     = createToggle(espPage, "Player Names", "Display username badges", espNames, function(v) espNames = v updateESP() end)
local espHealthToggle    = createToggle(espPage, "Health Meters", "Show current HP text", espHealth, function(v) espHealth = v updateESP() end)
local espDistToggle      = createToggle(espPage, "Distance Tracking", "Show range in meters", espDistance, function(v) espDistance = v updateESP() end)

local function hookPlayerESP(plr)
    if plr == LocalPlayer then return end
    plr.CharacterAdded:Connect(function() task.wait(1) updateESP() end)
end
for _, plr in pairs(Players:GetPlayers()) do hookPlayerESP(plr) end
Players.PlayerAdded:Connect(function(p) hookPlayerESP(p) end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) updateESP() end)

-- ══════════════════════════════════════════
--  PAGE 4: COMBAT & AIMBOT (MERGED)
-- ══════════════════════════════════════════
local combatPage = pages["Combat"]

-- Movement & Combat State
local currentSpeed   = 16
local speedSlider    = nil
local hitboxEnabled  = false
local hitboxVisible  = true
local hitboxSize     = 12

-- Aimbot & Silent State
local function newKalman() return {x=Vector3.zero,v=Vector3.zero,P=1,Q=0.01,R=0.1,initialized=false} end
local function kalmanUpdate(k,m)
    if not k.initialized then k.x=m k.initialized=true return m end
    local pred=k.x+k.v k.P=k.P+k.Q local gain=k.P/(k.P+k.R)
    k.v=k.v+gain*((m-k.x)-k.v) k.x=pred+gain*(m-pred) k.P=(1-gain)*k.P return k.x
end
local function kalmanForecast(k,dt) return k.x+k.v*dt end

local kalmanFilters       = {}
local aimbotEnabled       = false
local aimbotFOV           = 120
local aimbotSmooth        = 0.10
local aimbotPart          = "Head"
local aimbotConn          = nil
local aimbotLocked        = false
local aimbotLockedTarget  = nil
local silentAimEnabled    = false
local silentAimFOV        = 150
local silentKalman        = {}

-- PERSISTENT WALKSPEED & BYPASS: Use CFrame math to avoid Anti-Cheat teleportation
RunService.RenderStepped:Connect(function(deltaTime)
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hum and hrp and hum.Health > 0 then
        if currentSpeed > 16 then
            hum.WalkSpeed = 16 -- Keep real WalkSpeed safe
            if hum.MoveDirection.Magnitude > 0 then
                local extra = currentSpeed - 16
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (extra * deltaTime))
            end
        end
    end
end)

-- Section 1: Movement & Utility
local hitboxToggle = createToggle(combatPage, "Hitbox Expander", "Enlarges enemy character hitboxes", false, function(v)
    hitboxEnabled = v
    if not v then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local char = plr.Character if not char then continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
end)

local visibleHitboxToggle = createToggle(combatPage, "Visible Hitbox", "Shows or hides the expanded red hitbox box", false, function(v)
    hitboxVisible = v
end)

local hitboxSizeSlider = createSlider(combatPage, "Hitbox Size", 2, 30, 12, " studs", function(val)
    hitboxSize = val
end)

local infJumpConn = nil
createToggle(combatPage, "Infinite Jump", "Jump infinitely in air", false, function(v)
    if v then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    end
end)

local noclipConn = nil
createToggle(combatPage, "Noclip Mode", "Walk through walls and obstacles", false, function(v)
    if v then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character if not char then return end
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        local char = LocalPlayer.Character if char then
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end
    end
end)

createToggle(combatPage, "Fullbright", "Removes darkness and shadows", false, function(v)
    if v then
        game.Lighting.Brightness = 2 game.Lighting.ClockTime = 14 game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false game.Lighting.Ambient = Color3.fromRGB(255,255,255)
    else
        game.Lighting.Brightness = 1 game.Lighting.GlobalShadows = true
        game.Lighting.Ambient = Color3.fromRGB(0,0,0)
    end
end)

local ProximityPromptService = game:GetService("ProximityPromptService")
local instantPromptsEnabled = false
local promptAddedConn = nil
local promptHoldConn = nil
local originalHoldDurations = {}

local function applyInstantPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        if originalHoldDurations[prompt] == nil then
            originalHoldDurations[prompt] = prompt.HoldDuration
        end
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance, 6)
    end
end

local instantPromptsToggle = createToggle(combatPage, "Instant Prompts", "Triggers proximity prompts instantly with 0 hold time", false, function(v)
    instantPromptsEnabled = v
    if v then
        for _, obj in ipairs(workspace:GetDescendants()) do
            applyInstantPrompt(obj)
        end
        promptAddedConn = workspace.DescendantAdded:Connect(function(obj)
            if instantPromptsEnabled then
                applyInstantPrompt(obj)
            end
        end)
        promptHoldConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
            if instantPromptsEnabled then
                if typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, prompt)
                end
            end
        end)
    else
        if promptAddedConn then promptAddedConn:Disconnect() promptAddedConn = nil end
        if promptHoldConn then promptHoldConn:Disconnect() promptHoldConn = nil end
        for prompt, origHold in pairs(originalHoldDurations) do
            if prompt and prompt.Parent then
                pcall(function() prompt.HoldDuration = origHold end)
            end
        end
        table.clear(originalHoldDurations)
    end
end)

-- Section 2: Camera Aimbot & Silent Aim
local silentFovCircle = Drawing.new("Circle")
silentFovCircle.Visible = false
silentFovCircle.Thickness = 1
silentFovCircle.Transparency = 0.7
silentFovCircle.Color = Color3.fromRGB(255, 255, 255)
silentFovCircle.Radius = silentAimFOV
silentFovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    if not silentAimEnabled then
        if silentFovCircle.Visible then silentFovCircle.Visible = false end
        return
    end
    silentFovCircle.Visible = true
    silentFovCircle.Position = UserInputService:GetMouseLocation()
    silentFovCircle.Radius = silentAimFOV
end)

local function getAimbotTarget()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local mousePos = UserInputService:GetMouseLocation()
    local closest, closestDist = nil, aimbotFOV
    for _,plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        local part = char and char:FindFirstChild(aimbotPart) or (char and char:FindFirstChild("HumanoidRootPart"))
        local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
        if not part or not hum or hum.Health <= 0 then continue end
        local sp, on = cam:WorldToViewportPoint(part.Position) if not on then continue end
        local dist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
        if dist < closestDist then closestDist = dist closest = plr end
    end
    return closest
end

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.F then
        if not aimbotEnabled then return end
        if aimbotLocked then
            aimbotLocked = false
            aimbotLockedTarget = nil
            setStatus("Camera Lock Released", THEME.TEXT_MUTED)
        else
            local target = getAimbotTarget()
            if target then
                aimbotLockedTarget = target
                aimbotLocked = true
                setStatus("Locked onto " .. target.Name, THEME.WARNING)
            end
        end
    end
end)

local aimbotToggle = createToggle(combatPage, "Camera Aimbot (F Key)", "Press [F] in-game to lock onto nearest player", false, function(v)
    aimbotEnabled = v
    if v then
        aimbotConn = RunService.RenderStepped:Connect(function()
            if not aimbotLocked or not aimbotLockedTarget or not aimbotLockedTarget.Character then return end
            local part = aimbotLockedTarget.Character:FindFirstChild(aimbotPart) or aimbotLockedTarget.Character:FindFirstChild("HumanoidRootPart")
            if not part then return end
            if not kalmanFilters[aimbotLockedTarget.Name] then kalmanFilters[aimbotLockedTarget.Name] = newKalman() end
            local k = kalmanFilters[aimbotLockedTarget.Name]
            kalmanUpdate(k, part.Position)
            local predicted = kalmanForecast(k, 0.1)
            local cam = workspace.CurrentCamera
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, predicted), aimbotSmooth)
        end)
    else
        aimbotLocked = false
        aimbotLockedTarget = nil
        if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
        kalmanFilters = {}
    end
end)

local aimSmoothSlider = createSlider(combatPage, "Aim Smoothness", 1, 100, 10, "%", function(val)
    aimbotSmooth = math.max(0.01, val / 100)
end)

local headshotToggle = createToggle(combatPage, "Prioritize Headshots", "Targets Head instead of HumanoidRootPart", false, function(v)
    aimbotPart = v and "Head" or "HumanoidRootPart"
end)

local silentAimToggle = createToggle(combatPage, "Silent Aim", "Directs shots to targets inside FOV", false, function(v)
    silentAimEnabled = v
    if not v then silentKalman = {} end
end)

local silentFovSlider = createSlider(combatPage, "Silent Aim FOV Radius", 20, 600, 150, "px", function(val)
    silentAimFOV = val
end)

createColorPicker(combatPage, "Silent Aim FOV Color", Color3.fromRGB(255, 255, 255), function(col)
    silentFovCircle.Color = col
end)

-- Silent Aim Target Search (FOV Circle Redirect)
local function getSilentTarget()
    if not silentAimEnabled then return nil end

    local cam = workspace.CurrentCamera
    if not cam then return nil end

    local closest, closestDist = nil, silentAimFOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character if not char then continue end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local part = char:FindFirstChild(aimbotPart) or char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not part then continue end

        local sp, on = cam:WorldToViewportPoint(part.Position)
        if not on or sp.Z <= 0 then continue end

        local dist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = plr
        end
    end

    return closest
end

local function isHoldingWeapon()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Tool") ~= nil
end

local mouse = LocalPlayer:GetMouse()
local originalIndex
originalIndex = hookmetamethod(game, "__index", function(t, key)
    if not checkcaller() and t == mouse and (key == "Hit" or key == "Target") then
        if silentAimEnabled and isHoldingWeapon() then
            local target = getSilentTarget()
            if target and target.Character then
                local part = target.Character:FindFirstChild(aimbotPart) or target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("Torso")
                if part then
                    if key == "Hit" then
                        return CFrame.new(part.Position)
                    elseif key == "Target" then
                        return part
                    end
                end
            end
        end

        if hitboxEnabled then
            local targetPart = originalIndex(t, "Target")
            if targetPart and targetPart:IsA("BasePart") then
                local char = targetPart.Parent
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local plr = Players:GetPlayerFromCharacter(char)
                    if plr and plr ~= LocalPlayer then
                        local realPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head") or targetPart
                        if key == "Hit" then
                            return CFrame.new(realPart.Position)
                        elseif key == "Target" then
                            return realPart
                        end
                    end
                end
            end
        end
    end

    return originalIndex(t, key)
end)

local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local isExploitCall = (typeof(checkcaller) == "function" and checkcaller())

    if not isExploitCall and hitboxEnabled then
        if method == "Raycast" then
            local args = {...}
            local origin, direction, params = args[1], args[2], args[3]
            local result = originalNamecall(self, origin, direction, params)
            if result and result.Instance then
                local hitPart = result.Instance
                local char = hitPart.Parent
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local plr = Players:GetPlayerFromCharacter(char)
                    if plr and plr ~= LocalPlayer then
                        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head") or hitPart
                        local filterTable = {hitPart}
                        if LocalPlayer.Character then table.insert(filterTable, LocalPlayer.Character) end
                        if workspace.CurrentCamera then table.insert(filterTable, workspace.CurrentCamera) end
                        if params and params.FilterDescendantsInstances then
                            for _, v in ipairs(params.FilterDescendantsInstances) do
                                table.insert(filterTable, v)
                            end
                        end
                        local newParams = RaycastParams.new()
                        newParams.FilterDescendantsInstances = filterTable
                        newParams.FilterType = Enum.RaycastFilterType.Exclude
                        newParams.IgnoreWater = true

                        local bodyDir = (torso.Position - origin).Unit * (direction.Magnitude + 50)
                        local bodyResult = originalNamecall(self, origin, bodyDir, newParams)
                        if bodyResult and bodyResult.Instance then
                            return bodyResult
                        end
                    end
                end
            end
            return result
        elseif method:find("FindPartOnRay") then
            local hitPart, hitPos, hitNorm, hitMat = originalNamecall(self, ...)
            if hitPart then
                local char = hitPart.Parent
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local plr = Players:GetPlayerFromCharacter(char)
                    if plr and plr ~= LocalPlayer then
                        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head") or hitPart
                        return torso, torso.Position, hitNorm, hitMat
                    end
                end
            end
            return hitPart, hitPos, hitNorm, hitMat
        end
    end

    return originalNamecall(self, ...)
end)

Players.PlayerRemoving:Connect(function(plr) silentKalman[plr.Name] = nil end)

-- Blood FX & Bullet Hole Relocator for Hitbox Expander
local function processBloodObject(obj)
    if not hitboxEnabled or not obj or not obj.Parent then return end

    -- NEVER TOUCH RIG ATTACHMENTS OR JOINTS (Prevents character invisibility & joint breaking!)
    if obj:IsA("Attachment") or obj:IsA("Motor6D") or obj:IsA("Value") or obj:IsA("JointInstance") then
        return
    end

    local name = obj.Name:lower()

    -- NEVER TOUCH CHARACTER FACES OR CLOTHING
    if name == "face" or name == "shirt" or name == "pants" or name == "graphic" or name == "texture" or name == "head" then return end
    if obj.Parent and (obj.Parent:IsA("Accessory") or obj.Parent:IsA("Shirt") or obj.Parent:IsA("Pants") or obj.Parent:IsA("ShirtGraphic")) then return end

    local isDecal = obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter")
    local isBloodName = name:find("blood") or name:find("splat") or name:find("hole") or name:find("bullet") or name:find("hit") or name:find("impact") or name:find("wound") or name:find("bleed")

    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
        if hrp and torso then
            -- Case 1: Decal/Texture created directly inside HumanoidRootPart on hit
            if isDecal and obj.Parent == hrp then
                obj.Parent = torso
                break
            end

            -- Case 2: Blood part / decal spawned in workspace near enemy
            if isBloodName then
                local objPos = obj:IsA("BasePart") and obj.Position or nil
                if objPos and (objPos - hrp.Position).Magnitude <= (hitboxSize + 6) then
                    if obj:IsA("BasePart") then
                        obj.CFrame = torso.CFrame
                    elseif isDecal and obj.Parent ~= torso then
                        obj.Parent = torso
                    end
                    break
                end
            end
        end
    end
end

workspace.DescendantAdded:Connect(function(desc)
    if not hitboxEnabled then return end
    processBloodObject(desc)
end)

-- Hitbox Expander Loop
RunService.RenderStepped:Connect(function()
    if not hitboxEnabled then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hrp and hum then
            local isSeated = hum.Sit or hum.SeatPart ~= nil or hum:GetState() == Enum.HumanoidStateType.Seated
            if isSeated then
                -- Reset hitbox back to normal while sitting/inside a car so vehicle physics won't glitch
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            else
                -- Expand hitbox when standing / out of vehicle
                hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hrp.Transparency = hitboxVisible and 0.7 or 1
                hrp.Color = THEME.DANGER
                hrp.Material = Enum.Material.SmoothPlastic

                -- Automatically move any hit decals placed on HumanoidRootPart onto UpperTorso/Torso (ignoring all joints/attachments)
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
                if torso then
                    for _, child in pairs(hrp:GetChildren()) do
                        if (child:IsA("Decal") or child:IsA("Texture") or child:IsA("ParticleEmitter")) and child.Name:lower() ~= "face" then
                            child.Parent = torso
                        end
                    end
                end
            end
            hrp.CanCollide = false
        end
    end
    local myChar = LocalPlayer.Character
    if myChar then
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if myHRP then myHRP.Size = Vector3.new(2,2,1) myHRP.CanCollide = true end
    end
end)

-- ══════════════════════════════════════════
--  PAGE 5: PLAYER CONTENT (FLIGHT)
-- ══════════════════════════════════════════
local playerPage = pages["Player"]

local StarterGui = game:GetService("StarterGui")
local flyEnabled = false
local flySpeed = 80

local flyVelocity = nil
local flyGyro = nil
local flySeat = nil
local flyConnections = {}
local move = { W = false, A = false, S = false, D = false, Space = false, Shift = false }

local function FlyNotify(title, message)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = 2
        })
    end)
end

local function cleanupFly()
    for _, conn in ipairs(flyConnections) do
        if conn and conn.Disconnect then
            pcall(function() conn:Disconnect() end)
        end
    end
    flyConnections = {}

    if flyVelocity and flyVelocity.Parent then flyVelocity:Destroy(); flyVelocity = nil end
    if flyGyro and flyGyro.Parent then flyGyro:Destroy(); flyGyro = nil end
    if flySeat and flySeat.Parent then flySeat:Destroy(); flySeat = nil end

    if typeof(getgenv) == "function" then
        pcall(function() getgenv().SwimMethod = false end)
    end

    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp then
            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                humanoid.PlatformStand = false
                humanoid.Jump = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
end

local flySpeedSlider

local function setupFly()
    cleanupFly()

    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    if typeof(getgenv) == "function" then
        pcall(function() getgenv().SwimMethod = true end)
    end

    local seat = Instance.new("VehicleSeat")
    seat.Name = "FlySeat"
    seat.Anchored = false
    seat.CanCollide = false
    seat.Transparency = 1
    seat.TopSurface = Enum.SurfaceType.Smooth
    seat.BottomSurface = Enum.SurfaceType.Smooth
    seat.CFrame = hrp.CFrame * CFrame.new(0, -3, 0)
    seat.Parent = workspace

    local weld = Instance.new("Weld")
    weld.Part0 = seat
    weld.Part1 = hrp
    weld.C0 = CFrame.new(0, 3, 0)
    weld.Parent = seat

    seat:Sit(humanoid)
    flySeat = seat

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = hrp

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyGyro.P = 50000
    flyGyro.D = 1000
    flyGyro.CFrame = hrp.CFrame
    flyGyro.Parent = hrp

    for k in pairs(move) do move[k] = false end

    local inputBegan = UserInputService.InputBegan:Connect(function(inp, gameProcessed)
        if gameProcessed or UserInputService:GetFocusedTextBox() then return end
        if inp.KeyCode == Enum.KeyCode.W then move.W = true end
        if inp.KeyCode == Enum.KeyCode.A then move.A = true end
        if inp.KeyCode == Enum.KeyCode.S then move.S = true end
        if inp.KeyCode == Enum.KeyCode.D then move.D = true end
        if inp.KeyCode == Enum.KeyCode.Space then move.Space = true end
        if inp.KeyCode == Enum.KeyCode.LeftShift then move.Shift = true end
        if inp.KeyCode == Enum.KeyCode.E then
            flySpeed = math.clamp(flySpeed + 10, 20, 300)
            if flySpeedSlider then flySpeedSlider.SetValue(flySpeed) end
            FlyNotify("Fly Speed", tostring(flySpeed))
        end
        if inp.KeyCode == Enum.KeyCode.Q then
            flySpeed = math.clamp(flySpeed - 10, 20, 300)
            if flySpeedSlider then flySpeedSlider.SetValue(flySpeed) end
            FlyNotify("Fly Speed", tostring(flySpeed))
        end
    end)
    table.insert(flyConnections, inputBegan)

    local inputEnded = UserInputService.InputEnded:Connect(function(inp)
        if inp.KeyCode == Enum.KeyCode.W then move.W = false end
        if inp.KeyCode == Enum.KeyCode.A then move.A = false end
        if inp.KeyCode == Enum.KeyCode.S then move.S = false end
        if inp.KeyCode == Enum.KeyCode.D then move.D = false end
        if inp.KeyCode == Enum.KeyCode.Space then move.Space = false end
        if inp.KeyCode == Enum.KeyCode.LeftShift then move.Shift = false end
    end)
    table.insert(flyConnections, inputEnded)

    local renderStepped = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not flyVelocity or not flyGyro then return end
        local cam = workspace.CurrentCamera
        flyGyro.CFrame = cam.CFrame

        local dir = Vector3.zero
        if move.W then dir = dir + cam.CFrame.LookVector end
        if move.S then dir = dir - cam.CFrame.LookVector end
        if move.A then dir = dir - cam.CFrame.RightVector end
        if move.D then dir = dir + cam.CFrame.RightVector end
        if move.Space then dir = dir + Vector3.new(0, 1, 0) end
        if move.Shift then dir = dir - Vector3.new(0, 1, 0) end

        flyVelocity.Velocity = dir.Magnitude > 0 and (dir.Unit * flySpeed) or Vector3.zero
    end)
    table.insert(flyConnections, renderStepped)

    FlyNotify("Fly", "Enabled (Speed: " .. flySpeed .. ")")
end

local flyToggle

local function setFly(state)
    if flyEnabled == state then return end
    flyEnabled = state
    if flyEnabled then
        task.spawn(setupFly)
    else
        cleanupFly()
        FlyNotify("Fly", "Disabled")
    end
end

flyToggle = createToggle(playerPage, "Player Fly", "Fly with WASD + Space/Shift to ascend/descend", false, function(v)
    setFly(v)
end)

flySpeedSlider = createSlider(playerPage, "Fly Speed", 20, 300, 80, " Speed", function(val)
    flySpeed = val
end)

speedSlider = createSlider(playerPage, "WalkSpeed Multiplier", 16, 150, 16, " Speed", function(val)
    currentSpeed = val
end)

LocalPlayer.CharacterAdded:Connect(function()
    if flyEnabled then
        cleanupFly()
        if flyToggle then flyToggle.SetState(false) end
    end
end)

-- ──────────────────────────────────────────
--  RESPAWN UTILITIES
-- ──────────────────────────────────────────
createCard(playerPage, "RESPAWN UTILITIES", 28)

local fastRespawnEnabled = false
local respawnWhereDiedEnabled = false
local deathPosition = nil
local swimMethod = false
local fastRespawnConnection = nil

-- Anti-cheat bypass loop (prevents teleport kicks)
task.spawn(function()
    while true do
        task.wait()
        if swimMethod then
            local p = LocalPlayer
            if p and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
            end
        end
    end
end)

local function hookFastRespawn()
    if fastRespawnConnection then pcall(function() fastRespawnConnection:Disconnect() end) end
    fastRespawnConnection = RunService.PreRender:Connect(function()
        if not fastRespawnEnabled then return end
        if not LocalPlayer.Character then return end
        local h = LocalPlayer.Character:FindFirstChild("Humanoid")
        if h and h.Health <= 0 then 
            pcall(function() RS.LoadCharacter:FireServer() end)
            pcall(function() RS.RespawnRE:FireServer() end)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) 
        end
    end)
end

-- Backup loop for fast respawn
task.spawn(function()
    while true do
        task.wait(0.1)
        if fastRespawnEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then
                pcall(function() RS.RespawnRE:FireServer() end)
            end
        end
    end
end)

local function hookDeathLocation(char)
    local humanoid = char:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.Died:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then 
                deathPosition = hrp.Position
                if typeof(getgenv) == "function" then
                    getgenv().deathPosition = deathPosition
                end
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    hookDeathLocation(char)

    if respawnWhereDiedEnabled and deathPosition then
        task.wait(1)
        swimMethod = true
        task.wait(0.5)
        local newHRP = char:WaitForChild("HumanoidRootPart", 5)
        if newHRP then 
            newHRP.CFrame = CFrame.new(deathPosition) 
        end
        swimMethod = false
    end
end)

if LocalPlayer.Character then
    hookDeathLocation(LocalPlayer.Character)
end

local fastRespawnToggle = createToggle(playerPage, "Faster Respawn", "Instantly triggers respawn remotes upon death", false, function(v)
    fastRespawnEnabled = v
    _G.respawn = v
    if v then
        hookFastRespawn()
    else
        if fastRespawnConnection then 
            fastRespawnConnection:Disconnect() 
            fastRespawnConnection = nil 
        end
    end
end)

local respawnWhereDiedToggle = createToggle(playerPage, "Respawn Where Died", "Teleports you back to your death location on respawn", false, function(v)
    respawnWhereDiedEnabled = v
    if typeof(getgenv) == "function" then
        getgenv().respawnWhereDied = v
    end
end)



-- ──────────────────────────────────────────
--  GUN MODIFICATIONS SUITE
-- ──────────────────────────────────────────
createCard(playerPage, "GUN MODIFICATIONS", 28)

local function GetGunSettings()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool or not tool:FindFirstChild("Setting") then
        return nil, nil
    end
    local success, res = pcall(function() return require(tool.Setting) end)
    if success and res then
        return res, tool
    end
    return nil, nil
end

local function ApplyInfiniteAmmo()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then
        FlyNotify("Gun Mod", "Equip a gun first!")
        return
    end

    local settings, _ = GetGunSettings()
    if settings then
        settings.LimitedAmmoEnabled = false
        settings.MaxAmmo = 80000
        settings.AmmoPerMag = 80000
        settings.Ammo = 80000
        settings.StoredAmmo = 80000
        settings.MagCount = 80000
    end

    local gunScript = tool:FindFirstChild("GunScript_Local")
    if gunScript then
        pcall(function()
            if typeof(getsenv) == "function" and typeof(debug) == "table" and debug.setupvalue then
                local env = getsenv(gunScript)
                if env and env.Reload then
                    debug.setupvalue(env.Reload, 3, 80000)
                    debug.setupvalue(env.Reload, 5, 80000)
                end
            end
        end)
    end
    FlyNotify("Gun Mod", "Infinite Ammo Applied! Press R once if needed.")
end

createButton(playerPage, "Apply Infinite Ammo (80,000)", function()
    ApplyInfiniteAmmo()
end)

local infDamageEnabled = false
local function ToggleInfDamage(state)
    infDamageEnabled = (state ~= nil) and state or not infDamageEnabled
    if infDamageEnabled then
        task.spawn(function()
            while infDamageEnabled do
                local s = GetGunSettings()
                if s then s.BaseDamage = 9e9 end
                task.wait(0.5)
            end
        end)
    end
end

local infDamageToggle = createToggle(playerPage, "Infinite Damage", "Sets weapon BaseDamage to 9,000,000,000", false, function(v)
    ToggleInfDamage(v)
end)

local noSpreadEnabled = false
local function ToggleNoSpread(state)
    noSpreadEnabled = (state ~= nil) and state or not noSpreadEnabled
    if noSpreadEnabled then
        task.spawn(function()
            while noSpreadEnabled do
                local s = GetGunSettings()
                if s then
                    pcall(function()
                        s.SpreadXY = 0
                        s.SpreadYX = 0
                        s.Spread = 0
                        s.SpreadX = 0
                        s.SpreadY = 0
                    end)
                end
                task.wait(0.5)
            end
        end)
    end
end

local noSpreadToggle = createToggle(playerPage, "No Spread", "Removes all bullet spread/bloom", false, function(v)
    ToggleNoSpread(v)
end)

local noJamEnabled = false
local function ToggleNoJam(state)
    noJamEnabled = (state ~= nil) and state or not noJamEnabled
    if noJamEnabled then
        task.spawn(function()
            while noJamEnabled do
                local s = GetGunSettings()
                if s then
                    pcall(function() s.JamChance = 0 end)
                end
                task.wait(0.5)
            end
        end)
    end
end

local noJamToggle = createToggle(playerPage, "No Jam", "Prevents weapon from jamming (JamChance = 0)", false, function(v)
    ToggleNoJam(v)
end)

local rainbowGunEnabled = false
local function ToggleRainbowGun(state)
    rainbowGunEnabled = (state ~= nil) and state or not rainbowGunEnabled
    if rainbowGunEnabled then
        task.spawn(function()
            while rainbowGunEnabled do
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then
                    local color = Color3.fromHSV(tick() % 1, 1, 1)
                    for _, part in pairs(tool:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "Handle" then
                            part.Color = color
                            part.Material = Enum.Material.Neon
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end

local rainbowGunToggle = createToggle(playerPage, "Rainbow Gun Neon", "Animated RGB Neon material on weapon", false, function(v)
    ToggleRainbowGun(v)
end)

local GunSkins = {
    "rbxassetid://83922435917330",
    "rbxassetid://75965794858060",
    "rbxassetid://104925026556009",
    "rbxassetid://113000073171004",
    "rbxassetid://139546409781319"
}

local function ApplySkin(tool, imageId)
    if not tool then return end
    for _, obj in ipairs(tool:GetDescendants()) do
        if obj:IsA("MeshPart") then
            pcall(function() obj.TextureID = imageId end)
            pcall(function() obj.Color = Color3.fromRGB(255, 255, 255) end)
        elseif obj:IsA("BasePart") then
            for _, child in ipairs(obj:GetChildren()) do
                if child.Name == "ScorpioSkin" then child:Destroy() end
            end
            for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
                local decal = Instance.new("Decal")
                decal.Name = "ScorpioSkin"
                decal.Texture = imageId
                decal.Face = face
                decal.Parent = obj
            end
        end
        if obj:IsA("SpecialMesh") then
            pcall(function() obj.TextureId = imageId end)
        end
    end
end

local galaxySkinsEnabled = false
local function ToggleGalaxySkins(state)
    galaxySkinsEnabled = (state ~= nil) and state or not galaxySkinsEnabled
    if galaxySkinsEnabled then
        task.spawn(function()
            local index = 1
            while galaxySkinsEnabled do
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    ApplySkin(tool, GunSkins[index])
                end
                index = (index % #GunSkins) + 1
                task.wait(2)
            end
        end)
    end
end

local galaxySkinsToggle = createToggle(playerPage, "Galaxy Skins", "Animated cycling Galaxy textures", false, function(v)
    ToggleGalaxySkins(v)
end)

-- ══════════════════════════════════════════
--  PAGE 6: CAR MODS CONTENT
-- ══════════════════════════════════════════
local carModsPage = pages["Car Mods"]

-- ── 1. VEHICLE UTILITIES (BRING & FLY) ──
createCard(carModsPage, "VEHICLE CONTROLS", 28)

local function BringNearestCar()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 3)
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end

    local nearestCar, nearestDist = nil, math.huge

    local CivCars = workspace:FindFirstChild("CivCars")
    if CivCars then
        for _, car in ipairs(CivCars:GetChildren()) do
            if car:IsA("Model") then
                local seat = car:FindFirstChild("DriveSeat")
                if seat and not seat.Occupant then
                    if not car.PrimaryPart then
                        local body = car:FindFirstChild("Body")
                        car.PrimaryPart = (body and body:FindFirstChild("#Weight")) or seat
                    end
                    if car.PrimaryPart then
                        local dist = (car.PrimaryPart.Position - hrp.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearestCar = car
                        end
                    end
                end
            end
        end
    end

    if not nearestCar then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") and not v.Occupant then
                local model = v:FindFirstAncestorOfClass("Model")
                if model then
                    local dist = (v.Position - hrp.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestCar = model
                    end
                end
            end
        end
    end

    if not nearestCar then
        FlyNotify("Car", "No free car found!")
        return
    end

    local seat = nearestCar:FindFirstChild("DriveSeat") or nearestCar:FindFirstChildWhichIsA("VehicleSeat")
    if not seat then
        FlyNotify("Car", "No drive seat found!")
        return
    end

    if not nearestCar.PrimaryPart then
        nearestCar.PrimaryPart = nearestCar:FindFirstChildWhichIsA("BasePart") or seat
    end

    nearestCar:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -6) * CFrame.Angles(0, math.rad(180), 0))
    seat:Sit(hum)
    FlyNotify("Car", "Car brought!")
end

createButton(carModsPage, "Bring Nearest Car", function()
    BringNearestCar()
end)

local carFlyEnabled = false
local carFlySpeed = 120

local cfHum, cfSeat, cfCar, cfRoot
local cfBV, cfBG, cfLastCar

local function cfCleanup()
    if cfBV then cfBV:Destroy(); cfBV = nil end
    if cfBG then cfBG:Destroy(); cfBG = nil end
end

local function cfSetup()
    cfCleanup()
    if not carFlyEnabled then return end

    local char = LocalPlayer.Character
    if not char then return end
    cfHum = char:FindFirstChildWhichIsA("Humanoid")
    if not cfHum then return end

    cfSeat = cfHum.SeatPart
    if not cfSeat or not cfSeat:IsA("VehicleSeat") then return end

    cfCar = cfSeat.Parent
    if not cfCar then return end

    cfRoot = cfCar.PrimaryPart or cfSeat
    cfLastCar = cfCar

    for _, v in ipairs(cfCar:GetChildren()) do
        if v:IsA("BasePart") and not v.Name:lower():find("wheel") then
            v.CanCollide = false
        end
    end

    cfBV = Instance.new("BodyVelocity")
    cfBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    cfBV.Velocity = Vector3.zero
    cfBV.Parent = cfRoot

    cfBG = Instance.new("BodyGyro")
    cfBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    cfBG.P = 25000
    cfBG.D = 1500
    cfBG.CFrame = cfRoot.CFrame
    cfBG.Parent = cfRoot
end

RunService.RenderStepped:Connect(function()
    if not carFlyEnabled then cfCleanup(); return end
    if not cfHum or cfHum.SeatPart ~= cfSeat then return end
    if not cfRoot or not cfBV or not cfBG then cfSetup(); return end

    local cam = workspace.CurrentCamera
    local camCF = cam.CFrame
    local camLook = camCF.LookVector
    local camRight = camCF.RightVector

    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        cfBG.CFrame = CFrame.lookAt(cfRoot.Position, cfRoot.Position + camLook)
    end

    local move = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camLook end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camLook end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camRight end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camRight end

    cfBV.Velocity = move.Magnitude > 0 and (move.Unit * carFlySpeed) or Vector3.zero
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        local char = LocalPlayer.Character
        if char then
            local h = char:FindFirstChildWhichIsA("Humanoid")
            if h then
                local seat = h.SeatPart
                if seat and seat:IsA("VehicleSeat") then
                    if seat.Parent ~= cfLastCar and carFlyEnabled then cfSetup() end
                else
                    if cfLastCar then cfCleanup(); cfLastCar = nil end
                end
            end
        end
    end
end)

local carFlyToggle

local function setCarFly(state)
    if carFlyEnabled == state then return end
    carFlyEnabled = state
    if carFlyEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildWhichIsA("Humanoid")
        if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
            cfSetup()
            FlyNotify("Car Fly", "Active! WASD to fly (Right Click to steer)")
        else
            FlyNotify("Car Fly", "Get in a car first!")
        end
    else
        cfCleanup()
        FlyNotify("Car Fly", "Disabled")
    end
end

carFlyToggle = createToggle(carModsPage, "Car Fly", "Fly vehicle with WASD + Right Click to steer", false, function(v)
    setCarFly(v)
end)

local carFlySpeedSlider = createSlider(carModsPage, "Car Fly Speed", 20, 300, 120, " Speed", function(val)
    carFlySpeed = val
end)

-- ── 2. VEHICLE ACCELERATION & BRAKES ──
createCard(carModsPage, "DRIVING ACCELERATION & BRAKES", 28)

local VM = { 
    SpeedEnabled = false,
    SpeedValue = 5 / 1000,
    BreakEnabled = false,
    BreakValue = 170 / 1000,
    InstantStop = false,
    InstantStopBind = Enum.KeyCode.V
}

local function _vmSeat()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then 
        return hum.SeatPart 
    end
end

RunService.Heartbeat:Connect(function()
    -- Velocity Speed (Hold W)
    if VM.SpeedEnabled and UserInputService:IsKeyDown(Enum.KeyCode.W) then
        local s = _vmSeat()
        if s then
            if s.AssemblyLinearVelocity.Magnitude < 0.5 then
                s.AssemblyLinearVelocity = s.AssemblyLinearVelocity + (s.CFrame.LookVector * 1.5)
            else
                s.AssemblyLinearVelocity = s.AssemblyLinearVelocity * Vector3.new(1 + VM.SpeedValue, 1, 1 + VM.SpeedValue)
            end
        end
    end

    -- Break Velocity (Hold Shift)
    local isShiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
    if VM.BreakEnabled and isShiftDown then
        local s = _vmSeat()
        if s then 
            s.AssemblyLinearVelocity = s.AssemblyLinearVelocity * Vector3.new(1 - VM.BreakValue, 1, 1 - VM.BreakValue) 
        end
    end

    -- Instant Break (Hold V)
    if VM.InstantStop and VM.InstantStopBind and UserInputService:IsKeyDown(VM.InstantStopBind) then
        local s = _vmSeat()
        if s then 
            s.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            s.AssemblyAngularVelocity = Vector3.new(0, 0, 0) 
        end
    end
end)

local velocitySpeedToggle = createToggle(carModsPage, "Velocity Speed Enabled", "Hold W to accelerate with velocity scaling", VM.SpeedEnabled, function(v)
    VM.SpeedEnabled = v
end)

local speedValueSlider = createSlider(carModsPage, "Speed Value", 1, 25, 5, " (x0.001)", function(val)
    VM.SpeedValue = val / 1000
end)

local breakVelocityToggle = createToggle(carModsPage, "Break Velocity Enabled", "Hold Shift to brake with velocity deceleration", VM.BreakEnabled, function(v)
    VM.BreakEnabled = v
end)

local breakValueSlider = createSlider(carModsPage, "Break Value", 10, 300, 170, " (x0.001)", function(val)
    VM.BreakValue = val / 1000
end)

local instantBreakToggle = createToggle(carModsPage, "Instant Break Enabled", "Hold [V] to immediately freeze vehicle in place", VM.InstantStop, function(v)
    VM.InstantStop = v
end)

-- ── 3. AUTOMATION & PROTECTION ──
createCard(carModsPage, "AUTOMATION & PROTECTION", 28)

local infFuelEnabled = false
local fuelConnection = nil

local function ToggleInfFuel(state)
    infFuelEnabled = (state ~= nil) and state or not infFuelEnabled

    if fuelConnection then
        fuelConnection:Disconnect()
        fuelConnection = nil
    end

    if infFuelEnabled then
        local pumps = {}
        local lastScan = 0

        fuelConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if not hum or not hum.SeatPart then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if tick() - lastScan > 4 then
                lastScan = tick()
                pumps = {}
                local map = workspace:FindFirstChild("1# Map")
                if map then
                    for _, v in ipairs(map:GetDescendants()) do
                        if v.Name == "#Pump" and v:IsA("MeshPart") then
                            table.insert(pumps, v)
                        end
                    end
                end
            end

            for _, pump in ipairs(pumps) do
                if pump.Parent and (pump.Position - hrp.Position).Magnitude <= 18.5 then
                    if not LocalPlayer:GetAttribute("PaidGas") then
                        pcall(function() RS.RequestRefill:FireServer("Purchase") end)
                    else
                        pcall(function() RS.RequestRefill:FireServer(true) end)
                    end
                end
            end
        end)
    end
end

local infFuelToggle = createToggle(carModsPage, "Infinite / Auto Fuel", "Automatically purchases gas when near pumps", infFuelEnabled, function(v)
    ToggleInfFuel(v)
end)

local antiCarKBEnabled = false
local antiCarKBConn = nil

local function ToggleAntiCarKnockback(state)
    antiCarKBEnabled = (state ~= nil) and state or not antiCarKBEnabled

    if antiCarKBConn then
        antiCarKBConn:Disconnect()
        antiCarKBConn = nil
    end

    if antiCarKBEnabled then
        antiCarKBConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local c = LocalPlayer.Character
                if not c then return end
                local hrp = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildWhichIsA("Humanoid")
                if not hrp or not hum then return end

                hum.PlatformStand = false
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Ragdoll then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end

                local v = hrp.AssemblyLinearVelocity
                if math.sqrt(v.X * v.X + v.Z * v.Z) > 90 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, math.max(v.Y, -10), 0)
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        end)
    end
end

local antiCarKBToggle = createToggle(carModsPage, "Anti Car Knockback", "Prevents being flung or ragdolled by cars", antiCarKBEnabled, function(v)
    ToggleAntiCarKnockback(v)
end)

-- Features start disabled by default until toggled on in menu
-- ToggleInfFuel(true)
-- ToggleAntiCarKnockback(true)

-- ══════════════════════════════════════════
--  PAGE 7: THEME / CUSTOMIZATION CONTENT
-- ══════════════════════════════════════════
local themePage = pages["Theme"]

local THEMES = {
    ["Cyber Blue"] = {
        BG_MAIN       = Color3.fromRGB(10, 14, 23),
        BG_SIDEBAR    = Color3.fromRGB(15, 20, 33),
        BG_CARD       = Color3.fromRGB(20, 29, 48),
        BG_CARD_HOVER = Color3.fromRGB(28, 40, 66),
        BORDER        = Color3.fromRGB(36, 54, 88),
        ACCENT        = Color3.fromRGB(14, 165, 233),
        ACCENT_GLOW   = Color3.fromRGB(2, 132, 199),
        TEXT_MAIN     = Color3.fromRGB(240, 246, 255),
        TEXT_MUTED    = Color3.fromRGB(125, 150, 185),
        SUCCESS       = Color3.fromRGB(16, 185, 129),
        WARNING       = Color3.fromRGB(245, 158, 11),
        DANGER        = Color3.fromRGB(239, 68, 68),
        PURPLE        = Color3.fromRGB(139, 92, 246),
    },
    ["Ruby Red"] = {
        BG_MAIN       = Color3.fromRGB(19, 11, 11),
        BG_SIDEBAR    = Color3.fromRGB(27, 16, 16),
        BG_CARD       = Color3.fromRGB(36, 21, 21),
        BG_CARD_HOVER = Color3.fromRGB(48, 28, 28),
        BORDER        = Color3.fromRGB(60, 35, 35),
        ACCENT        = Color3.fromRGB(239, 68, 68),
        ACCENT_GLOW   = Color3.fromRGB(220, 38, 38),
        TEXT_MAIN     = Color3.fromRGB(250, 240, 240),
        TEXT_MUTED    = Color3.fromRGB(165, 130, 130),
        SUCCESS       = Color3.fromRGB(16, 185, 129),
        WARNING       = Color3.fromRGB(245, 158, 11),
        DANGER        = Color3.fromRGB(239, 68, 68),
        PURPLE        = Color3.fromRGB(139, 92, 246),
    },
    ["Emerald Green"] = {
        BG_MAIN       = Color3.fromRGB(11, 19, 14),
        BG_SIDEBAR    = Color3.fromRGB(16, 27, 20),
        BG_CARD       = Color3.fromRGB(21, 36, 26),
        BG_CARD_HOVER = Color3.fromRGB(28, 48, 35),
        BORDER        = Color3.fromRGB(35, 60, 43),
        ACCENT        = Color3.fromRGB(16, 185, 129),
        ACCENT_GLOW   = Color3.fromRGB(5, 150, 105),
        TEXT_MAIN     = Color3.fromRGB(240, 250, 244),
        TEXT_MUTED    = Color3.fromRGB(130, 165, 143),
        SUCCESS       = Color3.fromRGB(16, 185, 129),
        WARNING       = Color3.fromRGB(245, 158, 11),
        DANGER        = Color3.fromRGB(239, 68, 68),
        PURPLE        = Color3.fromRGB(139, 92, 246),
    },
    ["Amethyst Purple"] = {
        BG_MAIN       = Color3.fromRGB(15, 11, 19),
        BG_SIDEBAR    = Color3.fromRGB(21, 16, 27),
        BG_CARD       = Color3.fromRGB(28, 21, 36),
        BG_CARD_HOVER = Color3.fromRGB(38, 28, 48),
        BORDER        = Color3.fromRGB(46, 35, 60),
        ACCENT        = Color3.fromRGB(168, 85, 247),
        ACCENT_GLOW   = Color3.fromRGB(147, 51, 234),
        TEXT_MAIN     = Color3.fromRGB(246, 240, 250),
        TEXT_MUTED    = Color3.fromRGB(148, 130, 165),
        SUCCESS       = Color3.fromRGB(16, 185, 129),
        WARNING       = Color3.fromRGB(245, 158, 11),
        DANGER        = Color3.fromRGB(239, 68, 68),
        PURPLE        = Color3.fromRGB(139, 92, 246),
    }
}

local function applyTheme(themeName)
    local oldTheme = {}
    for k,v in pairs(THEME) do oldTheme[k] = v end
    local newTheme = THEMES[themeName]
    if not newTheme then return end
    for k,v in pairs(newTheme) do THEME[k] = v end

    local function matchColor(c1, c2)
        return math.round(c1.R * 255) == math.round(c2.R * 255) and
               math.round(c1.G * 255) == math.round(c2.G * 255) and
               math.round(c1.B * 255) == math.round(c2.B * 255)
    end

    local colorPriority = {
        "BG_MAIN", "BG_SIDEBAR", "BG_CARD", "BG_CARD_HOVER", 
        "TEXT_MAIN", "TEXT_MUTED", "ACCENT", "BORDER", 
        "ACCENT_GLOW", "SUCCESS", "WARNING", "DANGER", "PURPLE"
    }

    local function updateColor(prop, obj)
        for _, key in ipairs(colorPriority) do
            local oldColor = oldTheme[key]
            if oldColor and matchColor(obj[prop], oldColor) and newTheme[key] then
                obj[prop] = newTheme[key]
                break
            end
        end
    end

    for _, obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("GuiObject") then
            pcall(function() updateColor("BackgroundColor3", obj) end)
            pcall(function() updateColor("BorderColor3", obj) end)
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                pcall(function() updateColor("TextColor3", obj) end)
            end
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                pcall(function() updateColor("ImageColor3", obj) end)
            end
            if obj:IsA("ScrollingFrame") then
                pcall(function() updateColor("ScrollBarImageColor3", obj) end)
            end
        elseif obj:IsA("UIStroke") then
            pcall(function() updateColor("Color", obj) end)
        end
    end
    
    for _, tData in pairs(tabs) do
        if tData.page.Visible then
            tData.btn.BackgroundColor3 = THEME.BG_CARD
            tData.label.TextColor3 = THEME.TEXT_MAIN
            tData.bar.BackgroundColor3 = THEME.ACCENT
        else
            tData.btn.BackgroundColor3 = THEME.BG_SIDEBAR
            tData.label.TextColor3 = THEME.TEXT_MUTED
            tData.bar.BackgroundColor3 = THEME.ACCENT
        end
    end
end

local function applyFont(fontFamilyStr)
    for _, obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function()
                local w = obj.FontFace.Weight
                local s = obj.FontFace.Style
                obj.FontFace = Font.new(fontFamilyStr, w, s)
            end)
        end
    end
end

-- ──────────────────────────────────────────
--  LOCK TIME TO DAY / NIGHT
-- ──────────────────────────────────────────
local Lighting = game:GetService("Lighting")

local timeConnection = nil
local lockedTime = nil

local function LockTime(clockTime)
    if timeConnection then
        timeConnection:Disconnect()
        timeConnection = nil
    end

    if clockTime == nil then
        lockedTime = nil
        return
    end

    lockedTime = clockTime
    Lighting.ClockTime = lockedTime

    timeConnection = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
        if lockedTime ~= nil and Lighting.ClockTime ~= lockedTime then
            Lighting.ClockTime = lockedTime
        end
    end)
end

local lockDayToggle, lockNightToggle

lockDayToggle = createToggle(themePage, "Lock to Day ☀️", "Freezes game time at noon (12:00)", false, function(v)
    if v then
        if lockNightToggle and lockNightToggle.GetState() then
            lockNightToggle.SetState(false)
        end
        LockTime(12)
    else
        if not (lockNightToggle and lockNightToggle.GetState()) then
            LockTime(nil)
        end
    end
end)

lockNightToggle = createToggle(themePage, "Lock to Night 🌙", "Freezes game time at midnight (0:00)", false, function(v)
    if v then
        if lockDayToggle and lockDayToggle.GetState() then
            lockDayToggle.SetState(false)
        end
        LockTime(0)
    else
        if not (lockDayToggle and lockDayToggle.GetState()) then
            LockTime(nil)
        end
    end
end)

createCard(themePage, nil, 10).BackgroundTransparency = 1 -- spacer

createButton(themePage, "Theme: Cyber Blue", function() applyTheme("Cyber Blue") end)
createButton(themePage, "Theme: Ruby Red", function() applyTheme("Ruby Red") end)
createButton(themePage, "Theme: Emerald Green", function() applyTheme("Emerald Green") end)
createButton(themePage, "Theme: Amethyst Purple", function() applyTheme("Amethyst Purple") end)
createCard(themePage, nil, 10).BackgroundTransparency = 1 -- spacer
createButton(themePage, "Font: Gotham (Default)", function() applyFont("rbxasset://fonts/families/GothamSSm.json") end)
createButton(themePage, "Font: Roboto", function() applyFont("rbxasset://fonts/families/Roboto.json") end)
createButton(themePage, "Font: Ubuntu", function() applyFont("rbxasset://fonts/families/Ubuntu.json") end)
createButton(themePage, "Font: Source Sans Pro", function() applyFont("rbxasset://fonts/families/SourceSansPro.json") end)

-- ══════════════════════════════════════════
--  PAGE 8: CONFIGS CONTENT
-- ══════════════════════════════════════════
local configsPage = pages["Configs"]

local configGuideCard = createCard(configsPage, "CONFIGURATION MANAGER", 60)
local configGuideText = Instance.new("TextLabel")
configGuideText.Size               = UDim2.new(1, -24, 0, 30)
configGuideText.Position           = UDim2.new(0, 12, 0, 24)
configGuideText.BackgroundTransparency = 1
configGuideText.Text               = "Save custom presets, view all saved configurations below, and load or delete them with one click."
configGuideText.TextColor3         = THEME.TEXT_MUTED
configGuideText.Font               = Enum.Font.Gotham
configGuideText.TextSize           = 10
configGuideText.TextXAlignment     = Enum.TextXAlignment.Left
configGuideText.TextYAlignment     = Enum.TextYAlignment.Top
configGuideText.Parent             = configGuideCard

local configInputCard = createCard(configsPage, nil, 40)
local configNameInput = Instance.new("TextBox")
configNameInput.Size                  = UDim2.new(1, -24, 1, 0)
configNameInput.Position              = UDim2.new(0, 12, 0, 0)
configNameInput.BackgroundTransparency= 1
configNameInput.PlaceholderText       = "Type Config Name Here..."
configNameInput.PlaceholderColor3     = THEME.TEXT_MUTED
configNameInput.Text                  = ""
configNameInput.TextColor3            = THEME.TEXT_MAIN
configNameInput.Font                  = Enum.Font.GothamMedium
configNameInput.TextSize              = 11
configNameInput.TextXAlignment        = Enum.TextXAlignment.Left
configNameInput.ClearTextOnFocus      = false
configNameInput.Parent                = configInputCard

local CONFIG_FOLDER = "BronxHub_Configs"
local refreshConfigList

local function ensureFolder()
    pcall(function()
        if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
            if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
        end
    end)
end

local function saveConfig(name)
    if not name or name == "" then name = "default" end
    ensureFolder()
    local data = {
        currentSpeed     = currentSpeed,
        hitboxEnabled    = hitboxEnabled,
        hitboxVisible    = hitboxVisible,
        hitboxSize       = hitboxSize,
        aimbotEnabled    = aimbotEnabled,
        aimbotSmooth     = aimbotSmooth,
        aimbotPart       = aimbotPart,
        silentAimEnabled = silentAimEnabled,
        silentAimFOV     = silentAimFOV,
        espEnabled       = espEnabled,
        espHighlight     = espHighlight,
        espNames         = espNames,
        espHealth        = espHealth,
        espDistance      = espDistance,
        antiLoseEnabled  = antiLoseEnabled,
        instantPromptsEnabled = instantPromptsEnabled,
        lockedTime       = lockedTime,
        flySpeed         = flySpeed,
        fastRespawnEnabled = fastRespawnEnabled,
        respawnWhereDiedEnabled = respawnWhereDiedEnabled,
        carFlySpeed      = carFlySpeed,
        velocitySpeedEnabled = VM.SpeedEnabled,
        speedValue           = math.floor(VM.SpeedValue * 1000),
        breakVelocityEnabled = VM.BreakEnabled,
        breakValue           = math.floor(VM.BreakValue * 1000),
        instantBreakEnabled  = VM.InstantStop,
        infFuelEnabled   = infFuelEnabled,
        antiCarKBEnabled = antiCarKBEnabled,
        infDamageEnabled = infDamageEnabled,
        noSpreadEnabled  = noSpreadEnabled,
        noJamEnabled     = noJamEnabled,
        rainbowGunEnabled = rainbowGunEnabled,
        galaxySkinsEnabled = galaxySkinsEnabled,
    }
    local success, jsonStr = pcall(function() return game:GetService("HttpService"):JSONEncode(data) end)
    if success and typeof(writefile) == "function" then
        pcall(writefile, CONFIG_FOLDER .. "/" .. name .. ".json", jsonStr)
        setStatus("Config Saved: " .. name, THEME.SUCCESS)
        if refreshConfigList then refreshConfigList() end
    else
        setStatus("Save failed or FileSystem not supported", THEME.DANGER)
    end
end

local function loadConfig(name)
    if not name or name == "" then name = "default" end
    local filePath = CONFIG_FOLDER .. "/" .. name .. ".json"
    if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(filePath) then
        local content = readfile(filePath)
        local success, data = pcall(function() return game:GetService("HttpService"):JSONDecode(content) end)
        if success and typeof(data) == "table" then
            if data.currentSpeed ~= nil and speedSlider then speedSlider.SetValue(data.currentSpeed) end
            if data.hitboxEnabled ~= nil and hitboxToggle then hitboxToggle.SetState(data.hitboxEnabled) end
            if data.hitboxVisible ~= nil and visibleHitboxToggle then visibleHitboxToggle.SetState(data.hitboxVisible) end
            if data.hitboxSize ~= nil and hitboxSizeSlider then hitboxSizeSlider.SetValue(data.hitboxSize) end
            if data.aimbotEnabled ~= nil and aimbotToggle then aimbotToggle.SetState(data.aimbotEnabled) end
            if data.aimbotSmooth ~= nil and aimSmoothSlider then aimSmoothSlider.SetValue(data.aimbotSmooth * 100) end
            if data.aimbotPart ~= nil and headshotToggle then headshotToggle.SetState(data.aimbotPart == "Head") end
            if data.silentAimEnabled ~= nil and silentAimToggle then silentAimToggle.SetState(data.silentAimEnabled) end
            if data.silentAimFOV ~= nil and silentFovSlider then silentFovSlider.SetValue(data.silentAimFOV) end
            if data.espEnabled ~= nil and espToggle then espToggle.SetState(data.espEnabled) end
            if data.espHighlight ~= nil and espHighlightToggle then espHighlightToggle.SetState(data.espHighlight) end
            if data.espNames ~= nil and espNamesToggle then espNamesToggle.SetState(data.espNames) end
            if data.espHealth ~= nil and espHealthToggle then espHealthToggle.SetState(data.espHealth) end
            if data.espDistance ~= nil and espDistToggle then espDistToggle.SetState(data.espDistance) end
            if data.antiLoseEnabled ~= nil and antiLoseToggle then antiLoseToggle.SetState(data.antiLoseEnabled) end
            if data.instantPromptsEnabled ~= nil and instantPromptsToggle then instantPromptsToggle.SetState(data.instantPromptsEnabled) end
            if data.lockedTime == 12 and lockDayToggle then
                lockDayToggle.SetState(true)
            elseif data.lockedTime == 0 and lockNightToggle then
                lockNightToggle.SetState(true)
            end
            if data.flySpeed ~= nil and flySpeedSlider then flySpeedSlider.SetValue(data.flySpeed) end
            if data.fastRespawnEnabled ~= nil and fastRespawnToggle then fastRespawnToggle.SetState(data.fastRespawnEnabled) end
            if data.respawnWhereDiedEnabled ~= nil and respawnWhereDiedToggle then respawnWhereDiedToggle.SetState(data.respawnWhereDiedEnabled) end
            if data.carFlySpeed ~= nil and carFlySpeedSlider then carFlySpeedSlider.SetValue(data.carFlySpeed) end
            if data.velocitySpeedEnabled ~= nil and velocitySpeedToggle then velocitySpeedToggle.SetState(data.velocitySpeedEnabled) end
            if data.speedValue ~= nil and speedValueSlider then speedValueSlider.SetValue(data.speedValue) end
            if data.breakVelocityEnabled ~= nil and breakVelocityToggle then breakVelocityToggle.SetState(data.breakVelocityEnabled) end
            if data.breakValue ~= nil and breakValueSlider then breakValueSlider.SetValue(data.breakValue) end
            if data.instantBreakEnabled ~= nil and instantBreakToggle then instantBreakToggle.SetState(data.instantBreakEnabled) end
            if data.infFuelEnabled ~= nil and infFuelToggle then infFuelToggle.SetState(data.infFuelEnabled) end
            if data.antiCarKBEnabled ~= nil and antiCarKBToggle then antiCarKBToggle.SetState(data.antiCarKBEnabled) end
            if data.infDamageEnabled ~= nil and infDamageToggle then infDamageToggle.SetState(data.infDamageEnabled) end
            if data.noSpreadEnabled ~= nil and noSpreadToggle then noSpreadToggle.SetState(data.noSpreadEnabled) end
            if data.noJamEnabled ~= nil and noJamToggle then noJamToggle.SetState(data.noJamEnabled) end
            if data.rainbowGunEnabled ~= nil and rainbowGunToggle then rainbowGunToggle.SetState(data.rainbowGunEnabled) end
            if data.galaxySkinsEnabled ~= nil and galaxySkinsToggle then galaxySkinsToggle.SetState(data.galaxySkinsEnabled) end
            setStatus("Config Loaded: " .. name, THEME.SUCCESS)
        else
            setStatus("Error reading config: " .. name, THEME.DANGER)
        end
    else
        setStatus("Config not found: " .. name, THEME.WARNING)
    end
end

local function deleteConfig(name)
    if not name or name == "" then name = "default" end
    local filePath = CONFIG_FOLDER .. "/" .. name .. ".json"
    if typeof(delfile) == "function" and typeof(isfile) == "function" and isfile(filePath) then
        pcall(delfile, filePath)
        setStatus("Config Deleted: " .. name, THEME.WARNING)
        if refreshConfigList then refreshConfigList() end
    else
        setStatus("Config file not found", THEME.DANGER)
    end
end

createButton(configsPage, "Save Current Settings As Config", function() saveConfig(configNameInput.Text) end)

local listHeaderCard = createCard(configsPage, "SAVED CONFIGURATIONS", 28)
listHeaderCard.BackgroundColor3 = THEME.BG_MAIN

local configListContainer = Instance.new("Frame")
configListContainer.Size = UDim2.new(1, 0, 0, 0)
configListContainer.BackgroundTransparency = 1
configListContainer.Parent = configsPage

local configListLayout = Instance.new("UIListLayout")
configListLayout.Padding = UDim.new(0, 6)
configListLayout.SortOrder = Enum.SortOrder.LayoutOrder
configListLayout.Parent = configListContainer

configListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    configListContainer.Size = UDim2.new(1, 0, 0, configListLayout.AbsoluteContentSize.Y)
end)

refreshConfigList = function()
    for _, child in ipairs(configListContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    ensureFolder()
    local files = {}
    if typeof(listfiles) == "function" and typeof(isfolder) == "function" and isfolder(CONFIG_FOLDER) then
        local success, fileList = pcall(listfiles, CONFIG_FOLDER)
        if success and typeof(fileList) == "table" then
            for _, path in ipairs(fileList) do
                if path:sub(-5):lower() == ".json" then
                    local cleanName = path:match("([^/\\]+)%.json$") or path
                    table.insert(files, cleanName)
                end
            end
        end
    end

    if #files == 0 then
        local emptyCard = createCard(configListContainer, nil, 36)
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1, -24, 1, 0)
        emptyLbl.Position = UDim2.new(0, 12, 0, 0)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.Text = "No saved configs found. Enter a name above and click Save!"
        emptyLbl.TextColor3 = THEME.TEXT_MUTED
        emptyLbl.Font = Enum.Font.Gotham
        emptyLbl.TextSize = 10
        emptyLbl.TextXAlignment = Enum.TextXAlignment.Left
        emptyLbl.Parent = emptyCard
        return
    end

    for _, cfgName in ipairs(files) do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 36)
        card.BackgroundColor3 = THEME.BG_CARD
        card.BorderSizePixel = 0
        card.Parent = configListContainer
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke")
        stroke.Color = THEME.BORDER
        stroke.Thickness = 1
        stroke.Parent = card

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
        nameLabel.Position = UDim2.new(0, 12, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = cfgName
        nameLabel.TextColor3 = THEME.TEXT_MAIN
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextSize = 11
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = card

        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 60, 0, 24)
        loadBtn.Position = UDim2.new(1, -135, 0.5, -12)
        loadBtn.BackgroundColor3 = THEME.ACCENT
        loadBtn.Text = "Load"
        loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.TextSize = 10
        loadBtn.AutoButtonColor = false
        loadBtn.Parent = card
        Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 60, 0, 24)
        delBtn.Position = UDim2.new(1, -68, 0.5, -12)
        delBtn.BackgroundColor3 = THEME.DANGER
        delBtn.Text = "Delete"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 10
        delBtn.AutoButtonColor = false
        delBtn.Parent = card
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)

        loadBtn.MouseButton1Click:Connect(function()
            loadConfig(cfgName)
        end)

        delBtn.MouseButton1Click:Connect(function()
            deleteConfig(cfgName)
        end)
    end
end

refreshConfigList()

print("[BronxHub Pro] Loaded Successfully!  |  RightShift = Show/Hide UI")
