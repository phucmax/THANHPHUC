-- chest4.lua (complete - chest-only, cyborg/boss logic removed)
-- Features:
--  - Reliable team selection (Marines / Pirates)
--  - Non-invasive UI (Start/Stop/Toggle/Hop/ForceStop/Refresh)
--  - FPS boost
--  - No-clip / anti-gravity helper
--  - Tween movement and safe Tween2 approach
--  - Chest detection & collection loop (snap & bump to ensure pickup)
--  - Server hop (smart) and stuck detection
--  - Anti-AFK / anti-kick
--  - All cyborg/corebrain/fist/boss code removed

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- =================== Reliable team selection ===================
getgenv().team = getgenv().team or "Marines" -- set to "Pirates" if you want pirates

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function TryInvokeRemote(remote, ...)
    if not remote then return end
    pcall(function()
        if remote:IsA("RemoteFunction") and remote.InvokeServer then
            remote:InvokeServer(...)
        elseif remote:IsA("RemoteEvent") and remote.FireServer then
            remote:FireServer(...)
        end
    end)
end

local function SetTeamReliable(teamName, attempts, delay)
    attempts = attempts or 12
    delay = delay or 1.2
    for i = 1, attempts do
        local ok, currentTeam = pcall(function() return LocalPlayer.Team and LocalPlayer.Team.Name end)
        if ok and currentTeam == teamName then
            return true
        end

        local remotesContainer = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
        if remotesContainer then
            local candidates = { "CommF_", "CommF", "Comm", "Remotes" }
            for _, name in ipairs(candidates) do
                local r = remotesContainer:FindFirstChild(name)
                if r then
                    TryInvokeRemote(r, "SetTeam", teamName)
                    TryInvokeRemote(r, "SetTeam", teamName, true)
                    TryInvokeRemote(r, teamName)
                end
            end

            for _, r in ipairs(remotesContainer:GetChildren()) do
                if (r:IsA("RemoteFunction") or r:IsA("RemoteEvent")) and (r.Name:lower():find("comm") or r.Name:lower():find("setteam") or r.Name:lower():find("team")) then
                    TryInvokeRemote(r, "SetTeam", teamName)
                    TryInvokeRemote(r, "SetTeam", teamName, true)
                end
            end
        end

        task.wait(delay)
    end

    local ok2, currentTeam2 = pcall(function() return LocalPlayer.Team and LocalPlayer.Team.Name end)
    return ok2 and (currentTeam2 == teamName)
end

spawn(function()
    repeat task.wait() until LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    local tries = 6
    for i = 1, tries do
        if LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
            SetTeamReliable(getgenv().team, 15, 1.0)
            break
        end
        task.wait(1)
    end
end)

-- =================== Config & Globals ===================
local UI_BG_IMAGE = "rbxassetid://89799706653949"
local BTN_BG_IMAGE = "rbxassetid://138311826892324"
local TOGGLE_IMAGE = "rbxassetid://138094680927347"
local THEME_COLOR = Color3.fromRGB(140, 0, 255)
local TweenSpeed = 350
local SERVER_FETCH_LIMIT = 100

getgenv().ChestFarmer = getgenv().ChestFarmer or {
    AutoCollectChest = true,
    StopTween = false,
    StopTween2 = false,
    CancelTween2 = false,
    AutoRejoin = true,
    AutoHopEnabled = true,
    LastChestCollectedTime = tick(),
    ChestFarmingRunning = false,
}

local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

