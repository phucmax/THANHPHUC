--getgenv().team = "Marines" -- Change to "Pirates" if preferred
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- =================== UI (Inserted only â€” no functional changes) ===================
-- This UI is non-invasive: it only provides buttons that call existing functions in the script.
-- It does NOT change any logic on load and does not reset script flags automatically.
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("PHUCMAX_UI_CHEST4") then
        CoreGui.PHUCMAX_UI_CHEST4:Destroy()
    end

    local UI_BG_IMAGE = "rbxassetid://89799706653949"
    local BTN_BG_IMAGE = "rbxassetid://89799706653949"
    local TOGGLE_IMAGE = "rbxassetid://89799706653949"
    local THEME_COLOR = Color3.fromRGB(140, 0, 255)

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
    Title.Text = "Auto Cyborg - PHUCMAX"
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
    local ResetBtn, _ = Button("REFRESH INFO", UDim2.new(0,260,0,50))

    Toggle.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
        Toggle.Visible = true
    end)

    StartBtn.MouseButton1Click:Connect(function()
        pcall(function()
            _G.AutoCollectChest = true
            _G.IsChestFarming = true
            -- Do not change other flags â€” just call the existing function to start
            if type(AutoChestCollect) == "function" then
                pcall(AutoChestCollect)
            end
        end)
    end)

    StopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            _G.AutoCollectChest = false
            _G.IsChestFarming = false
            _G.StopTween = true
            _G.StopTween2 = true
        end)
    end)

    ToggleCollectBtn.MouseButton1Click:Connect(function()
        pcall(function()
            _G.AutoCollectChest = not _G.AutoCollectChest
            _G.IsChestFarming = _G.AutoCollectChest and true or false
            if _G.AutoCollectChest and type(AutoChestCollect) == "function" then
                pcall(AutoChestCollect)
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
            end
        end)
    end)

    ResetBtn.MouseButton1Click:Connect(function()
        -- Refresh Info display only (no state changes)
        pcall(function()
            local beli = 0
            if game.Players.LocalPlayer:FindFirstChild("Data") and game.Players.LocalPlayer.Data:FindFirstChild("Beli") then
                beli = game.Players.LocalPlayer.Data.Beli.Value
            end
            Info.Text = "Money : "..tostring(beli).."\nTime : 00:00:00\nState : "..( _G.AutoCollectChest and "Farming" or "Stopped")
        end)
    end)

    -- Info updater (harmless)
    spawn(function()
        local startTime = tick()
        while task.wait(0.5) do
            pcall(function()
                local beli = 0
                if game.Players.LocalPlayer:FindFirstChild("Data") and game.Players.LocalPlayer.Data:FindFirstChild("Beli") then
                    beli = game.Players.LocalPlayer.Data.Beli.Value
                end
                local t = 0
                if _G.IsChestFarming then t = math.floor(tick() - startTime) end
                local hours = math.floor(t / 3600) % 24
                local mins  = math.floor(t / 60) % 60
                local secs  = t % 60
                local state = _G.AutoCollectChest and (_G.IsChestFarming and "Farming" or "Idle") or "Stopped"
                Info.Text = "Money : "..tostring(beli).."\nTime : "..string.format("%02d:%02d:%02d", hours, mins, secs).."\nState : "..state
            end)
        end
    end)
end)

-- =================== END UI INSERTION ===================

-- Reliable team selection method
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
    repeat
        wait()
        local l_Remotes_0 = game.ReplicatedStorage:WaitForChild("Remotes")
        l_Remotes_0.CommF_:InvokeServer("SetTeam", getgenv().team)
        task.wait(3)
    until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)")
end


-- Global Variables
_G.AutoCollectChest = true
_G.CancelTween2 = false
_G.StopTween = false
_G.StopTween2 = false
_G.AutoRejoin = true
_G.starthop = true
_G.AutoHopEnabled = true
_G.LastPosition = nil
_G.LastTimeChecked = tick()
_G.LastChestCollectedTime = tick()
_G.AutoJump = true -- Flag to control auto jump
_G.Antikick = true
_G.AutoFightDarkbeard = nil
_G.FightDarkbeardOnlyWithFist = nil
_G.IsFightingBoss = false
_G.AutoCyborg = nil
_G.IsFightingCyborgBoss = false
_G.NeedCoreBrain = true -- Added to track Core Brain requirement
_G.HasCoreBrain = false -- Added to track if player has Core Brain
_G.HasFistOfDarkness = false -- Added to track if player has Fist of Darkness
_G.IsChestFarming = false
_G.IsCheckingForCoreBrain = false
_G.MicrochipPurchased = false -- Track if microchip has been purchased
_G.KeyDetected = false -- Added to track if key is detected
_G.FistDetected = false -- Added to track if Fist of Darkness is detected
_G.ClickAttempts = 0
_G.LastClickTime = 0
_G.ClickCooldown = 2 -- Cooldown 2 giĂ¢y giá»¯a cĂ¡c láº§n click
_G.MicrochipNotFound = false -- Flag Ä‘á»ƒ theo dĂµi thĂ´ng bĂ¡o "Microchip not found"
TweenSpeed = 350


-- Load external scripts
spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mizuharasup/autobonuty/refs/heads/main/all.txt"))()
    end)
end)

spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mizuharasup/autobonuty/refs/heads/main/zder.lua"))()
    end)
end)

-- Apply FPS Boost Function
local function ApplyFPSBoost()
    -- Use pcall for all operations to avoid errors
    
    -- Remove graphic effects in Lighting
    pcall(function()
        for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") 
                or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
    end)
    
    -- Remove FantasySky if present
    pcall(function()
        if game:GetService("Lighting"):FindFirstChild("FantasySky") then
            game:GetService("Lighting").FantasySky:Destroy()
        end
    end)
    
    -- Adjust lighting
    pcall(function()
        local l = game:GetService("Lighting")
        l.GlobalShadows = false
        l.FogEnd = 9e9
        l.Brightness = 0
    end)
    
    -- Change graphic settings
    pcall(function()
        settings().Rendering.QualityLevel = "Level01"
    end)
    
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.Automatic
    end)
    
    -- Reduce volume
    pcall(function()
        UserSettings():GetService("UserGameSettings").MasterVolume = 0
    end)
    
    -- Safely adjust Terrain
    pcall(function()
        if workspace:FindFirstChild("Terrain") then
            local t = workspace.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
        end
    end)
    
    -- Disable graphic effects (Process only 3000 elements each time to avoid freezing)
    local descendantCount = 0
    local maxDescendants = 3000
    pcall(function()
        for _, v in pairs(game:GetDescendants()) do
            descendantCount = descendantCount + 1
            if descendantCount > maxDescendants then break end
            
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
                v.Enabled = false
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            elseif v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
                v.TextureID = 10385902758728957
            end
        end
    end)
    
    -- Notification of completion
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "FPS Boost",
            Text = "Graphics reduced successfully!",
            Duration = 5
        })
    end)
end
-- WhiteScreen function - Táº¯t/báº­t render 3D Ä‘á»ƒ tÄƒng FPS
function ToggleWhiteScreen(enable)
    getgenv().Setting.WhiteScreen = enable
    
    if enable then
        -- Táº¯t render 3D khi báº­t WhiteScreen
        game:GetService("RunService"):Set3dRenderingEnabled(false)
        
        -- ThĂ´ng bĂ¡o cho ngÆ°á»i chÆ¡i
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "WhiteScreen",
            Text = "ÄĂ£ báº­t cháº¿ Ä‘á»™ WhiteScreen Ä‘á»ƒ tÄƒng FPS",
            Duration = 3
        })
    else
        -- Báº­t láº¡i render 3D khi táº¯t WhiteScreen
        game:GetService("RunService"):Set3dRenderingEnabled(true)
        
        -- ThĂ´ng bĂ¡o cho ngÆ°á»i chÆ¡i
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "WhiteScreen",
            Text = "ÄĂ£ táº¯t cháº¿ Ä‘á»™ WhiteScreen",
            Duration = 3
        })
    end
end

-- ThĂªm pháº§n theo dĂµi thay Ä‘á»•i cĂ i Ä‘áº·t WhiteScreen
spawn(function()
    local lastWhiteScreenSetting = getgenv().Setting.WhiteScreen
    
    while wait(1) do
        -- Kiá»ƒm tra náº¿u cĂ i Ä‘áº·t Ä‘Ă£ thay Ä‘á»•i
        if getgenv().Setting.WhiteScreen ~= lastWhiteScreenSetting then
            lastWhiteScreenSetting = getgenv().Setting.WhiteScreen
        end
    end
end)

-- Khá»Ÿi táº¡o cĂ i Ä‘áº·t WhiteScreen ban Ä‘áº§u
-- Implement FPS Boost
ApplyFPSBoost()

-- Continue to run every minute (to reduce new graphics)
spawn(function()
    while wait(60) do
        pcall(ApplyFPSBoost)
    end
end)

-- No Collision
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.AutoCollectChest or _G.IsFightingBoss or _G.IsFightingCyborgBoss then
                pcall(function()
                    local character = game:GetService("Players").LocalPlayer.Character
                    for _, descendant in pairs(character:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            descendant.CanCollide = false
                        end
                    end
                end)
            end
        end)
    end)
end)

-- Safe Tween function with error handling
function SafeTween(targetCF, speed)
    local success, result = pcall(function()
        if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return nil, "Character or HumanoidRootPart not found"
        end
        
        local Distance = (targetCF.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        local actualSpeed = speed or TweenSpeed
        local tweenInfo = TweenInfo.new(Distance / actualSpeed, Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, {
            CFrame = targetCF
        })
        tween:Play()
        return tween, Distance / actualSpeed
    end)
    
    if success then
        return result
    else
        return nil, 0
    end
end
-- HĂ m chá»‘ng rÆ¡i vĂ  NoClip
function EnableNoClipAndAntiGravity()
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        if not character then return end
        
        -- NoClip cho táº¥t cáº£ cĂ¡c part
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Anti-gravity
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- XĂ³a BodyVelocity cÅ© náº¿u cĂ³
            for _, child in pairs(hrp:GetChildren()) do
                if child:IsA("BodyVelocity") and child.Name == "ChestFarmAntiGravity" then
                    child:Destroy()
                end
            end
            
            -- Táº¡o BodyVelocity má»›i
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "ChestFarmAntiGravity"
            bodyVel.MaxForce = Vector3.new(0, 9999, 0)
            bodyVel.Velocity = Vector3.new(0, 0.5, 0) -- Äáº©y nháº¹ lĂªn trĂªn
            bodyVel.P = 1500 -- Lá»±c máº¡nh Ä‘á»ƒ chá»‘ng rÆ¡i tá»‘t hÆ¡n
            bodyVel.Parent = hrp
            
            -- Chá»‘ng tráº¡ng thĂ¡i Stun
            if character:FindFirstChild("Stun") then
                character.Stun.Value = 0
            end
            
            -- Chá»‘ng rÆ¡i
            if character:FindFirstChild("Humanoid") then
                character.Humanoid:ChangeState(11)
                character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end
    end)
