--// PHUCMAX | Farm Chest v1 (Island-clustered + near-teleport snap)
--// Updated: 2026-01-15 (patched: island clustering, snap-teleport when near, fix pickup/tele behavior)
--// Behavior summary:
--//  - Determine island by clustering chests and pick the largest cluster as "current island"
--//  - Fly between chests; when within TELEPORT_NEAR_DISTANCE (default 5) the script will teleport directly above chest to guarantee pickup
--//  - Do NOT teleport just because chest is far (avoids unnecessary teleports)
--//  - When island chests exhausted -> server hop
--//  - Preserves money-delta pickup detection and safer movement

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
local SPEED = 350 -- fly-forward speed when moving to a chest
local APPROACH_HEIGHT_OFFSET = 1 -- how high above the chest's position we aim
local FIXLAG_BRIGHTNESS_FACTOR = 0.3 -- reduce brightness to 30% (70% reduction)
local SERVER_FETCH_LIMIT = 100 -- how many servers to fetch per request
local SERVER_HOP_DELAY = 2 -- wait before trying to hop
local FORBIDDEN_TOOL_KEYWORDS = { "chalice", "god", "godschalice", "blackbeard", "black beard", "blackbeards", "key", "bkey", "rauden" } -- heuristics

-- NEW: island farming and teleport thresholds
local ISLAND_RADIUS = 250 -- studs radius to define island membership
local TELEPORT_NEAR_DISTANCE = 5 -- when closer than this, snap-teleport into chest to guarantee pickup

-- ================= GLOBAL STATE =================
getgenv().PHUCMAX = getgenv().PHUCMAX or {
    Running = false,
    Flying = false,
    StartTime = 0,
    VisitedServers = {},
    OverrideVelocity = nil,
    CurrentIslandCenter = nil,
    IslandChests = {}, -- list of chests (parts) considered part of current island
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

    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.fromOffset(28,28)
    CloseBtn.Position = UDim2.new(1,-36,0,6)
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 18
    CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CloseBtn.BackgroundTransparency = 0.7
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,10)

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

    local StartBtn, StartLbl = Button("BẮT ĐẦU", UDim2.new(0.07,0,0,0)) -- Start (backup)
    local StopBtn, StopLbl   = Button("DỪNG",    UDim2.new(0.38,0,0,0)) -- Pause
    local ResetBtn, ResetLbl = Button("RESET",   UDim2.new(0.69,0,0,0)) -- Reset

    Toggle.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
        Toggle.Visible = true
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
    end)

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
        local state = getgenv().PHUCMAX.Running and "Farming (island-clustered)" or "Đang dừng"
        UI.Info.Text = "Money : "..tostring(beli).."\nThời gian : "..string.format("%02d:%02d:%02d", hours, mins, secs).."\nTrạng thái : "..state
    end
end)

-- ================= FIX LAG =================
local function FixLag()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.Brightness = math.max(0.1, (Lighting.Brightness or 1) * FIXLAG_BRIGHTNESS_FACTOR)
        Lighting.FogEnd = 9e9
        if Workspace:FindFirstChildOfClass("Terrain") then
            Workspace.Terrain.WaterWaveSize = 0
            Workspace.Terrain.WaterWaveSpeed = 0
            Workspace.Terrain.WaterTransparency = 1
        end
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local nameLower = tostring(v.Name):lower()
                if nameLower:find("tree") or nameLower:find("leaf") or nameLower:find("foliage") or nameLower:find("bush") then
                    v.Transparency = 1
                    v.CanCollide = false
                else
                    v.Material = Enum.Material.SmoothPlastic
                    v.Color = Color3.fromRGB(120,120,120)
                    v.Reflectance = 0
                    if v:IsA("MeshPart") or v:IsA("UnionOperation") then
                        pcall(function() v.MeshId = "" end)
                    end
                end
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("Model") then
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

-- Filter chests to those within ISLAND_RADIUS of the given center
local function FilterChestsByIsland(chests, center)
    local out = {}
    if not center then return out end
    for _,c in ipairs(chests) do
        if c and c:IsA("BasePart") and c.Position then
            if (c.Position - center).Magnitude <= ISLAND_RADIUS then
                table.insert(out, c)
            end
        end
    end
    return out
end

local function RemoveChestFromList(list, chest)
    for i = #list,1,-1 do
        if not list[i] or list[i] == chest then
            table.remove(list, i)
        end
    end
end

-- Determine island center by clustering chests and returning largest cluster center + members
local function DetermineIslandCenter(chests)
    if not chests or #chests == 0 then return nil, {} end
    local clusters = {}
    for _,c in ipairs(chests) do
        if c and c.Position then
            local placed = false
            for _,cl in ipairs(clusters) do
                if (c.Position - cl.center).Magnitude <= ISLAND_RADIUS then
                    table.insert(cl.members, c)
                    -- recompute center
                    local sum = Vector3.new(0,0,0)
                    for _,m in ipairs(cl.members) do sum = sum + m.Position end
                    cl.center = sum / #cl.members
                    placed = true
                    break
                end
            end
            if not placed then
                table.insert(clusters, { center = c.Position, members = { c } })
            end
        end
    end
    if #clusters == 0 then return nil, {} end
    local best = clusters[1]
    for _,cl in ipairs(clusters) do
        if #cl.members > #best.members then best = cl end
    end
    return best.center, best.members
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

    local found, name = checkContainer(Player:FindFirstChild("Backpack"))
    if found then return true, name end
    found, name = checkContainer(Character)
    if found then return true, name end
    return false
