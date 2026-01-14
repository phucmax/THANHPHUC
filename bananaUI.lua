--!strict
-- BananaUI.lua (Studio-friendly)
-- UI layout: left sidebar (avatar + tabs) + right content with centered title
-- Search: only icon ðŸ”Ž to toggle search box (no "Search..." label)
-- Theme: customizable colors + optional rainbow/waves animated border
-- Floating toggle button (draggable) like in screenshot, to show/hide menu

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local BananaUI = {}
BananaUI.__index = BananaUI

-- ===== helpers =====
local function new(className: string, props: {[string]: any}?): Instance
	local inst = Instance.new(className)
	if props then
		for k, v in pairs(props) do
			(inst :: any)[k] = v
		end
	end
	return inst
end

local function round(parent: Instance, r: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = parent
	return c
end

local function stroke(parent: Instance, thickness: number, color: Color3, transparency: number?)
	local s = Instance.new("UIStroke")
	s.Thickness = thickness
	s.Color = color
	s.Transparency = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
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
	local ui = Instance.new("UIListLayout")
	ui.SortOrder = Enum.SortOrder.LayoutOrder
	ui.Padding = UDim.new(0, paddingPx)
	ui.Parent = parent
	return ui
end

local function tween(inst: Instance, ti: TweenInfo, goal: {[string]: any})
	local tw = TweenService:Create(inst, ti, goal)
	tw:Play()
	return tw
end

local function clamp(n: number, a: number, b: number): number
	if n < a then return a end
	if n > b then return b end
	return n
end

local function isPointerDown(input: InputObject)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

-- ===== theme =====
export type Theme = {
	Accent: Color3,
	Bg: Color3,
	Panel: Color3,
	Panel2: Color3,
	Stroke: Color3,
	Text: Color3,
	SubText: Color3,
	Row: Color3,
	RowHover: Color3,
}

local function bananaTheme(accent: Color3?): Theme
	local a = accent or Color3.fromRGB(220, 180, 60)
	return {
		Accent = a,
		Bg = Color3.fromRGB(10, 10, 10),
		Panel = Color3.fromRGB(18, 18, 18),
		Panel2 = Color3.fromRGB(28, 28, 28),
		Stroke = Color3.fromRGB(70, 70, 70),
		Text = Color3.fromRGB(235, 235, 235),
		SubText = Color3.fromRGB(170, 170, 170),
		Row = Color3.fromRGB(24, 24, 24),
		RowHover = Color3.fromRGB(34, 34, 34),
	}
end

-- ===== objects =====
local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

-- ===== rainbow border "waves" =====
local function attachRainbowBorder(frame: Frame, thickness: number)
	local s = stroke(frame, thickness, Color3.fromRGB(255,255,255), 0)
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
	grad.Rotation = 0
	grad.Parent = s

	-- animated wave: rotate gradient
	local conn = RunService.RenderStepped:Connect(function(dt)
		grad.Rotation = (grad.Rotation + dt * 60) % 360
	end)

	return {
		Stroke = s,
		Gradient = grad,
		Disconnect = function()
			conn:Disconnect()
		end
	}
end

-- ===== Section row base =====
local function makeRowBase(sec: any, height: number): Frame
	local row = new("Frame", {
		BackgroundColor3 = sec._theme.Row,
		Size = UDim2.new(1, 0, 0, height),
		Parent = sec._list,
	})
	round(row, 8)
	stroke(row, 1, sec._theme.Stroke, 0.35)
	pad(row, 10, 6, 10, 6)

	row.MouseEnter:Connect(function()
		tween(row, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = sec._theme.RowHover,
		})
	end)
	row.MouseLeave:Connect(function()
		tween(row, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = sec._theme.Row,
		})
	end)

	return row
end