end
-- HĂ m Tween2 giá»¯ nguyĂªn tá»« code cÅ©
function Tween2(targetCFrame)
    -- Äáº£m báº£o NoClip vĂ  anti-gravity Ä‘Æ°á»£c kĂ­ch hoáº¡t
    EnableNoClipAndAntiGravity()
    
    -- Táº¡o tween má»›i
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local distance = (targetCFrame.Position - character.HumanoidRootPart.Position).Magnitude
        local speed = 350 -- Tá»‘c Ä‘á»™ bay
        
        -- Táº¡o tween info vá»›i easing style smooth
        local tweenInfo = TweenInfo.new(
            distance / speed,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            0, -- Sá»‘ láº§n láº·p láº¡i (0 = khĂ´ng láº·p)
            false, -- Äáº£o ngÆ°á»£c
            0 -- Delay trÆ°á»›c khi báº¯t Ä‘áº§u
        )
        
        -- Táº¡o vĂ  cháº¡y tween
        local tween = game:GetService("TweenService"):Create(
            character.HumanoidRootPart,
            tweenInfo,
            {CFrame = targetCFrame}
        )
        
        -- ÄÄƒng kĂ½ sá»± kiá»‡n khi tween hoĂ n thĂ nh
        tween.Completed:Connect(function()
            -- KĂ­ch hoáº¡t láº¡i NoClip vĂ  anti-gravity sau khi tween hoĂ n thĂ nh
            EnableNoClipAndAntiGravity()
        end)
        
        -- Cháº¡y tween
        tween:Play()
        
        -- Chá» tween hoĂ n thĂ nh (+ thĂªm 0.1s Ä‘á»ƒ Ä‘áº£m báº£o)
        wait(distance / speed + 0.1)
    end)
end
-- BKP function
function BKP(Point)
    pcall(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Point
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Point
        end
    end)
end

-- Tween function
function Tween(KG)
    pcall(function()
        if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local Distance = (KG.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        local Speed = TweenSpeed  
        local tweenInfo = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, {
            CFrame = KG
        })
        tween:Play()
        if _G.StopTween then
            tween:Cancel()
        end
    end)
end

-- EquipTool function
function EquipTool(ToolSe)
    pcall(function()
        if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
            local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
            wait()
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end)
end

-- Cancel Tween function
function CancelTween()
    _G.StopTween = true
    wait()
    pcall(function()
        Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
    end)
    wait()
    _G.StopTween = false
end

-- Equip function
function equip(tooltip)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then return false end
    
    -- Check Backpack
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltip then
            humanoid:EquipTool(item)
            return true
        end
    end
    
    -- Check if already equipped
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltip then
            return true -- Already equipped
        end
    end
    
    return false
end

-- AutoHaki function
function AutoHaki()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and not player.Character:FindFirstChild("HasBuso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

-- Cáº£i tiáº¿n hĂ m kiá»ƒm tra tá»™c Cyborg Ä‘á»ƒ Ä‘Ă¡ng tin cáº­y hÆ¡n
function isCyborg()
    local success, result = pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local playerRace = player.Data.Race.Value
        return playerRace == "Cyborg"
    end)
    
    if success and result then
        -- Náº¿u Ä‘Ă£ cĂ³ tá»™c Cyborg, táº¯t háº¿t má»i hoáº¡t Ä‘á»™ng
        _G.AutoCyborg = false
        _G.AutoCollectChest = false
        _G.IsChestFarming = false
        _G.IsFightingBoss = false
        _G.AutoJump = false
        
        -- ThĂ´ng bĂ¡o cho ngÆ°á»i chÆ¡i
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Auto Cyborg",
                Text = "Báº¡n Ä‘Ă£ cĂ³ tá»™c Cyborg! Script Ä‘Ă£ dá»«ng láº¡i.",
                Duration = 10
            })
        end)
        
        return true
    else
        return false
    end
end

-- Check for Core Brain in inventory
function hasCoreBrain()
    local player = game:GetService("Players").LocalPlayer
    
    -- Check backpack
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == "Core Brain" then
            -- Immediately disable auto chest when Core Brain is found
            _G.AutoCollectChest = false
            _G.IsChestFarming = false
            _G.HasCoreBrain = true
            _G.NeedCoreBrain = false
            _G.AutoJump = false
            
            return true
        end
    end
    
    -- Check equipped items
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item.Name == "Core Brain" then
                -- Immediately disable auto chest when Core Brain is found
                _G.AutoCollectChest = false
                _G.IsChestFarming = false
                _G.HasCoreBrain = true
                _G.NeedCoreBrain = false
                _G.AutoJump = false
                
                
                return true
            end
        end
    end
    
    return false
end

-- Equip Core Brain if in inventory
function equipCoreBrain()
    local player = game:GetService("Players").LocalPlayer
    
    -- Check backpack
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == "Core Brain" then
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:EquipTool(item)
                return true
            end
        end
    end
    
    -- Check if already equipped
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item.Name == "Core Brain" then
                return true
            end
        end
    end
    
    return false
end
function hasFistOfDarkness()
    local player = game:GetService("Players").LocalPlayer
    
    -- Check backpack
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == "Fist of Darkness" then
            if not _G.FistDetected then
                _G.FistDetected = true
                _G.HasFistOfDarkness = true
                _G.AutoJump = false
                _G.AutoCollectChest = false
                _G.IsChestFarming = false
                
                -- Notification and click detector
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Fist of Darkness Found",
                    Text = "Auto chest collection stopped. Processing...",
                    Duration = 10
                })
                
                -- Process Fist of Darkness
                processFistOfDarkness()
            end
            return true
        end
    end
    
    -- Check character
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item.Name == "Fist of Darkness" then
                if not _G.FistDetected then
                    _G.FistDetected = true
                    _G.HasFistOfDarkness = true
                    _G.AutoJump = false
                    _G.AutoCollectChest = false
                    _G.IsChestFarming = false
                    
                    -- Process Fist of Darkness
                    processFistOfDarkness()
                end
                return true
            end
        end
    end
    
    return false
end

-- Check for Microchip in inventory
function hasMicrochip()
    local player = game:GetService("Players").LocalPlayer
    local hasMicrochipInInventory = false
    
    -- Check backpack
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == "Microchip" then
            hasMicrochipInInventory = true
            break
        end
    end
    
    -- Check equipped items
    if not hasMicrochipInInventory and player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item.Name == "Microchip" then
                hasMicrochipInInventory = true
                break
            end
        end
    end
    
    return hasMicrochipInInventory
end

-- Buy Microchip function
function buyMicrochip()
    -- Check if player already has a microchip or already purchased one
    if hasMicrochip() then
        return true
    end
    
    if _G.MicrochipPurchased then
        if hasMicrochip() then
            return true
        else
            -- Reset the flag if we still don't have the microchip
            _G.MicrochipPurchased = false
        end
    end
    
    -- Buy microchip
    local args = { [1] = "BlackbeardReward", [2] = "Microchip", [3] = "2" }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    
    -- Set flag to indicate purchase attempt
    _G.MicrochipPurchased = true
    
    -- Verify purchase was successful
    wait(1)
    if hasMicrochip() then
        return true
    else
        return false
    end
end

-- Buy Cyborg race function
function buyCyborgRace()
    local args = { [1] = "CyborgTrainer", [2] = "Buy" }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    
    -- Verify purchase was successful
    wait(2)
    if isCyborg() then
        _G.AutoCyborg = false
        _G.AutoCollectChest = false
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Cyborg",
            Text = "Successfully obtained Cyborg race!",
            Duration = 10
        })
        return true
    else
        return false
    end
end

-- Core Brain position
local coreBrainPosition = CFrame.new(-6059.92236, 15.9929152, -5088.71289, -0.726370811, 3.41200179e-09, 0.687303007, 5.61764901e-09, 1, 9.72634195e-10, -0.687303007, 4.56752014e-09, -0.726370811)

-- Check if boss exists
function bossExists()
    return workspace.Enemies:FindFirstChild("Order") ~= nil
end

-- Find boss function
function findBoss()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Order" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    
    return nil
end

-- Find the button's ClickDetector (Improved)
function findClickDetector()
    local success, result = pcall(function()
        -- Try to get the exact path from workspace
        local button = workspace:FindFirstChild("Map")
        if button then
            button = button:FindFirstChild("CircleIsland")
            if button then
                button = button:FindFirstChild("RaidSummon")
                if button then
                    button = button:FindFirstChild("Button")
                    if button then
                        button = button:FindFirstChild("Main")
                        if button then
                            local detector = button:FindFirstChild("ClickDetector")
                            if detector then
                                return detector, button.Position
                            end
                        end
                    end
                end
            end
        end
        
        -- Alternative search method if direct path fails
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ClickDetector" and v.Parent and v.Parent.Name == "Main" and 
               v.Parent.Parent and v.Parent.Parent.Name == "Button" and
               v.Parent.Parent.Parent and v.Parent.Parent.Parent.Name == "RaidSummon" then
                return v, v.Parent.Position
            end
        end
        
        return nil, nil
    end)
    
    if success then
        return result
    else
        return nil, nil
    end
end

-- Check if player is close to button
function isPlayerCloseToButton(buttonPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end

    if not buttonPosition then
        return false
    end
    
    local playerPosition = character.HumanoidRootPart.Position
    local distance = (buttonPosition - playerPosition).Magnitude
    
    -- Most ClickDetectors have a range between 10-32 studs
    return distance <= 32
end

-- Teleport to button
function teleportToButton(buttonPosition)
    if not buttonPosition then
        return false
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    -- Teleport near the button
    pcall(function()
        character.HumanoidRootPart.CFrame = CFrame.new(buttonPosition) + Vector3.new(0, 2, 0)
    end)
    wait(0.5) -- Wait for teleport to complete
    return true
end

-- Start NoClip function
function startNoClip()
    pcall(function()
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Anti-gravity to prevent falling
        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiGravity") then
                local ag = Instance.new("BodyVelocity")
                ag.Name = "AntiGravity"
                ag.MaxForce = Vector3.new(0, 9999, 0)
                ag.Velocity = Vector3.new(0, 0.1, 0)
                ag.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            end
        end
    end)
end
-- ThĂªm biáº¿n Ä‘á»ƒ theo dĂµi thá»i gian click gáº§n nháº¥t
_G.LastClickTime = 0
_G.ClickCooldown = 2 -- Cooldown 2 giĂ¢y giá»¯a cĂ¡c láº§n click
_G.MicrochipNotFound = false -- Flag Ä‘á»ƒ theo dĂµi thĂ´ng bĂ¡o "Microchip not found"

function clickDetectorForNotification()
    -- Kiá»ƒm tra cooldown
    local currentTime = tick()
    if currentTime - _G.LastClickTime < _G.ClickCooldown then
        return false
    end
    
    -- Cáº­p nháº­t thá»i gian click gáº§n nháº¥t
    _G.LastClickTime = currentTime
    
    local detector, buttonPosition = findClickDetector()
    
    if not detector then
        return false
    end
    
    -- Make sure player is close enough to click
    if not isPlayerCloseToButton(buttonPosition) and buttonPosition then
        teleportToButton(buttonPosition)
        wait(1) -- Wait after teleport
    end
    
    -- Chá»‰ click 2 láº§n thĂ´i Ä‘á»ƒ trĂ¡nh spam
    pcall(function() fireclickdetector(detector) end)
    wait(0.3)
    pcall(function() fireclickdetector(detector) end)
    
    return true
end

-- Khá»Ÿi táº¡o mĂ´i trÆ°á»ng khi script báº¯t Ä‘áº§u
spawn(function()
    -- Äá»£i 5 giĂ¢y Ä‘á»ƒ Ä‘áº£m báº£o game Ä‘Ă£ táº£i xong
    wait(5)
    
    -- Khá»Ÿi táº¡o chá»©c nÄƒng theo dĂµi chat vĂ  GUI
    setupChatMonitoring()
    setupGUIMonitoring()
    
    -- Khá»Ÿi Ä‘á»™ng chá»©c nÄƒng AutoChestCollect náº¿u Ä‘Æ°á»£c báº­t
    if _G.AutoCollectChest then
        AutoChestCollect()
    end
    
    -- Debug info khi khá»Ÿi Ä‘á»™ng
end)

function handleNotifications(message)
    if string.find(message, "Microchip not found") then
        
        -- Äáº·t láº¡i cĂ¡c cá»
        _G.MicrochipNotFound = true
        _G.AutoCollectChest = true
        _G.IsChestFarming = true
        _G.IsFightingBoss = false
        
        -- Äáº£m báº£o khĂ´ng cĂ³ cá» nĂ o Ä‘ang cháº·n AutoCollectChest
        _G.StopTween = false
        _G.StopTween2 = false
        _G.CancelTween2 = false
        
        -- Khá»Ÿi Ä‘á»™ng láº¡i auto chest collect náº¿u nĂ³ Ä‘ang khĂ´ng cháº¡y
        if not _G.IsChestFarming then
            farmChestsForFistOfDarkness()
        end
        
        -- Khá»Ÿi Ä‘ï¿½ï¿½ng láº¡i chest collection ngay láº­p tá»©c
        spawn(function()
            wait(1) -- Äá»£i 1 giĂ¢y Ä‘á»ƒ cĂ¡c thĂ´ng bĂ¡o xá»­ lĂ½ xong
            AutoChestCollect()
        end)
        
        return true
    elseif string.find(message, "Core Brain") then
        -- Táº¯t AutoCollectChest khi phĂ¡t hiá»‡n Core Brain
        _G.AutoCollectChest = false
        _G.IsChestFarming = false
        _G.HasCoreBrain = true
        _G.NeedCoreBrain = false
        _G.AutoJump = false
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Core Brain Detected",
            Text = "Tiáº¿n hĂ nh mua tá»™c Cyborg",
            Duration = 5
        })
        
        -- Táº¯t AutoCollectChest khi phĂ¡t hiá»‡n Core Brain
        equipCoreBrain()
        
        -- Click detector
        clickDetectorForNotification()
        wait(5)  -- Chá» 5 giĂ¢y
        
        -- Mua tá»™c Cyborg
        buyCyborgRace()
        
        return true
    end
    
    return false
