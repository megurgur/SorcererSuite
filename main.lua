--> developed @megur
--> @SORCERER SUITE V 0.01

local HttpService = game:GetService('HttpService');
local TweenService = game:GetService('TweenService');
local RunService = game:GetService('RunService');
local CoreGui = game:GetService('CoreGui');

local function setStats() end;
local function destroyUI() end;

local oldRequest = clonefunction(request);

local function isRequestValid(req)
    if (not req.Headers or not req.Headers.Date or req.Headers.Date == '') then return false end;
    return req.StatusCode < 500 and req.StatusCode ~= 0;
end;

local function httpRequest(...)
    local reqData = oldRequest(...);
    local attempts = 0;

    if (not isRequestValid(reqData)) then
        repeat
            reqData = oldRequest(...);
            attempts += 1;
            task.wait(1);
        until isRequestValid(reqData) or attempts > 30;
    end;

    return reqData;
end;

if LPH_OBFUSCATED then
	xpcall(function()
		local functionsToCheck = {
			fireServer = Instance.new('RemoteEvent').FireServer,
			invokeServer = Instance.new('RemoteFunction').InvokeServer,

			fire = Instance.new('BindableEvent').Fire,
			invoke = Instance.new('BindableFunction').Invoke,

			enum = getrawmetatable(Enum).__tostring,
			signals = getrawmetatable(game.Changed),
			newIndex = getrawmetatable(game).__newindex,
			namecall = getrawmetatable(game).__namecall,
			index = getrawmetatable(game).__index,

			stringMT = getrawmetatable(''),

			UDim2,
			Rect,
			BrickColor,
			Instance,
			Region3,
			Region3int16,
			utf8,
			UDim,
			Vector2,
			Vector3,
			CFrame,

			getrawmetatable(UDim2.new()),
			getrawmetatable(Rect.new()),
			getrawmetatable(BrickColor.new()),
			getrawmetatable(Region3.new()),
			getrawmetatable(Region3int16.new()),
			getrawmetatable(utf8),
			getrawmetatable(UDim.new()),
			getrawmetatable(Vector2.new()),
			getrawmetatable(Vector3.new()),
			getrawmetatable(CFrame.new()),

			task.wait,
			task.spawn,
			task.delay,
			task.defer,

			wait,
			spawn,
			ypcall,
			pcall,
			xpcall,
			error,

			tonumber,
			tostring,

			rawget,
			rawset,
			rawequal,

			string = string,
			math = math,
			bit32 = bit32,
			table = table,
			pairs,
			next,
			unpack,
			getfenv,

			steppedWait = RunService.Stepped.Wait,

			jsonEncode = HttpService.JSONEncode,
			jsonDecode = HttpService.JSONDecode,
			findFirstChild = game.FindFirstChild,
		};

		local function checkForFunction(t, i)
			local dataType = typeof(t);

			if (dataType == 'table') then
				for i, v in t do
					local suc, result = checkForFunction(v, i);
					if (not suc) then
						return false, result;
					end;
				end;
			elseif (dataType == 'function') then
				local suc, uv = pcall(getupvalue, t, 1);

				if (isexecutorclosure(t) or islclosure(t) or (suc and uv and typeof(uv) ~= 'userdata')) then
					return false, i;
				end;
			end;

			return true;
		end;

		if (not checkForFunction(functionsToCheck)) then
			messagebox('Sanity check failed\nThis usually happens cause you ran another script before.\n\nIf you don\'t know why this happened.\nPlease check your auto execute folder.\n\nThis error has been logged.', 'Megur Suite Security Error', 0);
			return SX_CRASH();
		else
			for i, v in next, functionsToCheck do
				if (typeof(v) == 'function') then
					originalFunctions[i] = clonefunction(v);
				end;
			end;
		end;

		originalFunctions.runOnActor = getgenv().run_on_actor;
		originalFunctions.createCommChannel = getgenv().create_comm_channel;
		originalFunctions.Stepped = RunService.Stepped
	end, function()
		messagebox('Sanity check failed\nThis usually happens cause you ran another script before.\n\nIf you don\'t know why this happened.\nPlease check your auto execute folder.\n\nThis error has been logged.', 'Megur Suite Security Error', 0);
		return SX_CRASH();
	end);
end;

--> @luraph placeholders
local LPH_ENCUM, LPH_NUMENC, LPH_ENCSTR, LPH_STRENC, LPH_ENCFUNC, LPH_FUNCENC, LPH_JIT, 
LPH_JIT_MAX, LPH_NO_VIRTUALIZE, LPH_NO_UPVALUES, LPH_CRASH do
	local assert = assert
	local type = type
	local setfenv = setfenv

	LPH_ENCNUM = function(toEncrypt, ...)
		assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
		return toEncrypt
	end
	LPH_NUMENC = LPH_ENCNUM

	LPH_ENCSTR = function(toEncrypt, ...)
		assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
		return toEncrypt
	end
	LPH_STRENC = LPH_ENCSTR

	LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)
		-- not checking decKey value since this shim is meant to be used without obfuscation/whitelisting
		assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a constant function, constant string, and string variable as arguments.")
		return toEncrypt
	end
	LPH_FUNCENC = LPH_ENCFUNC

	LPH_JIT = function(f, ...)
		assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
		return f
	end
	LPH_JIT_MAX = LPH_JIT

	LPH_NO_VIRTUALIZE = function(f, ...)
		assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
		return f
	end

	LPH_NO_UPVALUES = function(f, ...)
		assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
		assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
		return f
	end

	LPH_CRASH = function(...)
		assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
	end
end;

--> @load: UI LIRARY (vape)
if (not isfile('vapeui.lua')) then
	local suc, res = pcall(function()
		return game:HttpGet('https://raw.githubusercontent.com/megurgur/SorcererSuite/refs/heads/main/vapeui.lua', true)
	end)

	if (suc) then
		writefile('vapeui.lua', res);
	end;
end

local vape = loadstring(readfile('vapeui.lua'))();

