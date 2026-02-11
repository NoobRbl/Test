-- 🧠 Brainrot Hub v2 | Dark Theme + Glow + Toast Pro
-- Stable | Clean | No Error

-- ===== SERVICES =====
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ===== SCREEN GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name         = "BrainrotHubV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent       = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════
--        TOAST SYSTEM PRO
--  ⚠ NO UIListLayout — UIListLayout overrides .Position every frame
--    which breaks ALL slide tweens. We manage the stack manually.
-- ══════════════════════════════
local TOAST_W   = 280   -- card width (px)
local TOAST_H   = 48    -- card height (px)
local TOAST_GAP = 8     -- gap between stacked toasts
local TOAST_R   = 14    -- margin from right edge
local TOAST_B   = 14    -- margin from bottom edge
local MAX_TOAST = 5

local toastStack = {}   -- list of live toast Frames (index 1 = bottom-most)

local ToastConfig = {
    success = { bar = Color3.fromRGB(90,  200, 120), icon = "✔" },
    error   = { bar = Color3.fromRGB(255,  90,  90), icon = "✖" },
    info    = { bar = Color3.fromRGB(80,  160, 255), icon = "ℹ" },
    warn    = { bar = Color3.fromRGB(255, 180,  70), icon = "⚠" },
}

-- Y offset (from bottom of screen) for a given stack slot
local function slotY(slot)
    return -(TOAST_B + (slot - 1) * (TOAST_H + TOAST_GAP) + TOAST_H)
end

-- Smoothly slide all live toasts to their correct slot
local function reshiftStack()
    for i, card in ipairs(toastStack) do
        if card and card.Parent then
            TweenService:Create(card,
                TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Position = UDim2.new(1, -(TOAST_W + TOAST_R), 1, slotY(i)) }
            ):Play()
        end
    end
end

