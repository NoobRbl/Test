-- ╔══════════════════════════════════════════╗
-- ║       BRAINROT HUB v2.0 - Modern GUI     ║
-- ║   Duplicate Brainrot | Infinite Tokens   ║
-- ╚══════════════════════════════════════════╝

local Players        = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local LocalPlayer    = Players.LocalPlayer

-- ══════════════════════════════
--  THEME / CONSTANTS
-- ══════════════════════════════
local THEME = {
    BG_DEEP    = Color3.fromRGB(10,  12,  20),
    BG_PANEL   = Color3.fromRGB(18,  20,  32),
    BG_CARD    = Color3.fromRGB(24,  27,  42),
    BORDER     = Color3.fromRGB(50,  55,  90),
    ACCENT1    = Color3.fromRGB(110, 70,  255),   -- purple
    ACCENT2    = Color3.fromRGB(50,  200, 255),   -- cyan
    ACCENT_ON  = Color3.fromRGB(50,  230, 130),   -- green  (active)
    ACCENT_OFF = Color3.fromRGB(60,  65,  90),    -- muted  (inactive)
    TEXT_PRI   = Color3.fromRGB(235, 235, 255),
    TEXT_SEC   = Color3.fromRGB(140, 145, 180),
    TEXT_DIM   = Color3.fromRGB(80,  85,  120),
    WHITE      = Color3.fromRGB(255, 255, 255),
    RED        = Color3.fromRGB(255, 70,  90),
}

local EASE_OUT  = TweenInfo.new(0.25, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out)
local EASE_IN   = TweenInfo.new(0.18, Enum.EasingStyle.Quint,  Enum.EasingDirection.In)
local SPRING    = TweenInfo.new(0.45, Enum.EasingStyle.Back,   Enum.EasingDirection.Out)
local FAST      = TweenInfo.new(0.12, Enum.EasingStyle.Quad,   Enum.EasingDirection.Out)
local FLICKER   = TweenInfo.new(0.8,  Enum.EasingStyle.Sine,   Enum.EasingDirection.InOut, -1, true)

-- ══════════════════════════════
--  HELPER FUNCTIONS
-- ══════════════════════════════
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius  = UDim.new(0, radius or 8)
    c.Parent        = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color         = color or THEME.BORDER
    s.Thickness     = thickness or 1
    s.Transparency  = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent        = parent
    return s
end

local function gradient(parent, c1, c2, rotation)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new{
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2)
    }
    g.Rotation = rotation or 90
    g.Parent   = parent
    return g
end

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    if parent then obj.Parent = parent end
    return obj
end

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- ══════════════════════════════
--  ROOT GUI
-- ══════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name            = "BrainrotHub"
screenGui.ResetOnSpawn    = false
screenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder    = 999
screenGui.Parent          = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════
--  NOTIFICATION SYSTEM
-- ══════════════════════════════
local notifHolder = new("Frame", {
    Size                = UDim2.new(0, 260, 1, 0),
    Position            = UDim2.new(1, -270, 0, 0),
    BackgroundTransparency = 1,
    ZIndex              = 100,
}, screenGui)

local notifLayout = new("UIListLayout", {
    SortOrder           = Enum.SortOrder.LayoutOrder,
    VerticalAlignment   = Enum.VerticalAlignment.Bottom,
    Padding             = UDim.new(0, 6),
}, notifHolder)

local notifPadding = new("UIPadding", {
    PaddingBottom = UDim.new(0, 16),
    PaddingRight  = UDim.new(0, 0),
}, notifHolder)

