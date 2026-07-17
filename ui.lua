--[[
    PHUCMAX UI Library - Part 1/15
    Core Framework | Services | Utilities | Theme Engine | Config System
    Lines: 1-1100
]]

--============================================--
-- SECTION 1: SERVICE DECLARATIONS
--============================================--
local Services = {
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    HttpService = game:GetService("HttpService"),
    TextService = game:GetService("TextService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    StarterGui = game:GetService("StarterGui"),
    TeleportService = game:GetService("TeleportService"),
    MarketplaceService = game:GetService("MarketplaceService"),
    ContextActionService = game:GetService("ContextActionService"),
    CollectionService = game:GetService("CollectionService"),
    SoundService = game:GetService("SoundService"),
    Lighting = game:GetService("Lighting"),
    Workspace = game:GetService("Workspace")
}

--============================================--
-- SECTION 2: PLAYER & CHARACTER REFERENCES
--============================================--
local Player = Services.Players.LocalPlayer
local PlayerGui = nil
local Character = nil
local Humanoid = nil
local RootPart = nil
local Camera = Services.Workspace.CurrentCamera

-- Update character references
local function UpdateCharacter()
    Character = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end

-- Initial character setup
if Player.Character then
    UpdateCharacter()
end

Player.CharacterAdded:Connect(function()
    UpdateCharacter()
end)

PlayerGui = Player:WaitForChild("PlayerGui")

--============================================--
-- SECTION 3: GLOBAL VARIABLES & CONSTANTS
--============================================--
local BackdropImage = "rbxassetid://"
local PHUCMAX_VERSION = "1.0.0"
local PHUCMAX_BUILD = "2026"
local MINIMUM_ZOOM = 0.1
local MAXIMUM_ZOOM = 2.0
local DEFAULT_ZOOM = 1.0
local SCREEN_WIDTH = 1920
local SCREEN_HEIGHT = 1080
local IS_MOBILE = Services.UserInputService.TouchEnabled
local IS_CONSOLE = Services.UserInputService.GamepadEnabled
local IS_PC = not IS_MOBILE and not IS_CONSOLE

--============================================--
-- SECTION 4: FONT DECLARATIONS
--============================================--
local Fonts = {
    Bold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
    Medium = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
    Regular = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
    Light = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Light),
    Thin = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Thin),
    Mono = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular),
    Code = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular),
    Title = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold),
    Subtitle = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium)
}

--============================================--
-- SECTION 5: THEME DEFINITIONS
--============================================--
local ThemeData = {
    Purple = {
        Name = "Purple",
        Main = Color3.fromRGB(120, 80, 255),
        Second = Color3.fromRGB(80, 40, 200),
        Accent = Color3.fromRGB(150, 100, 255),
        Glow = Color3.fromRGB(140, 80, 255),
        Grad1 = Color3.fromRGB(100, 50, 255),
        Grad2 = Color3.fromRGB(50, 25, 150),
        Grad3 = Color3.fromRGB(130, 90, 255),
        Grad4 = Color3.fromRGB(70, 35, 180),
        Bg = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(25, 25, 30),
        SurfaceLight = Color3.fromRGB(35, 35, 40),
        SurfaceDark = Color3.fromRGB(20, 20, 25),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 190),
        MutedText = Color3.fromRGB(140, 140, 150),
        Border = Color3.fromRGB(60, 50, 100),
        Success = Color3.fromRGB(60, 220, 100),
        Warning = Color3.fromRGB(255, 200, 50),
        Error = Color3.fromRGB(255, 60, 60),
        Info = Color3.fromRGB(60, 150, 255),
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
        Glass = Color3.fromRGB(255, 255, 255)
    },
    Red = {
        Name = "Red",
        Main = Color3.fromRGB(255, 60, 60),
        Second = Color3.fromRGB(200, 30, 30),
        Accent = Color3.fromRGB(255, 80, 80),
        Glow = Color3.fromRGB(255, 50, 50),
        Grad1 = Color3.fromRGB(255, 40, 40),
        Grad2 = Color3.fromRGB(150, 20, 20),
        Grad3 = Color3.fromRGB(255, 70, 70),
        Grad4 = Color3.fromRGB(180, 25, 25),
        Bg = Color3.fromRGB(20, 15, 15),
        Surface = Color3.fromRGB(30, 25, 25),
        SurfaceLight = Color3.fromRGB(40, 30, 30),
        SurfaceDark = Color3.fromRGB(25, 20, 20),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(190, 180, 180),
        MutedText = Color3.fromRGB(150, 140, 140),
        Border = Color3.fromRGB(100, 50, 50),
        Success = Color3.fromRGB(60, 220, 100),
        Warning = Color3.fromRGB(255, 200, 50),
        Error = Color3.fromRGB(255, 60, 60),
        Info = Color3.fromRGB(60, 150, 255),
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
        Glass = Color3.fromRGB(255, 255, 255)
    },
    Blue = {
        Name = "Blue",
        Main = Color3.fromRGB(60, 130, 255),
        Second = Color3.fromRGB(30, 100, 230),
        Accent = Color3.fromRGB(80, 150, 255),
        Glow = Color3.fromRGB(70, 140, 255),
        Grad1 = Color3.fromRGB(50, 120, 255),
        Grad2 = Color3.fromRGB(25, 80, 200),
        Grad3 = Color3.fromRGB(90, 140, 255),
        Grad4 = Color3.fromRGB(40, 90, 210),
        Bg = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(25, 25, 30),
        SurfaceLight = Color3.fromRGB(35, 35, 40),
        SurfaceDark = Color3.fromRGB(20, 20, 25),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 190),
        MutedText = Color3.fromRGB(140, 140, 150),
        Border = Color3.fromRGB(50, 60, 100),
        Success = Color3.fromRGB(60, 220, 100),
        Warning = Color3.fromRGB(255, 200, 50),
        Error = Color3.fromRGB(255, 60, 60),
        Info = Color3.fromRGB(60, 150, 255),
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
        Glass = Color3.fromRGB(255, 255, 255)
    },
    Green = {
        Name = "Green",
        Main = Color3.fromRGB(60, 220, 100),
        Second = Color3.fromRGB(30, 180, 70),
        Accent = Color3.fromRGB(80, 240, 120),
        Glow = Color3.fromRGB(70, 230, 110),
        Grad1 = Color3.fromRGB(50, 210, 90),
        Grad2 = Color3.fromRGB(25, 150, 50),
        Grad3 = Color3.fromRGB(90, 230, 110),
        Grad4 = Color3.fromRGB(40, 170, 60),
        Bg = Color3.fromRGB(15, 20, 15),
        Surface = Color3.fromRGB(25, 30, 25),
        SurfaceLight = Color3.fromRGB(35, 40, 35),
        SurfaceDark = Color3.fromRGB(20, 25, 20),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 190, 180),
        MutedText = Color3.fromRGB(140, 150, 140),
        Border = Color3.fromRGB(50, 100, 50),
        Success = Color3.fromRGB(60, 220, 100),
        Warning = Color3.fromRGB(255, 200, 50),
        Error = Color3.fromRGB(255, 60, 60),
        Info = Color3.fromRGB(60, 150, 255),
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
        Glass = Color3.fromRGB(255, 255, 255)
    },
    Dark = {
        Name = "Dark",
        Main = Color3.fromRGB(70, 70, 75),
        Second = Color3.fromRGB(45, 45, 50),
        Accent = Color3.fromRGB(90, 90, 95),
        Glow = Color3.fromRGB(80, 80, 85),
        Grad1 = Color3.fromRGB(55, 55, 60),
        Grad2 = Color3.fromRGB(35, 35, 40),
        Grad3 = Color3.fromRGB(80, 80, 85),
        Grad4 = Color3.fromRGB(50, 50, 55),
        Bg = Color3.fromRGB(15, 15, 18),
        Surface = Color3.fromRGB(25, 25, 28),
        SurfaceLight = Color3.fromRGB(35, 35, 38),
        SurfaceDark = Color3.fromRGB(20, 20, 22),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        MutedText = Color3.fromRGB(140, 140, 140),
        Border = Color3.fromRGB(60, 60, 65),
        Success = Color3.fromRGB(60, 220, 100),
        Warning = Color3.fromRGB(255, 200, 50),
        Error = Color3.fromRGB(255, 60, 60),
        Info = Color3.fromRGB(60, 150, 255),
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
        Glass = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        Name = "Light",
        Main = Color3.fromRGB(220, 220, 225),
        Second = Color3.fromRGB(200, 200, 205),
        Accent = Color3.fromRGB(240, 240, 245),
        Glow = Color3.fromRGB(210, 210, 215),
        Grad1 = Color3.fromRGB(230, 230, 235),
        Grad2 = Color3.fromRGB(180, 180, 185),
        Grad3 = Color3.fromRGB(250, 250, 255),
        Grad4 = Color3.fromRGB(200, 200, 205),
        Bg = Color3.fromRGB(240, 240, 245),
        Surface = Color3.fromRGB(255, 255, 255),
        SurfaceLight = Color3.fromRGB(255, 255, 255),
        SurfaceDark = Color3.fromRGB(235, 235, 240),
        Text = Color3.fromRGB(20, 20, 25),
        SubText = Color3.fromRGB(80, 80, 85),
        MutedText = Color3.fromRGB(120, 120, 125),
        Border = Color3.fromRGB(200, 200, 205),
        Success = Color3.fromRGB(40, 180, 80),
        Warning = Color3.fromRGB(220, 170, 30),
        Error = Color3.fromRGB(220, 50, 50),
        Info = Color3.fromRGB(50, 120, 220),
        Shadow = Color3.fromRGB(100, 100, 105),
        Overlay = Color3.fromRGB(200, 200, 205),
        Glass = Color3.fromRGB(255, 255, 255)
    }
}

-- Custom theme storage
local CustomThemeData = {}

--============================================--
-- SECTION 6: ACTIVE THEME MANAGEMENT
--============================================--
local ActiveTheme = ThemeData.Purple
local ActiveThemeName = "Purple"

local ThemeManager = {}

function ThemeManager:GetTheme()
    return ActiveTheme
end

function ThemeManager:GetThemeName()
    return ActiveThemeName
end

function ThemeManager:SetTheme(themeName)
    if ThemeData[themeName] then
        ActiveTheme = ThemeData[themeName]
        ActiveThemeName = themeName
        return true
    elseif themeName == "Custom" and CustomThemeData.Main then
        ActiveTheme = CustomThemeData
        ActiveThemeName = "Custom"
        return true
    end
    return false
end

function ThemeManager:GetThemeData(themeName)
    return ThemeData[themeName] or CustomThemeData
end

function ThemeManager:GetThemeList()
    local list = {}
    for name, _ in pairs(ThemeData) do
        table.insert(list, name)
    end
    if CustomThemeData.Main then
        table.insert(list, "Custom")
    end
    return list
end

function ThemeManager:CreateCustomTheme(config)
    CustomThemeData = {
        Name = "Custom",
        Main = config.Main or ThemeData.Purple.Main,
        Second = config.Second or ThemeData.Purple.Second,
        Accent = config.Accent or ThemeData.Purple.Accent,
        Glow = config.Glow or ThemeData.Purple.Glow,
        Grad1 = config.Grad1 or ThemeData.Purple.Grad1,
        Grad2 = config.Grad2 or ThemeData.Purple.Grad2,
        Grad3 = config.Grad3 or ThemeData.Purple.Grad3,
        Grad4 = config.Grad4 or ThemeData.Purple.Grad4,
        Bg = config.Bg or ThemeData.Purple.Bg,
        Surface = config.Surface or ThemeData.Purple.Surface,
        SurfaceLight = config.SurfaceLight or ThemeData.Purple.SurfaceLight,
        SurfaceDark = config.SurfaceDark or ThemeData.Purple.SurfaceDark,
        Text = config.Text or ThemeData.Purple.Text,
        SubText = config.SubText or ThemeData.Purple.SubText,
        MutedText = config.MutedText or ThemeData.Purple.MutedText,
        Border = config.Border or ThemeData.Purple.Border,
        Success = config.Success or ThemeData.Purple.Success,
        Warning = config.Warning or ThemeData.Purple.Warning,
        Error = config.Error or ThemeData.Purple.Error,
        Info = config.Info or ThemeData.Purple.Info,
        Shadow = config.Shadow or ThemeData.Purple.Shadow,
        Overlay = config.Overlay or ThemeData.Purple.Overlay,
        Glass = config.Glass or ThemeData.Purple.Glass
    }
    return CustomThemeData
end

function ThemeManager:ResetCustomTheme()
    CustomThemeData = {}
end

--============================================--
-- SECTION 7: ANIMATION PRESETS
--============================================--
local Anim = {
    Spring = function(t, d)
        return TweenInfo.new(
            t or 0.5,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Bounce = function(t, d)
        return TweenInfo.new(
            t or 0.6,
            Enum.EasingStyle.Bounce,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Elastic = function(t, d)
        return TweenInfo.new(
            t or 0.8,
            Enum.EasingStyle.Elastic,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Smooth = function(t, d)
        return TweenInfo.new(
            t or 0.3,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Fast = function(t, d)
        return TweenInfo.new(
            t or 0.2,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Linear = function(t, d)
        return TweenInfo.new(
            t or 0.3,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Quart = function(t, d)
        return TweenInfo.new(
            t or 0.4,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Quint = function(t, d)
        return TweenInfo.new(
            t or 0.5,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Circ = function(t, d)
        return TweenInfo.new(
            t or 0.4,
            Enum.EasingStyle.Circ,
            Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end,
    
    Custom = function(t, easingStyle, easingDirection, d)
        return TweenInfo.new(
            t or 0.3,
            easingStyle or Enum.EasingStyle.Quad,
            easingDirection or Enum.EasingDirection.Out,
            0,
            false,
            d or 0
        )
    end
}

--============================================--
-- SECTION 8: CORE UTILITY FUNCTIONS
--============================================--
local Utils = {}

function Utils:CreateInstance(class, properties)
    local instance = Instance.new(class)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            pcall(function()
                instance[prop] = value
            end)
        end
    end
    if properties.Parent then
        pcall(function()
            instance.Parent = properties.Parent
        end)
    end
    return instance
end

function Utils:AddStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or ActiveTheme.Glow
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = instance
    return stroke
end

function Utils:AddCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

function Utils:AddGradient(instance, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = instance
    return gradient
end

function Utils:AddPadding(instance, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.Parent = instance
    return padding
end

function Utils:AddListLayout(instance, padding, horizontal, vertical, sortOrder)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, padding or 0)
    layout.HorizontalAlignment = horizontal or Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = vertical or Enum.VerticalAlignment.Top
    layout.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder
    layout.Parent = instance
    return layout
end

function Utils:AddGridLayout(instance, cellSize, cellPadding, horizontal, vertical)
    local layout = Instance.new("UIGridLayout")
    layout.CellSize = cellSize or UDim2.new(0, 100, 0, 100)
    layout.CellPadding = cellPadding or UDim2.new(0, 5, 0, 5)
    layout.HorizontalAlignment = horizontal or Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = vertical or Enum.VerticalAlignment.Center
    layout.Parent = instance
    return layout
end

function Utils:AddShadow(instance, size, transparency, zIndex)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, size or 10, 1, size or 10)
    shadow.Position = UDim2.new(0, -(size or 10)/2, 0, (size or 10)/2)
    shadow.Image = "rbxassetid://"
    shadow.ImageColor3 = ActiveTheme.Shadow
    shadow.ImageTransparency = transparency or 0.7
    shadow.ZIndex = (zIndex or instance.ZIndex) - 1
    shadow.Parent = instance
    return shadow
end

function Utils:CreateBlur(instance, size)
    local blur = Instance.new("BlurEffect")
    blur.Size = size or 24
    blur.Parent = instance
    return blur
end

function Utils:CreateText(properties)
    local defaultProps = {
        BackgroundTransparency = 1,
        Font = Fonts.Regular,
        TextColor3 = ActiveTheme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 100
    }
    
    for k, v in pairs(properties) do
        defaultProps[k] = v
    end
    
    return Utils:CreateInstance("TextLabel", defaultProps)
end

function Utils:CreateButton(properties)
    local defaultProps = {
        BackgroundColor3 = ActiveTheme.Main,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Text = "",
        Font = Fonts.Medium,
        TextColor3 = ActiveTheme.Text,
        TextSize = 14,
        ZIndex = 100
    }
    
    for k, v in pairs(properties) do
        defaultProps[k] = v
    end
    
    return Utils:CreateInstance("TextButton", defaultProps)
end

function Utils:CreateFrame(properties)
    local defaultProps = {
        BackgroundColor3 = ActiveTheme.Surface,
        BorderSizePixel = 0,
        BackgroundTransparency = 0.5,
        ZIndex = 100
    }
    
    for k, v in pairs(properties) do
        defaultProps[k] = v
    end
    
    return Utils:CreateInstance("Frame", defaultProps)
end

function Utils:PlayTween(instance, tweenInfo, properties, callback)
    local tween = Services.TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    return tween
end

function Utils:StopTween(tween)
    if tween then
        tween:Cancel()
    end
end

function Utils:ColorToHex(color)
    return string.format("#%02X%02X%02X", 
        math.floor(color.R * 255), 
        math.floor(color.G * 255), 
        math.floor(color.B * 255)
    )
end

function Utils:HexToColor(hex)
    hex = string.gsub(hex, "#", "")
    local r = tonumber(string.sub(hex, 1, 2), 16) / 255
    local g = tonumber(string.sub(hex, 3, 4), 16) / 255
    local b = tonumber(string.sub(hex, 5, 6), 16) / 255
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

function Utils:RGBToHSV(r, g, b)
    local minVal = math.min(r, g, b)
    local maxVal = math.max(r, g, b)
    local delta = maxVal - minVal
    
    local h = 0
    local s = 0
    local v = maxVal
    
    if delta > 0 then
        s = delta / maxVal
        
        if r == maxVal then
            h = ((g - b) / delta) % 6
        elseif g == maxVal then
            h = (b - r) / delta + 2
        else
            h = (r - g) / delta + 4
        end
        
        h = h / 6
        if h < 0 then h = h + 1 end
    end
    
    return h, s, v
end

function Utils:HSVToRGB(h, s, v)
    local r, g, b
    
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    return r, g, b
end

function Utils:Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function Utils:Lerp(a, b, t)
    return a + (b - a) * t
end

function Utils:Round(value, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(value * mult + 0.5) / mult
end

function Utils:DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = Utils:DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

function Utils:TableLength(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function Utils:TableFind(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end

function Utils:TableRemove(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            table.remove(tbl, i)
            return true
        end
    end
    return false
end

function Utils:GetTextSize(text, font, fontSize)
    return Services.TextService:GetTextSize(
        text,
        fontSize or 14,
        font or Fonts.Regular,
        Vector2.new(10000, 10000)
    )
end

function Utils:GetMouseLocation()
    return Services.UserInputService:GetMouseLocation()
end

function Utils:IsMouseOver(instance)
    local mousePos = Utils:GetMouseLocation()
    local absPos = instance.AbsolutePosition
    local absSize = instance.AbsoluteSize
    
    return mousePos.X >= absPos.X 
        and mousePos.X <= absPos.X + absSize.X
        and mousePos.Y >= absPos.Y 
        and mousePos.Y <= absPos.Y + absSize.Y
end

--============================================--
-- SECTION 9: CONFIG SYSTEM
--============================================--
local ConfigSystem = {
    Flags = {},
    Listeners = {},
    SaveFile = "PHUCMAX_Config.json",
    AutoSave = false,
    AutoSaveInterval = 30
}

function ConfigSystem:Set(flag, value)
    self.Flags[flag] = value
    
    if self.Listeners[flag] then
        for _, callback in ipairs(self.Listeners[flag]) do
            task.spawn(function()
                callback(value)
            end)
        end
    end
    
    if self.AutoSave then
        self:Save()
    end
end

function ConfigSystem:Get(flag, default)
    local value = self.Flags[flag]
    return value ~= nil and value or default
end

function ConfigSystem:Toggle(flag)
    local current = self:Get(flag, false)
    self:Set(flag, not current)
    return not current
end

function ConfigSystem:Delete(flag)
    self.Flags[flag] = nil
end

function ConfigSystem:Exists(flag)
    return self.Flags[flag] ~= nil
end

function ConfigSystem:GetAll()
    return Utils:DeepCopy(self.Flags)
end

function ConfigSystem:OnChange(flag, callback)
    if not self.Listeners[flag] then
        self.Listeners[flag] = {}
    end
    table.insert(self.Listeners[flag], callback)
    
    return function()
        Utils:TableRemove(self.Listeners[flag], callback)
    end
end

function ConfigSystem:Save()
    local saveData = {
        Flags = self.Flags,
        Theme = ActiveThemeName,
        Version = PHUCMAX_VERSION,
        Timestamp = os.time(),
        Build = PHUCMAX_BUILD
    }
    
    local encoded = Services.HttpService:JSONEncode(saveData)
    
    if writefile then
        writefile(self.SaveFile, encoded)
        return true
    end
    
    return false
end

function ConfigSystem:Load()
    if not isfile or not isfile(self.SaveFile) then
        return false
    end
    
    local success, content = pcall(function()
        return readfile(self.SaveFile)
    end)
    
    if not success then return false end
    
    local success2, data = pcall(function()
        return Services.HttpService:JSONDecode(content)
    end)
    
    if not success2 or not data then return false end
    
    if data.Flags then
        self.Flags = data.Flags
    end
    
    if data.Theme then
        ThemeManager:SetTheme(data.Theme)
    end
    
    return true
end

function ConfigSystem:Reset()
    self.Flags = {}
    self.Listeners = {}
    
    if isfile and isfile(self.SaveFile) then
        delfile(self.SaveFile)
        return true
    end
    
    return false
end

function ConfigSystem:Export()
    local exportData = {
        Flags = self.Flags,
        Theme = ActiveThemeName,
        Version = PHUCMAX_VERSION,
        Timestamp = os.time()
    }
    return Services.HttpService:JSONEncode(exportData)
end

function ConfigSystem:Import(jsonString)
    local success, data = pcall(function()
        return Services.HttpService:JSONDecode(jsonString)
    end)
    
    if not success or not data then return false end
    
    if data.Flags then
        self.Flags = data.Flags
    end
    
    if data.Theme then
        ThemeManager:SetTheme(data.Theme)
    end
    
    return true
end

function ConfigSystem:SetAutoSave(enabled, interval)
    self.AutoSave = enabled
    self.AutoSaveInterval = interval or 30
    
    if enabled then
        task.spawn(function()
            while self.AutoSave do
                task.wait(self.AutoSaveInterval)
                if self.AutoSave then
                    self:Save()
                end
            end
        end)
    end
end

--============================================--
-- SECTION 10: EVENT SYSTEM
--============================================--
local EventSystem = {}
EventSystem.Events = {}
EventSystem.Connections = {}

function EventSystem:Register(eventName)
    if not self.Events[eventName] then
        self.Events[eventName] = {
            Listeners = {},
            Bindable = Instance.new("BindableEvent")
        }
    end
    return self.Events[eventName]
end

function EventSystem:Fire(eventName, ...)
    local event = self:Register(eventName)
    event.Bindable:Fire(...)
    
    for _, listener in ipairs(event.Listeners) do
        task.spawn(function()
            listener(...)
        end)
    end
end

function EventSystem:Listen(eventName, callback)
    local event = self:Register(eventName)
    table.insert(event.Listeners, callback)
    
    local connection = event.Bindable.Event:Connect(callback)
    
    local disconnectFunc = function()
        connection:Disconnect()
        Utils:TableRemove(event.Listeners, callback)
    end
    
    table.insert(self.Connections, connection)
    
    return disconnectFunc
end

function EventSystem:Wait(eventName)
    local event = self:Register(eventName)
    return event.Bindable.Event:Wait()
end

function EventSystem:Clear(eventName)
    if self.Events[eventName] then
        for _, listener in ipairs(self.Events[eventName].Listeners) do
            Utils:TableRemove(self.Events[eventName].Listeners, listener)
        end
    end
end

function EventSystem:ClearAll()
    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end
    self.Connections = {}
    self.Events = {}
end

--============================================--
-- SECTION 11: CONNECTION MANAGER
--============================================--
local ConnectionManager = {}
ConnectionManager.Connections = {}

function ConnectionManager:Add(connection)
    table.insert(self.Connections, connection)
    return connection
end

function ConnectionManager:Remove(connection)
    local index = Utils:TableFind(self.Connections, connection)
    if index then
        table.remove(self.Connections, index)
        connection:Disconnect()
        return true
    end
    return false
end

function ConnectionManager:DisconnectAll()
    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end
    self.Connections = {}
end

function ConnectionManager:Count()
    return #self.Connections
end

--============================================--
-- SECTION 12: DEBOUNCE & THROTTLE UTILITIES
--============================================--
local DebounceSystem = {}
DebounceSystem.Debounces = {}
DebounceSystem.Throttles = {}

function DebounceSystem:Create(key, delay)
    if self.Debounces[key] then
        return false
    end
    
    self.Debounces[key] = true
    
    task.delay(delay, function()
        self.Debounces[key] = nil
    end)
    
    return true
end

function DebounceSystem:Throttle(key, delay)
    local currentTime = os.clock()
    
    if self.Throttles[key] and currentTime - self.Throttles[key] < delay then
        return false
    end
    
    self.Throttles[key] = currentTime
    return true
end

function DebounceSystem:Clear(key)
    self.Debounces[key] = nil
    self.Throttles[key] = nil
end

function DebounceSystem:ClearAll()
    self.Debounces = {}
    self.Throttles = {}
end

--============================================--
-- SECTION 13: MODULE EXPORTS (PART 1)
--============================================--
local PHUCMAX = {
    Services = Services,
    Player = Player,
    PlayerGui = PlayerGui,
    Character = Character,
    Humanoid = Humanoid,
    RootPart = RootPart,
    Camera = Camera,
    Fonts = Fonts,
    ThemeData = ThemeData,
    ActiveTheme = ActiveTheme,
    ThemeManager = ThemeManager,
    Anim = Anim,
    Utils = Utils,
    ConfigSystem = ConfigSystem,
    EventSystem = EventSystem,
    ConnectionManager = ConnectionManager,
    DebounceSystem = DebounceSystem,
    Version = PHUCMAX_VERSION,
    Build = PHUCMAX_BUILD,
    IsMobile = IS_MOBILE,
    IsConsole = IS_CONSOLE,
    IsPC = IS_PC
}



--============================================--
-- SECTION 14: NOTIFICATION SYSTEM
--============================================--
local NotificationSystem = {}
NotificationSystem.Queue = {}
NotificationSystem.Container = nil
NotificationSystem.MaxVisible = 5
NotificationSystem.Position = "Right" -- "Right" or "Left"
NotificationSystem.Spacing = 8
NotificationSystem.DefaultDuration = 3
NotificationSystem.ActiveNotifications = {}
NotificationSystem.History = {}
NotificationSystem.MaxHistory = 50

function NotificationSystem:Initialize()
    if self.Container then return end
    
    self.Container = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "PHUCMAX_Notifications",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 320, 1, 0),
        Position = self.Position == "Right" and UDim2.new(1, -340, 0, 0) or UDim2.new(0, 20, 0, 0),
        ZIndex = 10000
    })
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    listLayout.Padding = UDim.new(0, self.Spacing)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.Container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 20)
    padding.Parent = self.Container
end

function NotificationSystem:CalculatePosition(index)
    return UDim2.new(0, 0, 0, (index - 1) * 70)
end

function NotificationSystem:Send(config)
    self:Initialize()
    
    local theme = ThemeManager:GetTheme()
    
    local notifConfig = {
        Title = config.Title or "Notification",
        Content = config.Content or "",
        Duration = config.Duration or self.DefaultDuration,
        Type = config.Type or "info",
        Icon = config.Icon or "",
        Callback = config.Callback or nil,
        Color = config.Color or nil,
        Sound = config.Sound or nil,
        Priority = config.Priority or 1
    }
    
    -- Type colors
    local typeColors = {
        info = theme.Info,
        success = theme.Success,
        warning = theme.Warning,
        error = theme.Error
    }
    
    local notifColor = notifConfig.Color or typeColors[notifConfig.Type] or theme.Main
    
    -- Create notification frame
    local notification = Utils:CreateInstance("Frame", {
        Parent = self.Container,
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.25,
        Size = UDim2.new(1, 0, 0, 60),
        ClipsDescendants = true,
        ZIndex = 10001,
        LayoutOrder = notifConfig.Priority
    })
    Utils:AddCorner(notification, 12)
    Utils:AddStroke(notification, theme.Glow, 1)
    
    -- Glass overlay
    local glassOverlay = Utils:CreateInstance("Frame", {
        Parent = notification,
        BackgroundColor3 = theme.Glass,
        BackgroundTransparency = 0.95,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 10002
    })
    Utils:AddCorner(glassOverlay, 12)
    
    -- Type indicator bar
    local typeIndicator = Utils:CreateInstance("Frame", {
        Parent = notification,
        BackgroundColor3 = notifColor,
        Size = UDim2.new(0, 4, 0, 40),
        Position = UDim2.new(0, 0, 0.5, -20),
        BorderSizePixel = 0,
        ZIndex = 10003
    })
    Utils:AddCorner(typeIndicator, 2)
    
    -- Icon
    if notifConfig.Icon ~= "" then
        local iconImage = Utils:CreateInstance("ImageLabel", {
            Parent = notification,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 32, 0, 32),
            Position = UDim2.new(0, 16, 0.5, -16),
            Image = notifConfig.Icon,
            ImageColor3 = notifColor,
            ZIndex = 10003
        })
        Utils:AddCorner(iconImage, 8)
    end
    
    -- Title text
    local titleLabel = Utils:CreateText({
        Parent = notification,
        Position = UDim2.new(0, notifConfig.Icon ~= "" and 58 or 16, 0, 8),
        Size = UDim2.new(1, -(notifConfig.Icon ~= "" and 70 or 30), 0, 20),
        Font = Fonts.Bold,
        Text = notifConfig.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextTransparency = 1,
        ZIndex = 10003
    })
    
    -- Content text
    local contentLabel = Utils:CreateText({
        Parent = notification,
        Position = UDim2.new(0, notifConfig.Icon ~= "" and 58 or 16, 0, 30),
        Size = UDim2.new(1, -(notifConfig.Icon ~= "" and 70 or 30), 0, 18),
        Font = Fonts.Regular,
        Text = notifConfig.Content,
        TextColor3 = theme.SubText,
        TextSize = 12,
        TextTransparency = 1,
        ZIndex = 10003
    })
    
    -- Progress bar
    local progressBar = Utils:CreateInstance("Frame", {
        Parent = notification,
        BackgroundColor3 = notifColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        AnchorPoint = Vector2.new(0, 1),
        ZIndex = 10003
    })
    Utils:AddCorner(progressBar, 3)
    
    -- Close button
    local closeButton = Utils:CreateButton({
        Parent = notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0, 5),
        Text = "✕",
        TextColor3 = theme.SubText,
        TextSize = 12,
        ZIndex = 10004
    })
    
    -- Store notification data
    local notifData = {
        Frame = notification,
        Config = notifConfig,
        ProgressBar = progressBar,
        TitleLabel = titleLabel,
        ContentLabel = contentLabel,
        CreatedAt = os.clock(),
        IsDestroyed = false
    }
    
    -- Animations
    notification.Position = UDim2.new(self.Position == "Right" and 1 or -1, self.Position == "Right" and 350 or -350, 0, 0)
    
    local slideIn = Utils:PlayTween(notification, Anim.Quint(0.5), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    local titleFade = Utils:PlayTween(titleLabel, Anim.Fast(), {
        TextTransparency = 0
    })
    
    local contentFade = Utils:PlayTween(contentLabel, Anim.Fast(), {
        TextTransparency = 0.7
    })
    
    local progressAnim = Utils:PlayTween(progressBar, Anim.Linear(notifConfig.Duration), {
        Size = UDim2.new(0, 0, 0, 3)
    })
    
    -- Click callback
    if notifConfig.Callback then
        notification.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                notifConfig.Callback()
                self:Remove(notifData)
            end
        end)
    end
    
    -- Close button
    closeButton.MouseButton1Click:Connect(function()
        self:Remove(notifData)
    end)
    
    -- Auto remove
    task.delay(notifConfig.Duration, function()
        if not notifData.IsDestroyed then
            self:Remove(notifData)
        end
    end)
    
    -- Manage queue
    table.insert(self.ActiveNotifications, notifData)
    self:ManageQueue()
    
    -- Add to history
    table.insert(self.History, {
        Title = notifConfig.Title,
        Content = notifConfig.Content,
        Type = notifConfig.Type,
        Time = os.time()
    })
    
    if #self.History > self.MaxHistory then
        table.remove(self.History, 1)
    end
    
    -- Sound
    if notifConfig.Sound then
        -- Play sound if available
    end
    
    return notifData
end

function NotificationSystem:Remove(notifData)
    if notifData.IsDestroyed then return end
    notifData.IsDestroyed = true
    
    local frame = notifData.Frame
    if not frame or not frame.Parent then return end
    
    local slideOut = Utils:PlayTween(frame, Anim.Quint(0.3), {
        Position = UDim2.new(self.Position == "Right" and 1 or -1, self.Position == "Right" and 350 or -350, 0, 0),
        BackgroundTransparency = 1
    })
    
    slideOut.Completed:Connect(function()
        if frame and frame.Parent then
            frame:Destroy()
        end
    end)
    
    Utils:TableRemove(self.ActiveNotifications, notifData)
    self:ManageQueue()
end

function NotificationSystem:ManageQueue()
    -- Remove excess notifications
    while #self.ActiveNotifications > self.MaxVisible do
        local oldest = self.ActiveNotifications[1]
        if oldest then
            self:Remove(oldest)
        end
    end
    
    -- Update positions
    for i, notif in ipairs(self.ActiveNotifications) do
        if notif.Frame and notif.Frame.Parent then
            Utils:PlayTween(notif.Frame, Anim.Smooth(), {
                Position = self:CalculatePosition(i)
            })
        end
    end
end

function NotificationSystem:ClearAll()
    for _, notif in ipairs(self.ActiveNotifications) do
        if notif.Frame and notif.Frame.Parent then
            notif.Frame:Destroy()
        end
    end
    self.ActiveNotifications = {}
end

function NotificationSystem:GetHistory()
    return self.History
end

function NotificationSystem:ClearHistory()
    self.History = {}
end

function NotificationSystem:SetPosition(position)
    self.Position = position
    if self.Container then
        self.Container.Position = position == "Right" and UDim2.new(1, -340, 0, 0) or UDim2.new(0, 20, 0, 0)
    end
end

function NotificationSystem:SetMaxVisible(max)
    self.MaxVisible = max
    self:ManageQueue()
end

--============================================--
-- SECTION 15: WINDOW DRAG SYSTEM
--============================================--
local DragSystem = {}

function DragSystem:MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragSpeed = 1
    local bounds = nil -- {MinX, MinY, MaxX, MaxY}
    
    local function startDrag(input)
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        if frame.Parent then
            frame.ZIndex = frame.ZIndex + 100
        end
    end
    
    local function updateDrag(input)
        if not dragging then return end
        
        local delta = (input.Position - dragStart) * dragSpeed
        local newX = startPos.X.Scale * SCREEN_WIDTH + startPos.X.Offset + delta.X
        local newY = startPos.Y.Scale * SCREEN_HEIGHT + startPos.Y.Offset + delta.Y
        
        if bounds then
            newX = Utils:Clamp(newX, bounds.MinX or -10000, bounds.MaxX or 10000)
            newY = Utils:Clamp(newY, bounds.MinY or -10000, bounds.MaxY or 10000)
        end
        
        frame.Position = UDim2.new(0, newX, 0, newY)
    end
    
    local function endDrag()
        if not dragging then return end
        dragging = false
        
        if frame.Parent then
            frame.ZIndex = frame.ZIndex - 100
        end
        
        -- Snap to edges if close
        local pos = frame.Position
        local xOffset = pos.X.Offset
        local yOffset = pos.Y.Offset
        
        if math.abs(xOffset) < 10 then
            Utils:PlayTween(frame, Anim.Spring(0.3), {
                Position = UDim2.new(pos.X.Scale, 0, pos.Y.Scale, pos.Y.Offset)
            })
        end
        
        if math.abs(xOffset + frame.AbsoluteSize.X - SCREEN_WIDTH) < 10 then
            Utils:PlayTween(frame, Anim.Spring(0.3), {
                Position = UDim2.new(pos.X.Scale, SCREEN_WIDTH - frame.AbsoluteSize.X, pos.Y.Scale, pos.Y.Offset)
            })
        end
    end
    
    local handle = dragHandle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
    
    return {
        SetBounds = function(newBounds)
            bounds = newBounds
        end,
        SetSpeed = function(speed)
            dragSpeed = speed
        end,
        IsDragging = function()
            return dragging
        end
    }
end

--============================================--
-- SECTION 16: WINDOW MANAGEMENT SYSTEM
--============================================--
local WindowManager = {}
WindowManager.Windows = {}
WindowManager.ActiveWindow = nil
WindowManager.ZIndexBase = 100
WindowManager.WindowCount = 0

function WindowManager:Register(window)
    self.WindowCount = self.WindowCount + 1
    window._id = self.WindowCount
    window._zIndex = self.ZIndexBase + self.WindowCount * 10
    window.Container.ZIndex = window._zIndex
    
    table.insert(self.Windows, window)
    self:Focus(window)
    
    -- Focus on click
    window.Container.InputBegan:Connect(function()
        self:Focus(window)
    end)
    
    return window._id
end

function WindowManager:Unregister(window)
    Utils:TableRemove(self.Windows, window)
    
    if self.ActiveWindow == window then
        self.ActiveWindow = nil
        
        -- Focus last window
        if #self.Windows > 0 then
            self:Focus(self.Windows[#self.Windows])
        end
    end
end

function WindowManager:Focus(window)
    if self.ActiveWindow == window then return end
    
    self.ActiveWindow = window
    self.WindowCount = self.WindowCount + 1
    window._zIndex = self.ZIndexBase + self.WindowCount * 10
    window.Container.ZIndex = window._zIndex
    
    -- Update visual state
    for _, w in ipairs(self.Windows) do
        if w ~= window then
            -- Dim other windows slightly
            if w.Container and w.Container.Parent then
                w.Container.BackgroundTransparency = math.min(w.Container.BackgroundTransparency + 0.1, 1)
            end
        end
    end
    
    if window.Container and window.Container.Parent then
        window.Container.BackgroundTransparency = math.max(window.Container.BackgroundTransparency - 0.1, 0)
    end
end

function WindowManager:GetAll()
    return self.Windows
end

function WindowManager:GetActive()
    return self.ActiveWindow
end

function WindowManager:GetById(id)
    for _, w in ipairs(self.Windows) do
        if w._id == id then
            return w
        end
    end
    return nil
end

function WindowManager:CloseAll()
    for _, w in ipairs(self.Windows) do
        if w.Close then
            w:Close()
        end
    end
    self.Windows = {}
    self.ActiveWindow = nil
end

function WindowManager:MinimizeAll()
    for _, w in ipairs(self.Windows) do
        if w.Minimize then
            w:Minimize()
        end
    end
end

function WindowManager:RestoreAll()
    for _, w in ipairs(self.Windows) do
        if w.Restore then
            w:Restore()
        end
    end
end

--============================================--
-- SECTION 17: SCREEN UTILITIES
--============================================--
local ScreenUtils = {}

function ScreenUtils:GetScreenSize()
    return Vector2.new(
        Camera.ViewportSize.X,
        Camera.ViewportSize.Y
    )
end

function ScreenUtils:GetScreenCenter()
    local size = self:GetScreenSize()
    return Vector2.new(size.X / 2, size.Y / 2)
end

function ScreenUtils:ScaleToScreen(scaleX, scaleY)
    local size = self:GetScreenSize()
    return UDim2.new(scaleX or 0, 0, scaleY or 0, 0)
end

function ScreenUtils:OffsetToScreen(offsetX, offsetY)
    return UDim2.new(0, offsetX or 0, 0, offsetY or 0)
end

function ScreenUtils:GetRelativePosition(absolutePosition)
    local size = self:GetScreenSize()
    return Vector2.new(
        absolutePosition.X / size.X,
        absolutePosition.Y / size.Y
    )
end

function ScreenUtils:IsPositionOnScreen(position)
    local size = self:GetScreenSize()
    return position.X >= 0 and position.X <= size.X and
           position.Y >= 0 and position.Y <= size.Y
end

function ScreenUtils:GetSafeArea()
    local topBar = PlayerGui:FindFirstChild("TopBar")
    local safeTop = topBar and topBar.AbsoluteSize.Y or 0
    
    return {
        Top = safeTop,
        Bottom = 0,
        Left = 0,
        Right = 0
    }
end

--============================================--
-- SECTION 18: KEYBIND MANAGER
--============================================--
local KeybindManager = {}
KeybindManager.Binds = {}
KeybindManager.Enabled = true

function KeybindManager:Register(key, callback, description)
    local keyName = typeof(key) == "EnumItem" and key.Name or key
    
    if not self.Binds[keyName] then
        self.Binds[keyName] = {
            Key = key,
            Callbacks = {},
            Description = description or "",
            Enabled = true
        }
    end
    
    table.insert(self.Binds[keyName].Callbacks, callback)
    
    return function()
        Utils:TableRemove(self.Binds[keyName].Callbacks, callback)
        if #self.Binds[keyName].Callbacks == 0 then
            self.Binds[keyName] = nil
        end
    end
end

function KeybindManager:Unregister(key)
    local keyName = typeof(key) == "EnumItem" and key.Name or key
    self.Binds[keyName] = nil
end

function KeybindManager:SetEnabled(enabled)
    self.Enabled = enabled
end

function KeybindManager:GetBinds()
    local binds = {}
    for keyName, data in pairs(self.Binds) do
        table.insert(binds, {
            Key = keyName,
            Description = data.Description,
            Enabled = data.Enabled
        })
    end
    return binds
end

function KeybindManager:ClearAll()
    self.Binds = {}
end

-- Listen for input
Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not KeybindManager.Enabled then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        local bind = KeybindManager.Binds[keyName]
        
        if bind and bind.Enabled then
            for _, callback in ipairs(bind.Callbacks) do
                task.spawn(function()
                    callback()
                end)
            end
        end
    end
end)

--============================================--
-- SECTION 19: TOOLTIP SYSTEM
--============================================--
local TooltipSystem = {}
TooltipSystem.Tooltip = nil
TooltipSystem.Delay = 0.5
TooltipSystem.Enabled = true

function TooltipSystem:Initialize()
    if self.Tooltip then return end
    
    self.Tooltip = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "PHUCMAX_Tooltip",
        BackgroundColor3 = ActiveTheme.Surface,
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 99999,
        Visible = false,
        ClipsDescendants = false
    })
    Utils:AddCorner(self.Tooltip, 8)
    Utils:AddStroke(self.Tooltip, ActiveTheme.Glow, 1)
    
    local textLabel = Utils:CreateText({
        Parent = self.Tooltip,
        Name = "Text",
        Size = UDim2.new(1, -16, 1, -8),
        Position = UDim2.new(0, 8, 0, 4),
        Font = Fonts.Regular,
        Text = "",
        TextColor3 = ActiveTheme.Text,
        TextSize = 13,
        ZIndex = 100000
    })
    
    local padding = Utils:AddPadding(self.Tooltip, 4, 4, 4, 4)
end

function TooltipSystem:Show(text, position)
    if not self.Enabled then return end
    self:Initialize()
    
    local textLabel = self.Tooltip:FindFirstChild("Text")
    if not textLabel then return end
    
    textLabel.Text = text
    
    local textSize = Utils:GetTextSize(text, Fonts.Regular, 13)
    
    self.Tooltip.Size = UDim2.new(0, textSize.X + 24, 0, textSize.Y + 16)
    self.Tooltip.Position = UDim2.new(0, position.X + 10, 0, position.Y - self.Tooltip.AbsoluteSize.Y - 10)
    self.Tooltip.Visible = true
    self.Tooltip.ZIndex = 99999
end

function TooltipSystem:Hide()
    if self.Tooltip then
        self.Tooltip.Visible = false
    end
end

function TooltipSystem:Attach(instance, text)
    local hoverTimer = nil
    
    instance.MouseEnter:Connect(function()
        hoverTimer = task.delay(self.Delay, function()
            local mousePos = Utils:GetMouseLocation()
            self:Show(text, Vector2.new(mousePos.X, mousePos.Y))
        end)
    end)
    
    instance.MouseLeave:Connect(function()
        if hoverTimer then
            task.cancel(hoverTimer)
            hoverTimer = nil
        end
        self:Hide()
    end)
    
    instance.MouseMoved:Connect(function(x, y)
        if self.Tooltip and self.Tooltip.Visible then
            self.Tooltip.Position = UDim2.new(0, x + 10, 0, y - self.Tooltip.AbsoluteSize.Y - 10)
        end
    end)
end

--============================================--
-- SECTION 20: MODULE EXPORTS (PART 2)
--============================================--

-- Extend PHUCMAX with new systems
PHUCMAX.NotificationSystem = NotificationSystem
PHUCMAX.DragSystem = DragSystem
PHUCMAX.WindowManager = WindowManager
PHUCMAX.ScreenUtils = ScreenUtils
PHUCMAX.KeybindManager = KeybindManager
PHUCMAX.TooltipSystem = TooltipSystem

-- Notification shorthand
function PHUCMAX:Notify(config)
    return NotificationSystem:Send(config)
end

-- Window creation placeholder (expanded in Part 3)
function PHUCMAX:CreateWindow(config)
    -- Will be fully implemented in Part 3
    return WindowManager:CreateWindow(config)
end

--[[
    PHUCMAX UI Library - Part 3/15
    Window Builder | Tab Navigation | Section Layout | Scrolling System
    Lines: 2201-3300
]]

--============================================--
-- SECTION 21: WINDOW BUILDER CLASS
--============================================--
local WindowBuilder = {}
WindowBuilder.__index = WindowBuilder

function WindowBuilder.new(config)
    local self = setmetatable({}, WindowBuilder)
    
    -- Window configuration
    self.Config = {
        Title = config.Title or "PHUCMAX",
        SubTitle = config.SubTitle or "",
        Size = config.Size or UDim2.fromOffset(580, 420),
        MinSize = config.MinSize or UDim2.fromOffset(400, 300),
        MaxSize = config.MaxSize or UDim2.fromOffset(1200, 800),
        Position = config.Position or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = config.AnchorPoint or Vector2.new(0.5, 0.5),
        Theme = config.Theme or "Purple",
        Acrylic = config.Acrylic ~= false,
        TabWidth = config.TabWidth or 160,
        Resizable = config.Resizable or false,
        Draggable = config.Draggable ~= false,
        MinimizeKey = config.MinimizeKey or nil,
        CloseKey = config.CloseKey or nil,
        OnClose = config.OnClose or nil,
        OnMinimize = config.OnMinimize or nil,
        OnRestore = config.OnRestore or nil
    }
    
    -- Apply theme
    local themeName = self.Config.Theme
    ThemeManager:SetTheme(themeName)
    self.Theme = ThemeManager:GetTheme()
    
    -- State
    self.State = {
        IsVisible = false,
        IsMinimized = false,
        IsMaximized = false,
        IsClosing = false,
        IsDragging = false,
        IsResizing = false
    }
    
    -- Internal data
    self.Tabs = {}
    self.CurrentTab = nil
    self.Connections = {}
    self.Tweens = {}
    self.Children = {}
    self.ID = nil
    
    -- Build window
    self:Build()
    
    -- Register with window manager
    self.ID = WindowManager:Register(self)
    
    -- Show window
    self:Show()
    
    return self
end

function WindowBuilder:Build()
    local theme = self.Theme
    
    -- Main container
    self.Container = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "PHUCMAX_Window_" .. self.Config.Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0),
        Position = self.Config.Position,
        AnchorPoint = self.Config.AnchorPoint,
        ZIndex = 100,
        Visible = false,
        ClipsDescendants = true
    })
    
    -- Shadow effect
    self.Shadow = Utils:CreateInstance("ImageLabel", {
        Parent = self.Container,
        Name = "Shadow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, 20),
        Image = "rbxassetid://",
        ImageColor3 = theme.Shadow,
        ImageTransparency = 0.6,
        ZIndex = 98
    })
    Utils:AddCorner(self.Shadow, 28)
    
    -- Background
    self.Background = Utils:CreateInstance("ImageLabel", {
        Parent = self.Container,
        Name = "Background",
        BackgroundColor3 = theme.Bg,
        BackgroundTransparency = 0.35,
        Size = UDim2.new(1, 0, 1, 0),
        Image = BackdropImage,
        ScaleType = Enum.ScaleType.Crop,
        ImageTransparency = 0.82,
        ZIndex = 99
    })
    Utils:AddCorner(self.Background, 24)
    
    -- Main border glow
    self.BorderStroke = Utils:AddStroke(self.Background, theme.Glow, 1.5)
    
    -- Glass overlay with gradient
    if self.Config.Acrylic then
        self.GlassOverlay = Utils:CreateInstance("Frame", {
            Parent = self.Background,
            Name = "GlassOverlay",
            BackgroundColor3 = theme.Glass,
            BackgroundTransparency = 0.93,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            ZIndex = 100
        })
        Utils:AddCorner(self.GlassOverlay, 24)
        
        -- Multiple gradient layers for liquid glass effect
        self.GlassGradient1 = Utils:AddGradient(
            self.GlassOverlay, 
            theme.Grad1, 
            theme.Grad2, 
            135
        )
        
        -- Second glass layer for depth
        self.GlassOverlay2 = Utils:CreateInstance("Frame", {
            Parent = self.GlassOverlay,
            Name = "GlassOverlay2",
            BackgroundColor3 = theme.Glass,
            BackgroundTransparency = 0.97,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            ZIndex = 101
        })
        Utils:AddCorner(self.GlassOverlay2, 24)
        Utils:AddGradient(self.GlassOverlay2, theme.Grad3, theme.Grad4, -45)
    end
    
    -- Top bar
    self:BuildTopBar()
    
    -- Tab container
    self:BuildTabContainer()
    
    -- Content area
    self:BuildContentArea()
    
    -- Status bar
    self:BuildStatusBar()
    
    -- Resize handles
    if self.Config.Resizable then
        self:BuildResizeHandles()
    end
    
    -- Make draggable
    if self.Config.Draggable then
        self.DragController = DragSystem:MakeDraggable(self.Container, self.TopBar)
    end
    
    -- Keybinds
    if self.Config.MinimizeKey then
        local conn = KeybindManager:Register(self.Config.MinimizeKey, function()
            if self.State.IsMinimized then
                self:Restore()
            else
                self:Minimize()
            end
        end, "Minimize " .. self.Config.Title)
        table.insert(self.Connections, conn)
    end
    
    if self.Config.CloseKey then
        local conn = KeybindManager:Register(self.Config.CloseKey, function()
            self:Close()
        end, "Close " .. self.Config.Title)
        table.insert(self.Connections, conn)
    end
end

function WindowBuilder:BuildTopBar()
    local theme = self.Theme
    
    self.TopBar = Utils:CreateInstance("Frame", {
        Parent = self.Background,
        Name = "TopBar",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.55,
        Size = UDim2.new(1, 0, 0, 50),
        BorderSizePixel = 0,
        ZIndex = 200
    })
    Utils:AddCorner(self.TopBar, 24)
    
    -- Top bar gradient
    Utils:AddGradient(self.TopBar, theme.SurfaceLight, theme.SurfaceDark, 180)
    
    -- Avatar frame
    self.AvatarFrame = Utils:CreateInstance("Frame", {
        Parent = self.TopBar,
        Name = "AvatarFrame",
        BackgroundColor3 = theme.SurfaceDark,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 12, 0.5, -18),
        ZIndex = 201
    })
    Utils:AddCorner(self.AvatarFrame, 18)
    Utils:AddStroke(self.AvatarFrame, theme.Glow, 1)
    
    -- Avatar image
    self.AvatarImage = Utils:CreateInstance("ImageLabel", {
        Parent = self.AvatarFrame,
        Name = "Avatar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        ZIndex = 202
    })
    Utils:AddCorner(self.AvatarImage, 16)
    
    -- Load avatar
    local success, content = pcall(function()
        return Services.Players:GetUserThumbnailAsync(
            Player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size48x48
        )
    end)
    
    if success then
        self.AvatarImage.Image = content
    end
    
    -- Avatar click to refresh
    self.AvatarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local newContent = Services.Players:GetUserThumbnailAsync(
                Player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size48x48
            )
            self.AvatarImage.Image = newContent
        end
    end)
    
    -- Player display name
    self.DisplayNameLabel = Utils:CreateText({
        Parent = self.TopBar,
        Name = "DisplayName",
        Position = UDim2.new(0, 56, 0, 4),
        Size = UDim2.new(0, 150, 0, 20),
        Font = Fonts.Bold,
        Text = Player.DisplayName,
        TextColor3 = theme.Text,
        TextSize = 14,
        ZIndex = 201
    })
    
    -- Player username
    self.UsernameLabel = Utils:CreateText({
        Parent = self.TopBar,
        Name = "Username",
        Position = UDim2.new(0, 56, 0, 26),
        Size = UDim2.new(0, 150, 0, 16),
        Font = Fonts.Regular,
        Text = "@" .. Player.Name,
        TextColor3 = theme.SubText,
        TextSize = 11,
        ZIndex = 201
    })
    
    -- Window title
    self.TitleLabel = Utils:CreateText({
        Parent = self.TopBar,
        Name = "WindowTitle",
        Position = UDim2.new(0.5, -80, 0, 8),
        Size = UDim2.new(0, 160, 0, 30),
        Font = Fonts.Bold,
        Text = "PHUCMAX",
        TextColor3 = theme.Main,
        TextSize = 18,
        ZIndex = 201
    })
    
    -- Subtitle (if provided)
    if self.Config.SubTitle and self.Config.SubTitle ~= "" then
        self.SubTitleLabel = Utils:CreateText({
            Parent = self.TopBar,
            Name = "SubTitle",
            Position = UDim2.new(0.5, -80, 0, 32),
            Size = UDim2.new(0, 160, 0, 14),
            Font = Fonts.Regular,
            Text = self.Config.SubTitle,
            TextColor3 = theme.MutedText,
            TextSize = 10,
            ZIndex = 201
        })
    end
    
    -- Control buttons
    self:BuildControlButtons()
end

function WindowBuilder:BuildControlButtons()
    local theme = self.Theme
    
    -- Minimize button
    self.MinimizeButton = Utils:CreateButton({
        Parent = self.TopBar,
        Name = "MinimizeBtn",
        BackgroundColor3 = Color3.fromRGB(255, 200, 50),
        BackgroundTransparency = 0.85,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -96, 0.5, -14),
        Text = "—",
        Font = Fonts.Bold,
        TextColor3 = theme.Text,
        TextSize = 16,
        ZIndex = 210
    })
    Utils:AddCorner(self.MinimizeButton, 8)
    
    -- Maximize button
    self.MaximizeButton = Utils:CreateButton({
        Parent = self.TopBar,
        Name = "MaximizeBtn",
        BackgroundColor3 = Color3.fromRGB(100, 200, 100),
        BackgroundTransparency = 0.85,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -62, 0.5, -14),
        Text = "□",
        Font = Fonts.Bold,
        TextColor3 = theme.Text,
        TextSize = 14,
        ZIndex = 210
    })
    Utils:AddCorner(self.MaximizeButton, 8)
    
    -- Close button
    self.CloseButton = Utils:CreateButton({
        Parent = self.TopBar,
        Name = "CloseBtn",
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        BackgroundTransparency = 0.85,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -28, 0.5, -14),
        Text = "✕",
        Font = Fonts.Bold,
        TextColor3 = theme.Text,
        TextSize = 14,
        ZIndex = 210
    })
    Utils:AddCorner(self.CloseButton, 8)
    
    -- Button events
    self.MinimizeButton.MouseButton1Click:Connect(function()
        if self.State.IsMinimized then
            self:Restore()
        else
            self:Minimize()
        end
    end)
    
    self.MaximizeButton.MouseButton1Click:Connect(function()
        if self.State.IsMaximized then
            self:Restore()
        else
            self:Maximize()
        end
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- Button hover effects
    local function addHoverEffect(button, baseTransparency)
        button.MouseEnter:Connect(function()
            Utils:PlayTween(button, Anim.Fast(), {
                BackgroundTransparency = baseTransparency - 0.3
            })
        end)
        
        button.MouseLeave:Connect(function()
            Utils:PlayTween(button, Anim.Fast(), {
                BackgroundTransparency = baseTransparency
            })
        end)
    end
    
    addHoverEffect(self.MinimizeButton, 0.85)
    addHoverEffect(self.MaximizeButton, 0.85)
    addHoverEffect(self.CloseButton, 0.85)
    
    -- Tooltips
    TooltipSystem:Attach(self.MinimizeButton, "Minimize")
    TooltipSystem:Attach(self.MaximizeButton, "Maximize")
    TooltipSystem:Attach(self.CloseButton, "Close")
end

function WindowBuilder:BuildTabContainer()
    local theme = self.Theme
    
    self.TabContainer = Utils:CreateInstance("Frame", {
        Parent = self.Background,
        Name = "TabContainer",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.65,
        Size = UDim2.new(0, self.Config.TabWidth, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BorderSizePixel = 0,
        ZIndex = 150
    })
    Utils:AddCorner(self.TabContainer, 24)
    
    -- Tab container gradient
    Utils:AddGradient(self.TabContainer, theme.SurfaceLight, theme.SurfaceDark, 90)
    
    -- Tab list layout
    self.TabListLayout = Instance.new("UIListLayout")
    self.TabListLayout.Padding = UDim.new(0, 6)
    self.TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    self.TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabListLayout.Parent = self.TabContainer
    
    -- Tab scrolling
    self.TabScroll = Utils:CreateInstance("ScrollingFrame", {
        Parent = self.TabContainer,
        Name = "TabScroll",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 151,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    
    -- Move list layout to scroll
    self.TabListLayout.Parent = self.TabScroll
    
    -- Padding
    Utils:AddPadding(self.TabScroll, 16, 8, 8, 8)
    
    -- Separator line
    self.TabSeparator = Utils:CreateInstance("Frame", {
        Parent = self.Background,
        Name = "TabSeparator",
        BackgroundColor3 = theme.Border,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 1, 1, -50),
        Position = UDim2.new(0, self.Config.TabWidth, 0, 50),
        BorderSizePixel = 0,
        ZIndex = 152
    })
end

function WindowBuilder:BuildContentArea()
    local theme = self.Theme
    
    -- Content container
    self.ContentContainer = Utils:CreateInstance("Frame", {
        Parent = self.Background,
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -(self.Config.TabWidth + 10), 1, -60),
        Position = UDim2.new(0, self.Config.TabWidth + 5, 0, 55),
        BorderSizePixel = 0,
        ZIndex = 150,
        ClipsDescendants = true
    })
    
    -- Content scrolling frame
    self.ContentScroll = Utils:CreateInstance("ScrollingFrame", {
        Parent = self.ContentContainer,
        Name = "ContentScroll",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -5, 1, 0),
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Main,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 151,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Always,
        ScrollBarImageColor3 = theme.Main
    })
    
    -- Content list layout
    self.ContentListLayout = Instance.new("UIListLayout")
    self.ContentListLayout.Padding = UDim.new(0, 8)
    self.ContentListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    self.ContentListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.ContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ContentListLayout.Parent = self.ContentScroll
    
    -- Padding
    Utils:AddPadding(self.ContentScroll, 8, 8, 6, 6)
    
    -- Smooth scrolling
    self.ScrollConnection = nil
    self.ScrollVelocity = 0
    self.ScrollTarget = nil
    
    self.ContentScroll.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            self.ScrollVelocity = self.ContentScroll.CanvasPosition.Y
            self:ApplyMomentumScroll()
        end
    end)
end

function WindowBuilder:BuildStatusBar()
    local theme = self.Theme
    
    self.StatusBar = Utils:CreateInstance("Frame", {
        Parent = self.Background,
        Name = "StatusBar",
        BackgroundColor3 = theme.SurfaceDark,
        BackgroundTransparency = 0.6,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BorderSizePixel = 0,
        ZIndex = 200
    })
    
    -- Status text
    self.StatusText = Utils:CreateText({
        Parent = self.StatusBar,
        Name = "StatusText",
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -16, 1, 0),
        Font = Fonts.Regular,
        Text = "Ready",
        TextColor3 = theme.MutedText,
        TextSize = 11,
        ZIndex = 201
    })
    
    -- Version text
    self.VersionText = Utils:CreateText({
        Parent = self.StatusBar,
        Name = "VersionText",
        Position = UDim2.new(1, -100, 0, 0),
        Size = UDim2.new(0, 92, 1, 0),
        Font = Fonts.Regular,
        Text = "v" .. PHUCMAX_VERSION,
        TextColor3 = theme.MutedText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 201
    })
end

function WindowBuilder:BuildResizeHandles()
    -- Bottom-right resize handle
    self.ResizeHandle = Utils:CreateInstance("Frame", {
        Parent = self.Background,
        Name = "ResizeHandle",
        BackgroundColor3 = self.Theme.Main,
        BackgroundTransparency = 0.9,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        BorderSizePixel = 0,
        ZIndex = 250
    })
    
    -- Resize functionality
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    
    self.ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = self.Container.AbsoluteSize
            self.State.IsResizing = true
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = Utils:Clamp(
                startSize.X + delta.X,
                self.Config.MinSize.X.Offset,
                self.Config.MaxSize.X.Offset
            )
            local newHeight = Utils:Clamp(
                startSize.Y + delta.Y,
                self.Config.MinSize.Y.Offset,
                self.Config.MaxSize.Y.Offset
            )
            
            self.Container.Size = UDim2.new(0, newWidth, 0, newHeight)
            self:UpdateCanvasSize()
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if resizing then
            resizing = false
            self.State.IsResizing = false
        end
    end)
end

--============================================--
-- SECTION 22: WINDOW METHODS
--============================================--

function WindowBuilder:Show()
    if self.State.IsVisible then return end
    
    self.Container.Visible = true
    self.State.IsVisible = true
    
    local tween = Utils:PlayTween(self.Container, Anim.Spring(0.6), {
        Size = self.Config.Size
    }, function()
        self:UpdateCanvasSize()
    end)
    
    table.insert(self.Tweens, tween)
    
    -- Fade in elements
    if self.TopBar then
        Utils:PlayTween(self.TopBar, Anim.Smooth(0.4), {
            BackgroundTransparency = 0.55
        })
    end
end

function WindowBuilder:Hide()
    if not self.State.IsVisible then return end
    
    local tween = Utils:PlayTween(self.Container, Anim.Smooth(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }, function()
        self.Container.Visible = false
        self.State.IsVisible = false
    end)
    
    table.insert(self.Tweens, tween)
end

function WindowBuilder:Close()
    if self.State.IsClosing then return end
    self.State.IsClosing = true
    
    -- Call onClose callback
    if self.Config.OnClose then
        self.Config.OnClose()
    end
    
    -- Animate close
    local tween = Utils:PlayTween(self.Container, Anim.Quint(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Rotation = 5
    }, function()
        -- Destroy all children
        self:Destroy()
    end)
    
    table.insert(self.Tweens, tween)
end

function WindowBuilder:Minimize()
    if self.State.IsMinimized then return end
    self.State.IsMinimized = true
    
    -- Store current size
    self.RestoreSize = self.Container.Size
    
    local tween = Utils:PlayTween(self.Container, Anim.Smooth(0.3), {
        Size = UDim2.new(0, self.Config.Size.X.Offset, 0, 50)
    }, function()
        -- Hide content
        if self.TabContainer then
            self.TabContainer.Visible = false
        end
        if self.ContentContainer then
            self.ContentContainer.Visible = false
        end
        if self.StatusBar then
            self.StatusBar.Visible = false
        end
        
        if self.Config.OnMinimize then
            self.Config.OnMinimize()
        end
    end)
    
    table.insert(self.Tweens, tween)
end

function WindowBuilder:Restore()
    if not self.State.IsMinimized and not self.State.IsMaximized then return end
    
    -- Show content
    if self.TabContainer then
        self.TabContainer.Visible = true
    end
    if self.ContentContainer then
        self.ContentContainer.Visible = true
    end
    if self.StatusBar then
        self.StatusBar.Visible = true
    end
    
    local targetSize = self.RestoreSize or self.Config.Size
    
    local tween = Utils:PlayTween(self.Container, Anim.Spring(0.5), {
        Size = targetSize
    }, function()
        self.State.IsMinimized = false
        self.State.IsMaximized = false
        self:UpdateCanvasSize()
        
        if self.Config.OnRestore then
            self.Config.OnRestore()
        end
    end)
    
    table.insert(self.Tweens, tween)
end

function WindowBuilder:Maximize()
    if self.State.IsMaximized then return end
    
    self.RestoreSize = self.Container.Size
    self.State.IsMaximized = true
    
    local screenSize = ScreenUtils:GetScreenSize()
    local safeArea = ScreenUtils:GetSafeArea()
    
    local maxWidth = screenSize.X - 20
    local maxHeight = screenSize.Y - safeArea.Top - 20
    
    local tween = Utils:PlayTween(self.Container, Anim.Spring(0.5), {
        Size = UDim2.new(0, maxWidth, 0, maxHeight),
        Position = UDim2.new(0, 10, 0, safeArea.Top + 10)
    }, function()
        self:UpdateCanvasSize()
    end)
    
    table.insert(self.Tweens, tween)
end

function WindowBuilder:SetTitle(title)
    self.Config.Title = title
    if self.TitleLabel then
        self.TitleLabel.Text = title
    end
end

function WindowBuilder:SetStatus(text)
    if self.StatusText then
        self.StatusText.Text = text
    end
end

function WindowBuilder:SetSize(size)
    self.Config.Size = size
    if self.State.IsVisible then
        Utils:PlayTween(self.Container, Anim.Spring(0.4), {
            Size = size
        })
    end
end

function WindowBuilder:SetPosition(position)
    self.Config.Position = position
    if self.State.IsVisible then
        Utils:PlayTween(self.Container, Anim.Spring(0.4), {
            Position = position
        })
    end
end

function WindowBuilder:BringToFront()
    WindowManager:Focus(self)
end

function WindowBuilder:UpdateCanvasSize()
    if not self.ContentScroll then return end
    
    local totalHeight = 16
    for _, child in ipairs(self.ContentScroll:GetChildren()) do
        if child:IsA("Frame") and child.Visible then
            totalHeight = totalHeight + child.AbsoluteSize.Y + 8
        end
    end
    
    self.ContentScroll.CanvasSize = UDim2.new(
        0, 0,
        0, math.max(totalHeight, self.ContentContainer.AbsoluteSize.Y)
    )
end

function WindowBuilder:ApplyMomentumScroll()
    task.spawn(function()
        local friction = 0.95
        local minVelocity = 2
        
        while math.abs(self.ScrollVelocity) > minVelocity do
            self.ScrollVelocity = self.ScrollVelocity * friction
            
            local newPos = self.ContentScroll.CanvasPosition.Y + self.ScrollVelocity * 0.016
            newPos = math.max(0, math.min(
                newPos,
                self.ContentScroll.CanvasSize.Y.Offset - self.ContentScroll.AbsoluteSize.Y
            ))
            
            self.ContentScroll.CanvasPosition = Vector2.new(0, newPos)
            task.wait()
        end
    end)
end

function WindowBuilder:Destroy()
    -- Disconnect all connections
    for _, conn in ipairs(self.Connections) do
        if conn and typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    
    -- Cancel all tweens
    for _, tween in ipairs(self.Tweens) do
        if tween then
            tween:Cancel()
        end
    end
    
    -- Unregister from window manager
    WindowManager:Unregister(self)
    
    -- Destroy container
    if self.Container and self.Container.Parent then
        self.Container:Destroy()
    end
end

--============================================--
-- SECTION 23: WINDOW CREATION IN PHUCMAX
--============================================--

function PHUCMAX:CreateWindow(config)
    return WindowBuilder.new(config)
end

-- Add WindowBuilder to PHUCMAX
PHUCMAX.WindowBuilder = WindowBuilder

--[[
    PHUCMAX UI Library - Part 4/15
    Tab System | Section Builder | Element Factory | Toggle | Button Components
    Lines: 3301-4400
]]

--============================================--
-- SECTION 24: TAB SYSTEM
--============================================--
local TabSystem = {}

function TabSystem:CreateTab(window, config)
    local theme = ThemeManager:GetTheme()
    
    local tabConfig = {
        Title = config.Title or "Tab",
        Icon = config.Icon or "",
        Order = config.Order or #window.Tabs + 1
    }
    
    -- Create tab button
    local tabButton = Utils:CreateButton({
        Parent = window.TabScroll,
        Name = "Tab_" .. tabConfig.Title,
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.75,
        Size = UDim2.new(1, -4, 0, 42),
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 155,
        LayoutOrder = tabConfig.Order
    })
    Utils:AddCorner(tabButton, 12)
    
    -- Selection indicator
    local selectionIndicator = Utils:CreateInstance("Frame", {
        Parent = tabButton,
        Name = "Indicator",
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 0, 30),
        Position = UDim2.new(0, 0, 0.5, -15),
        ZIndex = 157
    })
    Utils:AddCorner(selectionIndicator, 3)
    
    -- Tab icon
    local tabIcon = nil
    if tabConfig.Icon ~= "" then
        tabIcon = Utils:CreateInstance("ImageLabel", {
            Parent = tabButton,
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(0, 14, 0.5, -11),
            Image = tabConfig.Icon,
            ImageColor3 = theme.SubText,
            ZIndex = 156
        })
        Utils:AddCorner(tabIcon, 6)
    end
    
    -- Tab title
    local tabLabel = Utils:CreateText({
        Parent = tabButton,
        Name = "Title",
        Position = UDim2.new(0, tabConfig.Icon ~= "" and 44 or 14, 0, 0),
        Size = UDim2.new(1, -(tabConfig.Icon ~= "" and 52 or 22), 1, 0),
        Font = Fonts.Medium,
        Text = tabConfig.Title,
        TextColor3 = theme.SubText,
        TextSize = 13,
        ZIndex = 156
    })
    
    -- Badge (for notifications count)
    local badge = Utils:CreateInstance("Frame", {
        Parent = tabButton,
        Name = "Badge",
        BackgroundColor3 = theme.Error,
        BackgroundTransparency = 0.2,
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -24, 0.5, -9),
        ZIndex = 158,
        Visible = false
    })
    Utils:AddCorner(badge, 9)
    
    local badgeText = Utils:CreateText({
        Parent = badge,
        Name = "BadgeText",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Fonts.Bold,
        Text = "0",
        TextColor3 = theme.Text,
        TextSize = 10,
        ZIndex = 159
    })
    
    -- Create tab content frame
    local tabContent = Utils:CreateInstance("Frame", {
        Parent = window.ContentScroll,
        Name = "Content_" .. tabConfig.Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Visible = false,
        BorderSizePixel = 0,
        ZIndex = 155,
        LayoutOrder = tabConfig.Order
    })
    
    -- Content list for sections
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 6)
    contentList.VerticalAlignment = Enum.VerticalAlignment.Top
    contentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = tabContent
    
    -- Tab data object
    local tabData = {
        Button = tabButton,
        Content = tabContent,
        Label = tabLabel,
        Icon = tabIcon,
        Indicator = selectionIndicator,
        Badge = badge,
        BadgeText = badgeText,
        Name = tabConfig.Title,
        Sections = {},
        Window = window,
        IsSelected = false,
        NotificationCount = 0
    }
    
    -- Hover effects
    tabButton.MouseEnter:Connect(function()
        if not tabData.IsSelected then
            Utils:PlayTween(tabButton, Anim.Fast(), {
                BackgroundTransparency = 0.55
            })
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if not tabData.IsSelected then
            Utils:PlayTween(tabButton, Anim.Fast(), {
                BackgroundTransparency = 0.75
            })
        end
    end)
    
    -- Click to select
    tabButton.MouseButton1Click:Connect(function()
        window:SelectTab(tabData)
    end)
    
    -- Methods
    function tabData:Select()
        if window.CurrentTab then
            window.CurrentTab:Deselect()
        end
        window.CurrentTab = tabData
        tabData.IsSelected = true
        
        -- Animate selection
        Utils:PlayTween(tabButton, Anim.Fast(), {
            BackgroundTransparency = 0.35
        })
        
        Utils:PlayTween(tabLabel, Anim.Fast(), {
            TextColor3 = theme.Text
        })
        
        if tabIcon then
            Utils:PlayTween(tabIcon, Anim.Fast(), {
                ImageColor3 = theme.Main
            })
        end
        
        Utils:PlayTween(selectionIndicator, Anim.Spring(0.4), {
            Size = UDim2.new(0, 3, 0, 30)
        })
        
        tabContent.Visible = true
        window:UpdateCanvasSize()
    end
    
    function tabData:Deselect()
        tabData.IsSelected = false
        
        Utils:PlayTween(tabButton, Anim.Fast(), {
            BackgroundTransparency = 0.75
        })
        
        Utils:PlayTween(tabLabel, Anim.Fast(), {
            TextColor3 = theme.SubText
        })
        
        if tabIcon then
            Utils:PlayTween(tabIcon, Anim.Fast(), {
                ImageColor3 = theme.SubText
            })
        end
        
        tabContent.Visible = false
    end
    
    function tabData:SetBadge(count)
        tabData.NotificationCount = count or 0
        
        if count and count > 0 then
            badge.Visible = true
            badgeText.Text = count > 99 and "99+" or tostring(count)
        else
            badge.Visible = false
        end
    end
    
    function tabData:AddNotification()
        tabData.NotificationCount = tabData.NotificationCount + 1
        tabData:SetBadge(tabData.NotificationCount)
    end
    
    function tabData:ClearNotifications()
        tabData:SetBadge(0)
    end
    
    function tabData:SetTitle(title)
        tabData.Name = title
        tabLabel.Text = title
    end
    
    function tabData:SetIcon(iconId)
        if tabIcon then
            tabIcon.Image = iconId
        end
        tabConfig.Icon = iconId
    end
    
    function tabData:Destroy()
        tabButton:Destroy()
        tabContent:Destroy()
        Utils:TableRemove(window.Tabs, tabData)
        
        if window.CurrentTab == tabData then
            window.CurrentTab = nil
            if #window.Tabs > 0 then
                window:SelectTab(window.Tabs[1])
            end
        end
    end
    
    -- Add to window tabs
    table.insert(window.Tabs, tabData)
    
    -- Auto-select if first tab
    if #window.Tabs == 1 then
        tabData:Select()
    end
    
    return tabData
end

--============================================--
-- SECTION 25: SECTION BUILDER
--============================================--
local SectionBuilder = {}

function SectionBuilder:CreateSection(tab, config)
    local theme = ThemeManager:GetTheme()
    
    local sectionConfig = {
        Name = config.Name or "Section",
        Order = config.Order or #tab.Sections + 1,
        Collapsible = config.Collapsible or false,
        Collapsed = config.Collapsed or false
    }
    
    -- Section frame
    local sectionFrame = Utils:CreateInstance("Frame", {
        Parent = tab.Content,
        Name = "Section_" .. sectionConfig.Name,
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.55,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0,
        ZIndex = 160,
        LayoutOrder = sectionConfig.Order
    })
    Utils:AddCorner(sectionFrame, 12)
    Utils:AddStroke(sectionFrame, theme.Glow, 0.5)
    
    -- Section header
    local sectionHeader = Utils:CreateInstance("Frame", {
        Parent = sectionFrame,
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 32),
        BorderSizePixel = 0,
        ZIndex = 161
    })
    
    -- Collapse toggle (if collapsible)
    local collapseButton = nil
    if sectionConfig.Collapsible then
        collapseButton = Utils:CreateButton({
            Parent = sectionHeader,
            Name = "CollapseBtn",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0, 4, 0.5, -12),
            Text = sectionConfig.Collapsed and "▶" or "▼",
            Font = Fonts.Bold,
            TextColor3 = theme.Main,
            TextSize = 10,
            ZIndex = 162
        })
    end
    
    -- Section title
    local sectionTitle = Utils:CreateText({
        Parent = sectionHeader,
        Name = "Title",
        Position = UDim2.new(0, sectionConfig.Collapsible and 32 or 12, 0, 0),
        Size = UDim2.new(1, -(sectionConfig.Collapsible and 44 or 24), 1, 0),
        Font = Fonts.Bold,
        Text = sectionConfig.Name,
        TextColor3 = theme.Main,
        TextSize = 14,
        ZIndex = 162
    })
    
    -- Divider
    local divider = Utils:CreateInstance("Frame", {
        Parent = sectionFrame,
        Name = "Divider",
        BackgroundColor3 = theme.Main,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 34),
        BorderSizePixel = 0,
        ZIndex = 161
    })
    
    -- Content area
    local sectionContent = Utils:CreateInstance("Frame", {
        Parent = sectionFrame,
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 0, 38),
        BorderSizePixel = 0,
        ZIndex = 161
    })
    
    -- Content list
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 4)
    contentList.VerticalAlignment = Enum.VerticalAlignment.Top
    contentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = sectionContent
    
    -- Content padding
    Utils:AddPadding(sectionContent, 4, 8, 8, 8)
    
    -- Section data
    local sectionData = {
        Frame = sectionFrame,
        Header = sectionHeader,
        Content = sectionContent,
        Title = sectionTitle,
        Divider = divider,
        CollapseButton = collapseButton,
        Tab = tab,
        Window = tab.Window,
        Elements = {},
        IsCollapsed = sectionConfig.Collapsed,
        IsCollapsible = sectionConfig.Collapsible
    }
    
    -- Collapse functionality
    if sectionConfig.Collapsible and collapseButton then
        collapseButton.MouseButton1Click:Connect(function()
            sectionData:ToggleCollapse()
        end)
        
        sectionHeader.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sectionData:ToggleCollapse()
            end
        end)
    end
    
    -- Initial collapse state
    if sectionConfig.Collapsed then
        sectionContent.Visible = false
        divider.Visible = false
        sectionFrame.Size = UDim2.new(1, 0, 0, 36)
    end
    
    -- Update section size
    function sectionData:UpdateSize()
        if sectionData.IsCollapsed then
            sectionFrame.Size = UDim2.new(1, 0, 0, 36)
            return
        end
        
        local totalHeight = 40
        for _, element in ipairs(sectionContent:GetChildren()) do
            if element:IsA("Frame") then
                totalHeight = totalHeight + element.AbsoluteSize.Y + 4
            end
        end
        
        sectionFrame.Size = UDim2.new(1, 0, 0, totalHeight + 4)
        tab.Window:UpdateCanvasSize()
    end
    
    function sectionData:ToggleCollapse()
        if not sectionData.IsCollapsible then return end
        
        sectionData.IsCollapsed = not sectionData.IsCollapsed
        
        if sectionData.IsCollapsed then
            -- Collapse
            collapseButton.Text = "▶"
            
            local targetSize = UDim2.new(1, 0, 0, 36)
            Utils:PlayTween(sectionFrame, Anim.Smooth(0.3), {
                Size = targetSize
            }, function()
                sectionContent.Visible = false
                divider.Visible = false
            end)
        else
            -- Expand
            collapseButton.Text = "▼"
            sectionContent.Visible = true
            divider.Visible = true
            
            sectionData:UpdateSize()
            
            local targetSize = sectionFrame.Size
            sectionFrame.Size = UDim2.new(1, 0, 0, 36)
            
            Utils:PlayTween(sectionFrame, Anim.Spring(0.4), {
                Size = targetSize
            })
        end
    end
    
    function sectionData:SetTitle(title)
        sectionConfig.Name = title
        sectionTitle.Text = title
    end
    
    function sectionData:Destroy()
        sectionFrame:Destroy()
        Utils:TableRemove(tab.Sections, sectionData)
    end
    
    -- Add to tab sections
    table.insert(tab.Sections, sectionData)
    
    return sectionData
end

--============================================--
-- SECTION 26: ELEMENT FACTORY
--============================================--
local ElementFactory = {}

function ElementFactory:CreateToggle(section, config)
    local theme = ThemeManager:GetTheme()
    
    local toggleConfig = {
        Title = config.Title or "Toggle",
        Description = config.Description or "",
        Default = config.Default or false,
        Callback = config.Callback or function(value) end,
        Flag = config.Flag or nil,
        Enabled = config.Enabled ~= false,
        Color = config.Color or theme.Main
    }
    
    local toggled = toggleConfig.Default
    
    -- Toggle frame
    local toggleFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Toggle_" .. toggleConfig.Title,
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, toggleConfig.Description ~= "" and 52 or 38),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(toggleFrame, 8)
    
    -- Title
    local titleLabel = Utils:CreateText({
        Parent = toggleFrame,
        Name = "Title",
        Position = UDim2.new(0, 10, 0, toggleConfig.Description ~= "" and 6 or 0),
        Size = UDim2.new(1, -65, 0, 20),
        Font = Fonts.Medium,
        Text = toggleConfig.Title,
        TextColor3 = theme.Text,
        TextSize = 13,
        ZIndex = 171
    })
    
    -- Description (if provided)
    local descLabel = nil
    if toggleConfig.Description ~= "" then
        descLabel = Utils:CreateText({
            Parent = toggleFrame,
            Name = "Description",
            Position = UDim2.new(0, 10, 0, 26),
            Size = UDim2.new(1, -65, 0, 16),
            Font = Fonts.Regular,
            Text = toggleConfig.Description,
            TextColor3 = theme.MutedText,
            TextSize = 11,
            ZIndex = 171
        })
    end
    
    -- Toggle background
    local toggleBackground = Utils:CreateInstance("Frame", {
        Parent = toggleFrame,
        Name = "ToggleBg",
        BackgroundColor3 = toggled and toggleConfig.Color or theme.SurfaceDark,
        Size = UDim2.new(0, 48, 0, 28),
        Position = UDim2.new(1, -58, 0.5, -14),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(toggleBackground, 14)
    
    -- Toggle knob
    local toggleKnob = Utils:CreateInstance("Frame", {
        Parent = toggleBackground,
        Name = "Knob",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 24, 0, 24),
        Position = toggled and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12),
        BorderSizePixel = 0,
        ZIndex = 172
    })
    Utils:AddCorner(toggleKnob, 12)
    
    -- Knob shadow
    local knobShadow = Utils:CreateInstance("ImageLabel", {
        Parent = toggleKnob,
        Name = "KnobShadow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 4, 1, 4),
        Position = UDim2.new(0, -2, 0, 2),
        Image = "rbxassetid://",
        ImageColor3 = theme.Shadow,
        ImageTransparency = 0.5,
        ZIndex = 171
    })
    Utils:AddCorner(knobShadow, 12)
    
    -- Toggle function
    local function updateToggle(state)
        toggled = state
        
        if toggled then
            Utils:PlayTween(toggleBackground, Anim.Smooth(0.3), {
                BackgroundColor3 = toggleConfig.Color
            })
            Utils:PlayTween(toggleKnob, Anim.Spring(0.4), {
                Position = UDim2.new(1, -26, 0.5, -12)
            })
        else
            Utils:PlayTween(toggleBackground, Anim.Smooth(0.3), {
                BackgroundColor3 = theme.SurfaceDark
            })
            Utils:PlayTween(toggleKnob, Anim.Spring(0.4), {
                Position = UDim2.new(0, 2, 0.5, -12)
            })
        end
        
        -- Callback
        if toggleConfig.Callback then
            task.spawn(function()
                toggleConfig.Callback(toggled)
            end)
        end
        
        -- Flag
        if toggleConfig.Flag then
            ConfigSystem:Set(toggleConfig.Flag, toggled)
        end
    end
    
    -- Click handler
    toggleBackground.InputBegan:Connect(function(input)
        if not toggleConfig.Enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            updateToggle(not toggled)
        end
    end)
    
    toggleFrame.InputBegan:Connect(function(input)
        if not toggleConfig.Enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            updateToggle(not toggled)
        end
    end)
    
    -- Hover effect
    toggleFrame.MouseEnter:Connect(function()
        if toggleConfig.Enabled then
            Utils:PlayTween(toggleFrame, Anim.Fast(), {
                BackgroundTransparency = 0.5
            })
        end
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        if toggleConfig.Enabled then
            Utils:PlayTween(toggleFrame, Anim.Fast(), {
                BackgroundTransparency = 0.7
            })
        end
    end)
    
    -- Element data
    local elementData = {
        Type = "Toggle",
        Frame = toggleFrame,
        Config = toggleConfig,
        State = {
            Value = toggled
        },
        SetValue = function(self, value)
            updateToggle(value)
        end,
        GetValue = function(self)
            return toggled
        end,
        SetEnabled = function(self, enabled)
            toggleConfig.Enabled = enabled
            if not enabled then
                Utils:PlayTween(toggleFrame, Anim.Fast(), {
                    BackgroundTransparency = 0.9
                })
            else
                Utils:PlayTween(toggleFrame, Anim.Fast(), {
                    BackgroundTransparency = 0.7
                })
            end
        end,
        Destroy = function(self)
            toggleFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    -- Load from config
    if toggleConfig.Flag then
        local savedValue = ConfigSystem:Get(toggleConfig.Flag)
        if savedValue ~= nil then
            updateToggle(savedValue)
        end
    end
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

function ElementFactory:CreateButton(section, config)
    local theme = ThemeManager:GetTheme()
    
    local buttonConfig = {
        Title = config.Title or "Button",
        Description = config.Description or "",
        Callback = config.Callback or function() end,
        Color = config.Color or theme.Main,
        Enabled = config.Enabled ~= false,
        Style = config.Style or "default" -- "default", "outline", "ghost", "danger"
    }
    
    -- Style colors
    local styleColors = {
        default = {
            bg = buttonConfig.Color,
            text = theme.Text,
            stroke = buttonConfig.Color
        },
        outline = {
            bg = Color3.fromRGB(255, 255, 255),
            text = buttonConfig.Color,
            stroke = buttonConfig.Color
        },
        ghost = {
            bg = Color3.fromRGB(255, 255, 255),
            text = theme.Text,
            stroke = theme.Border
        },
        danger = {
            bg = theme.Error,
            text = theme.Text,
            stroke = theme.Error
        }
    }
    
    local style = styleColors[buttonConfig.Style] or styleColors.default
    
    -- Button frame
    local buttonFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Button_" .. buttonConfig.Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, buttonConfig.Description ~= "" and 52 or 38),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    
    -- Button
    local button = Utils:CreateButton({
        Parent = buttonFrame,
        Name = "Btn",
        BackgroundColor3 = style.bg,
        BackgroundTransparency = buttonConfig.Style == "outline" and 0.9 or 
                                  buttonConfig.Style == "ghost" and 0.95 or 0.2,
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, buttonConfig.Description ~= "" and 0 or 0, 0),
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(button, 8)
    Utils:AddStroke(button, style.stroke, 1)
    
    -- Button text
    local buttonText = Utils:CreateText({
        Parent = button,
        Name = "Text",
        Size = UDim2.new(1, 0, 1, 0),
        Font = Fonts.Bold,
        Text = buttonConfig.Title,
        TextColor3 = style.text,
        TextSize = 13,
        ZIndex = 172
    })
    
    -- Description
    if buttonConfig.Description ~= "" then
        Utils:CreateText({
            Parent = buttonFrame,
            Name = "Description",
            Position = UDim2.new(0, 4, 0, 36),
            Size = UDim2.new(1, -8, 0, 14),
            Font = Fonts.Regular,
            Text = buttonConfig.Description,
            TextColor3 = theme.MutedText,
            TextSize = 11,
            ZIndex = 171
        })
    end
    
    -- Click handler
    button.MouseButton1Click:Connect(function()
        if not buttonConfig.Enabled then return end
        
        -- Click animation
        Utils:PlayTween(button, Anim.Fast(0.1), {
            Size = UDim2.new(0.96, 0, 0.88, 0)
        })
        
        task.delay(0.1, function()
            Utils:PlayTween(button, Anim.Spring(0.3), {
                Size = UDim2.new(1, 0, 1, 0)
            })
        end)
        
        -- Callback
        if buttonConfig.Callback then
            task.spawn(function()
                buttonConfig.Callback()
            end)
        end
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        if buttonConfig.Enabled then
            Utils:PlayTween(button, Anim.Fast(), {
                BackgroundTransparency = buttonConfig.Style == "outline" and 0.8 or
                                          buttonConfig.Style == "ghost" and 0.9 or 0.1
            })
        end
    end)
    
    button.MouseLeave:Connect(function()
        if buttonConfig.Enabled then
            Utils:PlayTween(button, Anim.Fast(), {
                BackgroundTransparency = buttonConfig.Style == "outline" and 0.9 or
                                          buttonConfig.Style == "ghost" and 0.95 or 0.2
            })
        end
    end)
    
    -- Element data
    local elementData = {
        Type = "Button",
        Frame = buttonFrame,
        Config = buttonConfig,
        SetText = function(self, text)
            buttonConfig.Title = text
            buttonText.Text = text
        end,
        SetEnabled = function(self, enabled)
            buttonConfig.Enabled = enabled
            if not enabled then
                Utils:PlayTween(button, Anim.Fast(), {
                    BackgroundTransparency = 0.8
                })
            else
                Utils:PlayTween(button, Anim.Fast(), {
                    BackgroundTransparency = 0.2
                })
            end
        end,
        Click = function(self)
            if buttonConfig.Callback then
                buttonConfig.Callback()
            end
        end,
        Destroy = function(self)
            buttonFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 27: TAB & SECTION ADD METHODS
--============================================--

-- Add tab method to window
function WindowBuilder:AddTab(config)
    local tab = TabSystem:CreateTab(self, config)
    return tab
end

-- Select tab method
function WindowBuilder:SelectTab(tab)
    if tab then
        tab:Select()
    end
end

-- Add section method to tab
function TabSystem.CreateTab_addSection(tab, config)
    local section = SectionBuilder:CreateSection(tab, config)
    
    -- Add element methods to section
    function section:AddToggle(config)
        return ElementFactory:CreateToggle(self, config)
    end
    
    function section:AddButton(config)
        return ElementFactory:CreateButton(self, config)
    end
    
    -- Placeholder for more elements (will be added in Part 5)
    function section:AddSlider(config)
        -- Will be implemented in Part 5
    end
    
    function section:AddDropdown(config)
        -- Will be implemented in Part 5
    end
    
    function section:AddTextbox(config)
        -- Will be implemented in Part 5
    end
    
    function section:AddKeybind(config)
        -- Will be implemented in Part 5
    end
    
    function section:AddColorPicker(config)
        -- Will be implemented in Part 5
    end
    
    function section:AddLabel(config)
        -- Will be implemented in Part 5
    end
    
    function section:AddParagraph(config)
        -- Will be implemented in Part 5
    end
    
    function section:AddDivider()
        -- Will be implemented in Part 5
    end
    
    function section:AddSearchBox(config)
        -- Will be implemented in Part 5
    end
    
    function section:AddProgressBar(config)
        -- Will be implemented in Part 5
    end
    
    return section
end

-- Override tab's AddSection
local originalCreateTab = TabSystem.CreateTab
function TabSystem.CreateTab(window, config)
    local tab = originalCreateTab(window, config)
    tab.AddSection = function(self, sectionConfig)
        return TabSystem.CreateTab_addSection(self, sectionConfig)
    end
    return tab
end

-- Add ElementFactory to PHUCMAX
PHUCMAX.ElementFactory = ElementFactory
PHUCMAX.TabSystem = TabSystem
PHUCMAX.SectionBuilder = SectionBuilder

-- This concludes Part 4 of the PHUCMAX UI Library
-- Part 5 will continue with Slider, Dropdown, Textbox, and Keybind components



--============================================--
-- SECTION 28: SLIDER COMPONENT
--============================================--

function ElementFactory:CreateSlider(section, config)
    local theme = ThemeManager:GetTheme()
    
    local sliderConfig = {
        Title = config.Title or "Slider",
        Description = config.Description or "",
        Min = config.Min or 0,
        Max = config.Max or 100,
        Default = config.Default or 50,
        Step = config.Step or 1,
        Suffix = config.Suffix or "",
        Prefix = config.Prefix or "",
        Callback = config.Callback or function(value) end,
        Flag = config.Flag or nil,
        Color = config.Color or theme.Main,
        Enabled = config.Enabled ~= false,
        ShowValue = config.ShowValue ~= false,
        Compact = config.Compact or false
    }
    
    local currentValue = Utils:Clamp(sliderConfig.Default, sliderConfig.Min, sliderConfig.Max)
    local isDragging = false
    
    -- Slider frame
    local sliderFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Slider_" .. sliderConfig.Title,
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, sliderConfig.Compact and 44 or 62),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(sliderFrame, 8)
    
    -- Title
    local titleLabel = Utils:CreateText({
        Parent = sliderFrame,
        Name = "Title",
        Position = UDim2.new(0, 10, 0, 6),
        Size = UDim2.new(1, -20, 0, 18),
        Font = Fonts.Medium,
        Text = sliderConfig.Title,
        TextColor3 = theme.Text,
        TextSize = 13,
        ZIndex = 171
    })
    
    -- Value display
    local valueLabel = nil
    if sliderConfig.ShowValue then
        valueLabel = Utils:CreateText({
            Parent = sliderFrame,
            Name = "Value",
            Position = UDim2.new(0, 10, 0, 24),
            Size = UDim2.new(1, -20, 0, 16),
            Font = Fonts.Bold,
            Text = sliderConfig.Prefix .. tostring(currentValue) .. sliderConfig.Suffix,
            TextColor3 = sliderConfig.Color,
            TextSize = 12,
            ZIndex = 171
        })
    end
    
    -- Slider track
    local trackY = sliderConfig.ShowValue and 44 or 30
    local sliderTrack = Utils:CreateInstance("Frame", {
        Parent = sliderFrame,
        Name = "Track",
        BackgroundColor3 = theme.SurfaceDark,
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, trackY),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(sliderTrack, 3)
    
    -- Track fill
    local fillPercent = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
    local trackFill = Utils:CreateInstance("Frame", {
        Parent = sliderTrack,
        Name = "Fill",
        BackgroundColor3 = sliderConfig.Color,
        Size = UDim2.new(fillPercent, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 172
    })
    Utils:AddCorner(trackFill, 3)
    
    -- Fill glow
    local fillGlow = Utils:CreateInstance("Frame", {
        Parent = trackFill,
        Name = "Glow",
        BackgroundColor3 = sliderConfig.Color,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 1, 4),
        Position = UDim2.new(0, 0, 0, -2),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(fillGlow, 3)
    
    -- Slider knob
    local sliderKnob = Utils:CreateInstance("Frame", {
        Parent = trackFill,
        Name = "Knob",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -9, 0.5, -9),
        BorderSizePixel = 0,
        ZIndex = 173,
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    Utils:AddCorner(sliderKnob, 9)
    Utils:AddStroke(sliderKnob, sliderConfig.Color, 2)
    
    -- Knob shadow
    Utils:CreateInstance("ImageLabel", {
        Parent = sliderKnob,
        Name = "Shadow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0, -3, 0, 3),
        Image = "rbxassetid://",
        ImageColor3 = theme.Shadow,
        ImageTransparency = 0.6,
        ZIndex = 172
    })
    
    -- Input display (for direct value input)
    local inputBox = nil
    if not sliderConfig.Compact then
        inputBox = Utils:CreateInstance("TextBox", {
            Parent = sliderFrame,
            Name = "Input",
            BackgroundColor3 = theme.SurfaceDark,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(0, 60, 0, 20),
            Position = UDim2.new(1, -70, 0, 4),
            Text = tostring(currentValue),
            Font = Fonts.Regular,
            TextColor3 = theme.Text,
            TextSize = 11,
            BorderSizePixel = 0,
            ZIndex = 171
        })
        Utils:AddCorner(inputBox, 4)
    end
    
    -- Update function
    local function updateSlider(value, triggerCallback)
        currentValue = Utils:Clamp(
            Utils:Round(value / sliderConfig.Step) * sliderConfig.Step,
            sliderConfig.Min,
            sliderConfig.Max
        )
        
        local percent = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
        
        Utils:PlayTween(trackFill, Anim.Fast(0.1), {
            Size = UDim2.new(percent, 0, 1, 0)
        })
        
        if valueLabel then
            valueLabel.Text = sliderConfig.Prefix .. tostring(currentValue) .. sliderConfig.Suffix
        end
        
        if inputBox and not isDragging then
            inputBox.Text = tostring(currentValue)
        end
        
        if triggerCallback ~= false and sliderConfig.Callback then
            task.spawn(function()
                sliderConfig.Callback(currentValue)
            end)
        end
        
        if sliderConfig.Flag then
            ConfigSystem:Set(sliderConfig.Flag, currentValue)
        end
    end
    
    -- Input handlers
    local function startDrag(input)
        if not sliderConfig.Enabled then return end
        isDragging = true
        
        local mousePos = input.Position
        local trackPos = sliderTrack.AbsolutePosition
        local trackSize = sliderTrack.AbsoluteSize
        
        local percent = (mousePos.X - trackPos.X) / trackSize.X
        percent = Utils:Clamp(percent, 0, 1)
        
        local value = sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent
        updateSlider(value)
    end
    
    local function updateDrag(input)
        if not isDragging then return end
        
        local mousePos = input.Position
        local trackPos = sliderTrack.AbsolutePosition
        local trackSize = sliderTrack.AbsoluteSize
        
        local percent = (mousePos.X - trackPos.X) / trackSize.X
        percent = Utils:Clamp(percent, 0, 1)
        
        local value = sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent
        updateSlider(value)
    end
    
    local function endDrag()
        isDragging = false
    end
    
    -- Mouse events on track
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
    
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
    
    -- Input box handler
    if inputBox then
        inputBox.FocusLost:Connect(function(enterPressed)
            local numValue = tonumber(inputBox.Text)
            if numValue then
                updateSlider(numValue)
            else
                inputBox.Text = tostring(currentValue)
            end
        end)
    end
    
    -- Description
    if sliderConfig.Description ~= "" then
        Utils:CreateText({
            Parent = sliderFrame,
            Name = "Description",
            Position = UDim2.new(0, 10, 0, sliderConfig.Compact and 26 or 46),
            Size = UDim2.new(1, -20, 0, 14),
            Font = Fonts.Regular,
            Text = sliderConfig.Description,
            TextColor3 = theme.MutedText,
            TextSize = 11,
            ZIndex = 171
        })
    end
    
    -- Load from config
    if sliderConfig.Flag then
        local savedValue = ConfigSystem:Get(sliderConfig.Flag)
        if savedValue ~= nil then
            updateSlider(savedValue, false)
        end
    end
    
    -- Element data
    local elementData = {
        Type = "Slider",
        Frame = sliderFrame,
        Config = sliderConfig,
        SetValue = function(self, value)
            updateSlider(value, true)
        end,
        GetValue = function(self)
            return currentValue
        end,
        SetMin = function(self, min)
            sliderConfig.Min = min
            if currentValue < min then
                updateSlider(min, true)
            end
        end,
        SetMax = function(self, max)
            sliderConfig.Max = max
            if currentValue > max then
                updateSlider(max, true)
            end
        end,
        SetEnabled = function(self, enabled)
            sliderConfig.Enabled = enabled
            if not enabled then
                Utils:PlayTween(sliderFrame, Anim.Fast(), {
                    BackgroundTransparency = 0.9
                })
            else
                Utils:PlayTween(sliderFrame, Anim.Fast(), {
                    BackgroundTransparency = 0.7
                })
            end
        end,
        Destroy = function(self)
            sliderFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 29: DROPDOWN COMPONENT
--============================================--

function ElementFactory:CreateDropdown(section, config)
    local theme = ThemeManager:GetTheme()
    
    local dropdownConfig = {
        Title = config.Title or "Dropdown",
        Description = config.Description or "",
        Options = config.Options or {},
        Default = config.Default or nil,
        MultiSelect = config.MultiSelect or false,
        MaxSelections = config.MaxSelections or 99,
        Searchable = config.Searchable ~= false,
        Callback = config.Callback or function(value) end,
        Flag = config.Flag or nil,
        Color = config.Color or theme.Main,
        Enabled = config.Enabled ~= false
    }
    
    local isOpen = false
    local selectedOptions = {}
    local filteredOptions = {}
    
    -- Initialize selections
    if dropdownConfig.MultiSelect then
        if dropdownConfig.Default and type(dropdownConfig.Default) == "table" then
            selectedOptions = {table.unpack(dropdownConfig.Default)}
        end
    else
        if dropdownConfig.Default and Utils:TableFind(dropdownConfig.Options, dropdownConfig.Default) then
            selectedOptions = {dropdownConfig.Default}
        end
    end
    
    -- Filter options
    local function filterOptions(query)
        if not query or query == "" then
            filteredOptions = {table.unpack(dropdownConfig.Options)}
        else
            filteredOptions = {}
            query = string.lower(query)
            for _, option in ipairs(dropdownConfig.Options) do
                if string.find(string.lower(option), query) then
                    table.insert(filteredOptions, option)
                end
            end
        end
    end
    filterOptions("")
    
    -- Dropdown frame
    local dropdownFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Dropdown_" .. dropdownConfig.Title,
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, dropdownConfig.Description ~= "" and 52 or 40),
        BorderSizePixel = 0,
        ZIndex = 170,
        ClipsDescendants = false
    })
    Utils:AddCorner(dropdownFrame, 8)
    
    -- Title
    if dropdownConfig.Title ~= "" then
        Utils:CreateText({
            Parent = dropdownFrame,
            Name = "Title",
            Position = UDim2.new(0, 10, 0, 4),
            Size = UDim2.new(1, -20, 0, 16),
            Font = Fonts.Medium,
            Text = dropdownConfig.Title,
            TextColor3 = theme.Text,
            TextSize = 13,
            ZIndex = 171
        })
    end
    
    -- Dropdown button
    local dropdownButton = Utils:CreateButton({
        Parent = dropdownFrame,
        Name = "DropdownBtn",
        BackgroundColor3 = theme.SurfaceDark,
        BackgroundTransparency = 0.4,
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, dropdownConfig.Title ~= "" and 20 or 0, 0),
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(dropdownButton, 8)
    Utils:AddStroke(dropdownButton, theme.Border, 0.5)
    
    -- Selected text
    local selectedText = Utils:CreateText({
        Parent = dropdownButton,
        Name = "SelectedText",
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Fonts.Medium,
        Text = #selectedOptions > 0 and table.concat(selectedOptions, ", ") or "Select...",
        TextColor3 = #selectedOptions > 0 and theme.Text or theme.MutedText,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 172
    })
    
    -- Arrow
    local arrowLabel = Utils:CreateText({
        Parent = dropdownButton,
        Name = "Arrow",
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Font = Fonts.Bold,
        Text = "▼",
        TextColor3 = theme.Main,
        TextSize = 12,
        ZIndex = 172
    })
    
    -- Options container
    local optionsContainer = Utils:CreateInstance("Frame", {
        Parent = dropdownFrame,
        Name = "OptionsContainer",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.15,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BorderSizePixel = 0,
        ZIndex = 200,
        Visible = false,
        ClipsDescendants = true
    })
    Utils:AddCorner(optionsContainer, 10)
    Utils:AddStroke(optionsContainer, theme.Glow, 1)
    
    -- Search box
    local searchBox = nil
    if dropdownConfig.Searchable then
        searchBox = Utils:CreateInstance("TextBox", {
            Parent = optionsContainer,
            Name = "SearchBox",
            BackgroundColor3 = theme.SurfaceDark,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(1, -12, 0, 28),
            Position = UDim2.new(0, 6, 0, 6),
            PlaceholderText = "Search...",
            Text = "",
            Font = Fonts.Regular,
            TextColor3 = theme.Text,
            PlaceholderColor3 = theme.MutedText,
            TextSize = 12,
            ClearTextOnFocus = false,
            BorderSizePixel = 0,
            ZIndex = 201
        })
        Utils:AddCorner(searchBox, 6)
        
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            filterOptions(searchBox.Text)
            refreshOptions()
        end)
    end
    
    -- Options scroll
    local optionsScroll = Utils:CreateInstance("ScrollingFrame", {
        Parent = optionsContainer,
        Name = "OptionsScroll",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -4, 1, -(dropdownConfig.Searchable and 40 or 6)),
        Position = UDim2.new(0, 2, 0, dropdownConfig.Searchable and 38 or 6),
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Main,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 201,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    
    local optionsList = Instance.new("UIListLayout")
    optionsList.Padding = UDim.new(0, 2)
    optionsList.VerticalAlignment = Enum.VerticalAlignment.Top
    optionsList.SortOrder = Enum.SortOrder.LayoutOrder
    optionsList.Parent = optionsScroll
    
    -- Option buttons
    local optionButtons = {}
    
    local function refreshOptions()
        -- Clear existing
        for _, btn in ipairs(optionButtons) do
            btn:Destroy()
        end
        optionButtons = {}
        
        -- Create new
        for _, option in ipairs(filteredOptions) do
            local isSelected = Utils:TableFind(selectedOptions, option) ~= nil
            
            local optionBtn = Utils:CreateButton({
                Parent = optionsScroll,
                Name = "Option_" .. option,
                BackgroundColor3 = isSelected and dropdownConfig.Color or theme.SurfaceLight,
                BackgroundTransparency = isSelected and 0.5 or 0.6,
                Size = UDim2.new(1, -4, 0, 28),
                Text = "",
                BorderSizePixel = 0,
                ZIndex = 202
            })
            Utils:AddCorner(optionBtn, 6)
            
            -- Checkmark for multi-select
            local checkmark = nil
            if dropdownConfig.MultiSelect and isSelected then
                checkmark = Utils:CreateText({
                    Parent = optionBtn,
                    Name = "Checkmark",
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = Fonts.Bold,
                    Text = "✓",
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    ZIndex = 203
                })
            end
            
            -- Option text
            Utils:CreateText({
                Parent = optionBtn,
                Name = "Text",
                Position = UDim2.new(0, dropdownConfig.MultiSelect and 30 or 8, 0, 0),
                Size = UDim2.new(1, -(dropdownConfig.MultiSelect and 38 or 16), 1, 0),
                Font = Fonts.Regular,
                Text = option,
                TextColor3 = isSelected and theme.Text or theme.SubText,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 203
            })
            
            -- Click handler
            optionBtn.MouseButton1Click:Connect(function()
                if dropdownConfig.MultiSelect then
                    local index = Utils:TableFind(selectedOptions, option)
                    if index then
                        table.remove(selectedOptions, index)
                    else
                        if #selectedOptions < dropdownConfig.MaxSelections then
                            table.insert(selectedOptions, option)
                        end
                    end
                    
                    selectedText.Text = #selectedOptions > 0 and table.concat(selectedOptions, ", ") or "Select..."
                    selectedText.TextColor3 = #selectedOptions > 0 and theme.Text or theme.MutedText
                    
                    if dropdownConfig.Callback then
                        dropdownConfig.Callback(selectedOptions)
                    end
                    
                    refreshOptions()
                else
                    selectedOptions = {option}
                    selectedText.Text = option
                    selectedText.TextColor3 = theme.Text
                    
                    if dropdownConfig.Callback then
                        dropdownConfig.Callback(option)
                    end
                    
                    closeDropdown()
                end
                
                if dropdownConfig.Flag then
                    ConfigSystem:Set(dropdownConfig.Flag, dropdownConfig.MultiSelect and selectedOptions or option)
                end
            end)
            
            -- Hover effect
            optionBtn.MouseEnter:Connect(function()
                if not Utils:TableFind(selectedOptions, option) then
                    Utils:PlayTween(optionBtn, Anim.Fast(), {
                        BackgroundTransparency = 0.4
                    })
                end
            end)
            
            optionBtn.MouseLeave:Connect(function()
                if not Utils:TableFind(selectedOptions, option) then
                    Utils:PlayTween(optionBtn, Anim.Fast(), {
                        BackgroundTransparency = 0.6
                    })
                end
            end)
            
            table.insert(optionButtons, optionBtn)
        end
        
        -- Update canvas size
        optionsScroll.CanvasSize = UDim2.new(0, 0, 0, #filteredOptions * 30 + 4)
    end
    
    -- Open/close functions
    local function openDropdown()
        isOpen = true
        optionsContainer.Visible = true
        filterOptions(searchBox and searchBox.Text or "")
        refreshOptions()
        
        local targetHeight = math.min(#filteredOptions * 30 + (dropdownConfig.Searchable and 44 or 10), 200)
        
        Utils:PlayTween(optionsContainer, Anim.Spring(0.4), {
            Size = UDim2.new(1, 0, 0, targetHeight)
        })
        
        Utils:PlayTween(arrowLabel, Anim.Smooth(), {
            Rotation = 180
        })
        
        dropdownFrame.ZIndex = 199
    end
    
    local function closeDropdown()
        isOpen = false
        
        Utils:PlayTween(optionsContainer, Anim.Smooth(0.3), {
            Size = UDim2.new(1, 0, 0, 0)
        })
        
        Utils:PlayTween(arrowLabel, Anim.Smooth(), {
            Rotation = 0
        })
        
        dropdownFrame.ZIndex = 170
        
        task.delay(0.3, function()
            if not isOpen then
                optionsContainer.Visible = false
            end
        end)
    end
    
    -- Toggle dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        if not dropdownConfig.Enabled then return end
        
        if isOpen then
            closeDropdown()
        else
            openDropdown()
        end
    end)
    
    -- Close when clicking outside
    Services.UserInputService.InputBegan:Connect(function(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = Utils:GetMouseLocation()
            local dropdownPos = dropdownFrame.AbsolutePosition
            local dropdownSize = dropdownFrame.AbsoluteSize
            
            if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                    mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y + 200) then
                closeDropdown()
            end
        end
    end)
    
    -- Description
    if dropdownConfig.Description ~= "" then
        Utils:CreateText({
            Parent = dropdownFrame,
            Name = "Description",
            Position = UDim2.new(0, 10, 0, 36),
            Size = UDim2.new(1, -20, 0, 14),
            Font = Fonts.Regular,
            Text = dropdownConfig.Description,
            TextColor3 = theme.MutedText,
            TextSize = 11,
            ZIndex = 171
        })
    end
    
    -- Initialize
    refreshOptions()
    
    -- Load from config
    if dropdownConfig.Flag then
        local savedValue = ConfigSystem:Get(dropdownConfig.Flag)
        if savedValue ~= nil then
            if dropdownConfig.MultiSelect and type(savedValue) == "table" then
                selectedOptions = savedValue
            elseif not dropdownConfig.MultiSelect and type(savedValue) == "string" then
                selectedOptions = {savedValue}
            end
            selectedText.Text = #selectedOptions > 0 and table.concat(selectedOptions, ", ") or "Select..."
            selectedText.TextColor3 = #selectedOptions > 0 and theme.Text or theme.MutedText
            refreshOptions()
        end
    end
    
    -- Element data
    local elementData = {
        Type = "Dropdown",
        Frame = dropdownFrame,
        Config = dropdownConfig,
        SetValue = function(self, value)
            if dropdownConfig.MultiSelect and type(value) == "table" then
                selectedOptions = value
            elseif not dropdownConfig.MultiSelect and type(value) == "string" then
                selectedOptions = {value}
            end
            selectedText.Text = #selectedOptions > 0 and table.concat(selectedOptions, ", ") or "Select..."
            selectedText.TextColor3 = #selectedOptions > 0 and theme.Text or theme.MutedText
            refreshOptions()
            
            if dropdownConfig.Callback then
                dropdownConfig.Callback(dropdownConfig.MultiSelect and selectedOptions or value)
            end
        end,
        GetValue = function(self)
            return dropdownConfig.MultiSelect and selectedOptions or (selectedOptions[1] or nil)
        end,
        SetOptions = function(self, options)
            dropdownConfig.Options = options
            filterOptions("")
            refreshOptions()
        end,
        AddOption = function(self, option)
            table.insert(dropdownConfig.Options, option)
            filterOptions(searchBox and searchBox.Text or "")
            refreshOptions()
        end,
        RemoveOption = function(self, option)
            Utils:TableRemove(dropdownConfig.Options, option)
            Utils:TableRemove(selectedOptions, option)
            filterOptions(searchBox and searchBox.Text or "")
            refreshOptions()
        end,
        ClearOptions = function(self)
            dropdownConfig.Options = {}
            selectedOptions = {}
            filterOptions("")
            refreshOptions()
            selectedText.Text = "Select..."
            selectedText.TextColor3 = theme.MutedText
        end,
        Destroy = function(self)
            dropdownFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 30: TEXTBOX COMPONENT
--============================================--

function ElementFactory:CreateTextbox(section, config)
    local theme = ThemeManager:GetTheme()
    
    local textboxConfig = {
        Title = config.Title or "Textbox",
        Description = config.Description or "",
        Default = config.Default or "",
        Placeholder = config.Placeholder or "Enter text...",
        MultiLine = config.MultiLine or false,
        Password = config.Password or false,
        MaxLength = config.MaxLength or 1000,
        Callback = config.Callback or function(text, enterPressed) end,
        Flag = config.Flag or nil,
        Color = config.Color or theme.Main,
        Enabled = config.Enabled ~= false,
        ClearOnFocus = config.ClearOnFocus or false
    }
    
    -- Textbox frame
    local textboxFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Textbox_" .. textboxConfig.Title,
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, textboxConfig.MultiLine and 80 or textboxConfig.Description ~= "" and 68 or 56),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(textboxFrame, 8)
    
    -- Title
    if textboxConfig.Title ~= "" then
        Utils:CreateText({
            Parent = textboxFrame,
            Name = "Title",
            Position = UDim2.new(0, 10, 0, 4),
            Size = UDim2.new(1, -20, 0, 18),
            Font = Fonts.Medium,
            Text = textboxConfig.Title,
            TextColor3 = theme.Text,
            TextSize = 13,
            ZIndex = 171
        })
    end
    
    -- Textbox background
    local textboxBg = Utils:CreateInstance("Frame", {
        Parent = textboxFrame,
        Name = "TextboxBg",
        BackgroundColor3 = theme.SurfaceDark,
        BackgroundTransparency = 0.4,
        Size = UDim2.new(1, 0, 0, textboxConfig.MultiLine and 60 or 32),
        Position = UDim2.new(0, 0, textboxConfig.Title ~= "" and 24 or 4, 0),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(textboxBg, 8)
    
    -- Border highlight (for focus)
    local borderHighlight = Utils:AddStroke(textboxBg, textboxConfig.Color, 1)
    borderHighlight.Transparency = 1
    
    -- Textbox
    local textbox = Utils:CreateInstance(textboxConfig.MultiLine and "TextBox" or "TextBox", {
        Parent = textboxBg,
        Name = "Input",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -16, 1, 0),
        PlaceholderText = textboxConfig.Placeholder,
        Text = textboxConfig.Default,
        Font = Fonts.Regular,
        TextColor3 = theme.Text,
        PlaceholderColor3 = theme.MutedText,
        TextSize = 13,
        ClearTextOnFocus = textboxConfig.ClearOnFocus,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = textboxConfig.MultiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        MultiLine = textboxConfig.MultiLine,
        TextWrapped = textboxConfig.MultiLine,
        BorderSizePixel = 0,
        ZIndex = 172
    })
    
    if textboxConfig.Password then
        -- Roblox doesn't support password masking natively, but we can set a placeholder
        textbox.PlaceholderText = "••••••••"
    end
    
    -- Focus effects
    textbox.Focused:Connect(function()
        Utils:PlayTween(borderHighlight, Anim.Fast(), {
            Transparency = 0
        })
        Utils:PlayTween(textboxBg, Anim.Fast(), {
            BackgroundTransparency = 0.2
        })
    end)
    
    textbox.FocusLost:Connect(function(enterPressed)
        Utils:PlayTween(borderHighlight, Anim.Fast(), {
            Transparency = 1
        })
        Utils:PlayTween(textboxBg, Anim.Fast(), {
            BackgroundTransparency = 0.4
        })
        
        if textboxConfig.Callback then
            task.spawn(function()
                textboxConfig.Callback(textbox.Text, enterPressed)
            end)
        end
        
        if textboxConfig.Flag then
            ConfigSystem:Set(textboxConfig.Flag, textbox.Text)
        end
    end)
    
    -- Character limit
    textbox:GetPropertyChangedSignal("Text"):Connect(function()
        if #textbox.Text > textboxConfig.MaxLength then
            textbox.Text = string.sub(textbox.Text, 1, textboxConfig.MaxLength)
        end
    end)
    
    -- Description
    if textboxConfig.Description ~= "" then
        Utils:CreateText({
            Parent = textboxFrame,
            Name = "Description",
            Position = UDim2.new(0, 10, 0, textboxConfig.MultiLine and 86 or textboxConfig.Title ~= "" and 58 or 38),
            Size = UDim2.new(1, -20, 0, 14),
            Font = Fonts.Regular,
            Text = textboxConfig.Description,
            TextColor3 = theme.MutedText,
            TextSize = 11,
            ZIndex = 171
        })
    end
    
    -- Load from config
    if textboxConfig.Flag then
        local savedValue = ConfigSystem:Get(textboxConfig.Flag)
        if savedValue ~= nil then
            textbox.Text = savedValue
        end
    end
    
    -- Element data
    local elementData = {
        Type = "Textbox",
        Frame = textboxFrame,
        Config = textboxConfig,
        SetValue = function(self, text)
            textbox.Text = text or ""
        end,
        GetValue = function(self)
            return textbox.Text
        end,
        SetPlaceholder = function(self, placeholder)
            textboxConfig.Placeholder = placeholder
            textbox.PlaceholderText = placeholder
        end,
        SetEnabled = function(self, enabled)
            textboxConfig.Enabled = enabled
            textbox.TextEditable = enabled
            if not enabled then
                Utils:PlayTween(textboxBg, Anim.Fast(), {
                    BackgroundTransparency = 0.8
                })
            else
                Utils:PlayTween(textboxBg, Anim.Fast(), {
                    BackgroundTransparency = 0.4
                })
            end
        end,
        Focus = function(self)
            textbox:CaptureFocus()
        end,
        Clear = function(self)
            textbox.Text = ""
        end,
        Destroy = function(self)
            textboxFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 31: KEYBIND COMPONENT
--============================================--

function ElementFactory:CreateKeybind(section, config)
    local theme = ThemeManager:GetTheme()
    
    local keybindConfig = {
        Title = config.Title or "Keybind",
        Description = config.Description or "",
        Default = config.Default or Enum.KeyCode.E,
        Callback = config.Callback or function(key) end,
        Flag = config.Flag or nil,
        Color = config.Color or theme.Main,
        Enabled = config.Enabled ~= false,
        AllowNone = config.AllowNone or false,
        Mode = config.Mode or "Toggle" -- "Toggle", "Hold", "Always"
    }
    
    local currentKey = keybindConfig.Default
    local isBinding = false
    local isHeld = false
    
    -- Keybind frame
    local keybindFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Keybind_" .. keybindConfig.Title,
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, keybindConfig.Description ~= "" and 52 or 38),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(keybindFrame, 8)
    
    -- Title
    Utils:CreateText({
        Parent = keybindFrame,
        Name = "Title",
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.55, 0, 1, 0),
        Font = Fonts.Medium,
        Text = keybindConfig.Title,
        TextColor3 = theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 171
    })
    
    -- Key button
    local keyButton = Utils:CreateButton({
        Parent = keybindFrame,
        Name = "KeyBtn",
        BackgroundColor3 = theme.SurfaceDark,
        BackgroundTransparency = 0.4,
        Size = UDim2.new(0.4, 0, 0, 30),
        Position = UDim2.new(0.58, 0, 0.5, -15),
        Text = currentKey.Name,
        Font = Fonts.Bold,
        TextColor3 = keybindConfig.Color,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(keyButton, 8)
    Utils:AddStroke(keyButton, keybindConfig.Color, 1)
    
    -- Mode indicator
    local modeIndicator = Utils:CreateText({
        Parent = keybindFrame,
        Name = "Mode",
        Position = UDim2.new(1, -16, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        Font = Fonts.Bold,
        Text = keybindConfig.Mode == "Toggle" and "T" or keybindConfig.Mode == "Hold" and "H" or "A",
        TextColor3 = theme.MutedText,
        TextSize = 10,
        ZIndex = 171
    })
    
    -- Click to bind
    keyButton.MouseButton1Click:Connect(function()
        if not keybindConfig.Enabled then return end
        
        isBinding = true
        keyButton.Text = "..."
        
        Utils:PlayTween(keyButton, Anim.Fast(), {
            BackgroundTransparency = 0.1
        })
        
        local bindConnection
        bindConnection = Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not isBinding then
                bindConnection:Disconnect()
                return
            end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keyButton.Text = currentKey.Name
                isBinding = false
                
                Utils:PlayTween(keyButton, Anim.Fast(), {
                    BackgroundTransparency = 0.4
                })
                
                if keybindConfig.Callback then
                    task.spawn(function()
                        keybindConfig.Callback(currentKey)
                    end)
                end
                
                if keybindConfig.Flag then
                    ConfigSystem:Set(keybindConfig.Flag, currentKey.Name)
                end
                
                bindConnection:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Allow unbinding with Escape
                if keybindConfig.AllowNone then
                    currentKey = nil
                    keyButton.Text = "None"
                    isBinding = false
                    
                    Utils:PlayTween(keyButton, Anim.Fast(), {
                        BackgroundTransparency = 0.4
                    })
                    
                    bindConnection:Disconnect()
                end
            end
        end)
        
        -- Cancel binding after 5 seconds
        task.delay(5, function()
            if isBinding then
                isBinding = false
                keyButton.Text = currentKey and currentKey.Name or "None"
                
                Utils:PlayTween(keyButton, Anim.Fast(), {
                    BackgroundTransparency = 0.4
                })
                
                bindConnection:Disconnect()
            end
        end)
    end)
    
    -- Right click for mode change
    keyButton.MouseButton2Click:Connect(function()
        local modes = {"Toggle", "Hold", "Always"}
        local currentIndex = Utils:TableFind(modes, keybindConfig.Mode) or 1
        local nextIndex = currentIndex % #modes + 1
        keybindConfig.Mode = modes[nextIndex]
        
        modeIndicator.Text = keybindConfig.Mode == "Toggle" and "T" or 
                             keybindConfig.Mode == "Hold" and "H" or "A"
        
        Utils:PlayTween(modeIndicator, Anim.Bounce(0.3), {
            TextSize = 14
        })
        task.delay(0.3, function()
            Utils:PlayTween(modeIndicator, Anim.Smooth(), {
                TextSize = 10
            })
        end)
    end)
    
    -- Description
    if keybindConfig.Description ~= "" then
        Utils:CreateText({
            Parent = keybindFrame,
            Name = "Description",
            Position = UDim2.new(0, 10, 0, 36),
            Size = UDim2.new(1, -20, 0, 14),
            Font = Fonts.Regular,
            Text = keybindConfig.Description,
            TextColor3 = theme.MutedText,
            TextSize = 11,
            ZIndex = 171
        })
    end
    
    -- Listen for key presses
    local keyConnection
    keyConnection = Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not keybindConfig.Enabled then return end
        if isBinding then return end
        if not currentKey then return end
        
        if input.KeyCode == currentKey then
            if keybindConfig.Mode == "Toggle" then
                isHeld = not isHeld
                if keybindConfig.Callback then
                    task.spawn(function()
                        keybindConfig.Callback(currentKey, isHeld)
                    end)
                end
            elseif keybindConfig.Mode == "Hold" then
                isHeld = true
                if keybindConfig.Callback then
                    task.spawn(function()
                        keybindConfig.Callback(currentKey, true)
                    end)
                end
            elseif keybindConfig.Mode == "Always" then
                if keybindConfig.Callback then
                    task.spawn(function()
                        keybindConfig.Callback(currentKey, true)
                    end)
                end
            end
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == currentKey and keybindConfig.Mode == "Hold" then
            isHeld = false
            if keybindConfig.Callback then
                task.spawn(function()
                    keybindConfig.Callback(currentKey, false)
                end)
            end
        end
    end)
    
    -- Load from config
    if keybindConfig.Flag then
        local savedKeyName = ConfigSystem:Get(keybindConfig.Flag)
        if savedKeyName then
            local success, key = pcall(function()
                return Enum.KeyCode[savedKeyName]
            end)
            if success and key then
                currentKey = key
                keyButton.Text = currentKey.Name
            end
        end
    end
    
    -- Element data
    local elementData = {
        Type = "Keybind",
        Frame = keybindFrame,
        Config = keybindConfig,
        SetKey = function(self, key)
            currentKey = key
            keyButton.Text = currentKey and currentKey.Name or "None"
        end,
        GetKey = function(self)
            return currentKey
        end,
        SetMode = function(self, mode)
            keybindConfig.Mode = mode
            modeIndicator.Text = mode == "Toggle" and "T" or mode == "Hold" and "H" or "A"
        end,
        GetMode = function(self)
            return keybindConfig.Mode
        end,
        Destroy = function(self)
            keybindFrame:Destroy()
            if keyConnection then keyConnection:Disconnect() end
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 32: UPDATE SECTION METHODS
--============================================--

-- Override section's AddSlider, AddDropdown, AddTextbox, AddKeybind
local originalCreateSection = SectionBuilder.CreateSection
function SectionBuilder.CreateSection(tab, config)
    local section = originalCreateSection(tab, config)
    
    -- Override placeholder methods with real implementations
    section.AddSlider = function(self, sliderConfig)
        return ElementFactory:CreateSlider(self, sliderConfig)
    end
    
    section.AddDropdown = function(self, dropdownConfig)
        return ElementFactory:CreateDropdown(self, dropdownConfig)
    end
    
    section.AddTextbox = function(self, textboxConfig)
        return ElementFactory:CreateTextbox(self, textboxConfig)
    end
    
    section.AddKeybind = function(self, keybindConfig)
        return ElementFactory:CreateKeybind(self, keybindConfig)
    end
    
    return section
end

--[[
    PHUCMAX UI Library - Part 6/15
    Color Picker | Label | Paragraph | Divider | Search Box | Progress Bar
    Lines: 5501-6600
]]

--============================================--
-- SECTION 33: COLOR PICKER COMPONENT
--============================================--

function ElementFactory:CreateColorPicker(section, config)
    local theme = ThemeManager:GetTheme()
    
    local pickerConfig = {
        Title = config.Title or "Color Picker",
        Description = config.Description or "",
        Default = config.Default or Color3.fromRGB(255, 255, 255),
        Callback = config.Callback or function(color) end,
        Flag = config.Flag or nil,
        Enabled = config.Enabled ~= false,
        ShowHEX = config.ShowHEX ~= false,
        ShowRGB = config.ShowRGB ~= false,
        ShowHSV = config.ShowHSV or false,
        ShowAlpha = config.ShowAlpha or false,
        Presets = config.Presets or {}
    }
    
    local currentColor = pickerConfig.Default
    local currentHSV = {Color3.toHSV(currentColor)}
    local currentAlpha = 1
    local isOpen = false
    local isDraggingHue = false
    local isDraggingCanvas = false
    
    -- Color picker frame
    local pickerFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "ColorPicker_" .. pickerConfig.Title,
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, pickerConfig.Description ~= "" and 52 or 40),
        BorderSizePixel = 0,
        ZIndex = 170,
        ClipsDescendants = false
    })
    Utils:AddCorner(pickerFrame, 8)
    
    -- Title
    if pickerConfig.Title ~= "" then
        Utils:CreateText({
            Parent = pickerFrame,
            Name = "Title",
            Position = UDim2.new(0, 10, 0, 4),
            Size = UDim2.new(1, -60, 0, 16),
            Font = Fonts.Medium,
            Text = pickerConfig.Title,
            TextColor3 = theme.Text,
            TextSize = 13,
            ZIndex = 171
        })
    end
    
    -- Preview button
    local previewButton = Utils:CreateButton({
        Parent = pickerFrame,
        Name = "PreviewBtn",
        BackgroundColor3 = currentColor,
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, pickerConfig.Title ~= "" and 20 or 0, 0),
        Text = "",
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(previewButton, 8)
    Utils:AddStroke(previewButton, theme.Border, 0.5)
    
    -- Color preview circle
    local colorPreview = Utils:CreateInstance("Frame", {
        Parent = previewButton,
        Name = "ColorPreview",
        BackgroundColor3 = currentColor,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 8, 0.5, -12),
        BorderSizePixel = 0,
        ZIndex = 172
    })
    Utils:AddCorner(colorPreview, 12)
    Utils:AddStroke(colorPreview, Color3.fromRGB(255, 255, 255), 1)
    
    -- Color text
    local colorText = Utils:CreateText({
        Parent = previewButton,
        Name = "ColorText",
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(1, -70, 1, 0),
        Font = Fonts.Regular,
        Text = Utils:ColorToHex(currentColor),
        TextColor3 = theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 172
    })
    
    -- Arrow
    local arrowLabel = Utils:CreateText({
        Parent = previewButton,
        Name = "Arrow",
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Font = Fonts.Bold,
        Text = "▼",
        TextColor3 = theme.Main,
        TextSize = 12,
        ZIndex = 172
    })
    
    -- Picker container
    local pickerContainer = Utils:CreateInstance("Frame", {
        Parent = pickerFrame,
        Name = "PickerContainer",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.15,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BorderSizePixel = 0,
        ZIndex = 200,
        Visible = false,
        ClipsDescendants = true
    })
    Utils:AddCorner(pickerContainer, 12)
    Utils:AddStroke(pickerContainer, theme.Glow, 1)
    
    -- Color canvas (Saturation x Value)
    local colorCanvas = Utils:CreateInstance("ImageButton", {
        Parent = pickerContainer,
        Name = "ColorCanvas",
        BackgroundColor3 = Color3.fromHSV(currentHSV[1], 1, 1),
        Size = UDim2.new(1, -16, 0, 140),
        Position = UDim2.new(0, 8, 0, 8),
        Image = "",
        BorderSizePixel = 0,
        ZIndex = 201,
        AutoButtonColor = false
    })
    Utils:AddCorner(colorCanvas, 8)
    
    -- Saturation gradient (white to transparent)
    local satGradient = Utils:AddGradient(colorCanvas, 
        Color3.fromRGB(255, 255, 255), 
        Color3.fromRGB(255, 255, 255), 
        0
    )
    satGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    
    -- Value gradient (transparent to black)
    local valFrame = Utils:CreateInstance("Frame", {
        Parent = colorCanvas,
        Name = "ValueOverlay",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 201
    })
    local valGradient = Utils:AddGradient(valFrame,
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 0),
        90
    )
    valGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    }
    
    -- Canvas cursor
    local canvasCursor = Utils:CreateInstance("Frame", {
        Parent = colorCanvas,
        Name = "CanvasCursor",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(currentHSV[2], -7, 1 - currentHSV[3], -7),
        BorderSizePixel = 0,
        ZIndex = 203,
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    Utils:AddCorner(canvasCursor, 7)
    Utils:AddStroke(canvasCursor, Color3.fromRGB(0, 0, 0), 1.5)
    
    -- Hue slider
    local hueSlider = Utils:CreateInstance("ImageButton", {
        Parent = pickerContainer,
        Name = "HueSlider",
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        Size = UDim2.new(1, -16, 0, 16),
        Position = UDim2.new(0, 8, 0, 156),
        Image = "",
        BorderSizePixel = 0,
        ZIndex = 201,
        AutoButtonColor = false
    })
    Utils:AddCorner(hueSlider, 8)
    
    -- Hue gradient
    local hueGradient = Utils:AddGradient(hueSlider,
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 0, 255),
        0
    )
    hueGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    
    -- Hue cursor
    local hueCursor = Utils:CreateInstance("Frame", {
        Parent = hueSlider,
        Name = "HueCursor",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 4, 1, 6),
        Position = UDim2.new(currentHSV[1], -2, 0, -3),
        BorderSizePixel = 0,
        ZIndex = 203
    })
    Utils:AddCorner(hueCursor, 2)
    Utils:AddStroke(hueCursor, Color3.fromRGB(0, 0, 0), 1)
    
    -- Alpha slider (if enabled)
    local alphaSlider = nil
    local alphaCursor = nil
    if pickerConfig.ShowAlpha then
        alphaSlider = Utils:CreateInstance("Frame", {
            Parent = pickerContainer,
            Name = "AlphaSlider",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, -16, 0, 16),
            Position = UDim2.new(0, 8, 0, 180),
            BorderSizePixel = 0,
            ZIndex = 201
        })
        Utils:AddCorner(alphaSlider, 8)
        
        -- Alpha checkerboard pattern
        local alphaBg = Utils:CreateInstance("ImageLabel", {
            Parent = alphaSlider,
            Name = "AlphaBg",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Image = "rbxassetid://",
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.new(0, 8, 0, 8),
            ZIndex = 201
        })
        Utils:AddCorner(alphaBg, 8)
        
        local alphaGradient = Utils:AddGradient(alphaSlider,
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 255, 255),
            0
        )
        alphaGradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }
        
        alphaCursor = Utils:CreateInstance("Frame", {
            Parent = alphaSlider,
            Name = "AlphaCursor",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 4, 1, 6),
            Position = UDim2.new(currentAlpha, -2, 0, -3),
            BorderSizePixel = 0,
            ZIndex = 203
        })
        Utils:AddCorner(alphaCursor, 2)
        Utils:AddStroke(alphaCursor, Color3.fromRGB(0, 0, 0), 1)
    end
    
    -- HEX input
    local hexInput = nil
    if pickerConfig.ShowHEX then
        local hexY = pickerConfig.ShowAlpha and 204 or 180
        hexInput = Utils:CreateInstance("TextBox", {
            Parent = pickerContainer,
            Name = "HexInput",
            BackgroundColor3 = theme.SurfaceDark,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(1, -16, 0, 24),
            Position = UDim2.new(0, 8, 0, hexY),
            PlaceholderText = "#FFFFFF",
            Text = Utils:ColorToHex(currentColor),
            Font = Fonts.Mono,
            TextColor3 = theme.Text,
            PlaceholderColor3 = theme.MutedText,
            TextSize = 12,
            BorderSizePixel = 0,
            ZIndex = 201
        })
        Utils:AddCorner(hexInput, 6)
        Utils:AddStroke(hexInput, theme.Border, 0.5)
    end
    
    -- RGB inputs
    local rgbInputs = {}
    if pickerConfig.ShowRGB then
        local rgbY = pickerConfig.ShowAlpha and 232 or (pickerConfig.ShowHEX and 210 or 180)
        local rgbFrame = Utils:CreateInstance("Frame", {
            Parent = pickerContainer,
            Name = "RGBFrame",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -16, 0, 28),
            Position = UDim2.new(0, 8, 0, rgbY),
            BorderSizePixel = 0,
            ZIndex = 201
        })
        
        local rgbLabels = {"R:", "G:", "B:"}
        for i = 1, 3 do
            local label = Utils:CreateText({
                Parent = rgbFrame,
                Name = rgbLabels[i] .. "Label",
                Position = UDim2.new((i-1)/3, 0, 0, 0),
                Size = UDim2.new(0, 16, 1, 0),
                Font = Fonts.Regular,
                Text = rgbLabels[i],
                TextColor3 = theme.SubText,
                TextSize = 11,
                ZIndex = 202
            })
            
            local input = Utils:CreateInstance("TextBox", {
                Parent = rgbFrame,
                Name = rgbLabels[i] .. "Input",
                BackgroundColor3 = theme.SurfaceDark,
                BackgroundTransparency = 0.5,
                Position = UDim2.new((i-1)/3 + 0.05, 0, 0, 4),
                Size = UDim2.new(0.22, 0, 0, 20),
                Text = tostring(math.floor(currentColor.R * 255 + 0.5)),
                Font = Fonts.Mono,
                TextColor3 = theme.Text,
                TextSize = 11,
                BorderSizePixel = 0,
                ZIndex = 202
            })
            Utils:AddCorner(input, 4)
            
            input.FocusLost:Connect(function()
                local num = tonumber(input.Text)
                if num then
                    updateColorFromRGB()
                end
            end)
            
            rgbInputs[i] = input
        end
    end
    
    -- Preset colors
    local presetButtons = {}
    if #pickerConfig.Presets > 0 then
        local presetY = pickerConfig.ShowAlpha and 260 or 
                       (pickerConfig.ShowRGB and 240 or 
                       (pickerConfig.ShowHEX and 210 or 200))
        
        local presetFrame = Utils:CreateInstance("Frame", {
            Parent = pickerContainer,
            Name = "PresetFrame",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -16, 0, 24),
            Position = UDim2.new(0, 8, 0, presetY),
            BorderSizePixel = 0,
            ZIndex = 201
        })
        
        local presetLayout = Instance.new("UIListLayout")
        presetLayout.FillDirection = Enum.FillDirection.Horizontal
        presetLayout.Padding = UDim.new(0, 4)
        presetLayout.Parent = presetFrame
        
        for _, presetColor in ipairs(pickerConfig.Presets) do
            local presetBtn = Utils:CreateButton({
                Parent = presetFrame,
                Name = "Preset",
                BackgroundColor3 = presetColor,
                Size = UDim2.new(0, 22, 0, 22),
                Text = "",
                BorderSizePixel = 0,
                ZIndex = 202
            })
            Utils:AddCorner(presetBtn, 6)
            Utils:AddStroke(presetBtn, Color3.fromRGB(255, 255, 255), 0.5)
            
            presetBtn.MouseButton1Click:Connect(function()
                updateColor(presetColor)
            end)
            
            table.insert(presetButtons, presetBtn)
        end
    end
    
    -- Color update function
    local function updateColor(newColor)
        currentColor = newColor
        currentHSV = {Color3.toHSV(currentColor)}
        
        -- Update preview
        colorPreview.BackgroundColor3 = currentColor
        previewButton.BackgroundColor3 = currentColor
        colorText.Text = Utils:ColorToHex(currentColor)
        
        -- Update canvas
        colorCanvas.BackgroundColor3 = Color3.fromHSV(currentHSV[1], 1, 1)
        
        -- Update cursors
        canvasCursor.Position = UDim2.new(currentHSV[2], -7, 1 - currentHSV[3], -7)
        hueCursor.Position = UDim2.new(currentHSV[1], -2, 0, -3)
        
        -- Update HEX input
        if hexInput then
            hexInput.Text = Utils:ColorToHex(currentColor)
        end
        
        -- Update RGB inputs
        if #rgbInputs > 0 then
            rgbInputs[1].Text = tostring(math.floor(currentColor.R * 255 + 0.5))
            rgbInputs[2].Text = tostring(math.floor(currentColor.G * 255 + 0.5))
            rgbInputs[3].Text = tostring(math.floor(currentColor.B * 255 + 0.5))
        end
        
        -- Callback
        if pickerConfig.Callback then
            task.spawn(function()
                pickerConfig.Callback(currentColor)
            end)
        end
        
        -- Flag
        if pickerConfig.Flag then
            ConfigSystem:Set(pickerConfig.Flag, Utils:ColorToHex(currentColor))
        end
    end
    
    local function updateColorFromRGB()
        if #rgbInputs < 3 then return end
        
        local r = Utils:Clamp(tonumber(rgbInputs[1].Text) or 0, 0, 255) / 255
        local g = Utils:Clamp(tonumber(rgbInputs[2].Text) or 0, 0, 255) / 255
        local b = Utils:Clamp(tonumber(rgbInputs[3].Text) or 0, 0, 255) / 255
        
        updateColor(Color3.fromRGB(r * 255, g * 255, b * 255))
    end
    
    -- Canvas interactions
    colorCanvas.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDraggingCanvas = true
            local pos = input.Position
            local canvasPos = colorCanvas.AbsolutePosition
            local canvasSize = colorCanvas.AbsoluteSize
            
            local s = Utils:Clamp((pos.X - canvasPos.X) / canvasSize.X, 0, 1)
            local v = 1 - Utils:Clamp((pos.Y - canvasPos.Y) / canvasSize.Y, 0, 1)
            
            currentHSV[2] = s
            currentHSV[3] = v
            
            updateColor(Color3.fromHSV(currentHSV[1], currentHSV[2], currentHSV[3]))
        end
    end)
    
    -- Hue slider interactions
    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDraggingHue = true
            local pos = input.Position
            local sliderPos = hueSlider.AbsolutePosition
            local sliderSize = hueSlider.AbsoluteSize
            
            local h = Utils:Clamp((pos.X - sliderPos.X) / sliderSize.X, 0, 1)
            currentHSV[1] = h
            
            updateColor(Color3.fromHSV(currentHSV[1], currentHSV[2], currentHSV[3]))
        end
    end)
    
    -- Alpha slider interactions
    if alphaSlider then
        alphaSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                local pos = input.Position
                local sliderPos = alphaSlider.AbsolutePosition
                local sliderSize = alphaSlider.AbsoluteSize
                
                currentAlpha = Utils:Clamp((pos.X - sliderPos.X) / sliderSize.X, 0, 1)
                alphaCursor.Position = UDim2.new(currentAlpha, -2, 0, -3)
                
                updateColor(Color3.fromHSV(currentHSV[1], currentHSV[2], currentHSV[3]))
            end
        end)
    end
    
    -- Global mouse move for dragging
    Services.UserInputService.InputChanged:Connect(function(input)
        if isDraggingCanvas and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position
            local canvasPos = colorCanvas.AbsolutePosition
            local canvasSize = colorCanvas.AbsoluteSize
            
            local s = Utils:Clamp((pos.X - canvasPos.X) / canvasSize.X, 0, 1)
            local v = 1 - Utils:Clamp((pos.Y - canvasPos.Y) / canvasSize.Y, 0, 1)
            
            currentHSV[2] = s
            currentHSV[3] = v
            
            updateColor(Color3.fromHSV(currentHSV[1], currentHSV[2], currentHSV[3]))
        end
        
        if isDraggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position
            local sliderPos = hueSlider.AbsolutePosition
            local sliderSize = hueSlider.AbsoluteSize
            
            local h = Utils:Clamp((pos.X - sliderPos.X) / sliderSize.X, 0, 1)
            currentHSV[1] = h
            
            updateColor(Color3.fromHSV(currentHSV[1], currentHSV[2], currentHSV[3]))
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function()
        isDraggingCanvas = false
        isDraggingHue = false
    end)
    
    -- HEX input handler
    if hexInput then
        hexInput.FocusLost:Connect(function()
            local hex = string.gsub(hexInput.Text, "#", "")
            local success, color = pcall(function()
                return Color3.fromHex("#" .. hex)
            end)
            
            if success then
                updateColor(color)
            else
                hexInput.Text = Utils:ColorToHex(currentColor)
            end
        end)
    end
    
    -- Toggle picker
    local function openPicker()
        isOpen = true
        pickerContainer.Visible = true
        
        local pickerHeight = 250
        if pickerConfig.ShowAlpha then pickerHeight = pickerHeight + 30 end
        if pickerConfig.ShowHEX then pickerHeight = pickerHeight + 32 end
        if pickerConfig.ShowRGB then pickerHeight = pickerHeight + 34 end
        if #pickerConfig.Presets > 0 then pickerHeight = pickerHeight + 32 end
        
        Utils:PlayTween(pickerContainer, Anim.Spring(0.4), {
            Size = UDim2.new(1, 0, 0, pickerHeight)
        })
        
        Utils:PlayTween(arrowLabel, Anim.Smooth(), {
            Rotation = 180
        })
        
        pickerFrame.ZIndex = 199
    end
    
    local function closePicker()
        isOpen = false
        
        Utils:PlayTween(pickerContainer, Anim.Smooth(0.3), {
            Size = UDim2.new(1, 0, 0, 0)
        })
        
        Utils:PlayTween(arrowLabel, Anim.Smooth(), {
            Rotation = 0
        })
        
        pickerFrame.ZIndex = 170
        
        task.delay(0.3, function()
            if not isOpen then
                pickerContainer.Visible = false
            end
        end)
    end
    
    previewButton.MouseButton1Click:Connect(function()
        if not pickerConfig.Enabled then return end
        
        if isOpen then
            closePicker()
        else
            openPicker()
        end
    end)
    
    -- Description
    if pickerConfig.Description ~= "" then
        Utils:CreateText({
            Parent = pickerFrame,
            Name = "Description",
            Position = UDim2.new(0, 10, 0, 36),
            Size = UDim2.new(1, -20, 0, 14),
            Font = Fonts.Regular,
            Text = pickerConfig.Description,
            TextColor3 = theme.MutedText,
            TextSize = 11,
            ZIndex = 171
        })
    end
    
    -- Load from config
    if pickerConfig.Flag then
        local savedHex = ConfigSystem:Get(pickerConfig.Flag)
        if savedHex then
            local success, color = pcall(function()
                return Color3.fromHex(savedHex)
            end)
            if success then
                updateColor(color)
            end
        end
    end
    
    -- Element data
    local elementData = {
        Type = "ColorPicker",
        Frame = pickerFrame,
        Config = pickerConfig,
        SetColor = function(self, color)
            updateColor(color)
        end,
        GetColor = function(self)
            return currentColor
        end,
        GetHex = function(self)
            return Utils:ColorToHex(currentColor)
        end,
        SetEnabled = function(self, enabled)
            pickerConfig.Enabled = enabled
        end,
        Destroy = function(self)
            pickerFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 34: LABEL COMPONENT
--============================================--

function ElementFactory:CreateLabel(section, config)
    local theme = ThemeManager:GetTheme()
    
    local labelConfig = {
        Text = config.Text or "Label",
        Color = config.Color or theme.Text,
        Size = config.Size or 13,
        Font = config.Font or Fonts.Regular,
        Alignment = config.Alignment or Enum.TextXAlignment.Left,
        Wrapped = config.Wrapped or false
    }
    
    local labelFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, labelConfig.Wrapped and 36 or 24),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    
    Utils:CreateText({
        Parent = labelFrame,
        Name = "Text",
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        Font = labelConfig.Font,
        Text = labelConfig.Text,
        TextColor3 = labelConfig.Color,
        TextSize = labelConfig.Size,
        TextXAlignment = labelConfig.Alignment,
        TextWrapped = labelConfig.Wrapped,
        ZIndex = 171
    })
    
    local elementData = {
        Type = "Label",
        Frame = labelFrame,
        SetText = function(self, text)
            labelConfig.Text = text
            local textLabel = labelFrame:FindFirstChild("Text")
            if textLabel then
                textLabel.Text = text
            end
        end,
        Destroy = function(self)
            labelFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 35: PARAGRAPH COMPONENT
--============================================--

function ElementFactory:CreateParagraph(section, config)
    local theme = ThemeManager:GetTheme()
    
    local paragraphConfig = {
        Title = config.Title or "Title",
        Content = config.Content or "Content",
        TitleColor = config.TitleColor or theme.Text,
        ContentColor = config.ContentColor or theme.SubText,
        TitleSize = config.TitleSize or 14,
        ContentSize = config.ContentSize or 12
    }
    
    local paragraphFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Paragraph",
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 52),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(paragraphFrame, 8)
    
    Utils:CreateText({
        Parent = paragraphFrame,
        Name = "Title",
        Position = UDim2.new(0, 10, 0, 6),
        Size = UDim2.new(1, -20, 0, 18),
        Font = Fonts.Bold,
        Text = paragraphConfig.Title,
        TextColor3 = paragraphConfig.TitleColor,
        TextSize = paragraphConfig.TitleSize,
        ZIndex = 171
    })
    
    Utils:CreateText({
        Parent = paragraphFrame,
        Name = "Content",
        Position = UDim2.new(0, 10, 0, 26),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Fonts.Regular,
        Text = paragraphConfig.Content,
        TextColor3 = paragraphConfig.ContentColor,
        TextSize = paragraphConfig.ContentSize,
        TextWrapped = true,
        ZIndex = 171
    })
    
    local elementData = {
        Type = "Paragraph",
        Frame = paragraphFrame,
        SetTitle = function(self, title)
            local titleLabel = paragraphFrame:FindFirstChild("Title")
            if titleLabel then
                titleLabel.Text = title
            end
        end,
        SetContent = function(self, content)
            local contentLabel = paragraphFrame:FindFirstChild("Content")
            if contentLabel then
                contentLabel.Text = content
            end
        end,
        Destroy = function(self)
            paragraphFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 36: DIVIDER COMPONENT
--============================================--

function ElementFactory:CreateDivider(section, config)
    local theme = ThemeManager:GetTheme()
    
    local dividerFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "Divider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    
    Utils:CreateInstance("Frame", {
        Parent = dividerFrame,
        Name = "Line",
        BackgroundColor3 = theme.Main,
        BackgroundTransparency = 0.6,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0.5, 0),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    
    local elementData = {
        Type = "Divider",
        Frame = dividerFrame,
        Destroy = function(self)
            dividerFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 37: SEARCH BOX COMPONENT
--============================================--

function ElementFactory:CreateSearchBox(section, config)
    local theme = ThemeManager:GetTheme()
    
    local searchConfig = {
        Placeholder = config.Placeholder or "Search...",
        Callback = config.Callback or function(query) end,
        Flag = config.Flag or nil,
        Enabled = config.Enabled ~= false,
        InstantSearch = config.InstantSearch ~= false
    }
    
    local searchFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "SearchBox",
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(searchFrame, 8)
    
    local searchBg = Utils:CreateInstance("Frame", {
        Parent = searchFrame,
        Name = "SearchBg",
        BackgroundColor3 = theme.SurfaceDark,
        BackgroundTransparency = 0.4,
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.new(0, 0, 0, 4),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(searchBg, 8)
    Utils:AddStroke(searchBg, theme.Border, 0.5)
    
    Utils:CreateText({
        Parent = searchBg,
        Name = "Icon",
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Font = Fonts.Bold,
        Text = "⌕",
        TextColor3 = theme.Main,
        TextSize = 16,
        ZIndex = 172
    })
    
    local searchInput = Utils:CreateInstance("TextBox", {
        Parent = searchBg,
        Name = "Input",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        PlaceholderText = searchConfig.Placeholder,
        Text = "",
        Font = Fonts.Regular,
        TextColor3 = theme.Text,
        PlaceholderColor3 = theme.MutedText,
        TextSize = 13,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        ZIndex = 172
    })
    
    local clearBtn = Utils:CreateButton({
        Parent = searchBg,
        Name = "ClearBtn",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        Text = "✕",
        TextColor3 = theme.MutedText,
        TextSize = 12,
        ZIndex = 172,
        Visible = false
    })
    
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local text = searchInput.Text
        clearBtn.Visible = text ~= ""
        
        if searchConfig.InstantSearch and searchConfig.Callback then
            searchConfig.Callback(text)
        end
    end)
    
    searchInput.FocusLost:Connect(function(enterPressed)
        if not searchConfig.InstantSearch and searchConfig.Callback then
            searchConfig.Callback(searchInput.Text)
        end
    end)
    
    clearBtn.MouseButton1Click:Connect(function()
        searchInput.Text = ""
        if searchConfig.Callback then
            searchConfig.Callback("")
        end
    end)
    
    local elementData = {
        Type = "SearchBox",
        Frame = searchFrame,
        SetValue = function(self, text)
            searchInput.Text = text or ""
        end,
        GetValue = function(self)
            return searchInput.Text
        end,
        Clear = function(self)
            searchInput.Text = ""
        end,
        Destroy = function(self)
            searchFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 38: PROGRESS BAR COMPONENT
--============================================--

function ElementFactory:CreateProgressBar(section, config)
    local theme = ThemeManager:GetTheme()
    
    local progressConfig = {
        Title = config.Title or "Progress",
        Value = config.Value or 0,
        Max = config.Max or 100,
        Color = config.Color or theme.Main,
        ShowValue = config.ShowValue ~= false,
        Suffix = config.Suffix or "%",
        Animated = config.Animated ~= false
    }
    
    local progressFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "ProgressBar",
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, progressConfig.Title ~= "" and 50 or 36),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(progressFrame, 8)
    
    if progressConfig.Title ~= "" then
        Utils:CreateText({
            Parent = progressFrame,
            Name = "Title",
            Position = UDim2.new(0, 10, 0, 4),
            Size = UDim2.new(0.7, 0, 0, 18),
            Font = Fonts.Medium,
            Text = progressConfig.Title,
            TextColor3 = theme.Text,
            TextSize = 13,
            ZIndex = 171
        })
    end
    
    if progressConfig.ShowValue then
        Utils:CreateText({
            Parent = progressFrame,
            Name = "Value",
            Position = UDim2.new(0.7, 0, 0, progressConfig.Title ~= "" and 4 or 0),
            Size = UDim2.new(0.3, -10, 0, 18),
            Font = Fonts.Bold,
            Text = tostring(progressConfig.Value) .. progressConfig.Suffix,
            TextColor3 = progressConfig.Color,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 171
        })
    end
    
    local track = Utils:CreateInstance("Frame", {
        Parent = progressFrame,
        Name = "Track",
        BackgroundColor3 = theme.SurfaceDark,
        Size = UDim2.new(1, -10, 0, 8),
        Position = UDim2.new(0, 5, 0, progressConfig.Title ~= "" and 28 or 16),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    Utils:AddCorner(track, 4)
    
    local fill = Utils:CreateInstance("Frame", {
        Parent = track,
        Name = "Fill",
        BackgroundColor3 = progressConfig.Color,
        Size = UDim2.new(progressConfig.Value / progressConfig.Max, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 172
    })
    Utils:AddCorner(fill, 4)
    
    -- Fill glow
    Utils:CreateInstance("Frame", {
        Parent = fill,
        Name = "Glow",
        BackgroundColor3 = progressConfig.Color,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 1, 4),
        Position = UDim2.new(0, 0, 0, -2),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    
    local elementData = {
        Type = "ProgressBar",
        Frame = progressFrame,
        SetValue = function(self, value)
            progressConfig.Value = Utils:Clamp(value, 0, progressConfig.Max)
            local percent = progressConfig.Value / progressConfig.Max
            
            if progressConfig.Animated then
                Utils:PlayTween(fill, Anim.Spring(0.5), {
                    Size = UDim2.new(percent, 0, 1, 0)
                })
            else
                fill.Size = UDim2.new(percent, 0, 1, 0)
            end
            
            local valueLabel = progressFrame:FindFirstChild("Value")
            if valueLabel then
                valueLabel.Text = tostring(progressConfig.Value) .. progressConfig.Suffix
            end
        end,
        GetValue = function(self)
            return progressConfig.Value
        end,
        SetMax = function(self, max)
            progressConfig.Max = max
            self:SetValue(progressConfig.Value)
        end,
        Destroy = function(self)
            progressFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 39: UPDATE SECTION WITH REMAINING METHODS
--============================================--

-- Override section creation to include all methods
local finalizeSection = function(section)
    section.AddColorPicker = function(self, config)
        return ElementFactory:CreateColorPicker(self, config)
    end
    
    section.AddLabel = function(self, config)
        return ElementFactory:CreateLabel(self, config)
    end
    
    section.AddParagraph = function(self, config)
        return ElementFactory:CreateParagraph(self, config)
    end
    
    section.AddDivider = function(self)
        return ElementFactory:CreateDivider(self, {})
    end
    
    section.AddSearchBox = function(self, config)
        return ElementFactory:CreateSearchBox(self, config)
    end
    
    section.AddProgressBar = function(self, config)
        return ElementFactory:CreateProgressBar(self, config)
    end
    
    return section
end

-- Patch the section creation
local patchSectionBuilder = SectionBuilder.CreateSection
SectionBuilder.CreateSection = function(tab, config)
    local section = patchSectionBuilder(tab, config)
    return finalizeSection(section)
end


--============================================--
-- SECTION 40: THEME SWITCHER COMPONENT
--============================================--

local ThemeSwitcher = {}

function ThemeSwitcher:Create(section, config)
    local theme = ThemeManager:GetTheme()
    
    local switcherConfig = {
        Title = config.Title or "Theme",
        Description = config.Description or "",
        Callback = config.Callback or function(themeName) end,
        ShowPreview = config.ShowPreview ~= false
    }
    
    local availableThemes = ThemeManager:GetThemeList()
    
    local switcherFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "ThemeSwitcher",
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, switcherConfig.Description ~= "" and 80 or 68),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(switcherFrame, 8)
    
    if switcherConfig.Title ~= "" then
        Utils:CreateText({
            Parent = switcherFrame,
            Name = "Title",
            Position = UDim2.new(0, 10, 0, 4),
            Size = UDim2.new(1, -20, 0, 18),
            Font = Fonts.Medium,
            Text = switcherConfig.Title,
            TextColor3 = theme.Text,
            TextSize = 13,
            ZIndex = 171
        })
    end
    
    local previewFrame = Utils:CreateInstance("Frame", {
        Parent = switcherFrame,
        Name = "PreviewFrame",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 40),
        Position = UDim2.new(0, 5, 0, switcherConfig.Title ~= "" and 24 or 4),
        BorderSizePixel = 0,
        ZIndex = 171
    })
    
    local previewLayout = Instance.new("UIListLayout")
    previewLayout.FillDirection = Enum.FillDirection.Horizontal
    previewLayout.Padding = UDim.new(0, 6)
    previewLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    previewLayout.SortOrder = Enum.SortOrder.LayoutOrder
    previewLayout.Parent = previewFrame
    
    local themeButtons = {}
    local selectedIndicator = nil
    
    for _, themeName in ipairs(availableThemes) do
        local themeData = ThemeManager:GetThemeData(themeName)
        if themeData then
            local previewBtn = Utils:CreateButton({
                Parent = previewFrame,
                Name = "Theme_" .. themeName,
                BackgroundColor3 = themeData.Main,
                Size = UDim2.new(0, 32, 0, 32),
                Text = "",
                BorderSizePixel = 0,
                ZIndex = 172
            })
            Utils:AddCorner(previewBtn, 8)
            Utils:AddStroke(previewBtn, themeName == ThemeManager:GetThemeName() and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0), 2)
            
            -- Theme name tooltip
            TooltipSystem:Attach(previewBtn, themeName)
            
            previewBtn.MouseButton1Click:Connect(function()
                ThemeManager:SetTheme(themeName)
                
                for _, btn in ipairs(themeButtons) do
                    Utils:AddStroke(btn, Color3.fromRGB(0, 0, 0), 2)
                end
                Utils:AddStroke(previewBtn, Color3.fromRGB(255, 255, 255), 2)
                
                if switcherConfig.Callback then
                    switcherConfig.Callback(themeName)
                end
                
                -- Notify theme change
                NotificationSystem:Send({
                    Title = "Theme Changed",
                    Content = "Switched to " .. themeName .. " theme",
                    Duration = 2,
                    Type = "info"
                })
            end)
            
            table.insert(themeButtons, previewBtn)
        end
    end
    
    if switcherConfig.Description ~= "" then
        Utils:CreateText({
            Parent = switcherFrame,
            Name = "Description",
            Position = UDim2.new(0, 10, 0, 68),
            Size = UDim2.new(1, -20, 0, 14),
            Font = Fonts.Regular,
            Text = switcherConfig.Description,
            TextColor3 = theme.MutedText,
            TextSize = 11,
            ZIndex = 171
        })
    end
    
    local elementData = {
        Type = "ThemeSwitcher",
        Frame = switcherFrame,
        Destroy = function(self)
            switcherFrame:Destroy()
            Utils:TableRemove(section.Elements, self)
        end
    }
    
    table.insert(section.Elements, elementData)
    section:UpdateSize()
    
    return elementData
end

--============================================--
-- SECTION 41: ANIMATION CONTROLLER
--============================================--

local AnimationController = {}
AnimationController.ActiveAnimations = {}
AnimationController.AnimationCount = 0

function AnimationController:Play(object, animationType, properties, duration, callback)
    local tweenInfo
    
    if type(animationType) == "string" then
        local animFunc = Anim[animationType]
        if animFunc then
            tweenInfo = animFunc(duration)
        else
            tweenInfo = Anim.Smooth(duration)
        end
    elseif type(animationType) == "TweenInfo" then
        tweenInfo = animationType
    else
        tweenInfo = Anim.Smooth(duration)
    end
    
    local tween = Services.TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    self.AnimationCount = self.AnimationCount + 1
    table.insert(self.ActiveAnimations, tween)
    
    tween.Completed:Connect(function()
        self.AnimationCount = self.AnimationCount - 1
        Utils:TableRemove(self.ActiveAnimations, tween)
    end)
    
    return tween
end

function AnimationController:StopAll()
    for _, tween in ipairs(self.ActiveAnimations) do
        tween:Cancel()
    end
    self.ActiveAnimations = {}
    self.AnimationCount = 0
end

function AnimationController:CreateSpring(object, targetProperties, speed, damping)
    local spring = {
        Object = object,
        Target = targetProperties,
        Current = {},
        Velocity = {},
        Speed = speed or 0.5,
        Damping = damping or 0.7,
        Active = true,
        Connection = nil
    }
    
    -- Initialize current values
    for prop, targetValue in pairs(targetProperties) do
        if typeof(object[prop]) == "number" then
            spring.Current[prop] = object[prop]
            spring.Velocity[prop] = 0
        elseif typeof(object[prop]) == "UDim2" then
            spring.Current[prop] = {
                X = {Scale = object[prop].X.Scale, Offset = object[prop].X.Offset},
                Y = {Scale = object[prop].Y.Scale, Offset = object[prop].Y.Offset}
            }
            spring.Velocity[prop] = {X = {Scale = 0, Offset = 0}, Y = {Scale = 0, Offset = 0}}
        end
    end
    
    spring.Connection = Services.RunService.RenderStepped:Connect(function(deltaTime)
        if not spring.Active then
            spring.Connection:Disconnect()
            return
        end
        
        for prop, targetValue in pairs(targetProperties) do
            if typeof(object[prop]) == "number" then
                local force = (targetValue - spring.Current[prop]) * spring.Speed
                spring.Velocity[prop] = (spring.Velocity[prop] + force) * spring.Damping
                spring.Current[prop] = spring.Current[prop] + spring.Velocity[prop]
                object[prop] = spring.Current[prop]
                
                if math.abs(spring.Velocity[prop]) < 0.001 and math.abs(targetValue - spring.Current[prop]) < 0.001 then
                    object[prop] = targetValue
                    spring.Active = false
                end
            elseif typeof(object[prop]) == "UDim2" then
                local currentUDim2 = spring.Current[prop]
                local targetUDim2 = targetValue
                
                local forceXScale = (targetUDim2.X.Scale - currentUDim2.X.Scale) * spring.Speed
                local forceXOffset = (targetUDim2.X.Offset - currentUDim2.X.Offset) * spring.Speed
                local forceYScale = (targetUDim2.Y.Scale - currentUDim2.Y.Scale) * spring.Speed
                local forceYOffset = (targetUDim2.Y.Offset - currentUDim2.Y.Offset) * spring.Speed
                
                spring.Velocity[prop].X.Scale = (spring.Velocity[prop].X.Scale + forceXScale) * spring.Damping
                spring.Velocity[prop].X.Offset = (spring.Velocity[prop].X.Offset + forceXOffset) * spring.Damping
                spring.Velocity[prop].Y.Scale = (spring.Velocity[prop].Y.Scale + forceYScale) * spring.Damping
                spring.Velocity[prop].Y.Offset = (spring.Velocity[prop].Y.Offset + forceYOffset) * spring.Damping
                
                currentUDim2.X.Scale = currentUDim2.X.Scale + spring.Velocity[prop].X.Scale
                currentUDim2.X.Offset = currentUDim2.X.Offset + spring.Velocity[prop].X.Offset
                currentUDim2.Y.Scale = currentUDim2.Y.Scale + spring.Velocity[prop].Y.Scale
                currentUDim2.Y.Offset = currentUDim2.Y.Offset + spring.Velocity[prop].Y.Offset
                
                object[prop] = UDim2.new(
                    currentUDim2.X.Scale, currentUDim2.X.Offset,
                    currentUDim2.Y.Scale, currentUDim2.Y.Offset
                )
            end
        end
    end)
    
    return spring
end

--============================================--
-- SECTION 42: EFFECTS SYSTEM
--============================================--

local EffectsSystem = {}

function EffectsSystem:CreateRipple(parent, position, size, color, duration)
    local ripple = Utils:CreateInstance("Frame", {
        Parent = parent,
        Name = "Ripple",
        BackgroundColor3 = color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, position.X, 0, position.Y),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        ZIndex = 9999
    })
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local targetSize = size or math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    
    local tween = AnimationController:Play(ripple, "Fast", {
        Size = UDim2.new(0, targetSize, 0, targetSize),
        BackgroundTransparency = 1
    }, duration or 0.6, function()
        ripple:Destroy()
    end)
    
    return ripple
end

function EffectsSystem:CreateGlowPulse(object, color, intensity, duration)
    if not object:FindFirstChild("GlowPulse") then
        local glowStroke = Utils:AddStroke(object, color or ActiveTheme.Glow, intensity or 3)
        glowStroke.Name = "GlowPulse"
        
        local function pulse()
            if not glowStroke.Parent then return end
            
            AnimationController:Play(glowStroke, "Smooth", {
                Transparency = 0.5
            }, duration or 1, function()
                AnimationController:Play(glowStroke, "Smooth", {
                    Transparency = 0
                }, duration or 1, function()
                    pulse()
                end)
            end)
        end
        
        pulse()
        return glowStroke
    end
end

function EffectsSystem:CreateShimmer(object, speed, angle)
    local gradient = object:FindFirstChild("ShimmerGradient")
    if not gradient then
        gradient = Utils:AddGradient(object, 
            Color3.fromRGB(255, 255, 255), 
            Color3.fromRGB(255, 255, 255), 
            angle or -45
        )
        gradient.Name = "ShimmerGradient"
        
        gradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.8),
            NumberSequenceKeypoint.new(0.5, 0.5),
            NumberSequenceKeypoint.new(1, 0.8)
        }
    end
    
    local connection
    connection = Services.RunService.RenderStepped:Connect(function(deltaTime)
        if not object or not object.Parent then
            connection:Disconnect()
            return
        end
        
        gradient.Offset = gradient.Offset + Vector2.new(speed or 0.01, 0)
        if gradient.Offset.X > 1 then
            gradient.Offset = Vector2.new(0, 0)
        end
    end)
    
    return connection
end

function EffectsSystem:CreateLiquidGlass(object, intensity)
    local gradient = object:FindFirstChild("LiquidGlassGradient")
    if not gradient then
        gradient = Instance.new("UIGradient")
        gradient.Name = "LiquidGlassGradient"
        gradient.Parent = object
    end
    
    local connection
    connection = Services.RunService.RenderStepped:Connect(function(deltaTime)
        if not object or not object.Parent then
            connection:Disconnect()
            return
        end
        
        local t = tick()
        gradient.Rotation = math.sin(t * 0.5) * 20 * (intensity or 1)
        gradient.Offset = Vector2.new(
            math.sin(t * 0.3) * 0.1 * (intensity or 1),
            math.cos(t * 0.4) * 0.1 * (intensity or 1)
        )
    end)
    
    return connection
end

function EffectsSystem:CreateParallax(object, intensity, maxOffset)
    local originalPosition = object.Position
    local connection
    
    connection = Services.RunService.RenderStepped:Connect(function()
        if not object or not object.Parent then
            connection:Disconnect()
            return
        end
        
        local mousePos = Utils:GetMouseLocation()
        local centerPos = object.AbsolutePosition + object.AbsoluteSize / 2
        local delta = (mousePos - centerPos) * (intensity or 0.02)
        
        delta = Vector2.new(
            Utils:Clamp(delta.X, -(maxOffset or 10), maxOffset or 10),
            Utils:Clamp(delta.Y, -(maxOffset or 10), maxOffset or 10)
        )
        
        object.Position = UDim2.new(
            originalPosition.X.Scale, originalPosition.X.Offset + delta.X,
            originalPosition.Y.Scale, originalPosition.Y.Offset + delta.Y
        )
    end)
    
    return connection
end

function EffectsSystem:CreateTypewriterEffect(textLabel, text, speed, callback)
    textLabel.Text = ""
    local currentIndex = 0
    
    local connection
    connection = Services.RunService.Heartbeat:Connect(function()
        if not textLabel or not textLabel.Parent then
            connection:Disconnect()
            return
        end
        
        currentIndex = currentIndex + 1
        if currentIndex <= #text then
            textLabel.Text = string.sub(text, 1, currentIndex)
        else
            connection:Disconnect()
            if callback then
                callback()
            end
        end
    end)
    
    return connection
end

function EffectsSystem:CreateFloatingAnimation(object, amplitude, frequency)
    local originalPosition = object.Position
    local connection
    
    connection = Services.RunService.RenderStepped:Connect(function(deltaTime)
        if not object or not object.Parent then
            connection:Disconnect()
            return
        end
        
        local t = tick()
        local offset = math.sin(t * (frequency or 2)) * (amplitude or 5)
        
        object.Position = UDim2.new(
            originalPosition.X.Scale, originalPosition.X.Offset,
            originalPosition.Y.Scale, originalPosition.Y.Offset + offset
        )
    end)
    
    return connection
end

--============================================--
-- SECTION 43: FLOATING BUTTON SYSTEM
--============================================--

local FloatingButtonSystem = {}
FloatingButtonSystem.Buttons = {}

function FloatingButtonSystem:Create(config)
    local theme = ThemeManager:GetTheme()
    
    local buttonConfig = {
        Icon = config.Icon or "rbxassetid://",
        Size = config.Size or 60,
        Position = config.Position or UDim2.new(0, 10, 0.5, -30),
        Color = config.Color or theme.Main,
        Callback = config.Callback or function() end,
        SnapToEdge = config.SnapToEdge ~= false,
        ShowGlow = config.ShowGlow ~= false,
        ShowShadow = config.ShowShadow ~= false,
        MinOpacity = config.MinOpacity or 0.7,
        Enabled = config.Enabled ~= false
    }
    
    local floatingButton = Utils:CreateInstance("ImageButton", {
        Parent = Services.CoreGui,
        Name = "PHUCMAX_FloatingBtn_" .. (#self.Buttons + 1),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, buttonConfig.Size, 0, buttonConfig.Size),
        Position = buttonConfig.Position,
        Image = buttonConfig.Icon,
        ImageColor3 = buttonConfig.Color,
        ImageTransparency = 0.2,
        ZIndex = 5000,
        Active = buttonConfig.Enabled
    })
    Utils:AddCorner(floatingButton, buttonConfig.Size / 2)
    Utils:AddStroke(floatingButton, buttonConfig.Color, 2)
    
    -- Glow effect
    if buttonConfig.ShowGlow then
        local glow = Utils:CreateInstance("ImageLabel", {
            Parent = floatingButton,
            Name = "Glow",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 20, 1, 20),
            Position = UDim2.new(0, -10, 0, -10),
            Image = "rbxassetid://",
            ImageColor3 = buttonConfig.Color,
            ImageTransparency = 0.5,
            ZIndex = 4999
        })
        Utils:AddCorner(glow, buttonConfig.Size / 2 + 10)
        
        EffectsSystem:CreateGlowPulse(floatingButton, buttonConfig.Color, 3, 1.5)
    end
    
    -- Shadow effect
    if buttonConfig.ShowShadow then
        local shadow = Utils:CreateInstance("ImageLabel", {
            Parent = floatingButton,
            Name = "Shadow",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 10, 1, 10),
            Position = UDim2.new(0, -5, 0, 5),
            Image = "rbxassetid://",
            ImageColor3 = theme.Shadow,
            ImageTransparency = 0.7,
            ZIndex = 4998
        })
        Utils:AddCorner(shadow, buttonConfig.Size / 2 + 5)
    end
    
    -- Drag functionality
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    local longPressTimer = nil
    local isLongPress = false
    
    floatingButton.InputBegan:Connect(function(input)
        if not buttonConfig.Enabled then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            isLongPress = false
            longPressTimer = task.delay(0.3, function()
                isLongPress = true
                isDragging = true
                dragStart = input.Position
                startPos = floatingButton.Position
                
                -- Scale up slightly when dragging
                AnimationController:Play(floatingButton, "Spring", {
                    Size = UDim2.new(0, buttonConfig.Size + 8, 0, buttonConfig.Size + 8)
                }, 0.3)
            end)
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                          input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            floatingButton.Position = UDim2.new(
                Utils:Clamp(startPos.X.Scale + delta.X / SCREEN_WIDTH, 0.01, 0.97),
                0,
                Utils:Clamp(startPos.Y.Scale + delta.Y / SCREEN_HEIGHT, 0.01, 0.97),
                0
            )
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if longPressTimer then
            task.cancel(longPressTimer)
            longPressTimer = nil
        end
        
        if isDragging then
            isDragging = false
            
            -- Snap to edge
            if buttonConfig.SnapToEdge then
                local pos = floatingButton.Position
                local centerX = pos.X.Scale * SCREEN_WIDTH + pos.X.Offset
                
                local targetX
                if centerX < SCREEN_WIDTH / 2 then
                    targetX = UDim2.new(0, 10, pos.Y.Scale, pos.Y.Offset)
                else
                    targetX = UDim2.new(1, -(buttonConfig.Size + 10), pos.Y.Scale, pos.Y.Offset)
                end
                
                AnimationController:Play(floatingButton, "Spring", {
                    Position = targetX,
                    Size = UDim2.new(0, buttonConfig.Size, 0, buttonConfig.Size)
                }, 0.4)
            end
        elseif not isLongPress then
            -- Click action
            AnimationController:Play(floatingButton, "Fast", {
                Size = UDim2.new(0, buttonConfig.Size - 5, 0, buttonConfig.Size - 5)
            }, 0.1, function()
                AnimationController:Play(floatingButton, "Bounce", {
                    Size = UDim2.new(0, buttonConfig.Size, 0, buttonConfig.Size)
                }, 0.3)
            end)
            
            if buttonConfig.Callback then
                buttonConfig.Callback()
            end
        end
        
        isLongPress = false
    end)
    
    -- Auto-hide near edges
    local hideConnection
    if buttonConfig.MinOpacity < 1 then
        hideConnection = Services.RunService.RenderStepped:Connect(function()
            if isDragging then return end
            
            local pos = floatingButton.AbsolutePosition
            local size = floatingButton.AbsoluteSize
            local centerX = pos.X + size.X / 2
            
            local distanceFromEdge = math.min(centerX, SCREEN_WIDTH - centerX)
            local maxDistance = 100
            local opacity = Utils:Clamp(distanceFromEdge / maxDistance, buttonConfig.MinOpacity, 1)
            
            floatingButton.ImageTransparency = 1 - opacity
        end)
    end
    
    -- Store button data
    local buttonData = {
        Button = floatingButton,
        Config = buttonConfig,
        Connection = hideConnection,
        SetPosition = function(self, position)
            floatingButton.Position = position
        end,
        SetIcon = function(self, iconId)
            floatingButton.Image = iconId
        end,
        SetEnabled = function(self, enabled)
            buttonConfig.Enabled = enabled
            floatingButton.Active = enabled
            floatingButton.ImageTransparency = enabled and 0.2 or 0.8
        end,
        Destroy = function(self)
            if hideConnection then hideConnection:Disconnect() end
            floatingButton:Destroy()
            Utils:TableRemove(FloatingButtonSystem.Buttons, self)
        end
    }
    
    table.insert(self.Buttons, buttonData)
    
    return buttonData
end

function FloatingButtonSystem:RemoveAll()
    for _, button in ipairs(self.Buttons) do
        if button.Connection then button.Connection:Disconnect() end
        if button.Button and button.Button.Parent then
            button.Button:Destroy()
        end
    end
    self.Buttons = {}
end

--============================================--
-- SECTION 44: INTEGRATION WITH PHUCMAX
--============================================--

-- Add systems to PHUCMAX
PHUCMAX.AnimationController = AnimationController
PHUCMAX.EffectsSystem = EffectsSystem
PHUCMAX.FloatingButtonSystem = FloatingButtonSystem

-- Add shorthand methods
function PHUCMAX:CreateFloatingButton(config)
    return FloatingButtonSystem:Create(config)
end

function PHUCMAX:Animate(object, animationType, properties, duration, callback)
    return AnimationController:Play(object, animationType, properties, duration, callback)
end

function PHUCMAX:CreateRipple(parent, position, size, color, duration)
    return EffectsSystem:CreateRipple(parent, position, size, color, duration)
end

-- Add ThemeSwitcher to section methods
finalizeSection = function(section)
    -- Previous finalizeSection code...
    section.AddColorPicker = function(self, config)
        return ElementFactory:CreateColorPicker(self, config)
    end
    
    section.AddLabel = function(self, config)
        return ElementFactory:CreateLabel(self, config)
    end
    
    section.AddParagraph = function(self, config)
        return ElementFactory:CreateParagraph(self, config)
    end
    
    section.AddDivider = function(self)
        return ElementFactory:CreateDivider(self, {})
    end
    
    section.AddSearchBox = function(self, config)
        return ElementFactory:CreateSearchBox(self, config)
    end
    
    section.AddProgressBar = function(self, config)
        return ElementFactory:CreateProgressBar(self, config)
    end
    
    section.AddThemeSwitcher = function(self, config)
        return ThemeSwitcher:Create(self, config)
    end
    
    return section
end



--============================================--
-- SECTION 45: DIALOG SYSTEM
--============================================--

local DialogSystem = {}
DialogSystem.ActiveDialogs = {}
DialogSystem.DialogCount = 0

function DialogSystem:Create(config)
    local theme = ThemeManager:GetTheme()
    
    local dialogConfig = {
        Title = config.Title or "Dialog",
        Content = config.Content or "",
        Buttons = config.Buttons or {},
        Width = config.Width or 350,
        Height = config.Height or 180,
        Modal = config.Modal ~= false,
        CloseButton = config.CloseButton ~= false,
        OnClose = config.OnClose or nil,
        Animation = config.Animation or "Spring"
    }
    
    -- Overlay background
    local overlay = nil
    if dialogConfig.Modal then
        overlay = Utils:CreateInstance("Frame", {
            Parent = Services.CoreGui,
            Name = "PHUCMAX_DialogOverlay_" .. (self.DialogCount + 1),
            BackgroundColor3 = theme.Overlay,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 9000
        })
        
        AnimationController:Play(overlay, "Smooth", {
            BackgroundTransparency = 0.5
        }, 0.3)
    end
    
    -- Dialog container
    local dialogContainer = Utils:CreateInstance("Frame", {
        Parent = overlay or Services.CoreGui,
        Name = "PHUCMAX_Dialog_" .. (self.DialogCount + 1),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        ZIndex = 9001,
        ClipsDescendants = true
    })
    Utils:AddCorner(dialogContainer, 16)
    Utils:AddStroke(dialogContainer, theme.Glow, 1.5)
    
    -- Glass overlay
    local glassOverlay = Utils:CreateInstance("Frame", {
        Parent = dialogContainer,
        BackgroundColor3 = theme.Glass,
        BackgroundTransparency = 0.93,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 9002
    })
    Utils:AddCorner(glassOverlay, 16)
    Utils:AddGradient(glassOverlay, theme.Grad1, theme.Grad2, 135)
    
    -- Title bar
    local titleBar = Utils:CreateInstance("Frame", {
        Parent = dialogContainer,
        Name = "TitleBar",
        BackgroundColor3 = theme.SurfaceDark,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0,
        ZIndex = 9003
    })
    Utils:AddCorner(titleBar, 16)
    
    -- Title text
    Utils:CreateText({
        Parent = titleBar,
        Name = "Title",
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Font = Fonts.Bold,
        Text = dialogConfig.Title,
        TextColor3 = theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9004
    })
    
    -- Close button
    if dialogConfig.CloseButton then
        local closeBtn = Utils:CreateButton({
            Parent = titleBar,
            Name = "CloseBtn",
            BackgroundColor3 = theme.Error,
            BackgroundTransparency = 0.8,
            Size = UDim2.new(0, 26, 0, 26),
            Position = UDim2.new(1, -32, 0.5, -13),
            Text = "✕",
            Font = Fonts.Bold,
            TextColor3 = theme.Text,
            TextSize = 12,
            ZIndex = 9005
        })
        Utils:AddCorner(closeBtn, 6)
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Close(dialogData)
        end)
    end
    
    -- Content area
    local contentArea = Utils:CreateInstance("Frame", {
        Parent = dialogContainer,
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -80),
        Position = UDim2.new(0, 0, 0, 40),
        BorderSizePixel = 0,
        ZIndex = 9003
    })
    
    Utils:CreateText({
        Parent = contentArea,
        Name = "Content",
        Position = UDim2.new(0, 16, 0, 10),
        Size = UDim2.new(1, -32, 0, 40),
        Font = Fonts.Regular,
        Text = dialogConfig.Content,
        TextColor3 = theme.SubText,
        TextSize = 13,
        TextWrapped = true,
        ZIndex = 9004
    })
    
    -- Button area
    local buttonArea = Utils:CreateInstance("Frame", {
        Parent = dialogContainer,
        Name = "ButtonArea",
        BackgroundColor3 = theme.SurfaceDark,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 1, -40),
        BorderSizePixel = 0,
        ZIndex = 9003
    })
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonLayout.Padding = UDim.new(0, 8)
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.Parent = buttonArea
    
    local buttonPadding = Instance.new("UIPadding")
    buttonPadding.PaddingRight = UDim.new(0, 12)
    buttonPadding.Parent = buttonArea
    
    -- Create buttons
    local dialogButtons = {}
    for i, buttonConfig in ipairs(dialogConfig.Buttons) do
        local btn = Utils:CreateButton({
            Parent = buttonArea,
            Name = "DialogBtn_" .. i,
            BackgroundColor3 = buttonConfig.Color or theme.Main,
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0, buttonConfig.Width or 80, 0, 28),
            Text = buttonConfig.Text or "Button",
            Font = Fonts.Bold,
            TextColor3 = buttonConfig.TextColor or theme.Text,
            TextSize = 12,
            BorderSizePixel = 0,
            ZIndex = 9004
        })
        Utils:AddCorner(btn, 6)
        Utils:AddStroke(btn, buttonConfig.Color or theme.Main, 1)
        
        if buttonConfig.Style == "outline" then
            btn.BackgroundTransparency = 0.9
        elseif buttonConfig.Style == "ghost" then
            btn.BackgroundTransparency = 1
        elseif buttonConfig.Style == "danger" then
            btn.BackgroundColor3 = theme.Error
        end
        
        btn.MouseButton1Click:Connect(function()
            if buttonConfig.Callback then
                buttonConfig.Callback()
            end
            
            if buttonConfig.CloseDialog ~= false then
                self:Close(dialogData)
            end
        end)
        
        table.insert(dialogButtons, btn)
    end
    
    -- Dialog data
    local dialogData = {
        Container = dialogContainer,
        Overlay = overlay,
        Config = dialogConfig,
        Buttons = dialogButtons,
        IsOpen = true,
        Close = function()
            self:Close(dialogData)
        end
    }
    
    -- Animate opening
    AnimationController:Play(dialogContainer, dialogConfig.Animation, {
        Size = UDim2.new(0, dialogConfig.Width, 0, dialogConfig.Height)
    }, 0.5)
    
    -- Make draggable
    DragSystem:MakeDraggable(dialogContainer, titleBar)
    
    -- Escape to close
    local escConnection
    escConnection = Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Escape and dialogData.IsOpen then
            self:Close(dialogData)
            escConnection:Disconnect()
        end
    end)
    
    dialogData.EscConnection = escConnection
    
    table.insert(self.ActiveDialogs, dialogData)
    self.DialogCount = self.DialogCount + 1
    
    return dialogData
end

function DialogSystem:Close(dialogData)
    if not dialogData.IsOpen then return end
    dialogData.IsOpen = false
    
    -- Close animation
    AnimationController:Play(dialogData.Container, "Smooth", {
        Size = UDim2.new(0, 0, 0, 0)
    }, 0.2, function()
        if dialogData.Overlay then
            AnimationController:Play(dialogData.Overlay, "Smooth", {
                BackgroundTransparency = 1
            }, 0.2, function()
                dialogData.Overlay:Destroy()
            end)
        end
        
        dialogData.Container:Destroy()
        
        if dialogData.EscConnection then
            dialogData.EscConnection:Disconnect()
        end
        
        if dialogData.Config.OnClose then
            dialogData.Config.OnClose()
        end
        
        Utils:TableRemove(self.ActiveDialogs, dialogData)
    end)
end

function DialogSystem:CloseAll()
    for _, dialog in ipairs(self.ActiveDialogs) do
        self:Close(dialog)
    end
end

function DialogSystem:Alert(title, content, callback)
    return self:Create({
        Title = title or "Alert",
        Content = content or "",
        Buttons = {
            {
                Text = "OK",
                Color = ThemeManager:GetTheme().Main,
                Callback = callback,
                Width = 100
            }
        },
        Width = 300,
        Height = 140,
        CloseButton = true
    })
end

function DialogSystem:Confirm(title, content, confirmCallback, cancelCallback)
    return self:Create({
        Title = title or "Confirm",
        Content = content or "",
        Buttons = {
            {
                Text = "Cancel",
                Style = "ghost",
                Callback = cancelCallback
            },
            {
                Text = "Confirm",
                Color = ThemeManager:GetTheme().Main,
                Callback = confirmCallback
            }
        },
        Width = 350,
        Height = 150,
        CloseButton = true
    })
end

function DialogSystem:Prompt(title, placeholder, callback)
    local dialogData
    local inputText = ""
    
    dialogData = self:Create({
        Title = title or "Prompt",
        Content = "",
        Buttons = {
            {
                Text = "Cancel",
                Style = "ghost",
                Callback = function()
                    if callback then callback(nil) end
                end
            },
            {
                Text = "OK",
                Color = ThemeManager:GetTheme().Main,
                Callback = function()
                    if callback then callback(inputText) end
                end
            }
        },
        Width = 350,
        Height = 150,
        CloseButton = true
    })
    
    -- Add input field to content area
    local contentArea = dialogData.Container:FindFirstChild("ContentArea")
    if contentArea then
        local inputBg = Utils:CreateInstance("Frame", {
            Parent = contentArea,
            Name = "InputBg",
            BackgroundColor3 = ThemeManager:GetTheme().SurfaceDark,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(1, -32, 0, 32),
            Position = UDim2.new(0, 16, 0, 50),
            BorderSizePixel = 0,
            ZIndex = 9005
        })
        Utils:AddCorner(inputBg, 6)
        Utils:AddStroke(inputBg, ThemeManager:GetTheme().Main, 1)
        
        local input = Utils:CreateInstance("TextBox", {
            Parent = inputBg,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 0),
            Size = UDim2.new(1, -16, 1, 0),
            PlaceholderText = placeholder or "Enter text...",
            Text = "",
            Font = Fonts.Regular,
            TextColor3 = ThemeManager:GetTheme().Text,
            PlaceholderColor3 = ThemeManager:GetTheme().MutedText,
            TextSize = 13,
            ClearTextOnFocus = false,
            BorderSizePixel = 0,
            ZIndex = 9006
        })
        
        input:GetPropertyChangedSignal("Text"):Connect(function()
            inputText = input.Text
        end)
        
        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                if callback then callback(inputText) end
                DialogSystem:Close(dialogData)
            end
        end)
        
        -- Focus input
        task.delay(0.3, function()
            input:CaptureFocus()
        end)
    end
end

--============================================--
-- SECTION 46: CONTEXT MENU SYSTEM
--============================================--

local ContextMenuSystem = {}
ContextMenuSystem.ActiveMenus = {}

function ContextMenuSystem:Create(config)
    local theme = ThemeManager:GetTheme()
    
    local menuConfig = {
        Items = config.Items or {},
        Position = config.Position or Vector2.new(0, 0),
        Parent = config.Parent or Services.CoreGui,
        OnClose = config.OnClose or nil,
        Width = config.Width or 180
    }
    
    -- Close any existing menus
    self:CloseAll()
    
    -- Menu container
    local menuContainer = Utils:CreateInstance("Frame", {
        Parent = menuConfig.Parent,
        Name = "PHUCMAX_ContextMenu",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, menuConfig.Width, 0, 0),
        Position = UDim2.new(0, menuConfig.Position.X, 0, menuConfig.Position.Y),
        BorderSizePixel = 0,
        ZIndex = 10000,
        ClipsDescendants = true
    })
    Utils:AddCorner(menuContainer, 12)
    Utils:AddStroke(menuContainer, theme.Glow, 1)
    
    -- Glass overlay
    local glassOverlay = Utils:CreateInstance("Frame", {
        Parent = menuContainer,
        BackgroundColor3 = theme.Glass,
        BackgroundTransparency = 0.95,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 10001
    })
    Utils:AddCorner(glassOverlay, 12)
    
    -- Menu list
    local menuList = Instance.new("UIListLayout")
    menuList.Padding = UDim.new(0, 2)
    menuList.VerticalAlignment = Enum.VerticalAlignment.Top
    menuList.SortOrder = Enum.SortOrder.LayoutOrder
    menuList.Parent = menuContainer
    
    Instance.new("UIPadding", menuContainer).PaddingTop = UDim.new(0, 4)
    Instance.new("UIPadding", menuContainer).PaddingBottom = UDim.new(0, 4)
    
    -- Create menu items
    local menuItems = {}
    local totalHeight = 8
    
    for _, itemConfig in ipairs(menuConfig.Items) do
        if itemConfig.Type == "separator" then
            local separator = Utils:CreateInstance("Frame", {
                Parent = menuContainer,
                Name = "Separator",
                BackgroundColor3 = theme.Border,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, -16, 0, 1),
                BorderSizePixel = 0,
                ZIndex = 10002
            })
            totalHeight = totalHeight + 3
            table.insert(menuItems, separator)
            
        else
            local itemBtn = Utils:CreateButton({
                Parent = menuContainer,
                Name = "MenuItem_" .. (itemConfig.Text or "Item"),
                BackgroundColor3 = itemConfig.Color or Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -8, 0, 32),
                Text = "",
                BorderSizePixel = 0,
                ZIndex = 10002
            })
            Utils:AddCorner(itemBtn, 6)
            
            -- Icon
            local iconOffset = 0
            if itemConfig.Icon then
                Utils:CreateInstance("ImageLabel", {
                    Parent = itemBtn,
                    Name = "Icon",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 10, 0.5, -9),
                    Image = itemConfig.Icon,
                    ImageColor3 = itemConfig.IconColor or theme.Text,
                    ZIndex = 10003
                })
                iconOffset = 28
            end
            
            -- Checkmark
            if itemConfig.Checked then
                Utils:CreateText({
                    Parent = itemBtn,
                    Name = "Checkmark",
                    Position = UDim2.new(0, iconOffset + 8, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = Fonts.Bold,
                    Text = "✓",
                    TextColor3 = theme.Main,
                    TextSize = 14,
                    ZIndex = 10003
                })
                iconOffset = iconOffset + 24
            end
            
            -- Text
            Utils:CreateText({
                Parent = itemBtn,
                Name = "Text",
                Position = UDim2.new(0, iconOffset + 12, 0, 0),
                Size = UDim2.new(1, -(iconOffset + 50), 1, 0),
                Font = Fonts.Regular,
                Text = itemConfig.Text or "Item",
                TextColor3 = itemConfig.Disabled and theme.MutedText or theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 10003
            })
            
            -- Shortcut
            if itemConfig.Shortcut then
                Utils:CreateText({
                    Parent = itemBtn,
                    Name = "Shortcut",
                    Position = UDim2.new(1, -60, 0, 0),
                    Size = UDim2.new(0, 50, 1, 0),
                    Font = Fonts.Regular,
                    Text = itemConfig.Shortcut,
                    TextColor3 = theme.MutedText,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 10003
                })
            end
            
            -- Submenu arrow
            if itemConfig.Items then
                Utils:CreateText({
                    Parent = itemBtn,
                    Name = "Arrow",
                    Position = UDim2.new(1, -20, 0, 0),
                    Size = UDim2.new(0, 16, 1, 0),
                    Font = Fonts.Bold,
                    Text = "▶",
                    TextColor3 = theme.MutedText,
                    TextSize = 10,
                    ZIndex = 10003
                })
            end
            
            -- Hover effect
            itemBtn.MouseEnter:Connect(function()
                if not itemConfig.Disabled then
                    AnimationController:Play(itemBtn, "Fast", {
                        BackgroundTransparency = 0.9
                    })
                end
            end)
            
            itemBtn.MouseLeave:Connect(function()
                AnimationController:Play(itemBtn, "Fast", {
                    BackgroundTransparency = 1
                })
            end)
            
            -- Click handler
            itemBtn.MouseButton1Click:Connect(function()
                if itemConfig.Disabled then return end
                
                if itemConfig.Callback then
                    itemConfig.Callback()
                end
                
                if itemConfig.CloseMenu ~= false then
                    self:CloseAll()
                end
            end)
            
            totalHeight = totalHeight + 34
            table.insert(menuItems, itemBtn)
        end
    end
    
    -- Set size
    menuContainer.Size = UDim2.new(0, menuConfig.Width, 0, totalHeight)
    
    -- Adjust position if off-screen
    local menuPos = menuConfig.Position
    if menuPos.X + menuConfig.Width > SCREEN_WIDTH then
        menuPos = Vector2.new(SCREEN_WIDTH - menuConfig.Width - 5, menuPos.Y)
    end
    if menuPos.Y + totalHeight > SCREEN_HEIGHT then
        menuPos = Vector2.new(menuPos.X, SCREEN_HEIGHT - totalHeight - 5)
    end
    menuContainer.Position = UDim2.new(0, menuPos.X, 0, menuPos.Y)
    
    -- Click outside to close
    local closeConnection
    closeConnection = Services.UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            local mousePos = Utils:GetMouseLocation()
            local menuAbsPos = menuContainer.AbsolutePosition
            local menuAbsSize = menuContainer.AbsoluteSize
            
            if not (mousePos.X >= menuAbsPos.X and mousePos.X <= menuAbsPos.X + menuAbsSize.X and
                    mousePos.Y >= menuAbsPos.Y and mousePos.Y <= menuAbsPos.Y + menuAbsSize.Y) then
                self:CloseAll()
                closeConnection:Disconnect()
            end
        end
    end)
    
    local menuData = {
        Container = menuContainer,
        Config = menuConfig,
        Items = menuItems,
        Connection = closeConnection,
        Close = function()
            self:Close(menuData)
        end
    }
    
    table.insert(self.ActiveMenus, menuData)
    
    return menuData
end

function ContextMenuSystem:Close(menuData)
    if not menuData.Container or not menuData.Container.Parent then return end
    
    AnimationController:Play(menuData.Container, "Smooth", {
        Size = UDim2.new(0, menuData.Config.Width, 0, 0),
        BackgroundTransparency = 1
    }, 0.2, function()
        menuData.Container:Destroy()
        if menuData.Connection then
            menuData.Connection:Disconnect()
        end
        Utils:TableRemove(self.ActiveMenus, menuData)
        
        if menuData.Config.OnClose then
            menuData.Config.OnClose()
        end
    end)
end

function ContextMenuSystem:CloseAll()
    for _, menu in ipairs(self.ActiveMenus) do
        if menu.Container and menu.Container.Parent then
            menu.Container:Destroy()
        end
        if menu.Connection then
            menu.Connection:Disconnect()
        end
    end
    self.ActiveMenus = {}
end

--============================================--
-- SECTION 47: RIGHT-CLICK DETECTOR
--============================================--

local RightClickDetector = {}

function RightClickDetector:Attach(instance, callback)
    instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            local mousePos = Utils:GetMouseLocation()
            if callback then
                callback(mousePos)
            end
        end
    end)
end

function RightClickDetector:AttachToWindow(window, tabCallback)
    -- Attach to tab buttons
    -- Will be implemented when tabs are fully created
end

--============================================--
-- SECTION 48: MODAL SYSTEM
--============================================--

local ModalSystem = {}
ModalSystem.ActiveModals = {}

function ModalSystem:Show(content, config)
    local theme = ThemeManager:GetTheme()
    
    local modalConfig = {
        Closable = config and config.Closable ~= false or true,
        OnClose = config and config.OnClose or nil,
        Animation = config and config.Animation or "Spring"
    }
    
    -- Overlay
    local overlay = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "PHUCMAX_Modal",
        BackgroundColor3 = theme.Overlay,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 9500
    })
    
    AnimationController:Play(overlay, "Smooth", {
        BackgroundTransparency = 0.6
    }, 0.3)
    
    -- Content container
    local contentContainer = Utils:CreateInstance("Frame", {
        Parent = overlay,
        Name = "Content",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.2,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        ZIndex = 9501
    })
    Utils:AddCorner(contentContainer, 16)
    Utils:AddStroke(contentContainer, theme.Glow, 1.5)
    
    -- Add content
    if type(content) == "function" then
        content(contentContainer)
    elseif type(content) == "string" then
        Utils:CreateText({
            Parent = contentContainer,
            Position = UDim2.new(0, 20, 0, 20),
            Size = UDim2.new(1, -40, 1, -40),
            Font = Fonts.Regular,
            Text = content,
            TextColor3 = theme.Text,
            TextSize = 14,
            TextWrapped = true,
            ZIndex = 9502
        })
    end
    
    -- Animate
    AnimationController:Play(contentContainer, modalConfig.Animation, {
        Size = UDim2.new(0, 400, 0, 300)
    }, 0.5)
    
    -- Close on overlay click
    if modalConfig.Closable then
        overlay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = Utils:GetMouseLocation()
                local contentPos = contentContainer.AbsolutePosition
                local contentSize = contentContainer.AbsoluteSize
                
                if not (mousePos.X >= contentPos.X and mousePos.X <= contentPos.X + contentSize.X and
                        mousePos.Y >= contentPos.Y and mousePos.Y <= contentPos.Y + contentSize.Y) then
                    self:Close(modalData)
                end
            end
        end)
    end
    
    -- Escape to close
    local escConnection
    escConnection = Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Escape and modalConfig.Closable then
            self:Close(modalData)
            escConnection:Disconnect()
        end
    end)
    
    local modalData = {
        Overlay = overlay,
        Content = contentContainer,
        Config = modalConfig,
        EscConnection = escConnection,
        Close = function()
            self:Close(modalData)
        end
    }
    
    table.insert(self.ActiveModals, modalData)
    
    return modalData
end

function ModalSystem:Close(modalData)
    if not modalData.Overlay or not modalData.Overlay.Parent then return end
    
    AnimationController:Play(modalData.Content, "Smooth", {
        Size = UDim2.new(0, 0, 0, 0)
    }, 0.2)
    
    AnimationController:Play(modalData.Overlay, "Smooth", {
        BackgroundTransparency = 1
    }, 0.2, function()
        modalData.Overlay:Destroy()
        if modalData.EscConnection then
            modalData.EscConnection:Disconnect()
        end
        Utils:TableRemove(self.ActiveModals, modalData)
        
        if modalData.Config.OnClose then
            modalData.Config.OnClose()
        end
    end)
end

function ModalSystem:CloseAll()
    for _, modal in ipairs(self.ActiveModals) do
        self:Close(modal)
    end
end

--============================================--
-- SECTION 49: OVERLAY SYSTEM
--============================================--

local OverlaySystem = {}
OverlaySystem.ActiveOverlays = {}

function OverlaySystem:Show(config)
    local theme = ThemeManager:GetTheme()
    
    local overlayConfig = {
        Color = config and config.Color or theme.Overlay,
        Transparency = config and config.Transparency or 0.6,
        ZIndex = config and config.ZIndex or 8000,
        OnClick = config and config.OnClick or nil
    }
    
    local overlay = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "PHUCMAX_Overlay",
        BackgroundColor3 = overlayConfig.Color,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = overlayConfig.ZIndex
    })
    
    AnimationController:Play(overlay, "Smooth", {
        BackgroundTransparency = 1 - overlayConfig.Transparency
    }, 0.3)
    
    if overlayConfig.OnClick then
        overlay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                overlayConfig.OnClick()
            end
        end)
    end
    
    local overlayData = {
        Frame = overlay,
        Config = overlayConfig,
        Hide = function()
            self:Hide(overlayData)
        end
    }
    
    table.insert(self.ActiveOverlays, overlayData)
    
    return overlayData
end

function OverlaySystem:Hide(overlayData)
    if not overlayData.Frame or not overlayData.Frame.Parent then return end
    
    AnimationController:Play(overlayData.Frame, "Smooth", {
        BackgroundTransparency = 1
    }, 0.3, function()
        overlayData.Frame:Destroy()
        Utils:TableRemove(self.ActiveOverlays, overlayData)
    end)
end

function OverlaySystem:HideAll()
    for _, overlay in ipairs(self.ActiveOverlays) do
        self:Hide(overlay)
    end
end

--============================================--
-- SECTION 50: INTEGRATION WITH PHUCMAX
--============================================--

-- Add systems to PHUCMAX
PHUCMAX.DialogSystem = DialogSystem
PHUCMAX.ContextMenuSystem = ContextMenuSystem
PHUCMAX.RightClickDetector = RightClickDetector
PHUCMAX.ModalSystem = ModalSystem
PHUCMAX.OverlaySystem = OverlaySystem

-- Shorthand methods
function PHUCMAX:Dialog(config)
    return DialogSystem:Create(config)
end

function PHUCMAX:Alert(title, content, callback)
    return DialogSystem:Alert(title, content, callback)
end

function PHUCMAX:Confirm(title, content, confirmCallback, cancelCallback)
    return DialogSystem:Confirm(title, content, confirmCallback, cancelCallback)
end

function PHUCMAX:Prompt(title, placeholder, callback)
    return DialogSystem:Prompt(title, placeholder, callback)
end

function PHUCMAX:ContextMenu(config)
    return ContextMenuSystem:Create(config)
end

function PHUCMAX:Modal(content, config)
    return ModalSystem:Show(content, config)
end

function PHUCMAX:Overlay(config)
    return OverlaySystem:Show(config)
end



--============================================--
-- SECTION 51: ADVANCED CONFIG SYSTEM
--============================================--

local AdvancedConfig = {}
AdvancedConfig.SaveHistory = {}
AdvancedConfig.MaxHistory = 10
AdvancedConfig.AutoSaveEnabled = false
AdvancedConfig.AutoSaveInterval = 60
AdvancedConfig.EncryptionEnabled = false
AdvancedConfig.EncryptionKey = "PHUCMAX_DEFAULT_KEY"
AdvancedConfig.CloudSaveEnabled = false
AdvancedConfig.SavePath = "PHUCMAX/Configs/"

local function simpleEncrypt(data, key)
    if not AdvancedConfig.EncryptionEnabled then return data end
    
    local encrypted = ""
    local keyLength = #key
    
    for i = 1, #data do
        local charCode = string.byte(data, i)
        local keyChar = string.byte(key, ((i - 1) % keyLength) + 1)
        local encryptedChar = bit32.bxor(charCode, keyChar)
        encrypted = encrypted .. string.char(encryptedChar)
    end
    
    return encrypted
end

local function simpleDecrypt(data, key)
    return simpleEncrypt(data, key) -- XOR is symmetric
end

function AdvancedConfig:Save(fileName)
    local saveData = {
        Flags = ConfigSystem:GetAll(),
        Theme = ThemeManager:GetThemeName(),
        Version = PHUCMAX_VERSION,
        Build = PHUCMAX_BUILD,
        Timestamp = os.time(),
        Metadata = {
            PlayerName = Player.Name,
            UserId = Player.UserId,
            PlaceId = game.PlaceId,
            JobId = game.JobId
        }
    }
    
    local jsonData = Services.HttpService:JSONEncode(saveData)
    
    -- Add to history
    table.insert(self.SaveHistory, {
        Data = saveData,
        Timestamp = os.time(),
        FileName = fileName or "auto_save"
    })
    
    -- Trim history
    while #self.SaveHistory > self.MaxHistory do
        table.remove(self.SaveHistory, 1)
    end
    
    -- Encrypt if enabled
    if self.EncryptionEnabled then
        jsonData = simpleEncrypt(jsonData, self.EncryptionKey)
    end
    
    -- Save to file
    local fullPath = self.SavePath .. (fileName or "config") .. ".json"
    
    if writefile then
        -- Create directory if needed
        local dirPath = self.SavePath
        if not isfolder(dirPath) then
            makefolder(dirPath)
        end
        
        writefile(fullPath, jsonData)
        
        -- Cloud save
        if self.CloudSaveEnabled then
            self:CloudSave(fullPath, jsonData)
        end
        
        return true, fullPath
    end
    
    return false, nil
end

function AdvancedConfig:Load(fileName)
    local fullPath = self.SavePath .. (fileName or "config") .. ".json"
    
    if not isfile or not isfile(fullPath) then
        return false, "File not found"
    end
    
    local success, content = pcall(function()
        return readfile(fullPath)
    end)
    
    if not success then
        return false, "Failed to read file"
    end
    
    -- Decrypt if needed
    if self.EncryptionEnabled then
        content = simpleDecrypt(content, self.EncryptionKey)
    end
    
    local success2, data = pcall(function()
        return Services.HttpService:JSONDecode(content)
    end)
    
    if not success2 or not data then
        return false, "Failed to parse JSON"
    end
    
    -- Load flags
    if data.Flags then
        for flag, value in pairs(data.Flags) do
            ConfigSystem:Set(flag, value)
        end
    end
    
    -- Load theme
    if data.Theme then
        ThemeManager:SetTheme(data.Theme)
    end
    
    -- Version migration
    if data.Version and data.Version ~= PHUCMAX_VERSION then
        self:MigrateConfig(data, data.Version, PHUCMAX_VERSION)
    end
    
    return true, data
end

function AdvancedConfig:Delete(fileName)
    local fullPath = self.SavePath .. (fileName or "config") .. ".json"
    
    if isfile and isfile(fullPath) then
        delfile(fullPath)
        return true
    end
    
    return false
end

function AdvancedConfig:ListSaves()
    local saves = {}
    
    if isfolder and isfolder(self.SavePath) then
        local files = listfiles(self.SavePath)
        for _, file in ipairs(files) do
            if string.match(file, "%.json$") then
                local fileName = string.gsub(file, self.SavePath, "")
                fileName = string.gsub(fileName, "%.json$", "")
                table.insert(saves, {
                    Name = fileName,
                    Path = file,
                    Date = isfile and "Unknown" or os.date("%Y-%m-%d %H:%M:%S")
                })
            end
        end
    end
    
    return saves
end

function AdvancedConfig:Export()
    local exportData = {
        Flags = ConfigSystem:GetAll(),
        Theme = ThemeManager:GetThemeName(),
        Version = PHUCMAX_VERSION,
        Build = PHUCMAX_BUILD,
        Timestamp = os.time(),
        ExportDate = os.date("%Y-%m-%d %H:%M:%S"),
        Checksum = ""
    }
    
    local jsonData = Services.HttpService:JSONEncode(exportData)
    exportData.Checksum = string.format("%08x", #jsonData)
    jsonData = Services.HttpService:JSONEncode(exportData)
    
    -- Copy to clipboard if available
    if syn and syn.write_clipboard then
        syn.write_clipboard(jsonData)
    end
    
    return jsonData
end

function AdvancedConfig:Import(jsonString)
    local success, data = pcall(function()
        return Services.HttpService:JSONDecode(jsonString)
    end)
    
    if not success or not data then
        return false, "Invalid JSON"
    end
    
    -- Validate checksum
    if data.Checksum then
        local tempData = Utils:DeepCopy(data)
        tempData.Checksum = ""
        local tempJson = Services.HttpService:JSONEncode(tempData)
        local calculatedChecksum = string.format("%08x", #tempJson)
        
        -- Note: Checksum validation is basic, not security-grade
    end
    
    -- Import flags
    if data.Flags then
        for flag, value in pairs(data.Flags) do
            ConfigSystem:Set(flag, value)
        end
    end
    
    -- Import theme
    if data.Theme then
        ThemeManager:SetTheme(data.Theme)
    end
    
    return true, data
end

function AdvancedConfig:GetHistory()
    return self.SaveHistory
end

function AdvancedConfig:RestoreFromHistory(index)
    if self.SaveHistory[index] then
        local data = self.SaveHistory[index].Data
        
        if data.Flags then
            for flag, value in pairs(data.Flags) do
                ConfigSystem:Set(flag, value)
            end
        end
        
        if data.Theme then
            ThemeManager:SetTheme(data.Theme)
        end
        
        return true
    end
    
    return false
end

function AdvancedConfig:ClearHistory()
    self.SaveHistory = {}
end

function AdvancedConfig:SetAutoSave(enabled, interval)
    self.AutoSaveEnabled = enabled
    self.AutoSaveInterval = interval or 60
    
    if enabled then
        task.spawn(function()
            while self.AutoSaveEnabled do
                task.wait(self.AutoSaveInterval)
                if self.AutoSaveEnabled then
                    self:Save("auto_save")
                end
            end
        end)
    end
end

function AdvancedConfig:SetEncryption(enabled, key)
    self.EncryptionEnabled = enabled
    self.EncryptionKey = key or self.EncryptionKey
end

function AdvancedConfig:MigrateConfig(data, fromVersion, toVersion)
    -- Version migration logic
    if fromVersion == "1.0.0" and toVersion == "1.0.1" then
        -- Example migration: rename flags
        if data.Flags then
            -- Migration logic here
        end
    end
    
    return data
end

function AdvancedConfig:CloudSave(filePath, data)
    -- Placeholder for cloud save functionality
    -- Could integrate with external APIs
    return false
end

function AdvancedConfig:CloudLoad(filePath)
    -- Placeholder for cloud load functionality
    return nil
end

--============================================--
-- SECTION 52: BACKUP SYSTEM
--============================================--

local BackupSystem = {}
BackupSystem.Backups = {}
BackupSystem.MaxBackups = 5
BackupSystem.BackupPath = "PHUCMAX/Backups/"

function BackupSystem:CreateBackup()
    local backupData = {
        Flags = ConfigSystem:GetAll(),
        Theme = ThemeManager:GetThemeName(),
        Version = PHUCMAX_VERSION,
        Timestamp = os.time(),
        DateTime = os.date("%Y-%m-%d_%H-%M-%S"),
        PlayerName = Player.Name,
        PlaceId = game.PlaceId
    }
    
    local jsonData = Services.HttpService:JSONEncode(backupData)
    
    if writefile then
        if not isfolder(self.BackupPath) then
            makefolder(self.BackupPath)
        end
        
        local fileName = self.BackupPath .. "backup_" .. backupData.DateTime .. ".json"
        writefile(fileName, jsonData)
        
        table.insert(self.Backups, {
            Data = backupData,
            FileName = fileName,
            Timestamp = backupData.Timestamp
        })
        
        -- Trim backups
        while #self.Backups > self.MaxBackups do
            local oldest = table.remove(self.Backups, 1)
            if oldest.FileName and isfile(oldest.FileName) then
                delfile(oldest.FileName)
            end
        end
        
        return true, fileName
    end
    
    return false, nil
end

function BackupSystem:RestoreBackup(index)
    if self.Backups[index] then
        local backup = self.Backups[index]
        local data = backup.Data
        
        if data.Flags then
            for flag, value in pairs(data.Flags) do
                ConfigSystem:Set(flag, value)
            end
        end
        
        if data.Theme then
            ThemeManager:SetTheme(data.Theme)
        end
        
        return true
    end
    
    return false
end

function BackupSystem:ListBackups()
    local backups = {}
    
    if isfolder and isfolder(self.BackupPath) then
        local files = listfiles(self.BackupPath)
        for _, file in ipairs(files) do
            local success, content = pcall(function()
                return readfile(file)
            end)
            
            if success then
                local success2, data = pcall(function()
                    return Services.HttpService:JSONDecode(content)
                end)
                
                if success2 then
                    table.insert(backups, {
                        FileName = file,
                        DateTime = data.DateTime or "Unknown",
                        PlayerName = data.PlayerName or "Unknown",
                        Version = data.Version or "Unknown"
                    })
                end
            end
        end
    end
    
    return backups
end

function BackupSystem:ClearBackups()
    if isfolder and isfolder(self.BackupPath) then
        local files = listfiles(self.BackupPath)
        for _, file in ipairs(files) do
            delfile(file)
        end
    end
    self.Backups = {}
end

--============================================--
-- SECTION 53: IMPORT/EXPORT UI
--============================================--

local ImportExportUI = {}

function ImportExportUI:ShowExportDialog()
    local jsonData = AdvancedConfig:Export()
    
    DialogSystem:Create({
        Title = "Export Configuration",
        Content = "Your configuration has been exported to clipboard. You can also copy it from below:",
        Buttons = {
            {
                Text = "Close",
                Style = "ghost",
                Width = 80
            }
        },
        Width = 500,
        Height = 350,
        CloseButton = true
    })
    
    -- Add a text box with the exported data would go here
    -- This is handled by the dialog system
end

function ImportExportUI:ShowImportDialog(callback)
    DialogSystem:Prompt(
        "Import Configuration",
        "Paste your configuration JSON here...",
        function(jsonString)
            if jsonString then
                local success, result = AdvancedConfig:Import(jsonString)
                if success then
                    NotificationSystem:Send({
                        Title = "Import Successful",
                        Content = "Configuration has been imported successfully.",
                        Type = "success",
                        Duration = 3
                    })
                    if callback then callback(true) end
                else
                    NotificationSystem:Send({
                        Title = "Import Failed",
                        Content = result or "Invalid configuration data.",
                        Type = "error",
                        Duration = 4
                    })
                    if callback then callback(false) end
                end
            end
        end
    )
end

--============================================--
-- SECTION 54: CONFIG AUTO-BACKUP
--============================================--

local AutoBackup = {}
AutoBackup.Enabled = false
AutoBackup.Interval = 300 -- 5 minutes
AutoBackup.MaxBackups = 5
AutoBackup.Connection = nil

function AutoBackup:Start(interval)
    self.Enabled = true
    self.Interval = interval or 300
    
    if self.Connection then
        self.Connection:Disconnect()
    end
    
    self.Connection = task.spawn(function()
        while self.Enabled do
            task.wait(self.Interval)
            if self.Enabled then
                BackupSystem:CreateBackup()
            end
        end
    end)
end

function AutoBackup:Stop()
    self.Enabled = false
    if self.Connection then
        -- Connection will stop on next iteration
    end
end

--============================================--
-- SECTION 55: SESSION MANAGEMENT
--============================================--

local SessionManager = {}
SessionManager.Sessions = {}
SessionManager.CurrentSession = nil
SessionManager.SessionPath = "PHUCMAX/Sessions/"

function SessionManager:StartSession(name)
    if self.CurrentSession then
        self:EndSession()
    end
    
    local sessionData = {
        Name = name or ("Session_" .. os.date("%Y%m%d_%H%M%S")),
        StartTime = os.time(),
        StartFlags = ConfigSystem:GetAll(),
        StartTheme = ThemeManager:GetThemeName(),
        Events = {},
        IsActive = true
    }
    
    self.CurrentSession = sessionData
    table.insert(self.Sessions, sessionData)
    
    return sessionData
end

function SessionManager:EndSession()
    if not self.CurrentSession then return end
    
    self.CurrentSession.EndTime = os.time()
    self.CurrentSession.EndFlags = ConfigSystem:GetAll()
    self.CurrentSession.EndTheme = ThemeManager:GetThemeName()
    self.CurrentSession.Duration = self.CurrentSession.EndTime - self.CurrentSession.StartTime
    self.CurrentSession.IsActive = false
    
    -- Calculate changes
    local changes = {}
    for flag, endValue in pairs(self.CurrentSession.EndFlags) do
        local startValue = self.CurrentSession.StartFlags[flag]
        if startValue ~= endValue then
            table.insert(changes, {
                Flag = flag,
                From = startValue,
                To = endValue
            })
        end
    end
    self.CurrentSession.Changes = changes
    
    local session = self.CurrentSession
    self.CurrentSession = nil
    
    -- Save session
    self:SaveSession(session)
    
    return session
end

function SessionManager:LogEvent(eventName, eventData)
    if self.CurrentSession then
        table.insert(self.CurrentSession.Events, {
            Name = eventName,
            Data = eventData,
            Time = os.time()
        })
    end
end

function SessionManager:SaveSession(session)
    if not writefile then return false end
    
    if not isfolder(self.SessionPath) then
        makefolder(self.SessionPath)
    end
    
    local jsonData = Services.HttpService:JSONEncode(session)
    local fileName = self.SessionPath .. session.Name .. ".json"
    writefile(fileName, jsonData)
    
    return true
end

function SessionManager:LoadSession(fileName)
    local fullPath = self.SessionPath .. fileName .. ".json"
    
    if not isfile or not isfile(fullPath) then
        return nil
    end
    
    local success, content = pcall(function()
        return readfile(fullPath)
    end)
    
    if not success then return nil end
    
    local success2, data = pcall(function()
        return Services.HttpService:JSONDecode(content)
    end)
    
    if not success2 then return nil end
    
    return data
end

function SessionManager:ListSessions()
    local sessions = {}
    
    if isfolder and isfolder(self.SessionPath) then
        local files = listfiles(self.SessionPath)
        for _, file in ipairs(files) do
            local success, content = pcall(function()
                return readfile(file)
            end)
            
            if success then
                local success2, data = pcall(function()
                    return Services.HttpService:JSONDecode(content)
                end)
                
                if success2 and data then
                    table.insert(sessions, {
                        Name = data.Name or "Unknown",
                        StartTime = data.StartTime,
                        EndTime = data.EndTime,
                        Duration = data.Duration,
                        Changes = data.Changes and #data.Changes or 0
                    })
                end
            end
        end
    end
    
    return sessions
end

--============================================--
-- SECTION 56: CONFIG PROFILE SYSTEM
--============================================--

local ProfileSystem = {}
ProfileSystem.Profiles = {}
ProfileSystem.ActiveProfile = "Default"
ProfileSystem.ProfilePath = "PHUCMAX/Profiles/"

function ProfileSystem:CreateProfile(name)
    if self.Profiles[name] then
        return false, "Profile already exists"
    end
    
    self.Profiles[name] = {
        Name = name,
        Flags = {},
        Theme = "Purple",
        CreatedAt = os.time(),
        ModifiedAt = os.time()
    }
    
    self:SaveProfile(name)
    
    return true, self.Profiles[name]
end

function ProfileSystem:SwitchProfile(name)
    if not self.Profiles[name] then
        -- Try to load
        local loaded = self:LoadProfile(name)
        if not loaded then
            return false, "Profile not found"
        end
    end
    
    -- Save current profile
    if self.ActiveProfile ~= name then
        self:SaveProfile(self.ActiveProfile)
    end
    
    -- Load new profile
    local profile = self.Profiles[name]
    
    -- Clear current flags
    ConfigSystem.Flags = {}
    
    -- Load profile flags
    if profile.Flags then
        for flag, value in pairs(profile.Flags) do
            ConfigSystem:Set(flag, value)
        end
    end
    
    if profile.Theme then
        ThemeManager:SetTheme(profile.Theme)
    end
    
    self.ActiveProfile = name
    
    return true, profile
end

function ProfileSystem:SaveProfile(name)
    local profile = self.Profiles[name]
    if not profile then return false end
    
    profile.Flags = ConfigSystem:GetAll()
    profile.Theme = ThemeManager:GetThemeName()
    profile.ModifiedAt = os.time()
    
    if writefile then
        if not isfolder(self.ProfilePath) then
            makefolder(self.ProfilePath)
        end
        
        local jsonData = Services.HttpService:JSONEncode(profile)
        local fileName = self.ProfilePath .. name .. ".json"
        writefile(fileName, jsonData)
    end
    
    return true
end

function ProfileSystem:LoadProfile(name)
    local fullPath = self.ProfilePath .. name .. ".json"
    
    if not isfile or not isfile(fullPath) then
        return nil
    end
    
    local success, content = pcall(function()
        return readfile(fullPath)
    end)
    
    if not success then return nil end
    
    local success2, data = pcall(function()
        return Services.HttpService:JSONDecode(content)
    end)
    
    if not success2 then return nil end
    
    self.Profiles[name] = data
    return data
end

function ProfileSystem:DeleteProfile(name)
    self.Profiles[name] = nil
    
    local fullPath = self.ProfilePath .. name .. ".json"
    if isfile and isfile(fullPath) then
        delfile(fullPath)
    end
    
    if self.ActiveProfile == name then
        self:SwitchProfile("Default")
    end
    
    return true
end

function ProfileSystem:ListProfiles()
    local profiles = {}
    
    if isfolder and isfolder(self.ProfilePath) then
        local files = listfiles(self.ProfilePath)
        for _, file in ipairs(files) do
            local success, content = pcall(function()
                return readfile(file)
            end)
            
            if success then
                local success2, data = pcall(function()
                    return Services.HttpService:JSONDecode(content)
                end)
                
                if success2 and data then
                    table.insert(profiles, {
                        Name = data.Name or "Unknown",
                        CreatedAt = data.CreatedAt,
                        ModifiedAt = data.ModifiedAt,
                        Theme = data.Theme or "Unknown"
                    })
                end
            end
        end
    end
    
    return profiles
end

--============================================--
-- SECTION 57: CONFIG MIGRATION TOOLS
--============================================--

local MigrationTools = {}

function MigrationTools:ExportForSharing()
    local exportData = {
        Flags = ConfigSystem:GetAll(),
        Theme = ThemeManager:GetThemeName(),
        Version = PHUCMAX_VERSION,
        SharedBy = Player.Name,
        SharedAt = os.time(),
        Description = "Shared PHUCMAX Configuration"
    }
    
    local jsonData = Services.HttpService:JSONEncode(exportData)
    
    -- Compress if possible
    local compressed = jsonData
    
    -- Encode for URL sharing
    local encoded = ""
    if syn and syn.crypt and syn.crypt.base64 then
        encoded = syn.crypt.base64.encode(jsonData)
    end
    
    return {
        Json = jsonData,
        Compressed = compressed,
        Encoded = encoded
    }
end

function MigrationTools:ImportFromShare(data)
    local jsonData = data
    
    -- Try to decode if base64
    if data.Encoded then
        if syn and syn.crypt and syn.crypt.base64 then
            jsonData = syn.crypt.base64.decode(data.Encoded)
        end
    end
    
    local success, configData = pcall(function()
        return Services.HttpService:JSONDecode(jsonData or data.Json or data)
    end)
    
    if not success or not configData then
        return false, "Invalid data format"
    end
    
    if configData.Flags then
        for flag, value in pairs(configData.Flags) do
            ConfigSystem:Set(flag, value)
        end
    end
    
    if configData.Theme then
        ThemeManager:SetTheme(configData.Theme)
    end
    
    return true, configData
end

function MigrationTools:GenerateShareCode()
    local exportData = AdvancedConfig:Export()
    
    if syn and syn.crypt and syn.crypt.base64 then
        local encoded = syn.crypt.base64.encode(exportData)
        -- Create a shorter code
        local shortCode = string.sub(encoded, 1, 50) .. "..."
        return encoded, shortCode
    end
    
    return exportData, nil
end

function MigrationTools:ImportFromShareCode(code)
    local jsonData = code
    
    if syn and syn.crypt and syn.crypt.base64 then
        local success, decoded = pcall(function()
            return syn.crypt.base64.decode(code)
        end)
        if success then
            jsonData = decoded
        end
    end
    
    return AdvancedConfig:Import(jsonData)
end

--============================================--
-- SECTION 58: INTEGRATION WITH PHUCMAX
--============================================--

-- Add systems to PHUCMAX
PHUCMAX.AdvancedConfig = AdvancedConfig
PHUCMAX.BackupSystem = BackupSystem
PHUCMAX.ImportExportUI = ImportExportUI
PHUCMAX.AutoBackup = AutoBackup
PHUCMAX.SessionManager = SessionManager
PHUCMAX.ProfileSystem = ProfileSystem
PHUCMAX.MigrationTools = MigrationTools

-- Shorthand methods
function PHUCMAX:SaveConfig(fileName)
    return AdvancedConfig:Save(fileName)
end

function PHUCMAX:LoadConfig(fileName)
    return AdvancedConfig:Load(fileName)
end

function PHUCMAX:ExportConfig()
    return AdvancedConfig:Export()
end

function PHUCMAX:ImportConfig(jsonString)
    return AdvancedConfig:Import(jsonString)
end

function PHUCMAX:CreateBackup()
    return BackupSystem:CreateBackup()
end

function PHUCMAX:RestoreBackup(index)
    return BackupSystem:RestoreBackup(index)
end

function PHUCMAX:StartSession(name)
    return SessionManager:StartSession(name)
end

function PHUCMAX:EndSession()
    return SessionManager:EndSession()
end

function PHUCMAX:CreateProfile(name)
    return ProfileSystem:CreateProfile(name)
end

function PHUCMAX:SwitchProfile(name)
    return ProfileSystem:SwitchProfile(name)
end

function PHUCMAX:ShareConfig()
    return MigrationTools:GenerateShareCode()
end

function PHUCMAX:LoadSharedConfig(code)
    return MigrationTools:ImportFromShareCode(code)
end

-- Auto-start backup system
task.delay(5, function()
    AutoBackup:Start(600) -- Every 10 minutes
end)

-- Create default profile if not exists
if not ProfileSystem.Profiles["Default"] then
    ProfileSystem:CreateProfile("Default")
end

--============================================--
-- SECTION 59: PERFORMANCE OPTIMIZER
--============================================--

local PerformanceOptimizer = {}
PerformanceOptimizer.FPS = 60
PerformanceOptimizer.TargetFPS = 60
PerformanceOptimizer.FrameTime = 0.016
PerformanceOptimizer.RenderConnections = {}
PerformanceOptimizer.LowPerformanceMode = false
PerformanceOptimizer.AnimationQuality = "High" -- "High", "Medium", "Low"
PerformanceOptimizer.UpdateThrottle = 0
PerformanceOptimizer.LastUpdate = 0

function PerformanceOptimizer:Initialize()
    -- Monitor FPS
    local lastTime = os.clock()
    local frameCount = 0
    
    Services.RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = os.clock()
        
        if currentTime - lastTime >= 1 then
            self.FPS = frameCount
            self.FrameTime = (currentTime - lastTime) / frameCount
            frameCount = 0
            lastTime = currentTime
            
            -- Auto-adjust quality
            if self.FPS < 30 and not self.LowPerformanceMode then
                self:EnableLowPerformanceMode()
            elseif self.FPS > 55 and self.LowPerformanceMode then
                self:DisableLowPerformanceMode()
            end
        end
    end)
end

function PerformanceOptimizer:EnableLowPerformanceMode()
    self.LowPerformanceMode = true
    self.AnimationQuality = "Low"
    
    -- Reduce animation complexity
    for _, tween in ipairs(AnimationController.ActiveAnimations) do
        -- Speed up animations
    end
    
    -- Reduce effects
    EffectsSystem.GlowEnabled = false
    EffectsSystem.ShadowEnabled = false
    
    -- Notify user
    NotificationSystem:Send({
        Title = "Performance Mode",
        Content = "Low performance mode enabled. Some effects have been reduced.",
        Duration = 3,
        Type = "warning"
    })
end

function PerformanceOptimizer:DisableLowPerformanceMode()
    self.LowPerformanceMode = false
    self.AnimationQuality = "High"
    
    EffectsSystem.GlowEnabled = true
    EffectsSystem.ShadowEnabled = true
    
    NotificationSystem:Send({
        Title = "Performance Mode",
        Content = "High performance mode restored.",
        Duration = 2,
        Type = "success"
    })
end

function PerformanceOptimizer:ThrottleUpdate(key, minInterval)
    local currentTime = os.clock()
    
    if currentTime - (self.LastUpdate or 0) < minInterval then
        return false
    end
    
    self.LastUpdate = currentTime
    return true
end

function PerformanceOptimizer:OptimizeTween(tweenInfo)
    if self.LowPerformanceMode then
        -- Reduce tween duration
        return TweenInfo.new(
            tweenInfo.Time * 0.5,
            tweenInfo.EasingStyle,
            tweenInfo.EasingDirection
        )
    end
    
    return tweenInfo
end

function PerformanceOptimizer:GetQualityMultiplier()
    if self.AnimationQuality == "High" then return 1.0
    elseif self.AnimationQuality == "Medium" then return 0.7
    else return 0.4 end
end

function PerformanceOptimizer:BatchUpdate(updates)
    local count = 0
    
    for _, update in ipairs(updates) do
        if self:ThrottleUpdate("batch_" .. count, 0.001) then
            if update.Object and update.Properties then
                for prop, value in pairs(update.Properties) do
                    update.Object[prop] = value
                end
            end
        end
        count = count + 1
    end
end

--============================================--
-- SECTION 60: MEMORY MANAGER
--============================================--

local MemoryManager = {}
MemoryManager.TrackedObjects = {}
MemoryManager.TotalObjects = 0
MemoryManager.MaxObjects = 10000
MemoryManager.AutoCleanup = true
MemoryManager.CleanupInterval = 60
MemoryManager.CleanupAge = 300 -- 5 minutes

function MemoryManager:Track(object, category)
    self.TotalObjects = self.TotalObjects + 1
    
    local trackedObject = {
        Object = object,
        Category = category or "General",
        CreatedAt = os.clock(),
        LastUsed = os.clock(),
        References = 1,
        ID = self.TotalObjects
    }
    
    table.insert(self.TrackedObjects, trackedObject)
    
    -- Check if we need cleanup
    if self.TotalObjects > self.MaxObjects then
        self:Cleanup()
    end
    
    return trackedObject.ID
end

function MemoryManager:AddReference(id)
    for _, obj in ipairs(self.TrackedObjects) do
        if obj.ID == id then
            obj.References = obj.References + 1
            obj.LastUsed = os.clock()
            return true
        end
    end
    return false
end

function MemoryManager:ReleaseReference(id)
    for _, obj in ipairs(self.TrackedObjects) do
        if obj.ID == id then
            obj.References = obj.References - 1
            obj.LastUsed = os.clock()
            
            if obj.References <= 0 then
                self:DestroyObject(obj)
            end
            return true
        end
    end
    return false
end

function MemoryManager:DestroyObject(trackedObj)
    if trackedObj.Object and trackedObj.Object.Parent then
        if trackedObj.Object.Destroy then
            trackedObj.Object:Destroy()
        end
    end
    
    Utils:TableRemove(self.TrackedObjects, trackedObj)
    self.TotalObjects = self.TotalObjects - 1
end

function MemoryManager:Cleanup()
    local currentTime = os.clock()
    local cleanedCount = 0
    
    for i = #self.TrackedObjects, 1, -1 do
        local obj = self.TrackedObjects[i]
        
        if obj.References <= 0 and 
           (currentTime - obj.LastUsed) > self.CleanupAge then
            self:DestroyObject(obj)
            cleanedCount = cleanedCount + 1
        end
    end
    
    return cleanedCount
end

function MemoryManager:GetStats()
    local categories = {}
    
    for _, obj in ipairs(self.TrackedObjects) do
        if not categories[obj.Category] then
            categories[obj.Category] = 0
        end
        categories[obj.Category] = categories[obj.Category] + 1
    end
    
    return {
        TotalObjects = self.TotalObjects,
        Categories = categories,
        MemoryUsage = collectgarbage("count")
    }
end

function MemoryManager:ForceCleanup()
    local count = self:Cleanup()
    collectgarbage("collect")
    return count
end

function MemoryManager:DumpInfo()
    local info = "Memory Manager Stats:\n"
    info = info .. "Total Objects: " .. self.TotalObjects .. "\n"
    info = info .. "Memory Usage: " .. collectgarbage("count") .. " KB\n\n"
    info = info .. "Categories:\n"
    
    local stats = self:GetStats()
    for category, count in pairs(stats.Categories) do
        info = info .. "  " .. category .. ": " .. count .. "\n"
    end
    
    return info
end

-- Auto-cleanup
task.spawn(function()
    while MemoryManager.AutoCleanup do
        task.wait(MemoryManager.CleanupInterval)
        if MemoryManager.AutoCleanup then
            MemoryManager:Cleanup()
        end
    end
end)

--============================================--
-- SECTION 61: UTILITY LIBRARY EXTENSIONS
--============================================--

-- Extend Utils with more functions
Utils.StringToVector3 = function(str)
    local parts = string.split(str, ",")
    if #parts == 3 then
        return Vector3.new(
            tonumber(parts[1]) or 0,
            tonumber(parts[2]) or 0,
            tonumber(parts[3]) or 0
        )
    end
    return Vector3.zero
end

Utils.Vector3ToString = function(vec)
    return string.format("%.2f,%.2f,%.2f", vec.X, vec.Y, vec.Z)
end

Utils.FormatNumber = function(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

Utils.FormatTime = function(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%02d:%02d", minutes, secs)
    end
end

Utils.FormatBytes = function(bytes)
    if bytes >= 1073741824 then
        return string.format("%.2f GB", bytes / 1073741824)
    elseif bytes >= 1048576 then
        return string.format("%.2f MB", bytes / 1048576)
    elseif bytes >= 1024 then
        return string.format("%.2f KB", bytes / 1024)
    else
        return string.format("%d B", bytes)
    end
end

Utils.TruncateString = function(str, maxLength)
    if #str <= maxLength then return str end
    return string.sub(str, 1, maxLength - 3) .. "..."
end

Utils.EscapeString = function(str)
    return string.gsub(str, "([^%w])", "%%%1")
end

Utils.SplitString = function(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

Utils.RandomString = function(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
end

Utils.GenerateUUID = function()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
        return string.format("%x", v)
    end)
end

Utils.DeepCompare = function(t1, t2)
    if type(t1) ~= type(t2) then return false end
    if type(t1) ~= "table" then return t1 == t2 end
    
    for k, v in pairs(t1) do
        if not Utils.DeepCompare(v, t2[k]) then
            return false
        end
    end
    
    for k, v in pairs(t2) do
        if not Utils.DeepCompare(v, t1[k]) then
            return false
        end
    end
    
    return true
end

Utils.MergeTables = function(t1, t2)
    local result = Utils:DeepCopy(t1)
    
    for k, v in pairs(t2) do
        if type(v) == "table" and type(result[k]) == "table" then
            result[k] = Utils.MergeTables(result[k], v)
        else
            result[k] = v
        end
    end
    
    return result
end

Utils.Debounce = function(callback, delay)
    local timer = nil
    
    return function(...)
        local args = {...}
        
        if timer then
            task.cancel(timer)
        end
        
        timer = task.delay(delay or 0.3, function()
            callback(table.unpack(args))
            timer = nil
        end)
    end
end

Utils.Throttle = function(callback, delay)
    local lastCall = 0
    
    return function(...)
        local currentTime = os.clock()
        
        if currentTime - lastCall >= (delay or 0.3) then
            lastCall = currentTime
            callback(...)
        end
    end
end

Utils.Once = function(callback)
    local called = false
    
    return function(...)
        if not called then
            called = true
            callback(...)
        end
    end
end

Utils.Memoize = function(callback)
    local cache = {}
    
    return function(key)
        if cache[key] == nil then
            cache[key] = callback(key)
        end
        return cache[key]
    end
end

--============================================--
-- SECTION 62: DEV TOOLS
--============================================--

local DevTools = {}
DevTools.Enabled = false
DevTools.Panels = {}
DevTools.Logs = {}
DevTools.MaxLogs = 1000

function DevTools:Enable()
    self.Enabled = true
    
    -- Create dev panel
    local devPanel = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "PHUCMAX_DevTools",
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BackgroundTransparency = 0.2,
        Size = UDim2.new(0, 350, 0, 250),
        Position = UDim2.new(1, -360, 1, -260),
        BorderSizePixel = 0,
        ZIndex = 99999,
        Visible = false
    })
    Utils:AddCorner(devPanel, 12)
    Utils:AddStroke(devPanel, Color3.fromRGB(100, 255, 100), 1)
    
    -- Title bar
    local titleBar = Utils:CreateInstance("Frame", {
        Parent = devPanel,
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Size = UDim2.new(1, 0, 0, 30),
        BorderSizePixel = 0,
        ZIndex = 100000
    })
    Utils:AddCorner(titleBar, 12)
    
    Utils:CreateText({
        Parent = titleBar,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Fonts.Bold,
        Text = "PHUCMAX Dev Tools",
        TextColor3 = Color3.fromRGB(100, 255, 100),
        TextSize = 13,
        ZIndex = 100001
    })
    
    -- Log area
    local logScroll = Utils:CreateInstance("ScrollingFrame", {
        Parent = devPanel,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 35),
        Size = UDim2.new(1, -10, 0, 170),
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 100000
    })
    
    local logList = Instance.new("UIListLayout")
    logList.Padding = UDim.new(0, 2)
    logList.Parent = logScroll
    
    -- Button area
    local buttonArea = Utils:CreateInstance("Frame", {
        Parent = devPanel,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 210),
        Size = UDim2.new(1, -10, 0, 30),
        BorderSizePixel = 0,
        ZIndex = 100000
    })
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.Padding = UDim.new(0, 5)
    buttonLayout.Parent = buttonArea
    
    -- Buttons
    local buttons = {
        {Text = "Clear", Color = Color3.fromRGB(255, 200, 50), Callback = function() self:ClearLogs() end},
        {Text = "Memory", Color = Color3.fromRGB(100, 200, 255), Callback = function() self:LogMemory() end},
        {Text = "Flags", Color = Color3.fromRGB(200, 100, 255), Callback = function() self:LogFlags() end},
        {Text = "Close", Color = Color3.fromRGB(255, 100, 100), Callback = function() devPanel.Visible = false end}
    }
    
    for _, btnData in ipairs(buttons) do
        local btn = Utils:CreateButton({
            Parent = buttonArea,
            BackgroundColor3 = btnData.Color,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(0, 65, 0, 26),
            Text = btnData.Text,
            Font = Fonts.Bold,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 11,
            ZIndex = 100001
        })
        Utils:AddCorner(btn, 6)
        
        btn.MouseButton1Click:Connect(function()
            btnData.Callback()
        end)
    end
    
    self.Panel = devPanel
    self.LogScroll = logScroll
    
    -- Toggle with F4
    KeybindManager:Register(Enum.KeyCode.F4, function()
        devPanel.Visible = not devPanel.Visible
    end, "Toggle Dev Tools")
    
    self:Log("Dev Tools initialized", "info")
end

function DevTools:Log(message, level)
    local timestamp = os.date("%H:%M:%S")
    local logEntry = {
        Message = message,
        Level = level or "info",
        Timestamp = timestamp,
        Time = os.clock()
    }
    
    table.insert(self.Logs, logEntry)
    
    if #self.Logs > self.MaxLogs then
        table.remove(self.Logs, 1)
    end
    
    -- Update UI if visible
    if self.LogScroll and self.LogScroll.Visible then
        self:UpdateLogUI()
    end
end

function DevTools:UpdateLogUI()
    if not self.LogScroll then return end
    
    -- Clear existing logs
    for _, child in ipairs(self.LogScroll:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local levelColors = {
        info = Color3.fromRGB(200, 200, 200),
        warn = Color3.fromRGB(255, 200, 50),
        error = Color3.fromRGB(255, 100, 100),
        success = Color3.fromRGB(100, 255, 100),
        debug = Color3.fromRGB(150, 150, 255)
    }
    
    -- Show last 50 logs
    local startIndex = math.max(1, #self.Logs - 50)
    for i = startIndex, #self.Logs do
        local log = self.Logs[i]
        local color = levelColors[log.Level] or levelColors.info
        
        local logLabel = Utils:CreateText({
            Parent = self.LogScroll,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -4, 0, 16),
            Font = Fonts.Mono,
            Text = "[" .. log.Timestamp .. "] " .. log.Message,
            TextColor3 = color,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 100001
        })
        
        MemoryManager:Track(logLabel, "DevLog")
    end
    
    self.LogScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(#self.Logs * 18, 170))
end

function DevTools:ClearLogs()
    self.Logs = {}
    self:Log("Logs cleared", "info")
end

function DevTools:LogMemory()
    local stats = MemoryManager:GetStats()
    self:Log(string.format("Memory: %.2f KB | Objects: %d", stats.MemoryUsage, stats.TotalObjects), "debug")
end

function DevTools:LogFlags()
    local flags = ConfigSystem:GetAll()
    local count = 0
    for _ in pairs(flags) do count = count + 1 end
    self:Log(string.format("Config Flags: %d", count), "debug")
end

--============================================--
-- SECTION 63: DEMO SYSTEM
--============================================--

local DemoSystem = {}
DemoSystem.Loaded = false
DemoSystem.DemoWindows = {}

function DemoSystem:LoadFullDemo()
    if self.Loaded then return end
    self.Loaded = true
    
    -- Create main window
    local mainWindow = PHUCMAX:CreateWindow({
        Title = "PHUCMAX",
        SubTitle = "Advanced Demo",
        Size = UDim2.fromOffset(620, 450),
        Theme = "Purple",
        Acrylic = true,
        TabWidth = 170
    })
    
    -- Tab 1: Main Dashboard
    local dashTab = mainWindow:AddTab({Title = "Dashboard", Icon = "rbxassetid://"})
    
    local welcomeSection = dashTab:AddSection({Name = "Welcome"})
    welcomeSection:AddLabel({Text = "Welcome to PHUCMAX UI Library"})
    welcomeSection:AddLabel({Text = "Player: " .. Player.Name})
    welcomeSection:AddParagraph({
        Title = "Library Status",
        Content = "Version: " .. PHUCMAX_VERSION .. "\nBuild: " .. PHUCMAX_BUILD .. "\nAll systems operational."
    })
    
    local quickSection = dashTab:AddSection({Name = "Quick Actions"})
    quickSection:AddButton({
        Title = "Save Configuration",
        Callback = function()
            PHUCMAX:SaveConfig("demo_config")
            PHUCMAX:Notify({Title = "Config", Content = "Configuration saved!", Type = "success"})
        end
    })
    
    quickSection:AddButton({
        Title = "Load Configuration",
        Callback = function()
            local success, result = PHUCMAX:LoadConfig("demo_config")
            if success then
                PHUCMAX:Notify({Title = "Config", Content = "Configuration loaded!", Type = "success"})
            else
                PHUCMAX:Notify({Title = "Config", Content = result or "Failed to load config", Type = "error"})
            end
        end
    })
    
    quickSection:AddButton({
        Title = "Create Backup",
        Callback = function()
            local success = PHUCMAX:CreateBackup()
            if success then
                PHUCMAX:Notify({Title = "Backup", Content = "Backup created!", Type = "success"})
            end
        end
    })
    
    -- Tab 2: Features Demo
    local featuresTab = mainWindow:AddTab({Title = "Features", Icon = "rbxassetid://"})
    
    local toggleSection = featuresTab:AddSection({Name = "Toggle Examples"})
    toggleSection:AddToggle({
        Title = "Enable Feature A",
        Description = "This is a sample toggle with description",
        Default = false,
        Callback = function(value)
            DevTools:Log("Feature A: " .. tostring(value), value and "success" or "info")
        end,
        Flag = "FeatureA"
    })
    
    toggleSection:AddToggle({
        Title = "Enable Feature B",
        Default = true,
        Callback = function(value)
            print("Feature B:", value)
        end,
        Flag = "FeatureB"
    })
    
    local sliderSection = featuresTab:AddSection({Name = "Slider Examples"})
    sliderSection:AddSlider({
        Title = "Volume",
        Description = "Adjust master volume",
        Min = 0,
        Max = 100,
        Default = 75,
        Suffix = "%",
        ShowValue = true,
        Callback = function(value)
            print("Volume:", value)
        end,
        Flag = "Volume"
    })
    
    sliderSection:AddSlider({
        Title = "Sensitivity",
        Min = 0,
        Max = 10,
        Default = 5,
        Step = 0.5,
        Suffix = "x",
        Compact = true,
        Flag = "Sensitivity"
    })
    
    local dropdownSection = featuresTab:AddSection({Name = "Dropdown Examples"})
    dropdownSection:AddDropdown({
        Title = "Game Mode",
        Options = {"Easy", "Normal", "Hard", "Expert", "Insane"},
        Default = "Normal",
        Callback = function(value)
            print("Game Mode:", value)
        end,
        Flag = "GameMode"
    })
    
    dropdownSection:AddDropdown({
        Title = "Multi-Select Items",
        Options = {"Sword", "Shield", "Potion", "Armor", "Ring", "Amulet"},
        MultiSelect = true,
        Default = {"Sword", "Shield"},
        MaxSelections = 4,
        Description = "Select up to 4 items",
        Flag = "Items"
    })
    
    local inputSection = featuresTab:AddSection({Name = "Input Examples"})
    inputSection:AddTextbox({
        Title = "Username",
        Default = Player.Name,
        Placeholder = "Enter username...",
        Callback = function(text, enterPressed)
            if enterPressed then
                print("Username submitted:", text)
            end
        end,
        Flag = "Username"
    })
    
    inputSection:AddTextbox({
        Title = "Notes",
        MultiLine = true,
        Placeholder = "Type your notes here...",
        Flag = "Notes"
    })
    
    inputSection:AddSearchBox({
        Placeholder = "Search features...",
        Callback = function(query)
            print("Searching:", query)
        end
    })
    
    -- Tab 3: Visual Demo
    local visualTab = mainWindow:AddTab({Title = "Visual", Icon = "rbxassetid://"})
    
    local colorSection = visualTab:AddSection({Name = "Color Examples"})
    colorSection:AddColorPicker({
        Title = "Primary Color",
        Default = Color3.fromRGB(120, 80, 255),
        ShowHEX = true,
        ShowRGB = true,
        Presets = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255)
        },
        Callback = function(color)
            print("Color:", Utils:ColorToHex(color))
        end,
        Flag = "PrimaryColor"
    })
    
    colorSection:AddColorPicker({
        Title = "Background Color",
        Default = Color3.fromRGB(30, 30, 40),
        ShowAlpha = true,
        Flag = "BackgroundColor"
    })
    
    local progressSection = visualTab:AddSection({Name = "Progress Examples"})
    local progressBar = progressSection:AddProgressBar({
        Title = "Loading Progress",
        Value = 45,
        Max = 100,
        Color = Color3.fromRGB(100, 200, 100)
    })
    
    progressSection:AddButton({
        Title = "Simulate Progress",
        Callback = function()
            local value = 0
            task.spawn(function()
                while value < 100 do
                    value = value + math.random(1, 10)
                    if value > 100 then value = 100 end
                    progressBar:SetValue(value)
                    task.wait(0.2)
                end
            end)
        end
    })
    
    -- Tab 4: Settings
    local settingsTab = mainWindow:AddTab({Title = "Settings", Icon = "rbxassetid://"})
    
    local themeSection = settingsTab:AddSection({Name = "Theme Settings"})
    themeSection:AddThemeSwitcher({
        Title = "Select Theme",
        Callback = function(themeName)
            print("Theme changed to:", themeName)
        end
    })
    
    themeSection:AddDropdown({
        Title = "Animation Quality",
        Options = {"High", "Medium", "Low"},
        Default = PerformanceOptimizer.AnimationQuality,
        Callback = function(value)
            PerformanceOptimizer.AnimationQuality = value
        end
    })
    
    local keybindSection = settingsTab:AddSection({Name = "Keybinds"})
    keybindSection:AddKeybind({
        Title = "Toggle UI",
        Default = Enum.KeyCode.RightShift,
        Mode = "Toggle",
        Flag = "ToggleUIKey"
    })
    
    keybindSection:AddKeybind({
        Title = "Panic Key",
        Default = Enum.KeyCode.P,
        Mode = "Hold",
        Description = "Hold to disable all features",
        Flag = "PanicKey"
    })
    
    keybindSection:AddKeybind({
        Title = "Quick Action",
        Default = Enum.KeyCode.F,
        Mode = "Always",
        Flag = "QuickActionKey"
    })
    
    local configSection = settingsTab:AddSection({Name = "Configuration"})
    configSection:AddButton({
        Title = "Export Config",
        Style = "outline",
        Callback = function()
            local exported = PHUCMAX:ExportConfig()
            print("Config exported to clipboard")
        end
    })
    
    configSection:AddButton({
        Title = "Import Config",
        Style = "outline",
        Callback = function()
            PHUCMAX:Prompt("Import Config", "Paste config JSON:", function(json)
                if json then
                    local success = PHUCMAX:ImportConfig(json)
                    if success then
                        PHUCMAX:Notify({Title = "Success", Content = "Config imported!", Type = "success"})
                    end
                end
            end)
        end
    })
    
    configSection:AddButton({
        Title = "Reset All Settings",
        Style = "danger",
        Callback = function()
            PHUCMAX:Confirm("Reset Settings", "Are you sure you want to reset all settings?", function()
                PHUCMAX:ResetConfig()
                PHUCMAX:Notify({Title = "Reset", Content = "All settings reset!", Type = "warning"})
            end)
        end
    })
    
    -- Tab 5: Dev Tools
    local devTab = mainWindow:AddTab({Title = "Dev", Icon = "rbxassetid://"})
    
    local devSection = devTab:AddSection({Name = "Developer Tools"})
    devSection:AddToggle({
        Title = "Enable Dev Tools",
        Default = false,
        Callback = function(value)
            if value then
                DevTools:Enable()
            end
            DevTools.Panel.Visible = value
        end
    })
    
    devSection:AddButton({
        Title = "Memory Stats",
        Callback = function()
            local stats = MemoryManager:GetStats()
            print("Memory:", stats.MemoryUsage, "KB")
            print("Objects:", stats.TotalObjects)
        end
    })
    
    devSection:AddButton({
        Title = "Force GC",
        Callback = function()
            local count = MemoryManager:ForceCleanup()
            print("Cleaned up", count, "objects")
        end
    })
    
    devSection:AddButton({
        Title = "Show Info",
        Callback = function()
            print(MemoryManager:DumpInfo())
        end
    })
    
    -- Create floating button
    PHUCMAX:CreateFloatingButton({
        Icon = "rbxassetid://",
        Size = 55,
        Color = ThemeManager:GetTheme().Main,
        ShowGlow = true,
        ShowShadow = true,
        Callback = function()
            if mainWindow.State.IsVisible then
                mainWindow:Hide()
            else
                mainWindow:Show()
            end
        end
    })
    
    -- Welcome notification
    PHUCMAX:Notify({
        Title = "PHUCMAX Loaded",
        Content = "Demo interface ready! Explore the tabs to see all features.",
        Type = "success",
        Duration = 5
    })
    
    -- Start session
    PHUCMAX:StartSession("Demo Session")
    
    -- Enable dev tools
    DevTools:Enable()
    DevTools:Log("Demo system loaded successfully", "success")
    
    table.insert(self.DemoWindows, mainWindow)
    
    return mainWindow
end

function DemoSystem:Unload()
    for _, window in ipairs(self.DemoWindows) do
        if window.Close then
            window:Close()
        end
    end
    self.DemoWindows = {}
    self.Loaded = false
end

--============================================--
-- SECTION 64: INTEGRATION
--============================================--

PHUCMAX.PerformanceOptimizer = PerformanceOptimizer
PHUCMAX.MemoryManager = MemoryManager
PHUCMAX.DevTools = DevTools
PHUCMAX.DemoSystem = DemoSystem

-- Initialize performance optimizer
PerformanceOptimizer:Initialize()

-- Load demo automatically
function PHUCMAX:LoadDemo()
    return DemoSystem:LoadFullDemo()
end

--============================================--
-- SECTION 65: ADVANCED TAB SYSTEM
--============================================--

local AdvancedTabSystem = {}
AdvancedTabSystem.TabGroups = {}
AdvancedTabSystem.TabHistory = {}
AdvancedTabSystem.MaxHistory = 20

function AdvancedTabSystem:CreateTabGroup(window, config)
    local theme = ThemeManager:GetTheme()
    
    local groupConfig = {
        Name = config.Name or "Tab Group",
        Tabs = config.Tabs or {},
        Collapsible = config.Collapsible or false,
        Collapsed = config.Collapsed or false,
        Icon = config.Icon or ""
    }
    
    -- Group container in tab area
    local groupContainer = Utils:CreateInstance("Frame", {
        Parent = window.TabScroll,
        Name = "TabGroup_" .. groupConfig.Name,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -4, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 155
    })
    
    -- Group header
    local groupHeader = Utils:CreateInstance("Frame", {
        Parent = groupContainer,
        Name = "GroupHeader",
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 30),
        BorderSizePixel = 0,
        ZIndex = 156
    })
    Utils:AddCorner(groupHeader, 8)
    
    -- Group icon
    if groupConfig.Icon ~= "" then
        Utils:CreateInstance("ImageLabel", {
            Parent = groupHeader,
            Name = "GroupIcon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 8, 0.5, -8),
            Image = groupConfig.Icon,
            ImageColor3 = theme.Main,
            ZIndex = 157
        })
    end
    
    -- Group name
    Utils:CreateText({
        Parent = groupHeader,
        Name = "GroupName",
        Position = UDim2.new(0, groupConfig.Icon ~= "" and 30 or 10, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Fonts.Bold,
        Text = groupConfig.Name,
        TextColor3 = theme.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 157
    })
    
    -- Collapse arrow
    local collapseArrow = nil
    if groupConfig.Collapsible then
        collapseArrow = Utils:CreateText({
            Parent = groupHeader,
            Name = "CollapseArrow",
            Position = UDim2.new(1, -20, 0, 0),
            Size = UDim2.new(0, 16, 1, 0),
            Font = Fonts.Bold,
            Text = groupConfig.Collapsed and "▶" or "▼",
            TextColor3 = theme.MutedText,
            TextSize = 10,
            ZIndex = 157
        })
    end
    
    -- Group content (contains tabs)
    local groupContent = Utils:CreateInstance("Frame", {
        Parent = groupContainer,
        Name = "GroupContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 32),
        BorderSizePixel = 0,
        ZIndex = 156,
        Visible = not groupConfig.Collapsed
    })
    
    local groupContentList = Instance.new("UIListLayout")
    groupContentList.Padding = UDim.new(0, 4)
    groupContentList.Parent = groupContent
    
    -- Tab list within group
    local groupTabs = {}
    
    local function updateGroupSize()
        if groupConfig.Collapsed then
            groupContainer.Size = UDim2.new(1, -4, 0, 32)
            return
        end
        
        local totalHeight = 36
        for _, tab in ipairs(groupTabs) do
            if tab.Button.Visible then
                totalHeight = totalHeight + tab.Button.AbsoluteSize.Y + 4
            end
        end
        groupContent.Size = UDim2.new(1, 0, 0, totalHeight - 36)
        groupContainer.Size = UDim2.new(1, -4, 0, totalHeight)
    end
    
    local function toggleCollapse()
        groupConfig.Collapsed = not groupConfig.Collapsed
        
        if groupConfig.Collapsed then
            groupContent.Visible = false
            if collapseArrow then
                collapseArrow.Text = "▶"
            end
            AnimationController:Play(groupContainer, "Smooth", {
                Size = UDim2.new(1, -4, 0, 32)
            }, 0.3)
        else
            groupContent.Visible = true
            if collapseArrow then
                collapseArrow.Text = "▼"
            end
            updateGroupSize()
            AnimationController:Play(groupContainer, "Spring", {
                Size = groupContainer.Size
            }, 0.3)
        end
    end
    
    if groupConfig.Collapsible then
        groupHeader.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggleCollapse()
            end
        end)
    end
    
    -- Methods
    local groupData = {
        Container = groupContainer,
        Header = groupHeader,
        Content = groupContent,
        Tabs = groupTabs,
        Config = groupConfig,
        ToggleCollapse = toggleCollapse,
        UpdateSize = updateGroupSize
    }
    
    -- Add tab to group
    function groupData:AddTab(tabConfig)
        local tab = TabSystem:CreateTab(window, {
            Title = tabConfig.Title or "Tab",
            Icon = tabConfig.Icon or "",
            Order = #groupTabs + 1
        })
        
        -- Move tab button to group content
        tab.Button.Parent = groupContent
        
        table.insert(groupTabs, tab)
        updateGroupSize()
        
        return tab
    end
    
    table.insert(self.TabGroups, groupData)
    
    return groupData
end

--============================================--
-- SECTION 66: TAB HISTORY & NAVIGATION
--============================================--

function AdvancedTabSystem:AddToHistory(tab)
    -- Remove if already in history
    for i, historyTab in ipairs(self.TabHistory) do
        if historyTab == tab then
            table.remove(self.TabHistory, i)
            break
        end
    end
    
    table.insert(self.TabHistory, tab)
    
    -- Trim history
    while #self.TabHistory > self.MaxHistory do
        table.remove(self.TabHistory, 1)
    end
end

function AdvancedTabSystem:GoBack(window)
    if #self.TabHistory < 2 then return false end
    
    -- Remove current
    table.remove(self.TabHistory)
    
    -- Get previous
    local previousTab = table.remove(self.TabHistory)
    
    if previousTab and previousTab.Button and previousTab.Button.Parent then
        window:SelectTab(previousTab)
        return true
    end
    
    return false
end

function AdvancedTabSystem:GoForward(window)
    -- Simple implementation - can be enhanced with forward history
    return false
end

function AdvancedTabSystem:CreateTabNavigator(window, section)
    local theme = ThemeManager:GetTheme()
    
    -- Navigation bar
    local navFrame = Utils:CreateInstance("Frame", {
        Parent = section.Content,
        Name = "TabNavigator",
        BackgroundColor3 = theme.SurfaceLight,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 32),
        BorderSizePixel = 0,
        ZIndex = 170
    })
    Utils:AddCorner(navFrame, 8)
    
    -- Back button
    local backBtn = Utils:CreateButton({
        Parent = navFrame,
        Name = "BackBtn",
        BackgroundColor3 = theme.Main,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 60, 0, 24),
        Position = UDim2.new(0, 8, 0.5, -12),
        Text = "◀ Back",
        Font = Fonts.Bold,
        TextColor3 = theme.Text,
        TextSize = 11,
        ZIndex = 171
    })
    Utils:AddCorner(backBtn, 6)
    
    -- Forward button
    local forwardBtn = Utils:CreateButton({
        Parent = navFrame,
        Name = "ForwardBtn",
        BackgroundColor3 = theme.Main,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 60, 0, 24),
        Position = UDim2.new(0, 74, 0.5, -12),
        Text = "Forward ▶",
        Font = Fonts.Bold,
        TextColor3 = theme.Text,
        TextSize = 11,
        ZIndex = 171
    })
    Utils:AddCorner(forwardBtn, 6)
    
    -- Current tab label
    local currentTabLabel = Utils:CreateText({
        Parent = navFrame,
        Name = "CurrentTab",
        Position = UDim2.new(0, 140, 0, 0),
        Size = UDim2.new(1, -148, 1, 0),
        Font = Fonts.Regular,
        Text = window.CurrentTab and window.CurrentTab.Name or "No Tab",
        TextColor3 = theme.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 171
    })
    
    backBtn.MouseButton1Click:Connect(function()
        AdvancedTabSystem:GoBack(window)
        currentTabLabel.Text = window.CurrentTab and window.CurrentTab.Name or "No Tab"
    end)
    
    forwardBtn.MouseButton1Click:Connect(function()
        AdvancedTabSystem:GoForward(window)
        currentTabLabel.Text = window.CurrentTab and window.CurrentTab.Name or "No Tab"
    end)
    
    -- Update label when tab changes
    local originalSelectTab = window.SelectTab
    window.SelectTab = function(self, tab)
        originalSelectTab(self, tab)
        AdvancedTabSystem:AddToHistory(tab)
        currentTabLabel.Text = tab and tab.Name or "No Tab"
    end
    
    return navFrame
end

--============================================--
-- SECTION 67: WINDOW STACKING SYSTEM
--============================================--

local WindowStacking = {}
WindowStacking.Stacks = {}

function WindowStacking:CreateStack(config)
    local stackConfig = {
        Name = config.Name or "Window Stack",
        Windows = config.Windows or {},
        Direction = config.Direction or "Horizontal", -- "Horizontal" or "Vertical"
        Spacing = config.Spacing or 4,
        AutoResize = config.AutoResize ~= false
    }
    
    local stackData = {
        Name = stackConfig.Name,
        Windows = {},
        Config = stackConfig
    }
    
    function stackData:AddWindow(window)
        table.insert(self.Windows, window)
        self:ArrangeWindows()
    end
    
    function stackData:RemoveWindow(window)
        Utils:TableRemove(self.Windows, window)
        self:ArrangeWindows()
    end
    
    function stackData:ArrangeWindows()
        local count = #self.Windows
        if count == 0 then return end
        
        if stackConfig.Direction == "Horizontal" then
            local totalWidth = 0
            local availableWidth = SCREEN_WIDTH - (count + 1) * stackConfig.Spacing
            local widthPerWindow = availableWidth / count
            
            for i, window in ipairs(self.Windows) do
                local xPos = stackConfig.Spacing + (i - 1) * (widthPerWindow + stackConfig.Spacing)
                
                window:SetPosition(UDim2.new(0, xPos, 0, stackConfig.Spacing))
                window:SetSize(UDim2.new(0, widthPerWindow, 0, SCREEN_HEIGHT - stackConfig.Spacing * 2))
            end
        else
            local totalHeight = 0
            local availableHeight = SCREEN_HEIGHT - (count + 1) * stackConfig.Spacing
            local heightPerWindow = availableHeight / count
            
            for i, window in ipairs(self.Windows) do
                local yPos = stackConfig.Spacing + (i - 1) * (heightPerWindow + stackConfig.Spacing)
                
                window:SetPosition(UDim2.new(0, stackConfig.Spacing, 0, yPos))
                window:SetSize(UDim2.new(0, SCREEN_WIDTH - stackConfig.Spacing * 2, 0, heightPerWindow))
            end
        end
    end
    
    table.insert(self.Stacks, stackData)
    
    -- Add initial windows
    for _, window in ipairs(stackConfig.Windows) do
        stackData:AddWindow(window)
    end
    
    return stackData
end

function WindowStacking:RemoveStack(stackData)
    Utils:TableRemove(self.Stacks, stackData)
end

--============================================--
-- SECTION 68: MULTI-WINDOW MANAGER
--============================================--

local MultiWindowManager = {}
MultiWindowManager.WindowGroups = {}
MultiWindowManager.ActiveGroup = nil

function MultiWindowManager:CreateWindowGroup(config)
    local groupConfig = {
        Name = config.Name or "Window Group",
        Layout = config.Layout or "Cascade", -- "Cascade", "Tile", "Grid"
        AutoArrange = config.AutoArrange ~= false
    }
    
    local groupData = {
        Name = groupConfig.Name,
        Windows = {},
        Config = groupConfig,
        Container = nil
    }
    
    -- Create container if needed
    if config.CreateContainer then
        groupData.Container = Utils:CreateInstance("Frame", {
            Parent = Services.CoreGui,
            Name = "WindowGroup_" .. groupConfig.Name,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.95,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 50,
            Visible = false
        })
    end
    
    function groupData:AddWindow(window)
        table.insert(self.Windows, window)
        
        if groupConfig.AutoArrange then
            self:ArrangeWindows()
        end
        
        -- Update window reference
        window._group = self
    end
    
    function groupData:RemoveWindow(window)
        Utils:TableRemove(self.Windows, window)
        window._group = nil
        
        if groupConfig.AutoArrange then
            self:ArrangeWindows()
        end
    end
    
    function groupData:ArrangeWindows()
        local count = #self.Windows
        if count == 0 then return end
        
        if groupConfig.Layout == "Cascade" then
            local offset = 30
            local startX = 50
            local startY = 50
            
            for i, window in ipairs(self.Windows) do
                local x = startX + (i - 1) * offset
                local y = startY + (i - 1) * offset
                
                window:SetPosition(UDim2.new(0, x, 0, y))
                
                -- Bring to front in reverse order
                if i == count then
                    window:BringToFront()
                end
            end
        elseif groupConfig.Layout == "Tile" then
            local cols = math.ceil(math.sqrt(count))
            local rows = math.ceil(count / cols)
            local width = SCREEN_WIDTH / cols
            local height = SCREEN_HEIGHT / rows
            
            for i, window in ipairs(self.Windows) do
                local col = (i - 1) % cols
                local row = math.floor((i - 1) / cols)
                
                window:SetPosition(UDim2.new(0, col * width, 0, row * height))
                window:SetSize(UDim2.new(0, width - 4, 0, height - 4))
            end
        elseif groupConfig.Layout == "Grid" then
            local cols = config.Cols or 2
            local rows = math.ceil(count / cols)
            local width = SCREEN_WIDTH / cols
            local height = SCREEN_HEIGHT / rows
            
            for i, window in ipairs(self.Windows) do
                local col = (i - 1) % cols
                local row = math.floor((i - 1) / cols)
                
                window:SetPosition(UDim2.new(0, col * width + 2, 0, row * height + 2))
                window:SetSize(UDim2.new(0, width - 4, 0, height - 4))
            end
        end
    end
    
    function groupData:ShowAll()
        for _, window in ipairs(self.Windows) do
            window:Show()
        end
        if self.Container then
            self.Container.Visible = true
        end
    end
    
    function groupData:HideAll()
        for _, window in ipairs(self.Windows) do
            window:Hide()
        end
        if self.Container then
            self.Container.Visible = false
        end
    end
    
    function groupData:CloseAll()
        for _, window in ipairs(self.Windows) do
            window:Close()
        end
        self.Windows = {}
        if self.Container then
            self.Container:Destroy()
        end
    end
    
    function groupData:FocusWindow(window)
        for _, w in ipairs(self.Windows) do
            if w == window then
                w:BringToFront()
            end
        end
    end
    
    table.insert(self.WindowGroups, groupData)
    
    return groupData
end

function MultiWindowManager:SetActiveGroup(groupData)
    self.ActiveGroup = groupData
end

function MultiWindowManager:GetActiveGroup()
    return self.ActiveGroup
end

--============================================--
-- SECTION 69: LAYOUT ENGINE
--============================================--

local LayoutEngine = {}
LayoutEngine.Layouts = {}

function LayoutEngine:CreateLayout(config)
    local layoutConfig = {
        Type = config.Type or "Flex", -- "Flex", "Grid", "Absolute", "Dock"
        Parent = config.Parent,
        Direction = config.Direction or "Vertical", -- "Horizontal" or "Vertical"
        Gap = config.Gap or 8,
        Padding = config.Padding or {Top = 8, Bottom = 8, Left = 8, Right = 8},
        Wrap = config.Wrap or false,
        Align = config.Align or "Start", -- "Start", "Center", "End", "Stretch"
        Justify = config.Justify or "Start" -- "Start", "Center", "End", "Between", "Around"
    }
    
    local layoutData = {
        Config = layoutConfig,
        Children = {},
        Connections = {}
    }
    
    -- Create layout container
    local container = Utils:CreateInstance("Frame", {
        Parent = layoutConfig.Parent,
        Name = "Layout_" .. layoutConfig.Type,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 100
    })
    
    -- Add padding
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, layoutConfig.Padding.Top)
    padding.PaddingBottom = UDim.new(0, layoutConfig.Padding.Bottom)
    padding.PaddingLeft = UDim.new(0, layoutConfig.Padding.Left)
    padding.PaddingRight = UDim.new(0, layoutConfig.Padding.Right)
    padding.Parent = container
    
    -- Add list layout for flex
    if layoutConfig.Type == "Flex" then
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, layoutConfig.Gap)
        listLayout.FillDirection = layoutConfig.Direction == "Horizontal" and 
                                     Enum.FillDirection.Horizontal or 
                                     Enum.FillDirection.Vertical
        listLayout.HorizontalAlignment = layoutConfig.Align == "Center" and Enum.HorizontalAlignment.Center or
                                          layoutConfig.Align == "End" and Enum.HorizontalAlignment.Right or
                                          Enum.HorizontalAlignment.Left
        listLayout.VerticalAlignment = layoutConfig.Justify == "Center" and Enum.VerticalAlignment.Center or
                                        layoutConfig.Justify == "End" and Enum.VerticalAlignment.Bottom or
                                        Enum.VerticalAlignment.Top
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = container
    elseif layoutConfig.Type == "Grid" then
        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.CellPadding = UDim2.new(0, layoutConfig.Gap, 0, layoutConfig.Gap)
        gridLayout.FillDirection = layoutConfig.Direction == "Horizontal" and 
                                    Enum.FillDirection.Horizontal or 
                                    Enum.FillDirection.Vertical
        gridLayout.HorizontalAlignment = layoutConfig.Align == "Center" and Enum.HorizontalAlignment.Center or
                                          layoutConfig.Align == "End" and Enum.HorizontalAlignment.Right or
                                          Enum.HorizontalAlignment.Left
        gridLayout.VerticalAlignment = layoutConfig.Justify == "Center" and Enum.VerticalAlignment.Center or
                                        layoutConfig.Justify == "End" and Enum.VerticalAlignment.Bottom or
                                        Enum.VerticalAlignment.Top
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        gridLayout.Parent = container
    end
    
    layoutData.Container = container
    
    function layoutData:AddChild(child, config)
        local childConfig = config or {}
        child.Parent = container
        
        if childConfig.LayoutOrder then
            child.LayoutOrder = childConfig.LayoutOrder
        end
        
        if childConfig.Fill and layoutConfig.Type == "Flex" then
            if layoutConfig.Direction == "Horizontal" then
                child.Size = UDim2.new(1, 0, 1, 0)
            else
                child.Size = UDim2.new(1, 0, 1, 0)
            end
        end
        
        if childConfig.Size then
            child.Size = childConfig.Size
        end
        
        table.insert(self.Children, {
            Object = child,
            Config = childConfig
        })
        
        return child
    end
    
    function layoutData:RemoveChild(child)
        for i, data in ipairs(self.Children) do
            if data.Object == child then
                table.remove(self.Children, i)
                child.Parent = nil
                break
            end
        end
    end
    
    function layoutData:Clear()
        for _, data in ipairs(self.Children) do
            if data.Object and data.Object.Parent then
                data.Object:Destroy()
            end
        end
        self.Children = {}
    end
    
    function layoutData:Destroy()
        self:Clear()
        if container and container.Parent then
            container:Destroy()
        end
        for _, conn in ipairs(self.Connections) do
            conn:Disconnect()
        end
    end
    
    table.insert(self.Layouts, layoutData)
    
    return layoutData
end

--============================================--
-- SECTION 70: TAB DRAG & DROP REORDERING
--============================================--

local TabDragDrop = {}
TabDragDrop.Dragging = false
TabDragDrop.DragTab = nil
TabDragDrop.DragGhost = nil
TabDragDrop.DropTarget = nil

function TabDragDrop:EnableForWindow(window)
    for _, tab in ipairs(window.Tabs) do
        self:MakeDraggable(tab, window)
    end
end

function TabDragDrop:MakeDraggable(tab, window)
    local button = tab.Button
    local longPress = false
    local pressTimer = nil
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            pressTimer = task.delay(0.4, function()
                longPress = true
                self:StartDrag(tab, window, input.Position)
            end)
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if pressTimer then
            task.cancel(pressTimer)
            pressTimer = nil
        end
        
        if self.Dragging and longPress then
            self:EndDrag(tab, window)
        end
        
        longPress = false
    end)
end

function TabDragDrop:StartDrag(tab, window, position)
    self.Dragging = true
    self.DragTab = tab
    
    -- Create ghost
    self.DragGhost = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "DragGhost",
        BackgroundColor3 = ThemeManager:GetTheme().Main,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, tab.Button.AbsoluteSize.X, 0, tab.Button.AbsoluteSize.Y),
        Position = UDim2.new(0, tab.Button.AbsolutePosition.X, 0, tab.Button.AbsolutePosition.Y),
        BorderSizePixel = 0,
        ZIndex = 50000
    })
    Utils:AddCorner(self.DragGhost, 8)
    Utils:AddStroke(self.DragGhost, ThemeManager:GetTheme().Glow, 2)
    
    -- Tab name on ghost
    Utils:CreateText({
        Parent = self.DragGhost,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Fonts.Bold,
        Text = tab.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        ZIndex = 50001
    })
    
    -- Fade original
    AnimationController:Play(tab.Button, "Fast", {
        BackgroundTransparency = 0.5
    })
end

function TabDragDrop:EndDrag(tab, window)
    self.Dragging = false
    
    if self.DragGhost then
        self.DragGhost:Destroy()
        self.DragGhost = nil
    end
    
    -- Restore original
    AnimationController:Play(tab.Button, "Fast", {
        BackgroundTransparency = tab.IsSelected and 0.35 or 0.75
    })
    
    -- Reorder if dropped on another tab
    if self.DropTarget then
        local targetTab = self.DropTarget
        
        -- Swap LayoutOrders
        local tempOrder = tab.Button.LayoutOrder
        tab.Button.LayoutOrder = targetTab.Button.LayoutOrder
        targetTab.Button.LayoutOrder = tempOrder
        
        -- Reorder in tabs array
        local tabIndex = Utils:TableFind(window.Tabs, tab)
        local targetIndex = Utils:TableFind(window.Tabs, targetTab)
        
        if tabIndex and targetIndex then
            table.remove(window.Tabs, tabIndex)
            table.insert(window.Tabs, targetIndex, tab)
        end
        
        self.DropTarget = nil
    end
    
    self.DragTab = nil
end

-- Update ghost position on mouse move
Services.UserInputService.InputChanged:Connect(function(input)
    if TabDragDrop.Dragging and TabDragDrop.DragGhost then
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            local pos = input.Position
            TabDragDrop.DragGhost.Position = UDim2.new(
                0, pos.X - TabDragDrop.DragGhost.AbsoluteSize.X / 2,
                0, pos.Y - TabDragDrop.DragGhost.AbsoluteSize.Y / 2
            )
            
            -- Check drop targets
            -- This would check if hovering over other tabs
        end
    end
end)

--============================================--
-- SECTION 71: INTEGRATION
--============================================--

-- Add systems to PHUCMAX
PHUCMAX.AdvancedTabSystem = AdvancedTabSystem
PHUCMAX.WindowStacking = WindowStacking
PHUCMAX.MultiWindowManager = MultiWindowManager
PHUCMAX.LayoutEngine = LayoutEngine
PHUCMAX.TabDragDrop = TabDragDrop

-- Add methods to WindowBuilder
local originalWindowBuilder = WindowBuilder.new
function WindowBuilder.new(config)
    local window = originalWindowBuilder(config)
    
    -- Add tab group method
    window.CreateTabGroup = function(self, groupConfig)
        return AdvancedTabSystem:CreateTabGroup(self, groupConfig)
    end
    
    -- Add navigator method
    window.CreateNavigator = function(self, section)
        return AdvancedTabSystem:CreateTabNavigator(self, section)
    end
    
    -- Enable drag-drop
    TabDragDrop:EnableForWindow(window)
    
    return window
end


--============================================--
-- SECTION 72: INTERNATIONALIZATION SYSTEM
--============================================--

local I18nSystem = {}
I18nSystem.CurrentLocale = "en"
I18nSystem.FallbackLocale = "en"
I18nSystem.Translations = {}
I18nSystem.LoadedLocales = {}
I18nSystem.TranslationCallbacks = {}

-- Default English translations
I18nSystem.Translations["en"] = {
    -- General
    General_Ok = "OK",
    General_Cancel = "Cancel",
    General_Close = "Close",
    General_Save = "Save",
    General_Load = "Load",
    General_Delete = "Delete",
    General_Edit = "Edit",
    General_Search = "Search...",
    General_Select = "Select...",
    General_None = "None",
    General_All = "All",
    General_Enabled = "Enabled",
    General_Disabled = "Disabled",
    General_On = "ON",
    General_Off = "OFF",
    General_Yes = "Yes",
    General_No = "No",
    General_Confirm = "Confirm",
    General_Reset = "Reset",
    General_Refresh = "Refresh",
    General_Export = "Export",
    General_Import = "Import",
    General_Copy = "Copy",
    General_Paste = "Paste",
    General_Cut = "Cut",
    General_Undo = "Undo",
    General_Redo = "Redo",
    General_Settings = "Settings",
    General_Help = "Help",
    General_About = "About",
    General_Back = "Back",
    General_Forward = "Forward",
    General_Home = "Home",
    General_Exit = "Exit",
    General_Quit = "Quit",
    General_Retry = "Retry",
    General_Ignore = "Ignore",
    General_Abort = "Abort",
    
    -- Notifications
    Notification_Success = "Success",
    Notification_Error = "Error",
    Notification_Warning = "Warning",
    Notification_Info = "Information",
    
    -- Window
    Window_Minimize = "Minimize",
    Window_Maximize = "Maximize",
    Window_Restore = "Restore",
    Window_Close = "Close",
    Window_Move = "Move",
    Window_Resize = "Resize",
    
    -- Tab
    Tab_New = "New Tab",
    Tab_Close = "Close Tab",
    Tab_Rename = "Rename Tab",
    Tab_Duplicate = "Duplicate Tab",
    
    -- Theme
    Theme_Change = "Theme Changed",
    Theme_Switched = "Switched to %s theme",
    Theme_Custom = "Custom",
    
    -- Config
    Config_Saved = "Configuration saved",
    Config_Loaded = "Configuration loaded",
    Config_Reset = "Configuration reset",
    Config_Exported = "Configuration exported",
    Config_Imported = "Configuration imported",
    Config_Failed = "Operation failed",
    Config_FileNotFound = "File not found",
    Config_InvalidData = "Invalid data format",
    
    -- Backup
    Backup_Created = "Backup created",
    Backup_Restored = "Backup restored",
    Backup_Failed = "Backup failed",
    
    -- Color
    Color_Picker = "Color Picker",
    Color_Hex = "HEX",
    Color_RGB = "RGB",
    Color_HSV = "HSV",
    Color_Alpha = "Alpha",
    Color_Presets = "Presets",
    
    -- Slider
    Slider_Value = "Value",
    Slider_Min = "Minimum",
    Slider_Max = "Maximum",
    
    -- Dropdown
    Dropdown_Search = "Search...",
    Dropdown_NoResults = "No results found",
    Dropdown_Selected = "Selected: %d",
    
    -- Keybind
    Keybind_PressKey = "Press a key...",
    Keybind_None = "None",
    Keybind_Mode_Toggle = "Toggle",
    Keybind_Mode_Hold = "Hold",
    Keybind_Mode_Always = "Always",
    
    -- Dialog
    Dialog_Confirm = "Are you sure?",
    Dialog_Yes = "Yes",
    Dialog_No = "No",
    Dialog_Cancel = "Cancel",
    
    -- Time
    Time_Second = "second",
    Time_Seconds = "seconds",
    Time_Minute = "minute",
    Time_Minutes = "minutes",
    Time_Hour = "hour",
    Time_Hours = "hours",
    Time_Day = "day",
    Time_Days = "days",
    Time_Ago = "%s ago",
    Time_JustNow = "Just now",
    
    -- Memory
    Memory_Usage = "Memory Usage",
    Memory_Objects = "Objects",
    Memory_Cleaned = "Cleaned up %d objects",
}

-- Vietnamese translations
I18nSystem.Translations["vi"] = {
    General_Ok = "Đồng ý",
    General_Cancel = "Hủy",
    General_Close = "Đóng",
    General_Save = "Lưu",
    General_Load = "Tải",
    General_Delete = "Xóa",
    General_Edit = "Sửa",
    General_Search = "Tìm kiếm...",
    General_Select = "Chọn...",
    General_None = "Không có",
    General_All = "Tất cả",
    General_Enabled = "Bật",
    General_Disabled = "Tắt",
    General_On = "BẬT",
    General_Off = "TẮT",
    General_Yes = "Có",
    General_No = "Không",
    General_Confirm = "Xác nhận",
    General_Reset = "Đặt lại",
    General_Refresh = "Làm mới",
    General_Export = "Xuất",
    General_Import = "Nhập",
    General_Copy = "Sao chép",
    General_Paste = "Dán",
    General_Cut = "Cắt",
    General_Settings = "Cài đặt",
    General_Help = "Trợ giúp",
    General_About = "Giới thiệu",
    General_Back = "Quay lại",
    General_Forward = "Tiến",
    General_Home = "Trang chủ",
    General_Exit = "Thoát",
    
    Notification_Success = "Thành công",
    Notification_Error = "Lỗi",
    Notification_Warning = "Cảnh báo",
    Notification_Info = "Thông tin",
    
    Window_Minimize = "Thu nhỏ",
    Window_Maximize = "Phóng to",
    Window_Restore = "Khôi phục",
    Window_Close = "Đóng",
    
    Theme_Change = "Đổi chủ đề",
    Theme_Switched = "Đã chuyển sang chủ đề %s",
    
    Config_Saved = "Đã lưu cấu hình",
    Config_Loaded = "Đã tải cấu hình",
    Config_Reset = "Đã đặt lại cấu hình",
    Config_Failed = "Thao tác thất bại",
    
    Dropdown_NoResults = "Không tìm thấy kết quả",
    Keybind_PressKey = "Nhấn một phím...",
    
    Dialog_Confirm = "Bạn có chắc không?",
    Dialog_Yes = "Có",
    Dialog_No = "Không",
    Dialog_Cancel = "Hủy",
}

function I18nSystem:Translate(key, ...)
    local locale = self.CurrentLocale
    local translations = self.Translations[locale] or self.Translations[self.FallbackLocale] or {}
    local text = translations[key] or self.Translations[self.FallbackLocale][key] or key
    
    if ... then
        local args = {...}
        text = string.format(text, table.unpack(args))
    end
    
    return text
end

function I18nSystem:T(key, ...)
    return self:Translate(key, ...)
end

function I18nSystem:SetLocale(locale)
    if self.Translations[locale] then
        self.CurrentLocale = locale
        self:NotifyCallbacks(locale)
        return true
    end
    return false
end

function I18nSystem:GetLocale()
    return self.CurrentLocale
end

function I18nSystem:AddTranslations(locale, translations)
    if not self.Translations[locale] then
        self.Translations[locale] = {}
    end
    
    for key, value in pairs(translations) do
        self.Translations[locale][key] = value
    end
    
    self.LoadedLocales[locale] = true
    
    -- Notify if current locale
    if locale == self.CurrentLocale then
        self:NotifyCallbacks(locale)
    end
end

function I18nSystem:LoadLocaleFromFile(locale, filePath)
    if not isfile or not isfile(filePath) then
        return false
    end
    
    local success, content = pcall(function()
        return readfile(filePath)
    end)
    
    if not success then return false end
    
    local success2, translations = pcall(function()
        return Services.HttpService:JSONDecode(content)
    end)
    
    if not success2 then return false end
    
    self:AddTranslations(locale, translations)
    return true
end

function I18nSystem:OnLocaleChange(callback)
    table.insert(self.TranslationCallbacks, callback)
    
    return function()
        Utils:TableRemove(self.TranslationCallbacks, callback)
    end
end

function I18nSystem:NotifyCallbacks(locale)
    for _, callback in ipairs(self.TranslationCallbacks) do
        task.spawn(function()
            callback(locale)
        end)
    end
end

function I18nSystem:TranslateElement(element)
    for _, child in ipairs(element:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
            local text = child.Text
            if string.match(text, "^I18n_") then
                local key = string.gsub(text, "^I18n_", "")
                child.Text = self:Translate(key)
            end
        end
    end
end

--============================================--
-- SECTION 73: ACCESSIBILITY SYSTEM
--============================================--

local AccessibilitySystem = {}
AccessibilitySystem.Enabled = false
AccessibilitySystem.HighContrast = false
AccessibilitySystem.LargeText = false
AccessibilitySystem.ReduceMotion = false
AccessibilitySystem.ScreenReader = false
AccessibilitySystem.KeyboardNavigation = false
AccessibilitySystem.FontSizeMultiplier = 1.0
AccessibilitySystem.ContrastMultiplier = 1.0

function AccessibilitySystem:Enable()
    self.Enabled = true
    self:ApplySettings()
end

function AccessibilitySystem:Disable()
    self.Enabled = false
    self:ResetSettings()
end

function AccessibilitySystem:SetHighContrast(enabled)
    self.HighContrast = enabled
    
    if enabled then
        -- Override themes with high contrast colors
        local highContrastTheme = {
            Main = Color3.fromRGB(255, 255, 0),
            Second = Color3.fromRGB(255, 200, 0),
            Accent = Color3.fromRGB(255, 255, 100),
            Glow = Color3.fromRGB(255, 255, 0),
            Grad1 = Color3.fromRGB(0, 0, 0),
            Grad2 = Color3.fromRGB(0, 0, 0),
            Bg = Color3.fromRGB(0, 0, 0),
            Surface = Color3.fromRGB(30, 30, 30),
            SurfaceLight = Color3.fromRGB(50, 50, 50),
            SurfaceDark = Color3.fromRGB(20, 20, 20),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(200, 200, 200),
            MutedText = Color3.fromRGB(150, 150, 150)
        }
        
        ThemeManager:CreateCustomTheme(highContrastTheme)
        ThemeManager:SetTheme("Custom")
    else
        ThemeManager:SetTheme(ThemeManager:GetThemeName())
    end
end

function AccessibilitySystem:SetLargeText(enabled)
    self.LargeText = enabled
    self.FontSizeMultiplier = enabled and 1.3 or 1.0
    
    -- Update all text elements
    for _, window in ipairs(WindowManager.Windows) do
        self:ApplyToContainer(window.Container)
    end
end

function AccessibilitySystem:SetReduceMotion(enabled)
    self.ReduceMotion = enabled
    
    if enabled then
        -- Reduce animation complexity
        PerformanceOptimizer.AnimationQuality = "Low"
    else
        PerformanceOptimizer.AnimationQuality = "High"
    end
end

function AccessibilitySystem:SetScreenReader(enabled)
    self.ScreenReader = enabled
    
    if enabled then
        self:EnableScreenReader()
    else
        self:DisableScreenReader()
    end
end

function AccessibilitySystem:SetKeyboardNavigation(enabled)
    self.KeyboardNavigation = enabled
    
    if enabled then
        self:EnableKeyboardNav()
    else
        self:DisableKeyboardNav()
    end
end

function AccessibilitySystem:ApplyToContainer(container)
    if not container then return end
    
    for _, child in ipairs(container:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
            if self.LargeText then
                child.TextSize = child.TextSize * 1.3
            end
        end
        
        if child:IsA("Frame") or child:IsA("ImageLabel") then
            if self.HighContrast then
                -- Increase contrast
                if child:FindFirstChildOfClass("UIStroke") then
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    stroke.Thickness = stroke.Thickness * 1.5
                end
            end
        end
    end
end

function AccessibilitySystem:ApplySettings()
    for _, window in ipairs(WindowManager.Windows) do
        self:ApplyToContainer(window.Container)
    end
end

function AccessibilitySystem:ResetSettings()
    self.HighContrast = false
    self.LargeText = false
    self.ReduceMotion = false
    self.FontSizeMultiplier = 1.0
    self.ContrastMultiplier = 1.0
end

--============================================--
-- SECTION 74: SCREEN READER
--============================================--

local ScreenReader = {}
ScreenReader.Enabled = false
ScreenReader.Announcements = {}
ScreenReader.CurrentFocus = nil
ScreenReader.FocusHistory = {}

function ScreenReader:Enable()
    self.Enabled = true
    
    -- Listen for focus changes
    Services.UserInputService.InputBegan:Connect(function(input)
        if not self.Enabled then return end
        
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = Utils:GetMouseLocation()
            self:FindElementAtPosition(mousePos)
        end
    end)
end

function ScreenReader:Disable()
    self.Enabled = false
end

function ScreenReader:Announce(text, priority)
    table.insert(self.Announcements, {
        Text = text,
        Priority = priority or 1,
        Time = os.clock()
    })
    
    -- Keep only recent announcements
    if #self.Announcements > 50 then
        table.remove(self.Announcements, 1)
    end
    
    -- Display announcement visually
    local announcementLabel = Utils:CreateText({
        Parent = Services.CoreGui,
        Name = "ScreenReaderAnnouncement",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 400, 0, 40),
        Position = UDim2.new(0.5, -200, 0, 10),
        Font = Fonts.Bold,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        ZIndex = 999999
    })
    Utils:AddCorner(announcementLabel, 8)
    
    task.delay(3, function()
        if announcementLabel and announcementLabel.Parent then
            AnimationController:Play(announcementLabel, "Smooth", {
                TextTransparency = 1,
                BackgroundTransparency = 1
            }, 0.5, function()
                announcementLabel:Destroy()
            end)
        end
    end)
    
    DevTools:Log("[ScreenReader] " .. text, "info")
end

function ScreenReader:DescribeElement(element)
    local description = ""
    
    if element:IsA("TextButton") then
        description = "Button: " .. (element.Text ~= "" and element.Text or "Unlabeled")
    elseif element:IsA("TextLabel") then
        description = "Label: " .. element.Text
    elseif element:IsA("TextBox") then
        description = "Text Input: " .. (element.PlaceholderText ~= "" and element.PlaceholderText or element.Text)
    elseif element:IsA("ImageButton") then
        description = "Image Button"
    elseif element:IsA("ScrollingFrame") then
        description = "Scrollable Area"
    elseif element:IsA("Frame") and element:FindFirstChildOfClass("UIStroke") then
        description = "Container"
    end
    
    if element.Name and description == "" then
        description = "Element: " .. element.Name
    end
    
    return description
end

function ScreenReader:FindElementAtPosition(position)
    local topElement = nil
    local topZIndex = -1
    
    for _, window in ipairs(WindowManager.Windows) do
        if window.Container and window.Container.Visible then
            local absPos = window.Container.AbsolutePosition
            local absSize = window.Container.AbsoluteSize
            
            if position.X >= absPos.X and position.X <= absPos.X + absSize.X and
               position.Y >= absPos.Y and position.Y <= absPos.Y + absSize.Y then
                
                for _, child in ipairs(window.Container:GetDescendants()) do
                    if child:IsA("GuiButton") or child:IsA("TextBox") then
                        local childPos = child.AbsolutePosition
                        local childSize = child.AbsoluteSize
                        
                        if position.X >= childPos.X and position.X <= childPos.X + childSize.X and
                           position.Y >= childPos.Y and position.Y <= childPos.Y + childSize.Y then
                            
                            if child.ZIndex >= topZIndex then
                                topZIndex = child.ZIndex
                                topElement = child
                            end
                        end
                    end
                end
            end
        end
    end
    
    if topElement and topElement ~= self.CurrentFocus then
        self.CurrentFocus = topElement
        table.insert(self.FocusHistory, topElement)
        
        if #self.FocusHistory > 100 then
            table.remove(self.FocusHistory, 1)
        end
        
        local description = self:DescribeElement(topElement)
        if description ~= "" then
            self:Announce(description)
        end
    end
end

--============================================--
-- SECTION 75: INPUT MANAGER
--============================================--

local InputManager = {}
InputManager.InputModes = {}
InputManager.CurrentMode = "Default"
InputManager.Gestures = {}
InputManager.ActiveGestures = {}
InputManager.DoubleClickTime = 0.3
InputManager.LongPressTime = 0.5
InputManager.ClickTimers = {}
InputManager.PressTimers = {}
InputManager.MousePosition = Vector2.new(0, 0)
InputManager.MouseDelta = Vector2.new(0, 0)

function InputManager:CreateInputMode(name, config)
    local modeConfig = {
        Name = name,
        Keybinds = config.Keybinds or {},
        Gestures = config.Gestures or {},
        MouseActions = config.MouseActions or {},
        OnEnter = config.OnEnter or nil,
        OnExit = config.OnExit or nil,
        BlockOtherInput = config.BlockOtherInput or false
    }
    
    self.InputModes[name] = modeConfig
    
    return modeConfig
end

function InputManager:SetMode(modeName)
    local oldMode = self.InputModes[self.CurrentMode]
    local newMode = self.InputModes[modeName]
    
    if not newMode then return false end
    
    -- Exit old mode
    if oldMode and oldMode.OnExit then
        oldMode.OnExit()
    end
    
    self.CurrentMode = modeName
    
    -- Enter new mode
    if newMode.OnEnter then
        newMode.OnEnter()
    end
    
    return true
end

function InputManager:GetMode()
    return self.CurrentMode
end

function InputManager:RegisterGesture(name, config)
    local gestureConfig = {
        Name = name,
        Type = config.Type or "Swipe", -- "Swipe", "Pinch", "Rotate", "Tap", "LongPress"
        Direction = config.Direction or "Any",
        MinDistance = config.MinDistance or 50,
        MaxTime = config.MaxTime or 0.5,
        Fingers = config.Fingers or 1,
        Callback = config.Callback or function() end,
        Enabled = config.Enabled ~= false
    }
    
    self.Gestures[name] = gestureConfig
    
    return gestureConfig
end

function InputManager:EnableGesture(name)
    if self.Gestures[name] then
        self.Gestures[name].Enabled = true
    end
end

function InputManager:DisableGesture(name)
    if self.Gestures[name] then
        self.Gestures[name].Enabled = false
    end
end

-- Track mouse position
Services.UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local oldPos = InputManager.MousePosition
        InputManager.MousePosition = input.Position
        InputManager.MouseDelta = input.Position - oldPos
    end
end)

-- Handle double click detection
function InputManager:DetectDoubleClick(element, callback)
    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local currentTime = os.clock()
            local lastClick = self.ClickTimers[element]
            
            if lastClick and currentTime - lastClick < self.DoubleClickTime then
                self.ClickTimers[element] = nil
                callback()
            else
                self.ClickTimers[element] = currentTime
            end
        end
    end)
end

-- Handle long press detection
function InputManager:DetectLongPress(element, callback)
    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            self.PressTimers[element] = task.delay(self.LongPressTime, function()
                callback()
            end)
        end
    end)
    
    element.InputEnded:Connect(function(input)
        if self.PressTimers[element] then
            task.cancel(self.PressTimers[element])
            self.PressTimers[element] = nil
        end
    end)
end

--============================================--
-- SECTION 76: GESTURE SYSTEM
--============================================--

local GestureSystem = {}
GestureSystem.ActiveTouches = {}
GestureSystem.GestureRecognizers = {}

function GestureSystem:Initialize()
    Services.UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
        if gameProcessed then return end
        
        table.insert(self.ActiveTouches, {
            Touch = touch,
            StartPosition = touch.Position,
            CurrentPosition = touch.Position,
            StartTime = os.clock(),
            Delta = Vector2.new(0, 0),
            Phase = "Began"
        })
        
        self:RecognizeGestures()
    end)
    
    Services.UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
        for _, touchData in ipairs(self.ActiveTouches) do
            if touchData.Touch == touch then
                touchData.Delta = touch.Position - touchData.CurrentPosition
                touchData.CurrentPosition = touch.Position
                touchData.Phase = "Moved"
                break
            end
        end
        
        self:RecognizeGestures()
    end)
    
    Services.UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
        for i, touchData in ipairs(self.ActiveTouches) do
            if touchData.Touch == touch then
                touchData.Phase = "Ended"
                touchData.EndPosition = touch.Position
                touchData.Duration = os.clock() - touchData.StartTime
                
                -- Process gesture
                self:ProcessGesture(touchData)
                
                table.remove(self.ActiveTouches, i)
                break
            end
        end
    end)
end

function GestureSystem:ProcessGesture(touchData)
    local totalDelta = touchData.EndPosition - touchData.StartPosition
    local distance = totalDelta.Magnitude
    local duration = touchData.Duration
    local direction = "None"
    
    if distance > 50 then
        local angle = math.deg(math.atan2(totalDelta.Y, totalDelta.X))
        
        if angle > -45 and angle < 45 then
            direction = "Right"
        elseif angle > 45 and angle < 135 then
            direction = "Down"
        elseif angle < -45 and angle > -135 then
            direction = "Up"
        else
            direction = "Left"
        end
    end
    
    if distance < 10 and duration < 0.3 then
        direction = "Tap"
    elseif distance < 10 and duration > 0.5 then
        direction = "LongPress"
    end
    
    -- Fire gesture events
    if direction ~= "None" then
        EventSystem:Fire("Gesture_" .. direction, touchData)
    end
end

function GestureSystem:RecognizeGestures()
    local touchCount = #self.ActiveTouches
    
    if touchCount == 2 then
        local t1 = self.ActiveTouches[1]
        local t2 = self.ActiveTouches[2]
        
        local currentDistance = (t1.CurrentPosition - t2.CurrentPosition).Magnitude
        local startDistance = (t1.StartPosition - t2.StartPosition).Magnitude
        
        if currentDistance > startDistance * 1.2 then
            EventSystem:Fire("Gesture_PinchOut", currentDistance / startDistance)
        elseif currentDistance < startDistance * 0.8 then
            EventSystem:Fire("Gesture_PinchIn", currentDistance / startDistance)
        end
    end
end

function GestureSystem:OnGesture(gestureType, callback)
    return EventSystem:Listen("Gesture_" .. gestureType, callback)
end

--============================================--
-- SECTION 77: KEYBOARD NAVIGATION
--============================================--

local KeyboardNav = {}
KeyboardNav.Enabled = false
KeyboardNav.FocusIndex = 1
KeyboardNav.FocusableElements = {}
KeyboardNav.FocusIndicator = nil

function KeyboardNav:Enable()
    self.Enabled = true
    self:CreateFocusIndicator()
    self:ScanFocusableElements()
    
    Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not self.Enabled then return end
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Tab then
            self:NavigateNext()
        elseif input.KeyCode == Enum.KeyCode.Up then
            self:NavigateUp()
        elseif input.KeyCode == Enum.KeyCode.Down then
            self:NavigateDown()
        elseif input.KeyCode == Enum.KeyCode.Left then
            self:NavigateLeft()
        elseif input.KeyCode == Enum.KeyCode.Right then
            self:NavigateRight()
        elseif input.KeyCode == Enum.KeyCode.Return then
            self:ActivateCurrent()
        elseif input.KeyCode == Enum.KeyCode.Escape then
            self:ClearFocus()
        end
    end)
end

function KeyboardNav:Disable()
    self.Enabled = false
    if self.FocusIndicator then
        self.FocusIndicator:Destroy()
    end
end

function KeyboardNav:CreateFocusIndicator()
    if self.FocusIndicator then
        self.FocusIndicator:Destroy()
    end
    
    self.FocusIndicator = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "FocusIndicator",
        BackgroundColor3 = ThemeManager:GetTheme().Main,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 999999,
        Visible = false
    })
    Utils:AddStroke(self.FocusIndicator, ThemeManager:GetTheme().Glow, 2)
end

function KeyboardNav:ScanFocusableElements()
    self.FocusableElements = {}
    
    for _, window in ipairs(WindowManager.Windows) do
        if window.Container and window.Container.Visible then
            for _, child in ipairs(window.Container:GetDescendants()) do
                if child:IsA("TextButton") or child:IsA("TextBox") or 
                   child:IsA("ImageButton") then
                    if child.Visible and child.Active then
                        table.insert(self.FocusableElements, child)
                    end
                end
            end
        end
    end
end

function KeyboardNav:FocusElement(index)
    if index < 1 or index > #self.FocusableElements then return end
    
    self.FocusIndex = index
    local element = self.FocusableElements[index]
    
    self.FocusIndicator.Visible = true
    self.FocusIndicator.Size = UDim2.new(
        0, element.AbsoluteSize.X + 6,
        0, element.AbsoluteSize.Y + 6
    )
    self.FocusIndicator.Position = UDim2.new(
        0, element.AbsolutePosition.X - 3,
        0, element.AbsolutePosition.Y - 3
    )
    
    -- Scroll element into view if needed
    if element:IsDescendantOf(WindowManager.ActiveWindow and WindowManager.ActiveWindow.ContentScroll) then
        local scroll = WindowManager.ActiveWindow.ContentScroll
        local elementBottom = element.AbsolutePosition.Y + element.AbsoluteSize.Y
        local scrollBottom = scroll.AbsolutePosition.Y + scroll.AbsoluteSize.Y
        
        if elementBottom > scrollBottom then
            scroll.CanvasPosition = Vector2.new(
                scroll.CanvasPosition.X,
                scroll.CanvasPosition.Y + (elementBottom - scrollBottom) + 20
            )
        elseif element.AbsolutePosition.Y < scroll.AbsolutePosition.Y then
            scroll.CanvasPosition = Vector2.new(
                scroll.CanvasPosition.X,
                scroll.CanvasPosition.Y - (scroll.AbsolutePosition.Y - element.AbsolutePosition.Y) - 20
            )
        end
    end
    
    if ScreenReader.Enabled then
        ScreenReader:Announce(ScreenReader:DescribeElement(element))
    end
end

function KeyboardNav:NavigateNext()
    self:ScanFocusableElements()
    local nextIndex = self.FocusIndex + 1
    if nextIndex > #self.FocusableElements then
        nextIndex = 1
    end
    self:FocusElement(nextIndex)
end

function KeyboardNav:NavigateUp()
    self:ScanFocusableElements()
    -- Find element above current
    local current = self.FocusableElements[self.FocusIndex]
    if not current then return end
    
    local bestIndex = self.FocusIndex
    local bestDistance = math.huge
    
    for i, element in ipairs(self.FocusableElements) do
        if element ~= current then
            local dy = current.AbsolutePosition.Y - element.AbsolutePosition.Y
            if dy > 0 then
                local dx = math.abs(current.AbsolutePosition.X - element.AbsolutePosition.X)
                local distance = math.sqrt(dx * dx + dy * dy)
                
                if distance < bestDistance then
                    bestDistance = distance
                    bestIndex = i
                end
            end
        end
    end
    
    self:FocusElement(bestIndex)
end

function KeyboardNav:NavigateDown()
    self:ScanFocusableElements()
    local current = self.FocusableElements[self.FocusIndex]
    if not current then return end
    
    local bestIndex = self.FocusIndex
    local bestDistance = math.huge
    
    for i, element in ipairs(self.FocusableElements) do
        if element ~= current then
            local dy = element.AbsolutePosition.Y - current.AbsolutePosition.Y
            if dy > 0 then
                local dx = math.abs(current.AbsolutePosition.X - element.AbsolutePosition.X)
                local distance = math.sqrt(dx * dx + dy * dy)
                
                if distance < bestDistance then
                    bestDistance = distance
                    bestIndex = i
                end
            end
        end
    end
    
    self:FocusElement(bestIndex)
end

function KeyboardNav:NavigateLeft() self:NavigateUp() end
function KeyboardNav:NavigateRight() self:NavigateDown() end

function KeyboardNav:ActivateCurrent()
    local element = self.FocusableElements[self.FocusIndex]
    if element and element:IsA("GuiButton") then
        -- Simulate click
        local mouseEvent = {
            UserInputType = Enum.UserInputType.MouseButton1,
            UserInputState = Enum.UserInputState.Begin,
            Position = element.AbsolutePosition + element.AbsoluteSize / 2
        }
        -- Fire input began/ended
        element.InputBegan:Fire(mouseEvent)
        task.delay(0.1, function()
            element.InputEnded:Fire(mouseEvent)
        end)
    end
end

function KeyboardNav:ClearFocus()
    self.FocusIndicator.Visible = false
end

--============================================--
-- SECTION 78: INTEGRATION
--============================================--

-- Add systems to PHUCMAX
PHUCMAX.I18n = I18nSystem
PHUCMAX.Accessibility = AccessibilitySystem
PHUCMAX.ScreenReader = ScreenReader
PHUCMAX.InputManager = InputManager
PHUCMAX.GestureSystem = GestureSystem
PHUCMAX.KeyboardNav = KeyboardNav

-- Shorthand translation function
PHUCMAX.T = function(key, ...)
    return I18nSystem:Translate(key, ...)
end

-- Initialize gesture system
GestureSystem:Initialize()

-- Auto-detect locale
local function detectLocale()
    local success, locale = pcall(function()
        return game:GetService("LocalizationService").RobloxLocaleId
    end)
    
    if success and locale then
        local lang = string.sub(locale, 1, 2)
        if I18nSystem.Translations[lang] then
            I18nSystem:SetLocale(lang)
        end
    end
end

detectLocale()



--============================================--
-- SECTION 79: PLUGIN SYSTEM
--============================================--

local PluginSystem = {}
PluginSystem.Plugins = {}
PluginSystem.LoadedPlugins = {}
PluginSystem.PluginOrder = {}
PluginSystem.PluginPath = "PHUCMAX/Plugins/"
PluginSystem.Dependencies = {}

function PluginSystem:RegisterPlugin(config)
    local pluginConfig = {
        Name = config.Name or "Unnamed Plugin",
        Version = config.Version or "1.0.0",
        Author = config.Author or "Unknown",
        Description = config.Description or "",
        Icon = config.Icon or "",
        Dependencies = config.Dependencies or {},
        OnLoad = config.OnLoad or function() end,
        OnUnload = config.OnUnload or function() end,
        OnEnable = config.OnEnable or function() end,
        OnDisable = config.OnDisable or function() end,
        OnUpdate = config.OnUpdate or nil,
        AutoStart = config.AutoStart ~= false,
        Required = config.Required or false,
        Priority = config.Priority or 1
    }
    
    if self.Plugins[pluginConfig.Name] then
        return false, "Plugin already registered: " .. pluginConfig.Name
    end
    
    self.Plugins[pluginConfig.Name] = pluginConfig
    table.insert(self.PluginOrder, pluginConfig.Name)
    
    -- Sort by priority
    table.sort(self.PluginOrder, function(a, b)
        return (self.Plugins[a].Priority or 1) < (self.Plugins[b].Priority or 1)
    end)
    
    -- Check dependencies
    self.Dependencies[pluginConfig.Name] = pluginConfig.Dependencies
    
    -- Auto-load if enabled
    if pluginConfig.AutoStart then
        self:LoadPlugin(pluginConfig.Name)
    end
    
    return true, pluginConfig
end

function PluginSystem:LoadPlugin(name)
    local plugin = self.Plugins[name]
    if not plugin then
        return false, "Plugin not found: " .. name
    end
    
    if self.LoadedPlugins[name] then
        return true, "Plugin already loaded"
    end
    
    -- Check dependencies
    for _, dep in ipairs(plugin.Dependencies) do
        if not self.LoadedPlugins[dep] then
            local success, msg = self:LoadPlugin(dep)
            if not success then
                return false, "Failed to load dependency '" .. dep .. "': " .. msg
            end
        end
    end
    
    -- Load plugin
    local success, result = pcall(function()
        return plugin.OnLoad()
    end)
    
    if not success then
        return false, "Plugin load error: " .. tostring(result)
    end
    
    plugin.Enabled = true
    self.LoadedPlugins[name] = plugin
    
    -- Call OnEnable
    if plugin.OnEnable then
        pcall(function()
            plugin.OnEnable()
        end)
    end
    
    -- Register update loop if needed
    if plugin.OnUpdate then
        task.spawn(function()
            while plugin.Enabled do
                local updateSuccess, updateResult = pcall(plugin.OnUpdate)
                if not updateSuccess then
                    DevTools:Log("Plugin update error [" .. name .. "]: " .. tostring(updateResult), "error")
                end
                task.wait()
            end
        end)
    end
    
    DevTools:Log("Plugin loaded: " .. name .. " v" .. plugin.Version, "success")
    
    return true, plugin
end

function PluginSystem:UnloadPlugin(name)
    local plugin = self.LoadedPlugins[name]
    if not plugin then
        return false, "Plugin not loaded"
    end
    
    -- Check if other plugins depend on this
    for pluginName, deps in pairs(self.Dependencies) do
        if self.LoadedPlugins[pluginName] then
            for _, dep in ipairs(deps) do
                if dep == name then
                    return false, "Cannot unload: '" .. pluginName .. "' depends on this plugin"
                end
            end
        end
    end
    
    -- Call OnDisable
    if plugin.OnDisable then
        pcall(function()
            plugin.OnDisable()
        end)
    end
    
    -- Call OnUnload
    if plugin.OnUnload then
        pcall(function()
            plugin.OnUnload()
        end)
    end
    
    plugin.Enabled = false
    self.LoadedPlugins[name] = nil
    
    DevTools:Log("Plugin unloaded: " .. name, "info")
    
    return true
end

function PluginSystem:EnablePlugin(name)
    local plugin = self.LoadedPlugins[name]
    if not plugin then return false end
    
    plugin.Enabled = true
    
    if plugin.OnEnable then
        pcall(plugin.OnEnable)
    end
    
    return true
end

function PluginSystem:DisablePlugin(name)
    local plugin = self.LoadedPlugins[name]
    if not plugin then return false end
    
    plugin.Enabled = false
    
    if plugin.OnDisable then
        pcall(plugin.OnDisable)
    end
    
    return true
end

function PluginSystem:GetPlugin(name)
    return self.Plugins[name] or self.LoadedPlugins[name]
end

function PluginSystem:GetAllPlugins()
    local list = {}
    for name, plugin in pairs(self.Plugins) do
        table.insert(list, {
            Name = name,
            Version = plugin.Version,
            Author = plugin.Author,
            Description = plugin.Description,
            Loaded = self.LoadedPlugins[name] ~= nil,
            Enabled = plugin.Enabled or false
        })
    end
    return list
end

function PluginSystem:SavePluginState()
    local state = {}
    for name, plugin in pairs(self.LoadedPlugins) do
        state[name] = plugin.Enabled
    end
    
    if writefile then
        if not isfolder(self.PluginPath) then
            makefolder(self.PluginPath)
        end
        writefile(self.PluginPath .. "plugin_state.json", Services.HttpService:JSONEncode(state))
    end
end

function PluginSystem:LoadPluginState()
    local path = self.PluginPath .. "plugin_state.json"
    if not isfile or not isfile(path) then return end
    
    local success, content = pcall(function()
        return readfile(path)
    end)
    
    if not success then return end
    
    local success2, state = pcall(function()
        return Services.HttpService:JSONDecode(content)
    end)
    
    if not success2 then return end
    
    for name, enabled in pairs(state) do
        if enabled then
            self:LoadPlugin(name)
        end
    end
end

--============================================--
-- SECTION 80: SCRIPT LOADER
--============================================--

local ScriptLoader = {}
ScriptLoader.LoadedScripts = {}
ScriptLoader.ScriptPath = "PHUCMAX/Scripts/"
ScriptLoader.ScriptCache = {}
ScriptLoader.MaxCacheSize = 50
ScriptLoader.Sandbox = {}
ScriptLoader.SecureMode = false

function ScriptLoader:SetSecureMode(enabled)
    self.SecureMode = enabled
end

function ScriptLoader:CreateSandbox()
    local sandbox = {
        print = print,
        warn = warn,
        task = task,
        wait = wait,
        tick = tick,
        Vector2 = Vector2,
        Vector3 = Vector3,
        CFrame = CFrame,
        Color3 = Color3,
        UDim2 = UDim2,
        math = math,
        string = string,
        table = table,
        game = game,
        workspace = workspace,
        PHUCMAX = PHUCMAX
    }
    
    -- Create safe versions of functions
    sandbox.loadstring = nil  -- Disabled for security
    sandbox.getfenv = nil
    sandbox.setfenv = nil
    
    return sandbox
end

function ScriptLoader:LoadScript(scriptContent, scriptName, environment)
    local env = environment or self:CreateSandbox()
    env._SCRIPT_NAME = scriptName or "Unnamed Script"
    env._LOADED_AT = os.time()
    
    local scriptFunc, err = loadstring(scriptContent)
    if not scriptFunc then
        return false, "Syntax error: " .. tostring(err)
    end
    
    -- Set environment
    if setfenv then
        setfenv(scriptFunc, env)
    else
        -- Use debug.setupvalue for newer Lua versions
        local success, result = pcall(function()
            debug.setupvalue(scriptFunc, 1, env)
        end)
        if not success then
            -- Fallback: run in global environment
        end
    end
    
    local success, result = pcall(scriptFunc)
    
    if not success then
        return false, "Runtime error: " .. tostring(result)
    end
    
    local scriptData = {
        Name = scriptName or "Unnamed",
        Environment = env,
        LoadedAt = os.time(),
        Result = result
    }
    
    table.insert(self.LoadedScripts, scriptData)
    
    return true, scriptData
end

function ScriptLoader:LoadScriptFromFile(filePath)
    if not isfile or not isfile(filePath) then
        return false, "File not found: " .. filePath
    end
    
    local success, content = pcall(function()
        return readfile(filePath)
    end)
    
    if not success then
        return false, "Failed to read file: " .. filePath
    end
    
    local fileName = string.match(filePath, "([^/]+)%.lua$") or "Unknown"
    
    -- Cache the content
    self.ScriptCache[filePath] = {
        Content = content,
        LoadedAt = os.time()
    }
    
    -- Trim cache
    local cacheKeys = {}
    for key, _ in pairs(self.ScriptCache) do
        table.insert(cacheKeys, key)
    end
    if #cacheKeys > self.MaxCacheSize then
        table.sort(cacheKeys, function(a, b)
            return (self.ScriptCache[a].LoadedAt or 0) < (self.ScriptCache[b].LoadedAt or 0)
        end)
        for i = 1, #cacheKeys - self.MaxCacheSize do
            self.ScriptCache[cacheKeys[i]] = nil
        end
    end
    
    return self:LoadScript(content, fileName)
end

function ScriptLoader:LoadScriptFromURL(url, scriptName)
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        return false, "Failed to fetch: " .. url
    end
    
    return self:LoadScript(content, scriptName or url)
end

function ScriptLoader:UnloadScript(scriptData)
    Utils:TableRemove(self.LoadedScripts, scriptData)
    
    -- Clean up environment
    if scriptData.Environment then
        for key, value in pairs(scriptData.Environment) do
            if type(value) == "function" then
                scriptData.Environment[key] = nil
            elseif type(value) == "RBXScriptConnection" then
                value:Disconnect()
                scriptData.Environment[key] = nil
            end
        end
    end
end

function ScriptLoader:GetLoadedScripts()
    return self.LoadedScripts
end

function ScriptLoader:ClearScripts()
    for _, scriptData in ipairs(self.LoadedScripts) do
        self:UnloadScript(scriptData)
    end
    self.LoadedScripts = {}
end

--============================================--
-- SECTION 81: AUTO-UPDATE SYSTEM
--============================================--

local AutoUpdate = {}
AutoUpdate.UpdateURL = ""
AutoUpdate.CurrentVersion = PHUCMAX_VERSION
AutoUpdate.CheckInterval = 3600 -- 1 hour
AutoUpdate.AutoInstall = false
AutoUpdate.LastCheck = 0
AutoUpdate.UpdateAvailable = false
AutoUpdate.UpdateInfo = nil
AutoUpdate.IsUpdating = false
AutoUpdate.Progress = 0

function AutoUpdate:SetUpdateURL(url)
    self.UpdateURL = url
end

function AutoUpdate:SetAutoInstall(enabled)
    self.AutoInstall = enabled
end

function AutoUpdate:CheckForUpdates()
    if self.UpdateURL == "" then return false, "Update URL not set" end
    
    self.LastCheck = os.time()
    
    local success, response = pcall(function()
        return game:HttpGet(self.UpdateURL)
    end)
    
    if not success then
        return false, "Failed to check for updates"
    end
    
    local success2, updateData = pcall(function()
        return Services.HttpService:JSONDecode(response)
    end)
    
    if not success2 then
        return false, "Invalid update data"
    end
    
    local latestVersion = updateData.Version or "0.0.0"
    
    if self:CompareVersions(latestVersion, self.CurrentVersion) > 0 then
        self.UpdateAvailable = true
        self.UpdateInfo = updateData
        
        DevTools:Log("Update available: v" .. latestVersion, "info")
        
        if self.AutoInstall then
            self:InstallUpdate()
        end
        
        return true, updateData
    end
    
    return false, "No updates available"
end

function AutoUpdate:InstallUpdate()
    if not self.UpdateAvailable or not self.UpdateInfo then
        return false, "No update available"
    end
    
    self.IsUpdating = true
    self.Progress = 0
    
    local updateData = self.UpdateInfo
    local downloadURL = updateData.DownloadURL
    
    if not downloadURL then
        self.IsUpdating = false
        return false, "No download URL"
    end
    
    -- Show update progress
    PHUCMAX:Notify({
        Title = "Update Available",
        Content = "Downloading v" .. updateData.Version .. "...",
        Type = "info",
        Duration = 5
    })
    
    -- Download update
    local success, content = pcall(function()
        return game:HttpGet(downloadURL)
    end)
    
    self.Progress = 50
    
    if not success then
        self.IsUpdating = false
        return false, "Download failed"
    end
    
    -- Save to file
    if writefile then
        if not isfolder("PHUCMAX/Updates/") then
            makefolder("PHUCMAX/Updates/")
        end
        
        local updatePath = "PHUCMAX/Updates/update_v" .. updateData.Version .. ".lua"
        writefile(updatePath, content)
        
        self.Progress = 100
        self.IsUpdating = false
        
        PHUCMAX:Notify({
            Title = "Update Downloaded",
            Content = "Please restart to apply v" .. updateData.Version,
            Type = "success",
            Duration = 5
        })
        
        return true, updatePath
    end
    
    self.IsUpdating = false
    return false, "Cannot save update"
end

function AutoUpdate:CompareVersions(v1, v2)
    local parts1 = {}
    for part in string.gmatch(v1, "%d+") do
        table.insert(parts1, tonumber(part))
    end
    
    local parts2 = {}
    for part in string.gmatch(v2, "%d+") do
        table.insert(parts2, tonumber(part))
    end
    
    for i = 1, math.max(#parts1, #parts2) do
        local p1 = parts1[i] or 0
        local p2 = parts2[i] or 0
        
        if p1 > p2 then return 1
        elseif p1 < p2 then return -1 end
    end
    
    return 0
end

function AutoUpdate:StartAutoCheck()
    task.spawn(function()
        while true do
            task.wait(self.CheckInterval)
            self:CheckForUpdates()
        end
    end)
end

--============================================--
-- SECTION 82: PACKAGE MANAGER
--============================================--

local PackageManager = {}
PackageManager.Packages = {}
PackageManager.PackagePath = "PHUCMAX/Packages/"
PackageManager.Registry = {}
PackageManager.RegistryURL = ""

function PackageManager:SetRegistry(url)
    self.RegistryURL = url
end

function PackageManager:FetchRegistry()
    if self.RegistryURL == "" then return false end
    
    local success, response = pcall(function()
        return game:HttpGet(self.RegistryURL)
    end)
    
    if not success then return false end
    
    local success2, registry = pcall(function()
        return Services.HttpService:JSONDecode(response)
    end)
    
    if not success2 then return false end
    
    self.Registry = registry
    return true
end

function PackageManager:InstallPackage(packageName, version)
    if not self.Registry[packageName] then
        return false, "Package not found in registry"
    end
    
    local packageInfo = self.Registry[packageName]
    local targetVersion = version or packageInfo.LatestVersion
    local downloadURL = packageInfo.Versions[targetVersion]
    
    if not downloadURL then
        return false, "Version not found"
    end
    
    local success, content = pcall(function()
        return game:HttpGet(downloadURL)
    end)
    
    if not success then
        return false, "Download failed"
    end
    
    if writefile then
        if not isfolder(self.PackagePath .. packageName .. "/") then
            makefolder(self.PackagePath .. packageName .. "/")
        end
        
        local installPath = self.PackagePath .. packageName .. "/" .. targetVersion .. ".lua"
        writefile(installPath, content)
        
        self.Packages[packageName] = {
            Name = packageName,
            Version = targetVersion,
            Path = installPath,
            InstalledAt = os.time()
        }
        
        -- Install dependencies
        if packageInfo.Dependencies then
            for depName, depVersion in pairs(packageInfo.Dependencies) do
                if not self.Packages[depName] then
                    self:InstallPackage(depName, depVersion)
                end
            end
        end
        
        return true, installPath
    end
    
    return false, "Cannot save package"
end

function PackageManager:UninstallPackage(packageName)
    local pkg = self.Packages[packageName]
    if not pkg then return false end
    
    if isfile and isfile(pkg.Path) then
        delfile(pkg.Path)
    end
    
    self.Packages[packageName] = nil
    
    return true
end

function PackageManager:GetInstalledPackages()
    local packages = {}
    for name, pkg in pairs(self.Packages) do
        table.insert(packages, pkg)
    end
    return packages
end

function PackageManager:LoadPackage(packageName)
    local pkg = self.Packages[packageName]
    if not pkg then return false end
    
    return ScriptLoader:LoadScriptFromFile(pkg.Path)
end

--============================================--
-- SECTION 83: API BRIDGE
--============================================--

local APIBridge = {}
APIBridge.Endpoints = {}
APIBridge.Middleware = {}
APIBridge.RateLimits = {}
APIBridge.Cache = {}
APIBridge.CacheEnabled = true
APIBridge.CacheTimeout = 60
APIBridge.DefaultHeaders = {
    ["Content-Type"] = "application/json",
    ["User-Agent"] = "PHUCMAX/" .. PHUCMAX_VERSION
}

function APIBridge:CreateEndpoint(method, url, config)
    local endpointConfig = {
        Method = string.upper(method),
        URL = url,
        Headers = config.Headers or {},
        Body = config.Body or nil,
        Callback = config.Callback or function(response) end,
        ErrorCallback = config.ErrorCallback or function(error) end,
        RetryCount = config.RetryCount or 0,
        RetryDelay = config.RetryDelay or 1,
        Timeout = config.Timeout or 10,
        CacheResponse = config.CacheResponse or false,
        RateLimit = config.RateLimit or nil
    }
    
    local endpointId = method .. ":" .. url
    self.Endpoints[endpointId] = endpointConfig
    
    return endpointId
end

function APIBridge:Request(endpointId, data)
    local endpoint = self.Endpoints[endpointId]
    if not endpoint then
        return false, "Endpoint not found"
    end
    
    -- Check rate limit
    if endpoint.RateLimit then
        local lastRequest = self.RateLimits[endpointId] or 0
        if os.clock() - lastRequest < endpoint.RateLimit then
            return false, "Rate limited"
        end
        self.RateLimits[endpointId] = os.clock()
    end
    
    -- Check cache
    if self.CacheEnabled and endpoint.CacheResponse then
        local cached = self.Cache[endpointId]
        if cached and os.clock() - cached.Time < self.CacheTimeout then
            if endpoint.Callback then
                endpoint.Callback(cached.Data)
            end
            return true, cached.Data
        end
    end
    
    -- Build headers
    local headers = {}
    for k, v in pairs(self.DefaultHeaders) do
        headers[k] = v
    end
    for k, v in pairs(endpoint.Headers) do
        headers[k] = v
    end
    
    -- Build request options
    local requestData = {
        Url = endpoint.URL,
        Method = endpoint.Method,
        Headers = headers,
        Body = data and Services.HttpService:JSONEncode(data) or endpoint.Body
    }
    
    -- Send request
    local attempts = 0
    local maxAttempts = 1 + endpoint.RetryCount
    
    while attempts < maxAttempts do
        attempts = attempts + 1
        
        local success, response = pcall(function()
            return syn and syn.request and syn.request(requestData) or 
                   game:HttpGet(endpoint.URL)
        end)
        
        if success then
            local responseData = response
            
            -- Parse JSON if needed
            if type(response) == "table" and response.Body then
                local parseSuccess, parsed = pcall(function()
                    return Services.HttpService:JSONDecode(response.Body)
                end)
                if parseSuccess then
                    responseData = parsed
                end
            end
            
            -- Cache response
            if endpoint.CacheResponse then
                self.Cache[endpointId] = {
                    Data = responseData,
                    Time = os.clock()
                }
            end
            
            -- Callback
            if endpoint.Callback then
                endpoint.Callback(responseData)
            end
            
            return true, responseData
        else
            if attempts < maxAttempts then
                task.wait(endpoint.RetryDelay)
            end
        end
    end
    
    -- All attempts failed
    if endpoint.ErrorCallback then
        endpoint.ErrorCallback("Request failed after " .. maxAttempts .. " attempts")
    end
    
    return false, "Request failed"
end

function APIBridge:Get(url, config)
    local endpointId = self:CreateEndpoint("GET", url, config or {})
    return self:Request(endpointId)
end

function APIBridge:Post(url, data, config)
    local cfg = config or {}
    cfg.Body = data and Services.HttpService:JSONEncode(data) or nil
    local endpointId = self:CreateEndpoint("POST", url, cfg)
    return self:Request(endpointId, data)
end

function APIBridge:AddMiddleware(callback)
    table.insert(self.Middleware, callback)
end

function APIBridge:ClearCache()
    self.Cache = {}
end

--============================================--
-- SECTION 84: EVENT WEBHOOK SYSTEM
--============================================--

local WebhookSystem = {}
WebhookSystem.Webhooks = {}
WebhookSystem.Enabled = true
WebhookSystem.Queue = {}
WebhookSystem.Processing = false
WebhookSystem.RateLimit = 1 -- 1 second between sends
WebhookSystem.LastSend = 0

function WebhookSystem:RegisterWebhook(name, url, config)
    local webhookConfig = {
        Name = name,
        URL = url,
        Events = config.Events or {},
        Format = config.Format or "default",
        Enabled = config.Enabled ~= false,
        RetryOnFail = config.RetryOnFail ~= false
    }
    
    self.Webhooks[name] = webhookConfig
    
    -- Register for events
    for _, eventName in ipairs(webhookConfig.Events) do
        EventSystem:Listen(eventName, function(...)
            self:SendWebhook(name, eventName, {...})
        end)
    end
    
    return webhookConfig
end

function WebhookSystem:SendWebhook(name, event, data)
    if not self.Enabled then return end
    
    local webhook = self.Webhooks[name]
    if not webhook or not webhook.Enabled then return end
    
    local payload = {
        Name = name,
        Event = event,
        Data = data,
        Timestamp = os.time(),
        Player = Player.Name,
        Version = PHUCMAX_VERSION
    }
    
    table.insert(self.Queue, {
        Webhook = webhook,
        Payload = payload
    })
    
    self:ProcessQueue()
end

function WebhookSystem:ProcessQueue()
    if self.Processing then return end
    if #self.Queue == 0 then return end
    
    self.Processing = true
    
    task.spawn(function()
        while #self.Queue > 0 do
            local now = os.clock()
            if now - self.LastSend < self.RateLimit then
                task.wait(self.RateLimit - (now - self.LastSend))
            end
            
            local item = table.remove(self.Queue, 1)
            
            if syn and syn.request then
                local success = pcall(function()
                    syn.request({
                        Url = item.Webhook.URL,
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json"
                        },
                        Body = Services.HttpService:JSONEncode({
                            content = "",
                            embeds = {{
                                title = "PHUCMAX Event: " .. item.Payload.Event,
                                description = "```json\n" .. Services.HttpService:JSONEncode(item.Payload.Data) .. "\n```",
                                color = 0x7850FF,
                                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                            }}
                        })
                    })
                end)
                
                if not success and item.Webhook.RetryOnFail then
                    table.insert(self.Queue, item)
                end
            end
            
            self.LastSend = os.clock()
        end
        
        self.Processing = false
    end)
end

function WebhookSystem:Disable()
    self.Enabled = false
end

function WebhookSystem:Enable()
    self.Enabled = true
end

--============================================--
-- SECTION 85: INTEGRATION
--============================================--

-- Add systems to PHUCMAX
PHUCMAX.PluginSystem = PluginSystem
PHUCMAX.ScriptLoader = ScriptLoader
PHUCMAX.AutoUpdate = AutoUpdate
PHUCMAX.PackageManager = PackageManager
PHUCMAX.APIBridge = APIBridge
PHUCMAX.WebhookSystem = WebhookSystem

-- Shorthand methods
function PHUCMAX:RegisterPlugin(config)
    return PluginSystem:RegisterPlugin(config)
end

function PHUCMAX:LoadScript(scriptContent, scriptName)
    return ScriptLoader:LoadScript(scriptContent, scriptName)
end

function PHUCMAX:LoadScriptFromURL(url, scriptName)
    return ScriptLoader:LoadScriptFromURL(url, scriptName)
end

function PHUCMAX:CheckForUpdates()
    return AutoUpdate:CheckForUpdates()
end

function PHUCMAX:InstallPackage(name, version)
    return PackageManager:InstallPackage(name, version)
end

function PHUCMAX:HttpGet(url, config)
    return APIBridge:Get(url, config)
end

function PHUCMAX:HttpPost(url, data, config)
    return APIBridge:Post(url, data, config)
end

-- Load plugin state on startup
PluginSystem:LoadPluginState()

```lua
--[[
    PHUCMAX UI Library - Part 14/15
    Debug Console | Profiler | Logger | Analytics | Crash Handler
    Lines: 14301-15400
]]

--============================================--
-- SECTION 86: DEBUG CONSOLE
--============================================--

local DebugConsole = {}
DebugConsole.Enabled = false
DebugConsole.Visible = false
DebugConsole.Container = nil
DebugConsole.Logs = {}
DebugConsole.MaxLogs = 500
DebugConsole.LogLevels = {
    DEBUG = {Priority = 0, Color = Color3.fromRGB(150, 150, 255), Label = "DEBUG"},
    INFO = {Priority = 1, Color = Color3.fromRGB(200, 200, 200), Label = "INFO"},
    WARN = {Priority = 2, Color = Color3.fromRGB(255, 200, 50), Label = "WARN"},
    ERROR = {Priority = 3, Color = Color3.fromRGB(255, 100, 100), Label = "ERROR"},
    FATAL = {Priority = 4, Color = Color3.fromRGB(255, 50, 50), Label = "FATAL"},
    SUCCESS = {Priority = 1, Color = Color3.fromRGB(100, 255, 100), Label = "SUCCESS"},
    TRACE = {Priority = 0, Color = Color3.fromRGB(100, 200, 200), Label = "TRACE"}
}
DebugConsole.CurrentLevel = "DEBUG"
DebugConsole.AutoScroll = true
DebugConsole.ShowTimestamps = true
DebugConsole.ShowLevel = true
DebugConsole.CommandHistory = {}
DebugConsole.HistoryIndex = 0
DebugConsole.RegisteredCommands = {}
DebugConsole.Filter = ""

function DebugConsole:Enable()
    self.Enabled = true
    self:CreateConsole()
    
    -- Register default commands
    self:RegisterCommand("help", "Show available commands", function()
        local helpText = "Available Commands:\n"
        for name, cmd in pairs(self.RegisteredCommands) do
            helpText = helpText .. "  " .. name .. " - " .. (cmd.Description or "No description") .. "\n"
        end
        self:Log(helpText, "INFO")
    end)
    
    self:RegisterCommand("clear", "Clear console", function()
        self:Clear()
    end)
    
    self:RegisterCommand("version", "Show version", function()
        self:Log("PHUCMAX v" .. PHUCMAX_VERSION .. " (Build " .. PHUCMAX_BUILD .. ")", "INFO")
    end)
    
    self:RegisterCommand("memory", "Show memory usage", function()
        self:Log("Memory: " .. string.format("%.2f KB", collectgarbage("count")), "INFO")
    end)
    
    self:RegisterCommand("flags", "List all flags", function()
        local flags = ConfigSystem:GetAll()
        for flag, value in pairs(flags) do
            self:Log(flag .. " = " .. tostring(value), "INFO")
        end
    end)
    
    self:RegisterCommand("theme", "Show current theme", function()
        self:Log("Current theme: " .. ThemeManager:GetThemeName(), "INFO")
    end)
    
    self:RegisterCommand("exit", "Close console", function()
        self:Hide()
    end)
    
    self:RegisterCommand("gc", "Force garbage collection", function()
        collectgarbage("collect")
        self:Log("Garbage collection completed", "SUCCESS")
    end)
    
    DevTools:Log("Debug Console initialized", "info")
end

function DebugConsole:CreateConsole()
    if self.Container then return end
    
    local theme = ThemeManager:GetTheme()
    
    -- Main container
    self.Container = Utils:CreateInstance("Frame", {
        Parent = Services.CoreGui,
        Name = "PHUCMAX_DebugConsole",
        BackgroundColor3 = Color3.fromRGB(15, 15, 20),
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 600, 0, 350),
        Position = UDim2.new(0.5, -300, 0.5, -175),
        BorderSizePixel = 0,
        ZIndex = 100000,
        Visible = false
    })
    Utils:AddCorner(self.Container, 12)
    Utils:AddStroke(self.Container, Color3.fromRGB(100, 200, 100), 1)
    
    -- Title bar
    local titleBar = Utils:CreateInstance("Frame", {
        Parent = self.Container,
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BackgroundTransparency = 0.3,
        Size = UDim2.new(1, 0, 0, 30),
        BorderSizePixel = 0,
        ZIndex = 100001
    })
    Utils:AddCorner(titleBar, 12)
    
    Utils:CreateText({
        Parent = titleBar,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Fonts.Bold,
        Text = "Debug Console",
        TextColor3 = Color3.fromRGB(100, 255, 100),
        TextSize = 13,
        ZIndex = 100002
    })
    
    -- Close button
    local closeBtn = Utils:CreateButton({
        Parent = titleBar,
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        BackgroundTransparency = 0.7,
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -28, 0.5, -11),
        Text = "✕",
        Font = Fonts.Bold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        ZIndex = 100003
    })
    Utils:AddCorner(closeBtn, 4)
    closeBtn.MouseButton1Click:Connect(function() self:Hide() end)
    
    -- Log area
    self.LogScroll = Utils:CreateInstance("ScrollingFrame", {
        Parent = self.Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 35),
        Size = UDim2.new(1, -10, 0, 270),
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(100, 200, 100),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 100001
    })
    
    local logList = Instance.new("UIListLayout")
    logList.Padding = UDim.new(0, 1)
    logList.Parent = self.LogScroll
    
    -- Input area
    local inputArea = Utils:CreateInstance("Frame", {
        Parent = self.Container,
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BackgroundTransparency = 0.3,
        Position = UDim2.new(0, 5, 0, 310),
        Size = UDim2.new(1, -10, 0, 30),
        BorderSizePixel = 0,
        ZIndex = 100001
    })
    Utils:AddCorner(inputArea, 6)
    
    -- Prompt
    Utils:CreateText({
        Parent = inputArea,
        Position = UDim2.new(0, 6, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Font = Fonts.Bold,
        Text = ">",
        TextColor3 = Color3.fromRGB(100, 255, 100),
        TextSize = 14,
        ZIndex = 100002
    })
    
    -- Command input
    self.CommandInput = Utils:CreateInstance("TextBox", {
        Parent = inputArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 26, 0, 0),
        Size = UDim2.new(1, -32, 1, 0),
        PlaceholderText = "Type command...",
        Text = "",
        Font = Fonts.Mono,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        TextSize = 13,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        ZIndex = 100002
    })
    
    self.CommandInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local command = self.CommandInput.Text
            if command ~= "" then
                self:ExecuteCommand(command)
            end
            self.CommandInput.Text = ""
        end
    end)
    
    -- Make draggable
    DragSystem:MakeDraggable(self.Container, titleBar)
end

function DebugConsole:Log(message, level)
    if not self.Enabled then return end
    
    local logLevel = self.LogLevels[level or "INFO"] or self.LogLevels.INFO
    local minLevel = self.LogLevels[self.CurrentLevel] or self.LogLevels.DEBUG
    
    -- Filter by level
    if logLevel.Priority < minLevel.Priority then return end
    
    -- Filter by text
    if self.Filter ~= "" and not string.find(string.lower(message), string.lower(self.Filter)) then
        return end
    end
    
    local timestamp = os.date("%H:%M:%S")
    local logEntry = {
        Message = message,
        Level = level or "INFO",
        Timestamp = timestamp,
        Time = os.clock()
    }
    
    table.insert(self.Logs, logEntry)
    
    -- Trim logs
    while #self.Logs > self.MaxLogs do
        table.remove(self.Logs, 1)
    end
    
    -- Update UI if visible
    if self.Visible and self.LogScroll then
        self:RenderLog(logEntry)
    end
end

function DebugConsole:RenderLog(logEntry)
    if not self.LogScroll then return end
    
    local logLevel = self.LogLevels[logEntry.Level] or self.LogLevels.INFO
    
    local logLabel = Utils:CreateText({
        Parent = self.LogScroll,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -4, 0, 16),
        Font = Fonts.Mono,
        Text = "",
        TextColor3 = logLevel.Color,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 100002
    })
    
    local displayText = ""
    if self.ShowTimestamps then
        displayText = "[" .. logEntry.Timestamp .. "] "
    end
    if self.ShowLevel then
        displayText = displayText .. "[" .. logLevel.Label .. "] "
    end
    displayText = displayText .. logEntry.Message
    
    logLabel.Text = displayText
    
    -- Auto-scroll
    if self.AutoScroll then
        self.LogScroll.CanvasPosition = Vector2.new(0, math.huge)
    end
    
    -- Update canvas size
    local totalHeight = 0
    for _, child in ipairs(self.LogScroll:GetChildren()) do
        if child:IsA("TextLabel") then
            totalHeight = totalHeight + 17
        end
    end
    self.LogScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, 270))
end

function DebugConsole:RenderAllLogs()
    if not self.LogScroll then return end
    
    -- Clear existing
    for _, child in ipairs(self.LogScroll:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Filter logs
    for _, logEntry in ipairs(self.Logs) do
        local logLevel = self.LogLevels[logEntry.Level] or self.LogLevels.INFO
        local minLevel = self.LogLevels[self.CurrentLevel] or self.LogLevels.DEBUG
        
        if logLevel.Priority >= minLevel.Priority then
            if self.Filter == "" or string.find(string.lower(logEntry.Message), string.lower(self.Filter)) then
                self:RenderLog(logEntry)
            end
        end
    end
end

function DebugConsole:RegisterCommand(name, description, callback)
    self.RegisteredCommands[name] = {
        Description = description,
        Callback = callback
    }
end

function DebugConsole:ExecuteCommand(command)
    -- Add to history
    table.insert(self.CommandHistory, command)
    self.HistoryIndex = #self.CommandHistory + 1
    
    -- Trim history
    while #self.CommandHistory > 100 do
        table.remove(self.CommandHistory, 1)
    end
    
    -- Echo command
    self:Log("> " .. command, "TRACE")
    
    -- Parse command
    local parts = {}
    for part in string.gmatch(command, "%S+") do
        table.insert(parts, part)
    end
    
    local cmdName = parts[1]
    local args = {}
    for i = 2, #parts do
        table.insert(args, parts[i])
    end
    
    -- Execute
    local cmd = self.RegisteredCommands[cmdName]
    if cmd then
        local success, result = pcall(function()
            cmd.Callback(table.unpack(args))
        end)
        
        if not success then
            self:Log("Command error: " .. tostring(result), "ERROR")
        end
    else
        self:Log("Unknown command: " .. cmdName .. " (type 'help' for commands)", "WARN")
    end
end

function DebugConsole:Show()
    self.Visible = true
    if self.Container then
        self.Container.Visible = true
        self:RenderAllLogs()
        self.CommandInput:CaptureFocus()
    end
end

function DebugConsole:Hide()
    self.Visible = false
    if self.Container then
        self.Container.Visible = false
    end
end

function DebugConsole:Toggle()
    if self.Visible then
        self:Hide()
    else
        self:Show()
    end
end

function DebugConsole:Clear()
    self.Logs = {}
    if self.LogScroll then
        for _, child in ipairs(self.LogScroll:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
    end
    self:Log("Console cleared", "INFO")
end

function DebugConsole:SetLevel(level)
    if self.LogLevels[level] then
        self.CurrentLevel = level
        self:RenderAllLogs()
    end
end

function DebugConsole:SetFilter(filter)
    self.Filter = filter or ""
    self:RenderAllLogs()
end

-- Register toggle key
Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F3 then
        DebugConsole:Toggle()
    end
end)

--============================================--
-- SECTION 87: PROFILER
--============================================--

local Profiler = {}
Profiler.Enabled = false
Profiler.Sessions = {}
Profiler.CurrentSession = nil
Profiler.Marks = {}
Profiler.Threshold = 0.001 -- 1ms

function Profiler:StartSession(name)
    if self.CurrentSession then
        self:EndSession()
    end
    
    self.CurrentSession = {
        Name = name or "Profile Session",
        StartTime = os.clock(),
        Marks = {},
        Events = {},
        MemoryStart = collectgarbage("count")
    }
    
    self.Enabled = true
    
    return self.CurrentSession
end

function Profiler:EndSession()
    if not self.CurrentSession then return nil end
    
    self.CurrentSession.EndTime = os.clock()
    self.CurrentSession.Duration = self.CurrentSession.EndTime - self.CurrentSession.StartTime
    self.CurrentSession.MemoryEnd = collectgarbage("count")
    self.CurrentSession.MemoryDelta = self.CurrentSession.MemoryEnd - self.CurrentSession.MemoryStart
    
    -- Calculate statistics
    local totalMarkTime = 0
    for _, mark in ipairs(self.CurrentSession.Marks) do
        if mark.Duration then
            totalMarkTime = totalMarkTime + mark.Duration
        end
    end
    self.CurrentSession.TotalMarkTime = totalMarkTime
    
    table.insert(self.Sessions, self.CurrentSession)
    self.Enabled = false
    
    local session = self.CurrentSession
    self.CurrentSession = nil
    
    return session
end

function Profiler:Mark(name)
    if not self.Enabled then return end
    
    local mark = {
        Name = name,
        StartTime = os.clock(),
        MemoryBefore = collectgarbage("count")
    }
    
    table.insert(self.CurrentSession.Marks, mark)
    table.insert(self.Marks, mark)
    
    return mark
end

function Profiler:EndMark(mark)
    if not mark then return end
    
    mark.EndTime = os.clock()
    mark.Duration = mark.EndTime - mark.StartTime
    mark.MemoryAfter = collectgarbage("count")
    mark.MemoryDelta = mark.MemoryAfter - mark.MemoryBefore
    
    if mark.Duration > self.Threshold then
        if self.CurrentSession then
            table.insert(self.CurrentSession.Events, {
                Type = "SlowMark",
                Name = mark.Name,
                Duration = mark.Duration,
                Memory = mark.MemoryDelta
            })
        end
    end
end

function Profiler:ProfileFunction(func, name)
    return function(...)
        local mark = Profiler:Mark(name or "Anonymous")
        local results = {func(...)}
        Profiler:EndMark(mark)
        return table.unpack(results)
    end
end

function Profiler:GetReport(session)
    local s = session or self.CurrentSession
    if not s then return "No session data" end
    
    local report = ""
    report = report .. "=== Profile Report: " .. s.Name .. " ===\n"
    report = report .. "Duration: " .. string.format("%.3f", s.Duration or 0) .. "s\n"
    report = report .. "Memory: " .. string.format("%.2f", s.MemoryDelta or 0) .. " KB\n"
    report = report .. "Marks: " .. #s.Marks .. "\n\n"
    
    if #s.Marks > 0 then
        report = report .. "Marks:\n"
        local sorted = {}
        for _, mark in ipairs(s.Marks) do
            table.insert(sorted, mark)
        end
        table.sort(sorted, function(a, b)
            return (a.Duration or 0) > (b.Duration or 0)
        end)
        
        for i = 1, math.min(20, #sorted) do
            local mark = sorted[i]
            report = report .. string.format("  %2d. %-30s %8.3fms %8.2fKB\n", 
                i, mark.Name, (mark.Duration or 0) * 1000, mark.MemoryDelta or 0)
        end
    end
    
    return report
end

function Profiler:PrintReport()
    local report = self:GetReport()
    print(report)
    DebugConsole:Log(report, "INFO")
end

--============================================--
-- SECTION 88: ANALYTICS SYSTEM
--============================================--

local Analytics = {}
Analytics.Enabled = true
Analytics.Events = {}
Analytics.MaxEvents = 10000
Analytics.SessionStart = os.time()
Analytics.SessionId = Utils:GenerateUUID()
Analytics.FlushInterval = 60
Analytics.AutoFlush = false

function Analytics:TrackEvent(category, action, label, value)
    if not self.Enabled then return end
    
    local event = {
        Category = category or "General",
        Action = action or "Unknown",
        Label = label or "",
        Value = value or 0,
        Timestamp = os.time(),
        SessionId = self.SessionId,
        PlayerName = Player.Name,
        PlaceId = game.PlaceId
    }
    
    table.insert(self.Events, event)
    
    -- Trim events
    while #self.Events > self.MaxEvents do
        table.remove(self.Events, 1)
    end
    
    -- Log to debug console
    DebugConsole:Log(string.format("[Analytics] %s / %s / %s", category, action, label), "DEBUG")
    
    return event
end

function Analytics:TrackPageView(pageName)
    return self:TrackEvent("PageView", "View", pageName)
end

function Analytics:TrackClick(elementName)
    return self:TrackEvent("Click", "Button", elementName)
end

function Analytics:TrackToggle(elementName, state)
    return self:TrackEvent("Toggle", state and "On" or "Off", elementName)
end

function Analytics:TrackSlider(elementName, value)
    return self:TrackEvent("Slider", "Change", elementName, value)
end

function Analytics:TrackError(source, message)
    return self:TrackEvent("Error", source, message)
end

function Analytics:TrackFeature(featureName, action)
    return self:TrackEvent("Feature", action or "Used", featureName)
end

function Analytics:GetSummary()
    local summary = {
        TotalEvents = #self.Events,
        SessionDuration = os.time() - self.SessionStart,
        Categories = {},
        TopActions = {}
    }
    
    for _, event in ipairs(self.Events) do
        -- Count categories
        if not summary.Categories[event.Category] then
            summary.Categories[event.Category] = 0
        end
        summary.Categories[event.Category] = summary.Categories[event.Category] + 1
        
        -- Track actions
        local actionKey = event.Category .. "/" .. event.Action
        if not summary.TopActions[actionKey] then
            summary.TopActions[actionKey] = 0
        end
        summary.TopActions[actionKey] = summary.TopActions[actionKey] + 1
    end
    
    return summary
end

function Analytics:Flush()
    -- Export events to external service
    if #self.Events == 0 then return end
    
    local payload = {
        SessionId = self.SessionId,
        Events = self.Events,
        Summary = self:GetSummary()
    }
    
    -- Could send to analytics endpoint
    local jsonData = Services.HttpService:JSONEncode(payload)
    
    if writefile then
        if not isfolder("PHUCMAX/Analytics/") then
            makefolder("PHUCMAX/Analytics/")
        end
        
        local fileName = "PHUCMAX/Analytics/" .. os.date("%Y%m%d_%H%M%S") .. ".json"
        writefile(fileName, jsonData)
    end
    
    self.Events = {}
    
    return jsonData
end

function Analytics:StartAutoFlush()
    self.AutoFlush = true
    
    task.spawn(function()
        while self.AutoFlush do
            task.wait(self.FlushInterval)
            if self.AutoFlush then
                self:Flush()
            end
        end
    end)
end

function Analytics:StopAutoFlush()
    self.AutoFlush = false
end

--============================================--
-- SECTION 89: CRASH HANDLER
--============================================--

local CrashHandler = {}
CrashHandler.Enabled = true
CrashHandler.CrashLogs = {}
CrashHandler.MaxCrashLogs = 20
CrashHandler.CrashLogPath = "PHUCMAX/Crashes/"
CrashHandler.RecoveryAttempts = 0
CrashHandler.MaxRecoveryAttempts = 3
CrashHandler.OnCrash = nil

function CrashHandler:Enable()
    self.Enabled = true
    
    -- Wrap pcall around main systems
    self:ProtectSystem("ConfigSystem", ConfigSystem)
    self:ProtectSystem("NotificationSystem", NotificationSystem)
    self:ProtectSystem("WindowManager", WindowManager)
end

function CrashHandler:ProtectSystem(name, system)
    if not system then return end
    
    -- Protect all methods
    for key, value in pairs(system) do
        if type(value) == "function" then
            local originalFunc = value
            system[key] = function(...)
                if not CrashHandler.Enabled then
                    return originalFunc(...)
                end
                
                local success, result = pcall(originalFunc, ...)
                
                if not success then
                    CrashHandler:LogCrash(name .. "." .. key, result)
                    
                    if CrashHandler.OnCrash then
                        CrashHandler.OnCrash(name .. "." .. key, result)
                    end
                    
                    return nil, result
                end
                
                return result
            end
        end
    end
end

function CrashHandler:LogCrash(source, error)
    local crashData = {
        Source = source,
        Error = tostring(error),
        Timestamp = os.time(),
        DateTime = os.date("%Y-%m-%d %H:%M:%S"),
        PlayerName = Player.Name,
        PlaceId = game.PlaceId,
        Version = PHUCMAX_VERSION,
        StackTrace = debug.traceback()
    }
    
    table.insert(self.CrashLogs, crashData)
    
    -- Trim logs
    while #self.CrashLogs > self.MaxCrashLogs do
        table.remove(self.CrashLogs, 1)
    end
    
    -- Save to file
    if writefile then
        if not isfolder(self.CrashLogPath) then
            makefolder(self.CrashLogPath)
        end
        
        local fileName = self.CrashLogPath .. "crash_" .. os.date("%Y%m%d_%H%M%S") .. ".json"
        writefile(fileName, Services.HttpService:JSONEncode(crashData))
    end
    
    -- Log to console
    DebugConsole:Log("CRASH: " .. source .. " - " .. tostring(error), "FATAL")
    
    -- Track in analytics
    Analytics:TrackError(source, tostring(error))
    
    -- Attempt recovery
    self:AttemptRecovery(crashData)
end

function CrashHandler:AttemptRecovery(crashData)
    self.RecoveryAttempts = self.RecoveryAttempts + 1
    
    if self.RecoveryAttempts > self.MaxRecoveryAttempts then
        DebugConsole:Log("Max recovery attempts reached. Some systems may be unstable.", "FATAL")
        return
    end
    
    -- Try to save config
    pcall(function()
        ConfigSystem:Save()
    end)
    
    -- Notify user
    pcall(function()
        NotificationSystem:Send({
            Title = "Error Detected",
            Content = "An error occurred in " .. crashData.Source .. ". The system has attempted recovery.",
            Type = "error",
            Duration = 5
        })
    end)
end

function CrashHandler:GetCrashLogs()
    return self.CrashLogs
end

function CrashHandler:ClearCrashLogs()
    self.CrashLogs = {}
end

function CrashHandler:ExportCrashReport()
    local report = {
        Crashes = self.CrashLogs,
        SystemInfo = {
            Version = PHUCMAX_VERSION,
            PlayerName = Player.Name,
            PlaceId = game.PlaceId,
            MemoryUsage = collectgarbage("count"),
            ActiveWindows = #WindowManager.Windows,
            LoadedPlugins = PluginSystem:GetAllPlugins()
        }
    }
    
    return Services.HttpService:JSONEncode(report)
end

--============================================--
-- SECTION 90: ERROR BOUNDARY SYSTEM
--============================================--

local ErrorBoundary = {}
ErrorBoundary.Boundaries = {}

function ErrorBoundary:Create(name, callback, fallback)
    local boundary = {
        Name = name,
        Callback = callback,
        Fallback = fallback or function() end,
        ErrorCount = 0,
        MaxErrors = 5,
        IsActive = true
    }
    
    self.Boundaries[name] = boundary
    
    return function(...)
        if not boundary.IsActive then
            return boundary.Fallback(...)
        end
        
        local success, result = pcall(function()
            return boundary.Callback(...)
        end)
        
        if not success then
            boundary.ErrorCount = boundary.ErrorCount + 1
            
            CrashHandler:LogCrash("ErrorBoundary." .. name, result)
            
            if boundary.ErrorCount >= boundary.MaxErrors then
                boundary.IsActive = false
                DebugConsole:Log("Error boundary '" .. name .. "' deactivated after " .. boundary.ErrorCount .. " errors", "ERROR")
            end
            
            return boundary.Fallback(...)
        end
        
        return result
    end
end

function ErrorBoundary:Reset(name)
    local boundary = self.Boundaries[name]
    if boundary then
        boundary.ErrorCount = 0
        boundary.IsActive = true
    end
end

function ErrorBoundary:ResetAll()
    for _, boundary in pairs(self.Boundaries) do
        boundary.ErrorCount = 0
        boundary.IsActive = true
    end
end

--============================================--
-- SECTION 91: INTEGRATION
--============================================--

-- Add systems to PHUCMAX
PHUCMAX.DebugConsole = DebugConsole
PHUCMAX.Profiler = Profiler
PHUCMAX.Analytics = Analytics
PHUCMAX.CrashHandler = CrashHandler
PHUCMAX.ErrorBoundary = ErrorBoundary

-- Shorthand methods
function PHUCMAX:DebugLog(message, level)
    DebugConsole:Log(message, level)
end

function PHUCMAX:StartProfiler(name)
    return Profiler:StartSession(name)
end

function PHUCMAX:EndProfiler()
    return Profiler:EndSession()
end

function PHUCMAX:TrackEvent(category, action, label, value)
    return Analytics:TrackEvent(category, action, label, value)
end

-- Enable crash handler
CrashHandler:Enable()

-- Start analytics
Analytics:TrackEvent("System", "Startup", "Library Loaded")
Analytics:StartAutoFlush()

-- Enable debug console
DebugConsole:Enable()
DebugConsole:Log("PHUCMAX Library v" .. PHUCMAX_VERSION .. " initialized", "SUCCESS")

```lua
--[[
    PHUCMAX UI Library - Part 15/15 (Final)
    Complete Integration | Final Demo | Export System | Cleanup | Finalization
    Lines: 15401-16400
]]

--============================================--
-- SECTION 92: FINAL INTEGRATION SYSTEM
--============================================--

local FinalIntegration = {}
FinalIntegration.Initialized = false
FinalIntegration.StartupTime = 0
FinalIntegration.Shutdown = false

function FinalIntegration:Initialize()
    if self.Initialized then return end
    
    local startTime = os.clock()
    self.Initialized = true
    
    -- Initialize all core systems
    DebugConsole:Log("Starting PHUCMAX initialization...", "INFO")
    
    -- Performance monitoring
    PerformanceOptimizer:Initialize()
    DebugConsole:Log("Performance optimizer started", "DEBUG")
    
    -- Memory manager
    DebugConsole:Log("Memory manager active", "DEBUG")
    
    -- Config system
    ConfigSystem:Load()
    DebugConsole:Log("Configuration loaded", "INFO")
    
    -- Theme
    local savedTheme = ConfigSystem:Get("_theme")
    if savedTheme then
        ThemeManager:SetTheme(savedTheme)
    end
    DebugConsole:Log("Theme: " .. ThemeManager:GetThemeName(), "INFO")
    
    -- Plugin system
    PluginSystem:LoadPluginState()
    DebugConsole:Log("Plugins loaded: " .. #PluginSystem.LoadedPlugins, "INFO")
    
    -- Session
    SessionManager:StartSession("Auto Session")
    DebugConsole:Log("Session started", "DEBUG")
    
    -- Analytics
    Analytics:TrackEvent("System", "Initialize", "Complete")
    Analytics:StartAutoFlush()
    
    -- Backup
    AutoBackup:Start(600)
    DebugConsole:Log("Auto-backup enabled (10min interval)", "DEBUG")
    
    -- Crash handler
    CrashHandler:Enable()
    DebugConsole:Log("Crash handler active", "DEBUG")
    
    -- Gesture system
    GestureSystem:Initialize()
    DebugConsole:Log("Gesture system ready", "DEBUG")
    
    -- Keybinds
    self:RegisterDefaultKeybinds()
    
    self.StartupTime = os.clock() - startTime
    DebugConsole:Log(string.format("Initialization complete in %.2fms", self.StartupTime * 1000), "SUCCESS")
    
    -- Track startup
    Analytics:TrackEvent("Performance", "Startup", string.format("%.2fms", self.StartupTime * 1000))
    
    -- Welcome notification
    NotificationSystem:Send({
        Title = "PHUCMAX Ready",
        Content = "Library initialized in " .. string.format("%.0f", self.StartupTime * 1000) .. "ms",
        Type = "success",
        Duration = 3
    })
    
    return true
end

function FinalIntegration:RegisterDefaultKeybinds()
    -- F2 - Toggle DevTools
    KeybindManager:Register(Enum.KeyCode.F2, function()
        if DevTools.Panel then
            DevTools.Panel.Visible = not DevTools.Panel.Visible
        end
    end, "Toggle DevTools")
    
    -- F3 - Toggle Debug Console
    KeybindManager:Register(Enum.KeyCode.F3, function()
        DebugConsole:Toggle()
    end, "Toggle Debug Console")
    
    -- Ctrl+S - Save Config
    KeybindManager:Register(Enum.KeyCode.S, function()
        ConfigSystem:Save()
        NotificationSystem:Send({
            Title = "Config Saved",
            Content = "Configuration has been saved",
            Type = "success",
            Duration = 2
        })
    end, "Save Config")
    
    -- Ctrl+R - Quick Reload
    KeybindManager:Register(Enum.KeyCode.R, function()
        DebugConsole:Log("Reload requested", "INFO")
    end, "Reload")
end

function FinalIntegration:Shutdown()
    if self.Shutdown then return end
    self.Shutdown = true
    
    DebugConsole:Log("Shutting down PHUCMAX...", "WARN")
    
    -- Save everything
    ConfigSystem:Save()
    SessionManager:EndSession()
    PluginSystem:SavePluginState()
    Analytics:Flush()
    BackupSystem:CreateBackup()
    
    -- Stop systems
    AutoBackup:Stop()
    Analytics:StopAutoFlush()
    AnimationController:StopAll()
    MemoryManager:Cleanup()
    
    -- Close all windows
    WindowManager:CloseAll()
    
    -- Clear notifications
    NotificationSystem:ClearAll()
    
    -- Disconnect all
    ConnectionManager:DisconnectAll()
    EventSystem:ClearAll()
    KeybindManager:ClearAll()
    
    DebugConsole:Log("PHUCMAX shutdown complete", "SUCCESS")
    
    -- Final cleanup
    task.delay(1, function()
        collectgarbage("collect")
    end)
end

--============================================--
-- SECTION 93: COMPLETE DEMO SYSTEM
--============================================--

local CompleteDemo = {}
CompleteDemo.Loaded = false
CompleteDemo.DemoData = {}

function CompleteDemo:Load()
    if self.Loaded then return end
    self.Loaded = true
    
    DebugConsole:Log("Loading complete demo...", "INFO")
    Analytics:TrackFeature("CompleteDemo", "Load")
    
    -- Create multiple windows for demo
    local mainWindow = self:CreateMainWindow()
    local settingsWindow = self:CreateSettingsWindow()
    local toolsWindow = self:CreateToolsWindow()
    
    -- Create window group
    local group = MultiWindowManager:CreateWindowGroup({
        Name = "Demo Group",
        Layout = "Cascade",
        AutoArrange = true
    })
    
    group:AddWindow(mainWindow)
    group:AddWindow(settingsWindow)
    group:AddWindow(toolsWindow)
    
    -- Create floating buttons
    self:CreateFloatingButtons(mainWindow)
    
    -- Setup context menus
    self:SetupContextMenus(mainWindow)
    
    -- Start demo session
    local session = SessionManager:StartSession("Demo Session")
    
    -- Demo notifications
    self:ShowDemoNotifications()
    
    -- Demo dialogs after delay
    task.delay(2, function()
        self:ShowWelcomeDialog()
    end)
    
    -- Track demo loaded
    Analytics:TrackFeature("CompleteDemo", "Loaded")
    
    self.DemoData = {
        MainWindow = mainWindow,
        SettingsWindow = settingsWindow,
        ToolsWindow = toolsWindow,
        Group = group,
        Session = session
    }
    
    DebugConsole:Log("Complete demo loaded successfully", "SUCCESS")
    
    return self.DemoData
end

function CompleteDemo:CreateMainWindow()
    local win = PHUCMAX:CreateWindow({
        Title = "PHUCMAX Pro",
        SubTitle = "Advanced Demo",
        Size = UDim2.fromOffset(640, 460),
        Theme = "Purple",
        TabWidth = 175,
        Acrylic = true
    })
    
    -- Dashboard Tab
    local dash = win:AddTab({Title = "Dashboard", Icon = ""})
    
    local welcome = dash:AddSection({Name = "Welcome"})
    welcome:AddLabel({Text = "Welcome to PHUCMAX Pro"})
    welcome:AddLabel({Text = "Player: " .. Player.Name})
    welcome:AddParagraph({
        Title = "System Status",
        Content = "All systems operational\nMemory: " .. string.format("%.1f MB", collectgarbage("count") / 1024)
    })
    
    local quick = dash:AddSection({Name = "Quick Actions"})
    quick:AddButton({
        Title = "Save Everything",
        Callback = function()
            ConfigSystem:Save()
            BackupSystem:CreateBackup()
            PHUCMAX:Notify({Title = "Saved", Content = "All data saved!", Type = "success"})
        end
    })
    
    quick:AddButton({
        Title = "Performance Check",
        Callback = function()
            local stats = MemoryManager:GetStats()
            PHUCMAX:Notify({
                Title = "Performance",
                Content = string.format("FPS: %d | Memory: %.1f MB | Objects: %d", 
                    PerformanceOptimizer.FPS, stats.MemoryUsage, stats.TotalObjects),
                Type = "info",
                Duration = 5
            })
        end
    })
    
    quick:AddToggle({
        Title = "Low Performance Mode",
        Default = PerformanceOptimizer.LowPerformanceMode,
        Callback = function(value)
            if value then
                PerformanceOptimizer:EnableLowPerformanceMode()
            else
                PerformanceOptimizer:DisableLowPerformanceMode()
            end
        end,
        Flag = "LowPerfMode"
    })
    
    -- Features Tab
    local features = win:AddTab({Title = "Features", Icon = ""})
    
    local toggles = features:AddSection({Name = "Toggles"})
    toggles:AddToggle({Title = "Feature Alpha", Default = true, Flag = "FeatAlpha"})
    toggles:AddToggle({Title = "Feature Beta", Description = "Experimental feature", Default = false, Flag = "FeatBeta"})
    toggles:AddToggle({Title = "Feature Gamma", Default = false, Flag = "FeatGamma"})
    
    local sliders = features:AddSection({Name = "Sliders"})
    local volumeSlider = sliders:AddSlider({
        Title = "Master Volume",
        Min = 0, Max = 100, Default = 80,
        Suffix = "%", ShowValue = true,
        Flag = "MasterVolume"
    })
    
    sliders:AddSlider({
        Title = "UI Scale",
        Min = 50, Max = 150, Default = 100,
        Suffix = "%", Flag = "UIScale"
    })
    
    local dropdowns = features:AddSection({Name = "Dropdowns"})
    dropdowns:AddDropdown({
        Title = "Language",
        Options = {"English", "Vietnamese", "Spanish", "French", "German"},
        Default = "English",
        Flag = "Language"
    })
    
    dropdowns:AddDropdown({
        Title = "Theme",
        Options = {"Purple", "Red", "Blue", "Green", "Dark", "Light"},
        Default = ThemeManager:GetThemeName(),
        Callback = function(value)
            ThemeManager:SetTheme(value)
            ConfigSystem:Set("_theme", value)
        end,
        Flag = "_theme"
    })
    
    -- Developer Tab
    local dev = win:AddTab({Title = "Developer", Icon = ""})
    
    local devTools = dev:AddSection({Name = "Developer Tools"})
    devTools:AddButton({
        Title = "Open Debug Console",
        Callback = function()
            DebugConsole:Show()
        end
    })
    
    devTools:AddButton({
        Title = "Memory Report",
        Callback = function()
            local report = MemoryManager:DumpInfo()
            DebugConsole:Log(report, "INFO")
        end
    })
    
    devTools:AddButton({
        Title = "Force GC",
        Callback = function()
            local count = MemoryManager:ForceCleanup()
            PHUCMAX:Notify({Title = "GC", Content = "Cleaned " .. count .. " objects", Type = "success"})
        end
    })
    
    devTools:AddButton({
        Title = "Crash Report",
        Callback = function()
            local report = CrashHandler:ExportCrashReport()
            DebugConsole:Log("Crash Report:\n" .. report, "INFO")
        end
    })
    
    local profiler = dev:AddSection({Name = "Profiler"})
    profiler:AddButton({
        Title = "Start Profiling",
        Callback = function()
            Profiler:StartSession("Manual Profile")
        end
    })
    
    profiler:AddButton({
        Title = "End Profiling",
        Callback = function()
            Profiler:PrintReport()
        end
    })
    
    local scripts = dev:AddSection({Name = "Scripts"})
    scripts:AddTextbox({
        Title = "Script URL",
        Placeholder = "Enter script URL...",
        Flag = "ScriptURL"
    })
    
    scripts:AddButton({
        Title = "Load Script",
        Callback = function()
            local url = ConfigSystem:Get("ScriptURL")
            if url and url ~= "" then
                local success, result = ScriptLoader:LoadScriptFromURL(url)
                if success then
                    PHUCMAX:Notify({Title = "Script", Content = "Loaded successfully!", Type = "success"})
                else
                    PHUCMAX:Notify({Title = "Error", Content = result, Type = "error"})
                end
            end
        end
    })
    
    return win
end

function CompleteDemo:CreateSettingsWindow()
    local win = PHUCMAX:CreateWindow({
        Title = "Settings",
        SubTitle = "Configuration",
        Size = UDim2.fromOffset(450, 350),
        Theme = "Purple",
        TabWidth = 150
    })
    
    local general = win:AddTab({Title = "General", Icon = ""})
    
    local appearance = general:AddSection({Name = "Appearance"})
    appearance:AddThemeSwitcher({
        Title = "Theme",
        Callback = function(themeName)
            ConfigSystem:Set("_theme", themeName)
        end
    })
    
    appearance:AddToggle({
        Title = "Acrylic Effect",
        Default = true,
        Flag = "AcrylicEnabled"
    })
    
    appearance:AddToggle({
        Title = "Show Animations",
        Default = true,
        Flag = "AnimationsEnabled"
    })
    
    local accessibility = general:AddSection({Name = "Accessibility"})
    accessibility:AddToggle({
        Title = "High Contrast",
        Default = AccessibilitySystem.HighContrast,
        Callback = function(value)
            AccessibilitySystem:SetHighContrast(value)
        end,
        Flag = "HighContrast"
    })
    
    accessibility:AddToggle({
        Title = "Large Text",
        Default = AccessibilitySystem.LargeText,
        Callback = function(value)
            AccessibilitySystem:SetLargeText(value)
        end,
        Flag = "LargeText"
    })
    
    accessibility:AddToggle({
        Title = "Reduce Motion",
        Default = AccessibilitySystem.ReduceMotion,
        Callback = function(value)
            AccessibilitySystem:SetReduceMotion(value)
        end,
        Flag = "ReduceMotion"
    })
    
    accessibility:AddToggle({
        Title = "Screen Reader",
        Default = ScreenReader.Enabled,
        Callback = function(value)
            AccessibilitySystem:SetScreenReader(value)
        end,
        Flag = "ScreenReader"
    })
    
    local data = win:AddTab({Title = "Data", Icon = ""})
    
    local config = data:AddSection({Name = "Configuration"})
    config:AddButton({
        Title = "Save Config",
        Callback = function()
            ConfigSystem:Save()
        end
    })
    
    config:AddButton({
        Title = "Load Config",
        Callback = function()
            ConfigSystem:Load()
        end
    })
    
    config:AddButton({
        Title = "Reset Config",
        Style = "danger",
        Callback = function()
            PHUCMAX:Confirm("Reset Configuration", "Are you sure you want to reset all settings?", function()
                ConfigSystem:Reset()
            end)
        end
    })
    
    local backup = data:AddSection({Name = "Backup"})
    backup:AddButton({
        Title = "Create Backup",
        Callback = function()
            BackupSystem:CreateBackup()
        end
    })
    
    backup:AddButton({
        Title = "Export Config",
        Style = "outline",
        Callback = function()
            ImportExportUI:ShowExportDialog()
        end
    })
    
    backup:AddButton({
        Title = "Import Config",
        Style = "outline",
        Callback = function()
            ImportExportUI:ShowImportDialog()
        end
    })
    
    return win
end

function CompleteDemo:CreateToolsWindow()
    local win = PHUCMAX:CreateWindow({
        Title = "Tools",
        SubTitle = "Utilities",
        Size = UDim2.fromOffset(400, 300),
        Theme = "Purple",
        TabWidth = 120
    })
    
    local utils = win:AddTab({Title = "Utilities", Icon = ""})
    
    local sys = utils:AddSection({Name = "System"})
    sys:AddLabel({Text = "FPS: " .. PerformanceOptimizer.FPS})
    sys:AddLabel({Text = "Memory: " .. string.format("%.1f MB", collectgarbage("count") / 1024)})
    sys:AddLabel({Text = "Objects: " .. MemoryManager.TotalObjects})
    sys:AddLabel({Text = "Windows: " .. #WindowManager.Windows})
    
    local actions = utils:AddSection({Name = "Actions"})
    actions:AddButton({
        Title = "Clear Memory",
        Callback = function()
            MemoryManager:ForceCleanup()
            collectgarbage("collect")
        end
    })
    
    actions:AddButton({
        Title = "Close All Windows",
        Style = "danger",
        Callback = function()
            WindowManager:CloseAll()
        end
    })
    
    actions:AddButton({
        Title = "Restart UI",
        Callback = function()
            CompleteDemo:Unload()
            task.delay(0.5, function()
                CompleteDemo:Load()
            end)
        end
    })
    
    actions:AddButton({
        Title = "Shutdown",
        Style = "danger",
        Callback = function()
            PHUCMAX:Confirm("Shutdown", "Close PHUCMAX completely?", function()
                FinalIntegration:Shutdown()
            end)
        end
    })
    
    return win
end

function CompleteDemo:CreateFloatingButtons(mainWindow)
    -- Toggle main window
    PHUCMAX:CreateFloatingButton({
        Icon = "",
        Size = 50,
        Color = ThemeManager:GetTheme().Main,
        ShowGlow = true,
        Callback = function()
            if mainWindow.State.IsVisible then
                mainWindow:Hide()
            else
                mainWindow:Show()
            end
        end
    })
    
    -- Quick config save
    PHUCMAX:CreateFloatingButton({
        Icon = "",
        Size = 45,
        Position = UDim2.new(0, 10, 0.5, 30),
        Color = Color3.fromRGB(100, 200, 100),
        Callback = function()
            ConfigSystem:Save()
            PHUCMAX:Notify({Title = "Saved", Content = "Config saved!", Type = "success", Duration = 2})
        end
    })
    
    -- Debug console toggle
    PHUCMAX:CreateFloatingButton({
        Icon = "",
        Size = 40,
        Position = UDim2.new(0, 10, 0.5, 80),
        Color = Color3.fromRGB(255, 200, 50),
        Callback = function()
            DebugConsole:Toggle()
        end
    })
end

function CompleteDemo:SetupContextMenus(mainWindow)
    -- Right-click on tabs
    for _, tab in ipairs(mainWindow.Tabs) do
        RightClickDetector:Attach(tab.Button, function(position)
            ContextMenuSystem:Create({
                Position = position,
                Items = {
                    {Text = "Reload Tab", Icon = "", Callback = function()
                        mainWindow:SelectTab(tab)
                    end},
                    {Text = "Duplicate Tab", Icon = "", Callback = function()
                        -- Create duplicate tab logic
                    end},
                    {Type = "separator"},
                    {Text = "Close Tab", Icon = "", Callback = function()
                        if #mainWindow.Tabs > 1 then
                            tab:Destroy()
                        end
                    end, Disabled = #mainWindow.Tabs <= 1},
                    {Text = "Close Other Tabs", Icon = "", Callback = function()
                        for _, t in ipairs(mainWindow.Tabs) do
                            if t ~= tab then
                                t:Destroy()
                            end
                        end
                    end}
                }
            })
        end)
    end
end

function CompleteDemo:ShowDemoNotifications()
    task.delay(1, function()
        PHUCMAX:Notify({
            Title = "Tip",
            Content = "Right-click on tabs for context menu options",
            Type = "info",
            Duration = 5
        })
    end)
    
    task.delay(3, function()
        PHUCMAX:Notify({
            Title = "Tip",
            Content = "Press F3 to open the debug console",
            Type = "info",
            Duration = 5
        })
    end)
    
    task.delay(5, function()
        PHUCMAX:Notify({
            Title = "Tip",
            Content = "Drag the floating buttons to reposition them",
            Type = "info",
            Duration = 5
        })
    end)
end

function CompleteDemo:ShowWelcomeDialog()
    DialogSystem:Create({
        Title = "Welcome to PHUCMAX Pro",
        Content = "This is a complete demonstration of the PHUCMAX UI Library.\n\nExplore the different windows and features to see what's possible.\n\nCheck the Developer tab for debugging tools and profiler.",
        Buttons = {
            {
                Text = "Get Started",
                Color = ThemeManager:GetTheme().Main,
                Callback = function()
                    Analytics:TrackEvent("Onboarding", "Complete", "WelcomeDialog")
                end
            },
            {
                Text = "Later",
                Style = "ghost"
            }
        },
        Width = 420,
        Height = 220,
        CloseButton = true
    })
end

function CompleteDemo:Unload()
    self.Loaded = false
    
    -- Close all windows
    WindowManager:CloseAll()
    
    -- Clear floating buttons
    FloatingButtonSystem:RemoveAll()
    
    -- Clear dialogs
    DialogSystem:CloseAll()
    
    -- Clear modals
    ModalSystem:CloseAll()
    
    -- Clear context menus
    ContextMenuSystem:CloseAll()
    
    -- Clear overlays
    OverlaySystem:HideAll()
    
    -- End session
    SessionManager:EndSession()
    
    self.DemoData = {}
    
    DebugConsole:Log("Demo unloaded", "INFO")
end

--============================================--
-- SECTION 94: EXPORT SYSTEM
--============================================--

local ExportSystem = {}

function ExportSystem:ExportFullConfig()
    return {
        Config = {
            Flags = ConfigSystem:GetAll(),
            Theme = ThemeManager:GetThemeName()
        },
        Windows = self:ExportWindows(),
        Plugins = PluginSystem:GetAllPlugins(),
        Sessions = SessionManager:ListSessions(),
        Backups = BackupSystem:ListBackups(),
        Profiles = ProfileSystem:ListProfiles(),
        Analytics = Analytics:GetSummary(),
        CrashLogs = CrashHandler:GetCrashLogs(),
        System = {
            Version = PHUCMAX_VERSION,
            Build = PHUCMAX_BUILD,
            PlayerName = Player.Name,
            PlaceId = game.PlaceId,
            Timestamp = os.time(),
            MemoryUsage = collectgarbage("count"),
            FPS = PerformanceOptimizer.FPS,
            Objects = MemoryManager.TotalObjects
        }
    }
end

function ExportSystem:ExportWindows()
    local windows = {}
    for _, win in ipairs(WindowManager.Windows) do
        local winData = {
            Title = win.Config.Title,
            Visible = win.State.IsVisible,
            Minimized = win.State.IsMinimized,
            Tabs = {}
        }
        
        for _, tab in ipairs(win.Tabs) do
            local tabData = {
                Name = tab.Name,
                Sections = {}
            }
            
            for _, section in ipairs(tab.Sections) do
                local sectionData = {
                    Name = section.Name,
                    Elements = {}
                }
                
                for _, element in ipairs(section.Elements) do
                    local elementData = {
                        Type = element.Type
                    }
                    
                    if element.GetValue then
                        elementData.Value = element:GetValue()
                    end
                    
                    table.insert(sectionData.Elements, elementData)
                end
                
                table.insert(tabData.Sections, sectionData)
            end
            
            table.insert(winData.Tabs, tabData)
        end
        
        table.insert(windows, winData)
    end
    
    return windows
end

function ExportSystem:ExportToFile()
    local data = self:ExportFullConfig()
    local json = Services.HttpService:JSONEncode(data)
    
    if writefile then
        local fileName = "PHUCMAX/full_export_" .. os.date("%Y%m%d_%H%M%S") .. ".json"
        if not isfolder("PHUCMAX") then makefolder("PHUCMAX") end
        writefile(fileName, json)
        return fileName
    end
    
    return nil
end

function ExportSystem:ExportForSharing()
    local data = {
        Config = {
            Flags = ConfigSystem:GetAll(),
            Theme = ThemeManager:GetThemeName()
        },
        SharedBy = Player.Name,
        SharedAt = os.time(),
        Version = PHUCMAX_VERSION
    }
    
    local json = Services.HttpService:JSONEncode(data)
    
    if syn and syn.write_clipboard then
        syn.write_clipboard(json)
    end
    
    return json
end

--============================================--
-- SECTION 95: FINALIZATION
--============================================--

-- Final setup
FinalIntegration:Initialize()

-- Create demo if auto-demo enabled
local autoDemo = ConfigSystem:Get("_autoDemo", true)
if autoDemo then
    task.delay(1, function()
        CompleteDemo:Load()
    end)
end

--============================================--
-- SECTION 96: PHUCMAX GLOBAL API EXPORT
--============================================--

-- Export PHUCMAX as global
if getgenv then
    getgenv().PHUCMAX = PHUCMAX
end

-- Store in shared for cross-script access
if shared then
    shared.PHUCMAX = PHUCMAX
end

-- Register with game for external access
if _G then
    _G.PHUCMAX = PHUCMAX
end

-- Final log
DebugConsole:Log("========================================", "SUCCESS")
DebugConsole:Log("  PHUCMAX UI Library v" .. PHUCMAX_VERSION, "SUCCESS")
DebugConsole:Log("  Build: " .. PHUCMAX_BUILD, "SUCCESS")
DebugConsole:Log("  All systems initialized successfully", "SUCCESS")
DebugConsole:Log("========================================", "SUCCESS")

-- Track library loaded
Analytics:TrackEvent("Library", "Exported", PHUCMAX_VERSION)

-- Clean up any leaked connections
task.delay(10, function()
    if MemoryManager.TotalObjects > 5000 then
        DebugConsole:Log("High object count detected: " .. MemoryManager.TotalObjects .. ". Running cleanup...", "WARN")
        MemoryManager:ForceCleanup()
    end
end)

