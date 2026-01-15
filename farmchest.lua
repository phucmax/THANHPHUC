-- chest4.lua
-- PHUCMAX FARM CHEST (final)
-- Chest-only script (cyborg/boss logic removed)
-- Changes in this build:
--  - Script will NOT auto-start farming on load (press START)
--  - UI reduced to two buttons: START, STOP
--  - All notifications use Title = "PHUCMAX FARM CHEST"
--  - Keeps reliable team selection, chest farming, tween movement, no-clip, server hop, anti-AFK
-- Updated: 2026-01-15

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- =================== CONFIG & GLOBALS ===================
getgenv().team = getgenv().team or "Marines" -- change to "Pirates" if you want
local UI_BG_IMAGE = "rbxassetid://89799706653949"
local BTN_BG_IMAGE = "rbxassetid://89799706653949"
local TOGGLE_IMAGE = "rbxassetid://89799706653949"
local THEME_COLOR = Color3.fromRGB(140, 0, 255)
local TweenSpeed = 350
local SERVER_FETCH_LIMIT = 100

-- Default: do NOT auto-start
getgenv().ChestFarmer = getgenv().ChestFarmer or {
    AutoCollectChest = false,           -- <- default false (user must press START)
    StopTween = false,
    StopTween2 = false,
    CancelTween2 = false,
    AutoRejoin = true,
    AutoHopEnabled = true,
    LastChestCollectedTime = tick(),
    ChestFarmingRunning = false,
    State = "Idle"                      -- used for continuous notifications
}

-- services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- Helper to send uniform notifications
local function Notify(text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "PHUCMAX FARM CHEST",
            Text = tostring(text or ""),
            Duration = tonumber(duration) or 5
        })
    end)
end

-- =================== UTILS: Remote invoker & scanner ===================
local function TryInvokeRemote(remote, ...)
    if not remote then return false end
    local suc = false
    pcall(function()
        if remote:IsA("RemoteFunction") and remote.InvokeServer then
            remote:InvokeServer(...)
            suc = true
        elseif remote:IsA("RemoteEvent") and remote.FireServer then
            remote:FireServer(...)
            suc = true
        end
    end)
    return suc
end

local function IterateRemotes(callback)
    local containers = { ReplicatedStorage, game:GetService("ReplicatedFirst"), Workspace }
    for _,cont in ipairs(containers) do
        if cont then
            for _,child in ipairs(cont:GetDescendants()) do
                if child:IsA("RemoteFunction") or child:IsA("RemoteEvent") then
                    pcall(function() callback(child) end)
                end
            end
        end
    end
    if ReplicatedStorage then
        for _,child in ipairs(ReplicatedStorage:GetChildren()) do
            if child:IsA("RemoteFunction") or child:IsA("RemoteEvent") then
                pcall(function() callback(child) end)
            end
        end
    end
end

-- =================== TEAM SELECTION: improved and reliable ===================
local function PlayerOnTeamChanged()
    local ok, t = pcall(function() return Player.Team and Player.Team.Name or nil end)
    if ok and t then return t end
    return nil
end

local function SetTeamReliable(teamName, attempts, delay)
    attempts = attempts or 18
    delay = delay or 1.0

    local cur = PlayerOnTeamChanged()
    if cur == teamName then
        return true
    end

    getgenv().ChestFarmer.State = "Selecting team: "..tostring(teamName)

    local done = false
    local conn
    conn = Player:GetPropertyChangedSignal("Team"):Connect(function()
        if Player.Team and Player.Team.Name == teamName then
            done = true
            pcall(function() conn:Disconnect() end)
        end
    end)

    for i = 1, attempts do
        if done then break end

        local remContainer = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
        if remContainer then
            local names = { "CommF_", "CommF", "Comm", "Remotes", "Remote" }
            for _,n in ipairs(names) do
                local r = remContainer:FindFirstChild(n)
                if r then
                    pcall(function() TryInvokeRemote(r, "SetTeam", teamName) end)
                    pcall(function() TryInvokeRemote(r, "SetTeam", teamName, true) end)
                    pcall(function() TryInvokeRemote(r, teamName) end)
                end
                if done then break end
            end
        end

        IterateRemotes(function(r)
            if done then return end
            local nameLower = tostring(r.Name):lower()
            if nameLower:find("comm") or nameLower:find("team") or nameLower:find("set") then
                pcall(function() TryInvokeRemote(r, "SetTeam", teamName) end)
                pcall(function() TryInvokeRemote(r, "SetTeam", teamName, true) end)
            else
                pcall(function() TryInvokeRemote(r, "SetTeam", teamName) end)
            end
        end)

        for _ = 1, math.max(1, math.floor(delay / 0.1)) do
            if done then break end
            task.wait(0.1)
        end

        local now = PlayerOnTeamChanged()
        if now == teamName then
            done = true
            break
        end
    end

    if conn and typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end

    local final = PlayerOnTeamChanged()
    if final == teamName then
        getgenv().ChestFarmer.State = "Team set: "..teamName
        return true
    else
        getgenv().ChestFarmer.State = "Team select failed"
        return false
    end
