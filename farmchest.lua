--// PHUCMAX | Farm Chest v1
--// Mobile Friendly | Executor Only

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG =================
local UI_BG_IMAGE = "rbxassetid://89799706653949" -- <<< ID ảnh background UI
local BTN_BG_IMAGE = "rbxassetid://89799706653949" -- <<< ID ảnh nút
local TOGGLE_IMAGE = "rbxassetid://89799706653949" -- <<< ID ảnh nút tròn
local THEME_COLOR = Color3.fromRGB(140, 0, 255) -- tím rợn gamer
-- ==========================================

getgenv().PHUCMAX = {
    Running = false,
    StartTime = 0
}

-- ================= UI SETUP =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PHUCMAX_UI"
ScreenGui.ResetOnSpawn = false

-- Toggle Button
local Toggle = Instance.new("ImageButton", ScreenGui)
Toggle.Size = UDim2.fromOffset(60,60)
Toggle.Position = UDim2.new(0,10,0.5,-30)
Toggle.Image = TOGGLE_IMAGE
Toggle.BackgroundTransparency = 1
Toggle.Active = true
Toggle.Draggable = true

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(420,260)
Main.Position = UDim2.new(0.5,-210,0.5,-130)
Main.BackgroundTransparency = 1
Main.Visible = true
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = THEME_COLOR
Stroke.Thickness = 2
Stroke.Transparency = 0

local BG = Instance.new("ImageLabel", Main)
BG.Size = UDim2.fromScale(1,1)
BG.Image = UI_BG_IMAGE
BG.BackgroundTransparency = 1
BG.ScaleType = Enum.ScaleType.Crop
BG.ZIndex = 0
Instance.new("UICorner", BG).CornerRadius = UDim.new(0,18)

-- ================= TEXT =================
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "PHUCMAX"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 32
Title.TextColor3 = THEME_COLOR

local Sub = Instance.new("TextLabel", Main)
Sub.Position = UDim2.new(0,0,0,45)
Sub.Size = UDim2.new(1,0,0,22)
Sub.BackgroundTransparency = 1
Sub.Text = "farm chest v1"
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 14
Sub.TextColor3 = Color3.fromRGB(200,200,200)

local Info = Instance.new("TextLabel", Main)
Info.Position = UDim2.new(0,20,0,80)
Info.Size = UDim2.new(1,-40,0,70)
Info.BackgroundTransparency = 1
Info.TextWrapped = true
Info.TextXAlignment = Left
Info.TextYAlignment = Top
Info.Font = Enum.Font.Gotham
Info.TextSize = 15
Info.TextColor3 = Color3.fromRGB(220,220,220)

-- ================= BUTTONS =================
local function CreateButton(text,pos)
    local B = Instance.new("ImageButton", Main)
    B.Size = UDim2.fromOffset(110,45)
    B.Position = pos
    B.Image = BTN_BG_IMAGE
    B.BackgroundTransparency = 1

    Instance.new("UICorner", B).CornerRadius = UDim.new(0,12)
    local S = Instance.new("UIStroke", B)
    S.Color = THEME_COLOR
    S.Thickness = 1.5

    local T = Instance.new("TextLabel", B)
    T.Size = UDim2.fromScale(1,1)
    T.BackgroundTransparency = 1
    T.Text = text
    T.Font = Enum.Font.GothamBold
    T.TextSize = 16
    T.TextColor3 = Color3.new(1,1,1)
    return B
end

local StartBtn = CreateButton("START", UDim2.new(0.1,0,1,-60))
local StopBtn  = CreateButton("STOP",  UDim2.new(0.37,0,1,-60))
local ResetBtn = CreateButton("RESET", UDim2.new(0.64,0,1,-60))

-- ================= LOGIC =================
Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

StartBtn.MouseButton1Click:Connect(function()
    if not getgenv().PHUCMAX.Running then
        getgenv().PHUCMAX.Running = true
        getgenv().PHUCMAX.StartTime = tick()
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    getgenv().PHUCMAX.Running = false
end)