local function notify(message, nType)
    nType = nType or "info"   -- "info" | "success" | "error"
    local accentCol = nType == "success" and THEME.ACCENT_ON
                   or nType == "error"   and THEME.RED
                   or THEME.ACCENT2

    local card = new("Frame", {
        Size                = UDim2.new(1, 0, 0, 52),
        BackgroundColor3    = THEME.BG_CARD,
        BackgroundTransparency = 0.15,
        ClipsDescendants    = true,
        ZIndex              = 100,
        Position            = UDim2.new(1.2, 0, 0, 0),  -- start off-screen
    }, notifHolder)
    corner(card, 10)
    stroke(card, accentCol, 1, 0.4)

    -- Left accent bar
    local bar = new("Frame", {
        Size                = UDim2.new(0, 3, 1, 0),
        BackgroundColor3    = accentCol,
        BorderSizePixel     = 0,
        ZIndex              = 101,
    }, card)
    corner(bar, 2)

    -- Icon
    local icons = {success = "✓", error = "✕", info = "●"}
    new("TextLabel", {
        Size                = UDim2.new(0, 30, 1, 0),
        Position            = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text                = icons[nType],
        TextColor3          = accentCol,
        Font                = Enum.Font.GothamBold,
        TextSize            = 18,
        ZIndex              = 101,
    }, card)

    -- Text
    new("TextLabel", {
        Size                = UDim2.new(1, -55, 1, 0),
        Position            = UDim2.new(0, 45, 0, 0),
        BackgroundTransparency = 1,
        Text                = message,
        TextColor3          = THEME.TEXT_PRI,
        Font                = Enum.Font.Gotham,
        TextSize            = 13,
        TextXAlignment      = Enum.TextXAlignment.Left,
        TextWrapped         = true,
        ZIndex              = 101,
    }, card)

    -- Progress bar
    local progress = new("Frame", {
        Size                = UDim2.new(1, 0, 0, 2),
        Position            = UDim2.new(0, 0, 1, -2),
        BackgroundColor3    = accentCol,
        BorderSizePixel     = 0,
        ZIndex              = 102,
    }, card)

    -- Animate in
    tween(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, 0)})

    -- Progress bar countdown
    tween(progress, TweenInfo.new(2.8, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 0, 2)})

    -- Animate out
    task.delay(3, function()
        tween(card, EASE_IN, {Position = UDim2.new(1.2, 0, 0, 0)})
        task.delay(0.3, function() card:Destroy() end)
    end)
end

-- ══════════════════════════════
--  MAIN FRAME (Glassmorphism)
-- ══════════════════════════════
local mainFrame = new("Frame", {
    Name                    = "MainFrame",
    Size                    = UDim2.new(0, 300, 0, 0),   -- starts at 0 height for open anim
    Position                = UDim2.new(0.5, -150, 0.5, -100),
    BackgroundColor3        = THEME.BG_DEEP,
    BackgroundTransparency  = 0.06,
    ClipsDescendants        = true,
    Active                  = true,
}, screenGui)
corner(mainFrame, 14)

-- Outer glow stroke
local outerStroke = stroke(mainFrame, THEME.ACCENT1, 1, 0.5)
-- Animate outer stroke glow
tween(outerStroke, FLICKER, {Transparency = 0.75})

-- Subtle inner grid texture simulation via Frame
new("Frame", {
    Size                    = UDim2.new(1, 0, 1, 0),
    BackgroundColor3        = THEME.ACCENT1,
    BackgroundTransparency  = 0.97,
    BorderSizePixel         = 0,
}, mainFrame)

-- ══════════════════════════════
--  HEADER BAR
-- ══════════════════════════════
local header = new("Frame", {
    Name                    = "Header",
    Size                    = UDim2.new(1, 0, 0, 44),
    BackgroundColor3        = THEME.BG_PANEL,
    BorderSizePixel         = 0,
}, mainFrame)
corner(header, 14)

-- Header bottom square corners fix
new("Frame", {
    Size                    = UDim2.new(1, 0, 0.5, 0),
    Position                = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3        = THEME.BG_PANEL,
    BorderSizePixel         = 0,
}, header)

-- Header accent line
local headerLine = new("Frame", {
    Size                    = UDim2.new(0, 0, 0, 1),  -- animates width
    Position                = UDim2.new(0, 0, 1, -1),
    BackgroundColor3        = THEME.ACCENT1,
    BorderSizePixel         = 0,
    ZIndex                  = 5,
}, header)
gradient(headerLine, THEME.ACCENT1, THEME.ACCENT2, 0)

