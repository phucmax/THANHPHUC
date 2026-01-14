--!strict
-- ReplicatedStorage/BananaUI.lua
-- Banana-style UI (sidebar left + main right) inspired by screenshot layout
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local BananaUI = {}
BananaUI.__index = BananaUI

-- ========= helpers =========
local function new(className: string, props: {[string]: any}?)
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

-- ========= theme =========
local Theme = {}
Theme.__index = Theme

function Theme.BananaDark(accent: Color3?)
	local a = accent or Color3.fromRGB(220, 180, 60)
	return {
		Accent = a,
		Bg = Color3.fromRGB(18, 18, 18),
		Panel = Color3.fromRGB(28, 28, 28),
		Panel2 = Color3.fromRGB(34, 34, 34),
		Stroke = Color3.fromRGB(70, 70, 70),
		Text = Color3.fromRGB(235, 235, 235),
		SubText = Color3.fromRGB(170, 170, 170),
		Row = Color3.fromRGB(30, 30, 30),
		RowHover = Color3.fromRGB(38, 38, 38),
		Button = Color3.fromRGB(50, 50, 50),
	}
end

-- ========= objects =========
local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

-- ========= Section components =========
local function makeRowBase(sec: any, height: number): Frame
	local row = new("Frame", {
		BackgroundColor3 = sec._theme.Row,
		Size = UDim2.new(1, 0, 0, height),
		Parent = sec._list,
	})
	round(row, 8)
	stroke(row, 1, sec._theme.Stroke, 0.35)
	pad(row, 10, 6, 10, 6)

	-- hover
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

