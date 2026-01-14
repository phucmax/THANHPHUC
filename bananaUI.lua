--!strict
-- BananaUI.lua (v4 - "complete")
-- Goals:
-- 1) No full-screen input blocker unless a dropdown/modal is OPEN.
-- 2) API style giống Fluent (AddTab({Title=...}), Tab:AddButton({...}), etc.)
-- 3) Draggable window + draggable floating toggle button.
-- 4) Semi-transparent UI + Accent by English name + optional Rainbow border.

-- NOTE (IMPORTANT):
-- Roblox GUI will ALWAYS block touches where the GUI is placed.
-- If your menu sits on top of the joystick/buttons, those spots can't be pressed.
-- Use Toggle button to hide/move the menu if it overlaps your controls.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local UI = {}
UI.__index = UI

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

local function stroke(parent: Instance, thickness: number, color: Color3, transparency: number)
	local s = Instance.new("UIStroke")
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Thickness = thickness
	s.Color = color
	s.Transparency = transparency
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
-- Theme + Accent Name
-- =========================
export type Theme = {
	Accent: Color3,
	Bg: Color3,
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
		Bg = Color3.fromRGB(10, 10, 10),
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
	local s = stroke(frame, thickness, Color3.fromRGB(255,255,255), 0)
	s.Name = "RainbowStroke"
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
-- Types / Classes
-- =========================
local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

-- =========================
-- Blocker (IMPORTANT FIX)
-- =========================
function Window:_block(enable: boolean, onClick: (() -> ())?)
	-- This blocker is the ONLY full-screen clickable, but it is OFF by default.
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

-- =========================
-- Window API
-- =========================
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

export type TabConfig = {
	Title: string,
	Icon: string?, -- optional
}

export type ButtonConfig = {
	Title: string,
	Description: string?,
	Callback: (() -> ())?,
}

export type ToggleConfig = {
	Title: string,
	Description: string?,
	Default: boolean?,
	Callback: ((boolean) -> ())?,
}

export type DropdownConfig = {
	Title: string,
	Description: string?,
	Values: {string},
	Default: string?,
	Callback: ((string) -> ())?,
}

export type SliderConfig = {
	Title: string,
	Description: string?,
	Min: number,
	Max: number,
	Default: number?,
	Step: number?,
	Callback: ((number) -> ())?,
}

export type ParagraphConfig = {
	Title: string,
	Content: string,
}

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
		Size = UDim2.fromOffset(270, 76),
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
		Size = UDim2.new(1, -18, 0, 44),
		Position = UDim2.new(0, 9, 0, 28),
		Parent = card,
		ZIndex = 301,
	})

	card.Position = UDim2.new(1, 320, 1, -14)
	tween(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -14, 1, -14)
	})

	task.delay(dur, function()
		if card.Parent then
			tween(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 320, 1, -14)
			})
			task.wait(0.2)
			card:Destroy()
		end
	end)
end

-- =========================
-- Tabs
-- =========================
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

function Window:AddTab(tabCfg: TabConfig)
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
		Parent = self._tabList,
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
		_id = title,
		_button = btn,
		_content = content,
		_sections = {},
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

	return tab
end

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

	local list = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = wrap,
	})
	listLayout(list, 8)

	local sec = setmetatable({
		_window = self._window,
		_theme = self._theme,
		_list = list,
	}, Section)

	table.insert(self._sections, sec)
	return sec
end

-- =========================
-- Rows + Controls
-- =========================
local function makeRow(sec: any, height: number)
	local row = new("Frame", {
		BackgroundColor3 = sec._theme.Row,
		BackgroundTransparency = 0.15,
		Size = UDim2.new(1, 0, 0, height),
		Parent = sec._list,
	})
	corner(row, 8)
	stroke(row, 1, sec._theme.Stroke, 0.35)
	pad(row, 10, 6, 10, 6)

	row.MouseEnter:Connect(function()
		tween(row, TweenInfo.new(0.12), {BackgroundColor3 = sec._theme.RowHover})
	end)
	row.MouseLeave:Connect(function()
		tween(row, TweenInfo.new(0.12), {BackgroundColor3 = sec._theme.Row})
	end)

	return row
end

local function addTitleDesc(row: Frame, theme: Theme, title: string, desc: string?)
	local t = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -120, 0, 18),
		Position = UDim2.new(0, 0, 0, 0),
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
			Size = UDim2.new(1, -120, 0, 14),
			Position = UDim2.new(0, 0, 0, 18),
			Parent = row,
		})
	end
	return t
end

