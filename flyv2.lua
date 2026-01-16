--==============================
-- PHUCMAX | FULL FLY LOCATION UI
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
    {Name="HOME", Pos=Vector3.new(128.74, 3.18, 15.57)},
}

local index = 1

-------------------------------
-- UI
-------------------------------
pcall(function()
    lp.PlayerGui:FindFirstChild("PHUCMAX_UI"):Destroy()
end)

local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "PHUCMAX_UI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,340,0,250)
main.Position = UDim2.new(0.5,-170,0.65,0)
main.BorderSizePixel = 0
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,22)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Transparency = 0.25

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "PHUCMAX"
title.Font = Enum.Font.GothamBlack
title.TextSize = 26
title.TextColor3 = Color3.new(1,1,1)

local locLabel = Instance.new("TextLabel", main)
locLabel.Size = UDim2.new(1,-20,0,30)
locLabel.Position = UDim2.new(0,10,0.26,0)
locLabel.BackgroundTransparency = 1
locLabel.Font = Enum.Font.GothamBold
locLabel.TextSize = 16
locLabel.TextWrapped = true
locLabel.TextColor3 = Color3.fromRGB(200,255,240)

local function makeBtn(text, pos)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.38,0,0,42)
    b.Position = pos
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(35,35,45)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
    return b
end

local btnPrev = makeBtn("◀ PREV", UDim2.new(0.06,0,0.45,0))
local btnNext = makeBtn("NEXT ▶", UDim2.new(0.56,0,0.45,0))

local btnFly = Instance.new("TextButton", main)
btnFly.Size = UDim2.new(0.88,0,0,46)
btnFly.Position = UDim2.new(0.06,0,0.7,0)
btnFly.Text = "FLY TO SELECTED"
btnFly.Font = Enum.Font.GothamBlack
btnFly.TextSize = 16
btnFly.TextColor3 = Color3.new(1,1,1)
btnFly.BackgroundColor3 = Color3.fromRGB(0,180,150)
btnFly.BorderSizePixel = 0
Instance.new("UICorner", btnFly).CornerRadius = UDim.new(0,18)

-------------------------------
-- DRAG UI (FIXED)
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
-- RAINBOW SMOOTH
-------------------------------
task.spawn(function()
    local h = 0
    while gui.Parent do
        h = (h + 0.01) % 1
        main.BackgroundColor3 = Color3.fromHSV(h,0.6,0.25)
        title.TextColor3 = Color3.fromHSV(h,1,1)
        stroke.Color = Color3.fromHSV((h+0.3)%1,1,1)
        task.wait(0.03)
    end
end)

-------------------------------
-- CHARACTER
-------------------------------
local char, hrp
local flying = false
local bv, conn
local SPEED = 500

local function loadChar(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    flying = false
    btnFly.Text = "FLY TO SELECTED"
end

loadChar(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(loadChar)

local function SetNoclip(on)
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not on
        end
    end
end

-------------------------------
-- UPDATE LABEL
-------------------------------
local function UpdateLabel()
    locLabel.Text = "["..index.."] "..Locations[index].Name
end
UpdateLabel()

-------------------------------
-- FLY LOGIC
-------------------------------
local function FlyTo(pos)
    if flying or not hrp then return end
    flying = true
    btnFly.Text = "FLYING..."
    SetNoclip(true)

    local arrived = 0
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e6,1e6,1e6)

    conn = RunService.RenderStepped:Connect(function(dt)
        local dir = pos - hrp.Position
        if dir.Magnitude <= 2 then
            bv.Velocity = Vector3.zero
            arrived += dt
            if arrived >= 2 then
                flying = false
                SetNoclip(false)
                bv:Destroy()
                conn:Disconnect()
                hrp.CFrame = CFrame.new(pos)
                btnFly.Text = "DONE"
            end
        else
            arrived = 0
            bv.Velocity = dir.Unit * SPEED
        end
    end)
end

-------------------------------
-- BUTTON EVENTS
-------------------------------
btnPrev.MouseButton1Click:Connect(function()
    index -= 1
    if index < 1 then index = #Locations end
    UpdateLabel()
end)

btnNext.MouseButton1Click:Connect(function()
    index += 1
    if index > #Locations then index = 1 end
    UpdateLabel()
end)

btnFly.MouseButton1Click:Connect(function()
    FlyTo(Locations[index].Pos)
end)