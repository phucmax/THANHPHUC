--!strict
-- BananaUI_All.lua (v1)
-- Goal: Fluent-style API + Options registry + scrollable tabs & content + draggable + mobile friendly.
-- Supports: Tab/Section, Button, Toggle, Slider, Dropdown (single/multi), Input, Keybind, ColorPicker (RGB sliders), Paragraph, Label, Separator, Notify
-- Optional: Save/Load config using writefile/readfile if available.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local BananaUI = {}
BananaUI.__index = BananaUI

-- =========================
-- Helpers
-- =========================
local function new(className: string, props: {[string]: any}?): Instance
	local inst = Instance.new(className)
	if props then
		for k, v in pairs(props) do
			(inst :: any)[k] = v
		end
	end
	return inst
end

local function corner(parent: Instance, r: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = parent
	return c
end

local function stroke(parent: Instance, thickness: number, color: Color3, transparency: number, name: string?)
	local s = Instance.new("UIStroke")
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Thickness = thickness
	s.Color = color
	s.Transparency = transparency
	if name then s.Name = name end
	s.Parent = parent
	return s
end

local function pad(parent: Instance, l: number, t: number, r: number, b: number)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l)
	p.PaddingTop = UDim.new(0, t)
	p.PaddingRight = UDim.new(0, r)
	p.PaddingBottom = UDim.new(0, b)
	p.Parent = parent
	return p
end

local function listLayout(parent: Instance, paddingPx: number)
	local lay = Instance.new("UIListLayout")
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	lay.Padding = UDim.new(0, paddingPx)
	lay.Parent = parent
	return lay
end

local function tween(obj: Instance, info: TweenInfo, goal: {[string]: any})
	local t = TweenService:Create(obj, info, goal)
	t:Play()
	return t
end

local function clamp(n: number, a: number, b: number)
	if n < a then return a end
	if n > b then return b end
	return n
end

local function isPointerDown(input: InputObject)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function makeDraggable(target: GuiObject, handle: GuiObject?)
	local h = handle or target
	target.Active = true
	h.Active = true

	local dragging = false
	local startPos: UDim2? = nil
	local startInput: Vector2? = nil

	h.InputBegan:Connect(function(input)
		if isPointerDown(input) then
			dragging = true
			startPos = target.Position
			startInput = input.Position
		end
	end)

	h.InputEnded:Connect(function(input)
		if isPointerDown(input) then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if startPos and startInput then
				local delta = input.Position - startInput
				target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end
	end)
end

-- =========================
-- Theme
-- =========================
export type Theme = {
	Accent: Color3,
	Panel: Color3,
	Panel2: Color3,
	Row: Color3,
	RowHover: Color3,
	Stroke: Color3,
	Text: Color3,
	SubText: Color3,
}

local COLOR_MAP: {[string]: Color3} = {
	red = Color3.fromRGB(255, 60, 60),
	green = Color3.fromRGB(60, 255, 140),
	blue = Color3.fromRGB(80, 160, 255),
	yellow = Color3.fromRGB(255, 220, 80),
	orange = Color3.fromRGB(255, 165, 70),
	purple = Color3.fromRGB(180, 90, 255),
	pink = Color3.fromRGB(255, 100, 200),
	cyan = Color3.fromRGB(80, 240, 255),
	white = Color3.fromRGB(245, 245, 245),
	black = Color3.fromRGB(20, 20, 20),
	gray = Color3.fromRGB(120, 120, 120),
	grey = Color3.fromRGB(120, 120, 120),
	gold = Color3.fromRGB(220, 180, 60),
}

local function colorFromName(name: string?): Color3?
	if not name then return nil end
	local key = string.lower((name:gsub("%s+", "")))
	return COLOR_MAP[key]
end

local function makeTheme(accent: Color3): Theme
	return {
		Accent = accent,
		Panel = Color3.fromRGB(18, 18, 18),
		Panel2 = Color3.fromRGB(28, 28, 28),
		Row = Color3.fromRGB(24, 24, 24),
		RowHover = Color3.fromRGB(34, 34, 34),
		Stroke = Color3.fromRGB(70, 70, 70),
		Text = Color3.fromRGB(235, 235, 235),
		SubText = Color3.fromRGB(170, 170, 170),
	}
end

local function attachRainbowBorder(frame: Frame, thickness: number)
	local s = stroke(frame, thickness, Color3.fromRGB(255,255,255), 0, "RainbowStroke")
	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 70, 70)),
		ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 180, 70)),
		ColorSequenceKeypoint.new(0.34, Color3.fromRGB(255, 255, 70)),
		ColorSequenceKeypoint.new(0.51, Color3.fromRGB(70, 255, 140)),
		ColorSequenceKeypoint.new(0.68, Color3.fromRGB(70, 170, 255)),
		ColorSequenceKeypoint.new(0.85, Color3.fromRGB(190, 70, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 70, 170)),
	})
	grad.Parent = s

	local conn = RunService.RenderStepped:Connect(function(dt)
		grad.Rotation = (grad.Rotation + dt * 60) % 360
	end)

	return function()
		conn:Disconnect()
	end