xpcall(function()
local loadingNotification = vape:CreateNotification('Loading Suite.', 'Checking data.');

local run = function(func)
	func()
end
local queue_on_teleport = queue_on_teleport or function() end
local cloneref = cloneref or function(obj)
	return obj
end

if (getgenv().sorcererSuiteRan or getgenv().sorcererSuiteRanReal) then 
	return vape:CreateNotification('Sorcerer Suite', 'Script already ran.', 3)
end;
getgenv().sorcererSuiteRan = true;
getgenv().sorcererSuiteRanReal = true;

if (typeof(game) ~= "Instance") then return LPH_CRASH() end;
--if (typeof(websiteKey) ~= 'string' or typeof(scriptKey) ~= 'string') then return LPH_CRASH() end;

local originalFunctions = {};
local HttpService = game:GetService('HttpService');

if (not game:IsLoaded()) then
	loadingNotification:ChangeText('Waiting for game to load.')
    game.Loaded:Wait();
end;

local gameId = game.GameId;

--> @VAPE ENVIRONMENT
	local playersService = cloneref(game:GetService('Players'))
	local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
	local runService = cloneref(game:GetService('RunService'))
	local inputService = cloneref(game:GetService('UserInputService'))
	local tweenService = cloneref(game:GetService('TweenService'))
	local lightingService = cloneref(game:GetService('Lighting'))
	local marketplaceService = cloneref(game:GetService('MarketplaceService'))
	local teleportService = cloneref(game:GetService('TeleportService'))
	local httpService = cloneref(game:GetService('HttpService'))
	local guiService = cloneref(game:GetService('GuiService'))
	local groupService = cloneref(game:GetService('GroupService'))
	local textChatService = cloneref(game:GetService('TextChatService'))
	local contextService = cloneref(game:GetService('ContextActionService'))
	local coreGui = cloneref(game:GetService('CoreGui'))

	local isnetworkowner = identifyexecutor and table.find({'AWP', 'Nihon'}, ({identifyexecutor()})[1]) and isnetworkowner or function()
		return true
	end
	local gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA('Camera')
	local lplr = playersService.LocalPlayer
	local assetfunction = getcustomasset

--> @setup: SS Console & log()
rconsoleclear();
rconsolename('Sorcerer Suite Console');
local function log(...) 
	local t = {};

	for i = 1, select("#",...) do 
		t[i] = tostring((select(i,...)));
	end;

	rconsolewarn("[SS] "..table.concat(t," ").."\n");
end;

--> @services:
local PlayerService = game:GetService("Players");
local RunService = game:GetService("RunService");

local LocalPlayer = game:GetService('Players').LocalPlayer
originalFunctions.getRankInGroup = clonefunction(LocalPlayer.GetRankInGroup);

--local websiteKey, scriptKey = ;
local jobId, placeId = game.JobId, game.PlaceId;

local userId = LocalPlayer.UserId;
local isUserTrolled = false;
local accountData;
local scriptVersion;
local serverConstants = {};

debugMode = true;

do --> hook print debug
    if (not debugMode) then
        function print() end;
        function warn() end;
        function printf() end;
    end;
end;

loadingNotification:ChangeText('Checking whitelist.')

do --> @whitelist Check
	task.wait(1);
end;

loadingNotification:ChangeText('All done')
loadingNotification:Close(1);

local sharedModule = {};

local sharedRequires = {};
local sharedLoading = {};

function sharedRequire(name)
	if (sharedRequires[name] ~= nil) then
		return sharedRequires[name];
	end;

	if (sharedModule[name] == nil) then
		-- error(("sharedRequire: no module named '%s'"):format(name), 2);
	end;

	if sharedLoading[name] then
		local chain = table.concat(sharedLoading, " -> ") .. " -> " .. name;
		-- error("sharedRequire: circular require detected: " .. chain, 2);
	end;

	sharedLoading[name] = true;
	table.insert(sharedLoading, name);

	local moduleTable = {};
	sharedRequires[name] = moduleTable;

	local suc, err = pcall(sharedModule[name], moduleTable);

	sharedLoading[name] = nil;
	table.remove(sharedLoading);

	if (not suc) then
		sharedRequires[name] = nil;
		error(("sharedRequire: error loading '%s': %s"):format(name, tostring(err)), 2);
	end;

	return moduleTable;
end;

sharedModule['Signal'] = function(Signal)
	Signal.__index = Signal
	Signal.ClassName = "Signal"

	function Signal.new()
		local self = setmetatable({}, Signal)

		self._bindableEvent = Instance.new("BindableEvent")
		self._argData = nil
		self._argCount = nil -- Prevent edge case of :Fire("A", nil) --> "A" instead of "A", nil

		return self
	end

	function Signal.isSignal(object)
		return typeof(object) == 'table' and getmetatable(object) == Signal;
	end;

	function Signal:Fire(...)
		self._argData = {...}
		self._argCount = select("#", ...)
		self._bindableEvent:Fire()
		self._argData = nil
		self._argCount = nil
	end

	function Signal:Connect(handler)
		if not self._bindableEvent then return error("Signal has been destroyed"); end --Fixes an error while respawning with the UI injected

		if not (type(handler) == "function") then
			error(("connect(%s)"):format(typeof(handler)), 2)
		end

		return self._bindableEvent.Event:Connect(function()
			handler(unpack(self._argData, 1, self._argCount))
		end)
	end

	function Signal:Wait()
		self._bindableEvent.Event:Wait()
		assert(self._argData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
		return unpack(self._argData, 1, self._argCount)
	end

	function Signal:Destroy()
		if self._bindableEvent then
			self._bindableEvent:Destroy()
			self._bindableEvent = nil
		end

		self._argData = nil
		self._argCount = nil
	end
end;

sharedModule['Maid'] = function(Maid)
	local Signal = sharedRequire('Signal')
	Maid.ClassName = "Maid"

	function Maid.new()
		return setmetatable({
			_tasks = {}
		}, Maid)
	end

	function Maid.isMaid(value)
		return type(value) == 'table' and value.ClassName == 'Maid'
	end

	function Maid.__index(self, index)
		if Maid[index] then
			return Maid[index]
		else
			return self._tasks[index]
		end
	end

	function Maid:__newindex(index, newTask)
		if Maid[index] ~= nil then
			error(("'%s' is reserved"):format(tostring(index)), 2)
		end

		local tasks = self._tasks
		local oldTask = tasks[index]

		if oldTask == newTask then
			return
		end

		tasks[index] = newTask

		if oldTask then
			if type(oldTask) == "function" then
				oldTask()
			elseif typeof(oldTask) == "RBXScriptConnection" then
				oldTask:Disconnect();
			elseif typeof(oldTask) == 'table' then
				oldTask:Remove();
			elseif (Signal.isSignal(oldTask)) then
				oldTask:Destroy();
			elseif (typeof(oldTask) == 'thread') then
				task.cancel(oldTask);
			elseif oldTask.Destroy then
				oldTask:Destroy();
			end
		end
	end

	function Maid:GiveTask(task)
		if not task then
			error("Task cannot be false or nil", 2)
		end

		local taskId = #self._tasks+1
		self[taskId] = task

		return taskId
	end

	function Maid:DoCleaning()
		local tasks = self._tasks

		-- Disconnect all events first as we know this is safe
		for index, task in pairs(tasks) do
			if typeof(task) == "RBXScriptConnection" then
				tasks[index] = nil
				task:Disconnect()
			end
		end

		-- Clear out tasks table completely, even if clean up tasks add more tasks to the maid
		local index, task = next(tasks)
		while task ~= nil do
			tasks[index] = nil
			if type(task) == "function" then
				task()
			elseif typeof(task) == "RBXScriptConnection" then
				task:Disconnect()
			elseif task.Destroy then
				task:Destroy()
			end
			index, task = next(tasks)
		end
	end

	Maid.Destroy = Maid.DoCleaning
end;

local Maid = sharedRequire('Maid')
local unloadMaid = Maid.new();

sharedModule['Display'] = function(Display)
	--[[
		Display — runtime overhead marker / ESP tag utility.

		Reproduces the "way1/2/3" rig style:
		• Highlight (AlwaysOnTop, accent fill @0.5 / solid outline)
		• BillboardGui (400x100 max, AlwaysOnTop, infinite distance, LightInfluence 0)
		• TextLabel: AutomaticSize.XY + TextScaled, capped to 12px tall via
			UISizeConstraint, bottom-center anchored, black Contextual UIStroke.

		Flexible target: attach to a world position (a Vector3/CFrame) OR to an
		existing instance (character/model/part). Caller supplies the color.

		Usage:
			local Display = require(path.to.Display)

			-- position marker:
			local d = Display.new({
				Position = Vector3.new(0, 50, 0),
				Text = "Waypoint #1 [231]",
				Color = Color3.fromRGB(92, 255, 220),
			})

			-- ESP tag on a character (follows it, highlights it):
			local e = Display.new({
				Adornee = somePlayer.Character,
				Text = "PlayerName",
				Color = Color3.fromRGB(255, 165, 87),
			})

			d:SetText("updated")
			d:SetColor(Color3.fromRGB(207, 110, 255))
			d:Destroy()
	]]

	local Display = {}
	Display.__index = Display

	type DisplayConfig = {
		Text: string?,
		Color: Color3?,
		--> exactly one target:
		Adornee: Instance?,          -- follows + highlights this instance (or its model)
		Position: (Vector3 | CFrame)?, -- static world marker
		--> optional overrides (default to the rig's values):
		StudsOffset: Vector3?,
		Highlight: boolean?,         -- default true; false = text only, no chams
		Parent: Instance?,           -- where the GUI lives (default PlayerGui-safe: the head part)
	}

	type Display = typeof(setmetatable(
		{} :: {
			_root: BasePart,
			_billboard: BillboardGui,
			_label: TextLabel,
			_stroke: UIStroke,
			_highlight: Highlight?,
			_ownsRoot: boolean,
			Destroyed: boolean,
		},
		Display
	))

	local DEFAULT_COLOR = Color3.fromRGB(92, 255, 220)

	--> resolve an Adornee down to something a Highlight accepts (Model) and
	--> something we can pin a BillboardGui to (a BasePart).
	local function resolveAdornee(inst: Instance): (Instance?, BasePart?)
		if inst:IsA("Model") then
			local part = inst.PrimaryPart
				or inst:FindFirstChild("HumanoidRootPart")
				or inst:FindFirstChild("Head")
				or inst:FindFirstChildWhichIsA("BasePart", true)
			return inst, part
		elseif inst:IsA("BasePart") then
			--> highlight the containing model if there is one, else just the part
			local model = inst:FindFirstAncestorWhichIsA("Model")
			return (model or inst), inst
		end
		return nil, nil
	end

	function Display.new(config: DisplayConfig): Display
		local self = setmetatable({}, Display) :: Display
		self.Destroyed = false
		self._ownsRoot = false

		local color = config.Color or DEFAULT_COLOR
		local doHighlight = config.Highlight ~= false

		--> ---- resolve target: adornee vs static position ----
		local highlightTarget: Instance? = nil
		local pinPart: BasePart

		if config.Adornee then
			local hlt, part = resolveAdornee(config.Adornee)
			highlightTarget = hlt
			if part then
				pinPart = part
			else
				--> adornee had no BasePart; fall back to an owned root at origin
				pinPart = self:_makeRoot(Vector3.zero)
			end
		else
			--> static world marker: build our own tiny head part (the "way" rig)
			local pos: Vector3
			local cf = config.Position
			if typeof(cf) == "CFrame" then
				pos = cf.Position
			elseif typeof(cf) == "Vector3" then
				pos = cf
			else
				pos = Vector3.zero
			end
			pinPart = self:_makeRoot(pos)
			highlightTarget = pinPart
		end

		self._root = pinPart

		--> ---- Highlight (chams) ----
		if doHighlight and highlightTarget then
			local hl = Instance.new("Highlight")
			hl.Name = "DisplayHighlight"
			hl.Adornee = highlightTarget
			hl.FillColor = color
			hl.FillTransparency = 0.5
			hl.OutlineColor = color
			hl.OutlineTransparency = 0
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Parent = pinPart
			self._highlight = hl
		end

		--> ---- BillboardGui ----
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "DisplayBillboard"
		billboard.Adornee = pinPart
		billboard.Size = UDim2.fromOffset(400, 100)
		billboard.StudsOffset = config.StudsOffset or Vector3.zero
		billboard.AlwaysOnTop = true
		billboard.MaxDistance = math.huge
		billboard.LightInfluence = 0
		billboard.ResetOnSpawn = false
		billboard.Parent = pinPart
		self._billboard = billboard

		--> ---- TextLabel (capped-height auto-sizing) ----
		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.BackgroundTransparency = 1
		label.AnchorPoint = Vector2.new(0.5, 1)
		label.Position = UDim2.fromScale(0.5, 1)
		label.Size = UDim2.fromOffset(0, 0)
		label.AutomaticSize = Enum.AutomaticSize.XY
		label.TextScaled = true
		label.TextSize = 24
		label.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
		label.TextColor3 = color
		label.Text = config.Text or ""
		label.Parent = billboard
		self._label = label

		local sizeConstraint = Instance.new("UISizeConstraint")
		sizeConstraint.MinSize = Vector2.zero
		sizeConstraint.MaxSize = Vector2.new(math.huge, 12)
		sizeConstraint.Parent = label

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.new(0, 0, 0)
		stroke.Thickness = 0.1
		stroke.Transparency = 0.5
		stroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		stroke.Parent = label
		self._stroke = stroke

		return self
	end

	--> build a tiny anchored head part at a position (the way1/2 rig root)
	function Display._makeRoot(self: Display, pos: Vector3): BasePart
		local root = Instance.new("Part")
		root.Name = "DisplayHead"
		root.Size = Vector3.new(0.25, 0.25, 0.25)
		root.CFrame = CFrame.new(pos)
		root.Anchored = true
		root.CanCollide = false
		root.CanQuery = false
		root.CanTouch = false
		root.Transparency = 1  -- invisible anchor; the rig had 0 but a marker root shouldn't render
		root.Parent = workspace
		self._ownsRoot = true
		return root
	end

	--> ---- public API ----

	function Display.SetText(self: Display, text: string)
		if self.Destroyed then return end
		self._label.Text = text
	end

	function Display.SetColor(self: Display, color: Color3)
		if self.Destroyed then return end
		self._label.TextColor3 = color
		if self._highlight then
			self._highlight.FillColor = color
			self._highlight.OutlineColor = color
		end
	end

	function Display.SetPosition(self: Display, pos: Vector3 | CFrame)
		if self.Destroyed then return end
		if not self._ownsRoot then return end -- adornee-bound displays follow their target
		local cf = typeof(pos) == "CFrame" and pos or CFrame.new(pos :: Vector3)
		self._root.CFrame = cf
	end

	function Display.SetVisible(self: Display, visible: boolean)
		if self.Destroyed then return end
		self._billboard.Enabled = visible
		if self._highlight then self._highlight.Enabled = visible end
	end

	function Display.Destroy(self: Display)
		if self.Destroyed then return end
		self.Destroyed = true
		if self._highlight then self._highlight:Destroy() end
		self._billboard:Destroy()
		--> only destroy the root if WE created it (adornee parts belong to the game)
		if self._ownsRoot and self._root then
			self._root:Destroy()
		end
	end
end;

sharedModule['Nametag'] = function(Nametag)
	--[[
		Nametag — 1:1 rebuild of the StarterGui billboard dump.
		Two separate BillboardGuis + a Highlight, gradient stroke removed.

		Billboard 1 (above, StudsOffset 0,1,0):
			container pill -> text line ("Name [level]\n[hp/maxhp]")
			separate rounded health bar below the container (red track, green fill)
		Billboard 2 (below, StudsOffset 0,-3,0):
			tool nametag -> underline bar + text (default "None")
		Highlight: outline-only.

		Event-driven (no RenderStep):
			Health/MaxHealth -> Humanoid signals
			Tool             -> Character ChildAdded/ChildRemoved
			Distance         -> one shared 0.2s loop across all nametags
	]]

	local Players = game:GetService("Players")
	Nametag.__index = Nametag

	type Config = {
		Adornee: Instance,
		Name: string?,
		Level: number?,
		StudsOffset: Vector3?,
		Highlight: boolean?,
		ShowDistance: boolean?,
	}

	--> ── shared distance loop ──
	local activenametags: {[any]: boolean} = {}
	local distanceLoopRunning = false
	local function localRoot(): BasePart?
		local char = Players.LocalPlayer and Players.LocalPlayer.Character
		return char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	end
	local function startDistanceLoop()
		if distanceLoopRunning then return end
		distanceLoopRunning = true
		task.spawn(function()
			while distanceLoopRunning do
				local origin = localRoot()
				if origin then
					local op = origin.Position
					for nametag in activenametags do nametag:_updateDistance(op) end
				end
				task.wait(0.2)
				if next(activenametags) == nil then distanceLoopRunning = false end
			end
		end)
	end

	local function resolveTarget(inst: Instance): (Instance, BasePart?, Humanoid?, Model?)
		if inst:IsA("Model") then
			local part = inst.PrimaryPart or inst:FindFirstChild("HumanoidRootPart")
				or inst:FindFirstChild("Head") or inst:FindFirstChildWhichIsA("BasePart", true)
			return inst, part, inst:WaitForChild("Humanoid", 10), inst
		elseif inst:IsA("BasePart") then
			local model = inst:FindFirstAncestorWhichIsA("Model")
			return (model or inst), inst, model and model:WaitForChild("Humanoid", 10), model
		end
		return inst, nil, nil, nil
	end

	function Nametag.new(config: Config)
		local self = setmetatable({}, Nametag)
		self.Destroyed = false
		self._conns = {} :: {RBXScriptConnection}
		self._name = config.Name or "?"
		self._level = config.Level or 0
		self._distance = 0
		self._showDistance = config.ShowDistance ~= false
		self._health = 100
		self._maxHealth = 100
		self.Color = config.Color or Color3.new(1,1,1);
		self.TextSize = config.TextSize or 12
		self._tool = ""

		task.wait(1) -- let subject load

		local hlTarget, pinPart, hum, model;

		-- resolve target
		if config.Adornee:IsA("Model") then
			local part = config.Adornee.PrimaryPart or config.Adornee:FindFirstChild("HumanoidRootPart")
				or config.Adornee:FindFirstChild("Head") or config.Adornee:FindFirstChildWhichIsA("BasePart", true)
			
			hlTarget = config.Adornee 
			pinPart = part 
			hum = config.Adornee:WaitForChild("Humanoid", 10) 
			model = config.Adornee
		elseif inst:IsA("BasePart") then
			local amodel = config.Adornee:FindFirstAncestorWhichIsA("Model")
			
			hlTarget = (amodel or config.Adornee)
			pinPart = config.Adornee
			hum = amodel and amodel:WaitForChild("Humanoid", 10)
			model = amodel
		end
		if not pinPart then return end
		self._root = pinPart
		self._humanoid = hum

		--> ── Highlight (G2L 1d): outline-only ──
		if config.Highlight ~= false then
			local hl = Instance.new("Highlight")
			hl.Adornee = hlTarget
			hl.FillTransparency = 1
			hl.OutlineColor = self.Color;
			hl.OutlineTransparency = 0.5
			hl.Parent = gethui()
			self._highlight = hl
		end

		--> ══════════════════════════════════════════════════════════════
		--> BILLBOARD 1 (G2L 2): name/level + health bar, StudsOffset 0,1,0
		--> ══════════════════════════════════════════════════════════════
		local bb1 = Instance.new("BillboardGui")
		bb1.ExtentsOffset = Vector3.new(0, 1, 0)
		bb1.SizeOffset = Vector2.new(0, 0.5)
		bb1.Active = true
		bb1.Size = UDim2.new(0, 200, 0, 100)
		bb1.ClipsDescendants = false
		bb1.AlwaysOnTop = true
		bb1.Adornee = pinPart                       -- the un-convertible Adornee, resolved
		bb1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		bb1.StudsOffset = config.StudsOffset or Vector3.new(0, 1, 0)
		bb1.Parent = gethui()
		self._bb1 = bb1

		-- G2L 3: container Frame
		local c3 = Instance.new("Frame")
		c3.BorderSizePixel = 0
		c3.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
		c3.AnchorPoint = Vector2.new(0.5, 1)
		c3.AutomaticSize = Enum.AutomaticSize.XY
		c3.Position = UDim2.new(0.5, 0, 1, 0)
		c3.BackgroundTransparency = 1
		c3.Parent = bb1

		local c4 = Instance.new("UICorner"); c4.CornerRadius = UDim.new(1, 0); c4.Parent = c3

		-- G2L 5 -> 6: nested transparent wrappers (kept 1:1)
		local c5 = Instance.new("Frame")
		c5.BorderSizePixel = 0; c5.AutomaticSize = Enum.AutomaticSize.XY
		c5.BackgroundTransparency = 1; c5.Parent = c3
		local c6 = Instance.new("Frame")
		c6.BorderSizePixel = 0; c6.AutomaticSize = Enum.AutomaticSize.XY
		c6.BackgroundTransparency = 1; c6.Parent = c5

		-- G2L 7: the name/level/hp TextLabel
		local t7 = Instance.new("TextLabel")
		t7.TextStrokeTransparency = 0
		t7.TextSize = self.TextSize;
		t7.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		t7.TextColor3 = self.Color;
		t7.BackgroundTransparency = 1
		t7.RichText = true
		t7.AutomaticSize = Enum.AutomaticSize.XY
		t7.Text = ""
		t7.Parent = c6
		self._label = t7

		local t8 = Instance.new("UIStroke"); t8.Transparency = 0.5; t8.Parent = t7
		t8.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
		t8.Thickness = 0.1

		-- G2L 9: container padding
		local c9 = Instance.new("UIPadding")
		c9.PaddingTop = UDim.new(0, 4); c9.PaddingRight = UDim.new(0, 4)
		c9.PaddingLeft = UDim.new(0, 4); c9.PaddingBottom = UDim.new(0, 10)
		c9.Parent = c3

		-- G2L c: health bar track (below the container)
		local cc = Instance.new("Frame")
		cc.BorderSizePixel = 0
		cc.BackgroundColor3 = Color3.fromRGB(141, 55, 55)
		cc.AnchorPoint = Vector2.new(0.5, 0)
		cc.AutomaticSize = Enum.AutomaticSize.X
		cc.Size = UDim2.new(0, 40, 0, 4)
		cc.Position = UDim2.new(0.5, 0, 1, 2)
		cc.Parent = c3

		local cd = Instance.new("UICorner"); cd.CornerRadius = UDim.new(1, 0); cd.Parent = cc

		-- G2L e: health fill
		local ce = Instance.new("Frame")
		ce.BorderSizePixel = 0
		ce.BackgroundColor3 = Color3.fromRGB(75, 212, 73)
		ce.AutomaticSize = Enum.AutomaticSize.X
		ce.Size = UDim2.new(0, 0, 0, 4)
		ce.Parent = cc
		self._fill = ce

		self._healthTrack = cc          -- add after self._fill = ce
		--> near the top of new(), with the other self._ fields:
		self._showHealth = config.ShowHealth ~= false   -- default true
		self._showTool   = config.ShowTool ~= false     -- default true

		local cf = Instance.new("UICorner"); cf.CornerRadius = UDim.new(0, 4); cf.Parent = ce
		local c10 = Instance.new("UIStroke"); c10.Transparency = 0.5; c10.Parent = ce
		local c11 = Instance.new("UIStroke"); c11.Transparency = 0.5; c11.Parent = cc

		--> ══════════════════════════════════════════════════════════════
		--> BILLBOARD 2 (G2L 12): tool nametag, StudsOffset 0,-3,0
		--> ══════════════════════════════════════════════════════════════
		local bb2 = Instance.new("BillboardGui")
		bb2.SizeOffset = Vector2.new(0, -0.5)
		bb2.Active = true
		bb2.Size = UDim2.new(0, 200, 0, 21)
		bb2.ClipsDescendants = false
		bb2.AlwaysOnTop = true
		bb2.Adornee = pinPart
		bb2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		bb2.StudsOffset = Vector3.new(0, -3, 0)
		bb2.Parent = gethui()
		self._bb2 = bb2

		-- G2L 13: tool container
		local d13 = Instance.new("Frame")
		d13.BorderSizePixel = 0
		d13.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
		d13.AnchorPoint = Vector2.new(0.5, 0)
		d13.AutomaticSize = Enum.AutomaticSize.X
		d13.Size = UDim2.new(0, 0, 1, 0)
		d13.Position = UDim2.new(0.5, 0, 0, 0)
		d13.BackgroundTransparency = 1
		d13.Parent = bb2

		local d14 = Instance.new("UICorner"); d14.CornerRadius = UDim.new(0, 4); d14.Parent = d13

		-- G2L 15: underline bar
		local d15 = Instance.new("Frame")
		d15.BorderSizePixel = 0
		d15.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
		d15.AutomaticSize = Enum.AutomaticSize.X
		d15.Size = UDim2.new(0, 0, 0, 1)
		d15.Position = UDim2.new(0, 0, 1, 0)
		d15.BackgroundTransparency = 0.5
		d15.Parent = d13

		-- G2L 16 -> 17: nested transparent wrappers
		local d16 = Instance.new("Frame")
		d16.BorderSizePixel = 0; d16.AutomaticSize = Enum.AutomaticSize.X
		d16.Size = UDim2.new(0, 0, 1, 0); d16.BackgroundTransparency = 1; d16.Parent = d13
		local d17 = Instance.new("Frame")
		d17.BorderSizePixel = 0; d17.AutomaticSize = Enum.AutomaticSize.X
		d17.Size = UDim2.new(0, 0, 1, 0); d17.BackgroundTransparency = 1; d17.Parent = d16

		-- G2L 18: tool TextLabel (default "None")
		local d18 = Instance.new("TextLabel")
		d18.TextStrokeTransparency = 0
		d18.TextSize = self.TextSize;
		d18.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		d18.TextColor3 = self.Color;
		d18.BackgroundTransparency = 1
		d18.RichText = true
		d18.Size = UDim2.new(0, 0, 1, 0)
		d18.AutomaticSize = Enum.AutomaticSize.X
		d18.Text = "None"
		d18.Parent = d17
		self._toolLabel = d18

		local d19 = Instance.new("UIStroke"); d19.Transparency = 0.5; d19.Parent = d18

		-- G2L 1a: tool container padding
		local d1a = Instance.new("UIPadding")
		d1a.PaddingRight = UDim.new(0, 4); d1a.PaddingLeft = UDim.new(0, 4); d1a.Parent = d13

		-- G2L 1b: tool container UIStroke (gradient child dropped)
		local d1b = Instance.new("UIStroke")
		d1b.Thickness = 0; d1b.Color = Color3.fromRGB(255, 255, 255); d1b.Parent = d13

		--> ── wire events (no polling) ──
		log(hum)
		if hum then
			table.insert(self._conns, hum:GetPropertyChangedSignal("Health"):Connect(function()
				self:_onHealth(hum.Health, hum.MaxHealth)
			end))
			table.insert(self._conns, hum:GetPropertyChangedSignal("MaxHealth"):Connect(function()
				self:_onHealth(hum.Health, hum.MaxHealth)
			end))
			self:_onHealth(hum.Health, hum.MaxHealth)
		end
		if model then
			local function scanTool()
				local t = model:FindFirstChildWhichIsA("Tool")
				self._tool = t and t.Name or ""
				self:_renderTool()
			end
			table.insert(self._conns, model.ChildAdded:Connect(function(c) if c:IsA("Tool") then scanTool() end end))
			table.insert(self._conns, model.ChildRemoved:Connect(function(c) if c:IsA("Tool") then scanTool() end end))
			scanTool()
		end

		if self._showDistance then
			activenametags[self] = true
			startDistanceLoop()
		end

		self._healthTrack.Visible = self._showHealth
		self._bb2.Enabled = self._showTool

		self:_render()
		self:_renderTool()
		return self
	end

	--> ── internal handlers ──
	function Nametag._onHealth(self, health, maxHealth)
		self._health, self._maxHealth = health, maxHealth
		local frac = maxHealth > 0 and math.clamp(health / maxHealth, 0, 1) or 0
		self._fill.Size = UDim2.new(frac, 0, 0, 4)
		self:_render()
	end

	function Nametag._updateDistance(self, originPos)
		if self.Destroyed or not self._root or not self._root.Parent then return end
		local rounded = math.floor((self._root.Position - originPos).Magnitude + 0.5)
		if rounded ~= self._distance then self._distance = rounded; self:_render() end
	end

	function Nametag._render(self)
		if self.Destroyed then return end
		local head = self._showDistance and self._distance or self._level
		local line1 = string.format("%s [%d] ", self._name, head)
		if self._showHealth then
			local line2 = string.format("[%d/%d]", math.floor(self._health + 0.5), math.floor(self._maxHealth + 0.5))
			self._label.Text = line1 .. "\n" .. line2
		else
			self._label.Text = line1
		end
	end

	function Nametag._renderTool(self)
		if self.Destroyed then return end
		self._toolLabel.Text = self._tool ~= "" and self._tool or "None"
	end

	--> ── public API ──
	function Nametag.SetName(self, name) if self.Destroyed then return end self._name = name; self:_render() end
	function Nametag.SetLevel(self, lvl) if self.Destroyed then return end self._level = lvl; self:_render() end
	function Nametag.SetColor(self, color)
		if (self.Destroyed) then return end;
	
		self._label.TextColor3 = color;
		self._toolLabel.TextColor3 = color;
		if (self._highlight) then
			self._highlight.OutlineColor = color;
		end;
	
	end;
	function Nametag.SetTextSize(self, size)
		if self.Destroyed then return end
		self._textSize = size
		self._label.TextSize = size
		self._toolLabel.TextSize = size
	end
	function Nametag.SetShowHealth(self, show)
		if self.Destroyed then return end
		self._showHealth = show
		self._healthTrack.Visible = show   -- the bar below billboard 1
		self:_render()                     -- add/remove the [hp/maxhp] line
	end

	function Nametag.SetShowTool(self, show)
		if self.Destroyed then return end
		self._showTool = show
		self._bb2.Enabled = show           -- the entire tool billboard
	end
	function Nametag.SetHealth(self, h, m) if self.Destroyed then return end self:_onHealth(h, m or self._maxHealth) end
	function Nametag.SetTool(self, t) if self.Destroyed then return end self._tool = t or ""; self:_renderTool() end
	function Nametag.SetVisible(self, v)
		if self.Destroyed then return end
		self._bb1.Enabled = v; 
		self._bb2.Enabled = v and self._showTool;
		if self._highlight then self._highlight.Enabled = v end
	end
	function Nametag.Destroy(self)
		if self.Destroyed then return end
		self.Destroyed = true
		activenametags[self] = nil
		for _, c in self._conns do pcall(function() c:Disconnect() end) end
		table.clear(self._conns)
		if self._highlight then self._highlight:Destroy() end
		if self._bb1 then self._bb1:Destroy() end
		if self._bb2 then self._bb2:Destroy() end
	end
end;

-- sharedModule['Vape'] = loadstring(readfile('vapeui.lua'));

sharedModule['NewIndexService'] = function(NewIndexService)
	if RunService:IsStudio() then return end

	-- weak keys so destroyed instances don't leak
	local Secured = setmetatable({}, { __mode = "k" })

	local gsub = string.gsub
	local insert = table.insert

	-- cache globals once; some executors have expensive/hooked lookups
	local checkcaller = checkcaller
	local getconnections = getconnections
	local gethiddenproperty = gethiddenproperty
	local sethiddenproperty = sethiddenproperty
	local hookmetamethod = hookmetamethod
	local newcclosure = newcclosure

	local function clean(property)
		-- strip null-byte bypass attempts
		return (gsub(property, "%z", ""))
	end

	--------------------------------------------------------------------------
	-- Metamethod hooks
	--------------------------------------------------------------------------
	-- debugprint("hooking __index")
	-- local __index
	-- __index = hookmetamethod(game, "__index", newcclosure(function(self, property)
	-- 	if not checkcaller() then
	-- 		local properties = Secured[self]
	-- 		if properties then
	-- 			local entry = properties[clean(property)]
	-- 			if entry then
	-- 				return entry.OriginalValue
	-- 			end
	-- 		end
	-- 	end
	-- 	return __index(self, property)
	-- end))
	-- debugprint("hooked __index")

	-- debugprint("hooking __newindex")
	-- local __newindex
	-- __newindex = hookmetamethod(game, "__newindex", newcclosure(function(self, property, value)
	-- 	if not checkcaller() then
	-- 		local properties = Secured[self]
	-- 		if properties then
	-- 			local key = clean(property)
	-- 			local entry = properties[key]
	-- 			if entry then
	-- 				-- game thinks it wrote `value`; we keep showing our spoofed value
	-- 				entry.OriginalValue = value
	-- 				return __newindex(self, key, entry.NewValue)
	-- 			end
	-- 		end
	-- 	end
	-- 	return __newindex(self, property, value)
	-- end))
	-- debugprint("hooked __newindex")

	--------------------------------------------------------------------------
	-- Connection helpers
	--------------------------------------------------------------------------
	local function collectDisabled(signals)
		local disabled = {}
		for _, signal in signals do
			if signal then
				for _, connection in getconnections(signal) do
					-- Disable isn't universally supported; guard it
					if connection.Disable then
						connection:Disable()
						insert(disabled, connection)
					end
				end
			end
		end
		return disabled
	end

	local function enableConnections(connections)
		for _, connection in connections do
			pcall(connection.Enable, connection)
		end
	end

	-- Gathers Changed + GetPropertyChangedSignal(property) safely.
	-- Both can throw on certain instances / non-replicated properties.
	local function silenceSignals(self, property)
		local signals = {}

		local ok, changed = pcall(function() return self.Changed end)
		if ok and typeof(changed) == "RBXScriptSignal" then
			insert(signals, changed)
		end

		if property then
			local ok2, pcs = pcall(self.GetPropertyChangedSignal, self, property)
			if ok2 then
				insert(signals, pcs)
			end
		end

		return collectDisabled(signals)
	end

	local function rawWrite(self, property, value)
		pcall(sethiddenproperty, self, property, value)
		pcall(function() self[property] = value end)
	end

	--------------------------------------------------------------------------
	-- Registry
	--------------------------------------------------------------------------
	local function readCurrent(self, property)
		local ok, value = pcall(gethiddenproperty, self, property)
		if ok and value ~= nil then
			return value
		end
		local ok2, value2 = pcall(function() return self[property] end)
		if ok2 then
			return value2
		end
		return nil
	end

	local function registerSecured(self, property, value)
		local properties = Secured[self]
		if not properties then
			properties = {}
			Secured[self] = properties
		end

		local entry = properties[property]
		if not entry then
			entry = { OriginalValue = readCurrent(self, property) }
			properties[property] = entry
		end

		entry.NewValue = value
		return entry
	end

	--------------------------------------------------------------------------
	-- Public API
	--------------------------------------------------------------------------

	-- Set a property without registering it (no spoofing on read-back).
	function NewIndexService:noregistersecureset(self, property, value)
		local disabled = silenceSignals(self, property)
		rawWrite(self, property, value)
		enableConnections(disabled)
		return true
	end
    -- secureset, multisecureset, unregisterSecured, noregistersecureset
	-- Set a property and spoof reads back to its original value.
	function NewIndexService:secureset(self, property, value)
		registerSecured(self, property, value)

		local disabled = silenceSignals(self, property)
		rawWrite(self, property, value)
		enableConnections(disabled)

		return true
	end

	-- Restore the original value and stop spoofing.
	function NewIndexService:unregisterSecured(self, property)
		local properties = Secured[self]
		local entry = properties and properties[property]
		if not entry then
			return false
		end

		local value = entry.OriginalValue

		-- clear registration first, or the __newindex hook will re-spoof the write
		properties[property] = nil
		if next(properties) == nil then
			Secured[self] = nil
		end

		local disabled = silenceSignals(self, property)
		rawWrite(self, property, value)
		enableConnections(disabled)

		return true
	end

	function NewIndexService:multisecureset(self, properties)
		for property, value in properties do
			secureset(self, property, value)
		end
		return true
	end
end;

sharedModule['RobloxServices'] = function(RobloxServices)

end;

sharedModule['utils.basics.lighting'] = function(basics)
    local NewIndexService = sharedRequire('NewIndexService');
	local Lighting = game:GetService("Lighting")

	--------------------------------------------------------------------
	-- state
	--------------------------------------------------------------------
	local fullbrightChanged
	local nofogChanged, nofogChildAdded
	local noblurChildAdded

	-- [instance] = originalParent
	-- Strong references on purpose: an instance with Parent = nil and no other
	-- refs gets garbage collected, and then we can never put it back.
	local strippedAtmosphere = {}
	local strippedBlur = {}

	local ATMOSPHERE = { "Atmosphere" }
	local BLUR = { "BlurEffect", "DepthOfFieldEffect" }

	-- property -> getter, so values stay live instead of being baked in at connect time
	local FULLBRIGHT_PROPS = {
		Brightness     = function() return Options["Brightness"].Value end,
		Ambient        = function() return Options["Ambient"].Value end,
		OutdoorAmbient = function() return Options["OutdoorAmbient"].Value end,
	}

	local FOG_PROPS = {
		FogEnd   = function() return 9e9 end,
		FogStart = function() return 0 end,
	}

	--------------------------------------------------------------------
	-- helpers
	--------------------------------------------------------------------
	local function disconnect(connection)
		if connection then
			connection:Disconnect()
		end
		return nil
	end

	local function applyAll(map)
		for property, get in map do
			NewIndexService:secureset(Lighting, property, get())
		end
	end

	local function restoreAll(map)
		for property in map do
			NewIndexService:unregisterSecured(Lighting, property)
		end
	end

	-- Fallback for writes that bypass __newindex (TweenService, engine-side changes).
	local function watchProps(toggle, map)
		return Lighting.Changed:Connect(function(property: string)
			if not Options[toggle].Value then return end
			local get = map[property]
			if get then
				NewIndexService:secureset(Lighting, property, get())
			end
		end)
	end

	local function isAnyOf(instance, classes)
		for _, class in classes do
			if instance:IsA(class) then
				return true
			end
		end
		return false
	end

	local function strip(stored, child)
		if stored[child] then return end
		stored[child] = child.Parent
		child.Parent = nil
	end

	local function stripExisting(stored, classes)
		for _, child in Lighting:GetChildren() do
			if isAnyOf(child, classes) then
				strip(stored, child)
			end
		end
	end

	local function restoreStripped(stored)
		for child, parent in stored do
			stored[child] = nil
			if child.Parent == nil then
				pcall(function() child.Parent = parent end)
			end
		end
	end

	local function watchChildren(toggle, stored, classes)
		return Lighting.ChildAdded:Connect(function(child)
			if not Options[toggle].Value then return end
			if isAnyOf(child, classes) then
				strip(stored, child)
			end
		end)
	end

	--------------------------------------------------------------------
	-- fullbright
	--------------------------------------------------------------------
	function basics:fullbright()
		fullbrightChanged = disconnect(fullbrightChanged)

		applyAll(FULLBRIGHT_PROPS)
		fullbrightChanged = watchProps("Fullbright", FULLBRIGHT_PROPS)
	end;

	function basics:disableFullbright()
		fullbrightChanged = disconnect(fullbrightChanged)
		restoreAll(FULLBRIGHT_PROPS)
	end;

	--------------------------------------------------------------------
	-- fog
	--------------------------------------------------------------------
	function basics:noFog()
		nofogChanged = disconnect(nofogChanged)
		nofogChildAdded = disconnect(nofogChildAdded)

		applyAll(FOG_PROPS)
		stripExisting(strippedAtmosphere, ATMOSPHERE)

		nofogChanged = watchProps("NoFog", FOG_PROPS)
		nofogChildAdded = watchChildren("NoFog", strippedAtmosphere, ATMOSPHERE)
	end;

	function basics:disableNoFog()
		nofogChanged = disconnect(nofogChanged)
		nofogChildAdded = disconnect(nofogChildAdded)

		restoreAll(FOG_PROPS)
		restoreStripped(strippedAtmosphere)
	end;

	--------------------------------------------------------------------
	-- blur
	--------------------------------------------------------------------
	function basics:noBlur()
		noblurChildAdded = disconnect(noblurChildAdded)

		stripExisting(strippedBlur, BLUR)
		noblurChildAdded = watchChildren("NoBlur", strippedBlur, BLUR)
	end;

	function basics:disableNoBlur()
		noblurChildAdded = disconnect(noblurChildAdded)
		restoreStripped(strippedBlur)
	end;
end;

local NewIndexService = sharedRequire('NewIndexService');
local LightingBasics = sharedRequire('utils.basics.lighting');

local scriptLoadAt = tick();
local silentLaunch = not not getgenv().ms_silentLaunch;

local function printf() end;

if (not game:IsLoaded()) then
    game.Loaded:Wait();
end;

--> @uninject Old Vape
local oldVape = (getgenv().oldVape)
if (oldVape) and (typeof(oldVape.Uninject) == 'function') then
	getgenv().oldVape:Uninject();
end;

--> @assign new Old Vape
getgenv().oldVape = vape;

--> grab library internals at load time (Uninject clears mainapi.Libraries)
local lib     = vape.Libraries;
local asset   = lib.getcustomasset;
local color   = lib.color;
local tween   = lib.tween;
local uipallet = lib.uipallet;

local Players           = game:GetService('Players');
local RunService        = game:GetService('RunService');
local Lighting          = game:GetService('Lighting');
local UserInputService  = game:GetService('UserInputService');
local TeleportService   = game:GetService('TeleportService');
local ProximityPromptService = game:GetService('ProximityPromptService');

local LocalPlayer = Players.LocalPlayer;

--> ═══════════════════════════════════════════════════════════════════
--> helpers
--> ═══════════════════════════════════════════════════════════════════

local function getCharacter()
    return LocalPlayer.Character;
end;

local function getHumanoid()
    local char = getCharacter();
    return char and char:FindFirstChildOfClass('Humanoid');
end;

local function getRoot()
    local char = getCharacter()
    return char and char:FindFirstChild('HumanoidRootPart');
end;

--> resolve a partial username/displayname to a Player
local function findPlayer(query)
    if query == '' then return nil end;
    local q = query:lower();
    for _, p in Players:GetPlayers() do
        if p.Name:sub(1, #q):lower() == q or p.DisplayName:sub(1, #q):lower() == q then
            return p
        end
    end
    return nil
end

--> closest other character in the same folder as ours
local function findClosestEnemy()
    local root = getRoot()
    local char = getCharacter()
    if not root or not char then return nil end

    local closest, closestDist = nil, math.huge
    for _, model in char.Parent:GetChildren() do
        if model ~= char then
            local otherRoot = model:FindFirstChild('HumanoidRootPart')
            if otherRoot then
                local dist = (otherRoot.Position - root.Position).Magnitude
                if dist < closestDist then
                    closest, closestDist = model, dist
                end
            end
        end
    end
    return closest
end

--> ═══════════════════════════════════════════════════════════════════
--> shell
--> ═══════════════════════════════════════════════════════════════════

vape:CreateGUI();
vape.Categories.Main:CreateDivider();

-- create game category

local supportedGames = { --> game.GameId
	[10257007695] = "Snowcone Stand";
	[6061766680] = "fight in a school";
	[10207000525] = "+1 Crunchy Butter Escape";
}

local gameName = supportedGames[game.GameId];
if (gameName) then
	rconsolewarn('[SS] Game found: ');
	rconsoleprint(gameName);
	rconsolewarn('.\n');

	vape:CreateCategory({
		Name = gameName,
		Icon = asset('newvape/assets/new/legit.png'),
		Size = UDim2.fromOffset(15, 14)
	});
end;

vape:CreateCategory({
    Name = 'Combat',
    Icon = asset('newvape/assets/new/combaticon.png'),
    Size = UDim2.fromOffset(15, 14)
});

vape:CreateCategory({
    Name = 'Visuals',
    Icon = asset('newvape/assets/new/rendericon.png'),
    Size = UDim2.fromOffset(15, 14)
});

vape:CreateCategory({
    Name = 'World',
    Icon = asset('newvape/assets/new/worldicon.png'),
    Size = UDim2.fromOffset(15, 14)
});

vape:CreateCategory({
    Name = 'Utils',
    Icon = asset('newvape/assets/new/utilityicon.png'),
    Size = UDim2.fromOffset(15, 14)
});

vape:CreateCategory({
    Name = 'Misc',
    Icon = asset('newvape/assets/new/dots.png'),
    Size = UDim2.fromOffset(15, 14)
});

vape.Categories.Main:CreateOverlayBar();   -- must exist before any CreateOverlay
vape.Categories.Main:CreateSettingsDivider();

local list = {};
for i = 1, 20 do
    list[i] = game:GetService("HttpService"):GenerateGUID();
end;

-- local offset;
-- offset = vape.Categories.Misc:CreateModule({
--     Name = 'Test Module',
--     Tooltip = 'Offsets your character via a held animation pose',
--     Function = print
-- });
-- offset.Version = offset:CreateMultiDropdown({
--     Name = 'Test List',
--     List = list,
--     Darker = true,
--     Function = log
-- });

-- table.foreach(vape.Categories.Misc, print)

--> @combat

--> @visuals
local Nametag = sharedRequire('Nametag');

local nametags = {};   --> player -> Nametag
local ESPModule
ESPModule = vape.Categories.Visuals:CreateModule({
    Name = 'Display Players',
	Tooltip = 'Allows better viewing of PlayerCharacters ingame.',
    Function = function(callback)
        if (not callback) then return end;
        
        local espMaid = Maid.new();

        local function eligible(player)
            if (player == LocalPlayer and not ESPModule.IncludeSelf.Enabled) then
                return false;
            end;
            return true;
        end;

        local function despawn(player)
            if nametags[player] then
                nametags[player]:Destroy();
                nametags[player] = nil;
            end;
        end;

        local function spawnFor(player, character)
            local char = character or player.Character;
            if (not char or not char.Parent) then return end;
            despawn(player);
            -- local suc, nametag = pcall(function()
                local nametag;
				task.spawn(function()
					nametag = Nametag.new({
				-- return Nametag.new({
						Adornee = char,
						Name = player.Name,
						ShowTool = ESPModule.ShowTool.Enabled,
						TextSize = ESPModule.TextSize.Value,
						ShowHealth = ESPModule.ShowHealth.Enabled,
						Color = Color3.fromHSV(ESPModule.Color.Hue, ESPModule.Color.Sat, ESPModule.Color.Value) or Color3.fromRGB(240, 240, 240),
						Highlight = ESPModule.Chams.Enabled,
					});
				end)
            -- end);
			-- log(suc,nametag)
            -- if (suc and nametag) then
                nametags[player] = nametag;
				if (nametag) and (not eligible(player)) and (typeof(nametag.SetVisible) == 'function') then
					nametag:SetVisible(false);
				end;
            -- end;
        end;

        local function trackPlayer(player)
            espMaid:GiveTask(player.CharacterAdded:Connect(function(char)
                task.defer(function() spawnFor(player, char) end);
            end));
            if player.Character then
                spawnFor(player);
            end;
        end;

        --> existing + future players
        for _, player in PlayerService:GetPlayers() do
            trackPlayer(player);
        end;
        espMaid:GiveTask(PlayerService.PlayerAdded:Connect(trackPlayer));
        espMaid:GiveTask(PlayerService.PlayerRemoving:Connect(despawn));

        --> teardown when the module toggles off
        espMaid:GiveTask(function()
            for player in nametags do despawn(player) end;
        end);
        ESPModule:Clean(function() espMaid:DoCleaning() end);
    end;
});

ESPModule.ShowHealth = ESPModule:CreateToggle({ Name = 'Show Health', Default = true, Function = function(callback)
	for player, nametag in nametags do
		if typeof(nametag.SetShowHealth) == 'function' then nametag:SetShowHealth(callback) end
	end
end});

ESPModule.ShowTool = ESPModule:CreateToggle({ Name = 'Show Tool', Default = true, Function = function(callback)
	for player, nametag in nametags do
		if typeof(nametag.SetShowTool) == 'function' then nametag:SetShowTool(callback) end
	end
end});
ESPModule.Color = ESPModule:CreateColorSlider({ Name = 'Color', DefaultHue = 0, DefaultSat = 0, DefaultValue = 0.94, Function = function(h,s,v)
	local color = Color3.fromHSV(h,s,v);
	for player, nametag in nametags do
		nametag:SetColor(color);
	end
end});
ESPModule.TextSize = ESPModule:CreateSlider({
	Name = 'Text Size',
	Min = 8, Max = 36, Default = 12,
	Decimal = 1,           -- integer sizes
	Suffix = 'px',
	Function = function(value)
		for player, nametag in nametags do
			if typeof(nametag.SetTextSize) == 'function' then
				nametag:SetTextSize(value)
			end
		end
	end
});
ESPModule.Chams = ESPModule:CreateToggle({ Name = 'Chams', Default = true, Function = function(callback)
	for player, nametag in nametags do
		local highlight = nametag._highlight;
		if (highlight) and (highlight.Enabled ~= nil) then highlight.Enabled = callback end;
	end
end});
ESPModule.IncludeSelf = ESPModule:CreateToggle({ Name = 'Include Self', Default = false, Function = function(callback)
	local myNametag = nametags[LocalPlayer];
	if (myNametag) and (typeof(myNametag.SetVisible) == 'function') then
		myNametag:SetVisible(ESPModule and callback);
	end;
end});

--> @world
local Freecam do
	local Value
	local randomkey, module, old = httpService:GenerateGUID(false)

	Freecam = vape.Categories.World:CreateModule({
		Name = 'Freecam',
		Function = function(callback)
			if callback then
				repeat
					task.wait(0.1)
					for _, v in getconnections(gameCamera:GetPropertyChangedSignal('CameraType')) do
						if v.Function then
							module = debug.getupvalue(v.Function, 1)
						end
					end
				until module or not Freecam.Enabled

				if module and module.activeCameraController and Freecam.Enabled then
					old = module.activeCameraController.GetSubjectPosition
					local camPos = old(module.activeCameraController) or Vector3.zero
					module.activeCameraController.GetSubjectPosition = function()
						return camPos
					end

					Freecam:Clean(runService.PreSimulation:Connect(function(dt)
						if not inputService:GetFocusedTextBox() then
							local forward = (inputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0) + (inputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
							local side = (inputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0) + (inputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0)
							local up = (inputService:IsKeyDown(Enum.KeyCode.Q) and -1 or 0) + (inputService:IsKeyDown(Enum.KeyCode.E) and 1 or 0)
							dt = dt * (inputService:IsKeyDown(Enum.KeyCode.LeftShift) and 0.25 or 1)
							camPos = (CFrame.lookAlong(camPos, gameCamera.CFrame.LookVector) * CFrame.new(Vector3.new(side, up, forward) * (Value.Value * dt))).Position
						end
					end))

					contextService:BindActionAtPriority('FreecamKeyboard'..randomkey, function()
						return Enum.ContextActionResult.Sink
					end, false, Enum.ContextActionPriority.High.Value,
						Enum.KeyCode.W,
						Enum.KeyCode.A,
						Enum.KeyCode.S,
						Enum.KeyCode.D,
						Enum.KeyCode.E,
						Enum.KeyCode.Q,
						Enum.KeyCode.Up,
						Enum.KeyCode.Down
					)
				end
			else
				pcall(function()
					contextService:UnbindAction('FreecamKeyboard'..randomkey)
				end)
				if module and old then
					module.activeCameraController.GetSubjectPosition = old
					module = nil
					old = nil
				end
			end
		end,
		Tooltip = 'Lets you fly and clip through walls freely\nwithout moving your player server-sided.'
	})
	Value = Freecam:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end;
vape.Categories.World:CreateModule({
	Name = 'NoclipCamera',
	Function = function(callback)
		if callback then
			local Popper = LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
			for _, v in pairs(getgc()) do
				if type(v) == 'function' and getfenv(v).script == Popper then
					for i, v1 in pairs(debug.getconstants(v)) do
						if tonumber(v1) == .25 then
							debug.setconstant(v, i, 0)
						end
					end
				end
			end
		else
			local Popper = LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
			for _, v in pairs(getgc()) do
				if type(v) == 'function' and getfenv(v).script == Popper then
					for i, v1 in pairs(debug.getconstants(v)) do
						if tonumber(v1) == 0 then
							debug.setconstant(v, i, .25)
						end
					end
				end
			end
		end
	end,
	Tooltip = 'Makes your camera have noclip 💩.'
})
--> @utils

--> @misc

local unload
unload = vape.Categories.Misc:CreateModule({
    Name = 'Unload Suite',
    Tooltip = 'Completely removes the suite from this game instance.',
    Function = function(enabled)
        vape:Uninject()
	end;
})
unload.NoSave = true;
local rejoin
rejoin = vape.Categories.Misc:CreateModule({
    Name = 'Rejoin Server',
    Tooltip = "Teleports sorcerer to the server they're currently in.",
    Function = function(enabled)
		LocalPlayer:Kick("Rejoining")
		game:GetService('GuiService'):ClearError()

		local tempTeleportGui do
			local function new(class, properties)
				local obj = Instance.new(class)
		
				for idx, val in properties do
					obj[idx] = val
				end
		
				return obj
			end
		
			local ScreenGui = new("ScreenGui", {
				Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			})
			tempTeleportGui = ScreenGui
		
			local Frame = new("Frame", {
				Parent = ScreenGui,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(2, 150, 2, 100)
			})
			local UIGradient = new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(15, 15, 15))},
				Rotation = 45,
				Parent = Frame,
			})
			local UICorner = new("UICorner", {
				Parent = Frame,
			})
			local TextLabel = new("TextLabel", {
				Parent = Frame,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, -20),
				Size = UDim2.new(1, 0, 1, 0),
				FontFace = Font.fromEnum(Enum.Font.Merriweather),
				Text = "Sorcerer Suite",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 32.000,
				TextTransparency = 0.400,
				TextWrapped = true,
			})
			local UIGradient_2 = new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(248, 251, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(219, 220, 248))},
				Rotation = 45,
				Parent = TextLabel,
			})
			local TextLabel_2 = new("TextLabel", {
				Parent = Frame,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 20),
				Size = UDim2.new(1, 0, 1, 0),
				FontFace = Font.fromEnum(Enum.Font.Merriweather),
				Text = "Rejoining",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 21.000,
				TextTransparency = 0.400,
				TextWrapped = true,
			})
			local UIGradient_3 = new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(248, 251, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(219, 220, 248))},
				Rotation = 45,
				Parent = TextLabel_2,
			})
			local Frame_2 = new("Frame", {
				Parent = Frame,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 250, 0, 1),
			})
		end
		game:GetService("TeleportService"):SetTeleportGui(tempTeleportGui)

		pcall(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
		end);
    end
})
rejoin.NoSave = true;
-- vape.Modules["Unload"] = vape.Categories.Misc:CreateButton({
--     Name = 'Unload',
--     Tooltip = 'Removes the suite from this game',
--     Function = function()
--         vape:Uninject()
--     end
-- })