ResetBtn.MouseButton1Click:Connect(function()
    getgenv().PHUCMAX.Running = false
    getgenv().PHUCMAX.StartTime = tick()
end)

-- ================= UPDATE LOOP =================
task.spawn(function()
    while task.wait(0.3) do
        local beli = 0
        pcall(function()
            beli = LocalPlayer.Data.Beli.Value
        end)

        local timeUse = 0
        if getgenv().PHUCMAX.Running then
            timeUse = tick() - getgenv().PHUCMAX.StartTime
        end

        local h = math.floor(timeUse/3600)
        local m = math.floor((timeUse%3600)/60)
        local s = math.floor(timeUse%60)

        Info.Text =
            "Money : "..beli.."\n"..
            string.format("Time : %02d:%02d:%02d",h,m,s)
    end
end)

-- ================= SERVICES =================
local RS = game:GetService("RunService")
local TS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- ================= TEAM MARINES =================
local function AutoTeam()
    if Player.PlayerGui:FindFirstChild("Main (minimal)") then
        repeat task.wait(1)
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam","Marines")
        until not Player.PlayerGui:FindFirstChild("Main (minimal)")
    end
end

-- ================= FIX LAG =================
local function FixLag()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.FogEnd = 9e9
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)

    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(120,120,120)
            v.Reflectance = 0
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("Water") then
            v:Destroy()
        end
    end
end

-- ================= FLY + NOCLIP =================
local BodyGyro, BodyVel
local function StartFly()
    BodyGyro = Instance.new("BodyGyro", HRP)
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    BodyGyro.CFrame = HRP.CFrame

    BodyVel = Instance.new("BodyVelocity", HRP)
    BodyVel.Velocity = Vector3.new(0,0,0)
    BodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)

    RS:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, function()
        if not getgenv().PHUCMAX.Running then return end
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        BodyVel.Velocity = workspace.CurrentCamera.CFrame.LookVector * 350
    end)

    RS:BindToRenderStep("Noclip", 1, function()
        for _,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end

local function StopFly()
    RS:UnbindFromRenderStep("Fly")
    RS:UnbindFromRenderStep("Noclip")
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVel then BodyVel:Destroy() end
end

-- ================= CHEST SCAN =================
local function GetChests()
    local chests = {}
    for _,v in pairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("chest") and v:IsA("BasePart") then
            table.insert(chests,v)
        end
    end
    return chests
end

-- ================= TOOL CHECK =================
local function HasItem(name)
    return Player.Backpack:FindFirstChild(name) or Character:FindFirstChild(name)
end

-- ================= SERVER HOP NO DUP =================
local VisitedServers = {}
local function Hop()
    local PlaceId = game.PlaceId
    local servers = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    )

    for _,v in pairs(servers.data) do
        if v.playing < v.maxPlayers and not VisitedServers[v.id] then
            VisitedServers[v.id] = true
            TS:TeleportToPlaceInstance(PlaceId, v.id, Player)
            break
        end
    end
end

-- ================= MAIN LOOP =================
task.spawn(function()
    while task.wait(1) do
        if getgenv().PHUCMAX.Running then
            AutoTeam()
            FixLag()
            StartFly()

            -- STOP CONDITION
            if HasItem("God's Chalice") and HasItem("Blackbeard Key") then
                getgenv().PHUCMAX.Running = false
                StopFly()
                break
            end

            local Chests = GetChests()
            if #Chests > 0 then
                for _,c in pairs(Chests) do
                    if not getgenv().PHUCMAX.Running then break end
                    HRP.CFrame = c.CFrame + Vector3.new(0,5,0)
                    task.wait(0.2)
                end
            else
                StopFly()
                task.wait(2)
                Hop()
            end
        else
            StopFly()
        end
    end
end)