-- Dot indicators (decorative)
local function makeDot(xOffset, color)
    local d = new("Frame", {
        Size                = UDim2.new(0, 8, 0, 8),
        Position            = UDim2.new(0, xOffset, 0.5, -4),
        BackgroundColor3    = color,
        BorderSizePixel     = 0,
        ZIndex              = 6,
    }, header)
    corner(d, 4)
    return d
end
makeDot(12, Color3.fromRGB(255, 90, 90))   -- red
makeDot(26, Color3.fromRGB(255, 190, 50))  -- yellow
makeDot(40, Color3.fromRGB(50, 210, 110))  -- green

-- Title
new("TextLabel", {
    Size                    = UDim2.new(1, -120, 1, 0),
    Position                = UDim2.new(0, 58, 0, 0),
    BackgroundTransparency  = 1,
    Text                    = "BRAINROT HUB",
    TextColor3              = THEME.TEXT_PRI,
    Font                    = Enum.Font.GothamBold,
    TextSize                = 14,
    TextXAlignment          = Enum.TextXAlignment.Left,
    LetterSpacing           = 2,
    ZIndex                  = 6,
}, header)

-- Version badge
local vBadge = new("Frame", {
    Size                    = UDim2.new(0, 34, 0, 18),
    Position                = UDim2.new(0, 185, 0.5, -9),
    BackgroundColor3        = THEME.ACCENT1,
    BackgroundTransparency  = 0.5,
    ZIndex                  = 6,
}, header)
corner(vBadge, 4)
new("TextLabel", {
    Size                    = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency  = 1,
    Text                    = "v2.0",
    TextColor3              = THEME.TEXT_PRI,
    Font                    = Enum.Font.GothamBold,
    TextSize                = 10,
    ZIndex                  = 7,
}, vBadge)

-- Minimize button
local minBtn = new("TextButton", {
    Size                    = UDim2.new(0, 28, 0, 28),
    Position                = UDim2.new(1, -65, 0.5, -14),
    BackgroundColor3        = THEME.BG_CARD,
    Text                    = "—",
    TextColor3              = THEME.TEXT_SEC,
    Font                    = Enum.Font.GothamBold,
    TextSize                = 14,
    ZIndex                  = 6,
}, header)
corner(minBtn, 6)
stroke(minBtn, THEME.BORDER, 1, 0)

-- Close button
local closeBtn = new("TextButton", {
    Size                    = UDim2.new(0, 28, 0, 28),
    Position                = UDim2.new(1, -32, 0.5, -14),
    BackgroundColor3        = Color3.fromRGB(80, 25, 35),
    Text                    = "✕",
    TextColor3              = THEME.RED,
    Font                    = Enum.Font.GothamBold,
    TextSize                = 13,
    ZIndex                  = 6,
}, header)
corner(closeBtn, 6)
stroke(closeBtn, THEME.RED, 1, 0.4)

-- ══════════════════════════════
--  BODY CONTAINER
-- ══════════════════════════════
local body = new("Frame", {
    Name                    = "Body",
    Size                    = UDim2.new(1, -24, 1, -60),
    Position                = UDim2.new(0, 12, 0, 50),
    BackgroundTransparency  = 1,
    ClipsDescendants        = false,
}, mainFrame)

local bodyLayout = new("UIListLayout", {
    SortOrder               = Enum.SortOrder.LayoutOrder,
    Padding                 = UDim.new(0, 8),
}, body)

-- ══════════════════════════════
--  TOGGLE BUTTON FACTORY
-- ══════════════════════════════
local toggleStates = {}