end

-- Cáº­p nháº­t hĂ m monitor GUI text
local function checkGUI(gui)
    pcall(function()
        if (gui:IsA("TextLabel") or gui:IsA("TextButton")) and gui.Visible and _G.AutoCyborg then
            if gui.Text then
                handleNotifications(gui.Text)
            end
        end
    end)
end

-- Cáº­p nháº­t hĂ m monitor chat messages
function setupChatMonitoring()
    pcall(function()
        if game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") then
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
                if data.Message then
                    if string.find(data.Message, "Microchip not found") then
                        handleNotifications("Microchip not found")
                    elseif string.find(data.Message, "Core Brain") then
                        handleNotifications("Core Brain")
                    end
                end
            end)
        end
    end)
end
function setupGUIMonitoring()
    pcall(function()
        local function checkGUI(gui)
            if (gui:IsA("TextLabel") or gui:IsA("TextButton")) and gui.Visible and _G.AutoCyborg then
                if gui.Text then
                    if string.find(gui.Text, "Microchip not found") then
                        handleNotifications("Microchip not found")
                    elseif string.find(gui.Text, "Core Brain") then
                        handleNotifications("Core Brain")
                    end
                end
            end
        end
        
        -- Kiá»ƒm tra GUI hiá»‡n táº¡i
        for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
            checkGUI(gui)
        end
        
        -- Theo dĂµi GUI má»›i
        game.Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                checkGUI(descendant)
                
                pcall(function()
                    descendant:GetPropertyChangedSignal("Text"):Connect(function()
                        checkGUI(descendant)
                    end)
                    
                    descendant:GetPropertyChangedSignal("Visible"):Connect(function()
                        checkGUI(descendant)
                    end)
                end)
            end
        end)
    end)
end
-- Cáº­p nháº­t hĂ m fightBoss Ä‘á»ƒ bay tá»›i boss thay vĂ¬ teleport
function fightBoss()
    if _G.IsFightingBoss then
        return
    end
    
    _G.IsFightingBoss = true
    
    -- Start NoClip
    startNoClip()
    
    -- Enable Haki and equip weapon
    AutoHaki()
    equip("Melee")
    
    spawn(function()
        local attackCooldown = 0
        
        while _G.IsFightingBoss do
            -- Re-enable Haki periodically
            AutoHaki()
            
            if tick() - attackCooldown > 2 then
                equip("Melee")
                attackCooldown = tick()
            end
            
            -- Find boss
            local boss = findBoss()
            
            if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                -- Check player health - if below 2000, fly 100 units above boss
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                
                if humanoid and humanoid.Parent and humanoid.Health < 2000 then
                    -- Turn off chest collection
                    _G.AutoCollectChest = false
                    
                    -- Get boss position
                    local bossPosition = boss.HumanoidRootPart.Position
                    -- Fly higher position (100 units above boss)
                    local higherPos = CFrame.new(
                        bossPosition.X, 
                        bossPosition.Y + 100, 
                        bossPosition.Z
                    )
                    
                    -- Fly to higher position (khĂ´ng teleport)
                    pcall(function()
                        Tween(higherPos)
                    end)
                    
                    -- Wait until health recovers to 5000
                    while humanoid and humanoid.Health < 5000 do
                        -- Keep updating position to stay above boss
                        local currentBoss = findBoss()
                        if currentBoss and currentBoss:FindFirstChild("HumanoidRootPart") then
                            local currentBossPos = currentBoss.HumanoidRootPart.Position
                            local newHigherPos = CFrame.new(
                                currentBossPos.X,
                                currentBossPos.Y + 100,
                                currentBossPos.Z
                            )
                            pcall(function()
                                Tween(newHigherPos)
                            end)
                        end
                        wait(0.5)
                    end
                else
                    -- Move to boss position (slightly above the boss)
                    local bossPosition = boss.HumanoidRootPart.Position
                    local targetPos = CFrame.new(
                        bossPosition.X, 
                        bossPosition.Y + 25, 
                        bossPosition.Z
                    )
                    
                    -- Fly to boss position (khĂ´ng teleport)
                    pcall(function()
                        Tween(targetPos)
                    end)
                    
                    -- Face the boss
                    pcall(function()
                        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                                game.Players.LocalPlayer.Character.HumanoidRootPart.Position,
                                Vector3.new(boss.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, boss.HumanoidRootPart.Position.Z)
                            )
                        end
                    end)
                    
                    -- Attack
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))
                end
            elseif not boss then
                -- Check if boss is defeated
                _G.IsFightingBoss = false
                
                -- Wait a bit
                wait(1)
                
                -- Check if player has Core Brain after boss fight
                if hasCoreBrain() then
                    _G.HasCoreBrain = true
                    _G.NeedCoreBrain = false
                    _G.AutoCollectChest = false -- Táº¯t AutoCollectChest khi cĂ³ Core Brain
                    _G.IsChestFarming = false   -- Äáº£m báº£o táº¯t hoĂ n toĂ n farm rÆ°Æ¡ng
                    _G.starthop = false         -- Táº¯t auto hop
                    _G.AutoHopEnabled = false   -- Táº¯t auto hop
                    
                    -- ThĂ´ng bĂ¡o tĂ¬m tháº¥y Core Brain
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Core Brain",
                        Text = "ÄĂ£ tĂ¬m tháº¥y Core Brain! Äang mua tá»™c Cyborg...",
                        Duration = 5
                    })
                    
                    -- Equip Core Brain
                    equipCoreBrain()
                    
                    -- Click detector for notification
                    clickDetectorForNotification()
                    wait(5)  -- Wait 5 seconds
                    
                    -- Buy Cyborg race
                    buyCyborgRace()
                    
                    -- Kiá»ƒm tra xem Ä‘Ă£ mua Ä‘Æ°á»£c chÆ°a
                    wait(2)
                    if isCyborg() then
                        _G.AutoCyborg = false
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Success",
                            Text = "ÄĂ£ mua thĂ nh cĂ´ng tá»™c Cyborg! (láº§n thá»­)",
                            Duration = 10
                        })
                    else

                        clickDetectorForNotification()
                        wait(1)
                        buyCyborgRace()
                    end
                else
                    -- Reset microchip purchased flag
                    _G.MicrochipPurchased = false
                    
                    -- Kiá»ƒm tra Fist of Darkness
                    if hasFistOfDarkness() then
                        -- ThĂ´ng bĂ¡o cho ngÆ°á»i chÆ¡i
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Fist of Darkness",
                            Text = "ÄĂ£ cĂ³ Fist of Darkness, Ä‘ang mua Microchip...",
                            Duration = 5
                        })
                        
                        -- Táº¯t táº¡m thá»i farm rÆ°Æ¡ng trong khi mua microchip
                        _G.AutoCollectChest = false
                        _G.IsChestFarming = false
                        
                        -- Click detector Ä‘á»ƒ thá»­ láº¡i
                        clickDetectorForNotification()
                        wait(1)
                        
                        -- Kiá»ƒm tra vĂ  mua microchip (thá»­ 3 láº§n)
                        if not hasMicrochip() then
                            for i = 1, 3 do
                                buyMicrochip()
                                wait(1)
                                if hasMicrochip() then
                                    game:GetService("StarterGui"):SetCore("SendNotification", {
                                        Title = "Microchip",
                                        Text = "ÄĂ£ mua thĂ nh cĂ´ng Microchip!",
                                        Duration = 3
                                    })
                                    break
                                end
                            end
                        end
                        
                        -- Spawn boss náº¿u cĂ³ microchip
                        if hasMicrochip() then
                            clickToSpawnBoss()
                        else
                            -- Náº¿u khĂ´ng thá»ƒ mua microchip, báº­t láº¡i farm rÆ°Æ¡ng
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Lá»—i",
                                Text = "KhĂ´ng thá»ƒ mua Microchip! Tiáº¿p tá»¥c farm rÆ°Æ¡ng...",
                                Duration = 5
                            })
                            _G.AutoCollectChest = true
                            _G.IsChestFarming = true
                        end
                    else
                        -- Náº¿u khĂ´ng cĂ³ Fist of Darkness, báº­t láº¡i AutoCollectChest
                        _G.AutoCollectChest = true
                        _G.IsChestFarming = true
                    end
                end
                
                -- Sá»­a pháº§n cuá»‘i cá»§a hĂ m fightBoss()
-- ThĂªm pháº§n cĂ²n thiáº¿u sau dĂ²ng "break;"
                break
            end
            
            wait(0.1)
        end
    end)
end
-- Cáº­p nháº­t clickToSpawnBoss Ä‘á»ƒ bay Ä‘áº¿n boss
function clickToSpawnBoss()
    if _G.IsFightingBoss then return end
    
    -- Kiá»ƒm tra Fist of Darkness
    if hasFistOfDarkness() and not _G.FistDetected then
        _G.FistDetected = true
        _G.HasFistOfDarkness = true
        _G.AutoJump = false
    end
    
    -- Click detector trÆ°á»›c khi mua microchip
    clickDetectorForNotification()
    wait(1)
    
    -- Kiá»ƒm tra microchip trong inventory
    if not hasMicrochip() then
        buyMicrochip()
        wait(1)
    end
    
    -- Náº¿u cĂ³ microchip, spawn boss
    if hasMicrochip() then
        local detector, buttonPosition = findClickDetector()
        if detector then
            -- Äáº£m báº£o ngÆ°á»i chÆ¡i Ä‘á»§ gáº§n Ä‘á»ƒ click
            if not isPlayerCloseToButton(buttonPosition) and buttonPosition then
                teleportToButton(buttonPosition)
                wait(1)
            end
            
            -- Click Ä‘á»ƒ spawn boss
            pcall(function() fireclickdetector(detector) end)
            wait(0.5)
            pcall(function() fireclickdetector(detector) end)
            
            wait(3)
            
            -- Kiá»ƒm tra xem boss Ä‘Ă£ spawn chÆ°a vĂ  Ä‘Ă¡nh
            if bossExists() then
                fightBoss()
            else
            end
        else
        end
    else
        -- Báº­t láº¡i AutoCollectChest náº¿u khĂ´ng cĂ³ microchip
        _G.AutoCollectChest = true
        _G.IsChestFarming = true
    end