end

-- =========================
-- Option object (Fluent-like)
-- =========================
local Option = {}
Option.__index = Option

function Option:_fire(v: any)
	for _, cb in ipairs(self._cbs) do
		task.spawn(cb, v)
	end
end

function Option:OnChanged(cb: (any) -> ())
	table.insert(self._cbs, cb)
	return self
end

function Option:GetValue()
	return self.Value
end

function Option:SetValue(v: any)
	self.Value = v
	if self._apply then
		self._apply(v)
	end
	self:_fire(v)
	return self
end

-- =========================
-- Window / Tab / Section
-- =========================
local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

export type WindowConfig = {
	Title: string?,
	SubTitle: string?,
	Accent: Color3?,
	AccentName: string?,
	Size: UDim2?,
	SidebarWidth: number?,
	UiScale: number?,
	ToggleKey: Enum.KeyCode?,
	Transparency: number?, -- 0..0.6
	RainbowBorder: boolean?,
	RainbowThickness: number?,
}

-- Public: expose Options table like Fluent
BananaUI.Options = {} :: {[string]: any}

local function makeRow(theme: Theme, parent: Instance, height: number, transp: number)
	local row = new("Frame", {
		BackgroundColor3 = theme.Row,
		BackgroundTransparency = 0.15,
		Size = UDim2.new(1, 0, 0, height),
		Parent = parent,
	})
	corner(row, 8)
	stroke(row, 1, theme.Stroke, 0.35)
	pad(row, 10, 6, 10, 6)

	row.MouseEnter:Connect(function()
		tween(row, TweenInfo.new(0.12), {BackgroundColor3 = theme.RowHover})
	end)
	row.MouseLeave:Connect(function()
		tween(row, TweenInfo.new(0.12), {BackgroundColor3 = theme.Row})
	end)

	return row
end

local function addTitleDesc(row: Frame, theme: Theme, title: string, desc: string?)
	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -160, 0, 18),
		Parent = row,
	})
	if desc and desc ~= "" then
		new("TextLabel", {
			BackgroundTransparency = 1,
			Text = desc,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -160, 0, 14),
			Position = UDim2.new(0, 0, 0, 18),
			Parent = row,
		})
	end
end

function Window:_block(enable: boolean, onClick: (() -> ())?)
	if enable then
		self._blocker.Visible = true
		self._blocker.Active = true
		if self._blockerConn then self._blockerConn:Disconnect() end
		if onClick then
			self._blockerConn = self._blocker.MouseButton1Click:Connect(onClick)
		else
			self._blockerConn = nil
		end
	else
		if self._blockerConn then self._blockerConn:Disconnect() end
		self._blockerConn = nil
		self._blocker.Visible = false
		self._blocker.Active = false
	end
end

function Window:SetAccent(color: Color3)
	self._theme.Accent = color
	for _, inst in ipairs(self._root:GetDescendants()) do
		if inst:IsA("UIStroke") and inst.Name == "AccentStroke" then
			inst.Color = color
		end
		if inst:IsA("Frame") and inst.Name == "AccentFill" then
			inst.BackgroundColor3 = color
		end
		if inst:IsA("TextButton") and inst.Name == "AccentButton" then
			inst.BackgroundColor3 = color
		end
		if inst:IsA("TextLabel") and inst.Name == "AccentText" then
			inst.TextColor3 = color
		end
	end
end

function Window:SetAccentName(name: string)
	local c = colorFromName(name)
	if c then self:SetAccent(c) end
end

function Window:Toggle()
	self._root.Visible = not self._root.Visible
end

function Window:Notify(opts: {Title: string?, Content: string?, Duration: number?})
	local title = opts.Title or "Notification"
	local content = opts.Content or ""
	local dur = opts.Duration or 2.5

	local card = new("Frame", {
		BackgroundColor3 = self._theme.Panel2,
		BackgroundTransparency = self._transp,
		Size = UDim2.fromOffset(280, 78),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -14, 1, -14),
		Parent = self._notifyHost,
		ZIndex = 300,
	})
	corner(card, 12)
	stroke(card, 1, self._theme.Stroke, 0.2)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -18, 0, 18),
		Position = UDim2.new(0, 9, 0, 8),
		Parent = card,
		ZIndex = 301,
	})

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = content,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = self._theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Size = UDim2.new(1, -18, 0, 46),
		Position = UDim2.new(0, 9, 0, 28),
		Parent = card,
		ZIndex = 301,
	})

	card.Position = UDim2.new(1, 340, 1, -14)
	tween(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -14, 1, -14)})

	task.delay(dur, function()
		if card.Parent then
			tween(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 340, 1, -14)})
			task.wait(0.2)
			if card.Parent then card:Destroy() end
		end
	end)
end

function Window:_switchTab(id: string)
	if self._activeTab == id then return end
	if self._activeTab and self._tabs[self._activeTab] then
		self._tabs[self._activeTab]:_setVisible(false)
	end
	self._activeTab = id
	local t = self._tabs[id]
	if t then t:_setVisible(true) end
	self._tabTitle.Text = id