local function createToggleCard(order, icon, label, sublabel, accentColor, callback)
    local card = new("Frame", {
        Name                    = label,
        Size                    = UDim2.new(1, 0, 0, 68),
        BackgroundColor3        = THEME.BG_CARD,
        BorderSizePixel         = 0,
        LayoutOrder             = order,
        ZIndex                  = 5,
    }, body)
    corner(card, 10)
    local cardStroke = stroke(card, THEME.BORDER, 1, 0)

    -- Glow overlay (shows when active)
    local glow = new("Frame", {
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundColor3        = accentColor,
        BackgroundTransparency  = 1,   -- starts invisible
        BorderSizePixel         = 0,
        ZIndex                  = 4,
    }, card)
    corner(glow, 10)

    -- Left accent stripe
    local stripe = new("Frame", {
        Size                    = UDim2.new(0, 3, 0.7, 0),
        Position                = UDim2.new(0, 0, 0.15, 0),
        BackgroundColor3        = accentColor,
        BackgroundTransparency  = 0.5,
        BorderSizePixel         = 0,
        ZIndex                  = 6,
    }, card)
    corner(stripe, 2)

    -- Icon box
    local iconBox = new("Frame", {
        Size                    = UDim2.new(0, 38, 0, 38),
        Position                = UDim2.new(0, 14, 0.5, -19),
        BackgroundColor3        = accentColor,
        BackgroundTransparency  = 0.75,
        BorderSizePixel         = 0,
        ZIndex                  = 6,
    }, card)
    corner(iconBox, 8)

    new("TextLabel", {
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        Text                    = icon,
        TextSize                = 20,
        Font                    = Enum.Font.GothamBold,
        ZIndex                  = 7,
    }, iconBox)

    -- Labels
    new("TextLabel", {
        Size                    = UDim2.new(1, -130, 0, 20),
        Position                = UDim2.new(0, 62, 0.5, -20),
        BackgroundTransparency  = 1,
        Text                    = label:upper(),
        TextColor3              = THEME.TEXT_PRI,
        Font                    = Enum.Font.GothamBold,
        TextSize                = 13,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 6,
    }, card)

    new("TextLabel", {
        Size                    = UDim2.new(1, -130, 0, 15),
        Position                = UDim2.new(0, 62, 0.5, 3),
        BackgroundTransparency  = 1,
        Text                    = sublabel,
        TextColor3              = THEME.TEXT_DIM,
        Font                    = Enum.Font.Gotham,
        TextSize                = 11,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 6,
    }, card)

    -- Toggle pill
    local pillBG = new("Frame", {
        Size                    = UDim2.new(0, 44, 0, 24),
        Position                = UDim2.new(1, -56, 0.5, -12),
        BackgroundColor3        = THEME.ACCENT_OFF,
        BorderSizePixel         = 0,
        ZIndex                  = 6,
    }, card)
    corner(pillBG, 12)

    local pillKnob = new("Frame", {
        Size                    = UDim2.new(0, 18, 0, 18),
        Position                = UDim2.new(0, 3, 0.5, -9),  -- OFF pos
        BackgroundColor3        = THEME.TEXT_PRI,
        BorderSizePixel         = 0,
        ZIndex                  = 7,
    }, pillBG)
    corner(pillKnob, 9)

    -- Ripple effect layer
    local rippleFrame = new("Frame", {
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        ClipsDescendants        = true,
        ZIndex                  = 8,
    }, card)
    corner(rippleFrame, 10)

    -- Invisible click button
    local btn = new("TextButton", {
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        Text                    = "",
        ZIndex                  = 9,
    }, card)

    local active = false
    toggleStates[label] = false

    local function setActive(state)
        active = state
        toggleStates[label] = state

        if state then
            -- Toggle ON
            tween(pillBG,   EASE_OUT,  {BackgroundColor3 = accentColor})
            tween(pillKnob, EASE_OUT,  {Position = UDim2.new(0, 23, 0.5, -9)})
            tween(cardStroke, EASE_OUT, {Color = accentColor, Transparency = 0.3})
            tween(glow,     EASE_OUT,  {BackgroundTransparency = 0.94})
            tween(stripe,   EASE_OUT,  {BackgroundTransparency = 0})
        else
            -- Toggle OFF
            tween(pillBG,   EASE_OUT,  {BackgroundColor3 = THEME.ACCENT_OFF})
            tween(pillKnob, EASE_OUT,  {Position = UDim2.new(0, 3, 0.5, -9)})
            tween(cardStroke, EASE_OUT, {Color = THEME.BORDER, Transparency = 0})
            tween(glow,     EASE_OUT,  {BackgroundTransparency = 1})
            tween(stripe,   EASE_OUT,  {BackgroundTransparency = 0.5})
        end

        if callback then callback(state) end
    end

    -- Ripple on click
    local function spawnRipple(inputPos)
        local relX = inputPos.X - card.AbsolutePosition.X
        local relY = inputPos.Y - card.AbsolutePosition.Y
        local ripple = new("Frame", {
            Size                = UDim2.new(0, 10, 0, 10),
            Position            = UDim2.new(0, relX - 5, 0, relY - 5),
            BackgroundColor3    = accentColor,
            BackgroundTransparency = 0.5,
            BorderSizePixel     = 0,
            ZIndex              = 8,
        }, rippleFrame)
        corner(ripple, 40)
        tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 200, 0, 200), Position = UDim2.new(0, relX - 100, 0, relY - 100), BackgroundTransparency = 1})
        task.delay(0.55, function() ripple:Destroy() end)
    end

    btn.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        spawnRipple(mousePos)

        -- Scale press animation
        tween(card, FAST, {Size = UDim2.new(1, -4, 0, 65)})
        task.delay(0.12, function()
            tween(card, SPRING, {Size = UDim2.new(1, 0, 0, 68)})
        end)

        setActive(not active)
    end)

    -- Hover
    btn.MouseEnter:Connect(function()
        if not active then
            tween(card, EASE_OUT, {BackgroundColor3 = Color3.fromRGB(30, 34, 52)})
        end
    end)
    btn.MouseLeave:Connect(function()
        tween(card, EASE_OUT, {BackgroundColor3 = THEME.BG_CARD})
    end)

    return card, setActive
