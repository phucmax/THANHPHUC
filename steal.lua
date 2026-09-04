-- share by qphuc.gg

local iData = {}
local unpackValues = unpack or table.unpack
iData.value1 = nil
iData.value2 = game:GetService("Players")
iData.value3 = game:GetService("RunService")
iData.value4 = game:GetService("TweenService")
iData.value5 = game:GetService("TeleportService")
iData.value6 = game:GetService("ReplicatedStorage")
iData.value7 = game:GetService("Workspace")
iData.value8 = game:GetService("HttpService")

local UserInputService = game:GetService("UserInputService")

iData.value9 = iData.value2.LocalPlayer
iData.value10 = {}
iData.value11 = {}
iData.value12 = {}
iData.value13 = {}
iData.value10.Rarities = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic",
    "Divine", "Secret", "Titan",
}
iData.value14 = {
	AutoSteal = false,
	AutoPickEgg = true,
	AutoStealRunMode = false,
	FarmMethod = "TP",
	AutoStealSpeed = 800,
	FarmMethod = "Speed",
	AntiTrap = true,
	AreaFocus = {},
	RarityFilter = {},
	SecretPriority = true,
	AutoHatch = false,
	HatchOnce = false,
	EggESP = false,
	FpsBoost = false,
	AutoEquipBest = false,
	AutoClaim = false,
	ClaimInterval = 20,
	AutoUpgrade = false,
	UpgradeInterval = 30,
	AutoTreadmill = false,
	AutoUpgradeTreadmill = false,
	AntiCheat = false,
	HumReady = false,
	Unloaded = false,
}
iData.value15 = {}
iData.value16 = {}
function iData.value17()
	return not iData.value14.Unloaded
end
function iData.value18(title, content, durationFlag)
    pcall(function()
        local message = tostring(title or "Shard") .. " • " .. tostring(content or "")
        if type(_G.PHUCMAX_Notify) == "function" then
            _G.PHUCMAX_Notify(message, durationFlag)
        else
            warn("[Shard] " .. message)
        end
    end)
end
iData.value11.hostGui = type(gethui) == "function" and gethui() or game:GetService("CoreGui")
iData.value11.warnLayer = nil
local function handler(argument)
	local thread = task.spawn(function()
		xpcall(argument, function(err)
			warn("[Shard] " .. tostring(err) .. "\n" .. debug.traceback())
		end)
	end)

	iData.value15[#iData.value15 + 1] = thread

	return thread
end
iData.value19 = nil
function iData.value19()
	if iData.value11.warnLayer and iData.value11.warnLayer.Parent then
		return iData.value11.warnLayer
	end

	return pcall(function()
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "ShardWarn"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = 9999
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Parent = iData.value11.hostGui
		iData.value11.warnLayer = ScreenGui
	end) and iData.value11.warnLayer or nil
end
function iData.value20(text, optionFlag)
	local parent = iData.value19()

	if not parent then
		return
	end

	local option = optionFlag or 4

	pcall(function()
		local Frame = Instance.new("Frame")

		Frame.AnchorPoint = Vector2.new(1, 1)
		Frame.Position = UDim2.new(1, 20, 1, -22)
		Frame.Size = UDim2.fromOffset(232, 54)
		Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		Frame.BorderSizePixel = 0
		Frame.Parent = parent

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Thickness = 1
		UIStroke.Color = Color3.fromRGB(238, 168, 62)
		UIStroke.Transparency = 0.35
		UIStroke.Parent = Frame

		local frame = Instance.new("Frame")

		frame.Size = UDim2.new(0, 3, 1, -16)
		frame.Position = UDim2.new(0, 8, 0, 8)
		frame.BackgroundColor3 = Color3.fromRGB(238, 168, 62)
		frame.BorderSizePixel = 0
		frame.Parent = Frame

		local uiCorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(1, 0)
		uiCorner.Parent = frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.BackgroundTransparency = 1
		TextLabel.Position = UDim2.new(0, 20, 0, 9)
		TextLabel.Size = UDim2.new(1, -30, 0, 16)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextSize = 12
		TextLabel.TextColor3 = Color3.fromRGB(238, 168, 62)
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Text = "Warning"
		TextLabel.Parent = Frame

		local textLabel = Instance.new("TextLabel")

		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.new(0, 20, 0, 27)
		textLabel.Size = UDim2.new(1, -30, 0, 18)
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextSize = 12
		textLabel.TextColor3 = Color3.fromRGB(206, 206, 212)
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel.Text = text
		textLabel.Parent = Frame
		iData.value4
			:Create(Frame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -18, 1, -22),
			})
			:Play()
		task.delay(option, function()
			local create =
				iData.value4:Create(Frame, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
					Position = UDim2.new(1, 260, 1, -22),
				})

			create:Play()
			create.Completed:Wait()
			Frame:Destroy()
		end)
	end)