end

function Window:_updateTabScroll()
	local y = self._tabListLayout.AbsoluteContentSize.Y + 6
	self._tabListScroll.CanvasSize = UDim2.new(0,0,0,y)
end

-- Config Save/Load (optional)
function Window:SaveConfig(path: string)
	if not writefile then
		self:Notify({Title="Config", Content="writefile() not available", Duration=2})
		return false
	end
	local data = {}
	for id, opt in pairs(BananaUI.Options) do
		if typeof(opt) == "table" and opt.GetValue then
			data[id] = opt:GetValue()
		end
	end
	local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
	if not ok then return false end
	pcall(function() writefile(path, encoded) end)
	self:Notify({Title="Config", Content="Saved: "..path, Duration=2})
	return true
end

function Window:LoadConfig(path: string)
	if not readfile then
		self:Notify({Title="Config", Content="readfile() not available", Duration=2})
		return false
	end
	local ok, raw = pcall(function() return readfile(path) end)
	if not ok or not raw then return false end
	local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok2 or typeof(data) ~= "table" then return false end

	for id, v in pairs(data) do
		local opt = BananaUI.Options[id]
		if opt and opt.SetValue then
			pcall(function() opt:SetValue(v) end)
		end
	end
	self:Notify({Title="Config", Content="Loaded: "..path, Duration=2})
	return true
end

-- =========================
-- Tab API
-- =========================
function Tab:_setVisible(v: boolean)
	self._content.Visible = v
	self._button.BackgroundColor3 = v and self._theme.Panel2 or Color3.fromRGB(18,18,18)
end

function Tab:AddSection(title: string)
	local wrap = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self._content,
	})

	if title ~= "" then
		new("TextLabel", {
			BackgroundTransparency = 1,
			Text = title,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextColor3 = self._theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(1, 0, 0, 20),
			Parent = wrap,
		})
	end

	local list = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = wrap,
	})
	listLayout(list, 8)

	return setmetatable({
		_window = self._window,
		_theme = self._theme,
		_list = list,
		_transp = self._transp,
	}, Section)
end

function Tab:_ensureDefaultSection()
	if self._defaultSection then return self._defaultSection end
	self._defaultSection = self:AddSection("")
	return self._defaultSection
end

-- Shortcut methods on Tab
function Tab:AddButton(cfg: any) return self:_ensureDefaultSection():AddButton(cfg) end
function Tab:AddToggle(idOrCfg: any, maybeCfg: any) return self:_ensureDefaultSection():AddToggle(idOrCfg, maybeCfg) end
function Tab:AddSlider(idOrCfg: any, maybeCfg: any) return self:_ensureDefaultSection():AddSlider(idOrCfg, maybeCfg) end
function Tab:AddDropdown(idOrCfg: any, maybeCfg: any) return self:_ensureDefaultSection():AddDropdown(idOrCfg, maybeCfg) end
function Tab:AddInput(idOrCfg: any, maybeCfg: any) return self:_ensureDefaultSection():AddInput(idOrCfg, maybeCfg) end
function Tab:AddKeybind(idOrCfg: any, maybeCfg: any) return self:_ensureDefaultSection():AddKeybind(idOrCfg, maybeCfg) end
function Tab:AddColorpicker(idOrCfg: any, maybeCfg: any) return self:_ensureDefaultSection():AddColorpicker(idOrCfg, maybeCfg) end
function Tab:AddParagraph(cfg: any) return self:_ensureDefaultSection():AddParagraph(cfg) end
function Tab:AddLabel(text: string) return self:_ensureDefaultSection():AddLabel(text) end
function Tab:AddSeparator() return self:_ensureDefaultSection():AddSeparator() end

-- =========================
-- Section controls
-- =========================
local function normalizeIdCfg(idOrCfg: any, maybeCfg: any, fallbackIdPrefix: string)
	if typeof(idOrCfg) == "string" then
		return idOrCfg, maybeCfg or {}
	elseif typeof(idOrCfg) == "table" then
		local cfg = idOrCfg
		local id = cfg.Id or (fallbackIdPrefix .. tostring(math.random(100000,999999)))
		return id, cfg
	else
		return (fallbackIdPrefix .. tostring(math.random(100000,999999))), (maybeCfg or {})
	end
end

function Section:_registerOption(id: string, initial: any, applyFn: ((any)->())?)
	local opt = setmetatable({
		Id = id,
		Value = initial,
		_cbs = {},
		_apply = applyFn,
	}, Option)
	BananaUI.Options[id] = opt
	return opt
end