end

-- ══════════════════════════════
--  ACTION BUTTON FACTORY
-- ══════════════════════════════
local function createActionCard(order, icon, label, sublabel, accentColor, callback)
    local card = new("Frame", {
        Name                    = label,
        Size                    = UDim2.new(1, 0, 0, 68),
        BackgroundColor3        = THEME.BG_CARD,
        BorderSizePixel         = 0,
        LayoutOrder             = order,
        ZIndex                  = 5,
    }, body)
    corner(card, 10)
    stroke(card, THEME.BORDER, 1, 0)

    -- Left accent stripe
    local stripe = new("Frame", {
        Size                    = UDim2.new(0, 3, 0.7, 0),
        Position                = UDim2.new(0, 0, 0.15, 0),
        BackgroundColor3        = accentColor,
        BackgroundTransparency  = 0.5,
        BorderSizePixel         = 0,
        ZIndex                  = 6,
    }, card)
    corner(stripe, 2)

    -- Icon box
    local iconBox = new("Frame", {
        Size                    = UDim2.new(0, 38, 0, 38),
        Position                = UDim2.new(0, 14, 0.5, -19),
        BackgroundColor3        = accentColor,
        BackgroundTransparency  = 0.75,
        BorderSizePixel         = 0,
        ZIndex                  = 6,
    }, card)
    corner(iconBox, 8)

    new("TextLabel", {
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        Text                    = icon,
        TextSize                = 20,
        Font                    = Enum.Font.GothamBold,
        ZIndex                  = 7,
    }, iconBox)

    new("TextLabel", {
        Size                    = UDim2.new(1, -130, 0, 20),
        Position                = UDim2.new(0, 62, 0.5, -20),
        BackgroundTransparency  = 1,
        Text                    = label:upper(),
        TextColor3              = THEME.TEXT_PRI,
        Font                    = Enum.Font.GothamBold,
        TextSize                = 13,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 6,
    }, card)

    new("TextLabel", {
        Size                    = UDim2.new(1, -130, 0, 15),
        Position                = UDim2.new(0, 62, 0.5, 3),
        BackgroundTransparency  = 1,
        Text                    = sublabel,
        TextColor3              = THEME.TEXT_DIM,
        Font                    = Enum.Font.Gotham,
        TextSize                = 11,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 6,
    }, card)

    -- Execute badge
    local execBadge = new("Frame", {
        Size                    = UDim2.new(0, 52, 0, 24),
        Position                = UDim2.new(1, -62, 0.5, -12),
        BackgroundColor3        = accentColor,
        BackgroundTransparency  = 0.7,
        BorderSizePixel         = 0,
        ZIndex                  = 6,
    }, card)
    corner(execBadge, 6)
    new("TextLabel", {
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        Text                    = "RUN ▶",
        TextColor3              = accentColor,
        Font                    = Enum.Font.GothamBold,
        TextSize                = 10,
        ZIndex                  = 7,
    }, execBadge)

    -- Ripple
    local rippleFrame = new("Frame", {
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        ClipsDescendants        = true,
        ZIndex                  = 8,
    }, card)
    corner(rippleFrame, 10)

    local btn = new("TextButton", {
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        Text                    = "",
        ZIndex                  = 9,
    }, card)

    btn.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local relX = mousePos.X - card.AbsolutePosition.X
        local relY = mousePos.Y - card.AbsolutePosition.Y
        local ripple = new("Frame", {
            Size                = UDim2.new(0, 10, 0, 10),
            Position            = UDim2.new(0, relX - 5, 0, relY - 5),
            BackgroundColor3    = accentColor,
            BackgroundTransparency = 0.4,
            BorderSizePixel     = 0,
            ZIndex              = 8,
        }, rippleFrame)
        corner(ripple, 40)
        tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 200, 0, 200), Position = UDim2.new(0, relX-100, 0, relY-100), BackgroundTransparency = 1})
        task.delay(0.55, function() ripple:Destroy() end)

        -- Flash badge
        tween(execBadge, FAST,     {BackgroundTransparency = 0.1})
        task.delay(0.15, function()
            tween(execBadge, EASE_OUT, {BackgroundTransparency = 0.7})
        end)

        -- Press scale
        tween(card, FAST,  {Size = UDim2.new(1, -4, 0, 65)})
        task.delay(0.12, function()
            tween(card, SPRING, {Size = UDim2.new(1, 0, 0, 68)})
        end)

        if callback then callback() end
    end)

    btn.MouseEnter:Connect(function()
        tween(card, EASE_OUT, {BackgroundColor3 = Color3.fromRGB(30, 34, 52)})
    end)
    btn.MouseLeave:Connect(function()
        tween(card, EASE_OUT, {BackgroundColor3 = THEME.BG_CARD})
    end)

    return card