end
local function secondaryHandler(argument)
	iData.value16[#iData.value16 + 1] = argument

	return argument
end
function iData.value21()
	local Character = iData.value9.Character

	return Character and Character:FindFirstChild("HumanoidRootPart") or nil
end
function iData.value22()
	local Character = iData.value9.Character

	return Character and Character:FindFirstChildWhichIsA("Humanoid") or nil
end
function iData.value23()
	local value22Result = iData.value22()

	return iData.value21() ~= nil and (value22Result ~= nil and value22Result.Health > 0)
end
iData.value10.HUM_COPY = {
	"RigType",
	"HipHeight",
	"JumpPower",
	"JumpHeight",
	"UseJumpPower",
	"AutoRotate",
	"MaxSlopeAngle",
	"DisplayDistanceType",
	"NameDisplayDistance",
	"HealthDisplayDistance",
	"AutomaticScalingEnabled",
	"BreakJointsOnDeath",
	"RequiresNeck",
	"EvaluateStateMachine",
}
local function createAutoStealHumanoid()
	local Character = iData.value9.Character
	local walkSpeedData = Character and Character:FindFirstChildWhichIsA("Humanoid")
	if not Character or not walkSpeedData then
		return false
	end
	local data = {}
	for _, item in ipairs(iData.value10.HUM_COPY) do
		local capturedV = item
		local ok, result = pcall(function()
			return walkSpeedData[capturedV]
		end)

		if ok then
			data[capturedV] = result
		end
	end
	local WalkSpeed = walkSpeedData.WalkSpeed
	pcall(function()
		walkSpeedData:Destroy()
	end)
	iData.value3.Heartbeat:Wait()
	local Humanoid = Instance.new("Humanoid")
	for key, item in pairs(data) do
		local capturedKey = key
		local capturedItem = item

		pcall(function()
			Humanoid[capturedKey] = capturedItem
		end)
	end
	Humanoid.Parent = Character
	iData.value3.Heartbeat:Wait()
	if Character ~= Humanoid.Parent then
		return false
	end
	Humanoid.WalkSpeed = WalkSpeed
	pcall(function()
		Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
	end)
	local CurrentCamera = iData.value7.CurrentCamera
	if CurrentCamera then
		pcall(function()
			CurrentCamera.CameraSubject = Humanoid
		end)
	end
	iData.value14.HumReady = true

	return true
end
iData.value24 = iData.value6:FindFirstChild("Packages")
iData.value24 = iData.value24 and iData.value24:FindFirstChild("Networking") or nil
iData.value25 = {
	EggSnapshot = "RF/EggWorld/AskFieldEggSnapshot",
	EggCarry = "RF/EggWorld/AskFieldEggCarry",
	EggPlace = "RF/EggWorld/AskPlaceEgg",
	EggDrop = "RF/EggWorld/AskFieldEggDrop",
	EggLive = "RF/EggWorld/AskLiveSnapshot",
	EggRarityShow = "RF/EggWorld/AskFieldEggRarityShows",
	Hatch = "RF/EggWorld/AskHatch",
	HatchFinish = "RF/EggWorld/AskFinishHatch",
	SkipGrowth = "RF/EggWorld/AskSkipGrowth",
	PlotState = "RF/Homestead/AskState",
	BaseTierRaise = "RE/Homestead/AskBaseTierRaise",
	NearbyBuy = "RE/Homestead/AskNearbyPurchase",
	Collect = "RF/AwayEarnings/AskCollect",
	PendingCheck = "RF/AwayEarnings/PendingCheck",
	CodexAll = "RF/Codex/AskRedeemAll",
	WearBest = "RF/Haul/WearBest",
	SatchelSale = "RF/Haul/OfferFullSatchelSale",
	SellEveryPet = "RE/PetSatchel/SellEveryPet",
	SellPet = "RE/PetSatchel/SellPet",
	PetSnapshot = "RF/PenRoster/AskLiveSnapshot",
	PetSale = "RF/PenRoster/AskSale",
	PetWear = "RF/PenRoster/AskWear",
	PetDoff = "RF/PenRoster/AskDoff",
	TreadRaise = "RF/Treadmill/AskTierRaise",
	TreadRender = "RF/Treadmill/AskRenderSnapshot",
	WearTool = "RF/EggWorld/AskWearTool",
	DoffTool = "RF/EggWorld/AskDoffTool",
	RigWipe = "RE/RigSync/AskRigWipe",
}
iData.value26 = nil
function iData.value26(argument)
	local firstChild = iData.value24

	if firstChild then
		firstChild = iData.value24:FindFirstChild(argument)
	end

	return firstChild or nil
end
function iData.value27(argument, ...)
	local okFlag = iData.value26(argument)

	if not okFlag then
		return nil
	end

	if okFlag:IsA("RemoteFunction") then
		local ok, result = pcall(okFlag.InvokeServer, okFlag, ...)

		return ok and result or nil
	end

	return pcall(okFlag.FireServer, okFlag, ...) or nil
end
function iData.value28()
	local childNames = {}

	if iData.value24 then
		for _, child in ipairs(iData.value24:GetChildren()) do
			if child:IsA("RemoteFunction") or child:IsA("RemoteEvent") then
				childNames[#childNames + 1] = child.Name
			end
		end
	end

	table.sort(childNames)

	return childNames
end
local value29Option = fireproximityprompt or syn and syn.fireproximityprompt
iData.value29 = nil
iData.value29 = value29Option
function iData.value30(holdDurationFlag)
	if not iData.value29 or (not holdDurationFlag or not holdDurationFlag.Enabled) then
		return false
	end

	pcall(function()
		holdDurationFlag.HoldDuration = 0
	end)

	return pcall(iData.value29, holdDurationFlag)
end
function iData.value31(instance)
	local secondaryInput = iData.value21()
	local alternateInput = instance and instance.Parent
	if not secondaryInput or not alternateInput then
		return false
	end
	local Position
	if alternateInput:IsA("BasePart") then
		Position = alternateInput.Position
	elseif alternateInput:IsA("Model") then
		local ok, result = pcall(function()
			return alternateInput:GetPivot()
		end)

		Position = ok and result.Position or nil
	elseif alternateInput:IsA("Attachment") then
		Position = alternateInput.WorldPosition
	end
	if not Position then
		return false
	end
	local number = instance.MaxActivationDistance > 0 and instance.MaxActivationDistance or 12

	return (secondaryInput.Position - Position).Magnitude <= number + 4
end
function iData.value32(getDescendantsFlag, secondaryData)
	local data = {}

	if not getDescendantsFlag then
		return data
	end

	local GetDescendants = getDescendantsFlag.GetDescendants

	for _, item in ipairs(GetDescendants(getDescendantsFlag)) do
		if item:IsA("ProximityPrompt") and item.Enabled then
			local lower = (item.Name .. " " .. item.ActionText .. " " .. item.ObjectText):lower()

			if item.Parent then
				lower ..= " " .. item.Parent.Name:lower()
			end

			for _, searchableText in ipairs(secondaryData) do
				if lower:find(searchableText, 1, true) then
					data[#data + 1] = item

					break
				end
			end
		end
	end

	return data
end
iData.value11.uidShape = {}
function iData.value33(argument, uid)
	local secondaryResult = iData.value11.uidShape[argument]

	if secondaryResult ~= 2 then
		local value27Result = iData.value27(argument, {
			Uid = uid,
		})

		if value27Result ~= nil and value27Result ~= false then
			iData.value11.uidShape[argument] = 1

			return true
		end

		if secondaryResult == 1 then
			return false
		end
	end

	local value27Result = iData.value27(argument, uid)

	if value27Result ~= nil and value27Result ~= false then
		iData.value11.uidShape[argument] = 2

		return true
	end

	return false
end
iData.value10.rarityLadder = {}
for i, item in ipairs(iData.value10.Rarities) do
	iData.value10.rarityLadder[item] = i
end
function iData.value34(argument)
	if type(argument) ~= "string" then
		return 0
	end

	return iData.value10.rarityLadder[argument] or 0
end
iData.value13.areaLabel = {}
iData.value13.areaRarity = {}
iData.value13.areaTierName = {}
iData.value13.areaByLabel = {}
iData.value13.areaOrder = {}
function iData.value35(areaOrder, optionFlag, flag, quaternaryArgument)
	if not areaOrder or iData.value13.areaLabel[areaOrder] then
		return
	end

	local option = optionFlag or areaOrder

	iData.value13.areaLabel[areaOrder] = option
	iData.value13.areaRarity[areaOrder] = flag or 0
	iData.value13.areaTierName[areaOrder] = quaternaryArgument
	iData.value13.areaByLabel[option] = areaOrder
	iData.value13.areaOrder[#iData.value13.areaOrder + 1] = areaOrder
end
function iData.value36()
	table.sort(iData.value13.areaOrder, function(argument, secondaryArgument)
		local optionFlag = iData.value13.areaRarity[argument]
		local areaRarityResult = iData.value13
		local option = optionFlag or 0
		local secondaryOption = areaRarityResult.areaRarity[secondaryArgument] or 0

		if option == secondaryOption then
			return tostring(iData.value13.areaLabel[argument]) < tostring(iData.value13.areaLabel[secondaryArgument])
		end

		return option < secondaryOption
	end)
end
function iData.value37()
	local data = {}

	for _, item in ipairs(iData.value13.areaOrder) do
		data[#data + 1] = iData.value13.areaLabel[item]
	end

	return data
end
local Data = iData.value6:FindFirstChild("Data")

iData.value38 = Data and Data:FindFirstChild("Areas")

local ok, result = pcall(function()
	return iData.value38 and require(iData.value38)
end)
local data = ok and (type(result) == "table" and (result.Directory or result)) or nil
if type(data) == "table" then
	for k, item in pairs(data) do
		local secondaryK = k

		if type(secondaryK) == "string" and type(item) == "table" then
			local number = 0
			local option
			if type(item.Rarity) == "table" then
				number = tonumber(item.Rarity.RarityNumber) or 0
				option = item.Rarity.DisplayName or item.Rarity._id
			end
			iData.value35(secondaryK, item.DisplayName or (item.Name or secondaryK), number, option)
		end
	end
end
if #iData.value13.areaOrder == 0 then
	local getChildrenCondition = iData.value7:FindFirstChild("Areas") or iData.value7:FindFirstChild("Islands")

	if getChildrenCondition then
		local number = 0
		local GetChildren = getChildrenCondition.GetChildren

		for _, item in ipairs(GetChildren(getChildrenCondition)) do
			number += 1
			iData.value35(item.Name, item.Name, number, nil)
		end
	end
end
iData.value36()
function iData.value39(data)
	local vData = {}
	local number = 0

	if type(data) == "table" then
		for _, item in ipairs(data) do
			if type(item) == "string" and item ~= "" then
				vData[item] = true
				number += 1
			end
		end
	end

	return vData, number
end
local areaWantedResult = iData.value13
local areaWantedCountResult = iData.value13
areaWantedResult.areaWanted = {}
areaWantedCountResult.areaWantedCount = 0
local rarityWantedResult = iData.value13
local rarityWantedCountResult = iData.value13
rarityWantedResult.rarityWanted = {}
rarityWantedCountResult.rarityWantedCount = 0
function iData.value40()
	local data = iData.value39(iData.value14.AreaFocus)
	local areaWanted = {}
	local areaWantedCount = 0

	for k in pairs(data) do
		local secondaryK = k

		areaWanted[iData.value13.areaByLabel[secondaryK] or secondaryK] = true
		areaWantedCount += 1
	end

	local areaWantedResult = iData.value13
	local areaWantedCountResult = iData.value13

	areaWantedResult.areaWanted = areaWanted
	areaWantedCountResult.areaWantedCount = areaWantedCount
end
iData.value41 = nil
function iData.value42()
	local rarityWantedResult = iData.value13
	local rarityWantedCountResult = iData.value13
	local rarityWanted, rarityWantedCount = iData.value39(iData.value14.RarityFilter)

	rarityWantedResult.rarityWanted = rarityWanted
	rarityWantedCountResult.rarityWantedCount = rarityWantedCount
end
iData.value41 = {}
function iData.value43(argument, secondaryArgument)
	local flag = iData.value41[argument]

	if not flag then
		return
	end

	if pcall(function()
		flag:SetValue(secondaryArgument)
	end) then
		return
	end

	pcall(function()
		flag:Set(secondaryArgument)
	end)
end
function iData.value44(argument, secondaryArgument)
	local flag = iData.value41[argument]

	if not flag then
		return
	end

	if pcall(function()
		flag:Refresh(secondaryArgument)
	end) then
		return
	end

	pcall(function()
		flag:SetValues(secondaryArgument)
	end)
end
iData.value11.slotsCache = nil
iData.value45 = nil
function iData.value45()
	if iData.value11.slotsCache and iData.value11.slotsCache.Parent then
		return iData.value11.slotsCache
	end

	iData.value11.slotsCache = iData.value7:FindFirstChild("AreaEggSlotsClient")

	return iData.value11.slotsCache
end
iData.value46 = nil
function iData.value46(argument)
	local firstChild = iData.value45()

	if firstChild then
		firstChild = firstChild:FindFirstChild(argument)
	end

	return firstChild or nil
end
function iData.value47(argument)
	local hitboxContainer = iData.value46(argument)

	if not hitboxContainer then
		return nil
	end

	return hitboxContainer.PrimaryPart
		or (hitboxContainer:FindFirstChild("Hitbox") or hitboxContainer:FindFirstChildWhichIsA("BasePart"))
end
function iData.value48(mutationsArgument)
	if mutationsArgument.BaseMutation then
		return true
	end

	return type(mutationsArgument.Mutations) == "table" and next(mutationsArgument.Mutations) ~= nil
end
iData.value11.eggList = {}
iData.value11.eggListAt = 0
iData.value11.triedUids = {}
iData.value11.failUids = {}
iData.value11.areaDirty = false
function iData.value49(secondaryFlag)
	if not secondaryFlag and tick() - iData.value11.eggListAt < 1.5 then
		return iData.value11.eggList
	end
	local dataFlag = iData.value27(iData.value25.EggSnapshot)
	local iteratorData = dataFlag and dataFlag.Records
	if type(iteratorData) ~= "table" then
		return iData.value11.eggList
	end
	local eggList = {}
	local iterator, state, control = pairs(iteratorData)
	local flag
	while true do
		local uidResult

		control, uidResult = iterator(state, control)

		if not control then
			break
		end

		if not (uidResult.State == "Slot" and uidResult.Uid) then
			continue
		end

		local condition = iData.value47(uidResult.Uid)
		local Position

		if condition then
			Position = condition.Position
		else
			local secondaryInput = uidResult.BoundsCFrame or uidResult.BottomCFrame

			Position = secondaryInput and secondaryInput.Position or nil
		end

		if not Position then
			continue
		end

		local AreaId = uidResult.AreaId

		if AreaId and not iData.value13.areaLabel[AreaId] then
			local callback = iData.value35
			local sum = #iData.value13.areaOrder + 1
			local option = uidResult.Rarity or (uidResult.RarityName or (uidResult.Tier or uidResult.RarityId))

			if type(option) == "table" then
				option = option.DisplayName or (option._id or (option.Name or option.Id))
			end

			callback(AreaId, AreaId, sum, type(option) == "string" and option or nil)
			iData.value11.areaDirty = true
		end

		local areaIdOption = uidResult.Rarity or (uidResult.RarityName or (uidResult.Tier or uidResult.RarityId))

		if type(areaIdOption) == "table" then
			areaIdOption = areaIdOption.DisplayName or (areaIdOption._id or (areaIdOption.Name or areaIdOption.Id))
		end

		local areaId = type(areaIdOption) == "string" and areaIdOption or nil

		if iData.value34(areaId) == 0 then
			areaId = nil
		end

		if not areaId then
			repeat
				if not flag and AreaId then
					areaId = iData.value13.areaTierName[AreaId]

					if not areaId then
						flag = true
					end
				else
					flag = false

					local areaIdOption = uidResult.Rarity
						or (uidResult.RarityName or (uidResult.Tier or uidResult.RarityId))

					if type(areaIdOption) == "table" then
						areaIdOption = areaIdOption.DisplayName
							or (areaIdOption._id or (areaIdOption.Name or areaIdOption.Id))
					end

					areaId = type(areaIdOption) == "string" and areaIdOption or nil
				end
			until not flag
		end

		local sum = #eggList + 1
		local Uid = uidResult.Uid
		local label = AreaId and iData.value13.areaLabel[AreaId] or "Unknown"
		local tier = AreaId and iData.value13.areaRarity[AreaId] or 0
		local rank = iData.value34(areaId)
		local mutated = iData.value48(uidResult)
		local size = uidResult.BoundsSize and uidResult.BoundsSize.Magnitude or 3

		eggList[sum] = {
			uid = Uid,
			area = AreaId,
			label = label,
			pos = Position,
			tier = tier,
			rarity = areaId,
			rank = rank,
			mutated = mutated,
			size = size,
		}
	end
	if iData.value11.areaDirty then
		iData.value11.areaDirty = false
		iData.value36()
		iData.value40()
		iData.value44("AreaFocus", iData.value37())
	end
	iData.value11.eggList = eggList
	iData.value11.eggListAt = tick()
	local uidData = {}
	for i = 1, #eggList do
		uidData[eggList[i].uid] = true
	end
	local timestamp = tick()
	for k, item in pairs(iData.value11.triedUids) do
		local secondaryK = k

		if not uidData[secondaryK] and timestamp - item > 300 then
			iData.value11.triedUids[secondaryK] = nil
			iData.value11.failUids[secondaryK] = nil
		end
	end

	return eggList
end
function iData.value50(uidArgument)
	local uid = iData.value11.triedUids[uidArgument.uid]

	if uid then
		local option = iData.value11.failUids[uidArgument.uid] or 0
		local number = 6

		if option >= 4 then
			number = 600
		elseif option == 3 then
			number = 120
		elseif option == 2 then
			number = 45
		elseif option == 1 then
			number = 18
		end

		if number > tick() - uid then
			return false
		end
	end

	if iData.value13.areaWantedCount > 0 and not iData.value13.areaWanted[uidArgument.area] then
		return false
	end

	if iData.value13.rarityWantedCount > 0 and not iData.value13.rarityWanted[uidArgument.rarity] then
		return false
	end

	return true
end
local function handleFlag()
	local secondaryInput = iData.value21()
	if not secondaryInput then
		return nil
	end
	iData.value49(false)
	local Position = secondaryInput.Position
	local alternateI
	local flagNumber
	for i = 1, #iData.value11.eggList do
		local secondaryI = iData.value11.eggList[i]

		if iData.value50(secondaryI) then
			local Magnitude = (secondaryI.pos - Position).Magnitude
			local differenceNumber = secondaryI.tier > 0 and secondaryI.tier or secondaryI.rank
			local difference = secondaryI.rank * 1000000000000
				+ differenceNumber * 100000000
				+ (not secondaryI.mutated and 0 or 1000000)
				- math.min(Magnitude, 100000)

			if not flagNumber or flagNumber < difference then
				flagNumber = difference
				alternateI = secondaryI
			end
		end
	end

	return alternateI
end
iData.value11.travelling = false
iData.value11.travelToken = 0
local function updateInstanceProperties(capturedInput, updateInstancePropertiesCondition)
	pcall(function()
		capturedInput.AssemblyLinearVelocity = Vector3.zero
		capturedInput.AssemblyAngularVelocity = Vector3.zero
	end)

	if updateInstancePropertiesCondition then
		pcall(function()
			updateInstancePropertiesCondition:ChangeState(Enum.HumanoidStateType.Physics)
		end)
	end
end
function iData.value51()
	local assemblyLinearVelocityCondition = iData.value21()
	local condition = iData.value22()

	if assemblyLinearVelocityCondition then
		pcall(function()
			assemblyLinearVelocityCondition.AssemblyLinearVelocity = Vector3.zero
			assemblyLinearVelocityCondition.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	if condition then
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.Landed)
		end)
	end
end
iData.value10.TRAP_RADIUS = 16
iData.value10.TRAP_WORDS = {
	"trap",
	"cage",
	"snare",
}
iData.value11.trapList = {}
iData.value11.trapModels = {}
iData.value11.trapAt = 0
function iData.value52()
	local trapModels = {}
	local trapList = {}
	local debris = iData.value7:FindFirstChild("__DEBRIS")

	for _, item in ipairs({
		debris,
		iData.value7,
	}) do
		if item then
			for _, child in ipairs(item:GetChildren()) do
				if
					(function(unplacePromptContainer)
						if not unplacePromptContainer:IsA("Model") then
							return false
						end

						if unplacePromptContainer:FindFirstChild("UnplacePrompt") then
							return true
						end

						local lower = unplacePromptContainer.Name:lower()

						for _, searchableText in ipairs(iData.value10.TRAP_WORDS) do
							if lower:find(searchableText, 1, true) then
								return true
							end
						end

						return false
					end)(child)
				then
					local condition = (function(state)
						local capturedState = state
						local success, positionResult = pcall(function()
							return capturedState:GetPivot()
						end)
						if success and positionResult then
							return positionResult.Position
						end
						local BasePart = capturedState:FindFirstChildWhichIsA("BasePart")

						return BasePart and BasePart.Position or nil
					end)(child)

					if condition then
						trapList[#trapList + 1] = condition
						trapModels[#trapModels + 1] = child

						if iData.value14.AntiTrap then
							(function(argument)
								for _, descendant in ipairs(argument:GetDescendants()) do
									local capturedDescendant = descendant

									if capturedDescendant:IsA("BasePart") then
										pcall(function()
											capturedDescendant.CanTouch = false
										end)
										pcall(function()
											capturedDescendant.CanCollide = false
										end)
									end
								end
							end)(child)
						end
					end
				end
			end
		end
	end

	iData.value11.trapList = trapList
	iData.value11.trapModels = trapModels
	iData.value11.trapAt = tick()

	return trapList
end
function iData.value53()
	if tick() - iData.value11.trapAt > 2 then
		iData.value52()
	end

	return iData.value11.trapList
end
function iData.value54(differenceNumber, secondaryDifferenceNumber, numberFlag)
	if not iData.value14.AntiTrap then
		return false
	end

	local data = iData.value53()
	local productNumber = numberFlag or iData.value10.TRAP_RADIUS
	local product = productNumber * productNumber

	for i = 1, #data do
		local vector = data[i]
		local difference = vector.X - differenceNumber
		local number = vector.Z - secondaryDifferenceNumber

		if product > difference * difference + number * number then
			return true
		end
	end

	return false
end
function iData.value55()
	local Character = iData.value9.Character
	if not Character then
		return
	end
	for index, item in ipairs(Character:GetDescendants()) do
		local capturedItem = item

		if capturedItem:IsA("BasePart") then
			if capturedItem.Anchored then
				pcall(function()
					capturedItem.Anchored = false
				end)
			end
		elseif capturedItem:IsA("WeldConstraint") or capturedItem:IsA("Weld") then
			pcall(function()
				local conditionFlag = capturedItem.Part0
				local flag = capturedItem.Part1
				local secondaryConditionFlag = conditionFlag and not conditionFlag:IsDescendantOf(Character)

				if not secondaryConditionFlag then
					if flag then
						flag = not flag:IsDescendantOf(Character)
					end

					secondaryConditionFlag = flag
				end

				if secondaryConditionFlag then
					capturedItem:Destroy()
				end
			end)
		end
	end
	local condition = iData.value22()
	if condition then
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.Physics)
		end)
	end
end
iData.value11.groundParams = RaycastParams.new()
iData.value11.groundParams.FilterType = Enum.RaycastFilterType.Exclude
iData.value11.groundParams.IgnoreWater = true
function iData.value56()
	local data = {}

	if iData.value9.Character then
		data[#data + 1] = iData.value9.Character
	end

	for _, player in ipairs(iData.value2:GetPlayers()) do
		if player ~= iData.value9 and player.Character then
			data[#data + 1] = player.Character
		end
	end

	local condition = iData.value45()

	if condition then
		data[#data + 1] = condition
	end

	for _, item in ipairs(iData.value11.trapModels) do
		if item.Parent then
			data[#data + 1] = item
		end
	end

	return data
end
function iData.value57()
	iData.value11.groundParams.FilterDescendantsInstances = iData.value56()
end
iData.value10.PROBE_LOW = 7
iData.value10.PROBE_HIGH = 160
iData.value10.PROBE_DOWN = 420
iData.value10.STEP_MAX = 6
iData.value10.TRAVEL_SPEED = 1000
local function alternateHandler(parent)
	for _ = 1, 6 do
		if not parent or parent == iData.value7 then
			return false
		end

		if
			parent:IsA("Model") and parent:FindFirstChildWhichIsA("Humanoid")
			or parent:FindFirstChildWhichIsA("AnimationController")
		then
			return true
		end

		parent = parent.Parent
	end

	return false
end
iData.value58 = nil
function iData.value58(argument, secondaryArgument, differenceNumber, raycastResultNumber)
	local difference = differenceNumber

	for _ = 1, 4 do
		local raycastResult = iData.value7:Raycast(
			Vector3.new(argument, difference, secondaryArgument),
			Vector3.new(0, -(difference - (differenceNumber - raycastResultNumber)), 0),
			iData.value11.groundParams
		)

		if not raycastResult then
			return nil
		end

		if not alternateHandler(raycastResult.Instance) then
			return raycastResult.Position.Y
		end

		difference = raycastResult.Position.Y - 0.6

		if difference <= differenceNumber - raycastResultNumber then
			return nil
		end
	end

	return nil
end
function iData.value59(argument, secondaryArgument, flagNumber)
	local condition = iData.value58(
		argument,
		secondaryArgument,
		flagNumber + iData.value10.PROBE_LOW,
		iData.value10.PROBE_LOW + iData.value10.PROBE_DOWN
	)

	if condition then
		return condition
	end

	local flag = iData.value58(
		argument,
		secondaryArgument,
		flagNumber + iData.value10.PROBE_HIGH,
		iData.value10.PROBE_HIGH + iData.value10.PROBE_DOWN
	)

	if flag and flag > flagNumber + iData.value10.PROBE_LOW then
		return flag
	end

	return nil
end
function iData.value60()
	local instance = iData.value21()
	local condition = iData.value22()
	local number = instance and instance.Size.Y * 0.5 or 1
	local numberResult = 2

	if condition then
		local success, successResult = pcall(function()
			return condition.HipHeight
		end)

		if success then
			success = type(successResult) == "number" and successResult > 0
		end

		if success then
			numberResult = successResult
		end
	end

	return number + numberResult
end
iData.value11.PathService = game:GetService("PathfindingService")
iData.value10.ROUTE_SAMPLE = 14
iData.value10.ROUTE_DROP = 26
iData.value61 = nil
function iData.value61(secondaryVector, alternateVector, secondaryNumber)
	local vector = Vector3.new(alternateVector.X - secondaryVector.X, 0, alternateVector.Z - secondaryVector.Z)
	local Magnitude = vector.Magnitude

	if Magnitude < 1 then
		return true, secondaryNumber
	end

	local Unit = vector.Unit
	local number = math.ceil(Magnitude / iData.value10.ROUTE_SAMPLE)
	local flag = false
	local sumNumber = 0

	while true do
		sumNumber += 1

		if (not flag or not (number <= sumNumber)) and (flag or not (sumNumber <= number)) then
			break
		end

		local sum = secondaryVector + Unit * math.min(Magnitude, sumNumber * iData.value10.ROUTE_SAMPLE)

		if iData.value54(sum.X, sum.Z) then
			return false, secondaryNumber
		end

		local value59Result = iData.value59(sum.X, sum.Z, secondaryNumber)

		if not value59Result or math.abs(value59Result - secondaryNumber) > iData.value10.ROUTE_DROP then
			return false, secondaryNumber
		end

		secondaryNumber = value59Result
	end

	return true, secondaryNumber
end
function iData.value62(vector, flagData)
	local flag = iData.value59(vector.X, vector.Z, vector.Y)

	if not flag then
		return false
	end

	for i = 1, #flagData do
		local secondaryI = i
		local value61Result, t13Result = iData.value61(vector, flagData[secondaryI], flag)
		flag = t13Result
		if not value61Result then
			return false
		end
		vector = flagData[secondaryI]
	end

	return true
end
local hubCacheResult = iData.value11
local hubTriedResult = iData.value11
hubCacheResult.hubCache = nil
hubTriedResult.hubTried = false
iData.value63 = nil
function iData.value63(iteratorFlag, secondaryArgument)
	if not iteratorFlag then
		return nil
	end
	local zero = Vector3.zero
	local number = 0
	local iterator, state, control = ipairs(iteratorFlag:GetDescendants())
	local flag
	repeat
		local secondaryInput

		repeat
			control, secondaryInput = iterator(state, control)

			if not control then
				flag = true
			end

			if flag then
				break
			end
		until secondaryInput:IsA("BasePart")

		if flag then
			break
		end

		zero += secondaryInput.Position
		number += 1
	until secondaryArgument <= number
	flag = false
	if number == 0 then
		return nil
	end

	return zero / number
end
function iData.value64()
	if iData.value11.hubCache or iData.value11.hubTried then
		return iData.value11.hubCache
	end

	iData.value11.hubTried = true

	local quotient = iData.value63(iData.value7:FindFirstChild("Stands"), 60)

	if not quotient then
		local Plots = iData.value7:FindFirstChild("Plots")

		if Plots then
			local zero = Vector3.zero
			local quotientNumber = 0
			local GetChildren = Plots.GetChildren

			for _, item in ipairs(GetChildren(Plots)) do
				if item:IsA("Model") then
					local success, positionResult = pcall(function()
						return item:GetPivot()
					end)

					if success and positionResult then
						zero += positionResult.Position
						quotientNumber += 1
					end
				end
			end

			if quotientNumber > 0 then
				quotient = zero / quotientNumber
			end
		end
	end

	if quotient then
		local hubCacheCondition = iData.value59(quotient.X, quotient.Z, quotient.Y)
			or iData.value59(quotient.X, quotient.Z, quotient.Y + 200)

		if hubCacheCondition then
			iData.value11.hubCache = Vector3.new(quotient.X, hubCacheCondition, quotient.Z)
		end
	end

	return iData.value11.hubCache
end
function iData.value65(iData)
	local vectorData = {}

	for i = 1, #iData do
		local vector = iData[i]
		local secondaryVector = vectorData[#vectorData]

		if
			not secondaryVector
			or Vector3.new(vector.X - secondaryVector.X, 0, vector.Z - secondaryVector.Z).Magnitude > 3
		then
			vectorData[#vectorData + 1] = vector
		end
	end

	if #vectorData < 3 then
		return vectorData
	end

	local data = {}

	for i = 2, #vectorData - 1 do
		local secondaryI = i
		local vector = Vector3.new(
			vectorData[secondaryI].X - vectorData[secondaryI - 1].X,
			0,
			vectorData[secondaryI].Z - vectorData[secondaryI - 1].Z
		)
		local secondaryVector = Vector3.new(
			vectorData[secondaryI + 1].X - vectorData[secondaryI].X,
			0,
			vectorData[secondaryI + 1].Z - vectorData[secondaryI].Z
		)
		local isMagnitude = vector.Magnitude > 0.1

		if isMagnitude then
			isMagnitude = secondaryVector.Magnitude > 0.1

			if isMagnitude then
				isMagnitude = vector.Unit:Dot(secondaryVector.Unit) < 0.995
			end
		end

		if isMagnitude then
			data[#data + 1] = vectorData[secondaryI]
		end
	end

	data[#data + 1] = vectorData[#vectorData]

	return data
end
local function updateTravelStep(updateTravelStepNumber, vector)
	local success, updateTravelStepResult = pcall(function()
		return iData.value11.PathService:CreatePath({
			AgentRadius = 3,
			AgentHeight = 6,
			AgentCanJump = true,
			AgentCanClimb = false,
			WaypointSpacing = 24,
		})
	end)
	local capturedResult = updateTravelStepResult
	if not success or not capturedResult then
		return nil
	end
	local secondarySuccess = pcall(function()
		capturedResult:ComputeAsync(updateTravelStepNumber, vector)
	end)
	iData.value11.travelStep = tick()
	local Status
	local Waypoints
	pcall(function()
		Status = capturedResult.Status
	end)
	if secondarySuccess and Status == Enum.PathStatus.Success then
		pcall(function()
			Waypoints = capturedResult:GetWaypoints()
		end)
	end
	pcall(function()
		capturedResult:Destroy()
	end)
	if type(Waypoints) ~= "table" or #Waypoints < 2 then
		return nil
	end
	local updateTravelStepData = {}
	for i = 2, #Waypoints do
		updateTravelStepData[#updateTravelStepData + 1] = Waypoints[i].Position
	end
	updateTravelStepData[#updateTravelStepData] = vector

	return iData.value65(updateTravelStepData)
end
iData.value10.SIDE_OFFSETS = {
	30,
	-30,
	70,
	-70,
	140,
	-140,
	240,
	-240,
}
iData.value10.STRAIGHT_MAX = 60
iData.value66 = nil
function iData.value66(secondaryVector, secondaryArgument, alternateVector)
	if iData.value62(secondaryVector, {
		alternateVector,
		secondaryArgument,
	}) then
		return {
			alternateVector,
			secondaryArgument,
		}
	end

	local vector = Vector3.new(alternateVector.X - secondaryVector.X, 0, alternateVector.Z - secondaryVector.Z)

	if vector.Magnitude > 1 then
		local sumNumber = Vector3.new(-vector.Unit.Z, 0, vector.Unit.X)

		for i = 1, #iData.value10.SIDE_OFFSETS do
			local sum = alternateVector + sumNumber * iData.value10.SIDE_OFFSETS[i]
			local vector34Flag = iData.value59(sum.X, sum.Z, alternateVector.Y)

			if not vector34Flag then
				continue
			end

			local secondaryResult = Vector3.new(sum.X, vector34Flag, sum.Z)

			if iData.value62(secondaryVector, {
				secondaryResult,
				secondaryArgument,
			}) then
				return {
					secondaryResult,
					secondaryArgument,
				}
			end
		end
	end

	return nil
end
function iData.value67(secondaryVector, alternateVector)
	local isValue10StraightMax = Vector3.new(
		alternateVector.X - secondaryVector.X,
		0,
		alternateVector.Z - secondaryVector.Z
	).Magnitude <= iData.value10.STRAIGHT_MAX

	if isValue10StraightMax then
		isValue10StraightMax = iData.value62(secondaryVector, { alternateVector })
	end

	if isValue10StraightMax then
		return { alternateVector }
	end

	local condition = iData.value64()

	if condition then
		local value66Result = iData.value66(secondaryVector, alternateVector, condition)

		if value66Result then
			return value66Result
		end
	end

	local vector = Vector3.new(alternateVector.X - secondaryVector.X, 0, alternateVector.Z - secondaryVector.Z)

	if vector.Magnitude > 1 then
		local Unit = vector.Unit
		local sumNumber = Vector3.new(-Unit.Z, 0, Unit.X)
		local sum = secondaryVector + vector * 0.5

		for i = 1, #iData.value10.SIDE_OFFSETS do
			local vector = sum + sumNumber * iData.value10.SIDE_OFFSETS[i]
			local vector36Flag = iData.value59(vector.X, vector.Z, sum.Y)

			if not vector36Flag then
				continue
			end

			local secondaryResult = Vector3.new(vector.X, vector36Flag, vector.Z)

			if iData.value62(secondaryVector, {
				secondaryResult,
				alternateVector,
			}) then
				return {
					secondaryResult,
					alternateVector,
				}
			end
		end
	end

	local flag = updateTravelStep(secondaryVector, alternateVector)

	if flag and #flag > 0 then
		return flag
	end

	if condition then
		return {
			condition,
			alternateVector,
		}
	end

	return { alternateVector }
end
function iData.value68(secondaryVector, secondaryFlag, callback, quaternaryArgument)
	local root = iData.value21()
	local humanoid = iData.value22()
	if not root or not humanoid then
		return false
	end

	local startPosition = root.Position
	local delta = Vector3.new(secondaryVector.X - startPosition.X, 0, secondaryVector.Z - startPosition.Z)
	if delta.Magnitude <= 0.5 then
		return true
	end

	-- TP engine adapted from the standalone teleport script:
	-- move by CFrame, then immediately clear linear/angular velocity.
	-- The existing TP_WAIT is deliberately preserved; it is NOT reduced.
	local route = {secondaryVector}
	local ok, calculated = pcall(function()
		return iData.value67(startPosition, secondaryVector)
	end)
	if ok and type(calculated) == "table" and #calculated > 0 then
		route = calculated
	end

	for index = 1, #route do
		if not iData.value17()
			or quaternaryArgument ~= iData.value11.travelToken
			or (callback and not callback())
		then
			return false
		end

		local target = route[index]
		if typeof(target) ~= "Vector3" then
			continue
		end

		local groundY = iData.value59(target.X, target.Z, target.Y) or target.Y
		local targetPosition = Vector3.new(target.X, groundY, target.Z)
		local lookVector = targetPosition - root.Position
		local rotation = lookVector.Magnitude > 0.01
			and CFrame.lookAt(Vector3.zero, Vector3.new(lookVector.X, 0, lookVector.Z)).Rotation
			or CFrame.identity

		pcall(function()
			root.CFrame = CFrame.new(targetPosition) * rotation
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			if humanoid.Health > 0 then
				humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			end
		end)

		iData.value11.travelStep = tick()

		if index < #route then
			task.wait(iData.value10.TP_WAIT)
		end
	end

	local finalRoot = iData.value21()
	if not finalRoot then
		return false
	end

	return Vector3.new(
		secondaryVector.X - finalRoot.Position.X,
		0,
		secondaryVector.Z - finalRoot.Position.Z
	).Magnitude <= (secondaryFlag or 8)
end
iData.value10.TP_STEP = 400
iData.value10.TP_WAIT = 0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005
local function updateHatchCursor(secondaryVector, flag, hatchCursorCallback, quaternaryArgument)
	local updateInstancePropertiesFlag = iData.value21()

	if not updateInstancePropertiesFlag then
		return false
	end

	local Position = updateInstancePropertiesFlag.Position
	local vector = Vector3.new(secondaryVector.X - Position.X, 0, secondaryVector.Z - Position.Z)
	local Magnitude = vector.Magnitude

	if Magnitude <= 0.5 then
		return true
	end

	local Unit = vector.Unit
	local Rotation = CFrame.lookAt(Vector3.zero, Unit).Rotation
	local updateInstancePropertiesNumber = iData.value60()
	local sum = (
		iData.value59(Position.X, Position.Z, Position.Y - updateInstancePropertiesNumber)
		or Position.Y - updateInstancePropertiesNumber
	) + updateInstancePropertiesNumber
	local sumNumber = 0
	local updateHatchCursorNumber = math.ceil(Magnitude / iData.value10.TP_STEP)
	local position = Position
	local number = tick() + updateHatchCursorNumber * (iData.value10.TP_WAIT + 0.06) + 10
	local timestamp = tick()

	while
		iData.value17()
		and quaternaryArgument == iData.value11.travelToken
		and (not hatchCursorCallback or hatchCursorCallback())
	do
		local updateInstancePropertiesFlag = iData.value21()
		local updateInstancePropertiesCondition = iData.value22()
		local capturedInput = updateInstancePropertiesFlag

		if
			not capturedInput
			or (not capturedInput.Parent or (not updateInstancePropertiesCondition or updateInstancePropertiesCondition.Health <= 0))
			or number < tick()
		then
			break
		end

		if (capturedInput.Position - position).Magnitude > 2 then
			position = capturedInput.Position
			timestamp = tick()
		elseif tick() - timestamp > 0.5 then
			timestamp = tick()
			iData.value55()
		end

		sumNumber = math.min(Magnitude, sumNumber + iData.value10.TP_STEP)

		local vector = Position + Unit * sumNumber
		local updateHatchCursorNumber = iData.value59(vector.X, vector.Z, sum - updateInstancePropertiesNumber)

		if updateHatchCursorNumber then
			sum = updateHatchCursorNumber + updateInstancePropertiesNumber
		end

		pcall(function()
			capturedInput.CFrame = CFrame.new(vector.X, sum, vector.Z) * Rotation
		end)
		updateInstanceProperties(capturedInput, updateInstancePropertiesCondition)
		iData.value11.travelStep = tick()

		if sumNumber >= Magnitude - 0.01 then
			return true
		end

		task.wait(iData.value10.TP_WAIT)
	end

	if quaternaryArgument ~= iData.value11.travelToken then
		return false
	end

	local updateHatchCursorFlag = iData.value21()

	if not updateHatchCursorFlag then
		return false
	end

	return Vector3.new(
		secondaryVector.X - updateHatchCursorFlag.Position.X,
		0,
		secondaryVector.Z - updateHatchCursorFlag.Position.Z
	).Magnitude <= (flag or 8)
end
local function updateGoToTreadmill(vector, number, isUpdateHatchCursorValid, preserveTravelState)
	local updateHatchCursorFlag = iData.value21()

	if not updateHatchCursorFlag or not vector then
		return false
	end

	local updateHatchCursorNumber = number or 8

	if
		updateHatchCursorNumber
		>= Vector3.new(vector.X - updateHatchCursorFlag.Position.X, 0, vector.Z - updateHatchCursorFlag.Position.Z).Magnitude
	then
		return true
	end

	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false
	iData.value57()
	iData.value52()

	local travelToken = iData.value11.travelToken

	iData.value11.travelStep = tick()
	iData.value11.travelling = true

	local hatchCursorCallback = iData.value14.FarmMethod == "TP Walk" and updateHatchCursor or iData.value68
	local updateHatchCursorData = iData.value67(updateHatchCursorFlag.Position, vector)
	local flag = true

	for i = 1, #updateHatchCursorData do
		if
			not hatchCursorCallback(
				updateHatchCursorData[i],
				i == #updateHatchCursorData and updateHatchCursorNumber or 4,
				isUpdateHatchCursorValid,
				travelToken
			)
		then
			flag = false

			break
		end
	end

	if travelToken ~= iData.value11.travelToken then
		return false
	end

	if not preserveTravelState then
		iData.value11.travelling = false
		iData.value51()
	end

	local secondaryInput = iData.value21()

	if not secondaryInput then
		return false
	end

	return flag
		and Vector3.new(vector.X - secondaryInput.Position.X, 0, vector.Z - secondaryInput.Position.Z).Magnitude
			<= updateHatchCursorNumber + 6
end
iData.value11.travelStep = 0
secondaryHandler(iData.value3.Heartbeat:Connect(function()
	if iData.value11.travelling and tick() - iData.value11.travelStep > 6 then
		iData.value11.travelling = false
		iData.value51()
	end
end))
secondaryHandler(iData.value9.CharacterAdded:Connect(function()
	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false
	iData.value11.travelStep = 0
	iData.value11.carryingUid = nil
	iData.value11.deliverFails = 0
	iData.value11.penCache = nil
end))

local debris = iData.value7:FindFirstChild("__DEBRIS")

if debris then
	secondaryHandler(debris.ChildAdded:Connect(function()
		task.delay(0.1, function()
			if iData.value17() and iData.value14.AntiTrap then
				pcall(iData.value52)
			end
		end)
	end))
end
handler(function()
	while iData.value17() do
		if iData.value14.AntiTrap then
			pcall(iData.value52)
		end

		task.wait(3)
	end
end)
iData.value11.voidBusy = false
function iData.value69(argument)
	if not iData.value23() then
		return false
	end

	local secondaryInput = iData.value21()

	return secondaryInput ~= nil and (secondaryInput.Parent ~= nil and argument < secondaryInput.Position.Y)
end
function iData.value70()
	if iData.value11.voidBusy then
		return false
	end

	local secondaryInput = iData.value21()

	if not secondaryInput then
		return false
	end

	iData.value11.voidBusy = true
	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false

	local capturedResult = -500
	local success, successResult = pcall(function()
		return iData.value7.FallenPartsDestroyHeight
	end)

	if success then
		success = type(successResult) == "number"
	end

	if success then
		capturedResult = successResult
	end

	local sum = capturedResult + 60
	local Position = secondaryInput.Position
	local condition = iData.value22()

	if condition then
		pcall(function()
			condition:ChangeState(Enum.HumanoidStateType.Physics)
		end)
	end

	local number = tick() + 5

	while iData.value17() and number > tick() do
		local instance = iData.value21()

		if not instance or not instance.Parent then
			break
		end

		pcall(function()
			instance.CFrame = CFrame.new(Position.X, sum, Position.Z)
			instance.AssemblyLinearVelocity = Vector3.zero
			instance.AssemblyAngularVelocity = Vector3.zero
		end)
		iData.value3.Heartbeat:Wait()
	end

	local instance = iData.value21()

	if instance and instance.Parent then
		pcall(function()
			instance.CFrame = CFrame.new(Position.X, capturedResult - 250, Position.Z)
			instance.AssemblyLinearVelocity = Vector3.new(0, -280, 0)
		end)
	end

	local secondarySum = capturedResult + 200
	local alternateSum = tick() + 20
	local flag = false

	while iData.value17() and alternateSum > tick() do
		if iData.value69(secondarySum) then
			flag = true

			break
		end

		task.wait(0.2)
	end

	if not flag and iData.value17() then
		iData.value20("Using Fallback..", 5)
		iData.value27(iData.value25.RigWipe)

		local sum = tick() + 12

		while iData.value17() and sum > tick() do
			if iData.value69(secondarySum) then
				flag = true

				break
			end

			task.wait(0.2)
		end
	end

	iData.value11.voidBusy = false

	return flag
end
function iData.value71(argument)
	local Stands = iData.value7:FindFirstChild("Stands")
	local option = Stands and Stands:FindFirstChild("Prompts")
	local flag = option and option:FindFirstChild(argument)

	return flag and flag:FindFirstChildWhichIsA("ProximityPrompt") or nil
end
local function handleInput()
	local inputOption = iData.value71("SellAll") or iData.value71("Sell")
	local inputFlag = inputOption and inputOption.Parent

	if inputFlag and inputFlag:IsA("BasePart") then
		return inputFlag.CFrame * CFrame.new(0, 0, 3)
	end

	return nil
end
local cachedSlotResult = iData.value11
local cachedPlotResult = iData.value11
cachedSlotResult.cachedSlot = nil
cachedPlotResult.cachedPlot = nil
iData.value11.plotTried = 0
function iData.value72()
	if iData.value11.cachedPlot and iData.value11.cachedPlot.Parent then
		return iData.value11.cachedPlot
	end

	local Plots = iData.value7:FindFirstChild("Plots")

	if not Plots then
		return nil
	end

	if not iData.value11.cachedSlot then
		local value27Result = iData.value27(iData.value25.PlotState)

		if type(value27Result) == "table" then
			local data = value27Result.OwnersBySlot
				or (value27Result.SlotOwners or (value27Result.Owners or value27Result.Slots))

			if type(data) == "table" then
				for k, secondaryItem in pairs(data) do
					local item = secondaryItem

					if type(secondaryItem) == "table" then
						item = secondaryItem.UserId
							or (secondaryItem.OwnerUserId or (secondaryItem.Id or secondaryItem.Name))
					end

					if
						item == iData.value9.UserId
						or (item == tostring(iData.value9.UserId) or item == iData.value9.Name)
					then
						iData.value11.cachedSlot = k

						break
					end
				end
			end
		end
	end

	if iData.value11.cachedSlot then
		local cachedPlotResult = iData.value11
		local cachedPlotData = { tostring(iData.value11.cachedSlot) }

		cachedPlotResult.cachedPlot = Plots:FindFirstChild(unpackValues(cachedPlotData))

		if iData.value11.cachedPlot then
			return iData.value11.cachedPlot
		end
	end

	if tick() - iData.value11.plotTried < 10 then
		return nil
	end

	local plotTriedResult = iData.value11
	local GetChildren = Plots.GetChildren

	plotTriedResult.plotTried = tick()

	for _, cachedPlot in ipairs(GetChildren(Plots)) do
		for _, descendant in ipairs(cachedPlot:GetDescendants()) do
			local capturedDescendant = descendant

			if capturedDescendant:IsA("TextLabel") or capturedDescendant:IsA("TextButton") then
				local success, successResult = pcall(function()
					return capturedDescendant.Text
				end)

				if success then
					success = type(successResult) == "string"

					if success then
						success = #successResult > 0

						if success then
							success = successResult:find(iData.value9.Name, 1, true)
						end
					end
				end

				if success then
					iData.value11.cachedPlot = cachedPlot

					return cachedPlot
				end
			end
		end
	end

	return nil
end
local function isUpdateHatchCursorInputValid()
	local flag = iData.value72()

	if not flag then
		return nil
	end

	local success, secondaryResult = pcall(function()
		return flag:GetPivot()
	end)

	return success and secondaryResult or nil
end
iData.value11.penCache = nil
function iData.value73()
	if iData.value11.penCache then
		return iData.value11.penCache
	end

	local getDescendantsCondition = iData.value72()

	if getDescendantsCondition then
		local GetDescendants = getDescendantsCondition.GetDescendants

		for _, item in ipairs(GetDescendants(getDescendantsCondition)) do
			local capturedV = item

			if capturedV.Name:lower():find("pen", 1, true) then
				if capturedV:IsA("BasePart") then
					iData.value11.penCache = capturedV.CFrame

					return iData.value11.penCache
				end

				if capturedV:IsA("Model") then
					local success, penCacheResult = pcall(function()
						return capturedV:GetPivot()
					end)

					if success and penCacheResult then
						iData.value11.penCache = penCacheResult

						return iData.value11.penCache
					end
				end
			end
		end
	end

	local flag = iData.value72()
	local penCacheNumber

	if not flag then
		penCacheNumber = nil
	else
		local success, penCacheNumberResult = pcall(function()
			return flag:GetPivot()
		end)

		penCacheNumber = success and penCacheNumberResult or nil
	end

	if penCacheNumber then
		iData.value11.penCache = penCacheNumber * CFrame.new(0, 0, 15)

		return iData.value11.penCache
	end

	return nil
end
function iData.value74(alternatePlayer)
	local secondaryPlayer = alternatePlayer.OwnerUserId
		or (alternatePlayer.UserId or (alternatePlayer.PlayerId or alternatePlayer.Owner))

	if type(secondaryPlayer) == "table" then
		secondaryPlayer = secondaryPlayer.UserId or (secondaryPlayer.userId or secondaryPlayer.Id)
	end

	return secondaryPlayer
end
iData.value75 = nil
function iData.value75(argument)
	local value74Result = iData.value74(argument)

	if type(value74Result) == "number" then
		return value74Result == iData.value9.UserId
	end

	if type(value74Result) == "string" then
		return value74Result == tostring(iData.value9.UserId) or value74Result == iData.value9.Name
	end

	return nil
end
iData.value76 = nil
function iData.value76()
	local updateUidData = {}
	local data = {}
	local recordsData = iData.value27(iData.value25.EggLive)
	if type(recordsData) ~= "table" then
		return updateUidData
	end
	local function updateUid(secondaryUpdateUidData)
		for k, item in pairs(secondaryUpdateUidData) do
			local secondaryK = k

			if type(item) == "table" then
				local uid = item.Uid or (type(secondaryK) == "string" and secondaryK or nil)

				if uid and (not data[uid] and iData.value75(item) ~= false) then
					data[uid] = true

					if item.Uid == nil then
						item.Uid = uid
					end

					updateUidData[#updateUidData + 1] = item
				end
			end
		end
	end
	for key, item in pairs(recordsData) do
		if type(item) == "table" and (iData.value75(item) == true and type(item.Records) == "table") then
			updateUid(item.Records)
		end
	end
	if #updateUidData == 0 then
		for _, item in pairs(recordsData) do
			if type(item) == "table" and type(item.Records) == "table" then
				updateUid(item.Records)
			end
		end
	end
	if #updateUidData == 0 and type(recordsData.Records) == "table" then
		updateUid(recordsData.Records)
	end

	return updateUidData
end
function iData.value77()
	local lData = {
		l = {},
		w = {},
	}
	for index, item in ipairs(iData.value76()) do
		local Placement = item.Placement
		local l = Placement and Placement.LocalCFrame or (Placement.CFrame or Placement.WorldCFrame)

		if typeof(l) == "CFrame" then
			lData.l[#lData.l + 1] = l.Position
		elseif typeof(l) == "Vector3" then
			lData.l[#lData.l + 1] = l
		end
	end
	for _, child in ipairs(iData.value7:GetChildren()) do
		if child.Name == "PlacedEggRenders" then
			for _, item in ipairs(child:GetChildren()) do
				local capturedItem = item
				local success, wResult = pcall(function()
					if capturedItem:IsA("BasePart") then
						return capturedItem.Position
					end

					if capturedItem:IsA("Model") then
						return capturedItem:GetPivot().Position
					end

					return nil
				end)

				if success and wResult then
					lData.w[#lData.w + 1] = wResult
				end
			end
		end
	end

	return lData
end
iData.value11.originCache = nil
iData.value11.originAt = 0
local function updateData()
	if iData.value11.originCache and tick() - iData.value11.originAt < 15 then
		return iData.value11.originCache
	end

	local updateData = {}
	local updateDataCondition = iData.value72()

	if updateDataCondition then
		local success, cFrameResult = pcall(function()
			return updateDataCondition.PrimaryPart
		end)
		if success and cFrameResult then
			updateData[#updateData + 1] = cFrameResult.CFrame
		end
		local item
		local updateDataNumber = 0
		for index, secondaryItem in ipairs(updateDataCondition:GetChildren()) do
			if secondaryItem:IsA("BasePart") then
				local lower = secondaryItem.Name:lower()
				local updateDataCondition = lower:find("base", 1, true)

				if not updateDataCondition then
					updateDataCondition = lower:find("plate", 1, true)

					if not updateDataCondition then
						updateDataCondition = lower:find("pad", 1, true)
							or (
								lower:find("floor", 1, true)
								or (lower:find("ground", 1, true) or lower:find("origin", 1, true))
							)
					end
				end

				if updateDataCondition then
					local product = secondaryItem.Size.X * secondaryItem.Size.Z

					if updateDataNumber < product then
						item = secondaryItem
						updateDataNumber = product
					end
				end
			end
		end
		if item then
			updateData[#updateData + 1] = item.CFrame
		end
		local secondarySuccess, updateDataResult = pcall(function()
			return updateDataCondition:GetPivot()
		end)
		if secondarySuccess and updateDataResult then
			updateData[#updateData + 1] = updateDataResult
		end
	end

	if #updateData == 0 then
		updateData[1] = CFrame.new()
	end

	local originCache = {}

	for _, item in ipairs(updateData) do
		local updateDataFlag = true

		for _, secondaryItem in ipairs(originCache) do
			if (secondaryItem.Position - item.Position).Magnitude < 0.5 then
				updateDataFlag = false

				break
			end
		end

		if updateDataFlag then
			originCache[#originCache + 1] = item
		end
	end

	iData.value11.originCache = originCache
	iData.value11.originAt = tick()

	return originCache
end
iData.value10.RING8 = {
	{
		1,
		0,
	},
	{
		-1,
		0,
	},
	{
		0,
		1,
	},
	{
		0,
		-1,
	},
	{
		1,
		1,
	},
	{
		1,
		-1,
	},
	{
		-1,
		1,
	},
	{
		-1,
		-1,
	},
}
iData.value10.PLACE_PITCH = 6
iData.value10.PLACE_HALF = 24
iData.value10.EGG_CLEAR = 7
iData.value10.ZONE_HALF = 20
iData.value10.GRID_STEP = 4
iData.value11.claimedCells = {}
local function handleData()
	local dataNumber = updateData()[1]

	if not dataNumber then
		return {}
	end

	local w = iData.value77().w
	local sumData = {}
	local data = {}
	local product = iData.value10.EGG_CLEAR * iData.value10.EGG_CLEAR

	local function handleResult(differenceNumber, number)
		local dataNumber = 1e999

		for _, item in ipairs(w) do
			local difference = item.X - differenceNumber
			local resultNumber = item.Z - number
			local product = resultNumber * resultNumber
			local sum = difference * difference + product

			if sum < dataNumber then
				dataNumber = sum
			end
		end

		return dataNumber
	end

	local ZONE_HALF = iData.value10.ZONE_HALF
	local GRID_STEP = iData.value10.GRID_STEP
	local dataResult = -ZONE_HALF

	while dataResult <= ZONE_HALF do
		local secondaryDataResult = -ZONE_HALF

		while secondaryDataResult <= ZONE_HALF do
			(function(lx, lz)
				local vector = dataNumber * CFrame.new(lx, 0, lz)
				local dataText = math.floor(vector.X / 3) .. ":" .. math.floor(vector.Z / 3)

				if data[dataText] then
					return
				end

				local number = iData.value11.claimedCells[dataText]

				if number and tick() - number < 20 then
					return
				end

				local clrResult = handleResult(vector.X, vector.Z)

				if clrResult < product then
					return
				end

				local dataFlag = iData.value59(vector.X, vector.Z, dataNumber.Position.Y)

				if not dataFlag then
					return
				end

				data[dataText] = true

				local secondarySumData = sumData
				local sum = #sumData + 1
				local secondaryW = Vector3.new(vector.X, dataFlag, vector.Z)
				local clr = math.sqrt(clrResult)

				secondarySumData[sum] = {
					key = dataText,
					w = secondaryW,
					lx = lx,
					lz = lz,
					clr = clr,
				}
			end)(secondaryDataResult, dataResult)
			secondaryDataResult += GRID_STEP
		end

		dataResult += GRID_STEP
	end

	return sumData
end
function iData.value78()
	local Character = iData.value9.Character

	return Character ~= nil and Character:FindFirstChildWhichIsA("Tool") ~= nil
end
function iData.value79(argument)
	if iData.value78() then
		return true
	end

	for _ = 1, 8 do
		iData.value33(iData.value25.WearTool, argument)

		for _ = 1, 4 do
			iData.value3.Heartbeat:Wait()

			if iData.value78() then
				return true
			end
		end
	end

	return false
end
iData.value10.SHAPE_FILE = "ShardPlaceShape.txt"
iData.value11.placeOK = nil
iData.value11.placeWhy = ""
iData.value11.placeLog = {}
iData.value11.placeFails = 0
function iData.value80(displayValue, secondaryDisplayValue)
	iData.value11.placeLog[#iData.value11.placeLog + 1] = tostring(displayValue)
		.. " "
		.. tostring(secondaryDisplayValue)

	if #iData.value11.placeLog > 12 then
		table.remove(iData.value11.placeLog, 1)
	end
end
function iData.value81()
	if iData.value11.placeOK and type(writefile) == "function" then
		pcall(function()
			writefile(iData.value10.SHAPE_FILE, (tostring(iData.value11.placeOK.origin)))
		end)
	end
end
if type(isfile) == "function" and type(readfile) == "function" then
	local success, numberResult = pcall(function()
		if isfile(iData.value10.SHAPE_FILE) then
			return readfile(iData.value10.SHAPE_FILE)
		end

		return nil
	end)
	local placeOkNumber = success and tonumber(numberResult) or nil

	if placeOkNumber and placeOkNumber >= 1 then
		iData.value11.placeOK = {
			origin = math.floor(placeOkNumber),
		}
	end
end
local function sendEggPlace(uid, sendEggPlaceText, positionNumber)
	local positionFlag = updateData()[sendEggPlaceText]

	if not positionFlag then
		return false
	end

	local remoteFunction = iData.value26(iData.value25.EggPlace)

	if not remoteFunction or not remoteFunction:IsA("RemoteFunction") then
		return false
	end

	if not iData.value78() then
		return false
	end

	local Position = (positionFlag:Inverse() * positionNumber).Position
	local cFrame = CFrame.new(Position)
	local success, whyResult = pcall(function()
		return remoteFunction:InvokeServer({
			Uid = uid,
			LocalCFrame = cFrame,
		})
	end)

	if not success then
		if type(whyResult) == "string" and #whyResult > 0 then
			iData.value11.placeWhy = whyResult:sub(1, 140)
		end

		iData.value80("O" .. sendEggPlaceText, whyResult)

		return false
	end

	if type(whyResult) == "string" and #whyResult > 0 then
		iData.value11.placeWhy = whyResult:sub(1, 140)
		iData.value80("O" .. sendEggPlaceText, whyResult)
	elseif type(whyResult) == "table" then
		local placeWhyOption = whyResult.Error or (whyResult.Reason or (whyResult.Message or whyResult.Why))

		if type(placeWhyOption) == "string" and #placeWhyOption > 0 then
			iData.value11.placeWhy = placeWhyOption:sub(1, 140)
		end

		iData.value80("O" .. sendEggPlaceText, placeWhyOption or "table reply")
	else
		iData.value11.placeWhy = "server returned " .. tostring(whyResult)
		iData.value80("O" .. sendEggPlaceText, "returned " .. tostring(whyResult))
	end

	for _ = 1, 16 do
		if not iData.value78() then
			return true
		end

		iData.value3.Heartbeat:Wait()
	end

	return false
end
function iData.value82(uid, secondaryArgument)
	local cFrame = CFrame.new(secondaryArgument.w)
	local data = updateData()

	if iData.value11.placeOK and data[iData.value11.placeOK.origin] then
		return sendEggPlace(uid, iData.value11.placeOK.origin, cFrame)
	end

	for i = 1, #data do
		local secondaryI = i

		if sendEggPlace(uid, secondaryI, cFrame) then
			iData.value11.placeOK = {
				origin = secondaryI,
			}
			iData.value81()

			return true
		end

		task.wait(0.04)
	end

	return false
end
local function secondaryUpdateInstanceProperties(updateInstancePropertiesText, updateInstancePropertiesFlag)
	local updateInstancePropertiesOption = updateInstancePropertiesFlag or 18
	if not iData.value79(updateInstancePropertiesText) then
		iData.value11.placeWhy = "egg never reached the hand"

		return false, false
	end
	local updateInstancePropertiesCondition = iData.value9.Character
		and iData.value9.Character:FindFirstChildWhichIsA("Tool")
	if updateInstancePropertiesCondition then
		local UID = updateInstancePropertiesCondition:GetAttribute("UID")

		if UID == nil then
			for _, child in ipairs(updateInstancePropertiesCondition:GetChildren()) do
				if child:IsA("Model") then
					UID = child.Name:match("_(%w+)$")

					if UID then
						break
					end
				end
			end
		end

		if UID ~= nil then
			updateInstancePropertiesText = tostring(UID)
		end
	end
	if not iData.value11.placeOK then
		iData.value11.placeLog = {}
		iData.value11.placeWhy = ""
	end
	local updateInstancePropertiesData = handleData()
	local numberData = updateData()
	local updateInstancePropertiesNumber = numberData[1] and numberData[1].Position
		or (iData.value21() and iData.value21().Position or Vector3.zero)
	table.sort(updateInstancePropertiesData, function(updateInstancePropertiesArgument, secondaryArgument)
		return (updateInstancePropertiesArgument.w - updateInstancePropertiesNumber).Magnitude
			< (secondaryArgument.w - updateInstancePropertiesNumber).Magnitude
	end)
	local updateInstancePropertiesResult = #iData.value76()
	local number = 0
	for index, item in ipairs(updateInstancePropertiesData) do
		number += 1

		if iData.value82(updateInstancePropertiesText, item) then
			iData.value11.claimedCells[item.key] = tick()
			iData.value11.placeFails = 0

			return true
		end

		if not iData.value78() then
			iData.value11.placeFails = 0

			return true
		end

		if updateInstancePropertiesOption <= number then
			break
		end

		task.wait(0.04)
	end
	if not iData.value78() then
		iData.value11.placeFails = 0

		return true
	end
	if updateInstancePropertiesResult < #iData.value76() then
		iData.value11.placeFails = 0

		return true
	end
	iData.value11.placeFails = iData.value11.placeFails + 1
	if iData.value11.placeOK and iData.value11.placeFails >= 3 then
		iData.value11.placeOK = nil
		iData.value11.placeFails = 0
	end

	return false, #updateInstancePropertiesData == 0
end
function iData.value83(uid)
	if iData.value27(iData.value25.EggCarry, {
		Uid = uid,
	}) ~= true then
		return false
	end

	task.spawn(function()
		for _ = 1, 3 do
			if iData.value78() then
				return
			end

			iData.value33(iData.value25.WearTool, uid)
			task.wait(0.15)
		end
	end)

	return true
end
function iData.value84(argument)
	local flag = iData.value45()

	if not flag then
		return true
	end

	return flag:FindFirstChild(argument) ~= nil
end
iData.value10.GRAB_TOLERANCE = 8
local function isUpdateHatchCursorValid(vector, number)
	local secondaryInput = iData.value21()

	if not secondaryInput or not vector then
		return false
	end

	return (Vector3.new(secondaryInput.Position.X, 0, secondaryInput.Position.Z) - Vector3.new(vector.X, 0, vector.Z)).Magnitude
		<= (number or 12) + iData.value10.GRAB_TOLERANCE
end

-- ============================================================
-- AUTO STEAL / TARGET LOCK + ZERO-SECOND E PICKUP
-- ============================================================

iData.value11.pickupBusy = false

local function shardGetEggPrompt(uid)
    local container = iData.value46(uid)
    if not container then
        return nil
    end

    local fallback

    for _, descendant in ipairs(container:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Enabled then
            local text = (
                tostring(descendant.Name) .. " "
                .. tostring(descendant.ActionText) .. " "
                .. tostring(descendant.ObjectText)
            ):lower()

            if text:find("steal", 1, true)
                or text:find("take", 1, true)
                or text:find("grab", 1, true)
                or text:find("egg", 1, true)
                or text:find("carry", 1, true)
            then
                return descendant
            end

            fallback = fallback or descendant
        end
    end

    return fallback
end

local function shardToolMatchesUid(uid)
    local character = iData.value9.Character
    if not character then
        return false
    end

    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            local toolUid = child:GetAttribute("UID")

            if toolUid ~= nil and tostring(toolUid) == tostring(uid) then
                return true
            end

            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("Model") then
                    local suffix = descendant.Name:match("_(%w+)$")
                    if suffix and tostring(suffix) == tostring(uid) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function iData.__AutoStealZeroEPickup(uid, targetPosition, timeout)
    if iData.value11.pickupBusy then
        return false
    end

    local root = iData.value21()
    local prompt = shardGetEggPrompt(uid)

    if not root or not prompt then
        return false
    end

    iData.value11.pickupBusy = true

    local lockedPosition = targetPosition or root.Position
    local lockedCFrame = CFrame.new(
        lockedPosition.X,
        root.Position.Y,
        lockedPosition.Z
    )

    local humanoid = iData.value22()
    local oldAutoRotate

    if humanoid then
        oldAutoRotate = humanoid.AutoRotate
        pcall(function()
            humanoid.AutoRotate = false
        end)
    end

    local oldHoldDuration
    pcall(function()
        oldHoldDuration = prompt.HoldDuration
        prompt.HoldDuration = 0
    end)

    local acquired = false
    local deadline = tick() + (timeout or 1.5)

    while iData.value17()
        and iData.value14.AutoSteal
        and tick() < deadline
    do
        local currentRoot = iData.value21()

        if not currentRoot then
            break
        end

        -- Stay completely still at the target while pressing the egg prompt.
        pcall(function()
            currentRoot.CFrame = lockedCFrame
            currentRoot.AssemblyLinearVelocity = Vector3.zero
            currentRoot.AssemblyAngularVelocity = Vector3.zero
        end)

        pcall(function()
            if prompt.Parent then
                prompt.HoldDuration = 0
            end
        end)

        if shardToolMatchesUid(uid) then
            acquired = true
            break
        end

        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt, 1, true)
            elseif iData.value29 then
                iData.value29(prompt)
            end
        end)

        task.wait(0.04)

        if shardToolMatchesUid(uid) then
            acquired = true
            break
        end
    end

    pcall(function()
        if prompt.Parent and oldHoldDuration ~= nil then
            prompt.HoldDuration = oldHoldDuration
        end
    end)

    if humanoid and oldAutoRotate ~= nil then
        pcall(function()
            humanoid.AutoRotate = oldAutoRotate
        end)
    end

    iData.value11.pickupBusy = false
    return acquired
end

iData.value11.carryingUid = nil
function iData.value85(posArgument)
	local condition = iData.value47(posArgument.uid)

	if condition then
		posArgument.pos = condition.Position
	end

	return posArgument.pos
end
function iData.value86()
	return iData.value17() and iData.value14.AutoSteal
end
function iData.value87()
	for _, child in ipairs(iData.value7:GetChildren()) do
		if child.Name == "SmartPromptPart" then
			local GetChildren = child.GetChildren

			for _, item in ipairs(GetChildren(child)) do
				if not (item:IsA("ProximityPrompt") and item.Enabled) then
					continue
				end

				local lower = (item.Name .. " " .. tostring(item.ActionText) .. " " .. tostring(item.ObjectText)):lower()

				if lower:find("place", 1, true) or (lower:find("plant", 1, true) or lower:find("drop", 1, true)) then
					return item
				end
			end
		end
	end

	return nil
end
iData.value11.deliverAt = 0
iData.value11.deliverFails = 0
iData.value11.dryRuns = 0
iData.value11.warnPlantAt = 0
iData.value11.hatchAll = nil
function iData.value88(updateInstancePropertiesText)
	local flag = iData.value72()
	local secondaryInput
	if not flag then
		secondaryInput = nil
	else
		local success, inputResult = pcall(function()
			return flag:GetPivot()
		end)

		secondaryInput = success and inputResult or nil
	end
	if secondaryInput and not isUpdateHatchCursorValid(secondaryInput.Position, 26) then
		updateGoToTreadmill(secondaryInput.Position, 14, iData.value86)
	end
	local alternateInput = iData.value73()
	if alternateInput and not isUpdateHatchCursorValid(alternateInput.Position, 12) then
		updateGoToTreadmill(alternateInput.Position, 8, iData.value86)
	end
	local condition, secondaryFlag = secondaryUpdateInstanceProperties(updateInstancePropertiesText)
	if condition then
		return true
	end
	if secondaryFlag and iData.value11.hatchAll then
		pcall(iData.value11.hatchAll, false)

		if secondaryUpdateInstanceProperties(updateInstancePropertiesText) then
			return true
		end
	end
	for _, item in ipairs({ iData.value87() }) do
		if iData.value31(item) and iData.value30(item) then
			for _ = 1, 12 do
				if not iData.value78() then
					return true
				end

				iData.value3.Heartbeat:Wait()
			end
		end
	end

	return false
end
-- ============================================================
-- ============================================================
-- AUTO STEAL
-- Imported from auto.lua; all non-Auto-Steal features remain unchanged.
-- ============================================================

local function AutoStealHandleFlag()
    local root = iData.value21()
    if not root then
        return nil
    end

    iData.value49(false)

    local position = root.Position
    local bestEgg
    local bestScore

    for i = 1, #iData.value11.eggList do
        local egg = iData.value11.eggList[i]

        if iData.value50(egg) then
            local distance = (egg.pos - position).Magnitude
            local tierOrRank = egg.tier > 0 and egg.tier or egg.rank
            local score =
                egg.rank * 1000000000000
                + tierOrRank * 100000000
                + (egg.mutated and 1000000 or 0)
                - math.min(distance, 100000)

            if not bestScore or bestScore < score then
                bestScore = score
                bestEgg = egg
            end
        end
    end

    return bestEgg
end

iData.value11.travelling = false
iData.value11.travelToken = 0
iData.value11.carryingUid = nil
iData.value11.deliverAt = 0
iData.value11.deliverFails = 0
iData.value11.dryRuns = 0
iData.value11.warnPlantAt = 0
iData.value11.carryingLastPos = nil

local AutoStealDropRecoveryRadius = 22

local function AutoStealCharacterReady()
    return iData.value23()
end

local function AutoStealDeliverEgg(uid)
    local plot = iData.value72()
    local plotPivot

    if plot then
        local ok, pivot = pcall(function()
            return plot:GetPivot()
        end)
        plotPivot = ok and pivot or nil
    end

    if plotPivot and not isUpdateHatchCursorValid(plotPivot.Position, 26) then
        updateGoToTreadmill(plotPivot.Position, 14, AutoStealCharacterReady)
    end

    local deliveryPosition = iData.value73()
    if deliveryPosition and not isUpdateHatchCursorValid(deliveryPosition.Position, 12) then
        updateGoToTreadmill(deliveryPosition.Position, 8, AutoStealCharacterReady)
    end

    local placed, empty = iData.value81(uid)
    if placed then
        return true
    end

    if empty and iData.value11.hatchAll then
        pcall(iData.value11.hatchAll, false)

        if iData.value81(uid) then
            return true
        end
    end

    local prompt = iData.value87()
    if iData.value31(prompt) and iData.value30(prompt) then
        for _ = 1, 12 do
            if not iData.value78() then
                return true
            end

            iData.value3.Heartbeat:Wait()
        end
    end

    return false
end

local function AutoStealIsNearHome()
    local root = iData.value21()
    if not root then
        return false
    end

    local homePosition
    local plot = iData.value72()
    if plot then
        pcall(function()
            homePosition = plot:GetPivot().Position
        end)
    end

    local deliveryPosition = iData.value73()
    if deliveryPosition then
        homePosition = deliveryPosition.Position
    end

    return homePosition and (root.Position - homePosition).Magnitude <= 30 or false
end

local function AutoStealRecoverDroppedEgg()
    local droppedAt = iData.value11.carryingLastPos
    if not droppedAt or AutoStealIsNearHome() then
        return false
    end

    iData.value49(false)

    local closestEgg
    local closestDistance

    for i = 1, #iData.value11.eggList do
        local egg = iData.value11.eggList[i]

        if iData.value50(egg) and egg.pos then
            local distance = (egg.pos - droppedAt).Magnitude
            if distance <= AutoStealDropRecoveryRadius
                and (not closestDistance or distance < closestDistance)
                and iData.value84(egg.uid)
            then
                closestEgg = egg
                closestDistance = distance
            end
        end
    end

    if not closestEgg then
        return false
    end

    local retryDistance = math.max(7, closestEgg.size * 0.6 + 5)
    local targetPosition = iData.value85(closestEgg)

    if not isUpdateHatchCursorValid(targetPosition, retryDistance) then
        updateGoToTreadmill(
            targetPosition,
            retryDistance,
            function()
                return AutoStealCharacterReady()
                    and iData.value84(closestEgg.uid)
            end
        )
    end

    if not AutoStealCharacterReady() then
        return false
    end

    if not iData.value84(closestEgg.uid) then
        return false
    end

    if iData.value83(closestEgg.uid) then
        iData.value11.carryingUid = closestEgg.uid
        iData.value11.carryingLastPos = closestEgg.pos
        iData.value11.deliverAt = tick()
        iData.value11.deliverFails = 0
        return true
    end

    return false
end

local function AutoStealLoop()
    while iData.value17() do
        local waitTime = 0.1

        if iData.value14.AutoSteal and AutoStealCharacterReady() then
            local success, operationError = pcall(function()
                if iData.value11.carryingUid then
                    if iData.value78() then
                        local root = iData.value21()
                        if root then
                            iData.value11.carryingLastPos = root.Position
                        end
                    elseif not iData.value84(iData.value11.carryingUid) then
                        local recovered = AutoStealRecoverDroppedEgg()
                        if recovered then
                            waitTime = 0
                            return
                        end

                        iData.value11.carryingUid = nil
                        iData.value11.carryingLastPos = nil
                        iData.value11.deliverFails = 0
                        return
                    end

                    if tick() - iData.value11.deliverAt < 1 then
                        return
                    end

                    iData.value11.deliverAt = tick()

                    if AutoStealDeliverEgg(iData.value11.carryingUid) then
                        iData.value11.carryingUid = nil
                        iData.value11.carryingLastPos = nil
                        iData.value11.deliverFails = 0
                        return
                    end

                    iData.value11.deliverFails += 1

                    if iData.value11.deliverFails >= 4 then
                        iData.value11.deliverFails = 0
                        iData.value33(
                            iData.value25.DoffTool,
                            iData.value11.carryingUid
                        )
                        iData.value11.carryingUid = nil
                        iData.value11.carryingLastPos = nil

                        if tick() - iData.value11.warnPlantAt > 60 then
                            iData.value11.warnPlantAt = tick()
                            iData.value20(
                                "Could not plant that egg"
                                    .. (
                                        #(
                                            iData.value11.placeWhy
                                            or ""
                                        ) > 0
                                        and ": " .. iData.value11.placeWhy
                                        or ""
                                    )
                                    .. ". Moving on to the next one.",
                                6
                            )
                        end
                    end

                    return
                end

                if iData.value14.SecretPriority
                    and iData.value11.carryingUid
                then
                    iData.value49(false)

                    for i = 1, #iData.value11.eggList do
                        local egg = iData.value11.eggList[i]

                        if egg.rank >= (iData.value10.rarityLadder.Secret or 8)
                            and iData.value50(egg)
                        then
                            local carryingEgg

                            for j = 1, #iData.value11.eggList do
                                if iData.value11.eggList[j].uid
                                    == iData.value11.carryingUid
                                then
                                    carryingEgg = iData.value11.eggList[j]
                                    break
                                end
                            end

                            if not ((carryingEgg and carryingEgg.rank or 0) < egg.rank) then
                                break
                            end

                            pcall(function()
                                iData.value33(
                                    iData.value25.DoffTool,
                                    iData.value11.carryingUid
                                )
                            end)

                            iData.value11.carryingUid = nil
                            iData.value11.deliverFails = 0
                            iData.value11.travelToken += 1
                            iData.value11.travelling = false

                            iData.value20(
                                "Secret egg spotted — switching targets!",
                                4
                            )

                            break
                        end
                    end
                end

                local target = AutoStealHandleFlag()

                if not target then
                    iData.value11.dryRuns += 1
                    iData.value49(true)
                    waitTime = math.min(
                        0.6 + iData.value11.dryRuns * 0.4,
                        3
                    )
                    return
                end

                iData.value11.dryRuns = 0
                iData.value11.triedUids[target.uid] = tick()

                local retryDistance = math.max(
                    9,
                    target.size * 0.6 + 7
                )

                local function targetStillValid()
                    return AutoStealCharacterReady()
                        and iData.value84(target.uid)
                end

                local targetPosition = iData.value85(target)

                if not isUpdateHatchCursorValid(
                    targetPosition,
                    retryDistance
                ) then
                    updateGoToTreadmill(
                        targetPosition,
                        retryDistance,
                        targetStillValid
                    )

                    if not AutoStealCharacterReady() then
                        return
                    end

                    targetPosition = iData.value85(target)

                    if not isUpdateHatchCursorValid(
                        targetPosition,
                        retryDistance
                    ) then
                        updateGoToTreadmill(
                            targetPosition,
                            retryDistance,
                            targetStillValid
                        )

                        if not AutoStealCharacterReady() then
                            return
                        end
                    end
                end

                local pickedUp = false

                if iData.value14.FarmMethod == "TP" then
                    -- After reaching the egg, keep hammering pickup for 3 seconds.
                    local pickupDeadline = tick() + 3
                    while tick() < pickupDeadline
                        and AutoStealCharacterReady()
                        and iData.value14.AutoSteal
                        and iData.value84(target.uid)
                    do
                        if iData.value83(target.uid) then
                            pickedUp = true
                            if iData.value78() then
                                break
                            end
                        end
                        task.wait(0.0008)
                    end
                else
                    pickedUp = iData.value83(target.uid)

                    if not pickedUp then
                        task.wait(0.1)
                        pickedUp = iData.value83(target.uid)
                    end
                end

                if pickedUp then
                    iData.value11.failUids[target.uid] = nil
                    iData.value11.carryingUid = target.uid
                    local root = iData.value21()
                    iData.value11.carryingLastPos = root and root.Position or target.pos
                    iData.value11.deliverAt = tick()
                    iData.value11.deliverFails = 0

                    if AutoStealDeliverEgg(target.uid) then
                        iData.value11.carryingUid = nil
                        iData.value11.carryingLastPos = nil
                    else
                        iData.value11.deliverFails = 1
                    end

                    waitTime = 0
                    return
                end

                iData.value11.failUids[target.uid] =
                    (iData.value11.failUids[target.uid] or 0) + 1
            end)

            if not success then
                warn("[Shard] steal: " .. tostring(operationError))
                task.wait(0.5)
            end
        else
            waitTime = 0.3
        end

        if waitTime > 0 then
            task.wait(waitTime)
        else
            iData.value3.Heartbeat:Wait()
        end
    end
end

handler(AutoStealLoop)

local moveKeysResult = iData.value10
local W = Enum.KeyCode.W
local w = Vector3.new(0, 0, -1)
local S = Enum.KeyCode.S
local s = Vector3.new(0, 0, 1)
local A = Enum.KeyCode.A
local a = Vector3.new(-1, 0, 0)
local D = Enum.KeyCode.D
local d = Vector3.new(1, 0, 0)

moveKeysResult.MOVE_KEYS = {
	[W] = w,
	[S] = s,
	[A] = a,
	[D] = d,
}
iData.value11.held = {}
secondaryHandler(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if iData.value10.MOVE_KEYS[input.KeyCode] then
		iData.value11.held[input.KeyCode] = true
	end
end))
secondaryHandler(UserInputService.InputEnded:Connect(function(input)
	if iData.value10.MOVE_KEYS[input.KeyCode] then
		iData.value11.held[input.KeyCode] = nil
	end
end))
secondaryHandler(unpackValues({
	UserInputService.JumpRequest:Connect(function()
		if not iData.value14.HumReady or iData.value11.travelling then
			return
		end

		local flag = iData.value22()

		if flag and flag.Health > 0 then
			pcall(function()
				flag:ChangeState(Enum.HumanoidStateType.Jumping)
			end)
		end
	end),
}))
iData.value89 = nil
function iData.value89()
	local CurrentCamera = iData.value7.CurrentCamera
	if not CurrentCamera then
		return Vector3.zero
	end
	local zero = Vector3.zero
	for key, item in pairs(iData.value10.MOVE_KEYS) do
		if iData.value11.held[key] then
			zero += item
		end
	end
	if zero.Magnitude < 0.01 then
		return Vector3.zero
	end
	local CurrentCameraCFrame = CurrentCamera.CFrame
	local difference = CurrentCameraCFrame.RightVector * zero.X - CurrentCameraCFrame.LookVector * zero.Z

	return Vector3.new(difference.X, 0, difference.Z)
end
handler(function()
	while iData.value17() do
		iData.value3.Heartbeat:Wait()

		if iData.value14.HumReady and (not iData.value11.travelling and not iData.value14.AutoTreadmill) then
			local flag = iData.value22()

			if flag and flag.Health > 0 then
				local vector = iData.value89()

				if vector.Magnitude > 0.01 then
					flag:Move(vector.Unit, false)
				end
			end
		end
	end
end)
secondaryHandler(iData.value9.CharacterAdded:Connect(function(character)
	iData.value14.HumReady = false
	iData.value11.carryingUid = nil
	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false
	pcall(function()
		character:WaitForChild("HumanoidRootPart", 10)
	end)
	task.wait(0.7)

	if iData.value14.AutoSteal then
		if iData.value14.AntiCheat and (not iData.value14.HumReady and iData.value23()) then
			createAutoStealHumanoid()

			return
		end

		local _ = iData.value14.HumReady
	end
end))
iData.value11.hatchCursor = 0
local function hatchAll(updateHatchCursorCondition)
	if updateHatchCursorCondition then
		local updateHatchCursorFlag = isUpdateHatchCursorInputValid()

		if not updateHatchCursorFlag then
		elseif not isUpdateHatchCursorValid(updateHatchCursorFlag.Position, 20) then
			updateGoToTreadmill(updateHatchCursorFlag.Position, 12)
		end
	end

	local updateHatchCursorData = iData.value76()
	local updateHatchCursorNumber = #updateHatchCursorData

	if updateHatchCursorNumber == 0 then
		iData.value11.hatchCursor = 0
	else
		if updateHatchCursorNumber <= iData.value11.hatchCursor then
			iData.value11.hatchCursor = 0
		end

		local hatchCursorNumber = updateHatchCursorCondition and updateHatchCursorNumber
			or math.min(updateHatchCursorNumber, 12)
		local updateHatchCursorFlag = false
		local flagNumber = 0

		while true do
			flagNumber += 1

			if
				(not updateHatchCursorFlag or not (hatchCursorNumber <= flagNumber))
				and (updateHatchCursorFlag or not (flagNumber <= hatchCursorNumber))
			then
				break
			end

			local conditionFlag =
				updateHatchCursorData[(iData.value11.hatchCursor + flagNumber - 1) % updateHatchCursorNumber + 1]
			local updateHatchCursorCondition = conditionFlag and conditionFlag.Uid

			if updateHatchCursorCondition then
				iData.value33(iData.value25.SkipGrowth, updateHatchCursorCondition)
				iData.value33(iData.value25.Hatch, updateHatchCursorCondition)
				iData.value33(iData.value25.HatchFinish, updateHatchCursorCondition)
				task.wait(0.06)
			end
		end

		iData.value11.hatchCursor = (iData.value11.hatchCursor + hatchCursorNumber) % updateHatchCursorNumber
	end

	local number = 0

	if updateHatchCursorNumber > 0 then
		local secondaryUpdateHatchCursorNumber = #iData.value76()

		if secondaryUpdateHatchCursorNumber < updateHatchCursorNumber then
			number = updateHatchCursorNumber - secondaryUpdateHatchCursorNumber
		end
	end

	if number == 0 then
		for _, item in
			ipairs(iData.value32(iData.value72(), {
				"hatch",
				"open",
			}))
		do
			if iData.value31(item) and iData.value30(item) then
				number += 1
				task.wait(0.08)
			end
		end
	end

	return number
end
iData.value11.hatchAll = hatchAll
handler(function()
	while iData.value17() do
		if
			iData.value14.AutoHatch
			or iData.value14.HatchOnce and (iData.value23() and not iData.value11.travelling)
		then
			iData.value14.HatchOnce = false
			pcall(hatchAll, false)
		end

		task.wait(2)
	end
end)

local rarityColorResult = iData.value13
local common = Color3.fromRGB(190, 190, 190)
local uncommon = Color3.fromRGB(120, 220, 120)
local rare = Color3.fromRGB(90, 160, 255)
local epic = Color3.fromRGB(180, 110, 255)
local legendary = Color3.fromRGB(255, 200, 70)
local mythic = Color3.fromRGB(255, 110, 190)
local cosmic = Color3.fromRGB(130, 240, 255)
local secret = Color3.fromRGB(60, 60, 70)
local divine = Color3.fromRGB(255, 250, 200)
local eternal = Color3.fromRGB(255, 90, 90)

rarityColorResult.rarityColor = {
	Common = common,
	Uncommon = uncommon,
	Rare = rare,
	Epic = epic,
	Legendary = legendary,
	Mythic = mythic,
	Cosmic = cosmic,
	Secret = secret,
	Divine = divine,
	Eternal = eternal,
}
iData.value11.espFolder = nil
iData.value11.espTags = {}
iData.value90 = nil
function iData.value90()
	if iData.value11.espFolder and iData.value11.espFolder.Parent then
		return iData.value11.espFolder
	end

	iData.value11.espFolder = Instance.new("Folder")
	iData.value11.espFolder.Name = "ShardEggESP"
	iData.value11.espFolder.Parent = gethui and gethui() or game:GetService("CoreGui")

	return iData.value11.espFolder
end
function iData.value91()
	for key, item in pairs(iData.value11.espTags) do
		local capturedItem = item

		pcall(function()
			capturedItem:Destroy()
		end)
		iData.value11.espTags[key] = nil
	end
	if iData.value11.espFolder then
		pcall(function()
			iData.value11.espFolder:Destroy()
		end)
		iData.value11.espFolder = nil
	end
end
function iData.value92(uidArgument)
	local adornee = iData.value46(uidArgument.uid)
	local secondaryAdornee = iData.value47(uidArgument.uid)

	if not adornee or not secondaryAdornee then
		return nil
	end

	local fillColor = iData.value13.rarityColor[uidArgument.rarity] or Color3.fromRGB(255, 255, 255)
	local Folder = Instance.new("Folder")

	Folder.Name = uidArgument.uid

	local Highlight = Instance.new("Highlight")

	Highlight.Adornee = adornee
	Highlight.FillColor = fillColor
	Highlight.OutlineColor = uidArgument.mutated and Color3.fromRGB(255, 150, 60) or fillColor
	Highlight.FillTransparency = 0.62
	Highlight.OutlineTransparency = 0
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Parent = Folder

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Adornee = secondaryAdornee
	BillboardGui.Size = UDim2.fromOffset(190, 26)
	BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.MaxDistance = 100000
	BillboardGui.Parent = Folder

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.fromScale(1, 1)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 13
	TextLabel.TextColor3 = fillColor
	TextLabel.TextStrokeTransparency = 0.35
	TextLabel.Text = (uidArgument.rarity or (uidArgument.label or "Egg")) .. (not uidArgument.mutated and "" or "  MUT")
	TextLabel.Parent = BillboardGui
	Folder.Parent = iData.value90()

	return Folder
end
handler(function()
	while iData.value17() do
		if iData.value14.EggESP then
			pcall(function()
				local data = iData.value49(false)
				local uidData = {}
				for index, item in ipairs(data) do
					uidData[item.uid] = true

					local uid = iData.value11.espTags[item.uid]

					if not uid or (not uid.Parent or not iData.value46(item.uid)) then
						if uid then
							pcall(function()
								uid:Destroy()
							end)
						end

						iData.value11.espTags[item.uid] = iData.value92(item)
					end
				end
				for k, item in pairs(iData.value11.espTags) do
					local capturedV = item
					local secondaryK = k

					if not uidData[secondaryK] then
						pcall(function()
							capturedV:Destroy()
						end)
						iData.value11.espTags[secondaryK] = nil
					end
				end
			end)
		elseif next(iData.value11.espTags) then
			iData.value91()
		end

		task.wait(1.2)
	end
end)
iData.value11.Lighting = game:GetService("Lighting")
iData.value11.fpsSaved = nil
iData.value11.hiddenParts = {}
iData.value11.hiddenGuis = {}
iData.value11.killedFx = {}
function iData.value93(argument)
	for _, player in ipairs(iData.value2:GetPlayers()) do
		local Character = player.Character

		if Character and argument == Character or argument:IsDescendantOf(Character) then
			return true
		end
	end

	return false
end
local function additionalHandler(parent)
	for _ = 1, 8 do
		if not parent or parent == iData.value7 then
			return false
		end

		local lower = parent.Name:lower()

		if lower:find("pet") or lower:find("pen") then
			return true
		end

		parent = parent.Parent
	end

	return false
end
function iData.value94()
	local data = {}

	for _, child in ipairs(iData.value7:GetChildren()) do
		local lower = child.Name:lower()

		if lower:find("pet") or lower:find("pen") then
			data[#data + 1] = child
		end
	end

	local Plots = iData.value7:FindFirstChild("Plots")

	if Plots then
		data[#data + 1] = Plots
	end

	return data
end
function iData.value95(localValueTransparencyModifierArgument)
	if iData.value11.hiddenParts[localValueTransparencyModifierArgument] ~= nil then
		return
	end

	iData.value11.hiddenParts[localValueTransparencyModifierArgument] =
		localValueTransparencyModifierArgument.LocalTransparencyModifier
	pcall(function()
		localValueTransparencyModifierArgument.LocalTransparencyModifier = 1
	end)
end
function iData.value96(enabledArgument)
	if iData.value11.hiddenGuis[enabledArgument] ~= nil then
		return
	end

	iData.value11.hiddenGuis[enabledArgument] = enabledArgument.Enabled
	pcall(function()
		enabledArgument.Enabled = false
	end)
end
iData.value97 = nil
function iData.value97(enabledArgument)
	if iData.value11.killedFx[enabledArgument] ~= nil then
		return
	end

	local condition = enabledArgument:IsA("ParticleEmitter")

	if not condition then
		condition = enabledArgument:IsA("Trail")

		if not condition then
			condition = enabledArgument:IsA("Beam")

			if not condition then
				condition = enabledArgument:IsA("Smoke")

				if not condition then
					condition = enabledArgument:IsA("Fire")
						or (enabledArgument:IsA("Sparkles") or enabledArgument:IsA("PostEffect"))
				end
			end
		end
	end

	if condition then
		iData.value11.killedFx[enabledArgument] = enabledArgument.Enabled
		pcall(function()
			enabledArgument.Enabled = false
		end)
	end
end
function iData.value98(data)
	for i = 1, #data do
		local parent = data[i]

		iData.value97(parent)

		if not iData.value93(parent) and additionalHandler(parent) then
			if parent:IsA("BasePart") then
				iData.value95(parent)
			elseif parent:IsA("BillboardGui") then
				iData.value96(parent)
			end
		end
	end
end
function iData.value99()
	local Terrain = iData.value7:FindFirstChildWhichIsA("Terrain")

	if not iData.value11.fpsSaved then
		local fpsSavedResult = iData.value11
		local GlobalShadows = iData.value11.Lighting.GlobalShadows
		local EnvironmentDiffuseScale = iData.value11.Lighting.EnvironmentDiffuseScale
		local EnvironmentSpecularScale = iData.value11.Lighting.EnvironmentSpecularScale
		local FogEnd = iData.value11.Lighting.FogEnd

		fpsSavedResult.fpsSaved = {
			shadows = GlobalShadows,
			diffuse = EnvironmentDiffuseScale,
			specular = EnvironmentSpecularScale,
			fogEnd = FogEnd,
			terrain = Terrain,
		}
		pcall(function()
			iData.value11.fpsSaved.quality = settings().Rendering.QualityLevel
		end)

		if Terrain then
			iData.value11.fpsSaved.waveSize = Terrain.WaterWaveSize
			iData.value11.fpsSaved.waveSpeed = Terrain.WaterWaveSpeed
			iData.value11.fpsSaved.reflect = Terrain.WaterReflectance
		end
	end

	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)
	pcall(function()
		iData.value11.Lighting.GlobalShadows = false
	end)
	pcall(function()
		iData.value11.Lighting.EnvironmentDiffuseScale = 0
	end)
	pcall(function()
		iData.value11.Lighting.EnvironmentSpecularScale = 0
	end)
	pcall(function()
		iData.value11.Lighting.FogEnd = 100000
	end)

	if Terrain then
		pcall(function()
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
		end)
	end

	for _, child in ipairs(iData.value11.Lighting:GetChildren()) do
		iData.value97(child)
	end

	iData.value98(iData.value7:GetDescendants())
end
function iData.value100()
	for key, item in pairs(iData.value11.hiddenParts) do
		local capturedKey = key
		local localValueTransparencyModifier = item

		pcall(function()
			capturedKey.LocalTransparencyModifier = localValueTransparencyModifier
		end)
		iData.value11.hiddenParts[capturedKey] = nil
	end
	for k, item in pairs(iData.value11.hiddenGuis) do
		local capturedV = item

		pcall(function()
			k.Enabled = capturedV
		end)
		iData.value11.hiddenGuis[k] = nil
	end
	for key, item in pairs(iData.value11.killedFx) do
		local capturedKey = key
		local enabled = item

		pcall(function()
			capturedKey.Enabled = enabled
		end)
		iData.value11.killedFx[capturedKey] = nil
	end
	if not iData.value11.fpsSaved then
		return
	end
	pcall(function()
		iData.value11.Lighting.GlobalShadows = iData.value11.fpsSaved.shadows
	end)
	pcall(function()
		iData.value11.Lighting.EnvironmentDiffuseScale = iData.value11.fpsSaved.diffuse
	end)
	pcall(function()
		iData.value11.Lighting.EnvironmentSpecularScale = iData.value11.fpsSaved.specular
	end)
	pcall(function()
		iData.value11.Lighting.FogEnd = iData.value11.fpsSaved.fogEnd
	end)
	if iData.value11.fpsSaved.quality then
		pcall(function()
			settings().Rendering.QualityLevel = iData.value11.fpsSaved.quality
		end)
	end
	local terrain = iData.value11.fpsSaved.terrain
	if terrain and iData.value11.fpsSaved.waveSize then
		pcall(function()
			terrain.WaterWaveSize = iData.value11.fpsSaved.waveSize
			terrain.WaterWaveSpeed = iData.value11.fpsSaved.waveSpeed
			terrain.WaterReflectance = iData.value11.fpsSaved.reflect
		end)
	end
	iData.value11.fpsSaved = nil
end
handler(function()
	while iData.value17() do
		task.wait(3)

		if iData.value14.FpsBoost then
			pcall(function()
				for _, item in ipairs(iData.value94()) do
					local GetDescendants = item.GetDescendants

					iData.value98(GetDescendants(item))
				end
			end)
		end
	end
end)
iData.value101 = nil
function iData.value101()
	local secondaryInput = handleInput()

	if not secondaryInput then
		return false
	end

	if isUpdateHatchCursorValid(secondaryInput.Position, 14) then
		return true
	end

	return updateGoToTreadmill(secondaryInput.Position, 8)
end
function iData.value102(condition)
	if condition then
		iData.value101()
	end

	local flag = iData.value71("SellAll")

	if not (not flag or not iData.value31(flag)) then
		iData.value30(flag)
	end

	iData.value27(iData.value25.SellEveryPet)
	iData.value27(iData.value25.SatchelSale)

	return "Sold every pet"
end
handler(function()
	while iData.value17() do
		if iData.value14.AutoEquipBest and iData.value23() then
			iData.value27(iData.value25.WearBest)
		end

		task.wait(6)
	end
end)
iData.value103 = nil
function iData.value103(condition)
	if condition then
		local secondaryInput = isUpdateHatchCursorInputValid()

		if not secondaryInput then
		elseif not isUpdateHatchCursorValid(secondaryInput.Position, 20) then
			updateGoToTreadmill(secondaryInput.Position, 12)
		end
	end

	local number = 0

	for _, item in
		ipairs(iData.value32(iData.value72(), {
			"claim",
			"collect",
			"coin",
			"cash",
		}))
	do
		if iData.value31(item) and iData.value30(item) then
			number += 1
			task.wait(0.06)
		end
	end

	if iData.value27(iData.value25.Collect) then
		number += 1
	end

	if iData.value27(iData.value25.CodexAll) then
		number += 1
	end

	return number
end
function iData.value104(condition)
	if condition then
		local secondaryInput = isUpdateHatchCursorInputValid()

		if not secondaryInput then
		elseif not isUpdateHatchCursorValid(secondaryInput.Position, 20) then
			updateGoToTreadmill(secondaryInput.Position, 12)
		end
	end

	local number = 0

	for _, item in
		ipairs(iData.value32(iData.value72(), {
			"upgrade",
			"buy",
			"purchase",
			"tier",
			"level",
		}))
	do
		if iData.value31(item) and iData.value30(item) then
			number += 1
			task.wait(0.06)
		end
	end

	if iData.value27(iData.value25.BaseTierRaise) then
		number += 1
	end

	if iData.value27(iData.value25.NearbyBuy) then
		number += 1
	end

	return number
end
handler(function()
	while iData.value17() do
		if iData.value14.AutoClaim and (iData.value23() and not iData.value11.travelling) then
			pcall(iData.value103, false)
		end

		task.wait((math.clamp(iData.value14.ClaimInterval, 5, 300)))
	end
end)
handler(function()
	while iData.value17() do
		if iData.value14.AutoUpgrade and (iData.value23() and not iData.value11.travelling) then
			pcall(iData.value104, false)
		end

		task.wait((math.clamp(iData.value14.UpgradeInterval, 5, 300)))
	end
end)
iData.value10.TREAD_AVOID = {
	"upgrade",
	"tier",
	"level",
	"board",
	"sign",
	"billboard",
	"gui",
	"shop",
	"buy",
	"display",
	"screen",
	"label",
	"text",
	"icon",
	"price",
	"cost",
	"info",
	"menu",
}
function iData.value105(argument)
	local lower = argument:lower()

	for i = 1, #iData.value10.TREAD_AVOID do
		if lower:find(iData.value10.TREAD_AVOID[i], 1, true) then
			return true
		end
	end

	return false
end
function iData.value106(instance, data)
	if not instance then
		return data
	end

	if
		instance:IsA("Model")
		or instance:IsA("BasePart")
			and (instance.Name:lower():find("treadmill", 1, true) and not iData.value105(instance.Name))
	then
		data[#data + 1] = instance
	end

	for _, descendant in ipairs(instance:GetDescendants()) do
		if
			descendant:IsA("Model")
			or descendant:IsA("BasePart")
				and (descendant.Name:lower():find("treadmill", 1, true) and not iData.value105(descendant.Name))
		then
			data[#data + 1] = descendant
		end
	end

	return data
end
function iData.value107(secondaryInput)
	if secondaryInput:IsA("BasePart") then
		return secondaryInput.Position
	end

	local success, positionResult = pcall(function()
		return secondaryInput:GetPivot()
	end)

	return success and (not not positionResult and positionResult.Position) or nil
end
iData.value11.treadCache = nil
local function updateTreadCache()
	if iData.value11.treadCache and iData.value11.treadCache.Parent then
		return iData.value11.treadCache
	end
	local updateTreadCacheData = {}
	iData.value106(iData.value72(), updateTreadCacheData)
	if #updateTreadCacheData == 0 then
		iData.value106(iData.value7:FindFirstChild("Treadmills"), updateTreadCacheData)
	end
	if #updateTreadCacheData == 0 then
		iData.value106(iData.value7:FindFirstChild("Stands"), updateTreadCacheData)
	end
	if #updateTreadCacheData == 0 then
		for _, child in ipairs(iData.value7:GetChildren()) do
			if child.Name:lower():find("tread", 1, true) then
				iData.value106(child, updateTreadCacheData)
			end
		end
	end
	if #updateTreadCacheData == 0 then
		return nil
	end
	local updateTreadCacheFlag = iData.value72()
	local position
	if not updateTreadCacheFlag then
		position = nil
	else
		local success, updateTreadCacheResult = pcall(function()
			return updateTreadCacheFlag:GetPivot()
		end)

		position = success and updateTreadCacheResult or nil
	end
	local secondaryInput = iData.value21()
	if position then
		position = position.Position
	end
	local updateTreadCacheNumber = position or secondaryInput and secondaryInput.Position
	local number
	local treadCache
	for i = 1, #updateTreadCacheData do
		local secondaryI = i
		local optionNumber = iData.value107(updateTreadCacheData[secondaryI])

		if optionNumber then
			local updateTreadCacheOption = updateTreadCacheNumber and (optionNumber - updateTreadCacheNumber).Magnitude
			local updateTreadCacheResult = updateTreadCacheData[secondaryI]
			local differenceNumber = updateTreadCacheOption or 0
			local difference = (not updateTreadCacheResult:IsA("Model") and 0 or 40) - differenceNumber

			if not number or number < difference then
				number = difference
				treadCache = updateTreadCacheData[secondaryI]
			end
		end
	end
	iData.value11.treadCache = treadCache

	return iData.value11.treadCache
end
local function handleCondition()
	local getDescendantsFlag = updateTreadCache()

	if not getDescendantsFlag then
		return nil
	end

	if getDescendantsFlag:IsA("Seat") or getDescendantsFlag:IsA("VehicleSeat") then
		return getDescendantsFlag
	end

	if getDescendantsFlag:IsA("BasePart") then
		return nil
	end

	local GetDescendants = getDescendantsFlag.GetDescendants

	for _, item in ipairs(GetDescendants(getDescendantsFlag)) do
		if item:IsA("Seat") or item:IsA("VehicleSeat") then
			return item
		end
	end

	return nil
end
iData.value10.BELT_HINTS = {
	"belt",
	"tread",
	"walk",
	"run",
	"platform",
	"floor",
	"deck",
	"pad",
}
iData.value108 = nil
function iData.value108()
	local getDescendantsFlag = updateTreadCache()
	if not getDescendantsFlag then
		return nil
	end
	if getDescendantsFlag:IsA("BasePart") then
		return getDescendantsFlag
	end
	local GetDescendants = getDescendantsFlag.GetDescendants
	local number
	local item
	for _, secondaryItem in ipairs(GetDescendants(getDescendantsFlag)) do
		if secondaryItem:IsA("BasePart") and not iData.value105(secondaryItem.Name) then
			local lower = secondaryItem.Name:lower()
			local sumNumber = 0

			for i = 1, #iData.value10.BELT_HINTS do
				if lower:find(iData.value10.BELT_HINTS[i], 1, true) then
					sumNumber = 100000

					break
				end
			end

			local sum = sumNumber + secondaryItem.Size.X * secondaryItem.Size.Z

			if not number or number < sum then
				number = sum
				item = secondaryItem
			end
		end
	end

	return item or getDescendantsFlag.PrimaryPart
end
function iData.value109()
	local condition = handleCondition()

	if condition then
		return condition.CFrame
	end

	local instance = iData.value108()

	return instance and instance.CFrame or nil
end
function iData.value110(flag)
	local value22Result = iData.value22()
	local instance = iData.value21()
	local capturedValue22Result = value22Result

	if not flag or (not capturedValue22Result or not instance) then
		return false
	end

	if capturedValue22Result.Sit then
		return true
	end

	for _, item in
		ipairs(iData.value32(updateTreadCache(), {
			"sit",
			"ride",
			"use",
			"start",
		}))
	do
		if not (iData.value31(item) and iData.value30(item)) then
			continue
		end

		task.wait(0.2)

		if capturedValue22Result.Sit then
			return true
		end
	end

	pcall(function()
		flag:Sit(capturedValue22Result)
	end)

	local cFrame = flag.CFrame * CFrame.new(0, 1.4, 0)

	for _ = 1, 24 do
		if capturedValue22Result.Sit then
			return true
		end

		pcall(function()
			instance.CFrame = cFrame
		end)
		iData.value3.Heartbeat:Wait()
	end

	return capturedValue22Result.Sit == true
end
iData.value111 = nil
function iData.value111()
	local number = 0

	if iData.value27(iData.value25.TreadRaise) then
		number += 1
	end

	local secondaryResult = updateTreadCache()

	for _, item in
		ipairs(iData.value32(secondaryResult, {
			"upgrade",
			"level",
			"tier",
			"buy",
		}))
	do
		if iData.value31(item) and iData.value30(item) then
			number += 1
			task.wait(0.06)
		end
	end

	return number
end
handler(function()
	local number = 0

	while iData.value17() do
		iData.value3.Heartbeat:Wait()

		if iData.value14.AutoTreadmill and (iData.value23() and not iData.value11.travelling) then
			local condition = handleCondition()
			local positionCondition = iData.value109()
			local secondaryInput = iData.value21()
			local option = positionCondition
			local conditionFlag = iData.value22()

			if positionCondition then
				option = secondaryInput and conditionFlag
			end

			if option then
				if
					Vector3.new(
							positionCondition.Position.X - secondaryInput.Position.X,
							0,
							positionCondition.Position.Z - secondaryInput.Position.Z
						).Magnitude
						> 12
					and not conditionFlag.Sit
				then
					updateGoToTreadmill(positionCondition.Position, 6, function()
						return iData.value17() and iData.value14.AutoTreadmill
					end)
				elseif condition then
					if not conditionFlag.Sit then
						iData.value110(condition)
					end

					if iData.value14.AutoUpgradeTreadmill and tick() - number > 4 then
						number = tick()
						pcall(iData.value111)
					end
				else
					local LookVector = positionCondition.LookVector

					if (secondaryInput.Position - positionCondition.Position):Dot(LookVector) > 6 then
						LookVector = -LookVector
					end

					pcall(function()
						conditionFlag.WalkSpeed = math.max(conditionFlag.WalkSpeed, 60)
					end)
					conditionFlag:Move(Vector3.new(LookVector.X, 0, LookVector.Z).Unit, false)

					if iData.value14.AutoUpgradeTreadmill and tick() - number > 4 then
						number = tick()
						pcall(iData.value111)
					end
				end
			end
		end
	end
end)
iData.value11.rawRequest = syn and syn.request or (http and http.request or (http_request or request))

function iData.value112(url)
	if type(iData.value11.rawRequest) == "function" then
		local success, bodyResult = pcall(iData.value11.rawRequest, {
			Url = url,
			Method = "GET",
		})

		if success then
			success = type(bodyResult) == "table" and type(bodyResult.Body) == "string"
		end

		if success then
			return bodyResult.Body
		end
	end

	local success, successResult = pcall(function()
		return game:HttpGet(url)
	end)

	if success then
		success = type(successResult) == "string"
	end

	if success then
		return successResult
	end

	return nil
end
iData.value10.HOP_FILE = "ShardHopCount.txt"
function iData.value113(shardHops)
	if writefile then
		pcall(writefile, iData.value10.HOP_FILE, (tostring(shardHops)))
	end

	if getgenv then
		getgenv().__shardHops = shardHops
	end
end
iData.value14.HopCount = (function()
	if isfile and (readfile and isfile(iData.value10.HOP_FILE)) then
		local success, result = pcall(readfile, iData.value10.HOP_FILE)
		if success then
			return tonumber(result) or 0
		end
	end

	return tonumber(getgenv and getgenv().__shardHops) or 0
end)()
iData.value11.visited = {}
iData.value11.hopping = false
function iData.value114()
	local games = "https://games.roblox.com/v1/games/"
		.. game.PlaceId
		.. "/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100"
	local flag = iData.value112(games)

	if not flag then
		return {}
	end

	local success, dataResult = pcall(function()
		return iData.value8:JSONDecode(flag)
	end)
	if not success or type(dataResult) ~= "table" or type(dataResult.data) ~= "table" then
		return {}
	end

	local exactOne = {}
	local fallback = {}

	for _, item in ipairs(dataResult.data) do
		local id = item.id
		local playing = tonumber(item.playing) or 0
		local maxPlayers = tonumber(item.maxPlayers) or 0

		if id and id ~= game.JobId and not iData.value11.visited[id] and playing < maxPlayers then
			if playing == 1 then
				exactOne[#exactOne + 1] = item
			else
				fallback[#fallback + 1] = item
			end
		end
	end

	-- Prefer servers already containing exactly one other player.
	-- Roblox's public server list does not expose a reliable server creation
	-- timestamp, so "oldest" cannot be truthfully inferred here.
	local selected = exactOne
	if #selected == 0 then
		selected = fallback
	end

	local result = {}
	for _, item in ipairs(selected) do
		result[#result + 1] = item.id
	end

	return result
end
function iData.value115()
	if iData.value11.hopping then
		return false
	end

	iData.value11.hopping = true

	local data = iData.value114()

	for _, item in ipairs(data) do
		local capturedV = item

		iData.value11.visited[capturedV] = true
		iData.value14.HopCount = (tonumber(iData.value14.HopCount) or 0) + 1
		iData.value113(iData.value14.HopCount)

		if pcall(function()
			iData.value5:TeleportToPlaceInstance(game.PlaceId, capturedV, iData.value9)
		end) then
			task.wait(6)
			iData.value11.hopping = false

			return true
		end
	end

	pcall(function()
		iData.value5:Teleport(game.PlaceId, iData.value9)
	end)
	iData.value11.hopping = false

	return #data > 0
end
function iData.value116()
	local RespawnLocation = iData.value9.RespawnLocation

	if RespawnLocation and RespawnLocation:IsA("BasePart") then
		return RespawnLocation.CFrame.Position + Vector3.new(0, 4, 0)
	end

	for _, descendant in ipairs(iData.value7:GetDescendants()) do
		if descendant:IsA("SpawnLocation") then
			return descendant.Position + Vector3.new(0, 4, 0)
		end
	end

	local flag = iData.value72()
	local secondaryInput

	if not flag then
		secondaryInput = nil
	else
		local success, inputResult = pcall(function()
			return flag:GetPivot()
		end)

		secondaryInput = success and inputResult or nil
	end

	return secondaryInput and secondaryInput.Position or nil
end
function iData.value117()
	iData.value14.Unloaded = true
	iData.value14.AutoSteal = false
	iData.value14.AutoHatch = false
	iData.value14.EggESP = false
	iData.value14.AutoEquipBest = false
	iData.value14.AutoClaim = false
	iData.value14.AutoUpgrade = false
	iData.value14.AutoTreadmill = false
	iData.value14.AutoUpgradeTreadmill = false
	iData.value14.FpsBoost = false
	iData.value11.travelToken = iData.value11.travelToken + 1
	iData.value11.travelling = false
	iData.value100()
	iData.value91()
	for index, item in ipairs(iData.value16) do
		local capturedItem = item

		pcall(function()
			capturedItem:Disconnect()
		end)
	end
	for _, item in ipairs(iData.value15) do
		pcall(task.cancel, item)
	end
	iData.value51()
end
function iData.value118(secondaryData)
	local data = {}

	if type(secondaryData) == "table" then
		for k, item in pairs(secondaryData) do
			if item == true then
				data[#data + 1] = k
			elseif type(item) == "string" then
				data[#data + 1] = item
			end
		end

		return data
	end

	if type(secondaryData) == "string" then
		data[1] = secondaryData
	end

	return data
end
iData.value10.filterValues = {}
for _, secondaryFilterValues in ipairs(iData.value10.Rarities) do
	iData.value10.filterValues[#iData.value10.filterValues + 1] = secondaryFilterValues
end

--[[
    PHUCMAX • LIQUID GLASS UI v4
    ----------------------------------------------------------
    CHANGES:
    ✓ Fixed list popup being covered by buttons (now on top)
    ✓ Four physical tabs: MAIN / PLAYER / VISUAL / MISC
    ✓ No demo controls
    ✓ Auto Steal is fully automatic
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChildOfClass("PlayerGui")
if not PlayerGui then
    PlayerGui = Player:WaitForChild("PlayerGui", 5)
end

if not PlayerGui then
    local fallbackParent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")
    PlayerGui = fallbackParent
end

------------------------------------------------------------
-- CONFIG
------------------------------------------------------------

local CONFIG = {
    MAIN_WIDTH = 318,
    MAIN_HEIGHT = 490,

    MIN_WIDTH = 270,
    MIN_HEIGHT = 360,

    MAX_WIDTH = 430,
    MAX_HEIGHT = 680,

    TOGGLE_SIZE = 54,

    MAIN_BACKGROUND = "rbxassetid://114446605486001",
    TOGGLE_BACKGROUND = "rbxassetid://120164064781939",

    ANIMATION = 0.32,

    COLORS = {
        Silver = Color3.fromRGB(225, 230, 238),
        SilverBright = Color3.fromRGB(255, 255, 255),

        Navy = Color3.fromRGB(8, 18, 42),
        NavyDark = Color3.fromRGB(3, 8, 22),

        Violet = Color3.fromRGB(68, 52, 125),
        IcePurple = Color3.fromRGB(153, 143, 255),

        Text = Color3.fromRGB(248, 249, 255),
        SubText = Color3.fromRGB(181, 188, 210),
    }
}

------------------------------------------------------------
-- CLEANUP
------------------------------------------------------------

local Old = PlayerGui:FindFirstChild("PHUCMAX_LiquidGlass")
if Old then
    Old:Destroy()
end

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------

local function Tween(obj, properties, duration, style, direction)
    local info = TweenInfo.new(
        duration or CONFIG.ANIMATION,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )

    local tween = TweenService:Create(obj, info, properties)
    tween:Play()

    return tween
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function Gradient(parent, colorSequence, rotation)
    local g = Instance.new("UIGradient")
    g.Color = colorSequence
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

------------------------------------------------------------
-- SCREEN GUI
------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PHUCMAX_LiquidGlass"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

------------------------------------------------------------
-- MAIN HOLDER
------------------------------------------------------------

local MainHolder = Instance.new("Frame")
MainHolder.Name = "MainHolder"

MainHolder.Size = UDim2.fromOffset(
    CONFIG.MAIN_WIDTH,
    CONFIG.MAIN_HEIGHT
)

MainHolder.Position = UDim2.new(
    0.5,
    -CONFIG.MAIN_WIDTH / 2,
    0.5,
    -CONFIG.MAIN_HEIGHT / 2
)

MainHolder.BackgroundTransparency = 1
MainHolder.ZIndex = 5
MainHolder.Parent = ScreenGui

------------------------------------------------------------
-- MAIN BACKGROUND
------------------------------------------------------------

local Background = Instance.new("ImageLabel")
Background.Name = "Background"

Background.Size = UDim2.fromScale(1, 1)
Background.Position = UDim2.fromScale(0, 0)

Background.Image = CONFIG.MAIN_BACKGROUND
Background.ScaleType = Enum.ScaleType.Crop

Background.BackgroundColor3 = CONFIG.COLORS.Navy
Background.BackgroundTransparency = 0.05

Background.BorderSizePixel = 0
Background.Active = false
Background.ZIndex = 5
Background.Parent = MainHolder

Corner(Background, 22)

------------------------------------------------------------
-- GLASS OVERLAY
------------------------------------------------------------

local GlassOverlay = Instance.new("Frame")
GlassOverlay.Name = "GlassOverlay"

GlassOverlay.Size = UDim2.fromScale(1, 1)

GlassOverlay.BackgroundColor3 = CONFIG.COLORS.Navy
GlassOverlay.BackgroundTransparency = 0.48

GlassOverlay.BorderSizePixel = 0
GlassOverlay.ClipsDescendants = true

GlassOverlay.Active = false
GlassOverlay.ZIndex = 6
GlassOverlay.Parent = MainHolder

Corner(GlassOverlay, 22)

Gradient(
    GlassOverlay,
    ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(5, 12, 30)
        ),

        ColorSequenceKeypoint.new(
            0.45,
            Color3.fromRGB(12, 24, 55)
        ),

        ColorSequenceKeypoint.new(
            0.72,
            Color3.fromRGB(56, 43, 102)
        ),

        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(4, 9, 25)
        )
    }),
    135
)

------------------------------------------------------------
-- BORDER
------------------------------------------------------------

local MainStroke = Stroke(
    MainHolder,
    CONFIG.COLORS.Silver,
    0.18,
    1.4
)

------------------------------------------------------------
-- MOVING GLASS REFLECTION
------------------------------------------------------------

local Reflection = Instance.new("Frame")
Reflection.Name = "Reflection"

Reflection.Size = UDim2.new(1.35, 0, 0.36, 0)
Reflection.Position = UDim2.new(-0.18, 0, -0.14, 0)
Reflection.Rotation = -13

Reflection.BackgroundColor3 = CONFIG.COLORS.SilverBright
Reflection.BackgroundTransparency = 0.91

Reflection.BorderSizePixel = 0
Reflection.Active = false

Reflection.ZIndex = 7
Reflection.Parent = MainHolder

Corner(Reflection, 100)

Gradient(
    Reflection,
    ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            CONFIG.COLORS.SilverBright
        ),

        ColorSequenceKeypoint.new(
            0.42,
            CONFIG.COLORS.IcePurple
        ),

        ColorSequenceKeypoint.new(
            0.75,
            CONFIG.COLORS.Silver
        ),

        ColorSequenceKeypoint.new(
            1,
            CONFIG.COLORS.SilverBright
        )
    }),
    0
)

------------------------------------------------------------
-- CONTENT ROOT
------------------------------------------------------------

local Root = Instance.new("Frame")
Root.Name = "Root"

Root.Size = UDim2.fromScale(1, 1)
Root.BackgroundTransparency = 1

Root.ZIndex = 10
Root.Parent = MainHolder

------------------------------------------------------------
-- HEADER
------------------------------------------------------------

local Header = Instance.new("Frame")

Header.Size = UDim2.new(1, -28, 0, 58)
Header.Position = UDim2.fromOffset(14, 8)

Header.BackgroundTransparency = 1
Header.ZIndex = 20
Header.Parent = Root

------------------------------------------------------------
-- TITLE
------------------------------------------------------------

local Logo = Instance.new("TextLabel")

Logo.Size = UDim2.new(1, 0, 0, 35)
Logo.Position = UDim2.fromOffset(0, 0)

Logo.BackgroundTransparency = 1
Logo.Text = "PHUCMAX"

Logo.TextColor3 = CONFIG.COLORS.SilverBright
Logo.TextSize = 25
Logo.Font = Enum.Font.GothamBlack

Logo.TextXAlignment = Enum.TextXAlignment.Center

Logo.ZIndex = 21
Logo.Parent = Header

Gradient(
    Logo,
    ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            CONFIG.COLORS.SilverBright
        ),

        ColorSequenceKeypoint.new(
            0.42,
            CONFIG.COLORS.Silver
        ),

        ColorSequenceKeypoint.new(
            0.66,
            CONFIG.COLORS.IcePurple
        ),

        ColorSequenceKeypoint.new(
            1,
            CONFIG.COLORS.SilverBright
        )
    }),
    0
)

------------------------------------------------------------
-- SUBTITLE
------------------------------------------------------------

local LogoSub = Instance.new("TextLabel")

LogoSub.Size = UDim2.new(1, 0, 0, 16)
LogoSub.Position = UDim2.fromOffset(0, 37)

LogoSub.BackgroundTransparency = 1
LogoSub.Text = "LIQUID GLASS  •  MOBILE"

LogoSub.TextColor3 = CONFIG.COLORS.SubText
LogoSub.TextSize = 8
LogoSub.Font = Enum.Font.GothamMedium

LogoSub.TextXAlignment = Enum.TextXAlignment.Center

LogoSub.ZIndex = 21
LogoSub.Parent = Header

------------------------------------------------------------
-- TAB BAR
------------------------------------------------------------

local TabContainer = Instance.new("Frame")

TabContainer.Name = "TabContainer"

TabContainer.Size = UDim2.new(1, -28, 0, 46)
TabContainer.Position = UDim2.fromOffset(14, 72)

TabContainer.BackgroundColor3 = CONFIG.COLORS.NavyDark
TabContainer.BackgroundTransparency = 0.45

TabContainer.BorderSizePixel = 0
TabContainer.ClipsDescendants = true

TabContainer.Active = false
TabContainer.ZIndex = 20
TabContainer.Parent = Root

Corner(TabContainer, 15)
Stroke(TabContainer, CONFIG.COLORS.Silver, 0.73, 1)

------------------------------------------------------------
-- SCROLLABLE TABS
------------------------------------------------------------

local Tabs = Instance.new("ScrollingFrame")

Tabs.Name = "Tabs"

Tabs.Size = UDim2.fromScale(1, 1)
Tabs.Position = UDim2.fromScale(0, 0)

Tabs.BackgroundTransparency = 1
Tabs.BorderSizePixel = 0

Tabs.ScrollBarThickness = 0
Tabs.ScrollingDirection = Enum.ScrollingDirection.X

Tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
Tabs.AutomaticCanvasSize = Enum.AutomaticSize.X

Tabs.ScrollingEnabled = true
Tabs.ElasticBehavior = Enum.ElasticBehavior.Always

Tabs.Active = true
Tabs.ZIndex = 21
Tabs.Parent = TabContainer

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.PaddingRight = UDim.new(0, 6)
TabPadding.PaddingTop = UDim.new(0, 5)
TabPadding.PaddingBottom = UDim.new(0, 5)
TabPadding.Parent = Tabs

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = Tabs

------------------------------------------------------------
-- CONTENT
------------------------------------------------------------

local Content = Instance.new("ScrollingFrame")

Content.Name = "Content"

Content.Size = UDim2.new(1, -28, 1, -132)
Content.Position = UDim2.fromOffset(14, 126)

Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0

Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = CONFIG.COLORS.IcePurple

Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.CanvasSize = UDim2.new(0, 0, 0, 0)

Content.Active = true
Content.ZIndex = 20
Content.Parent = Root

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.Parent = Content

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingBottom = UDim.new(0, 28)
ContentPadding.Parent = Content

------------------------------------------------------------
-- TAB LOGIC (updated for content switching)
------------------------------------------------------------

local TabObjects = {}
local CurrentTab = nil

-- Store controls per tab for show/hide
local ControlsByTab = {}

local function RegisterControl(tab, control)
    if not ControlsByTab[tab] then
        ControlsByTab[tab] = {}
    end
    table.insert(ControlsByTab[tab], control)
end

local function SetTabVisibility(tab)
    for tabName, controls in pairs(ControlsByTab) do
        local visible = (tabName == tab)
        for _, control in ipairs(controls) do
            control.Visible = visible
        end
    end
end

local function SelectTab(tab)
    if CurrentTab == tab then
        return
    end

    if CurrentTab and TabObjects[CurrentTab] then
        local old = TabObjects[CurrentTab]

        Tween(
            old.Background,
            {
                BackgroundTransparency = 0.78
            },
            0.22
        )

        Tween(
            old.Line,
            {
                Size = UDim2.new(0.15, 0, 0, 2),
                BackgroundTransparency = 0.8
            },
            0.25
        )

        Tween(
            old.Text,
            {
                TextColor3 = CONFIG.COLORS.SubText
            },
            0.2
        )
    end

    CurrentTab = tab

    local data = TabObjects[tab]

    Tween(
        data.Background,
        {
            BackgroundTransparency = 0.47
        },
        0.28,
        Enum.EasingStyle.Quint
    )

    Tween(
        data.Line,
        {
            Size = UDim2.new(0.72, 0, 0, 2),
            BackgroundTransparency = 0
        },
        0.38,
        Enum.EasingStyle.Quint
    )

    Tween(
        data.Text,
        {
            TextColor3 = CONFIG.COLORS.SilverBright
        },
        0.25
    )

    data.Button.Size = UDim2.fromOffset(88, 34)

    Tween(
        data.Button,
        {
            Size = UDim2.fromOffset(94, 36)
        },
        0.28,
        Enum.EasingStyle.Back
    )

    -- Close any open list popup
    if OpenPopupInfo and OpenPopupInfo.popup then
        ClosePopup()
    end

    SetTabVisibility(tab)
end

local function CreateTab(name)
    local Button = Instance.new("TextButton")

    Button.Name = name
    Button.Size = UDim2.fromOffset(88, 34)

    Button.BackgroundTransparency = 1
    Button.BorderSizePixel = 0

    Button.Text = ""
    Button.AutoButtonColor = false

    Button.Active = true
    Button.ZIndex = 22
    Button.Parent = Tabs

    Corner(Button, 11)

    local TabBackground = Instance.new("Frame")

    TabBackground.Size = UDim2.fromScale(1, 1)

    TabBackground.BackgroundColor3 = CONFIG.COLORS.Violet
    TabBackground.BackgroundTransparency = 0.78

    TabBackground.BorderSizePixel = 0
    TabBackground.Active = false

    TabBackground.ZIndex = 22
    TabBackground.Parent = Button

    Corner(TabBackground, 11)

    local TabText = Instance.new("TextLabel")

    TabText.Size = UDim2.fromScale(1, 1)

    TabText.BackgroundTransparency = 1
    TabText.Text = name

    TabText.TextColor3 = CONFIG.COLORS.SubText
    TabText.TextSize = 11
    TabText.Font = Enum.Font.GothamBold

    TabText.Active = false
    TabText.ZIndex = 24
    TabText.Parent = Button

    local Line = Instance.new("Frame")

    Line.AnchorPoint = Vector2.new(0.5, 1)
    Line.Position = UDim2.new(0.5, 0, 1, -2)

    Line.Size = UDim2.new(0.15, 0, 0, 2)

    Line.BackgroundColor3 = CONFIG.COLORS.SilverBright
    Line.BackgroundTransparency = 0.8

    Line.BorderSizePixel = 0
    Line.Active = false

    Line.ZIndex = 25
    Line.Parent = Button

    Corner(Line, 5)

    TabObjects[name] = {
        Button = Button,
        Background = TabBackground,
        Text = TabText,
        Line = Line
    }

    Button.MouseButton1Click:Connect(function()
        SelectTab(name)
    end)
end

-- ============================================================
-- PHYSICAL GUI TABS
-- Keep only the requested four physical tabs.
-- Feature groups are logical sections inside the five physical tabs.
-- ============================================================
for _, name in ipairs({
    "MAIN",
    "PLAYER",
    "VISUAL",
    "MISC",
    "INFO",
}) do
    CreateTab(name)
end

pcall(function()
    SelectTab("MAIN")
end)

------------------------------------------------------------
-- CONTROL BASE (modified to accept tab)
------------------------------------------------------------

local function CreateControl(title, subtitle, height, tab)
    local Holder = Instance.new("Frame")

    Holder.Size = UDim2.new(1, 0, 0, height or 59)

    Holder.BackgroundColor3 = CONFIG.COLORS.Navy
    Holder.BackgroundTransparency = 0.56

    Holder.BorderSizePixel = 0
    Holder.Active = false

    Holder.ZIndex = 21
    Holder.Parent = Content

    Corner(Holder, 15)
    Stroke(Holder, CONFIG.COLORS.Silver, 0.75, 1)

    local Title = Instance.new("TextLabel")

    Title.Size = UDim2.new(1, -105, 0, 23)
    Title.Position = UDim2.fromOffset(15, 7)

    Title.BackgroundTransparency = 1
    Title.Text = title

    Title.TextColor3 = CONFIG.COLORS.Text
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamSemibold

    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Active = false

    Title.ZIndex = 24
    Title.Parent = Holder

    local Sub = Instance.new("TextLabel")

    Sub.Size = UDim2.new(1, -105, 0, 17)
    Sub.Position = UDim2.fromOffset(15, 31)

    Sub.BackgroundTransparency = 1
    Sub.Text = subtitle or title

    Sub.TextColor3 = CONFIG.COLORS.SubText
    Sub.TextSize = 9
    Sub.Font = Enum.Font.GothamMedium

    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Active = false

    Sub.ZIndex = 24
    Sub.Parent = Holder

    -- Register control for tab switching
    RegisterControl(tab or "ALL", Holder)

    return Holder
end

------------------------------------------------------------
-- ACTION BUTTON (modified to accept tab)
------------------------------------------------------------

local function CreateActionButton(title, subtitle, callback, tab)
    local Holder = CreateControl(title, subtitle, nil, tab)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.fromOffset(82, 35)
    Button.Position = UDim2.new(1, -96, 0.5, -17)

    Button.BackgroundColor3 = CONFIG.COLORS.Violet
    Button.BackgroundTransparency = 0.45

    Button.BorderSizePixel = 0

    Button.Text = "RUN"
    Button.TextColor3 = CONFIG.COLORS.SilverBright
    Button.TextSize = 10
    Button.Font = Enum.Font.GothamBold

    Button.AutoButtonColor = false
    Button.Active = true

    Button.ZIndex = 26
    Button.Parent = Holder

    Corner(Button, 11)
    Stroke(Button, CONFIG.COLORS.Silver, 0.62, 1)

    Button.MouseButton1Click:Connect(function()
        Tween(
            Button,
            {
                Size = UDim2.fromOffset(75, 31)
            },
            0.08,
            Enum.EasingStyle.Quad
        )

        task.delay(0.08, function()
            Tween(
                Button,
                {
                    Size = UDim2.fromOffset(82, 35)
                },
                0.18,
                Enum.EasingStyle.Back
            )
        end)

        if callback then
            callback()
        end
    end)

    return Holder
end

------------------------------------------------------------
-- MENU / LIST SELECTOR (fixed popup on top)
------------------------------------------------------------

-- Global popup tracking
local OpenPopupInfo = nil

local function ClosePopup()
    if not OpenPopupInfo then return end

    local popup = OpenPopupInfo.popup
    local arrow = OpenPopupInfo.arrow
    local Opened = OpenPopupInfo.opened

    if not Opened then return end

    OpenPopupInfo.opened = false

    Tween(
        popup,
        {
            Size = UDim2.new(0, 122, 0, 0)
        },
        0.2
    )

    task.delay(0.2, function()
        if not OpenPopupInfo or not OpenPopupInfo.opened then
            popup.Visible = false
        end
    end)

    Tween(
        arrow,
        {
            Rotation = 0
        },
        0.2
    )
end

local function CreateList(title, subtitle, options, defaultIndex, callback, tab)
    local Holder = CreateControl(title, subtitle, 64, tab)

    local Selector = Instance.new("TextButton")

    Selector.Size = UDim2.fromOffset(122, 34)
    Selector.Position = UDim2.new(1, -136, 0.5, -17)

    Selector.BackgroundColor3 = CONFIG.COLORS.NavyDark
    Selector.BackgroundTransparency = 0.24

    Selector.BorderSizePixel = 0

    Selector.Text = ""
    Selector.AutoButtonColor = false
    Selector.Active = true

    Selector.ZIndex = 26
    Selector.Parent = Holder

    Corner(Selector, 11)
    Stroke(Selector, CONFIG.COLORS.Silver, 0.64, 1)

    local CurrentIndex = math.clamp(
        tonumber(defaultIndex) or 1,
        1,
        #options
    )

    local Value = Instance.new("TextLabel")

    Value.Size = UDim2.new(1, -32, 1, 0)
    Value.Position = UDim2.fromOffset(10, 0)

    Value.BackgroundTransparency = 1
    Value.Text = tostring(options[CurrentIndex])

    Value.TextColor3 = CONFIG.COLORS.SilverBright
    Value.TextSize = 10
    Value.Font = Enum.Font.GothamBold

    Value.TextXAlignment = Enum.TextXAlignment.Left
    Value.Active = false

    Value.ZIndex = 27
    Value.Parent = Selector

    local Arrow = Instance.new("TextLabel")

    Arrow.Size = UDim2.fromOffset(20, 20)
    Arrow.Position = UDim2.new(1, -25, 0.5, -10)

    Arrow.BackgroundTransparency = 1
    Arrow.Text = "⌄"

    Arrow.TextColor3 = CONFIG.COLORS.IcePurple
    Arrow.TextSize = 16
    Arrow.Font = Enum.Font.GothamBold

    Arrow.Active = false
    Arrow.ZIndex = 27
    Arrow.Parent = Selector

    -- Popup now parented to MainHolder to avoid being covered
    local Popup = Instance.new("Frame")

    Popup.Name = "Popup"

    Popup.Size = UDim2.new(0, 122, 0, 0)
    -- Position will be set dynamically

    Popup.BackgroundColor3 = CONFIG.COLORS.NavyDark
    Popup.BackgroundTransparency = 0.08

    Popup.BorderSizePixel = 0
    Popup.ClipsDescendants = true
    Popup.Visible = false

    Popup.ZIndex = 999 -- very high, above everything
    Popup.Parent = MainHolder

    Corner(Popup, 12)
    Stroke(Popup, CONFIG.COLORS.Silver, 0.55, 1)

    local PopupLayout = Instance.new("UIListLayout")
    PopupLayout.Padding = UDim.new(0, 3)
    PopupLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PopupLayout.Parent = Popup

    local PopupPadding = Instance.new("UIPadding")
    PopupPadding.PaddingTop = UDim.new(0, 5)
    PopupPadding.PaddingBottom = UDim.new(0, 5)
    PopupPadding.PaddingLeft = UDim.new(0, 5)
    PopupPadding.PaddingRight = UDim.new(0, 5)
    PopupPadding.Parent = Popup

    local Opened = false

    local function UpdatePopupPosition()
        if not OpenPopupInfo then return end
        local selector = OpenPopupInfo.selector
        local popup = OpenPopupInfo.popup

        if not selector or not popup or not popup.Visible then return end

        local mainAbs = MainHolder.AbsolutePosition
        local selAbs = selector.AbsolutePosition
        local selSize = selector.AbsoluteSize

        -- Popup position relative to MainHolder
        local x = selAbs.X - mainAbs.X + selSize.X - 122
        local y = selAbs.Y - mainAbs.Y + selSize.Y + 5

        -- Clamp to screen
        local viewport = workspace.CurrentCamera.ViewportSize
        local mainSize = MainHolder.AbsoluteSize
        local popupSize = Popup.AbsoluteSize

        x = math.clamp(x, 0, math.max(0, mainSize.X - popupSize.X))
        y = math.clamp(y, 0, math.max(0, mainSize.Y - popupSize.Y))

        Popup.Position = UDim2.new(0, x, 0, y)
    end

    local function ClosePopupLocal()
        if not Opened then return end

        Opened = false
        OpenPopupInfo.opened = false

        Tween(
            Popup,
            {
                Size = UDim2.new(0, 122, 0, 0)
            },
            0.2
        )

        task.delay(0.2, function()
            if not Opened then
                Popup.Visible = false
            end
        end)

        Tween(
            Arrow,
            {
                Rotation = 0
            },
            0.2
        )
    end

    local function OpenPopupLocal()
        if Opened then
            ClosePopupLocal()
            return
        end

        Opened = true
        Popup.Visible = true

        -- Set OpenPopupInfo for global update
        OpenPopupInfo = {
            popup = Popup,
            selector = Selector,
            arrow = Arrow,
            opened = true
        }

        -- Set size and position
        local popupHeight = math.clamp(#options * 31 + 10, 41, 160)
        Popup.Size = UDim2.new(0, 122, 0, 0)
        UpdatePopupPosition()

        Tween(
            Popup,
            {
                Size = UDim2.new(0, 122, 0, popupHeight)
            },
            0.25,
            Enum.EasingStyle.Back
        )

        Tween(
            Arrow,
            {
                Rotation = 180
            },
            0.2
        )
    end

    -- Track global popup state for close on tab switch
    if not OpenPopupInfo then
        OpenPopupInfo = {}
    end

    for index, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")

        OptionButton.Size = UDim2.new(1, 0, 0, 27)

        OptionButton.BackgroundColor3 = CONFIG.COLORS.Violet
        OptionButton.BackgroundTransparency = 0.78

        OptionButton.BorderSizePixel = 0

        OptionButton.Text = tostring(option)

        OptionButton.TextColor3 = CONFIG.COLORS.SubText
        OptionButton.TextSize = 9
        OptionButton.Font = Enum.Font.GothamSemibold

        OptionButton.AutoButtonColor = false
        OptionButton.Active = true

        OptionButton.ZIndex = 82
        OptionButton.Parent = Popup

        Corner(OptionButton, 8)

        OptionButton.MouseButton1Click:Connect(function()
            CurrentIndex = index
            Value.Text = tostring(option)

            Tween(
                OptionButton,
                {
                    BackgroundTransparency = 0.35,
                    TextColor3 = CONFIG.COLORS.SilverBright
                },
                0.12
            )

            task.delay(0.12, function()
                Tween(
                    OptionButton,
                    {
                        BackgroundTransparency = 0.78,
                        TextColor3 = CONFIG.COLORS.SubText
                    },
                    0.16
                )
            end)

            ClosePopupLocal()

            if callback then
                callback(option, index)
            end
        end)
    end

    Selector.MouseButton1Click:Connect(OpenPopupLocal)

    return Holder
end

------------------------------------------------------------
-- SLIDER (modified to accept tab)
------------------------------------------------------------

local function CreateSlider(title, subtitle, min, max, default, callback, tab)
    local Holder = CreateControl(title, subtitle, 72, tab)

    local ValueText = Instance.new("TextLabel")

    ValueText.Size = UDim2.fromOffset(48, 25)
    ValueText.Position = UDim2.new(1, -60, 0, 8)

    ValueText.BackgroundTransparency = 1

    ValueText.TextColor3 = CONFIG.COLORS.SilverBright
    ValueText.TextSize = 12
    ValueText.Font = Enum.Font.GothamBold

    ValueText.TextXAlignment = Enum.TextXAlignment.Right

    ValueText.ZIndex = 24
    ValueText.Parent = Holder

    local Track = Instance.new("Frame")

    Track.Size = UDim2.new(1, -28, 0, 18)
    Track.Position = UDim2.new(0, 14, 1, -24)

    Track.BackgroundColor3 = CONFIG.COLORS.NavyDark
    Track.BackgroundTransparency = 0.28

    Track.BorderSizePixel = 0

    Track.Active = true
    Track.ZIndex = 23
    Track.Parent = Holder

    Corner(Track, 20)

    local Value = default

    local percent = math.clamp(
        (default - min) / (max - min),
        0,
        1
    )

    local Fill = Instance.new("Frame")

    Fill.Size = UDim2.new(percent, 0, 1, 0)

    Fill.BackgroundColor3 = CONFIG.COLORS.IcePurple
    Fill.BackgroundTransparency = 0.12

    Fill.BorderSizePixel = 0
    Fill.Active = false

    Fill.ZIndex = 24
    Fill.Parent = Track

    Corner(Fill, 20)

    Gradient(
        Fill,
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                CONFIG.COLORS.Silver
            ),

            ColorSequenceKeypoint.new(
                0.55,
                CONFIG.COLORS.IcePurple
            ),

            ColorSequenceKeypoint.new(
                1,
                CONFIG.COLORS.Violet
            )
        }),
        0
    )

    local Knob = Instance.new("Frame")

    Knob.Size = UDim2.fromOffset(26, 26)

    Knob.AnchorPoint = Vector2.new(0.5, 0.5)

    Knob.Position = UDim2.new(
        percent,
        0,
        0.5,
        0
    )

    Knob.BackgroundColor3 = CONFIG.COLORS.SilverBright
    Knob.BackgroundTransparency = 0.04

    Knob.BorderSizePixel = 0
    Knob.Active = false

    Knob.ZIndex = 28
    Knob.Parent = Track

    Corner(Knob, 20)

    Stroke(
        Knob,
        CONFIG.COLORS.IcePurple,
        0.1,
        1
    )

    local Dragging = false

    local function SetValueFromX(x)
        local width = Track.AbsoluteSize.X

        if width <= 0 then
            return
        end

        local relative =
            math.clamp(
                x - Track.AbsolutePosition.X,
                0,
                width
            )

        local p = relative / width

        Value =
            min +
            ((max - min) * p)

        if max - min >= 10 then
            Value = math.floor(Value + 0.5)
        else
            Value =
                math.floor(Value * 100) / 100
        end

        Fill.Size = UDim2.new(
            p,
            0,
            1,
            0
        )

        Knob.Position = UDim2.new(
            p,
            0,
            0.5,
            0
        )

        ValueText.Text = tostring(Value)

        if callback then
            callback(Value)
        end
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = true

            SetValueFromX(
                input.Position.X
            )

            Tween(
                Knob,
                {
                    Size = UDim2.fromOffset(
                        30,
                        30
                    )
                },
                0.12,
                Enum.EasingStyle.Back
            )
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not Dragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            SetValueFromX(
                input.Position.X
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            if Dragging then
                Dragging = false

                Tween(
                    Knob,
                    {
                        Size = UDim2.fromOffset(
                            26,
                            26
                        )
                    },
                    0.18,
                    Enum.EasingStyle.Back
                )
            end
        end
    end)

    ValueText.Text = tostring(Value)

    return Holder
end

------------------------------------------------------------
-- TOGGLE BUTTON (new control)
------------------------------------------------------------

local function CreateToggleButton(title, subtitle, defaultState, callback, tab)
    local Holder = CreateControl(title, subtitle, 59, tab)

    local Toggle = Instance.new("TextButton")

    Toggle.Size = UDim2.fromOffset(58, 30)
    Toggle.Position = UDim2.new(1, -70, 0.5, -15)

    Toggle.BackgroundColor3 = CONFIG.COLORS.NavyDark
    Toggle.BackgroundTransparency = 0.3

    Toggle.BorderSizePixel = 0

    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.Active = true

    Toggle.ZIndex = 26
    Toggle.Parent = Holder

    Corner(Toggle, 999)
    Stroke(Toggle, CONFIG.COLORS.Silver, 0.55, 1)

    local Knob = Instance.new("Frame")

    Knob.Size = UDim2.fromOffset(22, 22)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(0.5, 0, 0.5, 0)

    Knob.BackgroundColor3 = CONFIG.COLORS.SilverBright
    Knob.BackgroundTransparency = 0.05
    Knob.BorderSizePixel = 0

    Knob.ZIndex = 27
    Knob.Parent = Toggle

    Corner(Knob, 11)

    local State = defaultState or false

    local function UpdateVisual()
        local targetColor = State and CONFIG.COLORS.IcePurple or CONFIG.COLORS.NavyDark
        local targetKnobPos = State and UDim2.new(0.8, 0, 0.5, 0) or UDim2.new(0.2, 0, 0.5, 0)
        local targetKnobColor = State and CONFIG.COLORS.SilverBright or CONFIG.COLORS.SubText

        Tween(
            Toggle,
            {BackgroundColor3 = targetColor},
            0.2
        )

        Tween(
            Knob,
            {Position = targetKnobPos},
            0.2,
            Enum.EasingStyle.Back
        )

        Tween(
            Knob,
            {BackgroundColor3 = targetKnobColor},
            0.2
        )
    end

    Toggle.MouseButton1Click:Connect(function()
        State = not State
        UpdateVisual()

        if callback then
            callback(State)
        end
    end)

    -- Initial visual
    UpdateVisual()

    return Holder
end

------------------------------------------------------------
-- DEMO UI REMOVED
-- All example/demo controls from gui.lua are intentionally removed.
-- Only controls with real callbacks are created below.
------------------------------------------------------------

------------------------------------------------------------
-- MAIN UI DRAG SYSTEM
------------------------------------------------------------

local DragZone = Instance.new("TextButton")

DragZone.Name = "DragZone"

DragZone.Size = UDim2.new(1, -125, 0, 67)
DragZone.Position = UDim2.fromOffset(14, 0)

DragZone.BackgroundTransparency = 1
DragZone.BorderSizePixel = 0

DragZone.Text = ""
DragZone.AutoButtonColor = false
DragZone.Active = true

DragZone.ZIndex = 15
DragZone.Parent = Root

local DraggingMain = false
local MainMoved = false

local MainDragStart
local MainStartPosition

local function ClampMainPosition(x, y)
    local viewport =
        workspace.CurrentCamera.ViewportSize

    local width =
        MainHolder.AbsoluteSize.X

    local height =
        MainHolder.AbsoluteSize.Y

    x = math.clamp(
        x,
        5,
        viewport.X - width - 5
    )

    y = math.clamp(
        y,
        5,
        viewport.Y - height - 5
    )

    return x, y
end

local function UpdateMainDrag(input)
    local delta =
        input.Position -
        MainDragStart

    local x =
        MainStartPosition.X.Offset +
        delta.X

    local y =
        MainStartPosition.Y.Offset +
        delta.Y

    x, y =
        ClampMainPosition(x, y)

    MainHolder.Position =
        UDim2.new(
            0,
            x,
            0,
            y
        )

    -- Update popup if open
    if OpenPopupInfo and OpenPopupInfo.popup and OpenPopupInfo.popup.Visible then
        UpdatePopupPosition()
    end
end

DragZone.InputBegan:Connect(function(input)
    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        DraggingMain = true
        MainMoved = false

        MainDragStart =
            input.Position

        MainStartPosition =
            MainHolder.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not DraggingMain then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        local delta =
            input.Position -
            MainDragStart

        if math.abs(delta.X) > 4
            or math.abs(delta.Y) > 4 then

            MainMoved = true
        end

        UpdateMainDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        DraggingMain = false
    end
end)

------------------------------------------------------------
-- RESIZE HANDLE
------------------------------------------------------------

local ResizeZone = Instance.new("TextButton")

ResizeZone.Name = "ResizeZone"

ResizeZone.Size = UDim2.fromOffset(52, 52)

ResizeZone.AnchorPoint =
    Vector2.new(1, 1)

ResizeZone.Position =
    UDim2.fromScale(1, 1)

ResizeZone.BackgroundTransparency = 1

ResizeZone.BorderSizePixel = 0

ResizeZone.Text = ""

ResizeZone.AutoButtonColor = false
ResizeZone.Active = true

ResizeZone.ZIndex = 70
ResizeZone.Parent = MainHolder

local ResizeVisual = Instance.new("Frame")

ResizeVisual.Size =
    UDim2.fromOffset(24, 24)

ResizeVisual.AnchorPoint =
    Vector2.new(1, 1)

ResizeVisual.Position =
    UDim2.new(1, -7, 1, -7)

ResizeVisual.BackgroundTransparency = 1

ResizeVisual.ZIndex = 71
ResizeVisual.Parent = ResizeZone

local ResizeLine1 = Instance.new("Frame")
ResizeLine1.Size = UDim2.fromOffset(14, 2)
ResizeLine1.Position = UDim2.new(1, -14, 1, -4)
ResizeLine1.Rotation = -45
ResizeLine1.BackgroundColor3 = CONFIG.COLORS.SilverBright
ResizeLine1.BackgroundTransparency = 0.35
ResizeLine1.BorderSizePixel = 0
ResizeLine1.ZIndex = 72
ResizeLine1.Parent = ResizeVisual
Corner(ResizeLine1, 5)

local ResizeLine2 = Instance.new("Frame")
ResizeLine2.Size = UDim2.fromOffset(19, 2)
ResizeLine2.Position = UDim2.new(1, -19, 1, -9)
ResizeLine2.Rotation = -45
ResizeLine2.BackgroundColor3 = CONFIG.COLORS.IcePurple
ResizeLine2.BackgroundTransparency = 0.35
ResizeLine2.BorderSizePixel = 0
ResizeLine2.ZIndex = 72
ResizeLine2.Parent = ResizeVisual
Corner(ResizeLine2, 5)

local Resizing = false
local ResizeStart
local ResizeStartSize

local function UpdateResize(input)
    local delta =
        input.Position -
        ResizeStart

    local viewport =
        workspace.CurrentCamera.ViewportSize

    local newWidth =
        math.clamp(
            ResizeStartSize.X.Offset +
            delta.X,

            CONFIG.MIN_WIDTH,

            math.min(
                CONFIG.MAX_WIDTH,
                viewport.X - 20
            )
        )

    local newHeight =
        math.clamp(
            ResizeStartSize.Y.Offset +
            delta.Y,

            CONFIG.MIN_HEIGHT,

            math.min(
                CONFIG.MAX_HEIGHT,
                viewport.Y - 20
            )
        )

    MainHolder.Size =
        UDim2.fromOffset(
            newWidth,
            newHeight
        )

    -- Keep the UI on-screen while resizing.
    local x =
        MainHolder.Position.X.Offset

    local y =
        MainHolder.Position.Y.Offset

    x, y =
        ClampMainPosition(x, y)

    MainHolder.Position =
        UDim2.new(
            0,
            x,
            0,
            y
        )

    -- Update popup if open
    if OpenPopupInfo and OpenPopupInfo.popup and OpenPopupInfo.popup.Visible then
        UpdatePopupPosition()
    end
end

ResizeZone.InputBegan:Connect(function(input)
    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        Resizing = true

        ResizeStart =
            input.Position

        ResizeStartSize =
            MainHolder.Size

        Tween(
            ResizeVisual,
            {
                Size = UDim2.fromOffset(
                    28,
                    28
                )
            },
            0.12,
            Enum.EasingStyle.Back
        )
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not Resizing then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        UpdateResize(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        if Resizing then
            Resizing = false

            Tween(
                ResizeVisual,
                {
                    Size = UDim2.fromOffset(
                        24,
                        24
                    )
                },
                0.18,
                Enum.EasingStyle.Back
            )
        end
    end
end)

------------------------------------------------------------
-- OPEN / CLOSE
------------------------------------------------------------

local Open = true

local MainScale = MainHolder:FindFirstChild("AnimationScale")
if not MainScale then
    MainScale = Instance.new("UIScale")
    MainScale.Name = "AnimationScale"
    MainScale.Scale = 1
    MainScale.Parent = MainHolder
end

local function OpenUI()
    Open = true
    MainHolder.Visible = true

    MainScale.Scale = 0.86
    Background.ImageTransparency = 1
    GlassOverlay.BackgroundTransparency = 1

    Tween(
        MainScale,
        {Scale = 1},
        0.42,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )

    Tween(
        Background,
        {ImageTransparency = 0},
        0.30
    )

    Tween(
        GlassOverlay,
        {BackgroundTransparency = 0.48},
        0.36
    )
end

local function CloseUI()
    Open = false

    local tween = Tween(
        MainScale,
        {Scale = 0.86},
        0.25,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In
    )

    Tween(
        Background,
        {ImageTransparency = 1},
        0.20
    )

    Tween(
        GlassOverlay,
        {BackgroundTransparency = 1},
        0.20
    )

    tween.Completed:Connect(function()
        if not Open then
            MainHolder.Visible = false
        end
    end)
end

local function ToggleUI()
    if Open then
        CloseUI()
    else
        OpenUI()
    end
end

-- OPEN THE REAL LIQUID-GLASS SHELL BEFORE FEATURE BOOTSTRAP.
pcall(OpenUI)

------------------------------------------------------------
-- FLOATING TOGGLE
------------------------------------------------------------

local Toggle = Instance.new("ImageButton")

Toggle.Name = "PHUCMAX_TOGGLE"

Toggle.Size = UDim2.fromOffset(
    CONFIG.TOGGLE_SIZE,
    CONFIG.TOGGLE_SIZE
)

Toggle.Position = UDim2.new(
    0,
    16,
    0.5,
    -CONFIG.TOGGLE_SIZE / 2
)

Toggle.BackgroundColor3 = CONFIG.COLORS.Navy
Toggle.BackgroundTransparency = 0.16
Toggle.BorderSizePixel = 0

Toggle.Image = CONFIG.TOGGLE_BACKGROUND
Toggle.ImageTransparency = 0
Toggle.ScaleType = Enum.ScaleType.Crop

Toggle.AutoButtonColor = false
Toggle.Active = true
Toggle.Visible = true

Toggle.ZIndex = 100
Toggle.Parent = ScreenGui

Corner(Toggle, 15)

local ToggleStroke = Stroke(
    Toggle,
    CONFIG.COLORS.SilverBright,
    0.18,
    1.4
)

local ToggleGlass = Instance.new("Frame")

ToggleGlass.Size = UDim2.fromScale(1, 1)
ToggleGlass.BackgroundColor3 = CONFIG.COLORS.Navy
ToggleGlass.BackgroundTransparency = 0.54
ToggleGlass.BorderSizePixel = 0

ToggleGlass.Active = false
ToggleGlass.ZIndex = 101
ToggleGlass.Parent = Toggle

Corner(ToggleGlass, 999)

Gradient(
    ToggleGlass,
    ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.Silver),
        ColorSequenceKeypoint.new(0.35, CONFIG.COLORS.IcePurple),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.Navy)
    }),
    135
)

local ToggleIcon = Instance.new("ImageLabel")

ToggleIcon.Size = UDim2.new(0.58, 0, 0.58, 0)
ToggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleIcon.Position = UDim2.fromScale(0.5, 0.5)

ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Image = CONFIG.TOGGLE_BACKGROUND
ToggleIcon.ImageTransparency = 0.08
ToggleIcon.ScaleType = Enum.ScaleType.Crop

ToggleIcon.Active = false
ToggleIcon.ZIndex = 105
ToggleIcon.Parent = Toggle

Corner(ToggleIcon, 999)

------------------------------------------------------------
-- FLOATING TOGGLE DRAG
------------------------------------------------------------

local DraggingToggle = false
local ToggleMoved = false

local ToggleDragStart = nil
local ToggleStartPosition = nil

local function GetViewportSize()
    local camera = workspace.CurrentCamera
    if camera then
        return camera.ViewportSize
    end

    return Vector2.new(800, 600)
end

local function ClampTogglePosition(x, y)
    local viewport = GetViewportSize()

    local width = Toggle.AbsoluteSize.X
    local height = Toggle.AbsoluteSize.Y

    x = math.clamp(
        x,
        5,
        math.max(5, viewport.X - width - 5)
    )

    y = math.clamp(
        y,
        5,
        math.max(5, viewport.Y - height - 5)
    )

    return x, y
end

local function UpdateTogglePosition(input)
    if not ToggleStartPosition or not ToggleDragStart then
        return
    end

    local delta = input.Position - ToggleDragStart

    local x =
        ToggleStartPosition.X.Offset +
        delta.X

    local y =
        ToggleStartPosition.Y.Offset +
        delta.Y

    x, y = ClampTogglePosition(x, y)

    Toggle.Position = UDim2.new(
        0,
        x,
        0,
        y
    )
end

Toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        DraggingToggle = true
        ToggleMoved = false

        ToggleDragStart = input.Position
        ToggleStartPosition = Toggle.Position

        Tween(
            Toggle,
            {
                Size = UDim2.fromOffset(
                    CONFIG.TOGGLE_SIZE + 4,
                    CONFIG.TOGGLE_SIZE + 4
                )
            },
            0.12,
            Enum.EasingStyle.Back
        )
    end
end)

Toggle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        -- Marker connection only; actual movement is handled globally.
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not DraggingToggle then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - ToggleDragStart

        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            ToggleMoved = true
        end

        UpdateTogglePosition(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        if not DraggingToggle then
            return
        end

        DraggingToggle = false

        Tween(
            Toggle,
            {
                Size = UDim2.fromOffset(
                    CONFIG.TOGGLE_SIZE,
                    CONFIG.TOGGLE_SIZE
                )
            },
            0.18,
            Enum.EasingStyle.Back
        )

        if not ToggleMoved then
            ToggleUI()
        end

        ToggleDragStart = nil
        ToggleStartPosition = nil
    end
end)

------------------------------------------------------------
-- LIQUID GLASS ANIMATION
------------------------------------------------------------

local Clock = 0

RunService.RenderStepped:Connect(function(delta)
    Clock += delta

    local x =
        math.sin(
            Clock * 0.45
        ) * 22

    local y =
        math.cos(
            Clock * 0.35
        ) * 9

    Reflection.Position =
        UDim2.new(
            -0.18,
            x,
            -0.14,
            y
        )

    local pulse =
        (math.sin(
            Clock * 1.6
        ) + 1) / 2

    MainStroke.Transparency =
        0.10 +
        pulse * 0.20

    ToggleStroke.Transparency =
        0.12 +
        pulse * 0.20

    local glow =
        (math.sin(
            Clock * 2.1
        ) + 1) / 2

    ToggleGlass.BackgroundTransparency =
        0.48 +
        glow * 0.08
end)

------------------------------------------------------------
-- INITIAL MOBILE-SIZED POSITION
------------------------------------------------------------

local viewport =
    workspace.CurrentCamera.ViewportSize

local startWidth =
    math.min(
        CONFIG.MAIN_WIDTH,
        viewport.X - 26
    )

local startHeight =
    math.min(
        CONFIG.MAIN_HEIGHT,
        viewport.Y - 90
    )

startWidth =
    math.max(
        CONFIG.MIN_WIDTH,
        startWidth
    )

startHeight =
    math.max(
        CONFIG.MIN_HEIGHT,
        startHeight
    )

MainHolder.Size =
    UDim2.fromOffset(
        startWidth,
        startHeight
    )

MainHolder.Position =
    UDim2.new(
        0.5,
        -startWidth / 2,
        0.5,
        -startHeight / 2
    )

MainScale.Scale = 0.86
Background.ImageTransparency = 1
GlassOverlay.BackgroundTransparency = 1

Toggle.Visible = true

task.delay(0.05, function()
    pcall(function()
        if OpenUI then
            OpenUI()
        end
    end)
end)

print("PHUCMAX Liquid Glass v4 loaded.")


------------------------------------------------------------
-- EXTENDED CONTROLS USED BY THE ORIGINAL FEATURE SCRIPT
------------------------------------------------------------

local function CreateInput(title, subtitle, placeholder, callback, tab)
    local Holder = CreateControl(title, subtitle, 62, tab)

    local Box = Instance.new("TextBox")
    Box.Name = "Input"
    Box.Size = UDim2.fromOffset(122, 35)
    Box.Position = UDim2.new(1, -136, 0.5, -17)
    Box.BackgroundColor3 = CONFIG.COLORS.NavyDark
    Box.BackgroundTransparency = 0.24
    Box.BorderSizePixel = 0
    Box.ClearTextOnFocus = false
    Box.PlaceholderText = placeholder or ""
    Box.PlaceholderColor3 = CONFIG.COLORS.SubText
    Box.TextColor3 = CONFIG.COLORS.SilverBright
    Box.Text = ""
    Box.TextSize = 9
    Box.Font = Enum.Font.GothamSemibold
    Box.TextXAlignment = Enum.TextXAlignment.Left
    Box.ZIndex = 26
    Box.Parent = Holder

    Corner(Box, 11)
    Stroke(Box, CONFIG.COLORS.Silver, 0.64, 1)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 9)
    pad.PaddingRight = UDim.new(0, 7)
    pad.Parent = Box

    Box.FocusLost:Connect(function()
        if callback then
            callback(Box.Text)
        end
    end)

    return Holder
end

local OpenMultiPopup = nil

local function CloseMultiPopup()
    if OpenMultiPopup and OpenMultiPopup.Close then
        OpenMultiPopup:Close()
    end
    OpenMultiPopup = nil
end

local function CreateMultiList(title, subtitle, options, selected, callback, tab)
    options = options or {}

    local Holder = CreateControl(title, subtitle, 64, tab)

    local Selector = Instance.new("TextButton")
    Selector.Size = UDim2.fromOffset(122, 34)
    Selector.Position = UDim2.new(1, -136, 0.5, -17)
    Selector.BackgroundColor3 = CONFIG.COLORS.NavyDark
    Selector.BackgroundTransparency = 0.24
    Selector.BorderSizePixel = 0
    Selector.Text = ""
    Selector.AutoButtonColor = false
    Selector.Active = true
    Selector.ZIndex = 26
    Selector.Parent = Holder

    Corner(Selector, 11)
    Stroke(Selector, CONFIG.COLORS.Silver, 0.64, 1)

    local Value = Instance.new("TextLabel")
    Value.Size = UDim2.new(1, -30, 1, 0)
    Value.Position = UDim2.fromOffset(9, 0)
    Value.BackgroundTransparency = 1
    Value.TextColor3 = CONFIG.COLORS.SilverBright
    Value.TextSize = 9
    Value.Font = Enum.Font.GothamBold
    Value.TextXAlignment = Enum.TextXAlignment.Left
    Value.TextTruncate = Enum.TextTruncate.AtEnd
    Value.ZIndex = 27
    Value.Parent = Selector

    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.fromOffset(20, 20)
    Arrow.Position = UDim2.new(1, -25, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "⌄"
    Arrow.TextColor3 = CONFIG.COLORS.IcePurple
    Arrow.TextSize = 16
    Arrow.Font = Enum.Font.GothamBold
    Arrow.ZIndex = 27
    Arrow.Parent = Selector

    local selectedMap = {}

    if type(selected) == "table" then
        for k, v in pairs(selected) do
            if v == true then
                selectedMap[k] = true
            elseif type(k) == "number" and type(v) == "string" then
                selectedMap[v] = true
            end
        end
    end

    local Popup = Instance.new("Frame")
    Popup.Name = "MultiDropdown"
    Popup.Size = UDim2.fromOffset(122, 0)
    Popup.BackgroundColor3 = CONFIG.COLORS.NavyDark
    Popup.BackgroundTransparency = 0.05
    Popup.BorderSizePixel = 0
    Popup.ClipsDescendants = true
    Popup.Visible = false
    Popup.ZIndex = 900
    Popup.Parent = MainHolder

    Corner(Popup, 12)
    Stroke(Popup, CONFIG.COLORS.Silver, 0.55, 1)

    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, -8, 1, -8)
    List.Position = UDim2.fromOffset(4, 4)
    List.BackgroundTransparency = 1
    List.BorderSizePixel = 0
    List.ScrollBarThickness = 2
    List.ScrollBarImageColor3 = CONFIG.COLORS.IcePurple
    List.ZIndex = 901
    List.Parent = Popup

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 3)
    Layout.Parent = List

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 2)
    Padding.PaddingBottom = UDim.new(0, 2)
    Padding.Parent = List

    local openState = false

    local function UpdateText()
        local result = {}

        for _, option in ipairs(options) do
            if selectedMap[option] then
                result[#result + 1] = tostring(option)
            end
        end

        Value.Text = (#result > 0) and table.concat(result, ", ") or "None"
    end

    local function Emit()
        if not callback then
            return
        end

        local result = {}

        for _, option in ipairs(options) do
            if selectedMap[option] then
                result[#result + 1] = option
            end
        end

        callback(result)
    end

    local function Rebuild()
        for _, child in ipairs(List:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, option in ipairs(options) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -2, 0, 28)
            item.BackgroundColor3 = CONFIG.COLORS.Violet
            item.BackgroundTransparency = selectedMap[option] and 0.38 or 0.78
            item.BorderSizePixel = 0
            item.Text = tostring(option)
            item.TextColor3 = selectedMap[option] and CONFIG.COLORS.SilverBright or CONFIG.COLORS.SubText
            item.TextSize = 9
            item.Font = Enum.Font.GothamSemibold
            item.AutoButtonColor = false
            item.ZIndex = 902
            item.Parent = List

            Corner(item, 8)

            item.MouseButton1Click:Connect(function()
                selectedMap[option] = not selectedMap[option]
                item.BackgroundTransparency = selectedMap[option] and 0.38 or 0.78
                item.TextColor3 = selectedMap[option] and CONFIG.COLORS.SilverBright or CONFIG.COLORS.SubText
                UpdateText()
                Emit()
            end)
        end

        List.CanvasSize = UDim2.new(0, 0, 0, math.max(0, #options * 31))
    end

    local function PositionPopup()
        local holderPos = MainHolder.AbsolutePosition
        local selectorPos = Selector.AbsolutePosition
        local selectorSize = Selector.AbsoluteSize

        local x = selectorPos.X - holderPos.X
        local y = selectorPos.Y - holderPos.Y + selectorSize.Y + 5

        Popup.Position = UDim2.fromOffset(x, y)
    end

    local function Close()
        openState = false
        Tween(Popup, {Size = UDim2.fromOffset(122, 0)}, 0.18)
        Tween(Arrow, {Rotation = 0}, 0.18)

        task.delay(0.18, function()
            if not openState then
                Popup.Visible = false
            end
        end)
    end

    local function Open()
        if openState then
            Close()
            OpenMultiPopup = nil
            return
        end

        CloseMultiPopup()

        openState = true
        OpenMultiPopup = {
            Close = Close,
        }

        Rebuild()
        PositionPopup()

        Popup.Visible = true

        local height = math.clamp(#options * 31 + 10, 42, 175)

        Tween(
            Popup,
            {Size = UDim2.fromOffset(122, height)},
            0.22,
            Enum.EasingStyle.Back
        )

        Tween(Arrow, {Rotation = 180}, 0.18)
    end

    Selector.MouseButton1Click:Connect(Open)

    UpdateText()

    return {
        Holder = Holder,

        Refresh = function(self, newOptions)
            options = newOptions or {}
            Rebuild()
            UpdateText()

            if openState then
                PositionPopup()
            end
        end,

        SetValues = function(self, newOptions)
            self:Refresh(newOptions)
        end,
    }
end


------------------------------------------------------------
-- ORIGINAL STEAL-AN-EGG API -> GUI.LUA ADAPTER
------------------------------------------------------------

-- Logical feature names are intentionally NOT physical GUI tabs.
-- Physical tabs belong to gui.lua and remain fixed at six.
local SHARD_TAB_NAMES = {
    "MAIN",
    "PLAYER",
    "VISUAL",
    "MISC",
}

-- MAIN = primary feature groups
local SHARD_VI = {
    ["Anti-Cheat Bypass"] = "Bỏ qua chống gian lận",
    ["Enable Anti-Cheat Bypass"] = "Bật chống gian lận",
    ["Void Unstuck"] = "Thoát kẹt vùng void",
    ["Speed Changer"] = "Thay đổi tốc độ",
    ["Walk Speed"] = "Tốc độ đi bộ",
    ["Base Location"] = "Vị trí căn cứ",
    ["Set Base Here"] = "Đặt căn cứ tại đây",
    ["Clear Base Pin"] = "Xóa ghim căn cứ",
        ["Focus Area"] = "Khu vực ưu tiên",
    ["Egg Rarity Filter"] = "Bộ lọc độ hiếm trứng",
    ["Auto Steal"] = "Tự động cắp trứng",
    ["Auto Pick Egg"] = "Tự động nhặt trứng",
    ["Auto Steal Speed"] = "Tốc độ Auto Steal",
    ["Run Mode"] = "Chế độ chạy",
    ["Run Speed"] = "Tốc độ chạy",
    ["Mini Spawn UI"] = "UI nhỏ về spawn",
    ["Enable Auto Steal"] = "Bật tự động cắp trứng",
    ["Farm Method"] = "Phương pháp farm",
    ["Secret Egg Priority"] = "Ưu tiên trứng Secret",
    ["Anti Trap"] = "Chống bẫy",
    ["Server Hop"] = "Đổi máy chủ",
        ["Server Hop Now"] = "Đổi máy chủ ngay",
    ["Recall to Spawn"] = "Về điểm spawn",
    ["Hatch & ESP"] = "Nở trứng & ESP",
    ["Enable Auto Hatch"] = "Bật tự động nở trứng",
    ["Hatch Once"] = "Nở trứng một lần",
    ["Enable Egg ESP"] = "Bật ESP trứng",
    ["FPS Boost"] = "Tăng FPS",
    ["Equip & Sell"] = "Trang bị & bán",
    ["Enable Auto Equip Best"] = "Bật tự động trang bị tốt nhất",
    ["Equip Best Now"] = "Trang bị pet tốt nhất",
    ["Sell Inventory Now"] = "Bán kho đồ",
    ["Claim & Upgrade"] = "Thu hoạch & nâng cấp",
    ["Enable Auto Claim"] = "Bật tự động thu hoạch",
    ["Claim Interval"] = "Khoảng thời gian thu hoạch",
    ["Claim Now"] = "Thu hoạch ngay",
    ["Enable Auto Upgrade"] = "Bật tự động nâng cấp",
    ["Upgrade Interval"] = "Khoảng thời gian nâng cấp",
    ["Upgrade Now"] = "Nâng cấp ngay",
    ["Treadmill"] = "Máy chạy bộ",
    ["Enable Auto Treadmill"] = "Bật máy chạy bộ tự động",
    ["Auto-Upgrade Treadmill"] = "Tự động nâng cấp máy chạy",
    ["Go to Treadmill"] = "Đi tới máy chạy",
    ["Configuration"] = "Cấu hình",
    ["Show Window"] = "Hiện cửa sổ",
    ["Drop to Void"] = "Rơi xuống vùng void",
    ["Copy Remote List"] = "Sao chép danh sách Remote",
    ["Copy Plot Dump"] = "Sao chép dữ liệu Plot",
    ["Copy Place Source"] = "Sao chép mã nguồn Place",
    ["Reset Hop Count"] = "Đặt lại số lần hop",
    ["Rejoin Server"] = "Vào lại server",
    ["Unload Script"] = "Tắt script",
    ["Visual Pets (Client Only)"] = "Pet hiển thị (chỉ client)",
    ["Pet"] = "Chọn pet",
    ["Refresh Pet List"] = "Làm mới danh sách pet",
    ["Custom Name"] = "Tên tùy chỉnh",
    ["Orbit Radius"] = "Bán kính quỹ đạo",
    ["Orbit Speed"] = "Tốc độ quỹ đạo",
    ["Spawn Pet"] = "Tạo pet",
    ["Remove Last Pet"] = "Xóa pet cuối",
    ["Remove All Pets"] = "Xóa tất cả pet",
}

local function SHARD_Desc(title, desc)
    local vi = SHARD_VI[tostring(title)] or ("Chức năng " .. tostring(title))
    if desc and tostring(desc) ~= "" then
        return vi .. " • " .. tostring(desc)
    end
    return vi
end

local function SHARD_FindTab(title)
    title = tostring(title or "")

    if title == "MAIN" or title == "PLAYER" or title == "VISUAL" or title == "MISC" or title == "INFO" then
        return title
    elseif title == "Auto Steal" then
        return "MAIN"
    elseif title == "Server Hop" then
        return "MISC"
    elseif title == "Hatch & ESP" or title == "Visual Pets" then
        return "VISUAL"
    elseif title == "Equip & Sell" then
        return "PLAYER"
    elseif title == "Claim & Upgrade" or title == "Treadmill" then
        return "MAIN"
    elseif title == "INFO" then
        return "INFO"
    elseif title == "Configuration" or title == "ALL" or title == "SETTINGS" then
        return "MAIN"
    elseif title == "INFO" then
        return "INFO"
    end

    return "MAIN"
end

local function SHARD_MakeTab(title)
    local physical = SHARD_FindTab(title)

    local tab = {}

    function tab:Section(_)
        return self
    end

    function tab:Button(options)
        options = options or {}
        if type(options.Callback) ~= "function" then
            return nil
        end

        return CreateActionButton(
            tostring(options.Title or "Button"),
            SHARD_Desc(options.Title, options.Desc),
            options.Callback,
            physical
        )
    end

    function tab:Toggle(options)
        options = options or {}

        return CreateToggleButton(
            tostring(options.Title or "Toggle"),
            SHARD_Desc(options.Title, options.Desc),
            options.Value == true,
            options.Callback,
            physical
        )
    end

    function tab:Slider(options)
        options = options or {}

        local value = options.Value
        local min = tonumber(options.Min) or 0
        local max = tonumber(options.Max) or 100
        local default = tonumber(value) or min

        if type(value) == "table" then
            min = tonumber(value.Min) or min
            max = tonumber(value.Max) or max
            default = tonumber(value.Default) or min
        end

        if max <= min then
            max = min + 1
        end

        return CreateSlider(
            tostring(options.Title or "Slider"),
            SHARD_Desc(options.Title, options.Desc),
            min,
            max,
            default,
            options.Callback,
            physical
        )
    end

    function tab:Dropdown(options)
        options = options or {}

        local title = tostring(options.Title or "Dropdown")
        local desc = SHARD_Desc(title, options.Desc)
        local values = options.Values or {}

        if options.Multi then
            return CreateMultiList(
                title,
                desc,
                values,
                options.Value,
                options.Callback,
                physical
            )
        end

        local defaultIndex = 1

        if type(options.Value) == "number" then
            defaultIndex = math.clamp(
                options.Value,
                1,
                math.max(1, #values)
            )
        elseif type(options.Value) == "string" then
            for index, value in ipairs(values) do
                if tostring(value) == options.Value then
                    defaultIndex = index
                    break
                end
            end
        end

        local holder = CreateList(
            title,
            desc,
            values,
            defaultIndex,
            options.Callback,
            physical
        )

        return {
            Holder = holder,
            Refresh = function(self, newValues)
                if self.Holder and self.Holder.Parent then
                    self.Holder:Destroy()
                end

                self.Holder = CreateList(
                    title,
                    desc,
                    newValues or {},
                    1,
                    options.Callback,
                    physical
                )
            end,
            SetValues = function(self, newValues)
                self:Refresh(newValues)
            end,
        }
    end

    function tab:Input(options)
        options = options or {}

        return CreateInput(
            tostring(options.Title or "Input"),
            SHARD_Desc(options.Title, options.Desc),
            options.Placeholder,
            options.Callback,
            physical
        )
    end

    return tab
end

local SHARD_WINDOW = {}

function SHARD_WINDOW:Open()
    if OpenUI then OpenUI() end
end

function SHARD_WINDOW:Show()
    if OpenUI then OpenUI() end
end

function SHARD_WINDOW:Maximize()
    if OpenUI then OpenUI() end
end

function SHARD_WINDOW:Unminimize()
    if OpenUI then OpenUI() end
end

function SHARD_WINDOW:Minimize(state)
    if state == false then
        if OpenUI then OpenUI() end
    else
        if CloseUI then CloseUI() end
    end
end

function SHARD_WINDOW:Destroy()
    if CloseUI then CloseUI() end
    if ScreenGui and ScreenGui.Parent then
        ScreenGui:Destroy()
    end
end

function SHARD_WINDOW:SelectTab(index)
    local numeric = tonumber(index) or 1
    local name = SHARD_TAB_NAMES[numeric] or "MAIN"

    if SelectTab then
        pcall(SelectTab, name)
    end
end

function SHARD_WINDOW:Tab(options)
    options = options or {}
    return SHARD_MakeTab(tostring(options.Title or "Auto Steal"))
end

function SHARD_WINDOW:Section(_)
    local section = {}

    function section:Tab(options)
        return SHARD_MakeTab(tostring((options or {}).Title or "Auto Steal"))
    end

    return section
end

local SHARD_LIBRARY = {}

function SHARD_LIBRARY:CreateWindow(_)
    return SHARD_WINDOW
end

function SHARD_LIBRARY:Notify(data)
    data = data or {}
    iData.value18(
        data.Title or "Shard",
        data.Content or "",
        data.Duration
    )
end

iData.value1 = SHARD_LIBRARY

-- ------------------------------------------------------------
-- UI BOOT SAFETY
-- Open gui.lua shell before feature construction.
-- ------------------------------------------------------------
-- UI is already visible before the feature adapter starts.
-- Keep the second call guarded for compatibility with older revisions.
pcall(function()
    if OpenUI then OpenUI() end
end)

-- Provide the floating UI notification callback.
_G.PHUCMAX_Notify = function(message, duration)
    pcall(function()
        iData.value20(tostring(message), duration or 4)
    end)
end


-- ============================================================
-- FEATURE BOOT ISOLATION
-- UI remains visible if a feature-side callback fails.
-- ============================================================
local __PHUCMAX_FEATURE_OK, __PHUCMAX_FEATURE_ERR = xpcall(function()

local windowResult = iData.value12
local createWindowResult = iData.value1
local size = UDim2.fromOffset(580, 430)
local secondaryUDim = UDim
local CreateWindow = createWindowResult.CreateWindow
local uDim = secondaryUDim.new(0, 14)

windowResult.Window = CreateWindow(createWindowResult, {
	Title = "Steal an Egg",
	Icon = "egg",
	Author = "PHUCMAX",
	Folder = "PHUCMAX",
	Size = size,
	Transparent = true,
	Theme = "Dark",
	SideBarWidth = 190,
	HideSearchBar = true,
	NewElements = true,
	OpenButton = {
		Enabled = true,
		Title = "Shard Hub",
		Draggable = true,
		OnlyMobile = false,
		CornerRadius = uDim,
		StrokeThickness = 2,
	},
})
local function secondaryPcall()
	for _, item in ipairs({
		"Open",
		"Maximize",
		"Unminimize",
		"Show",
	}) do
		local capturedV = item

		if pcall(function()
			iData.value12.Window[capturedV](iData.value12.Window)
		end) then
			return true
		end
	end

	return pcall(function()
		iData.value12.Window:Minimize(false)
	end)
end
secondaryHandler(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
		secondaryPcall()
	end
end))
-- ============================================================
-- PHUCMAX 5-TAB UI
-- MAIN / PLAYER / VISUAL / MISC / INFO only.
-- Feature logic stays in the existing engine above; this block is UI only.
-- ============================================================
local TabMain   = iData.value12.Window:Tab({Title="MAIN", Icon="zap"})
local TabPlayer = iData.value12.Window:Tab({Title="PLAYER", Icon="user"})
local TabVisual = iData.value12.Window:Tab({Title="VISUAL", Icon="eye"})
local TabMisc   = iData.value12.Window:Tab({Title="MISC", Icon="settings"})
local TabInfo   = iData.value12.Window:Tab({Title="INFO", Icon="info"})

-- Backwards-compatible aliases used by the existing feature code.
iData.value12.TabSteal = TabMain
iData.value12.TabHop = TabMisc
iData.value12.TabHatch = TabVisual
iData.value12.TabSell = TabPlayer
iData.value12.TabVisualPet = TabVisual
iData.value12.TabClaim = TabMain
iData.value12.TabTread = TabMain

-- Runtime UI state.
iData.value119 = {
    AutoSteal=false, ManualBase=nil, SpeedChanger=false, SpeedValue=60,
    HumReady=false, VoidUnstuck=false, AutoPutEggs=false, PutEggsDelay=0.4,
    AreaFocus={}, RarityFilter={},
}
iData.value120=45
iData.value121=0.08
iData.value122=8
iData.value123=nil
iData.value124=nil
iData.value125=nil
iData.value126=false
iData.value127=nil
iData.value128={}
iData.value129={}

-- ------------------------------------------------------------
-- MAIN • AUTO STEAL
-- ------------------------------------------------------------
TabMain:Section({Title="AUTO STEAL"})
TabMain:Button({Title="Jump Button", Desc="bị kẹt máy chạy bộ thì bấm vào.", Callback=function() local h=iData.value22(); if h then h.Jump=true; h:ChangeState(Enum.HumanoidStateType.Jumping) end end})
TabMain:Toggle({Title="Enable Auto Steal", Desc="Tự động quét, chấm điểm và chọn egg tốt nhất; không phụ thuộc List.", Value=false, Callback=function(v)
    iData.value14.AutoSteal=v
    iData.value11.travelToken=iData.value11.travelToken+1
    iData.value11.travelling=false
    if v then
        iData.value11.AutoStealTarget=nil
        iData.value11.AutoStealPhase="Scanning"
        iData.value11.AutoStealReached=false
    else
        iData.value11.AutoStealTarget=nil
        iData.value11.AutoStealPhase="Stopped"
        iData.value11.AutoStealReached=false
        pcall(iData.value51)
    end
end})
TabMain:Dropdown({Title="Farm Method", Desc="Chọn cơ chế farm: TP hoặc Speed.", Values={"TP","Speed"}, Value=iData.value14.FarmMethod or (iData.value14.AutoStealRunMode and "Speed" or "TP"), Callback=function(v)
    iData.value14.FarmMethod=v
    -- Giữ nguyên engine steal cũ:
    -- TP    = legacy travel/TP engine
    -- Speed = Humanoid WalkSpeed engine
    iData.value14.AutoStealRunMode=(v=="Speed")
end})
TabMain:Toggle({Title="Secret Egg Priority", Desc="Ưu tiên Secret/rare-tier cao trong scoring tự động.", Value=true, Callback=function(v) iData.value14.SecretPriority=v end})
TabMain:Toggle({Title="Anti Trap", Desc="Chống trap quanh tuyến di chuyển.", Value=iData.value14.AntiTrap, Callback=function(v) iData.value14.AntiTrap=v end})
TabMain:Toggle({Title="Anti-Cheat Bypass", Desc="Giữ nguyên cơ chế Bypass Humanoid hiện tại.", Value=iData.value14.AntiCheat, Callback=function(v)
    iData.value14.AntiCheat=v; iData.value119.HumReady=false
    if v then task.spawn(function() local ok=createAutoStealHumanoid(); iData.value119.HumReady=ok; iData.value14.HumReady=ok end) end
end})
TabMain:Toggle({Title="Void Unstuck", Desc="Gỡ trạng thái kẹt/physics khi engine phát hiện bất thường.", Value=false, Callback=function(v) iData.value119.VoidUnstuck=v end})
TabMain:Slider({Title="Auto Steal Speed", Desc="Tốc độ Auto Steal, tối đa 800.", Step=1, Value={Min=1,Max=800,Default=math.clamp(iData.value14.AutoStealSpeed or 800,1,800)}, Callback=function(v)
    iData.value14.AutoStealSpeed=math.clamp(tonumber(v) or 800,1,800)
    iData.value10.TRAVEL_SPEED=iData.value14.AutoStealSpeed
end})

-- ------------------------------------------------------------
-- MAIN • STEAL SELECTED (independent from Auto Steal)
-- ------------------------------------------------------------
TabMain:Section({Title="STEAL SELECTED"})
local AreaSelector=TabMain:Dropdown({Title="Target Area", Desc="Chọn nhiều Area cho Steal Selected.", Values=iData.value37(), Multi=true, Value={}, Callback=function(v)
    iData.value119.AreaFocus=type(v)=="table" and v or {}
    iData.value14.AreaFocus=iData.value119.AreaFocus
    iData.value40()
end})
TabMain:Button({Title="Refresh Area List", Desc="Quét lại Area hiện có.", Callback=function()
    iData.value36(); local values=iData.value37(); pcall(function() AreaSelector:Refresh(values) end)
end})
local RequiredRarities={"Common","Uncommon","Rare","Epic","Legendary","Mythic","Divine","Secret","Titan"}
local RaritySelector=TabMain:Dropdown({Title="Target Rarity", Desc="Chọn nhiều rarity cho Steal Selected.", Values=RequiredRarities, Multi=true, Value={}, Callback=function(v)
    iData.value119.RarityFilter=type(v)=="table" and v or {}
    iData.value14.RarityFilter=iData.value119.RarityFilter
    iData.value42()
end})

-- One-shot selected-steal runner. It never changes AutoSteal state.
local SelectedStealBusy=false
local function SelectedStealRun()
    if SelectedStealBusy then return end
    SelectedStealBusy=true
    task.spawn(function()
        local ok,err=xpcall(function()
            iData.value49(true)
            local areas,rarities={},{}
            for _,a in ipairs(iData.value119.AreaFocus) do areas[iData.value13.areaByLabel[a] or a]=true end
            for _,r in ipairs(iData.value119.RarityFilter) do rarities[r]=true end
            local best=nil
            for _,egg in ipairs(iData.value11.eggList) do
                local areaOK=(next(areas)==nil) or areas[egg.area] or areas[egg.label]
                local rarityOK=(next(rarities)==nil) or rarities[egg.rarity]
                if areaOK and rarityOK then
                    local root=iData.value21(); local d=root and (egg.pos-root.Position).Magnitude or math.huge
                    local score=(egg.mutated and 1e12 or 0)+(egg.rank or 0)*1e9+(egg.tier or 0)*1e6+(egg.size or 0)*1e3-d
                    if not best or score>best.score then best={egg=egg,score=score} end
                end
            end
            if not best then iData.value18("Steal Selected","Không có egg phù hợp với Area/Rarity đã chọn.",4); return end
            local egg=best.egg
            local reached=updateGoToTreadmill(egg.pos,8,function() return not iData.value14.AutoSteal end,true)
            if not reached then return end
            iData.value83(egg.uid)
        end,function(e) return tostring(e).."\n"..debug.traceback() end)
        if not ok then warn("[PHUCMAX][StealSelected] "..tostring(err)) end
        SelectedStealBusy=false
    end)
end
TabMain:Button({Title="STEAL SELECTED", Desc="Chỉ steal egg khớp Area + Rarity đã chọn; không bật Auto Steal.", Callback=SelectedStealRun})

-- ------------------------------------------------------------
-- MAIN • CLAIM / UPGRADE / TREADMILL
-- ------------------------------------------------------------
TabMain:Section({Title="CLAIM"})
TabMain:Toggle({Title="Auto Claim", Desc="Tự động claim theo interval.", Value=iData.value14.AutoClaim, Callback=function(v) iData.value14.AutoClaim=v end})
TabMain:Slider({Title="Claim Interval", Desc="Khoảng cách giữa các lần claim.", Step=1, Value={Min=5,Max=300,Default=iData.value14.ClaimInterval}, Callback=function(v) iData.value14.ClaimInterval=v end})
TabMain:Button({Title="Claim Now", Desc="Claim ngay lập tức.", Callback=function() task.spawn(function() iData.value18("Claim","Fired "..iData.value103(true).." claims.") end) end})
TabMain:Section({Title="UPGRADE"})
TabMain:Toggle({Title="Auto Upgrade", Desc="Tự động nâng cấp.", Value=iData.value14.AutoUpgrade, Callback=function(v) iData.value14.AutoUpgrade=v end})
TabMain:Slider({Title="Upgrade Interval", Desc="Khoảng cách giữa các lần upgrade.", Step=1, Value={Min=5,Max=300,Default=iData.value14.UpgradeInterval}, Callback=function(v) iData.value14.UpgradeInterval=v end})
TabMain:Button({Title="Upgrade Now", Desc="Nâng cấp ngay lập tức.", Callback=function() task.spawn(function() iData.value18("Upgrade","Fired "..iData.value104(true).." upgrades.") end) end})
TabMain:Section({Title="TREADMILL"})
TabMain:Toggle({Title="Auto Treadmill", Desc="Tự động chạy treadmill.", Value=iData.value14.AutoTreadmill, Callback=function(v) iData.value14.AutoTreadmill=v end})
TabMain:Toggle({Title="Auto-Upgrade Treadmill", Desc="Tự động nâng cấp treadmill.", Value=iData.value14.AutoUpgradeTreadmill, Callback=function(v) iData.value14.AutoUpgradeTreadmill=v end})
TabMain:Button({Title="Go to Treadmill", Desc="Đi tới treadmill gần nhất.", Callback=function() task.spawn(function() local p=iData.value109(); if p then updateGoToTreadmill(p.Position,6) end end) end})

-- ------------------------------------------------------------
-- MAIN • PLAYER CONTROL
-- ------------------------------------------------------------
TabMain:Section({Title="PLAYER CONTROL"})
TabMain:Toggle({Title="Speed Changer", Desc="Khóa WalkSpeed theo giá trị bên dưới.", Value=false, Callback=function(v) iData.value119.SpeedChanger=v end})
TabMain:Slider({Title="Walk Speed", Desc="WalkSpeed, tối đa 800.", Step=1, Value={Min=16,Max=800,Default=60}, Callback=function(v) iData.value119.SpeedValue=math.clamp(tonumber(v) or 60,16,800) end})
TabMain:Button({Title="Set Base Here", Desc="Đặt base/origin theo vị trí player hiện tại.", Callback=function() local r=iData.value21(); if r then iData.value119.ManualBase=r.Position end end})
TabMain:Button({Title="Clear Base Pin", Desc="Xóa base pin thủ công.", Callback=function() iData.value119.ManualBase=nil end})


-- ------------------------------------------------------------
-- PLAYER
-- ------------------------------------------------------------
TabPlayer:Section({Title="PLAYER / INVENTORY"})
TabPlayer:Toggle({Title="Auto Equip Best", Desc="Tự động trang bị pet tốt nhất.", Value=iData.value14.AutoEquipBest, Callback=function(v) iData.value14.AutoEquipBest=v end})
TabPlayer:Button({Title="Equip Best Now", Desc="Trang bị pet tốt nhất cc.", Callback=function() iData.value27(iData.value25.WearBest) end})
TabPlayer:Button({Title="Sell Inventory Now", Desc="Bán all trong inventory.", Callback=function() task.spawn(function() iData.value18("Pets",iData.value102(true)) end) end})

-- ------------------------------------------------------------
-- VISUAL
-- ------------------------------------------------------------
TabVisual:Section({Title="VISUAL / HATCH"})
TabVisual:Toggle({Title="Auto Hatch", Desc="Tự động hatch.", Value=iData.value14.AutoHatch, Callback=function(v) iData.value14.AutoHatch=v end})
TabVisual:Button({Title="Hatch Once", Desc="Hatch một lượt.", Callback=function() task.spawn(function() iData.value18("Hatch","Hatched "..hatchAll(true).." eggs.") end) end})
TabVisual:Toggle({Title="Egg ESP", Desc="Hiển thị CL.", Value=iData.value14.EggESP, Callback=function(v) iData.value14.EggESP=v; if not v then iData.value91() end end})
TabVisual:Toggle({Title="FPS Boost", Desc="máy lỏ thì bật lên giúp bố.", Value=iData.value14.FpsBoost, Callback=function(v) iData.value14.FpsBoost=v; task.spawn(function() if v then iData.value99() else iData.value100() end end) end})
TabVisual:Section({Title="VISUAL PETS"})
iData.value142 = {
	spawned = {},
	orbitRadius = 4,
	orbitSpeed = 0.8,
	conn = nil,
	petNames = {},
	inputName = "",
}
iData.value143 = Instance.new("Folder")
iData.value143.Name = "ShardVisualPets"
iData.value143.Parent = iData.value7
function iData.value144()
	local nameData = {}
	local names = {}
	local function handler(item)
		if not item:IsA("Model") then
			return
		end

		local lower = item.Name:lower()

		if lower:find("humanoid") or lower:find("egg") then
			return
		end

		local flag = item:FindFirstChildWhichIsA("BasePart") ~= nil
		local option = item.Parent and item.Parent.Name:lower() or ""

		if
			(
				flag and option:find("pet")
				or (
					option:find("pen")
					or (
						option:find("render")
						or (option:find("slot") or item:FindFirstChildWhichIsA("AnimationController"))
					)
				)
			) and not nameData[item.Name]
		then
			nameData[item.Name] = true
			names[#names + 1] = item.Name
		end
	end
	for index, item in ipairs(iData.value94()) do
		local GetDescendants = item.GetDescendants

		for _, item in ipairs(GetDescendants(item)) do
			handler(item)
		end
	end
	for _, child in ipairs(iData.value7:GetChildren()) do
		for _, item in ipairs(child:GetChildren()) do
			handler(item)
		end
	end
	table.sort(names)
	iData.value142.petNames = names

	return names
end
function iData.value145(argument)
	local searchableText = argument:lower()
	for index, item in ipairs(iData.value94()) do
		for _, descendant in ipairs(item:GetDescendants()) do
			if
				descendant:IsA("Model")
				and descendant.Name:lower():find(searchableText, 1, true)
				and descendant:FindFirstChildWhichIsA("BasePart")
			then
				return descendant
			end
		end
	end
	for _, descendant in ipairs(iData.value7:GetDescendants()) do
		local flag = descendant:IsA("Model")

		if flag then
			flag = descendant.Name:lower():find(searchableText, 1, true)

			if flag then
				flag = not descendant:IsDescendantOf(iData.value143)
			end
		end

		if flag and descendant:FindFirstChildWhichIsA("BasePart") then
			return descendant
		end
	end

	return nil
end
function iData.value146(text)
	local cloneFlag = iData.value145(text)
	if not cloneFlag then
		iData.value18("Visual Pets", "Could not find a model named: " .. text, 4)

		return
	end
	local clone = cloneFlag:Clone()
	for index, item in ipairs(clone:GetDescendants()) do
		if item:IsA("Script") or (item:IsA("LocalScript") or item:IsA("ModuleScript")) then
			item:Destroy()
		end
	end
	for _, descendant in ipairs(clone:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CastShadow = false
		end
	end
	clone.Name = "VP_" .. text
	clone.Parent = iData.value143
	local product = #iData.value142.spawned * (6.283185307179586 / math.max(1, #iData.value142.spawned + 1))
	iData.value142.spawned[#iData.value142.spawned + 1] = {
		model = clone,
		angle = product,
	}
	iData.value18("Visual Pets", "Spawned " .. text .. " (client only).", 3)
end
function iData.value147()
	for _, item in ipairs(iData.value142.spawned) do
		local capturedV = item

		pcall(function()
			capturedV.model:Destroy()
		end)
	end

	iData.value142.spawned = {}
end
function iData.value148()
	if #iData.value142.spawned == 0 then
		return
	end

	local removeResult = table.remove(iData.value142.spawned)

	pcall(function()
		removeResult.model:Destroy()
	end)
end
iData.value142.conn = iData.value3.Heartbeat:Connect(function(_)
	local secondaryInput = iData.value21()

	if not secondaryInput or #iData.value142.spawned == 0 then
		return
	end

	local timestamp = tick()
	local sum = secondaryInput.Position + Vector3.new(0, 1, 0)
	local sumNumber = #iData.value142.spawned

	for i, item in ipairs(iData.value142.spawned) do
		local capturedV = item
		local number = (i - 1) * (6.283185307179586 / sumNumber) + timestamp * iData.value142.orbitSpeed
		local product = math.cos(number) * iData.value142.orbitRadius
		local secondaryProduct = math.sin(number) * iData.value142.orbitRadius
		local secondarySum = sum + Vector3.new(product, 0, secondaryProduct)

		if capturedV.model.PrimaryPart or capturedV.model:FindFirstChildWhichIsA("BasePart") then
			pcall(function()
				capturedV.model:PivotTo(CFrame.new(secondarySum) * CFrame.Angles(0, number + 3.141592653589793, 0))
			end)
		end
	end
end)
secondaryHandler(iData.value142.conn)
iData.value149 = iData.value12.TabVisualPet:Dropdown({Title="Pet List", Desc="Chọn cc.", Values={"Scanning..."}, Value=1, Callback=function(v) local n=type(v)=="table" and next(v) or v; if type(n)=="string" then iData.value142.inputName=n end end})
iData.value12.TabVisualPet:Button({Title="Refresh Pet List", Desc="Quét cc.", Callback=function() local v=iData.value144(); if #v>0 then pcall(function() iData.value149:Refresh(v) end); pcall(function() iData.value149:SetValues(v) end) end end})
iData.value12.TabVisualPet:Input({Title="Custom Name", Desc="Tên cc.", Placeholder="Pet name", Callback=function(v) iData.value142.inputName=v end})
iData.value12.TabVisualPet:Slider({Title="Orbit Radius", Desc="Bán kính orbit.", Step=1, Value={Min=2,Max=20,Default=4}, Callback=function(v) iData.value142.orbitRadius=v end})
iData.value12.TabVisualPet:Slider({Title="Orbit Speed", Desc="Tốc độ orbit.", Step=1, Value={Min=0,Max=10,Default=1}, Callback=function(v) iData.value142.orbitSpeed=v*0.2 end})
iData.value12.TabVisualPet:Button({Title="Spawn Pet", Desc="Tạo pet cc.", Callback=function() if iData.value142.inputName~="" then iData.value146(iData.value142.inputName) end end})
iData.value12.TabVisualPet:Button({Title="Remove Last Pet", Desc="Xóa pet cuối.", Callback=function() iData.value148() end})
iData.value12.TabVisualPet:Button({Title="Remove All Pets", Desc="Xóa toàn bộ visual pet.", Callback=function() iData.value147() end})
task.delay(3,function() local v=iData.value144(); if #v>0 then pcall(function() iData.value149:Refresh(v) end); pcall(function() iData.value149:SetValues(v) end) end end)

-- ------------------------------------------------------------
-- MISC
-- ------------------------------------------------------------
TabMisc:Section({Title="SERVER"})
TabMisc:Toggle({Title="Auto Server Hop", Desc="Tự động hop.", Value=false, Callback=function(v) iData.value11.AutoServerHop=v end})
TabMisc:Slider({Title="Max Hops", Desc="Giới hạn số lần hop.", Step=1, Value={Min=1,Max=50,Default=10}, Callback=function(v) iData.value11.MaxHops=tonumber(v) or 10 end})
TabMisc:Slider({Title="Check Delay", Desc="Độ trễ kiểm tra server.", Step=1, Value={Min=1,Max=30,Default=5}, Callback=function(v) iData.value11.HopDelay=tonumber(v) or 5 end})
TabMisc:Button({Title="Server Hop Now", Desc="Hop ngay.", Callback=function() task.spawn(function() iData.value115() end) end})
TabMisc:Button({Title="Reset Hop Count", Desc="Đặt lại bộ đếm hop.", Callback=function() iData.value14.HopCount=0; iData.value113(0) end})
TabMisc:Button({Title="Rejoin Server", Desc="Vào lại server hiện tại.", Callback=function() iData.value5:Teleport(game.PlaceId,iData.value9) end})
TabMisc:Section({Title="RECOVERY"})
TabMisc:Button({Title="Recall to Spawn", Desc="Trở về spawn.", Callback=function() local p=iData.value116(); if p then updateGoToTreadmill(p,8) end end})
TabMisc:Button({Title="Drop to Void", Desc="Kích hoạt cc.", Callback=function() iData.value70() end})
TabMisc:Button({Title="Copy Remote List", Desc="Sao chép danh sách cc.", Callback=function() local t=table.concat(iData.value28(),"\n"); if setclipboard then setclipboard(t) end end})
TabMisc:Button({Title="Unload Script", Desc="Tắt toàn bộ cc.", Callback=function() iData.value14.Unloaded=true end})

-- Auto Server Hop loop uses the real server selector and hop counter.
handler(function()
    while iData.value17() do
        if iData.value11.AutoServerHop and not iData.value11.hopping then
            local maxHops=tonumber(iData.value11.MaxHops) or 10
            local count=tonumber(iData.value14.HopCount) or 0
            if count < maxHops then
                pcall(iData.value115)
            else
                iData.value11.AutoServerHop=false
            end
        end
        task.wait(math.max(1,tonumber(iData.value11.HopDelay) or 5))
    end
end)


-- ------------------------------------------------------------
-- INFO — exactly two buttons.
-- ------------------------------------------------------------
TabInfo:Section({Title="INFO"})
TabInfo:Button({Title="Copy TikTok Link", Desc="tiktok.com/@phucmaxt.", Callback=function() iData.value18("INFO","tiktok.com/@phucmaxt.",4) end})
TabInfo:Button({Title="Copy Discord Link", Desc="https://discord.gg/9R9QvtXEbV.", Callback=function() iData.value18("INFO","https://discord.gg/9R9QvtXEbV.",4) end})

pcall(function() iData.value12.Window:SelectTab(1) end)
pcall(function()
	iData.value12.Window:SelectTab(1)
end)
task.spawn(function()
	if not iData.value23() then
		iData.value9.CharacterAdded:Wait()
		task.wait(0.7)
	end

	iData.value49(true)

	if #iData.value13.areaOrder > 0 then
		iData.value36()
		iData.value40()
		iData.value44("AreaFocus", iData.value37())
	end
end)

if not iData.value24 then
	iData.value18("Shard Hub", "Packages.Networking is missing, remote features are offline.", 8)

	return
end
iData.value18("Shard Hub", "Loaded. " .. #iData.value13.areaOrder .. " areas, " .. #iData.value28() .. " endpoints.", 5)

end, function(err)
    return tostring(err) .. "\n" .. debug.traceback()
end)

if not __PHUCMAX_FEATURE_OK then
    warn("[PHUCMAX] Feature boot failed: " .. tostring(__PHUCMAX_FEATURE_ERR))
    pcall(function()
        if type(_G.PHUCMAX_Notify) == "function" then
            _G.PHUCMAX_Notify("Lỗi chức năng: " .. tostring(__PHUCMAX_FEATURE_ERR), 10)
        end
    end)
else
    pcall(function()
        if type(_G.PHUCMAX_Notify) == "function" then
            _G.PHUCMAX_Notify("PHUCMAX •  chức năng đã tải", 3)
        end
    end)
end

-- ============================================================
-- MINI SPAWN UI
-- One button only; visibility is controlled from MAIN.
-- ============================================================
do
	local gui = Instance.new("ScreenGui")
	gui.Name = "PHUCMAX_SpawnMini"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Enabled = false
	gui.DisplayOrder = 9998
	gui.Parent = iData.value11.hostGui
	iData.value11.spawnMiniGui = gui

	local button = Instance.new("TextButton")
	button.Name = "RunToSpawn"
	button.Size = UDim2.fromOffset(150, 42)
	button.Position = UDim2.new(0.5, -75, 0.82, 0)
	button.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = "RUN TO SPAWN"
	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	button.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = button

	button.Activated:Connect(function()
		local spawnPos = iData.value116()
		if not spawnPos then return end

		local hum = iData.value22()
		if hum then
			pcall(function()
				hum.WalkSpeed = math.clamp(
					tonumber(iData.value119.SpeedValue) or 60,
					16, 800
				)
				hum:MoveTo(spawnPos)
			end)
		end
	end)
end

