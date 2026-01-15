--// PHUCMAX | Farm Chest v1 (Fixed & Improved)
--// Mobile / Executor friendly
--// Updated: 2026-01-15
--// Notes: implements auto-team (Marines), aggressive fix-lag (trees/water/particles/colors),
--// flying with noclip, persistent server-hop avoiding duplicates, UI polish (Vietnamese labels),
--// stops everything when forbidden tools are detected (God's Chalice / Blackbeard key heuristics),
--// and auto-jump every 1 second when running.

repeat task.wait() until game:IsLoaded()

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ================= CONFIG (tweakable) =================
local UI_BG_IMAGE = "rbxassetid://89799706653949" -- background image id (main)
local BTN_BG_IMAGE = "rbxassetid://89799706653949" -- button background id
local TOGGLE_IMAGE = "rbxassetid://89799706653949" -- toggle circular image id
local THEME_COLOR = Color3.fromRGB(140, 0, 255) -- main accent
local SPEED = 350 -- fly forward speed
local FLY_HEIGHT = 6 -- height above chest when flying to it
local FIXLAG_BRIGHTNESS_FACTOR = 0.3 -- reduce brightness to 30% (70% reduction)
local SERVER_FETCH_LIMIT = 100 -- how many servers to fetch per request
local SERVER_HOP_DELAY = 2 -- wait before trying to hop
local FORBIDDEN_TOOL_KEYWORDS = { "chalice", "god", "godschalice", "blackbeard", "black beard", "blackbeards", "key", "bkey", "rauden" } -- heuristics

-- ================= GLOBAL STATE =================
getgenv().PHUCMAX = getgenv().PHUCMAX or {
    Running = false,
    Flying = false,
    StartTime = 0,
    VisitedServers = {}
}

-- ================= CHARACTER =================
local Character, HRP, Humanoid
local function UpdateChar()
    Character = Player.Character or Player.CharacterAdded:Wait()
    HRP = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 5)
    Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid", 5)
end
pcall(UpdateChar)
Player.CharacterAdded:Connect(function()
    task.wait(1)
    pcall(UpdateChar)
end)

-- ================= UI =================
local function MakeScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PHUCMAX_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    -- toggle circular button (left center) draggable
    local Toggle = Instance.new("ImageButton", ScreenGui)
    Toggle.Name = "PHUCMAX_TOGGLE"
    Toggle.Size = UDim2.fromOffset(60,60)
    Toggle.Position = UDim2.new(0,10,0.5,-30)
    Toggle.Image = TOGGLE_IMAGE
    Toggle.BackgroundTransparency = 1
    Toggle.Active = true
    Toggle.Draggable = true
    Toggle.ZIndex = 10

    -- main panel
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "PHUCMAX_MAIN"
    Main.Size = UDim2.fromOffset(420,260)
    Main.Position = UDim2.new(0.5,-210,0.5,-130)
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
    Title.Text = "PHUCMAX"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 32
    Title.TextColor3 = THEME_COLOR
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Position = UDim2.new(0,18,0,6)

    local Sub = Instance.new("TextLabel", Main)
    Sub.Name = "Sub"
    Sub.Position = UDim2.new(0,18,0,45)
    Sub.Size = UDim2.new(1,0,0,22)
    Sub.BackgroundTransparency = 1
    Sub.Text = "farm chest v1"
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 14
    Sub.TextColor3 = Color3.fromRGB(200,200,200)
    Sub.TextXAlignment = Enum.TextXAlignment.Left

    local Info = Instance.new("TextLabel", Main)
    Info.Name = "Info"
    Info.Position = UDim2.new(0,20,0,80)
    Info.Size = UDim2.new(1,-40,0,70)
    Info.BackgroundTransparency = 1
    Info.TextWrapped = true
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.TextYAlignment = Enum.TextYAlignment.Top
    Info.Font = Enum.Font.Gotham
    Info.TextSize = 15
    Info.TextColor3 = Color3.fromRGB(220,220,220)
    Info.Text = "Money : 0\nTime : 00:00:00\nState : Idle"

    -- bottom buttons container
    local BtnContainer = Instance.new("Frame", Main)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Size = UDim2.new(1, -40, 0, 60)
    BtnContainer.Position = UDim2.new(0,20,1,-80)

    local function Button(text, pos)
        local B = Instance.new("ImageButton", BtnContainer)
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
        return B, T
    end

    local StartBtn, StartLbl = Button("BẮT ĐẦU", UDim2.new(0.07,0,0,0)) -- Start
    local StopBtn, StopLbl   = Button("DỪNG",    UDim2.new(0.38,0,0,0)) -- Pause
    local ResetBtn, ResetLbl = Button("RESET",   UDim2.new(0.69,0,0,0)) -- Reset

    -- Toggle behavior: when main is visible hide the small toggle (only show background icon),
    -- when main hidden show the circular toggle button.
    Toggle.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
        Toggle.Visible = not Main.Visible
    end)

    -- If user clicks outside or close, allow toggle again
    Main:GetPropertyChangedSignal("Visible"):Connect(function()
        if Main.Visible then
            Toggle.Visible = false
        else
            Toggle.Visible = true
        end
    end)

    -- button actions wired later via returned table
    return {
        Gui = ScreenGui,
        Toggle = Toggle,
        Main = Main,
        Info = Info,
        StartBtn = StartBtn,
        StopBtn = StopBtn,
        ResetBtn = ResetBtn
    }
