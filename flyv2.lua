``` name=flyv2.lua
--==============================
-- PHUCMAX | COMPACT FLY LOCATION UI (fixed)
-- - Smaller UI, unique name so it doesn't conflict with script.lua
-- - Keeps original functionality (prev/next, fly to location, noclip while flying)
-- - Fixes issues on death / respawn (stops flying, cleans up, avoids wrong-slot jumps)
-- - More robust noclip (maintained while flying) and safety checks
--==============================

repeat task.wait() until game:IsLoaded()

-------------------------------
-- SERVICES
-------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-------------------------------
-- LOCATION LIST
-------------------------------
local Locations = {
    {Name="Slot 1", Pos=Vector3.new(285.54, -2.82, 2.42)},
    {Name="Slot 2", Pos=Vector3.new(758.88, -2.82, -24.76)},
    {Name="Slot 3", Pos=Vector3.new(1075.47, -2.82, 6.87)},
    {Name="Slot 4", Pos=Vector3.new(1553.93, -4.84, 4.31)},
    {Name="Slot 5", Pos=Vector3.new(2241.93, -2.82, -7.76)},
    {Name="Slot 6", Pos=Vector3.new(2595.85, -4.74, -5.99)},
    {Name="HOME",   Pos=Vector3.new(128.74, 3.18, 15.57)},
}

local index = 1

-------------------------------
-- UI (compact & unique)
-------------------------------
-- Remove any previous fly UI specifically (do not touch PHUCMAX_UI)
pcall(function()
    local old = lp.PlayerGui:FindFirstChild("PHUCMAX_FLY_UI")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "PHUCMAX_FLY_UI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 120) -- compact
main.Position = UDim2.new(0.5, -130, 0.7, 0)
main.AnchorPoint = Vector2.new(0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
main.BorderSizePixel = 0
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Transparency = 0.25
stroke.Color = Color3.fromRGB(90, 255, 170)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -16, 0, 28)
title.Position = UDim2.new(0, 8, 0, 6)
title.BackgroundTransparency = 1
title.Text = "PHUCMAX — FLY"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(200, 255, 240)
title.TextXAlignment = Enum.TextXAlignment.Left

local locLabel = Instance.new("TextLabel", main)
locLabel.Size = UDim2.new(1, -100, 0, 28)
locLabel.Position = UDim2.new(0, 8, 0, 36)
locLabel.BackgroundTransparency = 1
locLabel.Font = Enum.Font.Gotham
locLabel.TextSize = 14
locLabel.TextWrapped = true
locLabel.TextColor3 = Color3.fromRGB(220, 255, 240)
locLabel.Text = ""

local function makeBtn(text, pos, size)
    local b = Instance.new("TextButton", main)
    b.Size = size or UDim2.new(0.24, 0, 0, 32)
    b.Position = pos
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local btnPrev = makeBtn("◀", UDim2.new(0.02, 0, 0, 36), UDim2.new(0.12,0,0,32))
local btnNext = makeBtn("▶", UDim2.new(0.86, 0, 0, 36), UDim2.new(0.12,0,0,32))
local btnFly  = makeBtn("FLY",  UDim2.new(0.35, 0, 0, 72), UDim2.new(0.3,0,0,34))
local btnCancel = makeBtn("CANCEL", UDim2.new(0.66,0,0,72), UDim2.new(0.28,0,0,34))

-------------------------------
-- DRAG UI (compact)
-------------------------------
do
    local dragging = false
    local dragStart, startPos

    main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)

    main.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-------------------------------
-- RAINBOW (subtle) - optional
-------------------------------
task.spawn(function()
    local h = 0
    while gui.Parent do
        h = (h + 0.008) % 1
        main.BackgroundColor3 = Color3.fromHSV(h,0.45,0.18)
        stroke.Color = Color3.fromHSV((h+0.25)%1,0.9,0.9)
        task.wait(0.03)
    end
end)

-------------------------------
-- CHARACTER & STATE
-------------------------------
local char, hrp, humanoid
local flying = false
local bv, conn
local noclipConn, humanoidDiedConn

local SPEED = 500

local function SetNoclip(on)
    if not char then return end
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not not on and false or true -- explicit boolean
        end
    end
end

local function startMaintainNoclip()
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    noclipConn = RunService.Stepped:Connect(function()
        if flying and char then
            for _,v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    -- keep collisions off while flying
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function stopMaintainNoclip()
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
end

local function cleanupFlight()
    flying = false
    if conn then conn:Disconnect() conn = nil end
    if bv then
        pcall(function() bv:Destroy() end)
        bv = nil
    end
    SetNoclip(false)
    stopMaintainNoclip()
    btnFly.Text = "FLY"
end

local function onHumanoidDied()
    -- stop everything safely on death
    cleanupFlight()
    -- Ensure label updated and no invalid hrp usage
    hrp = nil
    humanoid = nil
end

local function loadChar(c)
    -- disconnect previous humanoid died listener
    if humanoidDiedConn then humanoidDiedConn:Disconnect() humanoidDiedConn = nil end

    char = c
    if not char then
        hrp = nil
        humanoid = nil
        cleanupFlight()
        return
    end

    hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
    humanoid = char:FindFirstChild("Humanoid") or char:WaitForChild("Humanoid")
    cleanupFlight() -- ensure no leftover flight state when respawning
    -- attach death listener
    humanoidDiedConn = humanoid.Died:Connect(onHumanoidDied)
end

loadChar(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(function(c) loadChar(c) end)
lp.CharacterRemoving:Connect(function() -- ensure we cleanup if character removing
    cleanupFlight()
    char, hrp, humanoid = nil, nil, nil
end)

-------------------------------
-- UPDATE LABEL (safe bounds)
-------------------------------
local function UpdateLabel()
    if index < 1 then index = 1 end
    if index > #Locations then index = #Locations end
    local loc = Locations[index]
    if loc then
        locLabel.Text = ("[%d/%d] %s"):format(index, #Locations, loc.Name)
    else
        locLabel.Text = ("[%d/%d]"):format(index, #Locations)
    end
end
UpdateLabel()

-------------------------------
-- FLY LOGIC (robust)
-------------------------------
local function FlyTo(pos)
    -- safety checks
    if flying then return end
    if not hrp or not hrp.Parent then
        -- try to refresh hrp from character
        if char then
            hrp = char:FindFirstChild("HumanoidRootPart")
        end
    end
    if not hrp then
        btnFly.Text = "NO CHAR"
        task.delay(1, function() if not flying then btnFly.Text = "FLY" end end)
        return
    end

    flying = true
    btnFly.Text = "FLYING..."
    -- enable noclip and maintain it every frame
    SetNoclip(true)
    startMaintainNoclip()

    -- create body velocity
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = hrp

    local arrived = 0
    local connLocal
    connLocal = RunService.Heartbeat:Connect(function(dt)
        -- if character lost or died, cancel flight
        if not char or not hrp or not hrp.Parent then
            if connLocal then connLocal:Disconnect() connLocal = nil end
            cleanupFlight()
            return
        end
        if humanoid and humanoid.Health <= 0 then
            if connLocal then connLocal:Disconnect() connLocal = nil end
            cleanupFlight()
            return
        end

        local dir = pos - hrp.Position
        local dist = dir.Magnitude
        if dist <= 2 then
            bv.Velocity = Vector3.zero
            arrived = arrived + dt
            if arrived >= 1.0 then
                -- finalize
                if connLocal then connLocal:Disconnect() connLocal = nil end
                -- place player exactly at target (small Y offset to avoid embedding in ground)
                pcall(function()
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
                end)
                cleanupFlight()
            end
        else
            arrived = 0
            local speed = SPEED
            bv.Velocity = dir.Unit * speed
        end
    end)
    conn = connLocal
end

-------------------------------
-- BUTTON EVENTS
-------------------------------
btnPrev.MouseButton1Click:Connect(function()
    index = index - 1
    if index < 1 then index = #Locations end
    UpdateLabel()
end)

btnNext.MouseButton1Click:Connect(function()
    index = index + 1
    if index > #Locations then index = 1 end
    UpdateLabel()
end)

btnFly.MouseButton1Click:Connect(function()
    -- double-check index validity
    if index < 1 then index = 1 end
    if index > #Locations then index = #Locations end
    local loc = Locations[index]
    if loc and loc.Pos then
        FlyTo(loc.Pos)
    end
end)

btnCancel.MouseButton1Click:Connect(function()
    cleanupFlight()
end)

-- ensure cleanup if script destroyed/unloaded
gui.AncestryChanged:Connect(function()
    if not gui:IsDescendantOf(game) then
        cleanupFlight()
    end
end)
```
