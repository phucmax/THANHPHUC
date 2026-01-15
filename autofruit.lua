-- farmfruit_chest.lua
-- NightX Fruit Finder integrated with PHUCMAX chest-style UI (from provided farmchest.lua)
-- Features:
--  - Chest-style UI (toggle, start/stop, hop, refresh info)
--  - Fly pickup for fruits (speed 350)
--  - ESP for fruits (name + distance)
--  - Noclip
--  - Server hop (SmartServerHop)
--  - Auto Store (auto store fruits from character/backpack)
--  - Webhook notifications (module ReplicatedStorage.NightXWebhook or paste URL in UI)
--  - Display name set to PHUCMAX
-- NOTE: Designed to run in exploit environment (readfile/writefile/http/post) where available.

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- ========== CONFIG ==========
local UI_BG_IMAGE = "rbxassetid://89799706653949"
local BTN_BG_IMAGE = "rbxassetid://138094680927347"
local TOGGLE_IMAGE = "rbxassetid://138311826892324"
local THEME_COLOR = Color3.fromRGB(140, 0, 255)

getgenv().DisplayName = "PHUCMAX"
getgenv().team = "Pirates"
getgenv().AutoCollect = false        -- auto collect fruits (fly)
getgenv().AutoStore = true          -- auto store fruits found in char/backpack
getgenv().FlySpeed = 350
getgenv().PickupDistance = 6
getgenv().ESPEnabled = true
getgenv().NoclipEnabled = false
getgenv().ServerHopEnabled = false
getgenv().WebhookURL = ""           -- can set in UI or place NightXWebhook ModuleScript in ReplicatedStorage

-- ========= SERVICES & LOCALS =========
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Try require webhook module if present
local WebhookModule = nil
pcall(function()
    if ReplicatedStorage:FindFirstChild("NightXWebhook") then
        WebhookModule = require(ReplicatedStorage:WaitForChild("NightXWebhook"))
    end
end)

-- ========= UTILITIES =========
local function isFruit(inst)
    if not inst then return false end
    if inst:IsA("Tool") and inst.Name:find("Fruit") then return true end
    if inst:IsA("Model") and inst.Name:find("Fruit") then return true end
    return false
end

local function findFruitToolInCharOrBP()
    local char = player.Character
    if char then
        local t = char:FindFirstChildOfClass("Tool")
        if t and t.Name:find("Fruit") then return t end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, it in ipairs(bp:GetChildren()) do
            if it:IsA("Tool") and it.Name:find("Fruit") then return it end
        end
    end
    return nil
end

local function sendWebhook(payload)
    pcall(function()
        payload.player = getgenv().DisplayName or payload.player or player.Name
        if WebhookModule and type(WebhookModule.Send) == "function" then
            WebhookModule.Send(payload)
            return
        end
        local url = getgenv().WebhookURL or ""
        if url == nil or url == "" then return end
        local embed = {
            title = "Fruit Collected",
            description = string.format("Player `%s` collected a fruit: **%s**", tostring(payload.player or "Unknown"), tostring(payload.fruitName or "Unknown")),
            color = 65280,
            fields = {
                { name = "PlaceId", value = tostring(payload.placeId or ""), inline = true },
                { name = "Time (UTC)", value = os.date("!%Y-%m-%d %H:%M:%S", os.time()), inline = true }
            }
        }
        local body = { username = "NightX Bot", embeds = { embed } }
        HttpService:PostAsync(url, HttpService:JSONEncode(body), Enum.HttpContentType.ApplicationJson)
    end)
end