function Section:AddButton(cfg: {Title:string, Description:string?, Callback:(()->())?})
	local row = makeRow(self._theme, self._list, 48, self._transp)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local btn = new("TextButton", {
		Name = "AccentButton",
		BackgroundColor3 = self._theme.Accent,
		Text = "Click",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.new(0, 78, 0, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Parent = row,
		AutoButtonColor = false,
	})
	corner(btn, 8)

	btn.MouseButton1Click:Connect(function()
		if cfg.Callback then cfg.Callback() end
	end)

	return btn
end

function Section:AddToggle(idOrCfg: any, maybeCfg: any)
	local id, cfg = normalizeIdCfg(idOrCfg, maybeCfg, "Toggle")
	cfg.Title = cfg.Title or id
	cfg.Default = cfg.Default == true

	local row = makeRow(self._theme, self._list, 48, self._transp)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local box = new("TextButton", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BackgroundTransparency = 0.1,
		Text = "",
		Size = UDim2.new(0, 22, 0, 22),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Parent = row,
		AutoButtonColor = false,
	})
	corner(box, 5)
	local accStroke = stroke(box, 2, self._theme.Accent, 0, "AccentStroke")

	local fill = new("Frame", {
		Name = "AccentFill",
		BackgroundColor3 = self._theme.Accent,
		Size = UDim2.new(1, -8, 1, -8),
		Position = UDim2.new(0, 4, 0, 4),
		Parent = box,
		Visible = cfg.Default,
	})
	corner(fill, 4)

	local opt = self:_registerOption(id, cfg.Default, function(v)
		fill.Visible = v == true
	end)

	if cfg.Callback then opt:OnChanged(cfg.Callback) end

	box.MouseButton1Click:Connect(function()
		opt:SetValue(not opt.Value)
	end)

	return opt
end

