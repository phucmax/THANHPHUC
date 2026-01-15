-- chest4.lua (cleaned) - keep chest collection + utilities, remove Cyborg/CoreBrain/Fist/Microchip/boss logic
-- Purpose: only chest-farming, server-hop, anti-AFK, no-clip, tween movement, UI and FPS boost.
-- Note: I removed all cyborg-specific functions and boss/fight flows. Everything else is preserved or simplified.

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- =================== CONFIG ===================
local UI_BG_IMAGE = "rbxassetid://89799706653949"
local BTN_BG_IMAGE = "rbxassetid://89799706653949"
local TOGGLE_IMAGE = "rbxassetid://89799706653949"
local THEME_COLOR = Color3.fromRGB(140, 0, 255)
local TweenSpeed = 350

-- =================== GLOBAL FLAGS ===================
_G.AutoCollectChest = true
_G.StopTween = false
_G.StopTween2 = false
_G.CancelTween2 = false
_G.AutoRejoin = true
_G.starthop = true
_G.AutoHopEnabled = true
_G.LastPosition = nil
_G.LastTimeChecked = tick()
_G.LastChestCollectedTime = tick()
_G.AutoJump = true
_G.Antikick = true
_G.ChestFarmingRunning = false

-- =================== UI (non-invasive) ===================
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("PHUCMAX_UI_CHEST4") then
        CoreGui.PHUCMAX_UI_CHEST4:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PHUCMAX_UI_CHEST4"
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
    Title.Text = "Chest Farmer - PHUCMAX"
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
            _G.AutoCollectChest = true
            _G.ChestFarmingRunning = false
            if type(AutoChestCollect) == "function" then
                pcall(AutoChestCollect)
            end
        end)
    end)

    StopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            _G.AutoCollectChest = false
            _G.StopTween = true
            _G.StopTween2 = true
        end)
    end)

    ToggleCollectBtn.MouseButton1Click:Connect(function()
        pcall(function()
            _G.AutoCollectChest = not _G.AutoCollectChest
            if _G.AutoCollectChest then
                _G.ChestFarmingRunning = false
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
            if type(ForceStopChestCollection) == "function" then
                pcall(ForceStopChestCollection)
            else
                _G.AutoCollectChest = false
                _G.ChestFarmingRunning = false
            end
        end)
    end)

    RefreshBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local beli = 0
            if game.Players.LocalPlayer:FindFirstChild("Data") and game.Players.LocalPlayer.Data:FindFirstChild("Beli") then
                beli = game.Players.LocalPlayer.Data.Beli.Value
            end
            Info.Text = "Money : "..tostring(beli).."\nTime : 00:00:00\nState : "..(_G.AutoCollectChest and "Farming" or "Stopped")
        end)
    end)

    -- Info updater
    spawn(function()
        local startTime = tick()
        while task.wait(0.5) do
            pcall(function()
                local beli = 0
                if game.Players.LocalPlayer:FindFirstChild("Data") and game.Players.LocalPlayer.Data:FindFirstChild("Beli") then
                    beli = game.Players.LocalPlayer.Data.Beli.Value
                end
                local t = 0
                if _G.AutoCollectChest then t = math.floor(tick() - startTime) end
                local hours = math.floor(t / 3600) % 24
                local mins  = math.floor(t / 60) % 60
                local secs  = t % 60
                local state = _G.AutoCollectChest and "Farming" or "Stopped"
                Info.Text = "Money : "..tostring(beli).."\nTime : "..string.format("%02d:%02d:%02d", hours, mins, secs).."\nState : "..state
            end)
        end
    end)
end)

-- =================== UTILITIES & FPS BOOST ===================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer

local function ApplyFPSBoost()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        if Workspace:FindFirstChildOfClass("Terrain") then
            Workspace.Terrain.WaterWaveSize = 0
            Workspace.Terrain.WaterWaveSpeed = 0
            Workspace.Terrain.WaterReflectance = 0
            Workspace.Terrain.WaterTransparency = 0
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
    while task.wait(60) do
        pcall(ApplyFPSBoost)
    end
end)

-- =================== Movement / Tweening / NoClip ===================
local function EnableNoClipAndAntiGravity()
    pcall(function()
        local char = Player.Character
        if not char then return end
        for _,part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- remove old anti-grav
            for _,child in pairs(hrp:GetChildren()) do
                if child:IsA("BodyVelocity") and child.Name == "ChestFarmAntiGravity" then
                    child:Destroy()
                end
            end
            local bv = Instance.new("BodyVelocity")
            bv.Name = "ChestFarmAntiGravity"
            bv.MaxForce = Vector3.new(0,9999,0)
            bv.Velocity = Vector3.new(0,0.25,0)
            bv.P = 1500
            bv.Parent = hrp
            if char:FindFirstChild("Stun") then
                char.Stun.Value = 0
            end
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
        if _G.StopTween then tween:Cancel() end
        task.wait(distance / speed + 0.08)
    end)
end