end

-- Core Brain detection and handling
function checkForCoreBrain()
    if _G.IsCheckingForCoreBrain then return end
    
    _G.IsCheckingForCoreBrain = true
    
    -- Check if player already has Core Brain
    if hasCoreBrain() then
        _G.HasCoreBrain = true
        _G.NeedCoreBrain = false
        _G.AutoCollectChest = false
        _G.IsChestFarming = false
        _G.AutoJump = false

        
        -- Equip Core Brain
        equipCoreBrain()
        
        -- Click detector for notification
        clickDetectorForNotification()
        wait(5)  -- Wait 5 seconds
        
        -- Buy Cyborg race
        buyCyborgRace()
        
        _G.IsCheckingForCoreBrain = false
        return true
    end
    
    -- Check if race is already Cyborg
    if isCyborg() then
        _G.AutoCyborg = false
        _G.AutoCollectChest = false
        _G.IsCheckingForCoreBrain = false
        return true
    end
    
    -- First check for Fist of Darkness
    if hasFistOfDarkness() and not _G.FistDetected then
        _G.FistDetected = true
        _G.HasFistOfDarkness = true
        _G.AutoJump = false
        
        -- Click detector when Fist is found
        clickDetectorForNotification()
    end
    
    -- Find and click detector to check for messages
    clickDetectorForNotification()
    wait(3)
    
    -- Check if boss exists (which means we need a microchip, not Core Brain)
    if bossExists() then
        fightBoss()
        _G.IsCheckingForCoreBrain = false
        return false
    else
        -- If no boss, we need to continue chest farming
        _G.AutoCollectChest = true
        _G.IsChestFarming = true
        _G.IsCheckingForCoreBrain = false
        return false
    end
    
    _G.IsCheckingForCoreBrain = false
    return false
end

-- Farm chests until finding Fist of Darkness
function farmChestsForFistOfDarkness()
    if not _G.IsChestFarming then
        _G.IsChestFarming = true
        
        spawn(function()
            while _G.IsChestFarming and _G.NeedCoreBrain and not _G.HasCoreBrain do
                -- First priority: Check if we got Core Brain directly
                if hasCoreBrain() then
                    -- hasCoreBrain function will already disable chest farming
                    
                    -- Equip Core Brain
                    equipCoreBrain()
                    
                    -- Click detector for notification
                    clickDetectorForNotification()
                    wait(5)  -- Wait 5 seconds
                    
                    -- Buy Cyborg race
                    buyCyborgRace()
                    
                    break
                end
                
                -- Second priority: Check if we got Fist of Darkness
                if hasFistOfDarkness() and not _G.FistDetected then
                    _G.HasFistOfDarkness = true
                    _G.FistDetected = true
                    _G.AutoJump = false

                    -- Stop chest farming
                    _G.IsChestFarming = false
                    _G.AutoCollectChest = false
                    
                    -- Click detector multiple times
                    clickDetectorForNotification()
                    wait(1)
                    clickDetectorForNotification() 
                    wait(3)
                    
                    -- Check if boss exists now
                    if bossExists() then
                        fightBoss()
                    else
                        -- If still no boss, resume chest farming
                        if not hasCoreBrain() then  -- Double-check we don't have Core Brain
                            _G.AutoCollectChest = true
                            _G.IsChestFarming = true
                        end
                    end
                    
                    break
                end
                
                wait(3) -- Check more frequently (every 3 seconds)
            end
        end)
    end
end

-- HĂ m dá»«ng hoĂ n toĂ n quĂ¡ trĂ¬nh thu tháº­p rÆ°Æ¡ng
function ForceStopChestCollection()
    -- Äáº·t nhiá»u cá» Ä‘á»ƒ Ä‘áº£m báº£o dá»«ng háº³n viá»‡c thu tháº­p rÆ°Æ¡ng
    _G.AutoCollectChest = false
    _G.IsChestFarming = false
    _G.starthop = false
    _G.AutoHopEnabled = false
    
    -- Há»§y tween hiá»‡n táº¡i
    _G.StopTween = true
    _G.StopTween2 = true
    _G.CancelTween2 = false
    
    -- ThĂ´ng bĂ¡o
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Cyborg",
        Text = "ÄĂ£ dá»«ng thu tháº­p rÆ°Æ¡ng Ä‘á»ƒ xá»­ lĂ½ váº­t pháº©m",
        Duration = 3
    })
    
    -- Äáº·t láº¡i nhiá»u láº§n Ä‘á»ƒ Ä‘áº£m báº£o
    spawn(function()
        for i = 1, 5 do
            wait(i * 0.2)
            _G.AutoCollectChest = false
            _G.IsChestFarming = false
        end
    end)
end

-- Main cycle function
function mainCycle()
    -- Kiá»ƒm tra ngay náº¿u Ä‘Ă£ cĂ³ tá»™c Cyborg
    if isCyborg() then
        ForceStopChestCollection()
        _G.AutoCyborg = false
        _G.AutoJump = false
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Cyborg",
            Text = "You already have Cyborg race! Script stopped.",
            Duration = 10
        })
        return
    end
    
    -- Kiá»ƒm tra náº¿u cĂ³ Core Brain
    if hasCoreBrain() then
        ForceStopChestCollection()
        _G.HasCoreBrain = true
        _G.NeedCoreBrain = false
        _G.AutoJump = false
        
        -- ThĂ´ng bĂ¡o 
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Core Brain",
            Text = "ÄĂ£ tĂ¬m tháº¥y Core Brain! Äang mua tá»™c Cyborg...",
            Duration = 5
        })
        
        -- Equip Core Brain
        equipCoreBrain()
        
        -- Click detector for notification
        clickDetectorForNotification()
        wait(5)
        
        -- Buy Cyborg race
        buyCyborgRace()
        
        -- Kiá»ƒm tra láº¡i xem Ä‘Ă£ mua Ä‘Æ°á»£c chÆ°a
        wait(2)
        if not isCyborg() then
            -- Thá»­ láº¡i náº¿u chÆ°a thĂ nh cĂ´ng
            for i = 1, 3 do
                clickDetectorForNotification()
                wait(1)
                buyCyborgRace()
                wait(2)
                
                if isCyborg() then break end
            end
        end
        
        return
    end
    
    -- Kiá»ƒm tra náº¿u cáº§n Core Brain vĂ  khĂ´ng cĂ³ Core Brain
    if _G.NeedCoreBrain and not _G.HasCoreBrain then
        farmChestsForFistOfDarkness()
    end
    
    -- Theo dĂµi liĂªn tá»¥c tráº¡ng thĂ¡i
    spawn(function()
        while _G.AutoCyborg do
            pcall(function()
                -- Kiá»ƒm tra Fist of Darkness trÆ°á»›c
                if hasFistOfDarkness() and not _G.FistDetected then
                    ForceStopChestCollection()
                    _G.FistDetected = true
                    _G.HasFistOfDarkness = true
                    _G.AutoJump = false
                    
                    -- ThĂ´ng bĂ¡o
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Fist of Darkness",
                        Text = "ÄĂ£ tĂ¬m tháº¥y Fist of Darkness! Äang xá»­ lĂ½...",
                        Duration = 5
                    })
                    
                    -- Click detector nhiá»u láº§n
                    clickDetectorForNotification() 
                    wait(1)
                    clickDetectorForNotification()
                    
                    -- Kiá»ƒm tra microchip
                    if not hasMicrochip() then
                        -- ThĂ´ng bĂ¡o
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Microchip",
                            Text = "Äang mua Microchip...",
                            Duration = 3
                        })
                        
                        for i = 1, 3 do
                            buyMicrochip()
                            wait(1)
                            if hasMicrochip() then break end
                        end
                    end
                    
                    -- Náº¿u cĂ³ microchip, spawn boss
                    if hasMicrochip() then
                        clickToSpawnBoss()
                    end
                end
                
                -- Náº¿u cĂ³ Core Brain, sá»­ dá»¥ng nĂ³
                if hasCoreBrain() and not isCyborg() then
                    ForceStopChestCollection()
                    _G.HasCoreBrain = true
                    _G.NeedCoreBrain = false
                    _G.AutoJump = false
                    
                    -- ThĂ´ng bĂ¡o
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Core Brain",
                        Text = "ÄĂ£ tĂ¬m tháº¥y Core Brain! Äang mua tá»™c Cyborg...",
                        Duration = 5
                    })
                    
                    -- Equip Core Brain
                    equipCoreBrain()
                    
                    -- Click detector for notification
                    clickDetectorForNotification()
                    wait(5)  -- Wait 5 seconds
                    
                    -- Buy Cyborg race
                    buyCyborgRace()
                    
                    -- Kiá»ƒm tra láº¡i
                    wait(2)
                    if not isCyborg() then
                        for i = 1, 3 do
                            clickDetectorForNotification()
                            wait(1)
                            buyCyborgRace()
                            wait(2)
                            if isCyborg() then break end
                        end
                    end
                end
                
                -- Náº¿u phĂ¡t hiá»‡n chĂ¬a khĂ³a
                local Key = workspace:FindFirstChild("Key")
                if Key and not _G.KeyDetected then
                    -- Äáº·t cá» phĂ¡t hiá»‡n chĂ¬a khĂ³a
                    _G.KeyDetected = true
                    _G.AutoJump = false
                    
                    -- ThĂ´ng bĂ¡o
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "ChĂ¬a khĂ³a",
                        Text = "ÄĂ£ phĂ¡t hiá»‡n chĂ¬a khĂ³a! Äang xá»­ lĂ½...",
                        Duration = 5
                    })
                    
                    -- Click detector nhiá»u láº§n
                    clickDetectorForNotification()
                    wait(1)
                    clickDetectorForNotification()
                    
                    -- Náº¿u cĂ³ Fist of Darkness, sá»­ dá»¥ng nĂ³
                    if hasFistOfDarkness() and not bossExists() and not _G.IsFightingBoss then
                        ForceStopChestCollection()
                        _G.HasFistOfDarkness = true
                        _G.FistDetected = true
                        
                        -- Click detector láº¡i
                        clickDetectorForNotification()
                        wait(3)
                        
                        -- Kiá»ƒm tra boss Ä‘Ă£ xuáº¥t hiá»‡n chÆ°a
                        if bossExists() then
                            fightBoss()
                        end
                    else
                        -- KhĂ´ng cĂ³ Fist of Darkness, nhÆ°ng cĂ³ chĂ¬a khĂ³a. Mua microchip vĂ  spawn boss
                        if not hasMicrochip() then
                            -- ThĂ´ng bĂ¡o
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Microchip",
                                Text = "Äang mua Microchip...",
                                Duration = 3
                            })
                            
                            for i = 1, 3 do
                                buyMicrochip()
                                wait(1)
                                if hasMicrochip() then break end
                            end
                        end
                        
                        -- Náº¿u Ä‘Ă£ cĂ³ microchip, click Ä‘á»ƒ spawn boss
                        if hasMicrochip() then
                            local detector, buttonPosition = findClickDetector()
                            if detector then
                                -- Äáº£m báº£o ngÆ°á»i chÆ¡i Ä‘á»§ gáº§n button
                                if buttonPosition and not isPlayerCloseToButton(buttonPosition) then
                                    teleportToButton(buttonPosition)
                                    wait(1)
                                end
                                
                                -- Thá»­ cĂ¡c phÆ°Æ¡ng thá»©c click
                                pcall(function() fireclickdetector(detector) end)
                                wait(0.5)
                                pcall(function() fireclickdetector(detector) end)
                                
                                wait(3)
                                
                                -- Kiá»ƒm tra xem boss Ä‘Ă£ xuáº¥t hiá»‡n chÆ°a vĂ  Ä‘Ă¡nh
                                if bossExists() then
                                    fightBoss()
                                end
                            end
                        end
                    end
                end
                
                -- Náº¿u boss tá»“n táº¡i vĂ  chÆ°a Ä‘Ă¡nh, báº¯t Ä‘áº§u Ä‘Ă¡nh
                if bossExists() and not _G.IsFightingBoss then
                    fightBoss()
                end
                
                -- Kiá»ƒm tra náº¿u Ä‘Ă£ cĂ³ tá»™c Cyborg
                if isCyborg() then
                    ForceStopChestCollection()
                    _G.AutoCyborg = false
                    _G.AutoJump = false
                    
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Auto Cyborg",
                        Text = "ÄĂ£ nháº­n thĂ nh cĂ´ng tï¿½ï¿½ï¿½c Cyborg!",
                        Duration = 10
                    })
                    return
                end
                
                -- Kiá»ƒm tra xem ngÆ°á»i dĂ¹ng cĂ³ cĂ¡c cĂ´ng cá»¥ má»›i khĂ´ng - Ä‘áº·c biá»‡t lĂ  Fist of Darkness
                local player = game.Players.LocalPlayer
                if player and player.Backpack then
                    local checkBackpack = player.Backpack:GetChildren()
                    for _, item in pairs(checkBackpack) do
                        if item.Name == "Fist of Darkness" and not _G.FistDetected then
                            ForceStopChestCollection()
                            _G.FistDetected = true
                            _G.HasFistOfDarkness = true
                            _G.AutoJump = false
                            
                            -- ThĂ´ng bĂ¡o
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Fist of Darkness",
                                Text = "ÄĂ£ tĂ¬m tháº¥y Fist of Darkness! Äang xá»­ lĂ½...",
                                Duration = 5
                            })
                            
                            -- Click detector nhiá»u láº§n
                            clickDetectorForNotification()
                            wait(1)
                            clickDetectorForNotification()
                            break
                        end
                    end
                end
                
                if player and player.Character then
                    local checkCharacter = player.Character:GetChildren()
                    for _, item in pairs(checkCharacter) do
                        if item.Name == "Fist of Darkness" and not _G.FistDetected then
                            ForceStopChestCollection()
                            _G.FistDetected = true
                            _G.HasFistOfDarkness = true
                            _G.AutoJump = false
                            
                            -- ThĂ´ng bĂ¡o
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Fist of Darkness",
                                Text = "ÄĂ£ tĂ¬m tháº¥y Fist of Darkness! Äang xá»­ lĂ½...",
                                Duration = 5
                            })
                            
                            -- Click detector nhiá»u láº§n
                            clickDetectorForNotification()
                            wait(1)
                            clickDetectorForNotification()
                            break
                        end
                    end
                end
            end)
            
            wait(2) -- Kiá»ƒm tra má»—i 2 giĂ¢y
        end
    end)
