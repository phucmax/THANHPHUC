

-- ============================================================
-- KHỞI TẠO THƯ VIỆN FLUENT VÀ TẠO WINDOW GỐC
-- ============================================================
local Fluent, SaveManager, InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()

local Window = Fluent:CreateWindow({
    Title = "X Nhau",
    SubTitle = "Grow a Garden 2",
    Size = UDim2.fromOffset(480, 380),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 160
})

-- Đồng bộ biến Window lên bộ nhớ toàn cục ngay lập tức để nút bấm nhận diện
getgenv().Window = Window

-- ============================================================
-- CÁC TAB CỦA MENU
-- ============================================================
local InfoTab = Window:AddTab({ Title = "Thong Tin", Icon = "" })
local MainTab = Window:AddTab({ Title = "Chinh", Icon = "" })
local PetTab = Window:AddTab({ Title = "Thu Cuong", Icon = "" })
local ShopTab = Window:AddTab({ Title = "Cua Hang", Icon = "" })
local SettingTab = Window:AddTab({ Title = "Cai Dat", Icon = "" })
local LagTab = Window:AddTab({ Title = "Giam Lag", Icon = "" })

-- ============================================================
-- KHỞI TẠO NÚT BẤM XNHAU HOÀN CHỈNH (CÓ SỬA LỖI ĐÓNG MỞ)
-- ============================================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local existingGui = playerGui:FindFirstChild("CustomScreenGui")
if existingGui then
    existingGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomScreenGui"
ScreenGui.Parent = playerGui
ScreenGui.IgnoreGuiInset = true 

-- 1. KHUNG CHỨA BÓNG ĐỔ (GLOW SHADOW CONTAINER)
local ShadowContainer = Instance.new("ImageLabel")
ShadowContainer.Name = "ShadowContainer"
ShadowContainer.Size = UDim2.new(0, 160, 0, 70) 
ShadowContainer.Position = UDim2.new(0.5, -80, 0.1, 0)
ShadowContainer.BackgroundTransparency = 1
ShadowContainer.Image = "rbxassetid://6015897843" 
ShadowContainer.ImageColor3 = Color3.fromRGB(0, 110, 255)
ShadowContainer.ImageTransparency = 0.3
ShadowContainer.ScaleType = Enum.ScaleType.Slice
ShadowContainer.SliceCenter = Rect.new(49, 49, 450, 450)
ShadowContainer.Parent = ScreenGui

-- 2. NÚT CHÍNH (MÀU XANH DƯƠNG GLOSSY ĐẬM 3D)
local Button = Instance.new("ImageButton")
Button.Name = "CustomButton"
Button.Size = UDim2.new(0, 130, 0, 40)
Button.Position = UDim2.new(0.5, -65, 0.5, -20) 
Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button.BorderSizePixel = 0
Button.AutoButtonColor = false 
Button.Parent = ShadowContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Button

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 35, 140)),   
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 20, 95)),  
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 5, 50))     
})
MainGradient.Rotation = 90
MainGradient.Parent = Button

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = Button
UIStroke.Thickness = 2
UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UIStroke.Color = Color3.fromRGB(0, 90, 255)
UIStroke.Transparency = 0.3

-- 3. HIỆU ỨNG PHẢN CHIẾU ÁNH SÁNG TRÊN ĐỈNH (GLOSSY CAP)
local GlossFrame = Instance.new("Frame")
GlossFrame.Name = "GlossFrame"
GlossFrame.Size = UDim2.new(1, 0, 0.45, 0)
GlossFrame.Position = UDim2.new(0, 0, 0, 0)
GlossFrame.BackgroundTransparency = 0
GlossFrame.BorderSizePixel = 0
GlossFrame.Parent = Button

local GlossCorner = Instance.new("UICorner")
GlossCorner.CornerRadius = UDim.new(0, 20)
GlossCorner.Parent = GlossFrame

local GlossGradient = Instance.new("UIGradient")
GlossGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
GlossGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.2), 
    NumberSequenceKeypoint.new(1, 0.95) 
})
GlossGradient.Rotation = 90
GlossGradient.Parent = GlossFrame

-- 4. CHỮ "XNhau" MÀU SẮC CHUẨN XNHAU.LA
local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Button
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = '<font color="rgb(255,150,0)">X</font><font color="rgb(205,90,255)">N</font><font color="rgb(215,110,255)">h</font><font color="rgb(230,130,255)">a</font><font color="rgb(245,150,255)">u</font>'
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 20
TextLabel.TextWrapped = false
TextLabel.TextXAlignment = Enum.TextXAlignment.Center
TextLabel.TextYAlignment = Enum.TextYAlignment.Center
TextLabel.RichText = true
TextLabel.ZIndex = 3 

local TextShadow = Instance.new("TextLabel")
TextShadow.Parent = Button
TextShadow.Size = UDim2.new(1, 0, 1, -2)
TextShadow.Position = UDim2.new(0, 1, 0, 1)
TextShadow.BackgroundTransparency = 1
TextShadow.Text = "XNhau"
TextShadow.Font = Enum.Font.GothamBold
TextShadow.TextSize = 20
TextShadow.TextColor3 = Color3.fromRGB(0, 0, 20)
TextShadow.TextTransparency = 0.5
TextShadow.ZIndex = 2

-- ============================================================
-- 5. LOGIC TOGGLE THU NHỎ/MỞ RỘNG ĐỘC LẬP
-- ============================================================
local function toggleFluentUI()
    local fluentWindow = getgenv().Window
    
    if fluentWindow and fluentWindow.Minimize then
        pcall(function()
            fluentWindow:Minimize() -- Gọi lệnh thu nhỏ chính thống của thư viện Fluent
        end)
    else
        -- Cơ chế quét dự phòng sâu nếu môi trường sandbox chặn getgenv()
        local found = false
        for _, loc in ipairs({CoreGui, playerGui}) do
            for _, scr in ipairs(loc:GetChildren()) do
                if scr:IsA("ScreenGui") and scr:FindFirstChild("MainFrame") then
                    local mf = scr.MainFrame
                    -- Tìm kiếm nút Minimize thu nhỏ bằng hình ảnh ID trên thanh TopBar
                    for _, desc in ipairs(mf:GetDescendants()) do
                        if desc:IsA("ImageButton") and (desc.Name:lower():find("min") or desc.Image:find("10305880150")) then
                            pcall(function() desc:Activate() end)
                            found = true
                            break
                        end
                    end
                end
                if found then break end
            end
            if found then break end
        end
    end
end

-- SỰ KIỆN CLICK NÚT
Button.MouseButton1Click:Connect(function()
    Button:TweenSize(UDim2.new(0, 118, 0, 35), "Out", "Quad", 0.08, true)
    task.wait(0.08)
    Button:TweenSize(UDim2.new(0, 130, 0, 40), "Out", "Quad", 0.08, true)

    toggleFluentUI()
end)

-- SỰ KIỆN KÉO THẢ (DRAGGING)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    local TargetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(ShadowContainer, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = TargetPos}):Play()
end

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ShadowContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)





-- ============================================================
-- SECTION: GIOI THIEU SCRIPT
-- ============================================================
local AboutSection = InfoTab:AddSection("Gioi Thieu")

AboutSection:AddParagraph({
    Title = "Grow a Garden 2 ",
    Content = "by THANH PHUC\n\n"
        .. "lỗi gì thì vào discord mà báo \n"
        
        
       
        
})



-- ============================================================
-- SECTION: LIEN KET
-- ============================================================
local LinkSection = InfoTab:AddSection("Lien Ket")



LinkSection:AddButton({
    Title = "Copy Link discord",
    Description = "Sao chep link discord vao clipboard",
    Callback = function()
        setclipboard("https://discord.gg/Wd5s7B5Ggb")
        Fluent:Notify({
            Title = "discord",
            Content = "Da sao chep link discord!",
            Duration = 2
        })
    end
})

LinkSection:AddButton({
    Title = "Copy Link tiktok",
    Description = "Sao chep link Tiktok vao clipboard",
    Callback = function()
        setclipboard("https://www.tiktok.com/@phucmaxt?_r=1&_t=ZS-97Nk7x6Je9V")
        Fluent:Notify({
            Title = "tiktok",
            Content = "Da sao chep link Tiktok!",
            Duration = 2
        })
    end
})






-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local PPS = game:GetService("ProximityPromptService")
PPS.MaxPromptsVisible = 100

local Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking"))
local Packet = RS.SharedModules.Packet.RemoteEvent
local hide = LP:FindFirstChild("HideCollectProximityPrompts")

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    ["Plant Seed"] = { Enable = false, Seed = {} },
    ["Harvest"] = { Enable = false, All = false, Fruit = {}, ["Only Mutation"] = false, ["Ignore Mutation"] = false, ["Select Mutation Harvest"] = {}, ["Select Mutation Ignore"] = {}, ["Weather Filter"] = false, ["Only During Weather"] = false, ["Select Weather"] = {}, ["Stop If Full"] = true },
    ["Sell"] = { Enable = false, ["When Full"] = false },
    ["Buy Seed"] = { Enable = false, Seed = {} },
    ["Buy Gear"] = { Enable = false, Gear = {} },
    ["Destroy Plant"] = { ["By Name"] = false, ["By Rarity"] = false, Name = {}, Rarity = {} },
    ["Seed Pack"] = { Enable = false, Gold = false, Rainbow = false, ["Auto Open"] = false },
    ["Pet Spawn"] = { Enable = false },
    ["Stand Center"] = { Enable = false, Height = 3, Interval = 2 },
    ["Settings"] = { ["Move Mode"] = "TP", ["Tween Speed"] = 350, ["Anti AFK"] = true, ["Plant Delay"] = 0.4, ["Harvest Delay"] = 0.05, ["Sell Delay"] = 0.2, ["Shovel Delay"] = 0.2 },
    Steal = false,
    StealDelay = 0.5,
    AntiSteal = false,
}

-- Danh sách seed
local AllSeedNames = {"Bamboo", "Blueberry", "Tulip", "Apple", "Tomato", "Banana", "Sunflower", "Corn", "Mushroom", "Cherry", "Mango", "Grape", "Coconut", "Cactus", "Baby Cactus", "Pomegranate", "Pineapple", "Dragon Fruit", "Poison Apple", "Moon Bloom", "Poison Ivy", "Ghost Pepper", "Venus Fly Trap", "Dragon's Breath"}

-- Mặc định bật vài seed
for _, name in ipairs({"Bamboo", "Blueberry", "Tulip", "Apple", "Tomato", "Banana", "Sunflower", "Corn", "Mushroom"}) do
    Config["Plant Seed"].Seed[name] = false
    Config["Buy Seed"].Seed[name] = false
end

-- ============================================================
-- UTILITY
-- ============================================================
local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getModel(instance)
    if not instance then return nil end
    return instance:FindFirstAncestorOfClass("Model")
end

local function firePrompt(prompt)
    if fireproximityprompt then fireproximityprompt(prompt)
    else prompt:InputHoldBegin() task.wait(0.01) prompt:InputHoldEnd() end
end

local function teleportTo(pos)
    local hrp = getHRP()
    if hrp then hrp.CFrame = CFrame.new(pos) end
end

local function isNight()
    local n = RS:FindFirstChild("Night")
    return n ~= nil and n.Value == true
end

local function isBackpackFull()
    local ok, result = pcall(function()
        return LP.PlayerGui.BackpackGui.Backpack.Inventory.FruitInventory.Text
    end)
    if ok and result then
        local current, max = result:match("(%d+)/(%d+)")
        if current and max then return tonumber(current) >= tonumber(max) end
    end
    return false
end

-- ============================================================
-- 1. AUTO PLANT SEED (LOGIC THẬT)
-- ============================================================
local function getGroundPosition(pos)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = CollectionService:GetTagged("PlantArea")
    local r = workspace:Raycast(pos + Vector3.new(0, 12, 0), Vector3.new(0, -60, 0), params)
    return r and r.Position
end

local function plantSeedAtPosition(position)
    if not Config["Plant Seed"].Enable then return false end
    local selectedSeeds = {}
    for name, enabled in pairs(Config["Plant Seed"].Seed) do
        if enabled then table.insert(selectedSeeds, name) end
    end
    if #selectedSeeds == 0 then return false end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return false end

    local seedTool = nil
    for _, name in ipairs(selectedSeeds) do
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == name and tool:GetAttribute("SeedTool") then
                seedTool = tool
                break
            end
        end
        if seedTool then break end
    end
    if not seedTool then return false end

    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum:EquipTool(seedTool) end) end
    task.wait(0.05)
    pcall(function() Networking.Plant.PlantSeed:Fire(position, seedTool:GetAttribute("SeedTool"), seedTool) end)
    return true
end

task.spawn(function()
    while true do
        if Config["Plant Seed"].Enable then
            local plotId = LP:GetAttribute("PlotId")
            local plot = plotId and workspace:FindFirstChild("Gardens") and workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId))
            if plot then
                local plantAreas = CollectionService:GetTagged("PlantArea")
                local plotAreas = {}
                for _, area in ipairs(plantAreas) do
                    if area:IsDescendantOf(plot) then table.insert(plotAreas, area) end
                end
                if #plotAreas > 0 then
                    local area = plotAreas[math.random(1, #plotAreas)]
                    local pos = area.Position
                    local size = area.Size
                    local target = Vector3.new(
                        pos.X + (math.random() - 0.5) * size.X,
                        pos.Y + size.Y / 2 + 0.1,
                        pos.Z + (math.random() - 0.5) * size.Z
                    )
                    plantSeedAtPosition(target)
                end
            end
        end
        task.wait(Config.Settings["Plant Delay"] or 0.4)
    end
end)



-- ============================================================
-- 2. AUTO COLLECT FRUIT (LOGIC THẬT)
-- ============================================================
task.spawn(function()
    while true do
        if Config.Harvest.Enable and (not hide or not hide.Value) then
            if Config.Harvest["Stop If Full"] and isBackpackFull() then
                task.wait(0.5)
                continue
            end
            for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local model = getModel(prompt)
                    if model and tonumber(model:GetAttribute("UserId")) == LP.UserId then
                        local plantId = model:GetAttribute("PlantId")
                        local fruitId = model:GetAttribute("FruitId") or ""
                        if plantId then
                            pcall(function() Networking.Garden.CollectFruit:Fire(plantId, fruitId) end)
                        end
                    end
                end
            end
        end
        task.wait(Config.Settings["Harvest Delay"] or 0.05)
    end
end)

-- ============================================================
-- 3. AUTO COLLECT SEEDPACK (LOGIC THẬT)
-- ============================================================
local function getSeedLocations()
    local seeds = {}
    local map = workspace:FindFirstChild("Map")
    if map then
        local locs = map:FindFirstChild("SeedPackSpawnServerLocations")
        if locs then
            for _, part in ipairs(locs:GetChildren()) do
                if part:IsA("BasePart") then
                    table.insert(seeds, { model = part, pos = part.Position + Vector3.new(0, part.Size.Y / 2 + 3, 0) })
                end
            end
        end
    end
    return seeds
end

task.spawn(function()
    while true do
        if Config["Seed Pack"].Enable then
            local seeds = getSeedLocations()
            if #seeds > 0 then
                local saved = getHRP() and getHRP().CFrame
                for _, seed in ipairs(seeds) do
                    if not Config["Seed Pack"].Enable then break end
                    teleportTo(seed.pos)
                    task.wait(0.2)
                    local prompt = seed.model:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        local oldDist = prompt.MaxActivationDistance
                        prompt.MaxActivationDistance = 100
                        firePrompt(prompt)
                        prompt.MaxActivationDistance = oldDist
                    end
                    task.wait(0.3)
                end
                if saved then teleportTo(saved.Position) end
            end
        end
        task.wait(1)
    end
end)

-- Auto Open SeedPack
task.spawn(function()
    while true do
        if Config["Seed Pack"].Enable and Config["Seed Pack"]["Auto Open"] then
            local backpack = LP:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("SeedPack") or item.Name:find("Seed Pack")) then
                        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                        if hum then pcall(function() hum:EquipTool(item) end) end
                        task.wait(0.1)
                        pcall(function() item:Use() end)
                        task.wait(0.3)
                    end
                end
            end
        end
        task.wait(2)
    end
end)