end

local UI = MakeScreenGui()

-- ================= INFO UPDATER =================
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
        local state = getgenv().PHUCMAX.Running and (getgenv().PHUCMAX.Flying and "Farming (Flying)" or "Farming") or "Đang dừng"
        UI.Info.Text = "Money : "..tostring(beli).."\nThời gian : "..string.format("%02d:%02d:%02d", hours, mins, secs).."\nTrạng thái : "..state
    end
end)

-- ================= AUTO TEAM =================
local function AutoTeam()
    pcall(function()
        -- keep trying to set team to Marines while main minimal UI present (spawned state)
        if Player.PlayerGui:FindFirstChild("Main (minimal)") then
            repeat
                task.wait(1)
                pcall(function()
                    if game.ReplicatedStorage and game.ReplicatedStorage:FindFirstChild("Remotes") and game.ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam","Marines")
                    else
                        -- fallback: try a generic remote if known
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Marines")
                        end)
                    end
                end)
            until not Player.PlayerGui:FindFirstChild("Main (minimal)") or not getgenv().PHUCMAX.Running
        end
    end)
end

-- ================= FIX LAG =================
local function FixLag()
    pcall(function()
        -- Lighting adjustments
        Lighting.GlobalShadows = false
        Lighting.Brightness = math.max(0.1, (Lighting.Brightness or 1) * FIXLAG_BRIGHTNESS_FACTOR) -- reduce ~70%
        Lighting.FogEnd = 9e9
        -- Terrain / water
        if Workspace:FindFirstChildOfClass("Terrain") then
            Workspace.Terrain.WaterWaveSize = 0
            Workspace.Terrain.WaterWaveSpeed = 0
            Workspace.Terrain.WaterTransparency = 1
        end
        -- iterate workspace and aggressively lower detail
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                -- remove colorful foliage and trees by heuristic on name
                local nameLower = tostring(v.Name):lower()
                if nameLower:find("tree") or nameLower:find("leaf") or nameLower:find("foliage") or nameLower:find("bush") then
                    -- hide rather than destroy (safer)
                    v.Transparency = 1
                    v.CanCollide = false
                else
                    v.Material = Enum.Material.SmoothPlastic
                    v.Color = Color3.fromRGB(120,120,120)
                    v.Reflectance = 0
                    -- reduce texture and detail on meshparts
                    if v:IsA("MeshPart") or v:IsA("UnionOperation") then
                        v.MeshId = ""
                    end
                end
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                -- hide decals to save fps
                v.Transparency = 1
            elseif v:IsA("Model") then
                -- simple heuristic to remove tree models
                local nm = tostring(v.Name):lower()
                if nm:find("tree") or nm:find("leaf") or nm:find("bush") or nm:find("foliage") then
                    for _,p in pairs(v:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.Transparency = 1
                            p.CanCollide = false
                        elseif p:IsA("ParticleEmitter") then
                            p.Enabled = false
                        end
                    end
                end
            end
        end
    end)
end

-- ================= FLY (with noclip & maintain height) =================
local BodyGyro, BodyVel
local function StartFly()
    if getgenv().PHUCMAX.Flying then return end
    if not HRP or not HRP.Parent then
        pcall(UpdateChar)
        if not HRP or not HRP.Parent then return end
    end
    getgenv().PHUCMAX.Flying = true

    -- cleanup previous
    pcall(function() RunService:UnbindFromRenderStep("PHUCMAX_FLY") end)
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVel then BodyVel:Destroy() BodyVel = nil end

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Parent = HRP
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    BodyGyro.D = 1000

    BodyVel = Instance.new("BodyVelocity")
    BodyVel.Parent = HRP
    BodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)

    -- maintain noclip by disabling collisions on character parts
    local function noclipCharacter()
        if Character and Character.Parent then
            for _,p in pairs(Character:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end

    RunService:BindToRenderStep("PHUCMAX_FLY", Enum.RenderPriority.Character.Value, function()
        if not getgenv().PHUCMAX.Running then return end
        pcall(function()
            local cam = workspace.CurrentCamera
            if not cam or not HRP then return end
            -- orient to camera
            if BodyGyro and BodyGyro.Parent then
                BodyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + cam.CFrame.LookVector)
            end
            -- set forward velocity while maintaining height (Y = 0 to keep stable)
            if BodyVel and BodyVel.Parent then
                local forward = cam.CFrame.LookVector * SPEED
                -- keep Y close to zero so BodyVelocity counters gravity and maintains altitude
                BodyVel.Velocity = Vector3.new(forward.X, 0, forward.Z)
            end
            noclipCharacter()
            -- keep Humanoid state in platform stand to reduce fall behavior (if available)
            if Humanoid and Humanoid.Parent then
                pcall(function() Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
            end
        end)
    end)
end

local function StopFly()
    getgenv().PHUCMAX.Flying = false
    pcall(function() RunService:UnbindFromRenderStep("PHUCMAX_FLY") end)
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVel then BodyVel:Destroy() BodyVel = nil end
    -- restore humanoid states
    if Humanoid and Humanoid.Parent then
        pcall(function() Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)
    end
end

-- ================= CHEST DETECTION =================
local function GetChests()
    local t = {}
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and tostring(v.Name):lower():find("chest") then
            table.insert(t,v)
        elseif v:IsA("Model") and tostring(v.Name):lower():find("chest") then
            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if part then table.insert(t, part) end
        end
    end
    return t
end

-- ================= FORBIDDEN TOOL DETECTION =================
local function HasForbiddenTool()
    local function checkContainer(cont)
        if not cont then return false end
        for _,it in pairs(cont:GetChildren()) do
            if it:IsA("Tool") then
                local nm = tostring(it.Name):lower()
                for _,kw in pairs(FORBIDDEN_TOOL_KEYWORDS) do
                    if nm:find(kw) then
                        return true, it.Name
                    end
                end
            end
        end
        return false
    end

    -- check backpack and character
    local found, name = checkContainer(Player:FindFirstChild("Backpack"))
    if found then return true, name end
    found, name = checkContainer(Character)
    if found then return true, name end

    -- also check StarterGear or StarterPack, just in case
    local st = game:GetService("StarterGui") -- not a direct container for tools but leave as fallback
    return false
end

-- ================= SERVER HOP =================
local function Hop()
    local ok, res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?limit="..tostring(SERVER_FETCH_LIMIT))
    end)
    if not ok or not res then return end
    local ok2, servers = pcall(function() return HttpService:JSONDecode(res) end)
    if not ok2 or type(servers) ~= "table" or not servers.data then return end
    for _,v in pairs(servers.data) do
        if type(v) == "table" and v.id and not getgenv().PHUCMAX.VisitedServers[v.id] and (v.playing < (v.maxPlayers or math.huge)) then
            getgenv().PHUCMAX.VisitedServers[v.id] = true
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, Player)
            end)
            break
        end
    end