local function toast(text, ttype, duration)
    ttype    = ttype    or "info"
    duration = duration or 3
    local cfg = ToastConfig[ttype] or ToastConfig.info

    -- Evict oldest if stack is full
    if #toastStack >= MAX_TOAST then
        local oldest = toastStack[1]
        table.remove(toastStack, 1)
        if oldest and oldest.Parent then oldest:Destroy() end
        reshiftStack()
    end

    -- Slot this card will land in
    local slot   = #toastStack + 1
    local finalY = slotY(slot)

    -- ── BUILD CARD ────────────────────────────────────────────────
    -- Parent: ScreenGui directly (NOT a frame with UIListLayout!)
    -- Start position: fully off-screen to the RIGHT
    local card = Instance.new("Frame")
    card.Size                   = UDim2.new(0, TOAST_W, 0, TOAST_H)
    card.Position               = UDim2.new(1, TOAST_W + 40, 1, finalY)  -- off-screen right
    card.BackgroundColor3       = Color3.fromRGB(32, 36, 45)
    card.BackgroundTransparency = 0
    card.ClipsDescendants       = false   -- never clip text children
    card.ZIndex                 = 200
    card.Parent                 = ScreenGui                              -- ← key fix
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    -- Border glow
    local glow = Instance.new("UIStroke")
    glow.Thickness    = 1.5
    glow.Color        = cfg.bar
    glow.Transparency = 0.35
    glow.Parent       = card

    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size                   = UDim2.new(0, 36, 1, -8)
    icon.Position               = UDim2.new(0, 8, 0, 4)
    icon.BackgroundTransparency = 1
    icon.Text                   = cfg.icon
    icon.Font                   = Enum.Font.GothamBold
    icon.TextSize               = 22
    icon.TextColor3             = cfg.bar
    icon.ZIndex                 = 201
    icon.Parent                 = card

    -- Message
    local label = Instance.new("TextLabel")
    label.Size                  = UDim2.new(1, -54, 1, -8)
    label.Position              = UDim2.new(0, 48, 0, 4)
    label.BackgroundTransparency = 1
    label.Text                  = text
    label.Font                  = Enum.Font.GothamBold
    label.TextSize              = 14
    label.TextWrapped           = true
    label.TextXAlignment        = Enum.TextXAlignment.Left
    label.TextColor3            = Color3.fromRGB(230, 230, 230)
    label.ZIndex                = 201
    label.Parent                = card

    -- Progress bar background
    local barBg = Instance.new("Frame")
    barBg.Size                  = UDim2.new(1, -16, 0, 3)
    barBg.Position              = UDim2.new(0, 8, 1, -5)
    barBg.BackgroundColor3      = Color3.fromRGB(0, 0, 0)
    barBg.BackgroundTransparency = 0.6
    barBg.BorderSizePixel       = 0
    barBg.ZIndex                = 201
    barBg.Parent                = card
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 2)

    -- Progress bar fill
    local bar = Instance.new("Frame")
    bar.Size             = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = cfg.bar
    bar.BorderSizePixel  = 0
    bar.ZIndex           = 202
    bar.Parent           = barBg
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)

    -- ── REGISTER ─────────────────────────────────────────────────
    table.insert(toastStack, card)

    -- ── ANIMATE IN ───────────────────────────────────────────────
    -- Slide from off-screen right → final position  (Back = slight overshoot)
    local finalPos = UDim2.new(1, -(TOAST_W + TOAST_R), 1, finalY)
    TweenService:Create(card,
        TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = finalPos }
    ):Play()

    -- Progress drain starts just after the card lands
    task.delay(0.4, function()
        if card and card.Parent then
            TweenService:Create(bar,
                TweenInfo.new(duration - 0.1, Enum.EasingStyle.Linear),
                { Size = UDim2.new(0, 0, 1, 0) }
            ):Play()
        end
    end)

    -- ── ANIMATE OUT ──────────────────────────────────────────────
    task.delay(duration + 0.35, function()
        -- Remove from stack
        for i, c in ipairs(toastStack) do
            if c == card then
                table.remove(toastStack, i)
                break
            end
        end
        reshiftStack()  -- slide remaining cards down

        if card and card.Parent then
            -- Slide out to right + fade border simultaneously
            TweenService:Create(glow,
                TweenInfo.new(0.12, Enum.EasingStyle.Linear),
                { Transparency = 1 }
            ):Play()
            TweenService:Create(card,
                TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                {
                    Position               = UDim2.new(1, TOAST_W + 40, 1, card.Position.Y.Offset),
                    BackgroundTransparency = 0.85,
                }
            ):Play()
            task.delay(0.35, function()
                if card and card.Parent then card:Destroy() end
            end)
        end
    end)
end

-- ══════════════════════════════
--            HUB UI
-- ══════════════════════════════
local Main = Instance.new("Frame")
Main.Size             = UDim2.new(0, 360, 0, 230)
Main.Position         = UDim2.new(0.5, -180, 0.5, -115)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.BorderSizePixel  = 0
Main.Active           = true
Main.Parent           = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Glow HUB
local hubStroke = Instance.new("UIStroke")
hubStroke.Thickness    = 2
hubStroke.Color        = Color3.fromRGB(120, 160, 255)
hubStroke.Transparency = 0.35
hubStroke.Parent       = Main

-- HEADER
local Header = Instance.new("Frame")
Header.Name           = "Header"
Header.Size           = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Header.BorderSizePixel = 0
Header.Parent         = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size                  = UDim2.new(1, -60, 1, 0)
Title.Position              = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text                  = "🧠 Brainrot Hub"
Title.Font                  = Enum.Font.GothamBold
Title.TextSize              = 20
Title.TextColor3            = Color3.new(1, 1, 1)
Title.TextXAlignment        = Enum.TextXAlignment.Left
Title.Parent                = Header