-- ============================================================
-- 6. ANTI STEAL (LOGIC THẬT)
-- ============================================================
task.spawn(function()
    while true do
        if Config.AntiSteal and isNight() then
            local pid = LP:GetAttribute("PlotId")
            if pid then
                local gzd = RS:FindFirstChild("GardenZoneData")
                if gzd then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP then
                            local v = gzd:FindFirstChild(p.Name)
                            local ch = p.Character
                            if v and v.Value == pid and ch and ch:FindFirstChild("HumanoidRootPart") then
                                local hrp = getHRP()
                                local tHRP = ch.HumanoidRootPart
                                if hrp and tHRP then
                                    hrp.CFrame = CFrame.new(tHRP.Position + Vector3.new(0, 0, 5), tHRP.Position)
                                    pcall(function() Networking.Shovel.SwingShovel:Fire() end)
                                    pcall(function() Networking.Shovel.HitPlayer:Fire(p.UserId) end)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- ============================================================
-- BUY SEEDS LOOP
-- ============================================================
task.spawn(function()
    while true do
        if Config["Buy Seed"].Enable then
            for name, enabled in pairs(Config["Buy Seed"].Seed) do
                if enabled then
                    pcall(function() Packet:FireServer(103, name) end)
                    task.wait(0.2)
                end
            end
        end
        task.wait(1.5)
    end
end)

-- ============================================================
-- 5. AUTO SELL (LOGIC THẬT)
-- ============================================================
task.spawn(function()
    while true do
        if Config.Sell.Enable then
            pcall(function() Networking.NPCS.SellAll:Fire() end)
        end
        if Config.Sell["When Full"] and isBackpackFull() then
            pcall(function() Networking.NPCS.SellAll:Fire() end)
        end
        task.wait(Config.Settings["Sell Delay"] or 0.2)
    end
end)





-- ============================================================
-- BUY SEEDS LOOP
-- ============================================================
task.spawn(function()
    while true do
        if Config["Buy Seed"].Enable then
            for name, enabled in pairs(Config["Buy Seed"].Seed) do
                if enabled then
                    pcall(function() Packet:FireServer(103, name) end)
                    task.wait(0.2)
                end
            end
        end
        task.wait(1.5)
    end
end)

-- ============================================================
-- STAND CENTER
-- ============================================================
task.spawn(function()
    while true do
        if Config["Stand Center"].Enable then
            local plotId = LP:GetAttribute("PlotId")
            if plotId then
                local plot = workspace.Gardens and workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId))
                if plot then
                    local ref = plot:FindFirstChild("PlotSizeReference")
                    if ref and ref:IsA("BasePart") then
                        local center = ref.Position + Vector3.new(0, Config["Stand Center"].Height or 3, 0)
                        local hrp = getHRP()
                        if hrp and (hrp.Position - center).Magnitude > 2 then
                            hrp.CFrame = CFrame.new(center)
                        end
                    end
                end
            end
        end
        task.wait(Config["Stand Center"].Interval or 2)
    end
end)


-- ============================================================
-- KHAI BÁO DANH SÁCH TẤT CẢ HẠT GIỐNG TRONG GROW A GARDEN 2
-- ============================================================
local AllSeedNames = {
    -- Cây cơ bản & Rau củ (Basic & Vegetables)
    "Wheat", "Tomato", "Potato", "Carrot", "Corn", "Pumpkin", "Cabbage", "Lettuce", "Garlic", "Onion",
    
    -- Trái cây & Cây ăn quả (Fruits & Berries)
    "Apple", "Banana", "Orange", "Grape", "Blueberry", "Strawberry", "Raspberry", "Watermelon", "Lemon", "Coconut",
    
    -- Hoa & Cây cảnh (Flowers & Decorative)
    "Tulip", "Sunflower", "Rose", "Lily", "Daisy", "Orchid", "Lavender", "Lotus", "Cactus",
    
    -- Cây đặc biệt, Hiếm & Tiến hóa (Special, Exotic & Fantasy)
    "Bamboo", "Mushroom", "GlowShroom", "DragonFruit", "GoldenApple", "CrystalFlower", "StarFruit", "Chili"
}

-- Khởi tạo bảng Config nếu chưa có để tránh lỗi Crash Script
if not Config then _G.Config = {} end
if not Config["Plant Seed"] then Config["Plant Seed"] = { Enable = false, EnableAll = false, Seed = {} } end
if not Config["Buy Seed"] then Config["Buy Seed"] = { Seed = {} } end
if not Config.Settings then Config.Settings = { ["Plant Delay"] = 0.4 } end
if not Config.Harvest then Config.Harvest = { Enable = false, ["Stop If Full"] = false } end
if not Config["Seed Pack"] then Config["Seed Pack"] = { Enable = false, ["Auto Open"] = false } end

-- ============================================================
-- 1. AUTO PLANT SEED (FIX LỖI NHẬN DIỆN DROPDOWN)
-- ============================================================
local function getGroundPosition(pos)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = CollectionService:GetTagged("PlantArea")
    local r = workspace:Raycast(pos + Vector3.new(0, 12, 0), Vector3.new(0, -60, 0), params)
    return r and r.Position
end

local function plantSeedAtPosition(position)
    if not Config["Plant Seed"].Enable and not Config["Plant Seed"].EnableAll then return false end
    
    local selectedSeeds = {}
    
    -- NẾU BẬT NÚT 2: Gom toàn bộ hạt giống có trong game
    if Config["Plant Seed"].EnableAll then
        for _, name in ipairs(AllSeedNames) do
            table.insert(selectedSeeds, name)
        end
    -- NẾU BẬT NÚT 1: Chỉ gom những hạt được người dùng tự tích chọn tay
    elseif Config["Plant Seed"].Enable then
        for name, enabled in pairs(Config["Plant Seed"].Seed) do
            if enabled == true then table.insert(selectedSeeds, name) end
        end
    end
    
    if #selectedSeeds == 0 then return false end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    local character = LP.Character
    if not backpack or not character then return false end 
    
    local seedTool = nil 
    for _, name in ipairs(selectedSeeds) do 
        -- Quét trong Backpack
        for _, tool in ipairs(backpack:GetChildren()) do 
            if tool:IsA("Tool") and tool.Name == name and tool:GetAttribute("SeedTool") then 
                seedTool = tool 
                break 
            end 
        end 
        if seedTool then break end
        
        -- Quét trên tay Character
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == name and tool:GetAttribute("SeedTool") then
                seedTool = tool
                break
            end
        end
        if seedTool then break end
    end 
    
    if not seedTool then return false end 

    local hum = character:FindFirstChildOfClass("Humanoid") 
    if hum then 
        if seedTool.Parent ~= character then
            pcall(function() hum:UnequipTools() end)
            task.wait(0.05)
            pcall(function() hum:EquipTool(seedTool) end)
            task.wait(0.1)
        end
    end 
    
    local success, err = pcall(function() 
        Networking.Plant.PlantSeed:Fire(position, seedTool:GetAttribute("SeedTool"), seedTool) 
    end)
    
    return success
end

task.spawn(function()
    while true do
        if Config["Plant Seed"].Enable or Config["Plant Seed"].EnableAll then
            local plotId = LP:GetAttribute("PlotId")
            local plot = plotId and workspace:FindFirstChild("Gardens") and workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId))
            if plot then
                local plantAreas = CollectionService:GetTagged("PlantArea")
                local plotAreas = {}
                for _, area in ipairs(plantAreas) do
                    if area:IsDescendantOf(plot) then 
                        table.insert(plotAreas, area) 
                    end
                end
                
                if #plotAreas > 0 then
                    local area = plotAreas[math.random(1, #plotAreas)]
                    local pos = area.Position
                    local size = area.Size
                    local target = Vector3.new(
                        pos.X + (math.random() - 0.5) * size.X,
                        pos.Y + size.Y / 2 + 0.1,
                        pos.Z + (math.random() - 0.5) * size.Z
                    )
                    
                    local groundPos = getGroundPosition(target)
                    if groundPos then
                        local planted = plantSeedAtPosition(groundPos)
                        if not planted then
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
        task.wait(Config.Settings["Plant Delay"] or 0.4)
    end
end)

-- ============================================================
-- 2. AUTO COLLECT FRUIT
-- ============================================================
task.spawn(function()
    while true do
        if Config.Harvest.Enable and (not hide or not hide.Value) then
            if Config.Harvest["Stop If Full"] and isBackpackFull() then
                task.wait(0.5)
            else
                for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local model = getModel(prompt)
                        if model and tonumber(model:GetAttribute("UserId")) == LP.UserId then
                            local plantId = model:GetAttribute("PlantId")
                            local fruitId = model:GetAttribute("FruitId") or ""
                            if plantId then
                                pcall(function() Networking.Garden.CollectFruit:Fire(plantId, fruitId) end)
                            end
                        end
                    end
                end
            end
        end
        task.wait(Config.Settings["Harvest Delay"] or 0.05)
    end
end)

-- ============================================================
-- 3. AUTO COLLECT SEEDPACK & AUTO OPEN
-- ============================================================
local function getSeedLocations()
    local seeds = {}
    local map = workspace:FindFirstChild("Map")
    if map then
        local locs = map:FindFirstChild("SeedPackSpawnServerLocations")
        if locs then
            for _, part in ipairs(locs:GetChildren()) do
                if part:IsA("BasePart") then
                    table.insert(seeds, { model = part, pos = part.Position + Vector3.new(0, part.Size.Y / 2 + 3, 0) })
                end
            end
        end
    end
    return seeds
end

task.spawn(function()
    while true do
        if Config["Seed Pack"].Enable then
            local seeds = getSeedLocations()
            if #seeds > 0 then
                local saved = getHRP() and getHRP().CFrame
                for _, seed in ipairs(seeds) do
                    if not Config["Seed Pack"].Enable then break end
                    teleportTo(seed.pos)
                    task.wait(0.2)
                    local prompt = seed.model:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        local oldDist = prompt.MaxActivationDistance
                        prompt.MaxActivationDistance = 100
                        firePrompt(prompt)
                        prompt.MaxActivationDistance = oldDist
                    end
                    task.wait(0.3)
                end
                if saved then teleportTo(saved.Position) end
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if Config["Seed Pack"].Enable and Config["Seed Pack"]["Auto Open"] then
            local backpack = LP:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("SeedPack") or item.Name:find("Seed Pack")) then
                        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                        if hum then pcall(function() hum:EquipTool(item) end) end
                        task.wait(0.1)
                        pcall(function() item:Use() end)
                        task.wait(0.3)
                    end
                end
            end
        end
        task.wait(2)
    end
end)

