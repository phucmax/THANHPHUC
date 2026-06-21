-- ============================================================
-- DUPE TOOL VÔ HẠN - UI NHỎ KÉO THẢ
-- ============================================================

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui") or gethui and gethui() or LP:WaitForChild("PlayerGui")

-- ============================================================
-- TẠO UI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DupeToolUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(160, 50)
Main.Position = UDim2.new(0.5, -80, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 1.5
UIStroke.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 18)
Title.Position = UDim2.new(0, 0, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = " XNhau DUPE VIP "
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 11
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- Nút Dupe
local DupeButton = Instance.new("TextButton")
DupeButton.Name = "DupeBtn"
DupeButton.Size = UDim2.new(0.85, 0, 0, 22)
DupeButton.Position = UDim2.new(0.075, 0, 0, 24)
DupeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
DupeButton.BorderSizePixel = 0
DupeButton.Text = " DUPE"
DupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeButton.TextSize = 11
DupeButton.Font = Enum.Font.GothamBold
DupeButton.AutoButtonColor = false
DupeButton.Parent = Main

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = DupeButton

-- ============================================================
-- ANIMATION NÚT KHI CLICK
-- ============================================================
local function animateButton()
    TweenService:Create(DupeButton, TweenInfo.new(0.1), { Size = UDim2.new(0.9, 0, 0, 24) }):Play()
    task.wait(0.1)
    TweenService:Create(DupeButton, TweenInfo.new(0.1), { Size = UDim2.new(0.85, 0, 0, 22) }):Play()
end

-- ============================================================
-- KÉO THẢ
-- ============================================================
local dragging = false
local dragStart = nil
local startPos = nil

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================================
-- NOTIFICATION
-- ============================================================
local function Notify(msg, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, 200, 0, 30)
    notif.Position = UDim2.new(0.5, -100, 0.8, 0)
    notif.Text = msg
    notif.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    notif.TextSize = 12
    notif.Font = Enum.Font.GothamBold
    notif.ZIndex = 10
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = notif
    
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255, 255, 255)
    s.Thickness = 1
    s.Parent = notif
    
    task.spawn(function()
        task.wait(2)
        notif:Destroy()
    end)
end

-- ============================================================
-- DUPE FUNCTION
-- ============================================================
local function getCurrentTool()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then return child end
    end
    return nil
end

local function dupeToolToBackpack()
    local tool = getCurrentTool()
    if not tool then
        Notify(" Cầm trên tay trước!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    -- Clone tool vào backpack
    local success = false
    
    -- Cách 1: Clone trực tiếp
    pcall(function()
        local clone = tool:Clone()
        clone.Parent = LP:FindFirstChildOfClass("Backpack") or LP.Backpack
        success = true
    end)
    
    -- Cách 2: Deep clone
    if not success then
        pcall(function()
            local clone = tool:Clone()
            -- Copy tất cả children
            for _, child in ipairs(tool:GetChildren()) do
                if not clone:FindFirstChild(child.Name) then
                    local clonedChild = child:Clone()
                    clonedChild.Parent = clone
                end
            end
            clone.Parent = LP:FindFirstChildOfClass("Backpack") or LP.Backpack
            success = true
        end)
    end
    
    -- Cách 3: Tạo tool mới
    if not success then
        pcall(function()
            local newTool = Instance.new("Tool")
            newTool.Name = tool.Name
            newTool.ToolTip = tool.ToolTip or ""
            newTool.RequiresHandle = tool.RequiresHandle
            newTool.CanBeDropped = tool.CanBeDropped
            
            -- Copy handle
            local handle = tool:FindFirstChild("Handle")
            if handle then
                local newHandle = handle:Clone()
                newHandle.Parent = newTool
            end
            
            -- Copy scripts
            for _, child in ipairs(tool:GetChildren()) do
                if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
                    child:Clone().Parent = newTool
                end
            end
            
            newTool.Parent = LP:FindFirstChildOfClass("Backpack") or LP.Backpack
            success = true
        end)
    end
    
    if success then
        Notify(" Đã dupe: " .. tool.Name, Color3.fromRGB(0, 255, 100))
    else
        Notify(" Dupe thất bại!", Color3.fromRGB(255, 100, 100))
    end
end

-- ============================================================
-- KẾT NỐI NÚT
-- ============================================================
DupeButton.MouseButton1Click:Connect(function()
    animateButton()
    dupeToolToBackpack()
end)

-- ============================================================
-- PHÍM TẮT X = DUPE
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        dupeToolToBackpack()
    end
end)

-- ============================================================
-- HIỆU ỨNG VIỀN PHÁT SÁNG
-- ============================================================
local hue = 0
task.spawn(function()
    while true do
        hue = (hue + 1) % 360
        local color = Color3.fromHSV(hue / 360, 1, 1)
        UIStroke.Color = color
        task.wait(0.05)
    end
end)

