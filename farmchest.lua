--// PHUCMAX | Farm Chest v1
--// Stable Fix | Mobile | Executor

repeat task.wait() until game:IsLoaded()

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ================= CONFIG =================
local UI_BG_IMAGE = "rbxassetid://89799706653949"
local BTN_BG_IMAGE = "rbxassetid://89799706653949"
local TOGGLE_IMAGE = "rbxassetid://89799706653949"
local THEME_COLOR = Color3.fromRGB(140, 0, 255)

-- ================= GLOBAL STATE =================
getgenv().PHUCMAX = {
    Running = false,
    Flying = false,
    StartTime = 0
}

-- ================= CHARACTER =================
local Character, HRP

local function UpdateChar()
    Character = Player.Character or Player.CharacterAdded:Wait()
    HRP = Character:WaitForChild("HumanoidRootPart")
end
UpdateChar()

Player.CharacterAdded:Connect(function()
    task.wait(1)
    UpdateChar()
end)

-- ================= UI =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PHUCMAX_UI"
ScreenGui.ResetOnSpawn = false

local Toggle = Instance.new("ImageButton", ScreenGui)
Toggle.Size = UDim2.fromOffset(60,60)
Toggle.Position = UDim2.new(0,10,0.5,-30)
Toggle.Image = TOGGLE_IMAGE
Toggle.BackgroundTransparency = 1
Toggle.Active = true
Toggle.Draggable = true

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(420,260)
Main.Position = UDim2.new(0.5,-210,0.5,-130)
Main.BackgroundTransparency = 1
Main.Active = true
Main.Draggable = true
Main.Visible = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = THEME_COLOR
Stroke.Thickness = 2

local BG = Instance.new("ImageLabel", Main)
BG.Size = UDim2.fromScale(1,1)
BG.Image = UI_BG_IMAGE
BG.BackgroundTransparency = 1
BG.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", BG).CornerRadius = UDim.new(0,18)

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
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Font = Enum.Font.Gotham
Info.TextSize = 15
Info.TextColor3 = Color3.fromRGB(220,220,220)

local function Button(text,pos)
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

local StartBtn = Button("START", UDim2.new(0.1,0,1,-60))
local StopBtn  = Button("STOP",  UDim2.new(0.37,0,1,-60))
local ResetBtn = Button("RESET", UDim2.new(0.64,0,1,-60))

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

task.spawn(function()
    while task.wait(0.3) do
        local beli = 0
        pcall(function()
            if Player and Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Beli") then
                beli = Player.Data.Beli.Value
            end
        end)
        local t = 0
        if getgenv().PHUCMAX.Running then
            t = math.floor(tick() - getgenv().PHUCMAX.StartTime)
        end
        local hours = math.floor(t / 3600) % 24
        local mins  = math.floor(t / 60) % 60
        local secs  = t % 60
        Info.Text = "Money : "..tostring(beli).."\nTime : "..string.format("%02d:%02d:%02d", hours, mins, secs)
    end
end)

-- ================= AUTO TEAM =================
local function AutoTeam()
    if Player.PlayerGui:FindFirstChild("Main (minimal)") then
        repeat task.wait(1)
            pcall(function()
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam","Marines")
            end)
        until not Player.PlayerGui:FindFirstChild("Main (minimal)")
    end
end

-- ================= FIX LAG =================
local function FixLag()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.FogEnd = 9e9
    if Workspace:FindFirstChildOfClass("Terrain") then
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
        Workspace.Terrain.WaterTransparency = 1
    end
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(120,120,120)
            v.Reflectance = 0
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
end

-- ================= FLY =================
local BodyGyro, BodyVel
local function StartFly()
    if getgenv().PHUCMAX.Flying then return end
    -- ensure character root exists
    if not HRP or not HRP.Parent then
        pcall(UpdateChar)
        if not HRP or not HRP.Parent then return end
    end
    getgenv().PHUCMAX.Flying = true

    -- cleanup any previous bindings/instances
    pcall(function() RunService:UnbindFromRenderStep("PHUCMAX_FLY") end)
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVel then BodyVel:Destroy() BodyVel = nil end

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Parent = HRP
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)

    BodyVel = Instance.new("BodyVelocity")
    BodyVel.Parent = HRP
    BodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
    BodyVel.Velocity = Vector3.new(0,0,0)

    RunService:BindToRenderStep("PHUCMAX_FLY", Enum.RenderPriority.Character.Value, function()
        if not getgenv().PHUCMAX.Running then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        if BodyGyro and BodyGyro.Parent then
            BodyGyro.CFrame = cam.CFrame
        end
        if BodyVel and BodyVel.Parent then
            BodyVel.Velocity = cam.CFrame.LookVector * 350
        end
        for _,p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end

local function StopFly()
    getgenv().PHUCMAX.Flying = false
    pcall(function() RunService:UnbindFromRenderStep("PHUCMAX_FLY") end)
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVel then BodyVel:Destroy() BodyVel = nil end
end

-- ================= CHEST =================
local function GetChests()
    local t = {}
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("chest") then
            table.insert(t,v)
        elseif v:IsA("Model") and v.Name:lower():find("chest") then
            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if part then table.insert(t, part) end
        end
    end
    return t
end

-- ================= SERVER HOP =================
local Visited = {}
local function Hop()
    local ok, res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?limit=100")
    end)
    if not ok or not res then return end
    local ok2, servers = pcall(function() return HttpService:JSONDecode(res) end)
    if not ok2 or type(servers) ~= "table" or not servers.data then return end
    for _,v in pairs(servers.data) do
        if type(v) == "table" and v.id and not Visited[v.id] and v.playing < (v.maxPlayers or math.huge) then
            Visited[v.id] = true
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, Player)
            end)
            break
        end
    end
end

-- ================= MAIN =================
task.spawn(function()
    while task.wait(1) do
        if getgenv().PHUCMAX.Running then
            UpdateChar()
            AutoTeam()
            FixLag()
            StartFly()

            local chests = GetChests()
            if #chests > 0 then
                for _,c in pairs(chests) do
                    if not getgenv().PHUCMAX.Running then break end
                    UpdateChar()
                    if HRP and c and c:IsA("BasePart") then
                        HRP.CFrame = c.CFrame + Vector3.new(0,6,0)
                        task.wait(0.25)
                    end
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