--> credits pane
local credits = vape.Categories.Main:CreateSettingsPane({Name = 'Credits'})
credits:CreateButton({
    Name = 'UI: Vape V4',
    Tooltip = 'This ClickGUI is extracted from Vape V4 for Roblox',
    Function = function()
        vape:CreateToast(
            'Credits',
            "UI library from <b>Vape V4 for Roblox</b><br/>by 7GrandDad and the Vape team.",
            3
        )
        pcall(setclipboard, 'https://github.com/7GrandDadPGN/VapeV4ForRoblox')
    end
})

--> ═══════════════════════════════════════════════════════════════════
--> GUI settings + bind (must come before Load)
--> ═══════════════════════════════════════════════════════════════════

-- vape.GUIColor = vape.Categories.Main:CreateGUISlider({
--     Name = 'GUI Theme',
--     Function = function(h, s, v)
--         vape:UpdateGUI(h, s, v, true)
--     end
-- })
vape.Categories.Main:CreateBind()

--> ═══════════════════════════════════════════════════════════════════
--> load profiles — MUST be last
--> ═══════════════════════════════════════════════════════════════════

local GRAY = Color3.fromHSV(0.5, 0.6, 0.8)

function vape:UpdateTextGUI()
    vape:UpdateGUI(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value, true)