-- ===== Components =====
function Section:AddActionRow(text: string, onClick: (() -> ())?)
	local row = makeRowBase(self, 40)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -90, 1, 0),
		Parent = row,
	})

	local btn = new("TextButton", {
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
	round(btn, 8)

	btn.MouseButton1Click:Connect(function()
		if onClick then onClick() end
	end)

	return btn
end

function Section:AddToggle(text: string, default: boolean, onChanged: ((boolean) -> ())?)
	local row = makeRowBase(self, 40)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -50, 1, 0),
		Parent = row,
	})

	local box = new("TextButton", {
		BackgroundColor3 = Color3.fromRGB(18, 18, 18),
		Text = "",
		Size = UDim2.new(0, 22, 0, 22),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Parent = row,
		AutoButtonColor = false,
	})
	round(box, 5)
	stroke(box, 2, self._theme.Accent, 0)

	local fill = new("Frame", {
		BackgroundColor3 = self._theme.Accent,
		Size = UDim2.new(1, -8, 1, -8),
		Position = UDim2.new(0, 4, 0, 4),
		Visible = default,
		Parent = box,
	})
	round(fill, 4)

	local state = default and true or false
	local function set(v: boolean)
		state = v
		fill.Visible = state
		if onChanged then onChanged(state) end
	end

	box.MouseButton1Click:Connect(function()
		set(not state)
	end)

	return { Set = set, Get = function() return state end }
end