end
-- Add processFistOfDarkness function
function processFistOfDarkness()
    -- First check if player already has Cyborg race
    if isCyborg() then
        _G.AutoCyborg = false
        _G.AutoCollectChest = false
        _G.IsChestFarming = false
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Cyborg",
            Text = "You already have Cyborg race! Script stopped.",
            Duration = 10
        })
        return
    end
    
    -- Stop chest collection temporarily
    ForceStopChestCollection()
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Cyborg Process",
        Text = "Checking for Core Brain...",
        Duration = 5
    })
    
    -- Click detector to check for game messages about Core Brain
    local detector, buttonPosition = findClickDetector()
    if detector then
        -- Make sure player is close enough to button
        if buttonPosition and not isPlayerCloseToButton(buttonPosition) then
            teleportToButton(buttonPosition)
            wait(1)
        end
        
        -- Click to check for messages
        pcall(function() fireclickdetector(detector) end)
        wait(0.5)
        pcall(function() fireclickdetector(detector) end)
        
        -- Wait to ensure messages are processed
        wait(2)
    end
    
    -- Check if player already has Core Brain
    if hasCoreBrain() then
        -- Player has Core Brain, proceed to buy Cyborg race
        _G.HasCoreBrain = true
        _G.NeedCoreBrain = false
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Core Brain",
            Text = "Core Brain found! Buying Cyborg race...",
            Duration = 5
        })
        
        -- Equip Core Brain
        equipCoreBrain()
        
        -- Click detector to use Core Brain
        clickDetectorForNotification()
        wait(3)
        
        -- Buy Cyborg race
        buyCyborgRace()
        
        -- Check if successfully purchased
        wait(2)
        if isCyborg() then
            _G.AutoCyborg = false
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Success",
                Text = "Successfully obtained Cyborg race!",
                Duration = 10
            })
        else
            -- Try again if failed
            for i = 1, 3 do
                clickDetectorForNotification()
                wait(1)
                buyCyborgRace()
                wait(2)
                
                if isCyborg() then
                    _G.AutoCyborg = false
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Success",
                        Text = "Successfully obtained Cyborg race! (attempt: " .. i .. ")",
                        Duration = 10
                    })
                    break
                end
            end
        end
        return
    end
    
    -- Check if boss already exists (this means we have used Fist of Darkness)
    if bossExists() then
        -- Boss already spawned, fight it
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Boss Found",
            Text = "Boss already spawned, fighting now...",
            Duration = 3
        })
        fightBoss()
        
        -- Wait for boss fight to complete
        local waitTime = 0
        while _G.IsFightingBoss and waitTime < 300 do
            wait(1)
            waitTime = waitTime + 1
        end
        
        -- Additional wait to ensure items are collected
        wait(3)
        
        -- Check for Core Brain after boss is defeated
        if hasCoreBrain() then
            _G.HasCoreBrain = true
            _G.NeedCoreBrain = false
            
            -- Equip Core Brain
            equipCoreBrain()
            
            -- Click detector to use Core Brain
            clickDetectorForNotification()
            wait(3)
            
            -- Buy Cyborg race
            buyCyborgRace()
            
            -- Check if successfully purchased
            wait(2)
            if isCyborg() then
                _G.AutoCyborg = false
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Success",
                    Text = "Successfully obtained Cyborg race!",
                    Duration = 10
                })
            else
                -- Try again if failed
                for i = 1, 3 do
                    clickDetectorForNotification()
                    wait(1)
                    buyCyborgRace()
                    wait(2)
                    
                    if isCyborg() then
                        _G.AutoCyborg = false
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Success",
                            Text = "Successfully obtained Cyborg race! (attempt: " .. i .. ")",
                            Duration = 10
                        })
                        break
                    end
                end
            end
        else
            -- If no Core Brain after boss fight, buy Microchip and try again
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Core Brain",
                Text = "Core Brain not found. Buying Microchip again...",
                Duration = 5
            })
            
            -- Reset Microchip purchased flag
            _G.MicrochipPurchased = false
            
            -- Buy Microchip if needed
            if not hasMicrochip() then
                buyMicrochip()
                wait(1)
            end
            
            -- Click detector to spawn boss
            clickDetectorForNotification()
            wait(3)
            
            -- Fight boss if it exists
            if bossExists() then
                fightBoss()
            else
                -- If boss doesn't spawn, resume chest farming
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Error",
                    Text = "Couldn't spawn boss! Resuming chest farming...",
                    Duration = 5
                })
                _G.AutoCollectChest = true
                _G.IsChestFarming = true
            end
        end
        return
    end
    
    -- If we have Fist of Darkness but no boss, use it
    if hasFistOfDarkness() then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fist of Darkness",
            Text = "Using Fist of Darkness...",
            Duration = 5
        })
        
        -- Click detector to use Fist of Darkness
        local detector, buttonPosition = findClickDetector()
        if detector then
            -- Make sure player is close enough to button
            if buttonPosition and not isPlayerCloseToButton(buttonPosition) then
                teleportToButton(buttonPosition)
                wait(1)
            end
            
            -- Click to use Fist of Darkness
            pcall(function() fireclickdetector(detector) end)
            wait(0.5)
            pcall(function() fireclickdetector(detector) end)
            
            -- Wait to ensure the click is processed
            wait(2)
        end
        
        -- Check if boss spawned after using Fist of Darkness
        if bossExists() then
            -- Boss spawned, fight it
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Boss Spawned",
                Text = "Fighting boss now...",
                Duration = 3
            })
            fightBoss()
            
            -- Wait for boss fight to complete
            local waitTime = 0
            while _G.IsFightingBoss and waitTime < 300 do
                wait(1)
                waitTime = waitTime + 1
            end
            
            -- Additional wait to ensure items are collected
            wait(3)
            
            -- Check for Core Brain after boss is defeated
            if hasCoreBrain() then
                _G.HasCoreBrain = true
                _G.NeedCoreBrain = false
                
                -- Equip Core Brain
                equipCoreBrain()
                
                -- Click detector to use Core Brain
                clickDetectorForNotification()
                wait(3)
                
                -- Buy Cyborg race
                buyCyborgRace()
                
                -- Check if successfully purchased
                wait(2)
                if isCyborg() then
                    _G.AutoCyborg = false
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Success",
                        Text = "Successfully obtained Cyborg race!",
                        Duration = 10
                    })
                else
                    -- Try again if failed
                    for i = 1, 3 do
                        clickDetectorForNotification()
                        wait(1)
                        buyCyborgRace()
                        wait(2)
                        
                        if isCyborg() then
                            _G.AutoCyborg = false
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Success",
                                Text = "Successfully obtained Cyborg race! (attempt: " .. i .. ")",
                                Duration = 10
                            })
                            break
                        end
                    end
                end
            else
                -- If no Core Brain after boss fight, buy Microchip and try again
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Core Brain",
                    Text = "Core Brain not found. Buying Microchip again...",
                    Duration = 5
                })
                
                -- Reset Microchip purchased flag
                _G.MicrochipPurchased = false
                
                -- Buy Microchip if needed
                if not hasMicrochip() then
                    buyMicrochip()
                    wait(1)
                end
                
                -- Click detector to spawn boss
                clickDetectorForNotification()
                wait(3)
                
                -- Fight boss if it exists
                if bossExists() then
                    fightBoss()
                else
                    -- If boss doesn't spawn, resume chest farming
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Error",
                        Text = "Couldn't spawn boss! Resuming chest farming...",
                        Duration = 5
                    })
                    _G.AutoCollectChest = true
                    _G.IsChestFarming = true
                end
            end
            return
        else
            -- If boss didn't spawn after using Fist of Darkness, buy Microchip
            if not hasMicrochip() then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Microchip",
                    Text = "Buying Microchip...",
                    Duration = 3
                })
                
                -- Buy Microchip
                buyMicrochip()
                wait(1)
                
                if hasMicrochip() then
                    _G.MicrochipPurchased = true
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Microchip",
                        Text = "Successfully purchased Microchip!",
                        Duration = 3
                    })
                else
                    -- If couldn't buy Microchip, resume chest farming
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Error",
                        Text = "Couldn't buy Microchip! Resuming chest farming...",
                        Duration = 5
                    })
                    _G.AutoCollectChest = true
                    _G.IsChestFarming = true
                    return
                end
            end
            
            -- Click detector to spawn boss with Microchip
            local detector, buttonPosition = findClickDetector()
            if detector then
                -- Make sure player is close enough to button
                if buttonPosition and not isPlayerCloseToButton(buttonPosition) then
                    teleportToButton(buttonPosition)
                    wait(1)
                end
                
                -- Click to spawn boss
                pcall(function() fireclickdetector(detector) end)
                wait(0.5)
                pcall(function() fireclickdetector(detector) end)
                
                -- Wait to ensure the click is processed
                wait(3)
                
                -- Fight boss if it exists
                if bossExists() then
                    fightBoss()
                    
                    -- Wait for boss fight to complete
                    local waitTime = 0
                    while _G.IsFightingBoss and waitTime < 300 do
                        wait(1)
                        waitTime = waitTime + 1
                    end
                    
                    -- Additional wait to ensure items are collected
                    wait(3)
                    
                    -- Check for Core Brain after boss is defeated
                    if hasCoreBrain() then
                        _G.HasCoreBrain = true
                        _G.NeedCoreBrain = false
                        
                        -- Equip Core Brain
                        equipCoreBrain()
                        
                        -- Click detector to use Core Brain
                        clickDetectorForNotification()
                        wait(3)
                        
                        -- Buy Cyborg race
                        buyCyborgRace()
                        
                        -- Check if successfully purchased
                        wait(2)
                        if isCyborg() then
                            _G.AutoCyborg = false
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Success",
                                Text = "Successfully obtained Cyborg race!",
                                Duration = 10
                            })
                        else
                            -- Try again if failed
                            for i = 1, 3 do
                                clickDetectorForNotification()
                                wait(1)
                                buyCyborgRace()
                                wait(2)
                                
                                if isCyborg() then
                                    _G.AutoCyborg = false
                                    game:GetService("StarterGui"):SetCore("SendNotification", {
                                        Title = "Success",
                                        Text = "Successfully obtained Cyborg race! (attempt: " .. i .. ")",
                                        Duration = 10
                                    })
                                    break
                                end
                            end
                        end
                    else
                        -- If no Core Brain after boss fight, resume chest farming
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Core Brain",
                            Text = "Core Brain not found. Resuming chest farming...",
                            Duration = 5
                        })
                        _G.AutoCollectChest = true
                        _G.IsChestFarming = true
                    end
                else
                    -- If boss doesn't exist after clicking, resume chest farming
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Error",
                        Text = "Couldn't spawn boss! Resuming chest farming...",
                        Duration = 5
                    })
                    _G.AutoCollectChest = true
                    _G.IsChestFarming = true
                end
            end
        end
        return
    end
    
    -- If we don't have Fist of Darkness or Core Brain, enable auto chest farming
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Chest",
        Text = "Enabling auto chest farming to find Fist of Darkness...",
        Duration = 5
    })
    _G.AutoCollectChest = true
    _G.IsChestFarming = true