function Section:AddSlider(idOrCfg: any, maybeCfg: any)
	local id, cfg = normalizeIdCfg(idOrCfg, maybeCfg, "Slider")
	cfg.Title = cfg.Title or id
	cfg.Min = cfg.Min or 0
	cfg.Max = cfg.Max or 100
	cfg.Step = cfg.Step or 1
	cfg.Default = cfg.Default or cfg.Min

	local minV, maxV = cfg.Min, cfg.Max
	local step = cfg.Step
	local value = clamp(cfg.Default, minV, maxV)

	local row = makeRow(self._theme, self._list, 60, self._transp)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local valLbl = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = tostring(value),
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = self._theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.new(0, 80, 0, 18),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Parent = row,
	})

	local bar = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BackgroundTransparency = 0.1,
		Size = UDim2.new(1, 0, 0, 10),
		Position = UDim2.new(0, 0, 0, 38),
		Parent = row,
	})
	corner(bar, 6)
	stroke(bar, 1, self._theme.Stroke, 0.4, nil)

	local fill = new("Frame", {
		Name = "AccentFill",
		BackgroundColor3 = self._theme.Accent,
		Size = UDim2.new((value-minV)/(maxV-minV), 0, 1, 0),
		Parent = bar,
	})
	corner(fill, 6)

	local knob = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(245,245,245),
		Size = UDim2.new(0, 14, 0, 14),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(fill.Size.X.Scale, 7, 0.5, 0),
		Parent = bar,
	})
	corner(knob, 7)

	local function apply(v: number)
		v = clamp(v, minV, maxV)
		v = math.floor((v - minV)/step + 0.5)*step + minV
		v = clamp(v, minV, maxV)
		local t = (v-minV)/(maxV-minV)
		fill.Size = UDim2.new(t,0,1,0)
		knob.Position = UDim2.new(t, 7, 0.5, 0)
		valLbl.Text = tostring(v)
	end

	local opt = self:_registerOption(id, value, function(v)
		apply(tonumber(v) or value)
	end)

	if cfg.Callback then opt:OnChanged(cfg.Callback) end

	local dragging = false
	local function setFromX(x: number)
		local rel = clamp((x - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
		opt:SetValue(minV + rel*(maxV-minV))
	end

	bar.InputBegan:Connect(function(input)
		if isPointerDown(input) then
			dragging = true
			setFromX(input.Position.X)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if isPointerDown(input) then dragging = false end
	end)

	-- init apply
	apply(value)
	return opt
end

function Section:AddDropdown(idOrCfg: any, maybeCfg: any)
	local id, cfg = normalizeIdCfg(idOrCfg, maybeCfg, "Dropdown")
	cfg.Title = cfg.Title or id
	cfg.Values = cfg.Values or {}
	cfg.Multi = cfg.Multi == true
	cfg.Default = cfg.Default

	-- normalize default
	local initial
	if cfg.Multi then
		initial = {}
		if typeof(cfg.Default) == "table" then
			for _, v in ipairs(cfg.Default) do table.insert(initial, tostring(v)) end
		end
	else
		if typeof(cfg.Default) == "number" then
			initial = tostring(cfg.Values[cfg.Default] or cfg.Values[1] or "")
		else
			initial = tostring(cfg.Default or cfg.Values[1] or "")
		end
	end

	local row = makeRow(self._theme, self._list, 48, self._transp)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local valueLbl = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = cfg.Multi and "(multi)" or tostring(initial),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = self._theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Right,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -18, 0.5, 0),
		Size = UDim2.new(0, 140, 0, 18),
		Parent = row,
	})

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = "▾",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = self._theme.SubText,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 14, 0, 18),
		Parent = row,
	})

	local function summarizeMulti(t: {string})
		if #t == 0 then return "(none)" end
		if #t <= 2 then return table.concat(t, ", ") end
		return ("%s, %s +%d"):format(t[1], t[2], #t-2)
	end

	local popup: Frame? = nil
	local function close()
		if popup then popup:Destroy(); popup=nil end
		self._window:_block(false)
	end

	local opt = self:_registerOption(id, initial, function(v)
		if cfg.Multi then
			if typeof(v) == "table" then
				valueLbl.Text = summarizeMulti(v)
			end
		else
			valueLbl.Text = tostring(v)
		end
	end)
	if cfg.Callback then opt:OnChanged(cfg.Callback) end

	local function open()
		if popup then return end
		self._window:_block(true, close)

		popup = new("Frame", {
			BackgroundColor3 = self._theme.Panel2,
			BackgroundTransparency = self._window._transp,
			Size = UDim2.fromOffset(300, 260),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Parent = self._window._overlay,
			ZIndex = 220,
		})
		popup.Active = true
		corner(popup, 12)
		stroke(popup, 1, self._theme.Stroke, 0.2, nil)

		new("TextLabel", {
			BackgroundTransparency = 1,
			Text = cfg.Title,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = self._theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -20, 0, 22),
			Position = UDim2.new(0, 10, 0, 8),
			Parent = popup,
			ZIndex = 221,
		})

		local sc = new("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -20, 1, -58),
			Position = UDim2.new(0, 10, 0, 38),
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarThickness = 4,
			Parent = popup,
			ZIndex = 221,
		})
		local lay = listLayout(sc, 6)

		local selected: {[string]: boolean} = {}
		if cfg.Multi and typeof(opt.Value) == "table" then
			for _, v in ipairs(opt.Value) do selected[tostring(v)] = true end
		end

		for _, it in ipairs(cfg.Values) do
			local s = tostring(it)
			local b = new("TextButton", {
				BackgroundColor3 = Color3.fromRGB(18,18,18),
				BackgroundTransparency = 0.1,
				Text = s,
				Font = Enum.Font.Gotham,
				TextSize = 13,
				TextColor3 = self._theme.Text,
				Size = UDim2.new(1, 0, 0, 30),
				Parent = sc,
				ZIndex = 222,
				AutoButtonColor = false,
			})
			corner(b, 8)
			local st = stroke(b, 2, self._theme.Accent, cfg.Multi and (selected[s] and 0 or 1) or 1, "AccentStroke")

			b.MouseButton1Click:Connect(function()
				if cfg.Multi then
					selected[s] = not selected[s]
					st.Transparency = selected[s] and 0 or 1
					local out = {}
					for k, v in pairs(selected) do
						if v then table.insert(out, k) end
					end
					table.sort(out)
					opt:SetValue(out)
				else
					opt:SetValue(s)
					close()
				end
			end)
		end

		-- Done button for multi
		if cfg.Multi then
			local done = new("TextButton", {
				Name="AccentButton",
				BackgroundColor3 = self._theme.Accent,
				Text="Done",
				Font=Enum.Font.GothamBold,
				TextSize=12,
				TextColor3=Color3.fromRGB(25,25,25),
				Size=UDim2.new(0, 70, 0, 26),
				AnchorPoint=Vector2.new(1,1),
				Position=UDim2.new(1, -10, 1, -10),
				Parent=popup,
				ZIndex=223,
				AutoButtonColor=false,
			})
			corner(done, 8)
			done.MouseButton1Click:Connect(close)
		end

		task.defer(function()
			sc.CanvasSize = UDim2.new(0,0,0, lay.AbsoluteContentSize.Y + 6)
		end)
	end

	row.InputBegan:Connect(function(input)
		if isPointerDown(input) then
			if popup then close() else open() end
		end
	end)

	-- init label
	if cfg.Multi then
		valueLbl.Text = summarizeMulti(initial)
	else
		valueLbl.Text = tostring(initial)
	end

	return opt
end

function Section:AddInput(idOrCfg: any, maybeCfg: any)
	local id, cfg = normalizeIdCfg(idOrCfg, maybeCfg, "Input")
	cfg.Title = cfg.Title or id
	cfg.Default = tostring(cfg.Default or "")
	cfg.Placeholder = tostring(cfg.Placeholder or "Type here...")

	local row = makeRow(self._theme, self._list, 54, self._transp)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local box = new("TextBox", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BackgroundTransparency = 0.1,
		Text = cfg.Default,
		PlaceholderText = cfg.Placeholder,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = self._theme.Text,
		PlaceholderColor3 = self._theme.SubText,
		ClearTextOnFocus = false,
		Size = UDim2.new(0, 150, 0, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Parent = row,
	})
	corner(box, 8)
	stroke(box, 1, self._theme.Stroke, 0.4, nil)

	local opt = self:_registerOption(id, cfg.Default, function(v)
		box.Text = tostring(v)
	end)
	if cfg.Callback then opt:OnChanged(cfg.Callback) end

	box.FocusLost:Connect(function()
		opt:SetValue(box.Text)
	end)

	return opt