function Section:AddSlider(text: string, opts: {Min:number, Max:number, Default:number?, Step:number?}, onChanged: ((number)->())?)
	local minV, maxV = opts.Min, opts.Max
	local step = opts.Step or 1
	local value = clamp(opts.Default or minV, minV, maxV)

	local row = makeRowBase(self, 52)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -80, 0, 18),
		Parent = row,
	})

	local valueLbl = new("TextLabel", {
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
		BackgroundColor3 = Color3.fromRGB(18, 18, 18),
		Size = UDim2.new(1, 0, 0, 10),
		Position = UDim2.new(0, 0, 0, 30),
		Parent = row,
	})
	round(bar, 6)
	stroke(bar, 1, self._theme.Stroke, 0.4)

	local fill = new("Frame", {
		BackgroundColor3 = self._theme.Accent,
		Size = UDim2.new((value - minV) / (maxV - minV), 0, 1, 0),
		Parent = bar,
	})
	round(fill, 6)

	local knob = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(245, 245, 245),
		Size = UDim2.new(0, 14, 0, 14),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(fill.Size.X.Scale, 7, 0.5, 0),
		Parent = bar,
	})
	round(knob, 7)

	local dragging = false

	local function apply(v: number)
		v = clamp(v, minV, maxV)
		v = math.floor((v - minV) / step + 0.5) * step + minV
		v = clamp(v, minV, maxV)

		value = v
		local t = (value - minV) / (maxV - minV)
		fill.Size = UDim2.new(t, 0, 1, 0)
		knob.Position = UDim2.new(t, 7, 0.5, 0)
		valueLbl.Text = tostring(value)
		if onChanged then onChanged(value) end
	end

	local function setFromX(x: number)
		local rel = clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		local raw = minV + rel * (maxV - minV)
		apply(raw)
	end

	bar.InputBegan:Connect(function(input)
		if isPointerDown(input) then
			dragging = true
			setFromX(input.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			setFromX(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if isPointerDown(input) then
			dragging = false
		end
	end)

	apply(value)

	return { Set = apply, Get = function() return value end }
end

function Section:AddDropdown(text: string, items: {string}, opts: {Default:string?, Search:boolean?}?, onChanged: ((string)->())?)
	opts = opts or {}
	local current = opts.Default or (items[1] or "")

	local row = makeRowBase(self, 40)

	local label = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = text .. ": " .. current,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -30, 1, 0),
		Parent = row,
	})

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = ">",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = self._theme.SubText,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 20, 1, 0),
		Parent = row,
	})

	local popup: Frame? = nil
	local closeConn: RBXScriptConnection? = nil

	local function close()
		if closeConn then closeConn:Disconnect(); closeConn = nil end
		if popup then popup:Destroy(); popup = nil end
	end

	local function open()
		if popup then return end
		local root = self._window._overlay

		popup = new("Frame", {
			BackgroundColor3 = self._theme.Panel2,
			Size = UDim2.fromOffset(270, 230),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Parent = root,
		})
		round(popup, 12)
		stroke(popup, 1, self._theme.Stroke, 0.2)

		new("TextLabel", {
			BackgroundTransparency = 1,
			Text = text,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = self._theme.Text,
			Size = UDim2.new(1, -20, 0, 22),
			Position = UDim2.new(0, 10, 0, 8),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = popup,
		})

		local listTop = 38
		local searchBox: TextBox? = nil
		if opts.Search then
			searchBox = new("TextBox", {
				BackgroundColor3 = Color3.fromRGB(18, 18, 18),
				Text = "",
				Font = Enum.Font.Gotham,
				TextSize = 13,
				TextColor3 = self._theme.Text,
				PlaceholderText = "",
				ClearTextOnFocus = false,
				Size = UDim2.new(1, -20, 0, 28),
				Position = UDim2.new(0, 10, 0, 34),
				Parent = popup,
			})
			round(searchBox, 8)
			stroke(searchBox, 1, self._theme.Stroke, 0.35)
			listTop = 70
		end

		local sc = new("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -20, 1, -listTop - 10),
			Position = UDim2.new(0, 10, 0, listTop),
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarThickness = 4,
			Parent = popup,
		})
		local lay = listLayout(sc, 6)

		local function rebuild(filter: string?)
			for _, ch in ipairs(sc:GetChildren()) do
				if ch:IsA("TextButton") then ch:Destroy() end
			end
			local f = (filter or ""):lower()
			for _, it in ipairs(items) do
				if f == "" or it:lower():find(f, 1, true) then
					local b = new("TextButton", {
						BackgroundColor3 = Color3.fromRGB(18, 18, 18),
						Text = it,
						Font = Enum.Font.Gotham,
						TextSize = 13,
						TextColor3 = self._theme.Text,
						Size = UDim2.new(1, 0, 0, 30),
						Parent = sc,
					})
					round(b, 8)
					stroke(b, 1, self._theme.Stroke, 0.45)
					b.MouseButton1Click:Connect(function()
						current = it
						label.Text = text .. ": " .. current
						if onChanged then onChanged(current) end
						close()
					end)
				end
			end
			task.defer(function()
				sc.CanvasSize = UDim2.new(0,0,0, lay.AbsoluteContentSize.Y + 6)
			end)
		end

		rebuild(nil)
		if searchBox then
			searchBox:GetPropertyChangedSignal("Text"):Connect(function()
				rebuild(searchBox.Text)
			end)
		end

		closeConn = root.MouseButton1Click:Connect(function()
			close()
		end)
	end

	row.InputBegan:Connect(function(input)
		if isPointerDown(input) then
			if popup then close() else open() end
		end
	end)

	return {
		Set = function(v: string)
			current = v
			label.Text = text .. ": " .. current
			if onChanged then onChanged(current) end
		end,
		Get = function() return current end,
	}
end

function Section:AddStatus(text: string, value: any)
	local row = makeRowBase(self, 34)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = self._theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -60, 1, 0),
		Parent = row,
	})

	local rightText = ""
	local rightColor = self._theme.SubText

	if typeof(value) == "boolean" then
		rightText = value and "âœ“" or "âœ—"
		rightColor = value and Color3.fromRGB(120, 220, 140) or Color3.fromRGB(240, 90, 90)
	else
		rightText = tostring(value)
	end

	local right = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = rightText,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = rightColor,
		TextXAlignment = Enum.TextXAlignment.Right,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 55, 1, 0),
		Parent = row,
	})

	return {
		Set = function(v: any)
			if typeof(v) == "boolean" then
				right.Text = v and "âœ“" or "âœ—"
				right.TextColor3 = v and Color3.fromRGB(120, 220, 140) or Color3.fromRGB(240, 90, 90)
			else
				right.Text = tostring(v)
				right.TextColor3 = self._theme.SubText
			end
		end
	}