end

function vape:UpdateGUI(hue, sat, val, default)
    if vape.Loaded == nil then return end
    for _, module in vape.Modules do
        if module.Enabled then
            module.Object.BackgroundColor3 = GRAY
            module.Object.TextColor3 = Color3.new(1, 1, 1)
            module.Object.UIGradient.Enabled = false
            module.Object.Bind.Icon.ImageColor3 = Color3.new(1, 1, 1)
            module.Object.Bind.TextLabel.TextColor3 = Color3.new(1, 1, 1)
            module.Object.Dots.Dots.ImageColor3 = Color3.new(1, 1, 1)
        end
        for _, option in module.Options do
            if option.Color then
                option:Color(hue, sat, val, false)
            end
        end
    end
end

--> @SUPPORTED GAME MODULES (START)
local gameCategory;
if (gameName) then 
	gameCategory = vape.Categories[gameName];
end;

if (gameName == "") then
elseif (gameName == "+1 Crunchy Butter Escape") then
	local Lobby = workspace:WaitForChild("Lobby", 5) or workspace.Map:FindFirstChild("Lobby", true);

	local plotLoadingNotification;
	-- wait for plot
	if (Lobby == nil) then
		plotLoadingNotification = vape:CreateNotification('Loading', 'Waiting for lobby to load.')
		repeat 
			Lobby = workspace.Map:FindFirstChild("Lobby", true);
			task.wait(0.3);
		until (Lobby ~= nil)
		
		task.wait(0.5)
		plotLoadingNotification:ChangeText("Finished loading.");
		plotLoadingNotification:Close(1);
	end;

	local rebirthButton;
	for _, v in LocalPlayer.PlayerGui:WaitForChild("Rebirth"):WaitForChild("Container"):WaitForChild("Frame"):GetChildren() do
		if (v.Name == 'Boost') and (v:FindFirstChild("Arrow") == nil) then
			for _, v2 in v:GetChildren() do
				if (v2:IsA("TextButton")) and (v2:FindFirstChild("Text").Text == 'Rebirth!') then
					rebirthButton = v2;
				end
			end;
		end;
	end;

	AutoRebirth = gameCategory:CreateModule({
		Name = 'Auto Rebirth',
		Tooltip = "Automatically rebirth for sorcerer.",
		Function = function(callback)
			if (not callback) then return end;

			while (AutoRebirth.Enabled) do
				firesignal(rebirthButton.Activated);
				task.wait(1)
			end;
		end;
	})
	
	local world;
	for _, v in workspace.Map:GetChildren() do
		if v.Name:sub(1, 5) == 'World' then world = v break end;
	end;

	-- local atWin = false;
	AutofarmWins = gameCategory:CreateModule({
		Name = 'Autofarm Wins',
		Tooltip = "Win buttons have a 3(s) cooldown.",
		Function = function(callback)
			if (not callback) then return end;

			local button;
			local highest = 0;
			for _, v in world.WinButtons:GetChildren() do 
				local real = v.Button.BillboardGui.Wins.Text:gsub('m', '000000'):gsub('k', '000'):gsub('b', '000000000')
				local winsAmount = tonumber(string.split(real:sub(2), ' ')[1])
				print(winsAmount)
				if (winsAmount and winsAmount > highest) then 
					highest = winsAmount;
					button = v;
				end;
			end;

			print(highest, button)

			while (AutofarmWins.Enabled) do
				local ch = LocalPlayer.Character
				local rp = ch and ch:FindFirstChild("HumanoidRootPart");
				if (rp) then else task.wait(1) continue end
				-- atWin = true;
				-- task.delay(0.5, function()
				-- 	atWin = false;
				-- end)
				firetouchinterest(button.Button, rp, true)
				firetouchinterest(button.Button, rp, false)
				-- rp.CFrame = button.Button.CFrame
				task.wait(3.5)
			end
		end;
	})
	
	local treadmills = {};
	for _, v in Lobby:GetChildren() do
		print(v.Name)
		if (v.Name:find('Treadmill')) then 
			table.insert(treadmills, v.Name);
		end;
	end;

	TreadmillFarm = gameCategory:CreateModule({
		Name = 'Treadmill Farm',
		Tooltip = "Win buttons have a 3(s) cooldown.",
		Function = function(callback)
			if (not callback) then return end;

			local stepped = RunService.Stepped
			local steppedWait = stepped.Wait

			while (TreadmillFarm.Enabled) do
				local ch = LocalPlayer.Character;
				local rp = ch and ch:FindFirstChild("HumanoidRootPart");
				local treadmill = TreadmillFarm.SelectTreadmill.Value;
				local treadmill = treadmill and Lobby:FindFirstChild(treadmill);
				local treadmill = treadmill and treadmill:FindFirstChild("TreadArea");
				-- if (atWin) then task.wait(0.5) continue end;
				if (rp and treadmill) then else task.wait(1) continue end;
				rp.CFrame = treadmill.CFrame * CFrame.Angles(0,math.rad(-90),0);
				steppedWait(stepped);
			end;
		end;
	})
	TreadmillFarm.SelectTreadmill = TreadmillFarm:CreateDropdown({
		Name = 'Select Treadmill',
		Tooltip = 'Select a treadmill to farm.',
		List = treadmills;
	});

	Lobby.ChildAdded:Connect(function(treadmill)
		task.defer(function()
			print(treadmill.Name)
			if (treadmill.Name:find('Treadmill')) then 
				table.insert(treadmills, v.Name);
				TreadmillFarm.SelectTreadmill:Change(treadmills);
			end;
		end);
	end);
	
	local killBricks = {};
	gameCategory:CreateModule({
		Name = 'No Killbricks',
		Tooltip = 'Removes all bricks that detect touch.',
		Function = function(callback)
			if (callback) then
				local winButtons = world.WinButtons;

				for _, v in workspace:GetDescendants() do
					if (v:IsDescendantOf(winButtons)) then continue end;
					if (v:FindFirstChildWhichIsA("TouchTransmitter")) then
						killBricks[v] = v.Parent;
						v.Parent = nil;
					end;
				end;
			elseif (not callback) then
				for killbrick, parent in killBricks do
					killbrick.Parent = parent;
				end;
			end;
		end;
	})