end

spawn(function()
    repeat task.wait() until Player and Player:FindFirstChild("PlayerGui")
    SetTeamReliable(getgenv().team, 20, 1.0)
end)

-- =================== UI: minimal (Start / Stop) ===================
pcall(function()
    if CoreGui:FindFirstChild("PHUCMAX_CHEST_UI") then CoreGui.PHUCMAX_CHEST_UI:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PHUCMAX_CHEST_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local Toggle = Instance.new("ImageButton", ScreenGui)
    Toggle.Name = "PHUCMAX_TOGGLE"
    Toggle.Size = UDim2.fromOffset(60,60)
    Toggle.Position = UDim2.new(0,10,0.5,-30)
    Toggle.Image = TOGGLE_IMAGE
    Toggle.BackgroundTransparency = 1
    Toggle.Active = true
    Toggle.Draggable = true
    Toggle.ZIndex = 10

    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "PHUCMAX_MAIN"
    Main.Size = UDim2.fromOffset(300,160)
    Main.Position = UDim2.new(0.5,-150,0.5,-80)
    Main.BackgroundTransparency = 1
    Main.Active = true
    Main.Draggable = true
    Main.Visible = false
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = THEME_COLOR
    Stroke.Thickness = 2
    local BG = Instance.new("ImageLabel", Main)
    BG.Name = "BG"
    BG.Size = UDim2.fromScale(1,1)
    BG.Image = UI_BG_IMAGE
    BG.BackgroundTransparency = 1
    BG.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", BG).CornerRadius = UDim.new(0,12)

    local Title = Instance.new("TextLabel", Main)
    Title.Name = "Title"
    Title.Size = UDim2.new(1,0,0,34)
    Title.BackgroundTransparency = 1
    Title.Text = "PHUCMAX FARM CHEST"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.TextColor3 = THEME_COLOR
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Position = UDim2.new(0,10,0,6)

    local Info = Instance.new("TextLabel", Main)
    Info.Name = "Info"
    Info.Position = UDim2.new(0,10,0,44)
    Info.Size = UDim2.new(1,-20,0,64)
    Info.BackgroundTransparency = 1
    Info.TextWrapped = true
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.TextYAlignment = Enum.TextYAlignment.Top
    Info.Font = Enum.Font.Gotham
    Info.TextSize = 14
    Info.TextColor3 = Color3.fromRGB(220,220,220)
    Info.Text = "State : Idle"

    local function MakeBtn(text, posX)
        local B = Instance.new("ImageButton", Main)
        B.Size = UDim2.fromOffset(120,34)
        B.Position = UDim2.new(0, posX, 1, -44)
        B.Image = BTN_BG_IMAGE
        B.BackgroundTransparency = 0.3
        Instance.new("UICorner", B).CornerRadius = UDim.new(0,8)
        local T = Instance.new("TextLabel", B)
        T.Size = UDim2.fromScale(1,1)
        T.BackgroundTransparency = 1
        T.Font = Enum.Font.GothamBold
        T.TextSize = 14
        T.Text = text
        T.TextColor3 = Color3.new(1,1,1)
        T.TextXAlignment = Enum.TextXAlignment.Center
        T.TextYAlignment = Enum.TextYAlignment.Center
        return B
    end

    local StartBtn = MakeBtn("START", 10)
    local StopBtn  = MakeBtn("STOP", 170)

    Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    StartBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().ChestFarmer.AutoCollectChest = true
            getgenv().ChestFarmer.ChestFarmingRunning = false
            getgenv().ChestFarmer.State = "Starting farming"
            Notify("Starting farming", 4)
            if type(AutoChestCollect) == "function" then pcall(AutoChestCollect) end
        end)
    end)

    StopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().ChestFarmer.AutoCollectChest = false
            getgenv().ChestFarmer.StopTween = true
            getgenv().ChestFarmer.StopTween2 = true
            getgenv().ChestFarmer.State = "Stopped by user"
            Notify("Stopped by user", 3)
        end)
    end)

    spawn(function()
        while task.wait(0.5) do
            pcall(function()
                local state = getgenv().ChestFarmer.State or "Idle"
                local beli = 0
                if Player and Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Beli") then
                    beli = Player.Data.Beli.Value
                end
                Info.Text = "Money : "..tostring(beli).."\nState : "..tostring(state)
            end)
        end
    end)