end

-- ===== Tab / Window =====
function Tab:AddSection(title: string)
	local secFrame = new("Frame", {
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
		Parent = secFrame,
	})

	local list = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = secFrame,
	})
	listLayout(list, 8)

	local sec = setmetatable({
		_list = list,
		_theme = self._theme,
		_window = self._window,
	}, Section)

	table.insert(self._sections, sec)
	return sec
end

function Tab:_setVisible(v: boolean)
	self._content.Visible = v
	self._button.BackgroundColor3 = v and self._theme.Panel2 or Color3.fromRGB(18,18,18)
end

function Window:_applyFilter(text: string)
	local q = (text or ""):lower()
	local tab = self._tabs[self._activeTab]
	if not tab then return end

	for _, sec in ipairs(tab._sections) do
		for _, row in ipairs(sec._list:GetChildren()) do
			if row:IsA("Frame") then
				local found = false
				for _, d in ipairs(row:GetDescendants()) do
					if d:IsA("TextLabel") or d:IsA("TextButton") then
						local t = (d.Text or ""):lower()
						if q == "" or t:find(q, 1, true) then
							found = true
							break
						end
					end
				end
				row.Visible = found
			end
		end
	end
end

function Window:_switchTab(name: string)
	if self._activeTab == name then return end
	if self._activeTab and self._tabs[self._activeTab] then
		self._tabs[self._activeTab]:_setVisible(false)
	end
	self._activeTab = name
	local t = self._tabs[name]
	if t then t:_setVisible(true) end

	-- update header title to active tab
	self._tabTitle.Text = name

	-- clear filter
	self._mainSearch.Text = ""
	self:_applyFilter("")
end

function Window:AddTab(name: string)
	local btn = new("TextButton", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		Text = name,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		Size = UDim2.new(1, 0, 0, 28),
		Parent = self._tabList,
		AutoButtonColor = false,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	round(btn, 7)
	pad(btn, 10, 0, 10, 0)

	btn.MouseEnter:Connect(function()
		if self._activeTab ~= name then
			tween(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(26,26,26)})
		end
	end)
	btn.MouseLeave:Connect(function()
		if self._activeTab ~= name then
			tween(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(18,18,18)})
		end
	end)

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
		_name = name,
		_button = btn,
		_content = content,
		_sections = {},
		_theme = self._theme,
		_window = self,
	}, Tab)

	self._tabs[name] = tab

	btn.MouseButton1Click:Connect(function()
		if self._activeTab ~= name then
			self:_switchTab(name)
		end
	end)

	if not self._activeTab then
		self._activeTab = name
		self._tabTitle.Text = name
		tab:_setVisible(true)
	end

	return tab
end

function Window:SetAccent(color: Color3)
	self._theme.Accent = color
	-- walk and recolor accent-dependent strokes/fills
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
	end
end

function Window:Notify(opts: {Title: string?, Content: string?, Duration: number?})
	local title = opts.Title or "Notification"
	local content = opts.Content or ""
	local dur = opts.Duration or 2.5

	local card = new("Frame", {
		BackgroundColor3 = self._theme.Panel2,
		Size = UDim2.fromOffset(260, 70),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -14, 1, -14),
		Parent = self._notifyHost,
	})
	round(card, 12)
	stroke(card, 1, self._theme.Stroke, 0.2)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = self._theme.Text,
		Size = UDim2.new(1, -18, 0, 18),
		Position = UDim2.new(0, 9, 0, 8),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = card,
	})

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = content,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = self._theme.SubText,
		Size = UDim2.new(1, -18, 0, 36),
		Position = UDim2.new(0, 9, 0, 28),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = card,
	})

	card.Position = UDim2.new(1, 300, 1, -14)
	tween(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -14, 1, -14)
	})

	task.delay(dur, function()
		if card.Parent then
			tween(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 300, 1, -14)
			})
			task.wait(0.2)
			card:Destroy()
		end
	end)
end