-- ========= ESP =========
local ESPs = {}
local function createESPForFruit(fruit)
    if not getgenv().ESPEnabled then return end
    if not fruit or not fruit.Parent then return end
    if ESPs[fruit] then return ESPs[fruit] end
    local handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
    if not handle then return end
    local bill = Instance.new("BillboardGui")
    bill.Name = "NightX_FruitESP"
    bill.Adornee = handle
    bill.Size = UDim2.new(0,220,0,50)
    bill.StudsOffset = Vector3.new(0, 2 + (handle.Size.Y/2), 0)
    bill.AlwaysOnTop = true
    bill.Parent = handle
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255,255,230)
    txt.TextStrokeTransparency = 0.6
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.Text = tostring(fruit.Name)
    txt.Parent = bill
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not fruit or not fruit.Parent or not handle.Parent then
            if conn then conn:Disconnect() end
            if bill then pcall(function() bill:Destroy() end) end
            ESPs[fruit] = nil
            return
        end
        local dist = 0
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            dist = (player.Character.HumanoidRootPart.Position - handle.Position).Magnitude
        end
        txt.Text = string.format("%s | %.1f m", tostring(fruit.Name), dist)
    end)
    ESPs[fruit] = { gui = bill, conn = conn }
    return ESPs[fruit]
end

workspace.DescendantRemoving:Connect(function(obj)
    if ESPs[obj] then
        if ESPs[obj].conn then pcall(function() ESPs[obj].conn:Disconnect() end) end
        if ESPs[obj].gui then pcall(function() ESPs[obj].gui:Destroy() end) end
        ESPs[obj] = nil
    end
end)

-- ========= Noclip =========
local noclipConn
local function startNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        local char = player.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end
local function stopNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
end

-- ========= Fly to position (BodyVelocity) =========
local function flyToPosition(targetPos, maxTime)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = char.HumanoidRootPart
    local bv = Instance.new("BodyVelocity")
    bv.Name = "NightX_FlyBV"
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = hrp
    local start = tick()
    while hrp and hrp.Parent and (tick() - start) < (maxTime or 12) do
        if (hrp.Position - targetPos).Magnitude <= getgenv().PickupDistance then break end
        local dir = (targetPos - hrp.Position)
        if dir.Magnitude > 0.1 then
            bv.Velocity = dir.Unit * getgenv().FlySpeed
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
        task.wait(0.03)
    end
    if bv and bv.Parent then pcall(function() bv:Destroy() end) end
    return true
end

-- ========= Attempt store tool =========
local function attemptStoreTool(tool)
    if not tool then return false end
    local ok = false
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            local originalName = tool:GetAttribute("OriginalName") or tool.Name
            remotes.CommF_:InvokeServer("StoreFruit", originalName, tool)
            ok = true
        end
    end)
    -- notify
    pcall(function()
        sendWebhook({ player = getgenv().DisplayName, fruitName = tool.Name or tostring(tool), placeId = tostring(game.PlaceId), time = os.date("!*t") })
    end)
    -- UI hook
    pcall(function()
        if getgenv().NightX_OnCollected and tool and tool.Name then
            pcall(getgenv().NightX_OnCollected, tool.Name)
        end
    end)
    return ok
end

-- ========= AutoStore loop =========
task.spawn(function()
    while true do
        if getgenv().AutoStore then
            pcall(function()
                -- character
                if player.Character then
                    for _, it in ipairs(player.Character:GetChildren()) do
                        if it:IsA("Tool") and it.Name:find("Fruit") then
                            attemptStoreTool(it)
                            task.wait(0.2)
                        end
                    end
                end
                -- backpack
                local bp = player:FindFirstChild("Backpack")
                if bp then
                    for _, it in ipairs(bp:GetChildren()) do
                        if it:IsA("Tool") and it.Name:find("Fruit") then
                            attemptStoreTool(it)
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
        task.wait(0.8)
    end
end)

-- ========= Collector (scan workspace and collect fruits) =========
local collecting = false
local function collectNearbyFruits()
    if collecting then return end
    collecting = true
    pcall(function()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if not getgenv().AutoCollect then break end
            if (obj:IsA("Tool") or obj:IsA("Model")) and obj.Name:find("Fruit") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle and handle.Position then
                    createESPForFruit(obj)
                    local targetPos = handle.Position + Vector3.new(0, (handle.Size.Y/2) + 1.5, 0)
                    flyToPosition(targetPos, 12)
                    task.wait(0.12)
                    local foundTool = findFruitToolInCharOrBP()
                    if foundTool then
                        attemptStoreTool(foundTool)
                        task.wait(0.6)
                    else
                        task.wait(0.6)
                        foundTool = findFruitToolInCharOrBP()
                        if foundTool then
                            attemptStoreTool(foundTool)
                            task.wait(0.6)
                        end
                    end
                    task.wait(0.3)
                end
            end
        end
    end)
    collecting = false
end

workspace.DescendantAdded:Connect(function(desc)
    if not getgenv().AutoCollect then return end
    if (desc:IsA("Tool") or desc:IsA("Model")) and desc.Name:find("Fruit") then
        task.wait(0.05)
        pcall(collectNearbyFruits)
    end
end)

task.spawn(function()
    while true do
        if getgenv().AutoCollect then
            pcall(collectNearbyFruits)
        end
        task.wait(1)
    end
end)

-- ========= Server Hop (SmartServerHop) =========
local function SmartServerHop()
    if not getgenv().ServerHopEnabled then return end
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
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], player)
        end
    end)