end)

-- =================== Utilities & FPS Boost ===================
local function ApplyFPSBoost()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        if Workspace:FindFirstChildOfClass("Terrain") then
            local t = Workspace.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
        end
        local cnt = 0
        for _,v in pairs(game:GetDescendants()) do
            cnt = cnt + 1
            if cnt > 3000 then break end
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    end)
end
ApplyFPSBoost()
spawn(function() while task.wait(60) do pcall(ApplyFPSBoost) end end)

-- =================== Movement / Tweening / NoClip ===================
local function EnableNoClipAndAntiGravity()
    pcall(function()
        local char = Player.Character
        if not char then return end
        for _,part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _,child in pairs(hrp:GetChildren()) do
                if child:IsA("BodyVelocity") and child.Name == "ChestFarmAntiGravity" then child:Destroy() end
            end
            local bv = Instance.new("BodyVelocity")
            bv.Name = "ChestFarmAntiGravity"
            bv.MaxForce = Vector3.new(0,9999,0)
            bv.Velocity = Vector3.new(0,0.25,0)
            bv.P = 1500
            bv.Parent = hrp
            if char:FindFirstChild("Stun") then char.Stun.Value = 0 end
        end
    end)
end

function Tween2(targetCFrame)
    EnableNoClipAndAntiGravity()
    pcall(function()
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local distance = (targetCFrame.Position - char.HumanoidRootPart.Position).Magnitude
        local speed = TweenSpeed
        local tweenInfo = TweenInfo.new(math.max(0.05, distance / speed), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local tween = game:GetService("TweenService"):Create(char.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        if getgenv().ChestFarmer.StopTween then tween:Cancel() end
        task.wait(distance / speed + 0.08)
    end)
end

function Tween(KG)
    pcall(function()
        if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
        local Distance = (KG.Position - Player.Character.HumanoidRootPart.Position).Magnitude
        local Speed = TweenSpeed
        local tweenInfo = TweenInfo.new(math.max(0.05, Distance / Speed), Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(Player.Character.HumanoidRootPart, tweenInfo, {CFrame = KG})
        tween:Play()
        if getgenv().ChestFarmer.StopTween then tween:Cancel() end
    end)
end

function BKP(Point)
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Point
            task.wait()
            Player.Character.HumanoidRootPart.CFrame = Point
        end
    end)
end

-- =================== Server Hop ===================
function HopServer()
    getgenv().ChestFarmer.State = "Hopping server"
    Notify("Hopping server", 4)
    local ok, res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?limit="..tostring(SERVER_FETCH_LIMIT))
    end)
    if not ok or not res then return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not ok2 or type(data) ~= "table" or not data.data then return end
    for _,v in pairs(data.data) do
        if type(v) == "table" and v.id and v.playing < (v.maxPlayers or math.huge) and v.id ~= game.JobId then
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, Player) end)
            return
        end
    end
end

function SmartServerHop()
    if not getgenv().ChestFarmer.AutoHopEnabled then return end
    getgenv().ChestFarmer.State = "Hopping server (smart)"
    Notify("Hopping server (smart)", 4)
    pcall(function()
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(req)
        local servers = {}
        for i,v in pairs(data.data or {}) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then table.insert(servers, v.id) end
        end
        if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], Player) end
    end)
end