end

-- ================= MAIN LOGIC =================
-- UI button bindings
UI.StartBtn.MouseButton1Click:Connect(function()
    if not getgenv().PHUCMAX.Running then
        getgenv().PHUCMAX.Running = true
        getgenv().PHUCMAX.StartTime = tick()
    end
end)

UI.StopBtn.MouseButton1Click:Connect(function()
    getgenv().PHUCMAX.Running = false
    StopFly()
end)

UI.ResetBtn.MouseButton1Click:Connect(function()
    getgenv().PHUCMAX.Running = false
    getgenv().PHUCMAX.StartTime = tick()
    getgenv().PHUCMAX.VisitedServers = {}
    UI.Info.Text = "Money : 0\nThời gian : 00:00:00\nTrạng thái : Reset"
end)

-- Safety: stop all if forbidden tool detected
local function StopAllDueToTool(foundName)
    getgenv().PHUCMAX.Running = false
    StopFly()
    UI.Info.Text = "Đã phát hiện ["..tostring(foundName).."]. Dừng tất cả chức năng."
    -- optionally notify via chat
    pcall(function()
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[PHUCMAX] Đã tìm thấy "..tostring(foundName)..". Script đã dừng.";
            Color = Color3.fromRGB(255,100,100);
        })
    end)
end