end

local function HopServer()
    -- fallback hop (attempt to find server)
    pcall(function()
        local res = game:HttpGet("https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?limit=100")
        local suc, data = pcall(function() return HttpService:JSONDecode(res) end)
        if suc and type(data) == "table" and data.data then
            for _,v in pairs(data.data) do
                if type(v) == "table" and v.id and v.playing < (v.maxPlayers or math.huge) and v.id ~= game.JobId then
                    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, player) end)
                    return
                end
            end
        end
    end)
end

-- prefer SmartServerHop if available
pcall(function()
    local ok = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    if ok then HopServer = SmartServerHop end
end)

-- ========= UI (chest-style from provided script) =========
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
    Main.Size = UDim2.fromOffset(420,340) -- increased height to fit extra button
    Main.Position = UDim2.new(0.5,-210,0.5,-170)
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
    Title.Text = "PHUCMAX - FARM - FRUIT"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 20
    Title.TextColor3 = THEME_COLOR
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Position = UDim2.new(0,18,0,6)

    local Info = Instance.new("TextLabel", Main)
    Info.Name = "Info"
    Info.Position = UDim2.new(0,20,0,60)
    Info.Size = UDim2.new(1,-40,0,90)
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
    BtnContainer.Size = UDim2.new(1, -40, 0, 160)
    BtnContainer.Position = UDim2.new(0,20,1,-170)

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
    local ToggleStoreBtn, _ = Button("Auto Store: ON", UDim2.new(0,0,0,100))

    Toggle.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    local startTime = tick()

    StartBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().AutoCollect = true
        end)
    end)

    StopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().AutoCollect = false
        end)
    end)

    ToggleCollectBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().AutoCollect = not getgenv().AutoCollect
        end)
    end)

    HopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            HopServer()
        end)
    end)

    ForceStopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().AutoCollect = false
            getgenv().AutoStore = false
            getgenv().ESPEnabled = false
            getgenv().NoclipEnabled = false
        end)
    end)

    RefreshBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local beli = 0
            if player:FindFirstChild("Data") and player.Data:FindFirstChild("Beli") then
                beli = player.Data.Beli.Value
            end
            Info.Text = "Money : "..tostring(beli).."\nTime : 00:00:00\nState : "..(getgenv().AutoCollect and "Farming" or "Stopped")
        end)
    end)

    ToggleStoreBtn.MouseButton1Click:Connect(function()
        getgenv().AutoStore = not getgenv().AutoStore
        ToggleStoreBtn.Text = "Auto Store: " .. (getgenv().AutoStore and "ON" or "OFF")
    end)

    -- Webhook input (bottom)
    local webhookLabel = Instance.new("TextLabel", Main)
    webhookLabel.Size = UDim2.new(0, 150, 0, 18)
    webhookLabel.Position = UDim2.new(0, 12, 1, -44)
    webhookLabel.BackgroundTransparency = 1
    webhookLabel.Font = Enum.Font.Gotham
    webhookLabel.TextSize = 13
    webhookLabel.TextColor3 = Color3.fromRGB(200,200,200)
    webhookLabel.Text = "Webhook URL:"
    webhookLabel.TextXAlignment = Enum.TextXAlignment.Left

    local webhookBox = Instance.new("TextBox", Main)
    webhookBox.Size = UDim2.new(0, 220, 0, 24)
    webhookBox.Position = UDim2.new(0, 12, 1, -24)
    webhookBox.BackgroundColor3 = Color3.fromRGB(34,34,40)
    webhookBox.TextColor3 = Color3.fromRGB(230,230,235)
    webhookBox.Font = Enum.Font.Gotham
    webhookBox.TextSize = 12
    webhookBox.Text = getgenv().WebhookURL or ""
    webhookBox.ClearTextOnFocus = false
    Instance.new("UICorner", webhookBox).CornerRadius = UDim.new(0,6)

    local btnSetWebhook = Instance.new("ImageButton", Main)
    btnSetWebhook.Size = UDim2.new(0, 100, 0, 26)
    btnSetWebhook.Position = UDim2.new(1, -112, 1, -24)
    btnSetWebhook.Image = BTN_BG_IMAGE
    btnSetWebhook.BackgroundTransparency = 0.3
    local txtBtn = Instance.new("TextLabel", btnSetWebhook)
    txtBtn.Size = UDim2.fromScale(1,1)
    txtBtn.BackgroundTransparency = 1
    txtBtn.Text = "Save Webhook"
    txtBtn.Font = Enum.Font.GothamBold
    txtBtn.TextSize = 13
    txtBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btnSetWebhook).CornerRadius = UDim.new(0,6)

    local lastCollected = Instance.new("TextLabel", Main)
    lastCollected.Size = UDim2.new(1, -12, 0, 18)
    lastCollected.Position = UDim2.new(0, 12, 0, 160)
    lastCollected.BackgroundTransparency = 1
    lastCollected.Text = "Last Collected: None"
    lastCollected.Font = Enum.Font.Gotham
    lastCollected.TextSize = 13
    lastCollected.TextColor3 = Color3.fromRGB(190,190,190)
    lastCollected.TextXAlignment = Enum.TextXAlignment.Left

    local function updateInfo()
        pcall(function()
            local beli = 0
            if player:FindFirstChild("Data") and player.Data:FindFirstChild("Beli") then
                beli = player.Data.Beli.Value
            end
            local t = 0
            if getgenv().AutoCollect then t = math.floor(tick() - startTime) end
            local hours = math.floor(t / 3600) % 24
            local mins  = math.floor(t / 60) % 60
            local secs  = t % 60
            local state = getgenv().AutoCollect and "Farming" or "Stopped"
            Info.Text = "Money : "..tostring(beli).."\nTime : "..string.format("%02d:%02d:%02d", hours, mins, secs).."\nState : "..state
        end)
    end

    -- Hook for collected update
    local function onCollected(name)
        lastCollected.Text = "Last Collected: " .. tostring(name)
    end
    getgenv().NightX_OnCollected = onCollected

    -- Save webhook button
    btnSetWebhook.MouseButton1Click:Connect(function()
        local txt = webhookBox.Text or ""
        getgenv().WebhookURL = txt
        webhookBox.Text = txt
        txtBtn.Text = "Saved!"
        task.delay(2, function() if txtBtn then pcall(function() txtBtn.Text = "Save Webhook" end) end end)
    end)

    -- Info updater loop
    spawn(function()
        while task.wait(0.5) do
            updateInfo()
        end
    end)
end)

-- ========= Anti-AFK / AutoJump (from chest script) =========
spawn(function()
    while task.wait(math.random(15,20)) do
        pcall(function()
            if getgenv().AutoJump == nil then getgenv().AutoJump = true end
            if getgenv().AutoJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Anti-kick micro adjust (from chest script)
spawn(function()
    while task.wait(1) do
        pcall(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character.HumanoidRootPart.Velocity.Magnitude < 0.1 then
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,0.01)
                end
            end
        end)
    end
end)

-- Initialize noclip toggle effect looping
spawn(function()
    while task.wait(1) do
        if getgenv().NoclipEnabled then
            startNoclip()
        else
            stopNoclip()
        end
    end
end)

-- Final startup message
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "PHUCMAX",
        Text = "Thank you for using my script.: "..tostring(getgenv().DisplayName),
        Duration = 5
    })
end)

print("PHUCMAX depzai.")