end

local function WarnForbiddenTool(foundName)
    UI.Info.Text = "Cảnh báo : Đã phát hiện ["..tostring(foundName).."]. Script sẽ tiếp tục."
    pcall(function()
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[PHUCMAX] Cảnh báo: Đã tìm thấy "..tostring(foundName)..". Script sẽ tiếp tục.";
            Color = Color3.fromRGB(255,180,50);
        })
    end)
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

-- ================= UTILITIES =================
local function GetMoneyValue()
    local val = 0
    pcall(function()
        if Player and Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Beli") then
            val = tonumber(Player.Data.Beli.Value) or 0
        end
    end)
    return val
end

-- Teleport safely to chest (near its position). Returns true if operation executed.
local function TeleportToChest(chestPart)
    if not chestPart or not HRP or not HRP.Parent then return false end
    pcall(UpdateChar)
    if not HRP or not HRP.Parent then return false end
    local ok = pcall(function()
        HRP.CFrame = CFrame.new(chestPart.Position + Vector3.new(0, APPROACH_HEIGHT_OFFSET + 0.4, 0))
        task.wait(0.06)
    end)
    return ok
end

-- ================= MOVEMENT & PICKUP: direct same-height approach with snap-tele support =================
local function MoveAndPickupChest(chestPart)
    if not chestPart or not HRP or not HRP.Parent then return false end
    pcall(UpdateChar)
    if not HRP or not HRP.Parent then return false end

    local startMoney = GetMoneyValue()

    local tempBG = Instance.new("BodyGyro")
    tempBG.Parent = HRP
    tempBG.P = 9e4
    tempBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    tempBG.D = 1000

    local tempBV = Instance.new("BodyVelocity")
    tempBV.Parent = HRP
    tempBV.MaxForce = Vector3.new(9e9,9e9,9e9)
    tempBV.Velocity = Vector3.new(0,0,0)

    local target = chestPart.Position + Vector3.new(0, APPROACH_HEIGHT_OFFSET, 0)
    local start = tick()
    local timeout = 4.0
    local picked = false

    while tick() - start < timeout and getgenv().PHUCMAX.Running and HRP and (HRP.Position - target).Magnitude > 1.5 do
        local dir = (target - HRP.Position)
        if dir.Magnitude <= 0.15 then break end
        local vel = dir.Unit * SPEED
        tempBV.Velocity = Vector3.new(vel.X, vel.Y, vel.Z)
        pcall(function()
            tempBG.CFrame = CFrame.new(HRP.Position, HRP.Position + dir.Unit)
        end)

        -- If we get very near, snap-tele into chest to guarantee pickup
        local distToChest = (chestPart.Position - HRP.Position).Magnitude
        if distToChest <= TELEPORT_NEAR_DISTANCE then
            pcall(function()
                tempBV.Velocity = Vector3.new(0,0,0)
                TeleportToChest(chestPart)
            end)
            task.wait(0.06)
        end

        -- fast money check: if changed, chest considered picked
        local nowMoney = GetMoneyValue()
        if nowMoney > startMoney then
            picked = true
            break
        end

        -- small anti-stall: if stuck, try jump
        if HRP.AssemblyLinearVelocity.Magnitude < 2 and (HRP.Position - target).Magnitude > 6 then
            pcall(function()
                if Humanoid and Humanoid.Parent then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end

        task.wait(0.03)
    end

    -- Bump attempt if not picked yet
    if not picked and getgenv().PHUCMAX.Running and HRP and (HRP.Position - target).Magnitude > 1.2 then
        local bumpDir = (chestPart.Position - HRP.Position).Unit
        local bumpTime = 0.18
        local bumpStart = tick()
        while tick() - bumpStart < bumpTime and getgenv().PHUCMAX.Running do
            tempBV.Velocity = bumpDir * SPEED * 1.0
            local nowMoney = GetMoneyValue()
            if nowMoney > startMoney then
                picked = true
                break
            end
            task.wait(0.03)
        end
    end

    -- cleanup
    pcall(function()
        tempBV.Velocity = Vector3.new(0,0,0)
        tempBV:Destroy()
        tempBG:Destroy()
    end)

    if picked then
        task.wait(0.08)
    else
        task.wait(0.12)
        local nowMoney = GetMoneyValue()
        if nowMoney > startMoney then picked = true end
    end

    return picked
end

-- ================= AUTO-JUMP =================
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

-- ================= UI BUTTONS =================
UI.StartBtn.MouseButton1Click:Connect(function()
    if not getgenv().PHUCMAX.Running then
        getgenv().PHUCMAX.Running = true
        getgenv().PHUCMAX.StartTime = tick()
        getgenv().PHUCMAX.CurrentIslandCenter = nil
        getgenv().PHUCMAX.IslandChests = {}
    end
end)

UI.StopBtn.MouseButton1Click:Connect(function()
    getgenv().PHUCMAX.Running = false
end)

UI.ResetBtn.MouseButton1Click:Connect(function()
    getgenv().PHUCMAX.Running = false
    getgenv().PHUCMAX.StartTime = tick()
    getgenv().PHUCMAX.VisitedServers = {}
    getgenv().PHUCMAX.CurrentIslandCenter = nil
    getgenv().PHUCMAX.IslandChests = {}
    UI.Info.Text = "Money : 0\nThời gian : 00:00:00\nTrạng thái : Reset"
end)

-- ================= MAIN LOOP =================
task.spawn(function()
    -- Auto-start
    if not getgenv().PHUCMAX.Running then
        getgenv().PHUCMAX.Running = true
        getgenv().PHUCMAX.StartTime = tick()
    end

    while task.wait(0.8) do
        if not getgenv().PHUCMAX.Running then
            task.wait(0.5)
            continue
        end

        -- warn if forbidden tool present
        local has, nm = HasForbiddenTool()
        if has then
            pcall(WarnForbiddenTool, nm or "Unknown")
        end

        pcall(UpdateChar)
        pcall(FixLag)

        local allChests = GetChests()

        -- If we don't have a current island center, determine it from chest clusters (largest cluster)
        if not getgenv().PHUCMAX.CurrentIslandCenter then
            local center, members = DetermineIslandCenter(allChests)
            if center and #members > 0 then
                getgenv().PHUCMAX.CurrentIslandCenter = center
                -- store unique parts (members may contain duplicates if same part referenced)
                getgenv().PHUCMAX.IslandChests = {}
                for _,m in ipairs(members) do
                    local exists = false
                    for _,x in ipairs(getgenv().PHUCMAX.IslandChests) do
                        if x == m then exists = true; break end
                    end
                    if not exists then table.insert(getgenv().PHUCMAX.IslandChests, m) end
                end
            else
                -- no chests found at all -> hop
                pcall(function() Hop() end)
                task.wait(SERVER_HOP_DELAY)
                getgenv().PHUCMAX.Running = false
                break
            end
        else
            -- refresh island chest list (add newly spawned chests on same island, remove invalid ones)
            local islandCandidates = FilterChestsByIsland(allChests, getgenv().PHUCMAX.CurrentIslandCenter)
            for _,c in ipairs(islandCandidates) do
                local exists = false
                for _,x in ipairs(getgenv().PHUCMAX.IslandChests) do
                    if x == c then exists = true; break end
                end
                if not exists then table.insert(getgenv().PHUCMAX.IslandChests, c) end
            end
            -- remove gone chests
            for i = #getgenv().PHUCMAX.IslandChests,1,-1 do
                local v = getgenv().PHUCMAX.IslandChests[i]
                if not v or not v.Parent then
                    table.remove(getgenv().PHUCMAX.IslandChests, i)
                end
            end
        end

        -- If island empty -> hop server
        if not getgenv().PHUCMAX.IslandChests or #getgenv().PHUCMAX.IslandChests == 0 then
            pcall(function()
                Hop()
            end)
            task.wait(SERVER_HOP_DELAY)
            getgenv().PHUCMAX.Running = false
            break
        end

        -- iterate chests
        for i = 1, #getgenv().PHUCMAX.IslandChests do
            if not getgenv().PHUCMAX.Running then break end
            local c = getgenv().PHUCMAX.IslandChests[i]
            if not c or not c.Parent then
                RemoveChestFromList(getgenv().PHUCMAX.IslandChests, c)
                continue
            end

            pcall(UpdateChar)
            if not HRP or not HRP.Parent then break end

            local picked = false
            local ok, err = pcall(function()
                -- compute distance
                local dist = 9e9
                pcall(function() dist = (HRP.Position - c.Position).Magnitude end)

                -- If we are already very near, snap-tele into chest to guarantee pickup
                if dist <= TELEPORT_NEAR_DISTANCE then
                    TeleportToChest(c)
                    task.wait(0.06)
                    -- try pickup detection after snap
                    if GetMoneyValue() > 0 then
                        -- continue to MoveAndPickupChest to be safe (it will see delta)
                    end
                end

                -- Attempt MoveAndPickupChest (MoveAndPickupChest itself will snap-tele if we approach within TELEPORT_NEAR_DISTANCE)
                picked = MoveAndPickupChest(c)
            end)
            if not ok then picked = false end

            if picked then
                RemoveChestFromList(getgenv().PHUCMAX.IslandChests, c)
                task.wait(0.12)
            else
                if not c.Parent then
                    RemoveChestFromList(getgenv().PHUCMAX.IslandChests, c)
                else
                    task.wait(0.06)
                end
            end

            task.wait(0.05)
        end
    end
end)