-- =================== UI (non-invasive) ===================
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("PHUCMAX_CHEST_UI") then
        CoreGui.PHUCMAX_CHEST_UI:Destroy()
    end

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
    Main.Size = UDim2.fromOffset(420,300)
    Main.Position = UDim2.new(0.5,-210,0.5,-150)
    Main.BackgroundTransparency = 1
    Main.Active = true
    Main.Draggable = true
    Main.Visible = false
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = THEME_COLOR
    Stroke.Thickness = 2
    local BG = Instance.new("ImageLabel", Main)
    BG.Name = "BG"
    BG.Size = UDim2.fromScale(1,1)
    BG.Image = UI_BG_IMAGE
    BG.BackgroundTransparency = 1
    BG.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", BG).CornerRadius = UDim.new(0,18)

    local Title = Instance.new("TextLabel", Main)
    Title.Name = "Title"
    Title.Size = UDim2.new(1,0,0,45)
    Title.BackgroundTransparency = 1
    Title.Text = "PHUCMAX-FARM-CHEST"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 20
    Title.TextColor3 = THEME_COLOR
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Position = UDim2.new(0,18,0,6)

    local Info = Instance.new("TextLabel", Main)
    Info.Name = "Info"
    Info.Position = UDim2.new(0,20,0,60)
    Info.Size = UDim2.new(1,-40,0,80)
    Info.BackgroundTransparency = 1
    Info.TextWrapped = true
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.TextYAlignment = Enum.TextYAlignment.Top
    Info.Font = Enum.Font.Gotham
    Info.TextSize = 14
    Info.TextColor3 = Color3.fromRGB(220,220,220)
    Info.Text = "Money : 0\nTime : 00:00:00\nState : Idle"

    local BtnContainer = Instance.new("Frame", Main)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Size = UDim2.new(1, -40, 0, 100)
    BtnContainer.Position = UDim2.new(0,20,1,-120)

    local function Button(text, pos)
        local B = Instance.new("ImageButton", BtnContainer)
        B.Size = UDim2.fromOffset(120,40)
        B.Position = pos
        B.Image = BTN_BG_IMAGE
        B.BackgroundTransparency = 0.3
        Instance.new("UICorner", B).CornerRadius = UDim.new(0,10)
        local S = Instance.new("UIStroke", B)
        S.Color = THEME_COLOR
        S.Thickness = 1
        local T = Instance.new("TextLabel", B)
        T.Size = UDim2.fromScale(1,1)
        T.BackgroundTransparency = 1
        T.Text = text
        T.Font = Enum.Font.GothamBold
        T.TextSize = 14
        T.TextColor3 = Color3.new(1,1,1)
        return B, T
    end

    local StartBtn, _ = Button("START", UDim2.new(0,0,0,0))
    local StopBtn, _  = Button("STOP", UDim2.new(0,130,0,0))
    local ToggleCollectBtn, _ = Button("Toggle Collect", UDim2.new(0,260,0,0))
    local HopBtn, _ = Button("Hop Now", UDim2.new(0,0,0,50))
    local ForceStopBtn, _ = Button("Force Stop", UDim2.new(0,130,0,50))
    local RefreshBtn, _ = Button("REFRESH INFO", UDim2.new(0,260,0,50))

    Toggle.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    StartBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().ChestFarmer.AutoCollectChest = true
            getgenv().ChestFarmer.ChestFarmingRunning = false
            if type(AutoChestCollect) == "function" then pcall(AutoChestCollect) end
        end)
    end)

    StopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().ChestFarmer.AutoCollectChest = false
            getgenv().ChestFarmer.StopTween = true
            getgenv().ChestFarmer.StopTween2 = true
        end)
    end)

    ToggleCollectBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().ChestFarmer.AutoCollectChest = not getgenv().ChestFarmer.AutoCollectChest
            if getgenv().ChestFarmer.AutoCollectChest then
                getgenv().ChestFarmer.ChestFarmingRunning = false
                if type(AutoChestCollect) == "function" then pcall(AutoChestCollect) end
            end
        end)
    end)

    HopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if type(HopServer) == "function" then
                pcall(HopServer)
            elseif type(SmartServerHop) == "function" then
                pcall(SmartServerHop)
            end
        end)
    end)

    ForceStopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            ForceStopChestCollection()
        end)
    end)

    RefreshBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local beli = 0
            if Player and Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Beli") then
                beli = Player.Data.Beli.Value
            end
            Info.Text = "Money : "..tostring(beli).."\nTime : 00:00:00\nState : "..( getgenv().ChestFarmer.AutoCollectChest and "Farming" or "Stopped")
        end)
    end)

    spawn(function()
        local startTime = tick()
        while task.wait(0.5) do
            pcall(function()
                local beli = 0
                if Player and Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Beli") then
                    beli = Player.Data.Beli.Value
                end
                local t = 0
                if getgenv().ChestFarmer.AutoCollectChest then t = math.floor(tick() - startTime) end
                local hours = math.floor(t / 3600) % 24
                local mins  = math.floor(t / 60) % 60
                local secs  = t % 60
                local state = getgenv().ChestFarmer.AutoCollectChest and "Farming" or "Stopped"
                Info.Text = "Money : "..tostring(beli).."\nTime : "..string.format("%02d:%02d:%02d", hours, mins, secs).."\nState : "..state
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
spawn(function()
    while task.wait(60) do pcall(ApplyFPSBoost) end
end)

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

function SafeTween(targetCF, speed)
    local ok, res = pcall(function()
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return nil, 0 end
        local dist = (targetCF.Position - char.HumanoidRootPart.Position).Magnitude
        local s = speed or TweenSpeed
        local tweenInfo = TweenInfo.new(math.max(0.05, dist / s), Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(char.HumanoidRootPart, tweenInfo, {CFrame = targetCF})
        tween:Play()
        return tween, dist / s
    end)
    if ok then return res else return nil, 0 end
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

-- =================== Server Hopping ===================
function HopServer()
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
    pcall(function()
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(req)
        local servers = {}
        for i,v in pairs(data.data or {}) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then table.insert(servers, v.id) end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], Player)
        else
            task.wait(30)
            SmartServerHop()
        end
    end)
end

if pcall(function() game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100") end) then
    HopServer = SmartServerHop
end

-- =================== Chest Detection & Collection ===================
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
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "PHUCMAX",
            Text = "Chest collection forced stop",
            Duration = 3
        })
    end)
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
            if not getgenv().ChestFarmer.AutoCollectChest then task.wait(1); continue end
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1); continue end

            local chest = GetChest()
            if chest and chest.Parent then
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
                            break
                        end
                    end
                end)
                task.wait(0.15)
            else
                if tick() - getgenv().ChestFarmer.LastChestCollectedTime > 60 then
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
                    if (char.HumanoidRootPart.Position - pos).Magnitude < 1 then pcall(HopServer) end
                    stuckSince = 0
                end
            else
                stuckSince = 0
            end
        end
        lastPos = pos
    end)
end

-- =================== Auto-jump (anti-AFK) ===================
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

-- =================== Anti-kick ===================
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

-- =================== Initialization ===================
if getgenv().ChestFarmer.AutoCollectChest then pcall(AutoChestCollect) end

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

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "PHUCMAX",
        Text = "Thank you for using my script. ",
        Duration = 5
    })
end)