end

function Section:AddKeybind(idOrCfg: any, maybeCfg: any)
	local id, cfg = normalizeIdCfg(idOrCfg, maybeCfg, "Keybind")
	cfg.Title = cfg.Title or id
	cfg.Default = cfg.Default or Enum.KeyCode.RightControl
	cfg.Mode = cfg.Mode or "Toggle" -- "Toggle" or "Hold"
	cfg.Callback = cfg.Callback

	local row = makeRow(self._theme, self._list, 48, self._transp)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local btn = new("TextButton", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BackgroundTransparency = 0.1,
		Text = tostring(cfg.Default.Name),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = self._theme.SubText,
		Size = UDim2.new(0, 120, 0, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Parent = row,
		AutoButtonColor = false,
	})
	corner(btn, 8)
	stroke(btn, 1, self._theme.Stroke, 0.4, nil)

	local waiting = false
	local active = false

	local opt = self:_registerOption(id, cfg.Default, function(v)
		if typeof(v) == "EnumItem" then
			btn.Text = v.Name
		end
	end)

	btn.MouseButton1Click:Connect(function()
		waiting = true
		btn.Text = "Press..."
	end)

	UIS.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if waiting then
			if input.KeyCode ~= Enum.KeyCode.Unknown then
				waiting = false
				opt:SetValue(input.KeyCode)
			end
			return
		end

		if input.KeyCode == opt.Value then
			if cfg.Mode == "Hold" then
				active = true
				if cfg.Callback then cfg.Callback(true) end
				opt:_fire(true)
			else
				active = not active
				if cfg.Callback then cfg.Callback(active) end
				opt:_fire(active)
			end
		end
	end)

	UIS.InputEnded:Connect(function(input, gpe)
		if gpe then return end
		if cfg.Mode == "Hold" and input.KeyCode == opt.Value then
			active = false
			if cfg.Callback then cfg.Callback(false) end
			opt:_fire(false)
		end
	end)

	return opt
end

function Section:AddColorpicker(idOrCfg: any, maybeCfg: any)
	local id, cfg = normalizeIdCfg(idOrCfg, maybeCfg, "Color")
	cfg.Title = cfg.Title or id
	cfg.Default = cfg.Default or self._theme.Accent

	local row = makeRow(self._theme, self._list, 48, self._transp)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local swatch = new("TextButton", {
		BackgroundColor3 = cfg.Default,
		Text = "",
		Size = UDim2.new(0, 38, 0, 22),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Parent = row,
		AutoButtonColor = false,
	})
	corner(swatch, 6)
	stroke(swatch, 1, self._theme.Stroke, 0.3, nil)

	local opt = self:_registerOption(id, cfg.Default, function(v)
		if typeof(v) == "Color3" then swatch.BackgroundColor3 = v end
	end)
	if cfg.Callback then opt:OnChanged(cfg.Callback) end

	local popup: Frame? = nil
	local function close()
		if popup then popup:Destroy(); popup=nil end
		self._window:_block(false)
	end

	local function open()
		if popup then return end
		self._window:_block(true, close)

		popup = new("Frame", {
			BackgroundColor3 = self._theme.Panel2,
			BackgroundTransparency = self._window._transp,
			Size = UDim2.fromOffset(320, 240),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Parent = self._window._overlay,
			ZIndex = 220,
		})
		popup.Active = true
		corner(popup, 12)
		stroke(popup, 1, self._theme.Stroke, 0.2, nil)
		pad(popup, 12, 10, 12, 12)

		new("TextLabel", {
			BackgroundTransparency = 1,
			Text = cfg.Title,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = self._theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 20),
			Parent = popup,
			ZIndex = 221,
		})

		local preview = new("Frame", {
			BackgroundColor3 = opt.Value,
			Size = UDim2.new(1, 0, 0, 26),
			Position = UDim2.new(0, 0, 0, 28),
			Parent = popup,
			ZIndex = 221,
		})
		corner(preview, 8)
		stroke(preview, 1, self._theme.Stroke, 0.3, nil)

		local function mkSlider(label: string, y: number, initial: number, onV: (number)->())
			local lbl = new("TextLabel", {
				BackgroundTransparency=1,
				Text = label,
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				TextColor3 = self._theme.SubText,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, 16),
				Position = UDim2.new(0, 0, 0, y),
				Parent = popup,
				ZIndex=221,
			})

			local bar = new("Frame", {
				BackgroundColor3 = Color3.fromRGB(18,18,18),
				BackgroundTransparency = 0.1,
				Size = UDim2.new(1, 0, 0, 10),
				Position = UDim2.new(0, 0, 0, y+18),
				Parent = popup,
				ZIndex=221,
			})
			corner(bar, 6)
			stroke(bar, 1, self._theme.Stroke, 0.4, nil)

			local fill = new("Frame", {Name="AccentFill", BackgroundColor3=self._theme.Accent, Size=UDim2.new(initial/255,0,1,0), Parent=bar, ZIndex=222})
			corner(fill, 6)
			local knob = new("Frame", {BackgroundColor3=Color3.fromRGB(245,245,245), Size=UDim2.new(0,14,0,14), AnchorPoint=Vector2.new(1,0.5),
				Position=UDim2.new(fill.Size.X.Scale,7,0.5,0), Parent=bar, ZIndex=223})
			corner(knob, 7)

			local dragging = false
			local function setFromX(x: number)
				local rel = clamp((x - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
				local v = math.floor(rel*255 + 0.5)
				fill.Size = UDim2.new(rel,0,1,0)
				knob.Position = UDim2.new(rel, 7, 0.5, 0)
				onV(v)
			end

			bar.InputBegan:Connect(function(input)
				if isPointerDown(input) then dragging = true; setFromX(input.Position.X) end
			end)
			UIS.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
					setFromX(input.Position.X)
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if isPointerDown(input) then dragging = false end
			end)
		end

		local r,g,b = math.floor(opt.Value.R*255+0.5), math.floor(opt.Value.G*255+0.5), math.floor(opt.Value.B*255+0.5)
		local function update()
			local c = Color3.fromRGB(r,g,b)
			preview.BackgroundColor3 = c
			opt:SetValue(c)
		end

		mkSlider("R", 66, r, function(v) r=v; update() end)
		mkSlider("G", 118, g, function(v) g=v; update() end)
		mkSlider("B", 170, b, function(v) b=v; update() end)

		local done = new("TextButton", {
			Name="AccentButton",
			BackgroundColor3 = self._theme.Accent,
			Text="Done",
			Font=Enum.Font.GothamBold,
			TextSize=12,
			TextColor3=Color3.fromRGB(25,25,25),
			Size=UDim2.new(0, 70, 0, 26),
			AnchorPoint=Vector2.new(1,1),
			Position=UDim2.new(1, 0, 1, 0),
			Parent=popup,
			ZIndex=224,
			AutoButtonColor=false,
		})
		corner(done, 8)
		done.MouseButton1Click:Connect(close)
	end

	swatch.MouseButton1Click:Connect(function()
		if popup then close() else open() end
	end)

	return opt
end

function Section:AddParagraph(cfg: {Title:string, Content:string})
	local row = makeRow(self._theme, self._list, 70, self._transp)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = cfg.Title,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 18),
		Parent = row,
	})

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = cfg.Content,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = self._theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Size = UDim2.new(1, 0, 0, 46),
		Position = UDim2.new(0, 0, 0, 20),
		Parent = row,
	})

	return row