end

-- ══════════════════════════════
--  FEATURE LOGIC
-- ══════════════════════════════

-- Duplicate Brainrot logic
local function doDuplicate()
    local character = LocalPlayer.Character
    if not character then
        notify("No character found!", "error")
        return
    end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        local clone = tool:Clone()
        clone.Parent = LocalPlayer.Backpack
        notify("Duplicated: " .. tool.Name, "success")
    else
        notify("No tool equipped!", "error")
    end
end

-- Inf Token logic
local infTokenActive = false

local function activateInfToken(state)
    infTokenActive = state
    if not state then
        notify("Infinite Tokens disabled", "info")
        return
    end
    notify("Infinite Tokens activated!", "success")

    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local hud = playerGui:FindFirstChild("HUD")
    if not hud then
        notify("HUD not found — retrying…", "info")
        task.delay(3, function() if infTokenActive then activateInfToken(true) end end)
        return
    end

    local function hookLabel(element)
        element.Text = "∞"
        element:GetPropertyChangedSignal("Text"):Connect(function()
            if infTokenActive and element.Text ~= "∞" then
                element.Text = "∞"
            end
        end)
    end

    local function searchFor(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if (child:IsA("TextLabel") or child:IsA("TextButton")) and
               (string.find(child.Name:lower(), "token") or string.find(child.Name:lower(), "trade")) then
                hookLabel(child)
            end
        end
    end

    searchFor(hud)
end

-- ══════════════════════════════
--  BUILD CARDS
-- ══════════════════════════════
createActionCard(1, "⧉", "Duplicate Brainrot", "Clone equipped tool to backpack",
    Color3.fromRGB(110, 70, 255), doDuplicate)

createToggleCard(2, "◆", "Infinite Tokens", "Lock token display to ∞",
    Color3.fromRGB(50, 200, 255), activateInfToken)

-- ══════════════════════════════
--  FOOTER
-- ══════════════════════════════
local footer = new("Frame", {
    Size                    = UDim2.new(1, -24, 0, 22),
    Position                = UDim2.new(0, 12, 1, -28),
    BackgroundTransparency  = 1,
    ZIndex                  = 5,
}, mainFrame)

new("TextLabel", {
    Size                    = UDim2.new(0.5, 0, 1, 0),
    BackgroundTransparency  = 1,
    Text                    = "BRAINROT HUB",
    TextColor3              = THEME.TEXT_DIM,
    Font                    = Enum.Font.GothamBold,
    TextSize                = 10,
    TextXAlignment          = Enum.TextXAlignment.Left,
    ZIndex                  = 6,
}, footer)

new("TextLabel", {
    Size                    = UDim2.new(0.5, 0, 1, 0),
    Position                = UDim2.new(0.5, 0, 0, 0),
    BackgroundTransparency  = 1,
    Text                    = "2 features loaded",
    TextColor3              = THEME.ACCENT_ON,
    Font                    = Enum.Font.Gotham,
    TextSize                = 10,
    TextXAlignment          = Enum.TextXAlignment.Right,
    ZIndex                  = 6,
}, footer)

-- ══════════════════════════════
--  OPEN ANIMATION
-- ══════════════════════════════
-- Target height = 44 header + 8 padding + 68 + 8 + 68 cards + 12 padding bottom + 28 footer pad = ~244
local FULL_HEIGHT = 244
mainFrame.Size = UDim2.new(0, 300, 0, 0)
mainFrame.BackgroundTransparency = 1

task.delay(0.1, function()
    tween(mainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 300, 0, FULL_HEIGHT), BackgroundTransparency = 0.06})
    tween(headerLine, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, 0, 0, 1)})
    notify("Brainrot Hub loaded!", "success")