function Tween(KG)
    pcall(function()
        if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
        local Distance = (KG.Position - Player.Character.HumanoidRootPart.Position).Magnitude
        local Speed = TweenSpeed
        local tweenInfo = TweenInfo.new(math.max(0.05, Distance / Speed), Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(Player.Character.HumanoidRootPart, tweenInfo, {
            CFrame = KG
        })
        tween:Play()
        if _G.StopTween then tween:Cancel() end
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
    -- Simple server hop using Http API fallback
    local ok, res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?limit=100")
    end)
    if not ok or not res then return end
    local suc, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not suc or type(data) ~= "table" or not data.data then return end
    for _,v in pairs(data.data) do
        if type(v) == "table" and v.id and v.playing < (v.maxPlayers or math.huge) and v.id ~= game.JobId then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, Player)
            end)
            return
        end
    end
end

function SmartServerHop()
    if not _G.AutoHopEnabled then return end
    pcall(function()
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(req)
        local servers = {}
        for i,v in pairs(data.data or {}) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], Player)
        else
            task.wait(30)
            SmartServerHop()
        end
    end)
end

-- Replace HopServer if SmartServerHop available
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
    -- Prefer workspace.Map descendants (original script used Map)
    if workspace:FindFirstChild("Map") then
        for _,v in pairs(workspace.Map:GetDescendants()) do
            if v:IsA("BasePart") and string.find(v.Name:lower(), "chest") then
                if v:FindFirstChild("TouchInterest") then
                    local d = (v.Position - hrp).Magnitude
                    if d < dist then
                        dist = d
                        best = v
                    end
                end
            end
        end
    else
        -- fallback: search entire workspace
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and string.find(v.Name:lower(), "chest") then
                if v:FindFirstChild("TouchInterest") then
                    local d = (v.Position - hrp).Magnitude
                    if d < dist then
                        dist = d
                        best = v
                    end
                end
            end
        end
    end
    return best
end

function ForceStopChestCollection()
    _G.AutoCollectChest = false
    _G.ChestFarmingRunning = false
    _G.StopTween = true
    _G.StopTween2 = true
    _G.CancelTween2 = false
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Chest Farmer",
            Text = "Chest collection forced stop",
            Duration = 3
        })
    end)
end

-- Simple money getter for pickup detection
local function GetMoneyValue()
    local v = 0
    pcall(function()
        if Player and Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Beli") then
            v = tonumber(Player.Data.Beli.Value) or 0
        end
    end)
    return v
end

-- Auto chest collect loop
function AutoChestCollect()
    if _G.ChestFarmingRunning then return end
    _G.ChestFarmingRunning = true
    spawn(function()
        while task.wait(0.1) do
            if not _G.AutoCollectChest then
                task.wait(1)
                continue
            end

            -- ensure character exists
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                task.wait(1)
                continue
            end

            -- find nearest chest
            local chest = GetChest()
            if chest and chest.Parent then
                -- approach chest using Tween2
                local targetCFrame = CFrame.new(chest.Position + Vector3.new(0, 1.2, 0))
                pcall(function() Tween2(targetCFrame) end)

                -- after reaching, do a short wait and lightly bump to ensure touch
                task.wait(0.12)
                pcall(function()
                    local prevMoney = GetMoneyValue()
                    -- try small local nudges if needed
                    for i=1,3 do
                        if not chest or not chest.Parent then break end
                        -- perform tiny teleport/bump to chest
                        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = Player.Character.HumanoidRootPart
                            hrp.CFrame = CFrame.new(chest.Position + Vector3.new(0, 1.2, 0))
                        end
                        task.wait(0.08)
                        local nowMoney = GetMoneyValue()
                        if nowMoney > prevMoney then
                            _G.LastChestCollectedTime = tick()
                            break
                        end
                    end
                end)
                task.wait(0.15)
            else
                -- no chest found nearby
                if tick() - _G.LastChestCollectedTime > 60 then
                    -- hop server if idle long
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
                    -- try simple teleport out first
                    pcall(function()
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                    end)
                    -- if still stuck, hop server
                    task.wait(2)
                    if (char.HumanoidRootPart.Position - pos).Magnitude < 1 then
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

-- =================== Auto-jump (anti-AFK) ===================
function AutoJumpLoop()
    spawn(function()
        local player = Players.LocalPlayer
        while task.wait(math.random(15,20)) do
            pcall(function()
                if _G.AutoJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end)
end
AutoJumpLoop()

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
-- Start collecting automatically if flag set
if _G.AutoCollectChest then
    pcall(AutoChestCollect)
end

-- Continuously check stuck & hop
spawn(function()
    while task.wait(1) do
        if _G.AutoHopEnabled and _G.AutoCollectChest then
            pcall(CheckIfStuckAndHop)
        end
    end
end)

-- Ensure ChestFarmingRunning kept alive
spawn(function()
    while task.wait(10) do
        if _G.AutoCollectChest and not _G.ChestFarmingRunning then
            pcall(AutoChestCollect)
        end
    end
end)

-- Final notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Chest Farmer",
        Text = "Chest-only script loaded. Cyborg/boss logic removed.",
        Duration = 5
    })
end)