end

function Section:AddLabel(text: string)
	local row = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		Parent = self._list,
	})
	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = self._theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = row,
	})
	return row
end

function Section:AddSeparator()
	local row = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 10),
		Parent = self._list,
	})
	local line = new("Frame", {
		BackgroundColor3 = self._theme.Stroke,
		BackgroundTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Parent = row,
	})
	corner(line, 1)
	return row
end

-- =========================
-- Window:AddTab
-- =========================
function Window:AddTab(tabCfg: {Title: string, Icon: string?})
	local title = tabCfg.Title

	local btn = new("TextButton", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BackgroundTransparency = 0.10,
		Text = title,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 28),
		Parent = self._tabListInner,
		AutoButtonColor = false,
	})
	corner(btn, 7)
	pad(btn, 10, 0, 10, 0)

	local content = new("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(0,0,0,0),
		ScrollBarThickness = 4,
		Visible = false,
		Parent = self._contentHost,
	})
	pad(content, 10, 10, 10, 10)

	local lay = listLayout(content, 12)
	lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.CanvasSize = UDim2.new(0,0,0, lay.AbsoluteContentSize.Y + 10)
	end)

	local tab = setmetatable({
		_window = self,
		_theme = self._theme,
		_transp = self._transp,
		_id = title,
		_button = btn,
		_content = content,
		_defaultSection = nil,
	}, Tab)

	self._tabs[title] = tab

	btn.MouseButton1Click:Connect(function()
		self:_switchTab(title)
	end)

	if not self._activeTab then
		self._activeTab = title
		self._tabTitle.Text = title
		tab:_setVisible(true)
	end

	task.defer(function()
		self:_updateTabScroll()
	end)

	return tab
end