-- ============================================================
-- SECTION 1: AUTOMATION PLANTS (BẢN FIX NHẬN DIỆN DROPDOWN)
-- ============================================================
local PlantSection = MainTab:AddSection("Automation Plants")

PlantSection:AddDropdown("SelectSeeds_1", {
    Title = "Chọn hạt giống",
    Description = "Chọn loại hạt giống muốn trồng tự động",
    Values = AllSeedNames,
    Multi = true,
    Default = {}, 
    Callback = function(value)
        -- Reset toàn bộ data cũ về false
        for _, name in ipairs(AllSeedNames) do
            Config["Plant Seed"].Seed[name] = false
            Config["Buy Seed"].Seed[name] = false
        end
        
        -- FIX TỐI ƯU: Quét đa cấu trúc (chấp nhận cả định dạng Array lẫn Dictionary của UI)
        if type(value) == "table" then
            for k, v in pairs(value) do
                if type(k) == "string" and v == true then
                    -- Định dạng Dictionary: {["Tomato"] = true}
                    Config["Plant Seed"].Seed[k] = true
                    Config["Buy Seed"].Seed[k] = true
                elseif type(v) == "string" then
                    -- Định dạng Array: {"Tomato", "Wheat"}
                    Config["Plant Seed"].Seed[v] = true
                    Config["Buy Seed"].Seed[v] = true
                end
            end
        end
    end
})

PlantSection:AddSlider("PlantDelay_1", {
    Title = "Độ trễ khi trồng",
    Min = 0.1, Max = 3, Default = 0.4, Rounding = 1,
    Callback = function(v) Config.Settings["Plant Delay"] = v end
})

PlantSection:AddToggle("AutoPlant_1", {
    Title = "Tự Động Trồng (Theo Dropdown)",
    Default = false, 
    Callback = function(v) Config["Plant Seed"].Enable = v end
})

PlantSection:AddToggle("AutoPlantAll_1", {
    Title = "Trồng Tất Cả Các Loại Hạt (Bỏ qua Dropdown)",
    Default = false, 
    Callback = function(v) Config["Plant Seed"].EnableAll = v end
})


-- ============================================================
-- CHẠY SCRIPT TỪ LINK - TAB MAIN
-- ============================================================
local RunScriptSection = MainTab:AddSection("nhan ban")

RunScriptSection:AddButton({
    Title = "Chay script dupe",
    Description = "dupe",
    Callback = function()
        Fluent:Notify({ Title = "Script", Content = "Dang chay script...", Duration = 2 })
        
        local success, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/phucmax/THANHPHUC/refs/heads/main/test.lua"))()
        end)
        
        if success then
            Fluent:Notify({ Title = "Script", Content = "Da chay script thanh cong!", Duration = 2 })
        else
            Fluent:Notify({ Title = "Loi", Content = "Khong the chay script: " .. tostring(result), Duration = 3 })
        end
    end
})


-- SECTION 2: AUTOMATION COLLECTION
local CollectSection = MainTab:AddSection("Automation Collection")

CollectSection:AddDropdown("FruitFilter_1", {
    Title = "Chọn Bộ Lọc Trái Cây",
    Values = {"All", "Apple", "Banana", "Blueberry", "Cherry", "Coconut", "Corn", "Dragon Fruit", "Grape", "Mango", "Mushroom", "Pineapple", "Pomegranate", "Sunflower", "Tomato", "Tulip"},
    Multi = true, Default = {"All"},
    Callback = function(value)
        Config.Harvest.All = table.find(value, "All") ~= nil
        Config.Harvest.Fruit = {}
        if not Config.Harvest.All then for _, v in ipairs(value) do Config.Harvest.Fruit[v] = true end end
    end
})

CollectSection:AddDropdown("RarityFilter_1", {
    Title = "Chọn Độ Hiếm",
    Values = {"All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"},
    Multi = true, Default = {"All"},
    Callback = function(value) end
})

CollectSection:AddDropdown("MutationFilter_1", {
    Title = "Chọn Đột Biến",
    Values = {"None", "Gold", "Rainbow", "Silver", "Dark", "Crystal"},
    Multi = true, Default = {"None"},
    Callback = function(value)
        Config.Harvest["Only Mutation"] = not table.find(value, "None")
        Config.Harvest["Select Mutation Harvest"] = {}
        if Config.Harvest["Only Mutation"] then
            for _, v in ipairs(value) do if v ~= "None" then Config.Harvest["Select Mutation Harvest"][v] = true end end
        end
    end
})

CollectSection:AddSlider("CollectDelay_1", {
    Title = "độ trễ thu thập",
    Min = 0.01, Max = 1, Default = 0.05, Rounding = 2,
    Callback = function(v) Config.Settings["Harvest Delay"] = v end
})

CollectSection:AddToggle("StopIfFull_1", {
    Title = "Dừng thu thập khi ba lô đầy",
    Default = true,
    Callback = function(v) Config.Harvest["Stop If Full"] = v end
})

CollectSection:AddToggle("PauseWeather_1", {
    Title = "Tạm dừng khi có sự kiện ",
    Default = false,
    Callback = function(v) Config.Harvest["Weather Filter"] = v end
})

CollectSection:AddToggle("AutoCollect_1", {
    Title = "Tự động thu thập Tất cả Trái Cây",
    Default = false,
    Callback = function(v) Config.Harvest.Enable = v end
})



-- ============================================================
-- TROM SIÊU TỐC - CHỈ CƯỚP (ĐƠN GIẢN - HIỆU QUẢ)
-- ============================================================

-- ============================================================
-- CONFIG
-- ============================================================
Config.Steal = false
Config.StealDelay = 0.01

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Networking
pcall(function()
    Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking"))
end)

-- ============================================================
-- UTILITY
-- ============================================================
local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getModel(instance)
    if not instance then return nil end
    return instance:FindFirstChildOfClass("Model") or instance:FindFirstAncestorOfClass("Model")
end

local function isNight()
    local n = RS:FindFirstChild("Night")
    return n ~= nil and n.Value == true
end

local function getMyPlotCenter()
    local plotId = LP:GetAttribute("PlotId")
    if not plotId then return nil end
    local gardens = workspace:FindFirstChild("Gardens")
    if not gardens then return nil end
    local plot = gardens:FindFirstChild("Plot" .. tostring(plotId))
    if not plot then return nil end
    local ref = plot:FindFirstChild("PlotSizeReference")
    if ref and ref:IsA("BasePart") then return ref.Position end
    return plot:GetPivot().Position
end

-- ============================================================
-- AUTO STEAL LOOP
-- ============================================================
task.spawn(function()
    local stolenCount = 0
    
    while true do
        if Config.Steal and isNight() then
            local hrp = getHRP()
            if not hrp then task.wait(0.1) continue end
            
            -- Lấy tất cả mục tiêu
            local targets = {}
            for _, prompt in ipairs(CollectionService:GetTagged("StealPrompt")) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled and prompt.Parent then
                    local model = getModel(prompt)
                    if model then
                        local uid = tonumber(model:GetAttribute("UserId"))
                        local pid = model:GetAttribute("PlantId")
                        if uid and uid ~= LP.UserId and pid then
                            table.insert(targets, {
                                model = model,
                                userId = uid,
                                plantId = pid,
                                pos = model:GetPivot().Position
                            })
                        end
                    end
                end
            end
            
            if #targets == 0 then task.wait(0.1) continue end
            
            -- Chọn mục tiêu đầu tiên
            local target = targets[1]
            
            -- Bay đến
            hrp.CFrame = CFrame.new(target.pos + Vector3.new(0, 2, 0))
            task.wait(0.03)
            
            -- Spam cướp trong 3 giây
            local startTime = os.clock()
            local success = false
            
            while os.clock() - startTime < 3 and not success do
                pcall(function()
                    Networking.Steal.BeginSteal:Fire(target.userId, target.plantId, "")
                end)
                task.wait(0.1)
                pcall(function()
                    Networking.Steal.CompleteSteal:Fire()
                end)
                
                -- Kiểm tra cây còn không
                if not target.model.Parent then
                    success = true
                    stolenCount = stolenCount + 1
                end
                task.wait(0.05)
            end
            
            -- Nếu không được thì thử mục tiêu thứ 2
            if not success and #targets >= 2 then
                target = targets[2]
                hrp.CFrame = CFrame.new(target.pos + Vector3.new(0, 2, 0))
                task.wait(0.03)
                
                startTime = os.clock()
                while os.clock() - startTime < 3 and not success do
                    pcall(function()
                        Networking.Steal.BeginSteal:Fire(target.userId, target.plantId, "")
                    end)
                    task.wait(0.1)
                    pcall(function()
                        Networking.Steal.CompleteSteal:Fire()
                    end)
                    if not target.model.Parent then
                        success = true
                        stolenCount = stolenCount + 1
                    end
                    task.wait(0.05)
                end
            end
            
            -- 5 trái về vườn
            if stolenCount >= 5 then
                stolenCount = 0
                local myCenter = getMyPlotCenter()
                if myCenter then
                    hrp.CFrame = CFrame.new(myCenter + Vector3.new(0, 5, 0))
                end
                task.wait(0.5)
            end
        end
        task.wait(Config.StealDelay or 0.01)
    end
end)