if pcall(function() game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100") end) then
    HopServer = SmartServerHop
end

-- =================== Chest detection & collection ===================
local function GetChest()
    local best
    local dist = math.huge
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart.Position

    if Workspace:FindFirstChild("Map") then
        for _,v in pairs(Workspace.Map:GetDescendants()) do
            if v:IsA("BasePart") and tostring(v.Name):lower():find("chest") then
                if v:FindFirstChild("TouchInterest") then
                    local d = (v.Position - hrp).Magnitude
                    if d < dist then dist = d; best = v end
                end
            end
        end
    else
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and tostring(v.Name):lower():find("chest") then
                if v:FindFirstChild("TouchInterest") then
                    local d = (v.Position - hrp).Magnitude
                    if d < dist then dist = d; best = v end
                end
            end
        end
    end
    return best
end

function ForceStopChestCollection()
    getgenv().ChestFarmer.AutoCollectChest = false
    getgenv().ChestFarmer.ChestFarmingRunning = false
    getgenv().ChestFarmer.StopTween = true
    getgenv().ChestFarmer.StopTween2 = true
    getgenv().ChestFarmer.CancelTween2 = false
    getgenv().ChestFarmer.State = "Force stopped"
    Notify("Chest collection forced stop", 3)
end

local function GetMoneyValue()
    local v = 0
    pcall(function()
        if Player and Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Beli") then
            v = tonumber(Player.Data.Beli.Value) or 0
        end
    end)
    return v
end

function AutoChestCollect()
    if getgenv().ChestFarmer.ChestFarmingRunning then return end
    getgenv().ChestFarmer.ChestFarmingRunning = true
    spawn(function()
        while task.wait(0.1) do
            if not getgenv().ChestFarmer.AutoCollectChest then
                getgenv().ChestFarmer.State = "Idle"
                task.wait(1)
                continue
            end

            getgenv().ChestFarmer.State = "Finding chest"
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1); continue end

            local chest = GetChest()
            if chest and chest.Parent then
                getgenv().ChestFarmer.State = "Approaching chest"
                local targetCFrame = CFrame.new(chest.Position + Vector3.new(0, 1.2, 0))
                pcall(function() Tween2(targetCFrame) end)

                task.wait(0.12)
                pcall(function()
                    local prevMoney = GetMoneyValue()
                    for i=1,4 do
                        if not chest or not chest.Parent then break end
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = CFrame.new(chest.Position + Vector3.new(0, 1.2, 0))
                        end
                        task.wait(0.08)
                        local nowMoney = GetMoneyValue()
                        if nowMoney > prevMoney then
                            getgenv().ChestFarmer.LastChestCollectedTime = tick()
                            getgenv().ChestFarmer.State = "Collected chest"
                            Notify("Collected chest", 2)
                            break
                        end
                    end
                end)
                task.wait(0.15)
            else
                getgenv().ChestFarmer.State = "No chest nearby"
                if tick() - getgenv().ChestFarmer.LastChestCollectedTime > 60 then
                    getgenv().ChestFarmer.State = "Idle - hopping soon"
                    Notify("No chest found recently, hopping server", 3)
                    pcall(HopServer)
                    task.wait(5)
                end
            end
        end
    end)
end

-- =================== Stuck detection & auto-hop ===================
local lastPos = nil
local stuckSince = 0
function CheckIfStuckAndHop()
    pcall(function()
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local pos = char.HumanoidRootPart.Position
        if lastPos then
            if (pos - lastPos).Magnitude < 1 then
                if stuckSince == 0 then stuckSince = tick() end
                if tick() - stuckSince > 30 then
                    pcall(function() char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,5,0) end)
                    task.wait(2)
                    if (char.HumanoidRootPart.Position - pos).Magnitude < 1 then
                        Notify("Stuck - hopping server", 4)
                        pcall(HopServer)
                    end
                    stuckSince = 0
                end
            else
                stuckSince = 0
            end
        end
        lastPos = pos
    end)
end

-- =================== Auto-jump (anti-AFK) & Anti-kick ===================
spawn(function()
    local player = Players.LocalPlayer
    while task.wait(math.random(15,20)) do
        pcall(function()
            if getgenv().ChestFarmer.AutoCollectChest and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

spawn(function()
    while task.wait(1) do
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                if Player.Character.HumanoidRootPart.Velocity.Magnitude < 0.1 then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,0.01)
                end
            end
        end)
    end
end)

-- =================== Continuous status notifications ===================
spawn(function()
    while task.wait(6) do
        pcall(function()
            local state = getgenv().ChestFarmer.State or "Unknown"
            Notify(state, 5)
        end)
    end
end)

-- =================== Initialization (NO AUTO-START) ===================
getgenv().ChestFarmer.State = "PHUCMAX"
Notify("loading successful ", 5)

-- Maintain stuck-checking when farming is enabled by user
spawn(function()
    while task.wait(1) do
        if getgenv().ChestFarmer.AutoHopEnabled and getgenv().ChestFarmer.AutoCollectChest then
            pcall(CheckIfStuckAndHop)
        end
    end
end)

spawn(function()
    while task.wait(10) do
        if getgenv().ChestFarmer.AutoCollectChest and not getgenv().ChestFarmer.ChestFarmingRunning then
            pcall(AutoChestCollect)
        end
    end
end)