local Close = Instance.new("TextButton")
Close.Size            = UDim2.new(0, 34, 0, 34)
Close.Position        = UDim2.new(1, -42, 0, 7)
Close.Text            = "✕"
Close.Font            = Enum.Font.GothamBold
Close.TextSize        = 18
Close.TextColor3      = Color3.new(1, 1, 1)
Close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Close.Parent          = Header
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

-- BUTTON MAKER
local function createButton(text, y)
    local b = Instance.new("TextButton")
    b.Size            = UDim2.new(1, -30, 0, 54)
    b.Position        = UDim2.new(0, 15, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(70, 110, 220)
    b.Text            = text
    b.Font            = Enum.Font.GothamBold
    b.TextSize        = 15
    b.TextColor3      = Color3.new(1, 1, 1)
    b.Parent          = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

local DupBtn   = createButton("Duplicate Brainrot",   70)
local TokenBtn = createButton("Infinite Tokens : OFF", 135)

-- STATES
local infTokenActive = false
local tokenCons      = {}

-- DUPLICATE
local function duplicateBrainrot()
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        toast("No tool equipped", "error")
        return
    end
    tool:Clone().Parent = LocalPlayer.Backpack
    toast("Duplicated: " .. tool.Name, "success")
end

-- INFINITE TOKEN
local function lockInfinity(lbl)
    lbl.Text       = "∞"
    lbl.TextScaled = true
    local c = lbl:GetPropertyChangedSignal("Text"):Connect(function()
        if infTokenActive and lbl.Text ~= "∞" then
            lbl.Text = "∞"
        end
    end)
    table.insert(tokenCons, c)
end

local function enableInfToken()
    local gui = LocalPlayer.PlayerGui
    local hud = gui:FindFirstChild("HUD")
    if not hud then
        toast("HUD not found", "error")
        return
    end
    local bl = hud:FindFirstChild("BottomLeft")
    local tt = bl and bl:FindFirstChild("TradeTokens")
    if not tt then
        toast("TradeTokens not found", "error")
        return
    end
    for _, v in ipairs(tt:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            lockInfinity(v)
        end
    end
    toast("Infinite Tokens Enabled", "info")
end

local function disableInfToken()
    for _, c in ipairs(tokenCons) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(tokenCons)
    toast("Infinite Tokens Disabled", "warn")
end

-- EVENTS
DupBtn.MouseButton1Click:Connect(duplicateBrainrot)

TokenBtn.MouseButton1Click:Connect(function()
    infTokenActive = not infTokenActive
    TokenBtn.Text  = "Infinite Tokens : " .. (infTokenActive and "ON" or "OFF")
    if infTokenActive then
        enableInfToken()
    else
        disableInfToken()
    end
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ══════════════════════════════
--      DRAG  (fixed & smooth)
-- ══════════════════════════════
--  Fix: track drag entirely inside InputBegan + UserInputService.
--  No intermediate dragInput variable needed — avoids the "miss first move" bug.
--  Position is set directly (no tween) for zero-latency feel.

local isDragging   = false
local dragOffset   = Vector2.new(0, 0)   -- mouse offset relative to frame top-left

-- When mouse is pressed on the header → record offset from frame corner
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        -- Offset = mouse pos minus the frame's absolute top-left corner
        dragOffset = Vector2.new(
            input.Position.X - Main.AbsolutePosition.X,
            input.Position.Y - Main.AbsolutePosition.Y
        )
    end
end)

-- Release drag on mouse up (global, so we never get stuck)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- Move frame every mouse move
UserInputService.InputChanged:Connect(function(input)
    if not isDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end

    -- New top-left = mouse position minus the recorded offset
    local newX = input.Position.X - dragOffset.X
    local newY = input.Position.Y - dragOffset.Y
    Main.Position = UDim2.fromOffset(newX, newY)
end)

-- ══════════════════════════════
toast("Brainrot Hub Loaded", "info")
print("🧠 Brainrot Hub loaded successfully")