function Section:AddActionRow(text: string, onClick: (() -> ())?)
	local row = makeRowBase(self, 40)

	local label = new("TextLabel", {
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

	local label = new("TextLabel", {
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
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
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
	local value = math.clamp(opts.Default or minV, minV, maxV)

	local row = makeRowBase(self, 52)

	local label = new("TextLabel", {
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
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
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
		v = math.clamp(v, minV, maxV)
		-- step snap
		v = math.floor((v - minV) / step + 0.5) * step + minV
		v = math.clamp(v, minV, maxV)

		value = v
		local t = (value - minV) / (maxV - minV)
		fill.Size = UDim2.new(t, 0, 1, 0)
		knob.Position = UDim2.new(t, 7, 0.5, 0)
		valueLbl.Text = tostring(value)
		if onChanged then onChanged(value) end
	end

	local function setFromX(x: number)
		local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		local raw = minV + rel * (maxV - minV)
		apply(raw)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
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
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
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

	local arrow = new("TextLabel", {
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

	-- simple popup list (overlay inside window)
	local popup: Frame? = nil

	local function close()
		if popup then
			popup:Destroy()
			popup = nil
		end
	end

	local function open()
		if popup then return end
		local root = self._window._overlay

		popup = new("Frame", {
			BackgroundColor3 = self._theme.Panel2,
			Size = UDim2.fromOffset(260, 220),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Parent = root,
		})
		round(popup, 12)
		stroke(popup, 1, self._theme.Stroke, 0.2)

		local title = new("TextLabel", {
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

		local searchBox: TextBox? = nil
		local listTop = 38
		if opts.Search then
			searchBox = new("TextBox", {
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				Text = "",
				PlaceholderText = "Search...",
				Font = Enum.Font.Gotham,
				TextSize = 13,
				TextColor3 = self._theme.Text,
				PlaceholderColor3 = self._theme.SubText,
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
						BackgroundColor3 = Color3.fromRGB(22, 22, 22),
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

		-- click outside to close
		root.MouseButton1Click:Connect(function()
			close()
		end)
	end

	(row :: any).InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
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

	local left = new("TextLabel", {
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
		rightText = value and "✓" or "✗"
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
				right.Text = v and "✓" or "✗"
				right.TextColor3 = v and Color3.fromRGB(120, 220, 140) or Color3.fromRGB(240, 90, 90)
			else
				right.Text = tostring(v)
				right.TextColor3 = self._theme.SubText
			end
		end
	}
end

-- ========= Tab / Window =========
function Tab:AddSection(title: string)
	local secFrame = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self._content,
	})

	local header = new("TextLabel", {
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

	local lay = listLayout(list, 8)
	lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		-- auto handled by AutomaticSize, but keep for safety
	end)

	local sec = setmetatable({
		_frame = secFrame,
		_list = list,
		_theme = self._theme,
		_window = self._window,
		_tab = self,
	}, Section)

	table.insert(self._sections, sec)
	return sec
end

function Tab:_setVisible(v: boolean)
	self._content.Visible = v
	self._button.BackgroundColor3 = v and self._theme.Panel2 or Color3.fromRGB(24,24,24)
end

function Tab:EnableSearch()
	self._searchEnabled = true
end

function Window:_applyFilter(text: string)
	local q = (text or ""):lower()
	local tab = self._tabs[self._activeTab]
	if not tab then return end

	for _, sec in ipairs(tab._sections) do
		for _, row in ipairs(sec._list:GetChildren()) do
			if row:IsA("Frame") then
				-- try collect labels/buttons text
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
	if t then
		t:_setVisible(true)
	end
	-- clear filter when switching
	self._mainSearch.Text = ""
	self:_applyFilter("")
end

function Window:AddTab(name: string)
	-- sidebar button
	local btn = new("TextButton", {
		BackgroundColor3 = Color3.fromRGB(24,24,24),
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
			tween(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30,30,30)})
		end
	end)
	btn.MouseLeave:Connect(function()
		if self._activeTab ~= name then
			tween(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(24,24,24)})
		end
	end)

	-- content page
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
		_searchEnabled = true,
	}, Tab)

	self._tabs[name] = tab

	btn.MouseButton1Click:Connect(function()
		self:_switchTab(name)
	end)

	if not self._activeTab then
		self._activeTab = name
		tab:_setVisible(true)
	end

	return tab
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

	local t = new("TextLabel", {
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

	local c = new("TextLabel", {
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

function BananaUI:CreateWindow(cfg: {[string]: any})
	cfg = cfg or {}
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local theme = Theme.BananaDark(cfg.Accent)
	local size: UDim2 = cfg.Size or UDim2.fromOffset(620, 340)
	local sidebarW = cfg.SidebarWidth or 190
	local uiScale = cfg.UiScale or 1
	local toggleKey = cfg.ToggleKey or cfg.MinimizeKey

	local gui = new("ScreenGui", {
		Name = "BananaUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		Parent = playerGui,
	})

	local root = new("Frame", {
		BackgroundColor3 = theme.Panel,
		Size = size,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Parent = gui,
	})
	round(root, 14)
	stroke(root, 1, theme.Stroke, 0.25)

	local scale = new("UIScale", {Scale = uiScale, Parent = root})

	-- overlay to close dropdowns
	local overlay = new("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		Parent = gui,
		Visible = true,
		AutoButtonColor = false,
		ZIndex = 1,
	})
	overlay.Active = true

	local rootZ = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		Parent = gui,
		ZIndex = 2,
	})
	root.Parent = rootZ

	-- top header (like screenshot title bar)
	local header = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Parent = root,
	})
	pad(header, 10, 8, 10, 0)

	local title = new("TextLabel", {
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

	-- right header icons (fake icons, simple text glyph)
	local iconSearch = new("TextButton", {
		BackgroundTransparency = 1,
		Text = "🔎",
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
		Text = "👁",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = theme.SubText,
		Size = UDim2.new(0, 24, 1, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Parent = header,
	})

	-- body split
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

	-- avatar circle
	local avatar = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(22,22,22),
		Size = UDim2.fromOffset(44, 44),
		Parent = sidebar,
	})
	round(avatar, 22)
	stroke(avatar, 1, theme.Stroke, 0.35)

	local avatarText = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = "🐱",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = theme.Accent,
		Size = UDim2.new(1,0,1,0),
		Parent = avatar,
	})

	-- search in sidebar
	local sideSearch = new("TextBox", {
		BackgroundColor3 = Color3.fromRGB(20,20,20),
		Text = "",
		PlaceholderText = "Search section or Func",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = theme.Text,
		PlaceholderColor3 = theme.SubText,
		ClearTextOnFocus = false,
		Size = UDim2.new(1, -54, 0, 28),
		Position = UDim2.new(0, 54, 0, 8),
		Parent = sidebar,
	})
	round(sideSearch, 8)
	stroke(sideSearch, 1, theme.Stroke, 0.35)

	-- tab list
	local tabList = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -54),
		Position = UDim2.new(0, 0, 0, 54),
		Parent = sidebar,
	})
	local tabLay = listLayout(tabList, 6)

	-- main panel right
	local main = new("Frame", {
		BackgroundColor3 = theme.Panel2,
		Size = UDim2.new(1, -(sidebarW + 10), 1, 0),
		Position = UDim2.new(0, sidebarW + 10, 0, 0),
		Parent = body,
	})
	round(main, 12)
	stroke(main, 1, theme.Stroke, 0.2)

	-- main header line (small)
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
		Size = UDim2.new(1, -80, 1, 0),
		Parent = mainTop,
	})

	local mainSearch = new("TextBox", {
		BackgroundColor3 = Color3.fromRGB(20,20,20),
		Text = "",
		PlaceholderText = "Search...",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = theme.Text,
		PlaceholderColor3 = theme.SubText,
		ClearTextOnFocus = false,
		Size = UDim2.new(0, 150, 0, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Parent = mainTop,
		Visible = false, -- toggled by iconSearch
	})
	round(mainSearch, 8)
	stroke(mainSearch, 1, theme.Stroke, 0.35)

	-- content host
	local contentHost = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -34),
		Position = UDim2.new(0, 0, 0, 34),
		Parent = main,
	})

	-- notification host
	local notifyHost = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		Parent = gui,
		ZIndex = 50,
	})

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

		_minimized = false,
		_toggleKey = toggleKey,
	}, Window)

	-- search wiring
	sideSearch:GetPropertyChangedSignal("Text"):Connect(function()
		win:_applyFilter(sideSearch.Text)
	end)
	mainSearch:GetPropertyChangedSignal("Text"):Connect(function()
		win:_applyFilter(mainSearch.Text)
	end)

	iconSearch.MouseButton1Click:Connect(function()
		mainSearch.Visible = not mainSearch.Visible
		if mainSearch.Visible then
			mainSearch:CaptureFocus()
		else
			mainSearch.Text = ""
			win:_applyFilter("")
		end
	end)

	-- eye icon: hide/show
	iconEye.MouseButton1Click:Connect(function()
		win._root.Visible = not win._root.Visible
	end)

	-- toggle key
	if toggleKey then
		UIS.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.KeyCode == toggleKey then
				win._root.Visible = not win._root.Visible
			end
		end)
	end

	-- simple drag window (desktop)
	local dragging = false
	local dragStart: Vector2? = nil
	local startPos: UDim2? = nil

	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = root.Position
		end
	end)
	header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart and startPos then
			local delta = input.Position - dragStart
			root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- overlay clicks (used by dropdown close)
	overlay.MouseButton1Click:Connect(function()
		-- dropdowns use this button to close themselves (they attach inside overlay)
	end)

	return win
end

return BananaUI