elseif (gameName == "fight in a school") then
elseif (gameName == "Snowcone Stand") then
	local Network, PlotSystem, UserData;

	local shopStockExample = {
		Equipment = {{
			rarity = 'Common', 
			placeable = 'BasicBlender', 
			perks = {speedMult = 1},
			remaining = 3,
			gem = 5,
			category = 'Machines',
			name = 'Basic Blender',
			tier = 'Common',
			icon = 'rbxassetid://133353713943695',
			cash = 50
		}};
		Plants = {{
			rarity = "Common",
			tier = "Common",
			remaining = 1,
			gem = 5,
			placeable = "GrapePlant",
			category = "Plants",
			name = "Grape Plant",
			icon = "rbxassetid://122188368659662",
			cash = 5000
		}};
		Flavors = {{
			remaining = 17,
			rarity = "Common",
			tier = "Common",
			name = "Ice",
			gem = 5,
			icon = "rbxassetid://137056545047267",
			cash = 10
		}};
		Automation = {{
			rarity = "Common",
			tier = "Common",
			remaining = 5,
			gem = 5,
			placeable = "ConvStraight",
			category = "Automation",
			name = "Conveyor",
			icon = "rbxassetid://89447493608574",
			cash = 10000
		}};
	}

	function getShopStock(recursive)
		local returnVal = UserData:Get("ShopStock");

		if (returnVal == nil) then
			repeat 
				returnVal = UserData:Get("ShopStock");
				task.wait(0.2)
			until (returnVal ~= nil)
		end;

		return returnVal;
	end;

	function buyFlavor(flavor: string)
		assert(flavor, 'Cannot buy flavor, missing flavor argument.');

		Network:FireServer("BuyShopItem", "Flavors", flavor, "cash");
	end;

	function buyFlavor(flavor: string)
		assert(flavor, 'Cannot buy flavor, missing flavor argument.');

		Network:FireServer("BuyShopItem", "Flavors", flavor, "cash");
	end;

	--[[ LPH_NO_VIRTUALIZE(function()
		local pass = 0;

		for _, v in getgc(true) do
			if type(v) == 'table' then
				if rawget(v, 'AddReferenceAlias') and rawget(v, 'LogTraffic') then
					Network = v;
					pass += 1;
				elseif rawget(v, 'Key') == 'UserData' then
					UserData = v;
					pass += 1;
				elseif rawget(v, 'PerfectZoneBounds') then
					PlotSystem = v;
					pass += 1;
				end;

				if pass >= 3 then break end;
			end;
		end;
	-- end)();]]

	vape:Remove('Combat');

	PlotSystem = filtergc('table', {Keys={'PerfectZoneBounds'}}, true);
	local myPlot = PlotSystem.FindOwnedPlot(LocalPlayer);

	-- wait for plot
	if (myPlot == nil) then
		plotLoadingNotification = vape:CreateNotification('Plot Loading', 'Waiting for plot to load.')
		repeat 
			myPlot = PlotSystem.FindOwnedPlot(LocalPlayer);
			task.wait(0.3)
		until (myPlot ~= nil)
	end;
	plotLoadingNotification:ChangeText("All done.")
	plotLoadingNotification:Close(1);
	plotLoadingNotification = nil;
	
	Network = filtergc('table', {Keys={'AddReferenceAlias','LogTraffic'}}, true);
	UserData = filtergc('table', {Keys={'Binds'},KeyValuePairs={Key = 'UserData'}}, true);

	--> LIST CATEGORIES (START)

		local listedCategories = {
			--> @equipment
			Machines = {};
			Tables = {};
			Special = {};

			--> @plants
			Plants = {};
			--> @automation
			Automation = {};
		}
		local listedFlavors = {};
		local flavorList = {};

		local currentShopStock = UserData:Get("ShopStock");
		repeat 
			currentShopStock = UserData:Get("ShopStock")
			task.wait(0.2)
		until (currentShopStock ~= nil) and (currentShopStock.Equipment ~= nil);
		-- log(currentShopStock, #currentShopStock)
		for _, equipment in currentShopStock.Equipment do
			listedCategories[equipment.category][equipment.placeable] = equipment;
		end;
		for _, plant in currentShopStock.Plants do
			listedCategories[plant.category][plant.placeable] = plant;
		end;
		for _, flavor in currentShopStock.Flavors do
			table.insert(flavorList, flavor.name);
			listedFlavors[flavor.name] = flavor;
		end;

		for _, auto in currentShopStock.Automation do
			listedCategories[auto.category][auto.placeable] = auto;
		end;

	--> LIST CATEGORIES (END)
	
	local AutoSell, AutoBlend, AutoCollect, AutoBuyFlavors, GetShopStock;

	local function findVacantTable()
		local candidates = {};

		for _, item in myPlot.PlacedItems:GetChildren() do
			if (listedCategories.Tables[item.Name] ~= nil) then
				for _, placePart in item.PlaceParts:GetChildren() do
					if (placePart:FindFirstChild('Cone') == nil) then
						table.insert(candidates, placePart);
					end;
				end;
			end;
		end;

		table.sort(candidates, function(a, b)
			return (a:FindFirstAncestorOfClass("Model"):GetAttribute('SpeedMult') or 0) > (b:FindFirstAncestorOfClass("Model"):GetAttribute('SpeedMult') or 0)
		end)

		return candidates[1];
	end;

	local function findVacantBlender()
		local candidates = {};

		for _, item in myPlot.PlacedItems:GetChildren() do
			if (listedCategories.Machines[item.Name] ~= nil) then
				for _, blender in item:GetChildren() do
					if (blender:IsA("Folder")) and (not blender:GetAttribute("Blending")) then
						table.insert(candidates, blender);
					end;
				end;
			end;
		end;

		table.sort(candidates, function(a, b)
			return (a:GetAttribute('SpeedMult') or 0) > (b:GetAttribute('SpeedMult') or 0)
		end)
		
		return candidates[1];
	end;

	local function waitForAdornee(hud)
		return hud:GetPropertyChangedSignal("Adornee"):Wait(1);
	end;

	local function isNil(adornee)
		return (adornee == nil)
	end;

	local blenderZones = {Ice = true, Chunky = true, Perfect = true, Melted = true, Liquid = true};
	local collectableZones = {Perfect = true, Melted = true, Liquid = true};

	local BlenderHuds = LocalPlayer.PlayerGui:WaitForChild('_BlenderHuds');

	local excludedFlavors = {};

	AutoBuyFlavors = gameCategory:CreateModule({
		Name = 'Auto Buy Flavors',
		Tooltip = 'Automatically buys snowcone flavors for the sorcerer.',
		Function = function(callback)
			while (AutoBuyFlavors.Enabled) do
				local shopStock = getShopStock();
				local flavorsToBuy = shopStock.Flavors;
				
				table.sort(flavorsToBuy, function(a,b)
					return a.cash < b.cash;
				end);

				for idx, flavor in flavorsToBuy do
					if (table.find(excludedFlavors, flavor.name)) then continue end;
					local cashAmount = UserData:Get('Cash')

					local amountCanBuy = math.min(math.floor(cashAmount / flavor.cash), flavor.remaining)
					
					for i = 1, amountCanBuy do
						buyFlavor(flavor.name);
					end;

					if amountCanBuy < flavor.remaining then break end;
					task.wait();
				end

				task.wait(3);
			end;
		end;
	})

	AutoBuyFlavors:CreateMultiDropdown({
		Name = 'Exclude Flavors',
		List = flavorList,
		Darker = true,
		Function = function(selectedList, selectionChangedOption, selectionChangedState)
			excludedFlavors = selectedList;
			-- table.foreach(AutoBuyFlavors['Exclude Flavors'], log)
		end;
	});

	AutoCollect = gameCategory:CreateModule({
		Name = 'Auto Collect',
		Tooltip = 'Automatically collects snowcones for the sorcerer.',
		Function = function(callback)
			if (not callback) then return end;

			for _, blenderHud in BlenderHuds:GetChildren() do
				if (blenderHud.Adornee and blenderHud.Adornee:IsDescendantOf(myPlot)) then else continue end;
				
				local textLabels = {};
				for _, v in blenderHud.Content:GetChildren() do
					if (v:IsA("TextLabel")) and (blenderZones[v.Text]) then
						table.insert(textLabels, v);
					end;
				end;

				for _, zoneText in textLabels do
					if collectableZones[zoneText.Text] then
						local prompt = vacantBlender and vacantBlender:FindFirstChildWhichIsA('ProximityPrompt', true)
						if (prompt) and (prompt.ActionText ~= "Insta Blend") then fireproximityprompt(prompt) end
					end;
				end;
			end;
		end;
	})

	AutoBlend = gameCategory:CreateModule({
		Name = 'Auto Blend',
		Tooltip = 'Automatically blends snowcones for the sorcerer.',
		Function = function(callback)
			local thread = task.spawn(function()
				while AutoBlend.Enabled do
					
					local flavors = {};
					for _, flavor in LocalPlayer.Backpack:GetChildren() do
						if not AutoBlend.Enabled then break end

						if flavor:GetAttribute('Kind') == 'flavor' then
							table.insert(flavors, flavor)
						end
					end

					table.sort(flavors, function(a, b)
						local valueA = (a:GetAttribute('Value') or 1)-- * (a:GetAttribute('Weight') or 1)
						local valueB =  (b:GetAttribute('Value') or 1)-- * (b:GetAttribute('Weight') or 1)

						return valueA > valueB;
					end);

					for _, flavor in flavors do
						local vacantBlender = findVacantBlender()
						if vacantBlender then
							local char = LocalPlayer.Character
							local hum = char and char:FindFirstChildOfClass('Humanoid')
							if hum then
								hum:EquipTool(flavor)
								task.wait(0.1);
								local prompt = vacantBlender:FindFirstChildWhichIsA("ProximityPrompt", true)
								if (prompt) and (prompt.ActionText ~= "Insta Blend") then
									fireproximityprompt(prompt);
								end;
								task.wait(0.1);
								-- local blendTime = flavor:GetAttribute('BlendSeconds') or 1
								-- local speed = vacantBlender.Parent:GetAttribute('SpeedMult') or 1
								-- if speed <= 0 then speed = 1 end
								-- task.delay((blendTime / speed) + 0.1, function()
    							-- 	if not AutoBlend.Enabled then return end
								-- 	fireproximityprompt(vacantBlender.PrimaryPart.ProximityPrompt);
								-- end)
							end
						else
							local char = LocalPlayer.Character
							local tool = char:FindFirstAncestorOfClass("Tool")
							if (tool) and (tool:GetAttribute('Kind') == 'flavor') then
								local hum = char and char:FindFirstChildOfClass('Humanoid')
								if hum then hum:UnequipTools() end;
							end;
							task.wait(5);
							break;
						end;
					end;

					task.wait(0.5)
				end
			end)

			AutoBlend:Clean(function() pcall(task.cancel, thread) end)
		end
	})

	AutoSell = gameCategory:CreateModule({
		Name = 'Auto Sell',
		Tooltip = 'Automatically sells snowcones for the sorcerer.',
		Function = function(callback)
			local thread = task.spawn(function()
				while AutoSell.Enabled do
					local inventory = LocalPlayer.Backpack:GetChildren();
					local character = LocalPlayer.Character
					local equipped = character and character:FindFirstChildOfClass("Tool");
					if equipped then
						table.insert(inventory, equipped);
					end;

					local cones = {};

					for _, cone in inventory do
						if not AutoSell.Enabled then break end

						if cone:GetAttribute('Kind') == 'cone' then
							table.insert(cones, cone);
						end;
					end;

					table.sort(cones, function(a, b)
						return (a:GetAttribute('Value') or 0) > (b:GetAttribute('Value') or 0)
					end)

					for _, cone in cones do
						local vacantTable = findVacantTable()
						if vacantTable then
							local char = LocalPlayer.Character
							local hum = char and char:FindFirstChildOfClass('Humanoid')
							if hum then
								hum:EquipTool(cone)
								task.wait()

								for _, prompt in vacantTable:GetChildren() do
									if prompt:IsA('ProximityPrompt')
										and prompt.Enabled
										and prompt.ActionText == 'Place Cone' then
										fireproximityprompt(prompt)
										break
									end
								end
							end
							task.wait();
						end
					end;

					task.wait(0.5)
				end
			end)

			AutoSell:Clean(function() pcall(task.cancel, thread) end)
		end
	})

	local no_zonetext_count = 0;

	--> @Auto Collect Functionality
	local function setupBlenderHud(blenderHud)
		local adornee = blenderHud.Adornee;
		-- log(adornee)
		--> @make sure has (adornee)
		if isNil(adornee) then waitForAdornee(blenderHud) if isNil(adornee) then return log('returned black') end end;

		--> @make sure is our blender
		if (adornee:IsDescendantOf(myPlot)) then else return end;
		-- log('mine');

		local textlabels = {};
		for _, v in blenderHud.Content:GetChildren() do
			if (v:IsA("TextLabel")) then
				table.insert(textlabels, v);
			end;
		end;

		-- log(zoneText);

		local connections = {};
		for _, zoneText in textlabels do
			table.insert(connections, zoneText.Changed:Connect(function()
				if (not AutoCollect.Enabled) then return end;
				if collectableZones[zoneText.Text] then
					local prompt = adornee:FindFirstChildOfClass("ProximityPrompt", true);
					if (prompt) and (prompt.ActionText ~= "Insta Blend") then fireproximityprompt(prompt) end;
				end;
			end));
		end;

		table.insert(connections, adornee.Destroying:Once(function()
			for _, connection in connections do
				if (connection) and (connection.Disconnect) then connection:Disconnect() end;
			end;
		end));
		table.insert(connections, blenderHud.Destroying:Once(function()
			for _, connection in connections do
				if (connection) and (connection.Disconnect) then connection:Disconnect() end;
			end;
		end));
	end;

	for _, v in BlenderHuds:GetChildren() do
		task.spawn(setupBlenderHud, v)
	end;
	BlenderHuds.ChildAdded:Connect(setupBlenderHud);

	GetShopStock = gameCategory:CreateButton({
		Name = 'Copy Shop Stock (JSON)',
		Tooltip = "Set to clipboard: JSON of userdata:Get('ShopStock')",
		Function = function()
			local shopStock = getShopStock();
			setclipboard(HttpService:JSONEncode(shopStock));

			vape.ChangeTooltip("Copied")
			task.wait(0.25)
			vape.ChangeTooltip("Set to clipboard: JSON of userdata:Get('ShopStock')")
		end;
	});

end;

--> @SUPPORT GAME MODULES (END)

for _, v in getconnections(LocalPlayer.Idled) do
	if (v.Function) then continue end;
	v:Disable();
end;

-- vape:CreateLegit()
vape:CreateSearch()

vape:Load()
vape:CreateNotification('Sorcerer Suite', 'Loaded. Press <b>LeftAlt</b> to open.', 5)

log('Loaded.')
getgenv().ss_loaded = true;
end, function(...)
	local t = {};

	for i = 1, select("#",...) do 
		t[i] = tostring((select(i,...)));
	end;

	vape:CreateNotification("Error", table.concat(t,"\n"), 8, "alert")
end)