-- ===== draggable helper =====
local function makeDraggable(frame: GuiObject, dragHandle: GuiObject?)
	local handle = dragHandle or frame
	local dragging = false
	local startPos: UDim2? = nil
	local startInput: Vector2? = nil

	handle.InputBegan:Connect(function(input)
		if isPointerDown(input) then
			dragging = true
			startPos = frame.Position
			startInput = input.Position
		end
	end)

	handle.InputEnded:Connect(function(input)
		if isPointerDown(input) then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			if startPos and startInput then
				local delta = input.Position - startInput
				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end
	end)
end

-- ===== CreateWindow =====
export type WindowConfig = {
	Title: string?,
	SubTitle: string?,
	Accent: Color3?,
	Theme: string?,
	Size: UDim2?,
	SidebarWidth: number?,
	UiScale: number?,
	ToggleKey: Enum.KeyCode?,
	RainbowBorder: boolean?,
	RainbowThickness: number?,
	ToggleButtonImage: string?, -- rbxassetid://...
}

function BananaUI:CreateWindow(cfg: WindowConfig)
	cfg = cfg or {}
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local theme = bananaTheme(cfg.Accent)
	local size: UDim2 = cfg.Size or UDim2.fromOffset(650, 360)
	local sidebarW = cfg.SidebarWidth or 200
	local uiScale = cfg.UiScale or 1
	local toggleKey = cfg.ToggleKey
	local rainbow = cfg.RainbowBorder == true
	local rainbowThickness = cfg.RainbowThickness or 2

	local gui = new("ScreenGui", {
		Name = "BananaUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		Parent = playerGui,
	})

	-- overlay layer for dropdowns/modals
	local overlay = new("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		Parent = gui,
		AutoButtonColor = false,
		ZIndex = 20,
	})
	overlay.Active = true

	-- root window
	local root = new("Frame", {
		BackgroundColor3 = theme.Panel,
		Size = size,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Parent = gui,
		ZIndex = 10,
	})
	round(root, 14)
	stroke(root, 1, theme.Stroke, 0.25)

	new("UIScale", {Scale = uiScale, Parent = root})

	-- rainbow border on window (optional)
	local rainbowHandle = nil
	if rainbow then
		rainbowHandle = attachRainbowBorder(root, rainbowThickness)
	end

	-- header bar: centered title (like screenshot)
	local header = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Parent = root,
	})
	pad(header, 10, 8, 10, 0)

	local centerTitle = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = (cfg.Title or "Banana Cat Hub") .. " - " .. (cfg.SubTitle or "Game"),
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, -80, 1, 0),
		Position = UDim2.new(0.5, -40, 0, 0),
		Parent = header,
	})

	-- right header icons
	local iconSearch = new("TextButton", {
		BackgroundTransparency = 1,
		Text = "ðŸ”Ž",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = theme.SubText,
		Size = UDim2.new(0, 24, 1, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -44, 0.5, 0),
		Parent = header,
	})

	local iconEye = new("TextButton", {
		BackgroundTransparency = 1,
		Text = "ðŸ‘",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = theme.SubText,
		Size = UDim2.new(0, 24, 1, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Parent = header,
	})

	-- body
	local body = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -30),
		Position = UDim2.new(0, 0, 0, 30),
		Parent = root,
	})

	-- sidebar
	local sidebar = new("Frame", {
		BackgroundColor3 = theme.Panel2,
		Size = UDim2.new(0, sidebarW, 1, 0),
		Parent = body,
	})
	round(sidebar, 12)
	stroke(sidebar, 1, theme.Stroke, 0.2)
	pad(sidebar, 10, 10, 10, 10)

	-- avatar circle (no extra text required)
	local avatar = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		Size = UDim2.fromOffset(44, 44),
		Parent = sidebar,
	})
	round(avatar, 22)
	stroke(avatar, 1, theme.Stroke, 0.35)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Text = "ðŸ±",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = theme.Accent,
		Size = UDim2.new(1,0,1,0),
		Parent = avatar,
	})

	-- NOTE: remove sidebar search text as requested (only icon search in header)
	-- tab list
	local tabList = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -54),
		Position = UDim2.new(0, 0, 0, 54),
		Parent = sidebar,
	})
	listLayout(tabList, 6)

	-- main panel
	local main = new("Frame", {
		BackgroundColor3 = theme.Panel2,
		Size = UDim2.new(1, -(sidebarW + 10), 1, 0),
		Position = UDim2.new(0, sidebarW + 10, 0, 0),
		Parent = body,
	})
	round(main, 12)
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
		Size = UDim2.new(1, -90, 1, 0),
		Parent = mainTop,
	})

	-- main search box toggled by icon only; no placeholder text
	local mainSearch = new("TextBox", {
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		Text = "",
		PlaceholderText = "",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = theme.Text,
		ClearTextOnFocus = false,
		Size = UDim2.new(0, 160, 0, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Parent = mainTop,
		Visible = false,
	})
	round(mainSearch, 8)
	stroke(mainSearch, 1, theme.Stroke, 0.35)

	local contentHost = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -34),
		Position = UDim2.new(0, 0, 0, 34),
		Parent = main,
	})

	-- notifications
	local notifyHost = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		Parent = gui,
		ZIndex = 50,
	})

	-- floating toggle button (draggable) like screenshot
	local toggleBtn = new("ImageButton", {
		Name = "ToggleButton",
		BackgroundColor3 = theme.Panel2,
		Size = UDim2.fromOffset(44, 44),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 20, 0.5, 0),
		Parent = gui,
		ZIndex = 60,
		AutoButtonColor = false,
	})
	round(toggleBtn, 22)
	stroke(toggleBtn, 1, theme.Stroke, 0.2)

	-- if no image supplied, show emoji label
	local imgId = cfg.ToggleButtonImage
	if imgId and imgId ~= "" then
		toggleBtn.Image = imgId
		toggleBtn.ImageTransparency = 0
	else
		toggleBtn.Image = ""
		local l = new("TextLabel", {
			BackgroundTransparency = 1,
			Text = "ðŸŒ",
			Font = Enum.Font.GothamBold,
			TextSize = 18,
			TextColor3 = theme.Accent,
			Size = UDim2.new(1,0,1,0),
			Parent = toggleBtn,
			ZIndex = 61,
		})
	end

	makeDraggable(toggleBtn)

	-- make window draggable by header
	makeDraggable(root, header)

	-- search wiring
	mainSearch:GetPropertyChangedSignal("Text"):Connect(function()
		(Window :: any)._applyFilter(Window, mainSearch.Text)
	end)

	iconSearch.MouseButton1Click:Connect(function()
		mainSearch.Visible = not mainSearch.Visible
		if mainSearch.Visible then
			mainSearch:CaptureFocus()
		else
			mainSearch.Text = ""
			(Window :: any)._applyFilter(Window, "")
		end
	end)

	local function setVisible(v: boolean)
		root.Visible = v
	end

	iconEye.MouseButton1Click:Connect(function()
		setVisible(not root.Visible)
	end)

	toggleBtn.MouseButton1Click:Connect(function()
		setVisible(not root.Visible)
	end)

	if toggleKey then
		UIS.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.KeyCode == toggleKey then
				setVisible(not root.Visible)
			end
		end)
	end

	local win = setmetatable({
		_gui = gui,
		_root = root,
		_overlay = overlay,
		_theme = theme,
		_tabs = {},
		_activeTab = nil,

		_tabList = tabList,
		_contentHost = contentHost,
		_tabTitle = tabTitle,
		_mainSearch = mainSearch,
		_notifyHost = notifyHost,

		_rainbowHandle = rainbowHandle,
		_toggleBtn = toggleBtn,
		_centerTitle = centerTitle,
	}, Window)

	-- bind methods for inner closures
	win._applyFilter = Window._applyFilter
	win._switchTab = Window._switchTab

	return win
end

return BananaUI
