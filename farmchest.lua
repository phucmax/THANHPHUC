--// PHUCMAX | Farm Chest v1 (Adjusted per user request)
--// Mobile / Executor friendly
--// Updated: 2026-01-15 (patched: auto-start, non-tele pickup, persistent toggle, safer movement)
--// Further update: 2026-01-15 (smooth direct-approach pickup)
--// Changes in this copy:
--//  - Direct, same-height approach into chests (no hover/descend/ascend)
--//  - No slowing while approaching (avoids mid-flight stutter)
--//  - Fast chest detection + immediate money-check to confirm pickup
--//  - Removed aggressive noclip to avoid getting stuck; only non-invasive fixes kept
--//  - If pickup not detected, a short high-speed bump is attempted
--//  - UI/buttons preserved. Script still auto-starts by default.

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
local SPEED = 350 -- fly-forward speed when moving to a chest (user requested)
local APPROACH_HEIGHT_OFFSET = 1 -- how high above the chest's position we aim (keeps Y aligned with chest)
local FIXLAG_BRIGHTNESS_FACTOR = 0.3 -- reduce brightness to 30% (70% reduction)
local SERVER_FETCH_LIMIT = 100 -- how many servers to fetch per request
local SERVER_HOP_DELAY = 2 -- wait before trying to hop
local FORBIDDEN_TOOL_KEYWORDS = { "chalice", "god", "godschalice", "blackbeard", "black beard", "blackbeards", "key", "bkey", "rauden" } -- heuristics

-- ================= GLOBAL STATE =================
getgenv().PHUCMAX = getgenv().PHUCMAX or {
    Running = false,
    Flying = false, -- retained flag but we do NOT enable persistent fly by default
    StartTime = 0,
    VisitedServers = {},
    OverrideVelocity = nil,
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

-- lightweight noclip helper removed to avoid getting stuck; we'll avoid toggling CanCollide globally
-- local function noclipCharacter()
--     if Character and Character.Parent then
--         for _,p in pairs(Character:GetDescendants()) do
--             if p:IsA("BasePart") then
--                 p.CanCollide = false
--             end
--         end
--     end
-- end

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
        local state = getgenv().PHUCMAX.Running and "Farming (direct approach)" or "Đang dừng"
        UI.Info.Text = "Money : "..tostring(beli).."\nThời gian : "..string.format("%02d:%02d:%02d", hours, mins, secs).."\nTrạng thái : "..state
    end
end)

-- ================= AUTO TEAM =================
-- NOTE: per user request, we will NOT auto-select team (Marines). AutoTeam logic is left but not invoked.
local function AutoTeam()
    -- no-op (disabled): kept for reference but intentionally not used
    return
end

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
    -- Do not stop the script automatically. Just warn the user and update UI.
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

-- ================= MOVEMENT & PICKUP: direct same-height approach =================
-- This function approaches the chest at roughly the chest's height (APPROACH_HEIGHT_OFFSET),
-- does NOT slow down while approaching, and checks the player's money value continuously.
-- When money increases during the approach, the function treats the chest as picked and returns true.
-- If approach completes without pickup, it will attempt a short high-speed bump into the chest to try registering touch.
local function MoveAndPickupChest(chestPart)
    if not chestPart or not HRP or not HRP.Parent then return false end
    pcall(UpdateChar)
    if not HRP or not HRP.Parent then return false end

    -- Remember starting money
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

    -- Target is aligned with chest height (so we fly straight into it)
    local target = chestPart.Position + Vector3.new(0, APPROACH_HEIGHT_OFFSET, 0)
    local start = tick()
    local timeout = 3.5 -- allow more time for approach
    local picked = false

    -- Continuous approach: DO NOT reduce speed (use full SPEED) and check money often
    while tick() - start < timeout and getgenv().PHUCMAX.Running and HRP and (HRP.Position - target).Magnitude > 2.5 do
        local dir = (target - HRP.Position)
        if dir.Magnitude <= 0.2 then break end
        local vel = dir.Unit * SPEED
        tempBV.Velocity = Vector3.new(vel.X, vel.Y, vel.Z)
        pcall(function()
            tempBG.CFrame = CFrame.new(HRP.Position, HRP.Position + dir.Unit)
        end)

        -- fast money check: if changed, chest considered picked
        local nowMoney = GetMoneyValue()
        if nowMoney > startMoney then
            picked = true
            break
        end

        -- If velocity stalls (possible collision), try a tiny jump to dislodge
        if HRP.AssemblyLinearVelocity.Magnitude < 2 and (HRP.Position - target).Magnitude > 6 then
            pcall(function()
                if Humanoid and Humanoid.Parent then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end

        task.wait(0.03)
    end

    -- If not detected yet, attempt a short high-speed bump (0.18s) directly into the chest
    if not picked and getgenv().PHUCMAX.Running and HRP and (HRP.Position - target).Magnitude > 1.2 then
        local bumpDir = (chestPart.Position - HRP.Position).Unit
        local bumpTime = 0.18
        local bumpStart = tick()
        while tick() - bumpStart < bumpTime and getgenv().PHUCMAX.Running do
            tempBV.Velocity = bumpDir * SPEED * 1.0 -- full force bump
            local nowMoney = GetMoneyValue()
            if nowMoney > startMoney then
                picked = true
                break
            end
            task.wait(0.03)
        end
    end

    -- Gentle stop and cleanup
    pcall(function()
        tempBV.Velocity = Vector3.new(0,0,0)
        tempBV:Destroy()
        tempBG:Destroy()
    end)

    -- Small settle wait to allow server to register pickup; but short to keep responsiveness
    if picked then
        task.wait(0.08)
    else
        task.wait(0.12)
        -- final money check
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
    end
end)

UI.StopBtn.MouseButton1Click:Connect(function()
    getgenv().PHUCMAX.Running = false
end)

UI.ResetBtn.MouseButton1Click:Connect(function()
    getgenv().PHUCMAX.Running = false
    getgenv().PHUCMAX.StartTime = tick()
    getgenv().PHUCMAX.VisitedServers = {}
    UI.Info.Text = "Money : 0\nThời gian : 00:00:00\nTrạng thái : Reset"
end)

-- ================= MAIN LOOP =================
task.spawn(function()
    -- Auto-start as before (optional): script will auto-run but movement is per-target (no persistent fly)
    if not getgenv().PHUCMAX.Running then
        getgenv().PHUCMAX.Running = true
        getgenv().PHUCMAX.StartTime = tick()
    end

    while task.wait(0.8) do -- slight delay between scans (fast enough for "siêu nhanh" chest checks)
        if not getgenv().PHUCMAX.Running then
            task.wait(0.5)
            continue
        end

        -- check forbidden tools: WARN but do NOT stop automatically per user request
        local has, nm = HasForbiddenTool()
        if has then
            pcall(WarnForbiddenTool, nm or "Unknown")
            -- do NOT break or stop the script
        end

        -- update char, ensure HRP exists
        pcall(UpdateChar)
        -- AutoTeam intentionally NOT invoked (per user request)

        -- reduce lag where possible
        pcall(FixLag)

        -- find chests
        local chests = GetChests()
        if #chests > 0 then
            -- iterate through chests and pick them using direct approach
            for _,c in pairs(chests) do
                if not getgenv().PHUCMAX.Running then break end
                pcall(UpdateChar)
                if HRP and c and c:IsA("BasePart") then
                    local picked = false
                    -- Try direct approach & pickup
                    picked = pcall(MoveAndPi