end

-- Improved AutoChestCollect function
    GetChest = function()
        local distance = math.huge
        local a
        for r, v in pairs(workspace.Map:GetDescendants()) do
            if string.find(v.Name:lower(), "chest") then
                if v:FindFirstChild("TouchInterest") then
                    if (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < distance then
                        distance = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        a = v
                    end
                end
            end
        end
        return a
    end
function AutoChestCollect()
    if not _G.ChestFarmingRunning then
        _G.ChestFarmingRunning = true
        
        -- Create variable to track collected chests
        local visitedChests = {}
        
        spawn(function()
            while wait(0.1) do
                -- Check for Core Brain, Cyborg race, and Fist of Darkness before each chest search
                if hasCoreBrain() then
                    _G.AutoCollectChest = false
                    _G.IsChestFarming = false
                    _G.starthop = false
                    _G.AutoHopEnabled = false
                    
                    -- Notification
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Auto Cyborg",
                        Text = "Core Brain found! Stopping chest farm...",
                        Duration = 5
                    })
                    
                    -- Process Core Brain
                    equipCoreBrain()
                    clickDetectorForNotification()
                    wait(5)
                    buyCyborgRace()
                    
                    continue
                elseif isCyborg() then
                    _G.AutoCollectChest = false
                    _G.IsChestFarming = false
                    _G.AutoCyborg = false
                    _G.starthop = false
                    _G.AutoHopEnabled = false
                    
                    -- Notification
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Auto Cyborg",
                        Text = "You already have Cyborg race! Script stopped.",
                        Duration = 10
                    })
                    
                    continue
                elseif isCyborg() then
                    _G.AutoCollectChest = false
                    _G.IsChestFarming = false
                    _G.AutoCyborg = false
                    _G.starthop = false
                    _G.AutoHopEnabled = false
                    
                    -- Notification
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Auto Cyborg",
                        Text = "You already have Cyborg race! Script stopped.",
                        Duration = 10
                    })
                    
                    continue
                elseif hasFistOfDarkness() then
                    _G.AutoCollectChest = false
                    _G.IsChestFarming = false
                    _G.starthop = false
                    _G.AutoHopEnabled = false
                    
                    -- Notification
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Auto Cyborg",
                        Text = "Fist of Darkness found! Processing...",
                        Duration = 5
                    })
                    
                    -- Process Fist of Darkness
                    processFistOfDarkness()
                    
                    continue
                end
                
                -- Kiá»ƒm tra náº¿u cháº¿ Ä‘á»™ Ä‘Ă£ bá»‹ táº¯t
                if not _G.AutoCollectChest then 
                    wait(1)
                    continue 
                end
                
                -- Kiá»ƒm tra náº¿u Ä‘ang Ä‘Ă¡nh boss
                if _G.IsFightingBoss or _G.IsFightingCyborgBoss then
                    continue
                end
                
                -- Rest of the chest collection code...
                -- (giá»¯ nguyĂªn pháº§n code thu tháº­p rÆ°Æ¡ng)
                
                -- KĂ­ch hoáº¡t NoClip vĂ  anti-gravity
                EnableNoClipAndAntiGravity()
                
                pcall(function()
                    local character = game.Players.LocalPlayer.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    
                    local hrpPosition = character.HumanoidRootPart.Position
                    
                    -- ===== CĂ‚N Báº°NG GIá»®A GIĂ TRá» RÆ¯Æ NG VĂ€ KHOáº¢NG CĂCH =====
                    -- Thu tháº­p rÆ°Æ¡ng tá»‘t nháº¥t
                    if GetChest() then
                        Tween2(GetChest().CFrame)
                        pcall(function()
                            if workspace:FindFirstChild("Key") and not _G.KeyDetected then
                                _G.KeyDetected = true
                                _G.AutoJump = false
                            end
                            
                            -- Kiá»ƒm tra Fist of Darkness vĂ  Core Brain
                            hasFistOfDarkness()
                            hasCoreBrain()
                        end)
                    elseif tick() - _G.LastChestCollectedTime > 60 then
                        HopServer()
                    end
                end)
            end
        end)
    end
end

-- Kiá»ƒm tra liĂªn tá»¥c viá»‡c chá»‘ng rÆ¡i
spawn(function()
    while wait(0.5) do
        pcall(function()
            if _G.AutoCollectChest and not _G.IsFightingBoss and not _G.IsFightingCyborgBoss then
                EnableNoClipAndAntiGravity()
            end
        end)
    end
end)

-- Báº¯t Ä‘áº§u quĂ¡ trĂ¬nh thu tháº­p chest
AutoChestCollect()
-- Continuously check player position
spawn(function()
    while wait(1) do -- Check every second
        if _G.AutoHopEnabled and not _G.IsFightingBoss and not _G.IsFightingCyborgBoss then
            pcall(function()
                CheckIfStuckAndHop()
            end)
        end
    end
end)
-- ThĂªm hĂ m nĂ y gáº§n Ä‘áº§u script, sau pháº§n khai bĂ¡o biáº¿n toĂ n cá»¥c
function ForceStopChestCollection()
    -- Äáº·t nhiá»u cá» Ä‘á»ƒ Ä‘áº£m báº£o dá»«ng háº³n viá»‡c thu tháº­p rÆ°Æ¡ng
    _G.AutoCollectChest = false
    _G.IsChestFarming = false
    _G.starthop = false
    _G.AutoHopEnabled = false
    
    -- Há»§y tween hiá»‡n táº¡i
    _G.StopTween = true
    _G.StopTween2 = true
    _G.CancelTween2 = false
    
    -- ThĂ´ng bĂ¡o
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Cyborg",
        Text = "ÄĂ£ dá»«ng thu tháº­p rÆ°Æ¡ng Ä‘á»ƒ xá»­ lĂ½ váº­t pháº©m",
        Duration = 3
    })
    
    -- Äáº·t láº¡i nhiá»u láº§n Ä‘á»ƒ Ä‘áº£m báº£o
    spawn(function()
        for i = 1, 5 do
            wait(i * 0.2)
            _G.AutoCollectChest = false
            _G.IsChestFarming = false
        end
    end)
end
-- Server hopping function
function HopServer()
    local maxServerSize = 9 -- Limit on players in server to hop to
    local serverFound = false -- Variable to check if server change was successful

    -- Function to find and join new server
    local function findAndJoinNewServer()
        local serverBrowserService = game:GetService("ReplicatedStorage").__ServerBrowser
        for i = 1, math.huge do
            local availableServers = serverBrowserService:InvokeServer(i)
            for jobId, serverInfo in pairs(availableServers) do
                if jobId ~= game.JobId and serverInfo["Count"] < maxServerSize then
                    serverBrowserService:InvokeServer("teleport", jobId)
                    serverFound = true
                    return true
                end
            end
        end
        return false
    end

    -- Try to switch to new server
    pcall(function()
        while not serverFound do
            findAndJoinNewServer()
            wait(0.4) -- Wait a short period before trying again
        end
    end)
end

-- Auto-jump function (press E to save status)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
        -- Write data to file
        local data = {
            AutoCyborg = _G.AutoCyborg,
            HasMicrochip = hasMicrochip(),
            HasCoreBrain = hasCoreBrain(),
            HasCyborgRace = isCyborg(),
            AutoJump = _G.AutoJump,
            HasFistOfDarkness = hasFistOfDarkness()
        }
        
        -- Convert to string format
        local dataString = "AutoCyborg: " .. tostring(data.AutoCyborg) .. "\n" ..
                          "HasMicrochip: " .. tostring(data.HasMicrochip) .. "\n" ..
                          "HasCoreBrain: " .. tostring(data.HasCoreBrain) .. "\n" ..
                          "HasCyborgRace: " .. tostring(data.HasCyborgRace) .. "\n" ..
                          "AutoJump: " .. tostring(data.AutoJump) .. "\n" ..
                          "HasFistOfDarkness: " .. tostring(data.HasFistOfDarkness)
        
        -- Save to new file
        writefile("CyborgStatus.txt", dataString)
    end
end)

-- Anti-AFK function to make character jump
function AutoJump()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    while wait(math.random(15, 20)) do  -- Wait random time
        pcall(function()
            if _G.AutoJump and humanoid and humanoid.Health > 0 then  -- Check if auto jump is enabled and character is alive
                -- Double-check for Fist of Darkness before jumping
                if hasFistOfDarkness() and not _G.FistDetected then
                    _G.FistDetected = true
                    _G.HasFistOfDarkness = true
                    _G.AutoJump = false 

                    -- Click detector multiple times
                    clickDetectorForNotification()
                    wait(1)
                    clickDetectorForNotification()
                elseif _G.AutoJump then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)  -- Activate jump state
                end
            end
        end)
    end
end

-- Start auto jump in separate coroutine
spawn(AutoJump)