end)

-- ══════════════════════════════
--  MINIMIZE / CLOSE
-- ══════════════════════════════
local isMinimized = false

minBtn.MouseButton1Click:Connect(function()
    tween(minBtn, FAST, {BackgroundColor3 = Color3.fromRGB(50, 55, 80)})
    task.delay(0.12, function()
        tween(minBtn, EASE_OUT, {BackgroundColor3 = THEME.BG_CARD})
    end)

    isMinimized = not isMinimized
    if isMinimized then
        tween(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 300, 0, 44)})
        minBtn.Text = "□"
    else
        tween(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 300, 0, FULL_HEIGHT)})
        minBtn.Text = "—"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    tween(closeBtn, FAST, {BackgroundColor3 = THEME.RED})
    tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 300, 0, 0), BackgroundTransparency = 1})
    task.delay(0.35, function() screenGui:Destroy() end)
end)

-- Hover effects on header buttons
for _, btn in ipairs({minBtn, closeBtn}) do
    local origColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        tween(btn, FAST, {BackgroundTransparency = 0})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, EASE_OUT, {BackgroundTransparency = 0})
    end)
end

-- ══════════════════════════════
--  DRAGGING (smooth)
-- ══════════════════════════════
local dragging, dragStart, startPos, dragInput

local function updateDrag(input)
    local delta = input.Position - dragStart
    tween(mainFrame, TweenInfo.new(0.05, Enum.EasingStyle.Linear),
        {Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )})
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos  = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- ══════════════════════════════
print("✓ Brainrot Hub v2.0 loaded")