function Tab:AddButton(cfg: ButtonConfig)
	local row = makeRow(self:AddSection(""), 48) -- quick sectionless row
	row.Parent = self._content

	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local btn = new("TextButton", {
		Name = "AccentButton",
		BackgroundColor3 = self._theme.Accent,
		Text = "Click",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.new(0, 70, 0, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Parent = row,
	})
	corner(btn, 8)

	btn.MouseButton1Click:Connect(function()
		if cfg.Callback then cfg.Callback() end
	end)

	return btn
end

function Section:AddButton(cfg: ButtonConfig)
	local row = makeRow(self, 48)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local btn = new("TextButton", {
		Name = "AccentButton",
		BackgroundColor3 = self._theme.Accent,
		Text = "Click",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.new(0, 70, 0, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Parent = row,
	})
	corner(btn, 8)
	btn.MouseButton1Click:Connect(function()
		if cfg.Callback then cfg.Callback() end
	end)
	return btn
end

function Section:AddToggle(cfg: ToggleConfig)
	local row = makeRow(self, 48)
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
	local accStroke = stroke(box, 2, self._theme.Accent, 0)
	accStroke.Name = "AccentStroke"

	local fill = new("Frame", {
		Name = "AccentFill",
		BackgroundColor3 = self._theme.Accent,
		Size = UDim2.new(1, -8, 1, -8),
		Position = UDim2.new(0, 4, 0, 4),
		Parent = box,
		Visible = cfg.Default == true,
	})
	corner(fill, 4)

	local state = cfg.Default == true
	local function set(v: boolean)
		state = v
		fill.Visible = state
		if cfg.Callback then cfg.Callback(state) end
	end

	box.MouseButton1Click:Connect(function()
		set(not state)
	end)

	return {Set=set, Get=function() return state end}
end

function Section:AddSlider(cfg: SliderConfig)
	local minV, maxV = cfg.Min, cfg.Max
	local step = cfg.Step or 1
	local value = clamp(cfg.Default or minV, minV, maxV)

	local row = makeRow(self, 60)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local valLbl = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = tostring(value),
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = self._theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.new(0, 70, 0, 18),
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
	stroke(bar, 1, self._theme.Stroke, 0.4)

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

	local dragging = false
	local function apply(v: number)
		v = clamp(v, minV, maxV)
		v = math.floor((v - minV)/step + 0.5)*step + minV
		v = clamp(v, minV, maxV)
		value = v

		local t = (value-minV)/(maxV-minV)
		fill.Size = UDim2.new(t,0,1,0)
		knob.Position = UDim2.new(t, 7, 0.5, 0)
		valLbl.Text = tostring(value)
		if cfg.Callback then cfg.Callback(value) end
	end

	local function setFromX(x: number)
		local rel = clamp((x - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
		apply(minV + rel*(maxV-minV))
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

	apply(value)
	return {Set=apply, Get=function() return value end}
end

function Section:AddDropdown(cfg: DropdownConfig)
	local row = makeRow(self, 48)
	addTitleDesc(row, self._theme, cfg.Title, cfg.Description)

	local current = cfg.Default or (cfg.Values[1] or "")

	local valueLbl = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = current,
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

	local popup: Frame? = nil
	local function close()
		if popup then popup:Destroy(); popup=nil end
		self._window:_block(false)
	end
	local function open()
		if popup then return end

		-- turn ON blocker while popup is open (this is safe now)
		self._window:_block(true, close)

		popup = new("Frame", {
			BackgroundColor3 = self._theme.Panel2,
			BackgroundTransparency = self._window._transp,
			Size = UDim2.fromOffset(280, 240),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Parent = self._window._overlay,
			ZIndex = 220,
		})
		popup.Active = true
		corner(popup, 12)
		stroke(popup, 1, self._theme.Stroke, 0.2)

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
			Size = UDim2.new(1, -20, 1, -48),
			Position = UDim2.new(0, 10, 0, 38),
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarThickness = 4,
			Parent = popup,
			ZIndex = 221,
		})
		local lay = listLayout(sc, 6)

		for _, it in ipairs(cfg.Values) do
			local b = new("TextButton", {
				BackgroundColor3 = Color3.fromRGB(18,18,18),
				BackgroundTransparency = 0.1,
				Text = it,
				Font = Enum.Font.Gotham,
				TextSize = 13,
				TextColor3 = self._theme.Text,
				Size = UDim2.new(1, 0, 0, 30),
				Parent = sc,
				ZIndex = 222,
				AutoButtonColor = false,
			})
			corner(b, 8)
			stroke(b, 1, self._theme.Stroke, 0.45)

			b.MouseButton1Click:Connect(function()
				current = it
				valueLbl.Text = current
				if cfg.Callback then cfg.Callback(current) end
				close()
			end)
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

	-- fire callback for default
	if cfg.Callback and current ~= "" then
		task.defer(function() cfg.Callback(current) end)
	end

	return {Set=function(v: string) current=v; valueLbl.Text=v; if cfg.Callback then cfg.Callback(v) end end, Get=function() return current end}
end

function Section:AddParagraph(cfg: ParagraphConfig)
	local row = makeRow(self, 64)

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

	local body = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = cfg.Content,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = self._theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Size = UDim2.new(1, 0, 0, 40),
		Position = UDim2.new(0, 0, 0, 20),
		Parent = row,
	})
	return body