-- Anti-kick function to prevent being kicked after 20 minutes idle
local function AntiKick()
    while true do
        wait(1)
        pcall(function()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local v1518 = Instance.new("BillboardGui", game.Players.LocalPlayer.Character.HumanoidRootPart);
                v1518.Name = "Esp";
                v1518.ExtentsOffset = Vector3.new(0, 1, 0);
                v1518.Size = UDim2.new(1, 300, 1, 50);
                v1518.Adornee = game.Players.LocalPlayer.Character.HumanoidRootPart;
                v1518.AlwaysOnTop = true;
                local v1524 = Instance.new("TextLabel", v1518);
                v1524.Font = "Code";
                v1524.FontSize = "Size14";
                v1524.TextWrapped = true;
                v1524.Size = UDim2.new(1, 0, 1, 0);
                v1524.TextYAlignment = "Top";
                v1524.BackgroundTransparency = 1;
                v1524.TextStrokeTransparency = 0.5;
                v1524.TextColor3 = Color3.fromRGB(80, 245, 245);
                v1524.Text = "taphoamizu";
            end
            if game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity.Magnitude < 0.1 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 0.01)
            end
        end)
    end
end

-- Call AntiKick function
spawn(AntiKick)

-- Automatic rejoin on kick
spawn(function()
    while wait() do
        if _G.AutoRejoin == true then
            getgenv().rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end
            end)
        end
    end
end)

-- Check for special items (Fist of Darkness, Core Brain)
local function CheckForSpecialItems()
    local startTime = tick()  -- Save start check time
    local timeLimit = 15 * 60 -- Time limit is 15 minutes

    spawn(function()
        while true do
            wait(1)  -- Check every second
            local currentTime = tick()
            local player = game.Players.LocalPlayer
            
            -- Check specifically for Core Brain first
            if hasCoreBrain() then
                -- Immediately disable auto chest when Core Brain is found
                _G.AutoCollectChest = false
                _G.IsChestFarming = false
                _G.HasCoreBrain = true
                _G.NeedCoreBrain = false
                _G.AutoJump = false
                
               
                
                -- Equip Core Brain
                equipCoreBrain()
                
                -- Click detector for notification
                clickDetectorForNotification()
                wait(5)  -- Wait 5 seconds
                
                -- Buy Cyborg race
                buyCyborgRace()
                
                startTime = tick()
            -- Then check for Fist of Darkness
            elseif hasFistOfDarkness() and not _G.FistDetected then
                -- Disable auto chest when Fist of Darkness is found
                _G.FistDetected = true
                _G.HasFistOfDarkness = true
                _G.AutoJump = false

                -- Click detector multiple times
                clickDetectorForNotification()
                wait(1)
                clickDetectorForNotification()
                
                startTime = tick()
            elseif (currentTime - startTime) > timeLimit then
                -- If over 15 minutes without finding item, change server
                HopServer()
                startTime = tick()  -- Reset time after server change
            end
            
            -- Check for key and stop auto jump if found
            if workspace:FindFirstChild("Key") and not _G.KeyDetected then
                _G.KeyDetected = true
                _G.AutoJump = false
                -- Click detector for notification multiple times
                clickDetectorForNotification()
                wait(1)
                clickDetectorForNotification()
            end
            
            -- Deep check player inventory for Fist of Darkness
            pcall(function()
                local backpack = player.Backpack:GetChildren()
                for _, item in pairs(backpack) do
                    if item.Name == "Fist of Darkness" and not _G.FistDetected then
                        _G.FistDetected = true
                        _G.HasFistOfDarkness = true
                        _G.AutoJump = false
                        -- Click detector multiple times
                        clickDetectorForNotification()
                        wait(1)
                        clickDetectorForNotification()
                    end
                end
                
                if player.Character then
                    local character = player.Character:GetChildren()
                    for _, item in pairs(character) do
                        if item.Name == "Fist of Darkness" and not _G.FistDetected then
                            _G.FistDetected = true
                            _G.HasFistOfDarkness = true
                            _G.AutoJump = false
                            -- Click detector multiple times
                            clickDetectorForNotification()
                            wait(1)
                            clickDetectorForNotification()
                        end
                    end
                end
            end)
        end
    end)
end

-- Call special item check function
CheckForSpecialItems()

-- Enhanced Core Brain detection
function setupCoreBrainDetection()
    -- Setup chat monitoring
    setupChatMonitoring()
    
    -- Function to teleport to Core Brain location
    local function teleportToCoreBrain()
        pcall(function()
            _G.NeedCoreBrain = true
            
            -- Stop chest farming and other activities
            _G.AutoCollectChest = false
            _G.IsChestFarming = false
            _G.AutoJump = false
            
            -- Teleport to Core Brain position
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = coreBrainPosition
            end
            
            -- Wait a bit after teleporting
            wait(2)
            
            -- Check if we now have Core Brain
            if hasCoreBrain() then
                _G.HasCoreBrain = true
                
                -- Equip Core Brain
                equipCoreBrain()
                
                -- Click detector for notification
                clickDetectorForNotification()
                wait(5)  -- Wait 5 seconds
                
                -- Buy Cyborg race
                buyCyborgRace()
            else
                -- If still no Core Brain, continue process
                if bossExists() then
                    fightBoss()
                else
                    clickToSpawnBoss()
                end
            end
        end)
    end
    
    -- Monitor GUI
    pcall(function()
        if game.Players.LocalPlayer.PlayerGui then
            -- Check current GUI
            for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                checkGUI(gui)
            end
            
            -- Monitor new GUI
            game.Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                    checkGUI(descendant)
                    
                    pcall(function()
                        descendant:GetPropertyChangedSignal("Text"):Connect(function()
                            checkGUI(descendant)
                        end)
                    
                        descendant:GetPropertyChangedSignal("Visible"):Connect(function()
                            checkGUI(descendant)
                        end)
                    end)
                end
            end)
        end
    end)
    
    -- Monitor workspace for key
    pcall(function()
        workspace.ChildAdded:Connect(function(child)
            if child.Name == "Key" then
                -- Key was added to workspace, disable auto jump
                _G.KeyDetected = true
                _G.AutoJump = false

                clickDetectorForNotification()
                wait(1)
                clickDetectorForNotification()
            end
        end)
    end)
    
    -- Monitor inventory for Fist of Darkness
    local player = game:GetService("Players").LocalPlayer
    
    pcall(function()
        player.Backpack.ChildAdded:Connect(function(item)
            if item.Name == "Fist of Darkness" and not _G.FistDetected then
                _G.FistDetected = true
                _G.HasFistOfDarkness = true
                _G.AutoJump = false

                -- Click detector multiple times
                clickDetectorForNotification()
                wait(1)
                clickDetectorForNotification()
            end
        end)
    end)
    
    pcall(function()
        if player.Character then
            player.Character.ChildAdded:Connect(function(item)
                if item.Name == "Fist of Darkness" and not _G.FistDetected then
                    _G.FistDetected = true
                    _G.HasFistOfDarkness = true
                    _G.AutoJump = false
                    -- Click detector multiple times
                    clickDetectorForNotification()
                    wait(1)
                    clickDetectorForNotification()
                end
            end)
        end
    end)
    
    player.CharacterAdded:Connect(function(char)
        pcall(function()
            char.ChildAdded:Connect(function(item)
                if item.Name == "Fist of Darkness" and not _G.FistDetected then
                    _G.FistDetected = true
                    _G.HasFistOfDarkness = true
                    _G.AutoJump = false
                    -- Click detector multiple times
                    clickDetectorForNotification()
                    wait(1)
                    clickDetectorForNotification()
                end
            end)
        end)
    end)
end

-- Character death and respawn handling
pcall(function()
    game.Players.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        -- If we were fighting boss, this is likely a death
        if _G.IsFightingBoss then
            -- Wait a bit for character to fully load
            wait(3)
            
            -- Resume boss fight if boss still exists
            if bossExists() then
                fightBoss()
            else
                _G.IsFightingBoss = false
                
                -- Check if we need to continue with process
                if not isCyborg() and _G.AutoCyborg then
                    if hasCoreBrain() then
                        _G.HasCoreBrain = true
                        _G.NeedCoreBrain = false
                        _G.AutoJump = false
                        
                        -- Equip Core Brain
                        equipCoreBrain()
                        
                        -- Click detector for notification
                        clickDetectorForNotification()
                        wait(5)  -- Wait 5 seconds
                        
                        -- Buy Cyborg race
                        buyCyborgRace()
                    else
                        -- Continue process
                        checkForCoreBrain()
                    end
                end
            end
        end
        
        -- Also check for Fist of Darkness on respawn
        wait(1) -- Wait for items to load
        if hasFistOfDarkness() and not _G.FistDetected then
            _G.FistDetected = true
            _G.HasFistOfDarkness = true
            _G.AutoJump = false
            -- Click detector multiple times
            clickDetectorForNotification()
            wait(1)
            clickDetectorForNotification()
        end
    end)
end)

-- Race change detection
pcall(function()
    game.Players.LocalPlayer.Data.Race.Changed:Connect(function()
        if game.Players.LocalPlayer.Data.Race.Value == "Cyborg" then
            _G.AutoCyborg = false
            _G.AutoCollectChest = false
            _G.IsChestFarming = false
            _G.IsFightingBoss = false
            _G.AutoJump = false
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Auto Cyborg",
                Text = "Successfully obtained Cyborg race!",
                Duration = 10
            })
        end
    end)
end)

-- Add ability activation for auto T, Y, and Ken
spawn(function()
    while wait() do
        if _G.IsFightingBoss or _G.IsFightingCyborgBoss then
            pcall(function()
                -- Auto Ken Haki
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
                
                -- Auto T Ability
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
                
                -- Auto Y Ability
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
                wait()
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
                
                -- V3/V4 Activation
                -- Check for V4
                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AwakeningChanger", "Check") == true then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AwakeningChanger", "Awaken")
                end
                
                -- Check for V3
                for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Melee" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name) then
                            local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name)
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
                        end
                    end
                end
                
                if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("RaceTransformed") then
                    local RightClick = game:GetService("VirtualInputManager")
                    RightClick:SendKeyEvent(true, "E", false, game)
                    wait(0.1)
                    RightClick:SendKeyEvent(false, "E", false, game)
                end
            end)
        end
    end
end)

-- Stun prevention
task.spawn(function()
    while wait() do
        pcall(function()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
                game.Players.LocalPlayer.Character.Stun.Value = 0
            end
        end)
    end
end)

-- Additional NoClip for boss fights
spawn(function()
    while true do
        wait()
        if _G.IsFightingBoss or _G.IsFightingCyborgBoss then
            pcall(function()
                if game.Players.LocalPlayer.Character then
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    
                    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                        game.Players.LocalPlayer.Character.Humanoid:ChangeState(11) -- GettingUp state (more stable than Flying)
                        game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                        game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    end
                end
            end)
        end
    end
end)

-- Smart Server Hopper (finds less crowded servers for better chest farming)
function SmartServerHop()
    if not _G.AutoHopEnabled then return end
    
    pcall(function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = game:GetService("HttpService"):JSONDecode(req)
        
        for i,v in pairs(data.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end
        
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
        else
            wait(30)
            SmartServerHop()
        end
    end)
end

-- Replace the original HopServer function with the smarter version if available
if pcall(function() game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100") end) then
    HopServer = SmartServerHop
end

-- Start the auto chest collect function
AutoChestCollect()

-- Setup Core Brain detection
setupCoreBrainDetection()

-- Initialize by checking for features needed
spawn(function()
    -- Start the main cycle after 10 seconds (allow game to fully load)
    wait(10)
    
    -- Check if already Cyborg
    if isCyborg() then
        _G.AutoCyborg = false
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Cyborg",
            Text = "You already have Cyborg race!",
            Duration = 10
        })
        return
    end
    
    -- Start the main process
    mainCycle()
    
    -- Print initial status
    if _G.AutoCollectChest then
        pcall(function()
            local collectionService = game:GetService("CollectionService")
            local chests = collectionService:GetTagged("_ChestTagged")
            if #chests > 0 then
            else
            end
        end)
    end
    
    -- Check for Fist of Darkness on startup
    if hasFistOfDarkness() then
        _G.FistDetected = true
        _G.HasFistOfDarkness = true
        _G.AutoJump = false

        -- Click detector multiple times
        clickDetectorForNotification()
        wait(1)
        clickDetectorForNotification()
    end
end)

