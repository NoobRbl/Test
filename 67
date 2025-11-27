local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local success, VirtualInputManager = pcall(function()
    return game:GetService("VirtualInputManager")
end)
if not success then
    VirtualInputManager = nil
end

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("BrainrotHub")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
toggleBtn.Text = "⚡"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 30, 180)}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(128, 0, 255)}):Play()
end)

-- Drag toggle
local dragging, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        TweenService:Create(toggleBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = newPos
        }):Play()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 360)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BackgroundTransparency = 0.35
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

-- Background image
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1,0,1,0)
bg.Position = UDim2.new(0,0,0,0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://109622202126848"
bg.ZIndex = 0
bg.Parent = mainFrame

-- Gradient (tweak để hợp style ảnh)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200,200,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150,150,200))
})
gradient.Rotation = 45
gradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 0.35)
}
gradient.Parent = mainFrame

-- Glow
local glow = Instance.new("UIStroke")
glow.Thickness = 2.8
glow.Color = Color3.fromRGB(140, 60, 255)
glow.Transparency = 0.15
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glow.Parent = mainFrame

-- Blur effect
local blur = Instance.new("BlurEffect")
blur.Size = 4
blur.Parent = workspace.CurrentCamera

-- Show/hide panel
local function showPanel()
    mainFrame.Visible = true
    mainFrame.BackgroundTransparency = 1
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    mainFrame.Size = UDim2.new(0, 390, 0, 330)
    glow.Transparency = 1

    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 360),
        Position = UDim2.new(0.5, -210, 0.5, -180),
        BackgroundTransparency = 0.35
    }):Play()

    TweenService:Create(glow, TweenInfo.new(0.45), {
        Transparency = 0.15
    }):Play()
end

local function hidePanel()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 360, 0, 300),
        Position = UDim2.new(0.5, -180, 0.5, -160),
        BackgroundTransparency = 1
    })

    TweenService:Create(glow, TweenInfo.new(0.25), {
        Transparency = 1
    }):Play()

    tween:Play()
    tween.Completed:Wait()
    mainFrame.Visible = false
end

local opened = false
toggleBtn.MouseButton1Click:Connect(function()
    if opened then
        hidePanel()
    else
        showPanel()
    end
    opened = not opened
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🧠 Steal A Brainrot Hub"
title.TextColor3 = Color3.fromRGB(220,220,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 8)
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(180, 100, 100)
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(hidePanel)

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 42)
divider.BackgroundColor3 = Color3.fromRGB(140, 80, 200)
divider.Parent = mainFrame

-- Buttons Frame
local buttonsFrame = Instance.new("ScrollingFrame")
buttonsFrame.Size = UDim2.new(1, 0, 1, -60)
buttonsFrame.Position = UDim2.new(0, 0, 0, 50)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.ScrollBarThickness = 4
buttonsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
buttonsFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = buttonsFrame

-- Virtual keys
local virtualKeys = {
    ["Execute All Event"] = Enum.KeyCode.E,
    ["3 Roads"] = Enum.KeyCode.R
}

local function pressKey(key)
    if not VirtualInputManager then return end
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.25)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

-- Button creation
local function createButton(name, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 350, 0, 40)
    btn.Text = name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 18
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.AutoButtonColor = false
    btn.Parent = buttonsFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,10)
    btnCorner.Parent = btn

    if virtualKeys[name] then
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(0, 70, 1, 0)
        keyLabel.Position = UDim2.new(1, -80, 0, 0)
        keyLabel.BackgroundTransparency = 1
        keyLabel.Text = "["..virtualKeys[name].Name.."]"
        keyLabel.TextColor3 = Color3.fromRGB(230,230,230)
        keyLabel.Font = Enum.Font.Gotham
        keyLabel.TextSize = 14
        keyLabel.TextXAlignment = Enum.TextXAlignment.Right
        keyLabel.Parent = btn
    end

    btn.MouseEnter:Connect(function()
        local target = color:Lerp(Color3.new(1,1,1),0.25)
        TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = target
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = color
        }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        local originalText = btn.Text
        btn.Text = "Processing..."
        local progress = 0

        while progress < 100 do
            progress = progress + math.random(5,10)
            if progress > 100 then progress = 100 end
            btn.Text = name .. " - " .. progress .. "%"
            task.wait(math.random(0.07, 0.15))
        end

        btn.Text = "✅ Done!"
        task.wait(0.6)
        btn.Text = originalText

        if virtualKeys[name] then
            pressKey(virtualKeys[name])
        end

        if name == "Auto Fish" then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/NoobRoblox/Test/refs/heads/main/Event-sab"))()
            end)
        elseif name == "Duplicate" then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/tunadan212/Kkkk/refs/heads/main/K"))()
            end)
        elseif name == "Spawn Brainrot" then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/NoobRoblox/Test/refs/heads/main/Brainrot%20Spawner"))()
            end)
        elseif name == "Buff Lucky x10" then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/NoobRoblox/Test/refs/heads/main/Lucky"))()
            end)
        end
    end)
end

-- Buttons
createButton("Auto Fish", Color3.fromRGB(80, 60, 200))
createButton("Duplicate", Color3.fromRGB(60, 140, 200))
createButton("Spawn Brainrot", Color3.fromRGB(130, 90, 240))
createButton("Execute All Event", Color3.fromRGB(200, 90, 90))
createButton("3 Roads", Color3.fromRGB(100, 190, 120))
createButton("Buff Lucky x10", Color3.fromRGB(230, 180, 60))

-- Flying Carpet button
local function FlyingCarpetAction()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.J, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.J, false, game)
end

local flyingBtn = Instance.new("TextButton")
flyingBtn.Size = UDim2.new(0, 350, 0, 40)
flyingBtn.Text = "Flying Carpet"
flyingBtn.Font = Enum.Font.GothamMedium
flyingBtn.TextSize = 18
flyingBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 60)
flyingBtn.TextColor3 = Color3.new(1,1,1)
flyingBtn.AutoButtonColor = false
flyingBtn.Parent = buttonsFrame

local fcCorner = Instance.new("UICorner")
fcCorner.CornerRadius = UDim.new(0,10)
fcCorner.Parent = flyingBtn

flyingBtn.MouseEnter:Connect(function()
    TweenService:Create(flyingBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(230,150,90)
    }):Play()
end)

flyingBtn.MouseLeave:Connect(function()
    TweenService:Create(flyingBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(200,120,60)
    }):Play()
end)

flyingBtn.MouseButton1Click:Connect(function()
    FlyingCarpetAction()
end)

-- Footer
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 25)
footer.Position = UDim2.new(0, 0, 1, -25)
footer.BackgroundTransparency = 1
footer.Text = "Made by NoobRoblox | v3.0"
footer.Font = Enum.Font.Gotham
footer.TextSize = 14
footer.TextColor3 = Color3.fromRGB(180, 180, 220)
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = mainFrame