end

-- =========================
-- CreateWindow
-- =========================
function UI:CreateWindow(cfg: WindowConfig)
	cfg = cfg or {}
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local acc = cfg.Accent or colorFromName(cfg.AccentName) or Color3.fromRGB(220, 180, 60)
	local theme = makeTheme(acc)

	local size = cfg.Size or UDim2.fromOffset(650, 360)
	local sidebarW = cfg.SidebarWidth or 200
	local uiScale = cfg.UiScale or 1
	local transp = clamp(cfg.Transparency or 0.12, 0, 0.6)

	local gui = new("ScreenGui", {
		Name = "BananaUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui,
	})

	-- Overlay container (no input)
	local overlay = new("Frame", {
		Name = "Overlay",
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		Parent = gui,
		ZIndex = 200,
	})
	overlay.Active = false

	-- Blocker (input) - OFF by default (IMPORTANT)
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
	stroke(root, 1, theme.Stroke, 0.25)

	new("UIScale", {Scale = uiScale, Parent = root})

	local rainbowDisconnect: (() -> ())? = nil
	if cfg.RainbowBorder then
		rainbowDisconnect = attachRainbowBorder(root, cfg.RainbowThickness or 2)
	end

	local header = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Parent = root,
	})
	pad(header, 10, 8, 10, 0)
	header.Active = true

	local titleText = new("TextLabel", {
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

	local body = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -30),
		Position = UDim2.new(0, 0, 0, 30),
		Parent = root,
	})

	local sidebar = new("Frame", {
		BackgroundColor3 = theme.Panel2,
		BackgroundTransparency = transp,
		Size = UDim2.new(0, sidebarW, 1, 0),
		Parent = body,
	})
	corner(sidebar, 12)
	stroke(sidebar, 1, theme.Stroke, 0.2)
	pad(sidebar, 10, 10, 10, 10)

	local avatar = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BackgroundTransparency = transp,
		Size = UDim2.fromOffset(44, 44),
		Parent = sidebar,
	})
	corner(avatar, 22)
	stroke(avatar, 1, theme.Stroke, 0.35)

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

	local tabList = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -54),
		Position = UDim2.new(0, 0, 0, 54),
		Parent = sidebar,
	})
	listLayout(tabList, 6)

	local main = new("Frame", {
		BackgroundColor3 = theme.Panel2,
		BackgroundTransparency = transp,
		Size = UDim2.new(1, -(sidebarW + 10), 1, 0),
		Position = UDim2.new(0, sidebarW + 10, 0, 0),
		Parent = body,
	})
	corner(main, 12)
	stroke(main, 1, theme.Stroke, 0.2)

	local mainTop = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,34),
		Parent = main,
	})
	pad(mainTop, 10, 8, 10, 0)

	local tabTitle = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = "Tab",
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = mainTop,
	})

	local contentHost = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,-34),
		Position = UDim2.new(0,0,0,34),
		Parent = main,
	})

	local notifyHost = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		Parent = gui,
		ZIndex = 290,
	})

	-- Floating toggle (draggable)
	local toggleBtn = new("TextButton", {
		BackgroundColor3 = theme.Panel2,
		BackgroundTransparency = transp,
		Text = "🍌",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = theme.Accent,
		Size = UDim2.fromOffset(44,44),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 20, 0.5, 0),
		Parent = gui,
		ZIndex = 400,
		AutoButtonColor = false,
	})
	corner(toggleBtn, 22)
	stroke(toggleBtn, 1, theme.Stroke, 0.2)

	makeDraggable(toggleBtn)
	makeDraggable(root, header)

	-- Toggle visibility
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
		_tabList = tabList,
		_contentHost = contentHost,
		_tabTitle = tabTitle,
		_notifyHost = notifyHost,
		_transp = transp,
		_rainbowDisconnect = rainbowDisconnect,
		_titleLabel = titleText,
	}, Window)

	return win
end

return UI