-- Show notification that script is running
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Auto Cyborg Script",
    Text = "Script started successfully!",
    Duration = 10
})

-- HĂ m kiá»ƒm tra Boss Darkbeard (cáº£i tiáº¿n)
function CheckBossAttack()
    -- Kiá»ƒm tra trong ReplicatedStorage
    local replicated = game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard")
    if replicated then return replicated end
    
    -- Kiá»ƒm tra trong workspace.Enemies
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        local boss = enemies:FindFirstChild("Darkbeard")
        if boss then return boss end
    end
    
    -- Kiá»ƒm tra trong workspace
    local workspaceBoss = workspace:FindFirstChild("Darkbeard")
    if workspaceBoss then return workspaceBoss end
    
    return nil
end

-- HĂ m kiá»ƒm tra pháº§n HumanoidRootPart cá»§a boss (cáº£i tiáº¿n)
function DetectingPart(boss)
    if not boss then return false end
    
    -- Kiá»ƒm tra náº¿u boss cĂ³ HumanoidRootPart
    if not boss:FindFirstChild("HumanoidRootPart") then return false end
    
    -- Kiá»ƒm tra Humanoid
    local humanoid = boss:FindFirstChild("Humanoid")
    if not humanoid then 
        -- Cá»‘ gáº¯ng tĂ¬m humanoid vá»›i tĂªn khĂ¡c
        for _, child in pairs(boss:GetChildren()) do
            if child:IsA("Humanoid") then
                humanoid = child
                break
            end
        end
        
        if not humanoid then return false end
    end
    
    -- Kiá»ƒm tra náº¿u boss cĂ²n sá»‘ng
    if humanoid.Health <= 0 then return false end
    
    return true
end

-- HĂ m kiá»ƒm tra Darkbeard vĂ  tráº£ vá» náº¿u tĂ¬m tháº¥y (cáº£i tiáº¿n)
function checkDarkbeard()
    local boss = CheckBossAttack()
    if boss and DetectingPart(boss) then
        return boss
    end
    return nil
end

-- Kiá»ƒm tra xem ngÆ°á»i chÆ¡i cĂ³ Fist of Darkness khĂ´ng
function HasFistOfDarkness()
    local player = game.Players.LocalPlayer
    return player.Backpack:FindFirstChild("Fist of Darkness") or player.Character:FindFirstChild("Fist of Darkness")
end

-- HĂ m kiá»ƒm tra náº¿u cĂ³ chĂ¬a khĂ³a (God's Chalice)
function HasGodsChalice()
    local player = game.Players.LocalPlayer
    return player.Backpack:FindFirstChild("God's Chalice") or player.Character:FindFirstChild("God's Chalice")
end

-- HĂ m bay Ä‘áº¿n vá»‹ trĂ­ cá»§a boss vĂ  Ä‘Ă¡nh (Ä‘Ă£ chá»‰nh sá»­a Ä‘á»ƒ tÆ°Æ¡ng thĂ­ch vá»›i tá»‡p Ä‘áº§u tiĂªn)
function FightDarkbeard()
    local boss = checkDarkbeard()
    
    if boss then
        _G.IsFightingBoss = true
        _G.AutoCollectChest = false
        _G.AutoHopEnabled = false
        
        -- Báº¯t Ä‘áº§u NoClip
        startNoClip()
        
        -- KĂ­ch hoáº¡t Haki vĂ  trang bá»‹ vÅ© khĂ­
        AutoHaki()
        equip("Melee")
        
        spawn(function()
            local attackCooldown = 0
            
            while _G.IsFightingBoss and boss do
                -- KĂ­ch hoáº¡t láº¡i Haki Ä‘á»‹nh ká»³
                AutoHaki()
                
                if tick() - attackCooldown > 2 then
                    equip("Melee")
                    attackCooldown = tick()
                end
                
                -- TĂ¬m boss
                local bossUpdated = checkDarkbeard()
                
                if bossUpdated and bossUpdated:FindFirstChild("HumanoidRootPart") and 
                   bossUpdated:FindFirstChild("Humanoid") and bossUpdated.Humanoid.Health > 0 then
                    -- Kiá»ƒm tra sá»©c khá»e ngÆ°á»i chÆ¡i - náº¿u dÆ°á»›i 2000, bay cao hÆ¡n boss
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    
                    if humanoid and humanoid.Health < 2000 then
                        -- Vá»‹ trĂ­ boss
                        local bossPosition = bossUpdated.HumanoidRootPart.Position
                        -- Bay cao hÆ¡n (100 Ä‘Æ¡n vá»‹ trĂªn boss)
                        local higherPos = CFrame.new(
                            bossPosition.X, 
                            bossPosition.Y + 100, 
                            bossPosition.Z
                        )
                        
                        -- Bay Ä‘áº¿n vá»‹ trĂ­ cao hÆ¡n
                        Tween(higherPos)
                        
                        -- Äá»£i Ä‘áº¿n khi há»“i phá»¥c sá»©c khá»e lĂªn 5000
                        while humanoid.Health < 5000 do
                            -- LiĂªn tá»¥c cáº­p nháº­t vá»‹ trĂ­ Ä‘á»ƒ á»Ÿ trĂªn boss
                            local currentBoss = checkDarkbeard()
                            if currentBoss and currentBoss:FindFirstChild("HumanoidRootPart") then
                                local currentBossPos = currentBoss.HumanoidRootPart.Position
                                local newHigherPos = CFrame.new(
                                    currentBossPos.X,
                                    currentBossPos.Y + 100,
                                    currentBossPos.Z
                                )
                                Tween(newHigherPos)
                            end
                            wait(0.5)
                        end
                    else
                        -- Di chuyá»ƒn Ä‘áº¿n vá»‹ trĂ­ boss (hÆ¡i cao hÆ¡n boss)
                        local bossPosition = bossUpdated.HumanoidRootPart.Position
                        local targetPos = CFrame.new(
                            bossPosition.X, 
                            bossPosition.Y + 25, 
                            bossPosition.Z
                        )
                        
                        -- Bay Ä‘áº¿n vá»‹ trĂ­ boss
                        Tween(targetPos)
                        
                        -- Quay máº·t vá» phĂ­a boss
                        pcall(function()
                            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position,
                                    Vector3.new(bossUpdated.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, bossUpdated.HumanoidRootPart.Position.Z)
                                )
                            end
                        end)
                        
                        -- Táº¥n cĂ´ng
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))
                    end
                else
                    -- Kiá»ƒm tra xem boss Ä‘Ă£ bá»‹ Ä‘Ă¡nh báº¡i chÆ°a
                    _G.IsFightingBoss = false
                    
                    -- Kiá»ƒm tra cĂ¡c váº­t pháº©m Ä‘áº·c biá»‡t sau khi Ä‘Ă¡nh boss
                    if HasFistOfDarkness() then
                        -- ThĂ´ng bĂ¡o Ä‘Ă£ cĂ³ Fist of Darkness
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "ÄĂ£ nháº­n Fist of Darkness",
                            Text = "Tiáº¿p tá»¥c sÄƒn boss hoáº·c tĂ¬m kiáº¿m váº­t pháº©m khĂ¡c",
                            Duration = 5
                        })
                    else
                        -- Báº­t láº¡i AutoCollectChest náº¿u khĂ´ng cĂ³ váº­t pháº©m Ä‘áº·c biá»‡t
                        _G.AutoCollectChest = true
                        _G.AutoHopEnabled = true
                    end
                    
                    break
                end
                
                wait(0.1)
            end
        end)
    end
end

-- HĂ m Ä‘i Ä‘áº¿n cá»•ng Darkbeard khi cĂ³ Fist of Darkness
function GoToDarkbeardGate()
    local darkbeardGate = CFrame.new(3779.50708, 15.0840397, -3500.45386, -0.998627782, 7.57007683e-08, 0.0523698553, 7.95809925e-08, 1, 7.20074809e-08, -0.0523698553, 7.60763115e-08, -0.998627782)
    
    -- Táº¯t táº¡m thá»i auto chest
    _G.AutoCollectChest = false
    
    -- Bay Ä‘áº¿n cá»•ng
    SafeTween(darkbeardGate, 350)
    wait(1)  -- Äá»£i má»™t chĂºt á»Ÿ cá»•ng
    
    -- Kiá»ƒm tra xem boss Ä‘Ă£ xuáº¥t hiá»‡n chÆ°a
    if checkDarkbeard() then
        FightDarkbeard()
    else
        -- Náº¿u khĂ´ng cĂ³ boss, click detector náº¿u cĂ³
        local detector, buttonPosition = findClickDetector()
        if detector then
            if buttonPosition and not isPlayerCloseToButton(buttonPosition) then
                teleportToButton(buttonPosition)
                wait(1)
            end
            
            pcall(function() fireclickdetector(detector) end)
            wait(0.5)
            pcall(function() fireclickdetector(detector) end)
            
            wait(3)
            
            -- Kiá»ƒm tra láº¡i xem boss Ä‘Ă£ xuáº¥t hiá»‡n chÆ°a
            if checkDarkbeard() then
                FightDarkbeard()
            else
                -- Báº­t láº¡i auto chest náº¿u khĂ´ng cĂ³ boss
                _G.AutoCollectChest = true
            end
        else
            -- Báº­t láº¡i auto chest náº¿u khĂ´ng tĂ¬m tháº¥y detector
            _G.AutoCollectChest = true
        end
    end
end

-- Function Auto NoClip (bá»• sung cho táº­p tin Ä‘áº§u tiĂªn)
function startNoClip()
    pcall(function()
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Anti-gravity Ä‘á»ƒ trĂ¡nh rÆ¡i
        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiGravity") then
                local ag = Instance.new("BodyVelocity")
                ag.Name = "AntiGravity"
                ag.MaxForce = Vector3.new(0, 9999, 0)
                ag.Velocity = Vector3.new(0, 0.1, 0)
                ag.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            end
        end
    end)
end

-- Coroutine kiá»ƒm tra Darkbeard vĂ  Ä‘Ă¡nh náº¿u cáº§n
spawn(function()
    while wait(1) do
        if _G.AutoFightDarkbeard then  -- LuĂ´n Ä‘Ă¡nh Darkbeard (Cháº¿ Ä‘á»™ 2)
            local boss = checkDarkbeard()
            if boss and not _G.IsFightingBoss then
                FightDarkbeard()
            end
        elseif _G.FightDarkbeardOnlyWithFist and HasFistOfDarkness() then  -- Chá»‰ Ä‘Ă¡nh vá»›i Fist (Cháº¿ Ä‘á»™ 1)
            local boss = checkDarkbeard()
            if boss and not _G.IsFightingBoss then
                FightDarkbeard()
            elseif not _G.IsFightingBoss then
                -- Náº¿u cĂ³ Fist of Darkness nhÆ°ng khĂ´ng cĂ³ boss, bay Ä‘áº¿n cá»•ng
                GoToDarkbeardGate()
                wait(5)  -- Äá»£i má»™t lĂºc á»Ÿ cá»•ng trÆ°á»›c khi kiá»ƒm tra láº¡i
            end
        end
    end
end)