-- ============================================================
-- UI
-- ============================================================
local StealSection = MainTab:AddSection("Tu Dong Trom")

StealSection:AddToggle("AutoSteal", {
    Title = "Tu Dong Trom",
    Description = "Cuop VIP - 5 trai ve vuon",
    Default = false,
    Callback = function(v)
        Config.Steal = v
        if v then
            Fluent:Notify({ Title = "Trom", Content = "Da bat!", Duration = 2 })
        end
    end
})

StealSection:AddSlider("StealSpeed", {
    Title = "Toc Do",
    Min = 0.01, Max = 0.5, Default = 0.01, Rounding = 2,
    Callback = function(v) Config.StealDelay = v end
})

-- ============================================================
-- CONFIG GLOBAL
-- ============================================================
getgenv().Config = {
    FlySpeed = 360, -- Tốc độ bay mượt lách Anticheat
    SeedPack = {
        Enable = false,   -- Gom Gói Hạt Giống thường
        Gold = false,     -- Gom Hạt Giống Vàng
        Rainbow = false,  -- Gom Hạt Giống Cầu Vồng
        AutoOpen = false  -- Tự động mở gói
    }
}

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Networking
pcall(function() Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking")) end)

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- Hàm tính toán thời gian dựa trên khoảng cách để bay chuẩn vận tốc 360
local function flyTo(targetCFrame)
    local hrp = getHRP()
    if not hrp then return false end
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance < 3 then return true end -- Đã ở sát cạnh thì không cần bay
    
    local duration = distance / getgenv().Config.FlySpeed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    -- Triệt tiêu lực đẩy quán tính cũ để không bị lệch hướng bay
    hrp.Velocity = Vector3.new(0, 0, 0)
    
    tween:Play()
    tween.Completed:Wait() -- Chờ bay chạm đích hoàn toàn mới chạy lệnh tiếp theo
    hrp.Velocity = Vector3.new(0, 0, 0)
    return true
end

-- Hàm giả lập hành động nhấn và giữ phím tương tác
local function activePrompt(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt:InputBegan(Enum.UserInputType.MouseButton1)
        task.wait(prompt.HoldDuration)
        prompt:InputEnded(Enum.UserInputType.MouseButton1)
    end
end

-- ============================================================
-- MAIN LOOP: TỰ ĐỘNG QUÉT VÀ HÚT HẠT GIỐNG KHI ĐẾN SỰ KIỆN
-- ============================================================
task.spawn(function()
    while true do
        local sc = getgenv().Config.SeedPack
        
        -- Chỉ chạy khi mày bật ít nhất 1 chế độ nhặt
        if sc.Enable or sc.Gold or sc.Rainbow then
            local hrp = getHRP()
            if hrp then
                local targetItem = nil
                
                -- Quét liên tục môi trường workspace để tìm túi hạt giống rơi
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local pName = obj.Parent and obj.Parent.Name:lower() or ""
                        
                        -- Phân loại mục tiêu dựa theo thiết lập nút của mày trên UI
                        if sc.Enable and (pName:find("seedpack") or pName:find("seed pack") or pName:find("pack")) then
                            targetItem = obj
                            break
                        elseif sc.Gold and (pName:find("gold") or pName:find("vang")) then
                            targetItem = obj
                            break
                        elseif sc.Rainbow and (pName:find("rainbow") or pName:find("cau vong") or pName:find("premium")) then
                            targetItem = obj
                            break
                        end
                    end
                end
                
                -- Nếu phát hiện ra hạt giống của Event, lập tức bay qua hút
                if targetItem and targetItem.Parent then
                    local itemPos = targetItem.Parent:GetPivot().Position
                    
                    -- Bay đến sát vật phẩm (cách 0.5 stud trên trục đứng)
                    local reached = flyTo(CFrame.new(itemPos + Vector3.new(0, 0.5, 0)))
                    
                    if reached and targetItem.Enabled then
                        hrp.Anchored = true -- Khóa trục tạm thời để quá trình giữ phím nhặt không bị lệch
                        activePrompt(targetItem)
                        task.wait(0.12)
                        hrp.Anchored = false
                    end
                end
            end
        end
        
        -- Logic tự động gửi gói tin khui mở hạt giống ngầm từ xa
        if sc.AutoOpen then
            pcall(function()
                if Networking and Networking.Seeds and Networking.Seeds.OpenPack then
                    Networking.Seeds.OpenPack:FireServer()
                end
            end)
        end
        
        task.wait(0.15) -- Tốc độ quét 0.15 giây cực nhạy, ra quả nào hút quả đó lập tức
    end
end)

-- ============================================================
-- CONFIG GLOBAL
-- ============================================================
getgenv().Config = {
    FlySpeed = 360, -- Tốc độ bay mượt lách Anticheat
    SeedPack = {
        Enable = false,   -- Gom Gói Hạt Giống thường
        Gold = false,     -- Gom Hạt Giống Vàng
        Rainbow = false,  -- Gom Hạt Giống Cầu Vồng
        AutoOpen = false  -- Tự động mở gói
    }
}

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Networking
pcall(function() Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking")) end)

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- Hàm tính toán thời gian dựa trên khoảng cách để bay chuẩn vận tốc 360
local function flyTo(targetCFrame)
    local hrp = getHRP()
    if not hrp then return false end
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance < 3 then return true end -- Đã ở sát cạnh thì không cần bay
    
    local duration = distance / getgenv().Config.FlySpeed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    -- Triệt tiêu lực đẩy quán tính cũ để không bị lệch hướng bay
    hrp.Velocity = Vector3.new(0, 0, 0)
    
    tween:Play()
    tween.Completed:Wait() -- Chờ bay chạm đích hoàn toàn mới chạy lệnh tiếp theo
    hrp.Velocity = Vector3.new(0, 0, 0)
    return true
end

-- Hàm giả lập hành động nhấn và giữ phím tương tác
local function activePrompt(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt:InputBegan(Enum.UserInputType.MouseButton1)
        task.wait(prompt.HoldDuration)
        prompt:InputEnded(Enum.UserInputType.MouseButton1)
    end
end

-- ============================================================
-- MAIN LOOP: TỰ ĐỘNG QUÉT VÀ HÚT HẠT GIỐNG KHI ĐẾN SỰ KIỆN
-- ============================================================
task.spawn(function()
    while true do
        local sc = getgenv().Config.SeedPack
        
        -- Chỉ chạy khi mày bật ít nhất 1 chế độ nhặt
        if sc.Enable or sc.Gold or sc.Rainbow then
            local hrp = getHRP()
            if hrp then
                local targetItem = nil
                
                -- Quét liên tục môi trường workspace để tìm túi hạt giống rơi
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local pName = obj.Parent and obj.Parent.Name:lower() or ""
                        
                        -- Phân loại mục tiêu dựa theo thiết lập nút của mày trên UI
                        if sc.Enable and (pName:find("seedpack") or pName:find("seed pack") or pName:find("pack")) then
                            targetItem = obj
                            break
                        elseif sc.Gold and (pName:find("gold") or pName:find("vang")) then
                            targetItem = obj
                            break
                        elseif sc.Rainbow and (pName:find("rainbow") or pName:find("cau vong") or pName:find("premium")) then
                            targetItem = obj
                            break
                        end
                    end
                end
                
                -- Nếu phát hiện ra hạt giống của Event, lập tức bay qua hút
                if targetItem and targetItem.Parent then
                    local itemPos = targetItem.Parent:GetPivot().Position
                    
                    -- Bay đến sát vật phẩm (cách 0.5 stud trên trục đứng)
                    local reached = flyTo(CFrame.new(itemPos + Vector3.new(0, 0.5, 0)))
                    
                    if reached and targetItem.Enabled then
                        hrp.Anchored = true -- Khóa trục tạm thời để quá trình giữ phím nhặt không bị lệch
                        activePrompt(targetItem)
                        task.wait(0.12)
                        hrp.Anchored = false
                    end
                end
            end
        end
        
        -- Logic tự động gửi gói tin khui mở hạt giống ngầm từ xa
        if sc.AutoOpen then
            pcall(function()
                if Networking and Networking.Seeds and Networking.Seeds.OpenPack then
                    Networking.Seeds.OpenPack:FireServer()
                end
            end)
        end
        
        task.wait(0.15) -- Tốc độ quét 0.15 giây cực nhạy, ra quả nào hút quả đó lập tức
    end
end)

-- ============================================================
-- UI SETUP VIA FLUENT
-- ============================================================
local SeedPackSection = MainTab:AddSection("Sự Kiện ")

SeedPackSection:AddToggle("AutoSeedPack_1", {
    Title = "Tự động thu thập Gói Hạt Giống",
    Default = false,
    Callback = function(v) getgenv().Config.SeedPack.Enable = v end
})

SeedPackSection:AddToggle("AutoGoldSeed_1", {
    Title = "Tự động thu thập Hạt Giống Vàng",
    Default = false,
    Callback = function(v) getgenv().Config.SeedPack.Gold = v end
})

SeedPackSection:AddToggle("AutoRainbowSeed_1", {
    Title = "Tự động thu thập Hạt Giống Cầu Vồng",
    Default = false,
    Callback = function(v) getgenv().Config.SeedPack.Rainbow = v end
})

SeedPackSection:AddToggle("AutoOpenSeedPack_1", {
    Title = "Tự động mở gói hạt giống",
    Default = false,
    Callback = function(v) getgenv().Config.SeedPack.AutoOpen = v end
})

-- SECTION 5: AUTOMATION SELL
local SellSection = MainTab:AddSection("Automation Sell")

SellSection:AddSlider("SellDelay_1", {
    Title = "độ chễ khi bán",
    Min = 0.1, Max = 5, Default = 0.2, Rounding = 1,
    Callback = function(v) Config.Settings["Sell Delay"] = v end
})

SellSection:AddToggle("AllowSellMax_1", {
    Title = "bán khi ba lô đầy",
    Default = false,
    Callback = function(v) Config.Sell["When Full"] = v end
})

SellSection:AddToggle("AutoSell_1", {
    Title = "tự động bán",
    Default = false,
    Callback = function(v) Config.Sell.Enable = v end
})

SellSection:AddButton({
    Title = "tự động bán",
    Description = "Bán tất cả ngay",
    Callback = function()
        pcall(function() Networking.NPCS.SellAll:Fire() end)
        Fluent:Notify({ Title = "Sell", Content = "Đã bán!", Duration = 2 })
    end
})

-- SECTION 6: ANTI STEAL
local AntiStealSection = MainTab:AddSection("Anti Steal Protection")

AntiStealSection:AddToggle("AntiSteal_1", {
    Title = "chống cướp",
    Default = false,
    Callback = function(v) Config.AntiSteal = v end
})


-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Networking
pcall(function()
    Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking"))
end)

-- ============================================================
-- CONFIG GLOBAL
-- ============================================================
local Config = {
    Pet = { EquipEnabled = false, AutoEquipList = {}, AutoTameEnabled = false, SelectedEquip = nil }
}

-- ============================================================
-- UTILITY
-- ============================================================
local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function firePrompt(prompt)
    if fireproximityprompt then fireproximityprompt(prompt)
    else prompt:InputHoldBegin() task.wait(0.01) prompt:InputHoldEnd() end
end

-- ============================================================
-- TAB PET (THU CUONG)
-- ============================================================

local AllPetNames = {
    "Frog", "Bunny", "Owl", "Deer", "Robin", "Bee", "Monkey",
    "Golden Dragonfly", "Bear", "Unicorn", "Raccoon", "Black Dragon", "Ice Serpent"
}

for _, name in ipairs({"Robin", "Bee", "Monkey", "Unicorn", "Black Dragon", "Ice Serpent"}) do
    Config.Pet.AutoEquipList[name] = true
end

local function getOwnedPets()
    local pets = {}
    local petFolder = LP:FindFirstChild("Pets") or LP:FindFirstChild("OwnedPets")
    if petFolder then
        for _, pet in ipairs(petFolder:GetChildren()) do
            if pet:IsA("Model") or pet:IsA("Tool") then table.insert(pets, pet.Name) end
        end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("Pet") then table.insert(pets, item.Name) end
        end
    end
    return pets
end

local function equipPetByName(petName)
    local char = LP.Character
    if not char then return false end
    local petFolder = LP:FindFirstChild("Pets") or LP:FindFirstChild("OwnedPets")
    if petFolder then
        for _, pet in ipairs(petFolder:GetChildren()) do
            if pet.Name == petName then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and pet:IsA("Tool") then pcall(function() hum:EquipTool(pet) end) return true end
            end
        end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name == petName and item:GetAttribute("Pet") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(item) end) return true end
            end
        end
    end
    return false
end

local function getWildPets()
    local wildPets = {}
    local map = workspace:FindFirstChild("Map")
    if map then
        local wildPetFolder = map:FindFirstChild("WildPetRef") or map:FindFirstChild("WildPets")
        if wildPetFolder then
            for _, pet in ipairs(wildPetFolder:GetChildren()) do
                if pet:IsA("BasePart") or pet:IsA("Model") then
                    local ownerId = tonumber(pet:GetAttribute("OwnerUserId")) or 0
                    if ownerId == 0 then
                        table.insert(wildPets, {
                            object = pet,
                            name = pet.Name,
                            rarity = pet:GetAttribute("Rarity") or "Common",
                            position = pet:IsA("BasePart") and pet.Position or pet:GetPivot().Position
                        })
                    end
                end
            end
        end
    end
    return wildPets
end

-- SECTION 1: TRANG BI PET
local EquipSection = PetTab:AddSection("Trang Bi Pet")

EquipSection:AddDropdown("SelectPetEquip_1", {
    Title = "Chon Pet de Trang Bi",
    Description = "Chon mot pet de trang bi len nguoi",
    Values = getOwnedPets(),
    Multi = false,
    Default = nil,
    Callback = function(value)
        if value and #value > 0 then Config.Pet.SelectedEquip = value[1] end
    end
})

EquipSection:AddButton({
    Title = "Lam Moi Danh Sach Pet",
    Description = "Cap nhat lai danh sach pet dang so huu",
    Callback = function()
        local owned = getOwnedPets()
        if #owned > 0 then
            Fluent:Notify({ Title = "Thu Cuong", Content = "Tim thay " .. #owned .. " pet!", Duration = 2 })
        else
            Fluent:Notify({ Title = "Thu Cuong", Content = "Khong tim thay pet nao!", Duration = 2 })
        end
    end
})

EquipSection:AddButton({
    Title = "Trang Bi Pet Da Chon",
    Description = "Trang bi pet da chon len nguoi",
    Callback = function()
        if Config.Pet.SelectedEquip then
            local ok = equipPetByName(Config.Pet.SelectedEquip)
            if ok then
                Fluent:Notify({ Title = "Trang Bi", Content = "Da trang bi: " .. Config.Pet.SelectedEquip, Duration = 2 })
            else
                Fluent:Notify({ Title = "Trang Bi", Content = "Khong tim thay pet: " .. Config.Pet.SelectedEquip, Duration = 2 })
            end
        else
            Fluent:Notify({ Title = "Trang Bi", Content = "Chon pet truoc!", Duration = 2 })
        end
    end
})

-- SECTION 2: AUTO TRANG BI PET
local AutoEquipSection = PetTab:AddSection("Tu Dong Trang Bi Pet")

AutoEquipSection:AddDropdown("SelectPetsMulti_1", {
    Title = "Chon Nhieu Pet",
    Description = "Chon nhieu pet de tu dong trang bi",
    Values = AllPetNames,
    Multi = true,
    Default = {"Robin", "Bee", "Monkey", "Unicorn", "Black Dragon", "Ice Serpent"},
    Callback = function(value)
        for _, name in ipairs(AllPetNames) do Config.Pet.AutoEquipList[name] = false end
        for _, v in ipairs(value) do Config.Pet.AutoEquipList[v] = true end
    end
})

AutoEquipSection:AddToggle("AutoEquipPets_1", {
    Title = "Tu Dong Trang Bi Pet",
    Description = "Tu dong trang bi pet tu danh sach da chon",
    Default = false,
    Callback = function(v)
        Config.Pet.EquipEnabled = v
        if v then
            Fluent:Notify({ Title = "Tu Dong Trang Bi", Content = "Da bat tu dong trang bi pet!", Duration = 2 })
        else
            Fluent:Notify({ Title = "Tu Dong Trang Bi", Content = "Da tat!", Duration = 2 })
        end
    end
})

task.spawn(function()
    while true do
        if Config.Pet.EquipEnabled then
            for petName, enabled in pairs(Config.Pet.AutoEquipList) do
                if enabled and table.find(getOwnedPets(), petName) then
                    equipPetByName(petName)
                    break
                end
            end
        end
        task.wait(2)
    end
end)

-- SECTION 3: BO LOC TEN PET
local FilterSection = PetTab:AddSection("Bo Loc Ten Pet")

FilterSection:AddDropdown("PetNameFilter_1", {
    Title = "Bo Loc Ten Pet",
    Description = "Loc pet theo ten",
    Values = AllPetNames,
    Multi = true,
    Default = {},
    Callback = function(value) end
})

-- SECTION 4: TU DONG BAT PET HOANG DA
local TameSection = PetTab:AddSection("Tu Dong Bat Pet Hoang Da")

TameSection:AddToggle("AutoTameWild_1", {
    Title = "Tu Dong Bat Pet Hoang Da",
    Description = "Tu dong bat pet hoang da ngoai map",
    Default = false,
    Callback = function(v)
        Config.Pet.AutoTameEnabled = v
        if v then
            Fluent:Notify({ Title = "Bat Pet", Content = "Dang tu dong bat pet hoang da!", Duration = 2 })
        else
            Fluent:Notify({ Title = "Bat Pet", Content = "Da dung!", Duration = 2 })
        end
    end
})

task.spawn(function()
    while true do
        if Config.Pet.AutoTameEnabled then
            local wildPets = getWildPets()
            if #wildPets > 0 then
                local rarityOrder = { Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Mythic = 6 }
                table.sort(wildPets, function(a, b) return (rarityOrder[a.rarity] or 0) > (rarityOrder[b.rarity] or 0) end)
                local bestPet = wildPets[1]
                local hrp = getHRP()
                if hrp and bestPet.object and bestPet.object.Parent then
                    local savedPos = hrp.CFrame
                    hrp.CFrame = CFrame.new(bestPet.position + Vector3.new(0, 3, 2))
                    task.wait(0.2)
                    pcall(function() if Networking.Pets and Networking.Pets.WildPetTame then Networking.Pets.WildPetTame:Fire(bestPet.object) end end)
                    local prompt = bestPet.object:FindFirstChildWhichIsA("ProximityPrompt")
                    if not prompt then
                        for _, desc in ipairs(bestPet.object:GetDescendants()) do
                            if desc:IsA("ProximityPrompt") then prompt = desc break end
                        end
                    end
                    if prompt then firePrompt(prompt) end
                    task.wait(0.3)
                    hrp.CFrame = savedPos
                end
            end
        end
        task.wait(1)
    end
end)


-- ============================================================
-- CONFIG GLOBAL
-- ============================================================
local Config = {
    Shop = {
        SeedSelected = {},
        GearSelected = {},
        CrateSelected = {},
        AutoBuySeed = false,
        AutoBuyGear = false,
        AutoBuyCrate = false
    }
}

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

local Networking
pcall(function()
    Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking"))
end)

-- ============================================================
-- STOCK ITEMS (TỰ ĐỘNG LẤY TỪ GAME)
-- ============================================================
local function stockFolder(shop)
    local sv = RS:FindFirstChild("StockValues")
    local sh = sv and sv:FindFirstChild(shop)
    return sh and sh:FindFirstChild("Items")
end

local function listItems(shop)
    local out, f = {}, stockFolder(shop)
    if f then
        for _, v in ipairs(f:GetChildren()) do
            if v:IsA("ValueBase") then table.insert(out, v.Name) end
        end
        table.sort(out)
    end
    return out
end

local seedNames = listItems("SeedShop")
local gearNames = listItems("GearShop")

local crateNames = {
    "Basic Crate",
    "Rare Crate",
    "Epic Crate",
    "Legendary Crate",
    "Mythic Crate",
    "Omega Crate"
}

-- ============================================================
-- AUTO BUY SEEDS LOOP (SỬA PHƯƠNG THỨC TRUYỀN THAM SỐ)
-- ============================================================
task.spawn(function()
    while true do
        if Config.Shop.AutoBuySeed then
            local f = stockFolder("SeedShop")
            if f then
                for _, v in ipairs(f:GetChildren()) do
                    if v:IsA("ValueBase") and Config.Shop.SeedSelected[v.Name] == true then
                        -- Một số game yêu cầu gửi kèm số lượng (Ví dụ: 1), hoặc tên đầy đủ phải có chữ "Seed"
                        local finalName = v.Name
                        if not finalName:find("Seed") then
                            finalName = finalName .. " Seed"
                        end

                        pcall(function() 
                            -- Thử nghiệm cả 2 kiểu bắn Remote phổ biến của game
                            Networking.SeedShop.PurchaseSeed:Fire(v.Name, 1) 
                            Networking.SeedShop.PurchaseSeed:Fire(finalName, 1)
                        end)
                        task.wait(0.1)
                    end
                end
            end
        else
            task.wait(0.5)
        end
        task.wait(0.3)
    end
end)

-- ============================================================
-- AUTO BUY GEARS LOOP (ĐANG CHẠY NGON - GIỮ NGUYÊN)
-- ============================================================
task.spawn(function()
    while true do
        if Config.Shop.AutoBuyGear then
            local f = stockFolder("GearShop")
            if f then
                for _, v in ipairs(f:GetChildren()) do
                    if v:IsA("ValueBase") and Config.Shop.GearSelected[v.Name] == true then
                        pcall(function() Networking.GearShop.PurchaseGear:Fire(v.Name) end)
                        task.wait(0.1)
                    end
                end
            end
        else
            task.wait(0.5)
        end
        task.wait(0.5)
    end
end)

-- ============================================================
-- AUTO BUY CRATES LOOP (CHUYỂN HẲN SANG NETWORKING CHO ĐỒNG BỘ)
-- ============================================================
task.spawn(function()
    while true do
        if Config.Shop.AutoBuyCrate then
            for name, enabled in pairs(Config.Shop.CrateSelected) do
                if enabled == true then
                    pcall(function() 
                        -- Đồng bộ gọi qua cấu trúc Shop giống như Gear/Seed thay vì bắn Packet ID cũ
                        if Networking.CrateShop and Networking.CrateShop.PurchaseCrate then
                            Networking.CrateShop.PurchaseCrate:Fire(name, 1)
                        elseif Networking.Shop and Networking.Shop.BuyItem then
                            Networking.Shop.BuyItem:Fire(name, 1)
                        else
                            -- Phương án dự phòng nếu game xài chung cụm Purchase
                            Networking.GearShop.PurchaseGear:Fire(name, 1)
                        end
                    end)
                    task.wait(0.2)
                end
            end
        else
            task.wait(0.5)
        end
        task.wait(0.5)
    end
end)

-- ============================================================
-- UI - CUA HANG HAT GIONG
-- ============================================================
local SeedShopSection = ShopTab:AddSection("Cua Hang Hat Giong")

SeedShopSection:AddDropdown("ShopSeeds_1", {
    Title = "Chon Hat Giong",
    Description = "Chon loai hat muon mua",
    Values = seedNames,
    Multi = true,
    Default = {}, 
    Callback = function(value)
        for _, n in ipairs(seedNames) do Config.Shop.SeedSelected[n] = false end
        if type(value) == "table" then
            for k, v in pairs(value) do
                if type(k) == "string" and v == true then Config.Shop.SeedSelected[k] = true
                elseif type(v) == "string" then Config.Shop.SeedSelected[v] = true end
            end
        end
    end
})

SeedShopSection:AddToggle("AutoBuySeed_1", {
    Title = "Tu Dong Mua Hat Giong",
    Default = false,
    Callback = function(v) Config.Shop.AutoBuySeed = v end
})

-- ============================================================
-- UI - CUA HANG DUNG CU
-- ============================================================
local GearShopSection = ShopTab:AddSection("Cua Hang Dung Cu")

GearShopSection:AddDropdown("ShopGears_1", {
    Title = "Chon Dung Cu",
    Description = "Chon dung cu muon mua",
    Values = gearNames,
    Multi = true,
    Default = {}, 
    Callback = function(value)
        for _, n in ipairs(gearNames) do Config.Shop.GearSelected[n] = false end
        if type(value) == "table" then
            for k, v in pairs(value) do
                if type(k) == "string" and v == true then Config.Shop.GearSelected[k] = true
                elseif type(v) == "string" then Config.Shop.GearSelected[v] = true end
            end
        end
    end
})

GearShopSection:AddToggle("AutoBuyGear_1", {
    Title = "Tu Dong Mua Dung Cu",
    Default = false,
    Callback = function(v) Config.Shop.AutoBuyGear = v end
})

-- ============================================================
-- UI - CUA HANG CRATE
-- ============================================================
local CrateShopSection = ShopTab:AddSection("Cua Hang Crate")

CrateShopSection:AddDropdown("ShopCrates_1", {
    Title = "Chon Crate",
    Description = "Chon loai crate muon mua",
    Values = crateNames,
    Multi = true,
    Default = {}, 
    Callback = function(value)
        for _, n in ipairs(crateNames) do Config.Shop.CrateSelected[n] = false end
        if type(value) == "table" then
            for k, v in pairs(value) do
                if type(k) == "string" and v == true then Config.Shop.CrateSelected[k] = true
                elseif type(v) == "string" then Config.Shop.CrateSelected[v] = true end
            end
        end
    end
})

CrateShopSection:AddToggle("AutoBuyCrate_1", {
    Title = "Tu Dong Mua Crate",
    Default = false,
    Callback = function(v) Config.Shop.AutoBuyCrate = v end
})

-- ============================================================
-- TAB SETTING - THAY ĐỔI MÀU GIAO DIỆN
-- ============================================================



-- ============================================================
-- DANH SÁCH MÀU
-- ============================================================
local Themes = {
    "Rose",
    "Midnight",
    "Forest",
    "Sunset",
    "Ocean",
    "Emerald",
    "Sapphire",
    "Cloud",
    "Dark",
    "Darker",
    "AMOLED",
    "Light",
    "Balloon",
    "Soft Cream",
    "Aqua",
    "Amethyst"
}

-- ============================================================
-- SECTION: GIAO DIEN
-- ============================================================
local ThemeSection = SettingTab:AddSection("Giao Dien")

ThemeSection:AddDropdown("ThemeSelect_1", {
    Title = "Chon Mau Giao Dien",
    Description = "Thay doi mau sac cua menu",
    Values = Themes,
    Multi = false,
    Default = "Darker",
    Callback = function(value)
        if value and #value > 0 then
            local theme = value[1]
            Fluent:SetTheme(theme)
            Fluent:Notify({
                Title = "Giao Dien",
                Content = "Da doi mau sang: " .. theme,
                Duration = 2
            })
        end
    end
})

-- ============================================================
-- NÚT RESET VỀ MẶC ĐỊNH
-- ============================================================
ThemeSection:AddButton({
    Title = "Reset Ve Mac Dinh",
    Description = "Quay ve mau Darker mac dinh",
    Callback = function()
        Fluent:SetTheme("Darker")
        Fluent:Notify({
            Title = "Giao Dien",
            Content = "Da reset ve mau mac dinh!",
            Duration = 2
        })
    end
})

-- ============================================================
-- TAB GIẢM LAG - 6 CẤP ĐỘ
-- ============================================================



-- ============================================================
-- CONFIG GIẢM LAG
-- ============================================================
local LagLevel = 0
local OriginalSettings = {}

-- ============================================================
-- HÀM LƯU CÀI ĐẶT GỐC
-- ============================================================
local function saveOriginalSettings()
    OriginalSettings = {
        Brightness = Lighting.Brightness,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        MaterialColors = {},
        Textures = {}
    }
end

-- ============================================================
-- HÀM KHÔI PHỤC CÀI ĐẶT GỐC
-- ============================================================
local function restoreSettings()
    if OriginalSettings.Brightness then
        Lighting.Brightness = OriginalSettings.Brightness
    end
    if OriginalSettings.GlobalShadows ~= nil then
        Lighting.GlobalShadows = OriginalSettings.GlobalShadows
    end
    if OriginalSettings.FogEnd then
        Lighting.FogEnd = OriginalSettings.FogEnd
    end
    if OriginalSettings.FogStart then
        Lighting.FogStart = OriginalSettings.FogStart
    end
end

-- ============================================================
-- HÀM ÁP DỤNG GIẢM LAG THEO CẤP
-- ============================================================
local function applyLagLevel(level)
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    
    -- Lưu cài đặt gốc lần đầu
    if level == 1 and not OriginalSettings.Brightness then
        saveOriginalSettings()
    end
    
    if level == 0 then
        -- Khôi phục hoàn toàn
        restoreSettings()
        if Terrain then
            Terrain.MaterialColors = OriginalSettings.MaterialColors or {}
        end
        -- Hiện lại tất cả vật thể
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency == 1 then
                obj.Transparency = 0
            end
        end
        Fluent:Notify({ Title = "Giam Lag", Content = "Da tat giam lag!", Duration = 2 })
        return
    end
    
    local brightnessValues = { 1, 0.8, 0.6, 0.4, 0.25, 0.1 }
    local shadowValues = { true, true, false, false, false, false }
    local fogValues = { 10000, 5000, 2000, 1000, 500, 200 }
    local transparencyValues = { 0, 0, 0.5, 0.8, 0.95, 1 }
    
    local idx = level
    
    -- Ánh sáng
    Lighting.Brightness = brightnessValues[idx]
    Lighting.GlobalShadows = shadowValues[idx]
    Lighting.FogEnd = fogValues[idx]
    Lighting.FogStart = fogValues[idx] / 2
    
    -- Cấp 6: Mặt đất màu xám
    if level >= 6 and Terrain then
        local gray = Color3.fromRGB(128, 128, 128)
        local mats = Terrain.MaterialColors
        if not OriginalSettings.MaterialColors or #OriginalSettings.MaterialColors == 0 then
            OriginalSettings.MaterialColors = {}
            for name, color in pairs(mats) do
                OriginalSettings.MaterialColors[name] = color
            end
        end
        for name, _ in pairs(mats) do
            mats[name] = gray
        end
    end
    
    -- Làm trong suốt vật thể
    if level >= 3 then
        local trans = transparencyValues[idx]
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsA("Terrain") then
                -- Giữ lại mặt đất để đứng (HumanoidRootPart, Baseplate, Ground)
                local name = obj.Name:lower()
                local isGround = name:find("ground") or name:find("baseplate") or 
                                name:find("floor") or name:find("plot") or
                                name:find("plantarea") or name:find("plant")
                
                if not isGround or level < 6 then
                    obj.Transparency = trans
                end
            end
        end
    end
    
    -- Cấp 6: Giữ lại mặt bằng để đứng và di chuyển
    if level >= 6 then
        -- Đảm bảo HumanoidRootPart không bị ẩn
        local char = game:GetService("Players").LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
        -- Giữ lại PlantArea và Plot
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("plot") or name:find("plantarea") or name:find("garden") then
                    obj.Transparency = 0
                end
            end
        end
    end
    
    Fluent:Notify({ Title = "Giam Lag", Content = "Da ap dung cap do: x" .. level, Duration = 2 })
end

-- ============================================================
-- SERVICES
-- ============================================================
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

-- ============================================================
-- SECTION: GIẢM LAG
-- ============================================================
local LagSection = LagTab:AddSection("Giam Lag")

LagSection:AddParagraph({
    Title = "Chon Cap Do Giam Lag",
    Content = "x0: Khong giam lag\n"
        .. "x1: Giam nhe (giam sang + suong mu)\n"
        .. "x2: Giam vua (tat bong + giam suong mu)\n"
        .. "x3: Giam kha (an 50% vat the + giam sang)\n"
        .. "x4: Giam manh (an 80% vat the + toi)\n"
        .. "x5: Giam rat manh (an 95% vat the + rat toi)\n"
        .. "x6: Giam toi da (an toan bo vat the + mat dat xam + giu mat bang di chuyen)"
})

LagSection:AddDropdown("LagLevel_1", {
    Title = "Cap Do Giam Lag",
    Description = "Chon muc do giam lag",
    Values = {"x0 (Tat)", "x1 (Nhe)", "x2 (Vua)", "x3 (Kha)", "x4 (Manh)", "x5 (Rat Manh)", "x6 (Toi Da)"},
    Multi = false,
    Default = "x0 (Tat)",
    Callback = function(value)
        if value and #value > 0 then
            local choice = value[1]
            local level = tonumber(choice:match("x(%d)")) or 0
            LagLevel = level
            applyLagLevel(level)
        end
    end
})

-- ============================================================
-- NÚT TẮT NHANH
-- ============================================================
LagSection:AddButton({
    Title = "Tat Giam Lag (x0)",
    Description = "Khoi phuc tat ca ve mac dinh",
    Callback = function()
        LagLevel = 0
        applyLagLevel(0)
    end
})

LagSection:AddButton({
    Title = "Giam Lag Toi Da (x6)",
    Description = "Giam lag toi da, giu mat bang di chuyen",
    Callback = function()
        LagLevel = 6
        applyLagLevel(6)
    end
})