-- =========================
-- CreateWindow
-- =========================
function BananaUI:CreateWindow(cfg: WindowConfig)
	cfg = cfg or {}
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local acc = cfg.Accent or colorFromName(cfg.AccentName) or Color3.fromRGB(220, 180, 60)
	local theme = makeTheme(acc)

	local size = cfg.Size or UDim2.fromOffset(650, 360)
	local sidebarW = cfg.SidebarWidth or 200
	local uiScale = cfg.UiScale or 1
	local transp = clamp(cfg.Transparency or 0.12, 0, 0.6)

	local gui = new("ScreenGui", {
		Name = "BananaUI_All",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui,
	})

	local overlay = new("Frame", {
		Name = "Overlay",
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		Parent = gui,
		ZIndex = 200,
	})
	overlay.Active = false

	local blocker = new("TextButton", {
		Name = "Blocker",
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.new(1,0,1,0),
		Parent = overlay,
		ZIndex = 210,
		Visible = false,
		AutoButtonColor = false,
	})
	blocker.Active = false

	local root = new("Frame", {
		BackgroundColor3 = theme.Panel,
		BackgroundTransparency = transp,
		Size = size,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Parent = gui,
		ZIndex = 20,
	})
	corner(root, 14)
	stroke(root, 1, theme.Stroke, 0.25, nil)
	new("UIScale", {Scale = uiScale, Parent = root})

	if cfg.RainbowBorder then
		attachRainbowBorder(root, cfg.RainbowThickness or 2)
	end

	local header = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,30), Parent = root})
	pad(header, 10, 8, 10, 0)
	header.Active = true

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = (cfg.Title or "Banana Cat Hub") .. " - " .. (cfg.SubTitle or "Game"),
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0.5, -30, 0, 0),
		Parent = header,
	})

	local eyeBtn = new("TextButton", {
		BackgroundTransparency = 1,
		Text = "👁",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = theme.SubText,
		Size = UDim2.new(0, 24, 1, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Parent = header,
		AutoButtonColor = false,
	})

	local body = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,1,-30), Position = UDim2.new(0,0,0,30), Parent = root})

	local sidebar = new("Frame", {BackgroundColor3 = theme.Panel2, BackgroundTransparency = transp, Size = UDim2.new(0, sidebarW, 1, 0), Parent = body})
	corner(sidebar, 12)
	stroke(sidebar, 1, theme.Stroke, 0.2, nil)
	pad(sidebar, 10, 10, 10, 10)

	-- Avatar / logo
	local avatar = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BackgroundTransparency = transp,
		Size = UDim2.fromOffset(44, 44),
		Parent = sidebar,
	})
	corner(avatar, 22)
	stroke(avatar, 1, theme.Stroke, 0.35, nil)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = "🐱",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = theme.Accent,
		Size = UDim2.new(1,0,1,0),
		Parent = avatar,
		Name = "AccentText",
	})

	-- Tabs list scrollable
	local tabListScroll = new("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -54),
		Position = UDim2.new(0, 0, 0, 54),
		CanvasSize = UDim2.new(0,0,0,0),
		ScrollBarThickness = 4,
		Parent = sidebar,
	})
	local tabListInner = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -6, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = tabListScroll,
	})
	local tabListLayout = listLayout(tabListInner, 6)
	tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabListScroll.CanvasSize = UDim2.new(0,0,0, tabListLayout.AbsoluteContentSize.Y + 6)
	end)

	local main = new("Frame", {BackgroundColor3 = theme.Panel2, BackgroundTransparency = transp, Size = UDim2.new(1, -(sidebarW + 10), 1, 0), Position = UDim2.new(0, sidebarW + 10, 0, 0), Parent = body})
	corner(main, 12)
	stroke(main, 1, theme.Stroke, 0.2, nil)

	local mainTop = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,34), Parent = main})
	pad(mainTop, 10, 8, 10, 0)

	local tabTitle = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = "Tab",
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1,0,1,0),
		Parent = mainTop,
	})

	local contentHost = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,1,-34), Position = UDim2.new(0,0,0,34), Parent = main})
	local notifyHost = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Parent = gui, ZIndex = 290})

	-- Floating toggle button (draggable)
	local toggleBtn = new("TextButton", {
		BackgroundColor3 = theme.Panel2,
		BackgroundTransparency = transp,
		Text = "🍌",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = theme.Accent,
		Size = UDim2.fromOffset(44,44),
		AnchorPoint = Vector2.new(0,0.5),
		Position = UDim2.new(0, 20, 0.5, 0),
		Parent = gui,
		ZIndex = 400,
		AutoButtonColor = false,
	})
	corner(toggleBtn, 22)
	stroke(toggleBtn, 1, theme.Stroke, 0.2, nil)

	makeDraggable(toggleBtn)
	makeDraggable(root, header)

	local function setVisible(v: boolean)
		root.Visible = v
	end

	toggleBtn.MouseButton1Click:Connect(function()
		setVisible(not root.Visible)
	end)
	eyeBtn.MouseButton1Click:Connect(function()
		setVisible(not root.Visible)
	end)

	if cfg.ToggleKey then
		UIS.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.KeyCode == cfg.ToggleKey then
				setVisible(not root.Visible)
			end
		end)
	end

	local win = setmetatable({
		_gui = gui,
		_root = root,
		_overlay = overlay,
		_blocker = blocker,
		_blockerConn = nil,

		_theme = theme,
		_tabs = {},
		_activeTab = nil,

		_tabListScroll = tabListScroll,
		_tabListInner = tabListInner,
		_tabListLayout = tabListLayout,

		_contentHost = contentHost,
		_tabTitle = tabTitle,

		_notifyHost = notifyHost,
		_transp = transp,
	}, Window)

	return win
end

return BananaUI