-- movement helper to move to a chest safely (uses flying)
local function MoveToChestPart(chestPart)
    if not chestPart or not HRP then return end
    -- set target CFrame above chest
    local target = chestPart.CFrame + Vector3.new(0, FLY_HEIGHT, 0)
    -- teleport HRP gently towards it; using CFrame assignment short wait works in many executors
    pcall(function() HRP.CFrame = target end)
    task.wait(0.2)
end

-- try to "pickup" chest by touching it (move into it)
local function TryPickupChest(chestPart)
    if not chestPart or not HRP then return end
    MoveToChestPart(chestPart)
    -- move slightly lower to ensure touching
    pcall(function() HRP.CFrame = chestPart.CFrame + Vector3.new(0, 2, 0) end)
    task.wait(0.5)
    -- restore hover height
    pcall(function() HRP.CFrame = chestPart.CFrame + Vector3.new(0, FLY_HEIGHT, 0) end)
end

-- ================= AUTO-JUMP =================
-- Jump once every 1 second while script is running
task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().PHUCMAX.Running then
            pcall(function()
                if not Humanoid or not Humanoid.Parent then
                    pcall(UpdateChar)
                end
                if Humanoid and Humanoid.Parent then
                    Humanoid.Jump = true
                end
            end)
        end
    end
end)

-- main loop: runs in background
task.spawn(function()
    while task.wait(1) do
        -- if user stopped or script paused, ensure fly stopped and continue
        if not getgenv().PHUCMAX.Running then
            StopFly()
            continue
        end

        -- check forbidden tools each iteration
        local has, nm = HasForbiddenTool()
        if has then
            StopAllDueToTool(nm or "Unknown")
            break -- break main loop (stop entirely)
        end

        -- update char, ensure HRP exists
        pcall(UpdateChar)
        -- auto team to Marines if possible
        pcall(AutoTeam)
        -- fix lag
        pcall(FixLag)
        -- start flying
        pcall(StartFly)

        -- find chests
        local chests = GetChests()
        if #chests > 0 then
            -- iterate through chests and pick them
            for _,c in pairs(chests) do
                if not getgenv().PHUCMAX.Running then break end
                -- ensure character and chest valid
                pcall(UpdateChar)
                if HRP and c and c:IsA("BasePart") then
                    -- move close and noclip maintained by Fly loop
                    MoveToChestPart(c)
                    task.wait(0.25)
                    -- attempt to pick up
                    TryPickupChest(c)
                    -- wait a little for server to register pickup
                    task.wait(0.8)
                end
            end
        else
            -- no chests found: stop flying, wait a bit then hop server
            StopFly()
            task.wait(SERVER_HOP_DELAY)
            pcall(Hop)
        end
    end
end)