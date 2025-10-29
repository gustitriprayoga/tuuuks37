--[[
    FI-SHIT | By Rav
    UI Revamped by Gemini with Glassmorphism Effect
    All core functionalities remain untouched.
--]] -- Services & Libraries
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- External Libraries (Assuming these are loaded correctly)
local lib = loadstring(game:HttpGet("https://cdn.x-zone.id/Library/Lib"))()
local FlagsManager = loadstring(game:HttpGet("https://cdn.x-zone.id/Library/ConfigManager"))()

-- Remote Event References
local Update = ReplicatedStorage.Packages._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Update
local netFolder = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- =================================================================
-- SECTION: Main UI Initialization
-- =================================================================

local main = lib:Load({
    Title = "🎣 FI-SHIT | By G",
    ToggleButton = "rbxassetid://138498482261906",
    BindGui = Enum.KeyCode.RightControl
})

-- =================================================================
-- SECTION: Global State Variables
-- =================================================================

-- Toggles State
local autoFishOn, noclipOn, infiniteJumpOn, espOn, airWalkOn, infOxygenOn, antiAfkOn = false, false, false, true, false,
    false, false

-- Values
local walkSpeedValue = 16
local boatType = 1
local rodIndex = 1
local enchantId = 1

-- Connections & Instances
local airwalkPlatform, airwalkConn, freezeConn, afkConn
local freezePosition

-- =================================================================
-- SECTION: Dynamic Teleport UI (Revamped with Glassmorphism)
-- =================================================================

local function createTeleportDialog(teleportList)
    if #teleportList == 0 then
        lib:Notification("Teleport", "No valid targets found!", 2.5)
        return
    end

    local dialogGui = Instance.new("ScreenGui")
    dialogGui.Name = "TeleportDialog"
    dialogGui.ResetOnSpawn = false
    dialogGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    dialogGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame with Glass Effect
    local frame = Instance.new("Frame", dialogGui)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Active = true

    -- Glass Border
    local frameStroke = Instance.new("UIStroke", frame)
    frameStroke.Color = Color3.fromRGB(120, 120, 180)
    frameStroke.Thickness = 1.5
    frameStroke.Transparency = 0.5

    local frameCorner = Instance.new("UICorner", frame)
    frameCorner.CornerRadius = UDim.new(0, 12)

    -- Subtle Gradient for Depth
    local frameGradient = Instance.new("UIGradient", frame)
    frameGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 85, 120)),
                                             ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 45, 70))})
    frameGradient.Rotation = 90

    -- Title
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Teleport Locations"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.new(1, 1, 1)

    -- Close Button
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -38, 0, 5)
    closeBtn.Text = "✖"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 8)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = Color3.fromRGB(255, 100, 130)
    closeStroke.Thickness = 1

    closeBtn.MouseButton1Click:Connect(function()
        dialogGui:Destroy()
    end)

    -- Scrolling Frame
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -16, 1, -52)
    scroll.Position = UDim2.new(0, 8, 0, 44)
    scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    scroll.BackgroundTransparency = 0.6
    scroll.BorderSizePixel = 0
    scroll.ClipsDescendants = true
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 200)
    local scrollCorner = Instance.new("UICorner", scroll)
    scrollCorner.CornerRadius = UDim.new(0, 8)

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

    -- Populate List with Buttons
    for _, item in ipairs(teleportList) do
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Text = item.label
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.BackgroundColor3 = Color3.fromRGB(80, 140, 220)
        btn.BackgroundTransparency = 0.4
        btn.TextColor3 = Color3.new(1, 1, 1)

        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 8)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(120, 180, 255)
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(item.pos + Vector3.new(0, 3, 0))
                lib:Notification("Teleport", "Teleported to: " .. item.label, 2.5)
            end
            dialogGui:Destroy()
        end)
    end

    task.defer(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end)
end

-- =================================================================
-- SECTION: AFK Black Screen UI (Revamped)
-- =================================================================
local blackScreenOn = false
local afkBlackScreenOn = false
local startTime = 0
local timerConn

local afkBlackScreenGui = Instance.new("ScreenGui")
afkBlackScreenGui.Name = "AFKBlackScreen"
afkBlackScreenGui.ResetOnSpawn = false
afkBlackScreenGui.IgnoreGuiInset = true
afkBlackScreenGui.Enabled = false
afkBlackScreenGui.Parent = player:WaitForChild("PlayerGui")

local blackFrame = Instance.new("Frame", afkBlackScreenGui)
blackFrame.Name = "BlackFrame"
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BorderSizePixel = 0

-- Dynamic timer label with a modern look
local timerLabel = Instance.new("TextLabel", blackFrame)
timerLabel.Name = "TimerLabel"
timerLabel.BackgroundTransparency = 1
timerLabel.Size = UDim2.new(0, 300, 0, 60)
timerLabel.Position = UDim2.new(0.5, -150, 0.5, -30)
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 36
timerLabel.Text = "AFK: 00:00:00"
timerLabel.TextStrokeTransparency = 0.5
timerLabel.TextStrokeColor3 = Color3.fromRGB(50, 50, 50)

local camera = Workspace.CurrentCamera
local oldCameraType, oldCameraSubject

local function toTimeString(seconds)
    local hours = string.format("%02d", math.floor(seconds / 3600))
    local mins = string.format("%02d", math.floor(seconds / 60) % 60)
    local secs = string.format("%02d", seconds % 60)
    return hours .. ":" .. mins .. ":" .. secs
end

local function enableBlackScreen()
    afkBlackScreenOn = true
    startTime = os.time()
    oldCameraType, oldCameraSubject = camera.CameraType, camera.CameraSubject
    camera.CameraType = Enum.CameraType.Scriptable
    afkBlackScreenGui.Enabled = true
    timerLabel.Text = "AFK: 00:00:00"
    if timerConn then
        timerConn:Disconnect()
    end
    timerConn = RunService.RenderStepped:Connect(function()
        timerLabel.Text = "AFK: " .. toTimeString(os.time() - startTime)
    end)
end

local function disableBlackScreen()
    afkBlackScreenOn = false
    camera.CameraType = oldCameraType
    camera.CameraSubject = oldCameraSubject
    afkBlackScreenGui.Enabled = false
    if timerConn then
        timerConn:Disconnect();
        timerConn = nil
    end
end

-- =================================================================
-- SECTION: Feature Functions
-- =================================================================

-- Airwalk & Character Freeze
local function createAirPlatform()
    if airwalkPlatform then
        return
    end
    airwalkPlatform = Instance.new("Part")
    airwalkPlatform.Name = "RavAirPlatform"
    airwalkPlatform.Size = Vector3.new(6, 0.5, 6)
    airwalkPlatform.Anchored = true
    airwalkPlatform.CanCollide = true
    airwalkPlatform.Transparency = 0.7
    airwalkPlatform.Color = Color3.fromRGB(80, 200, 255)
    airwalkPlatform.Material = Enum.Material.ForceField
    airwalkPlatform.Parent = Workspace
end

local function enableAirWalk()
    createAirPlatform()
    airwalkConn = RunService.RenderStepped:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            airwalkPlatform.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -3.2, 0)
        end
    end)
end

local function disableAirWalk()
    if airwalkConn then
        airwalkConn:Disconnect();
        airwalkConn = nil
    end
    if airwalkPlatform then
        airwalkPlatform:Destroy();
        airwalkPlatform = nil
    end
end

local function freezeCharacter(state)
    local char = player.Character
    if not char then
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if state then
        if root then
            freezePosition = root.CFrame
            freezeConn = RunService.RenderStepped:Connect(function()
                if root and root.Parent then
                    root.CFrame = freezePosition
                end
            end)
        end
        if humanoid then
            humanoid.WalkSpeed, humanoid.JumpPower = 0, 0
        end
    else
        if freezeConn then
            freezeConn:Disconnect();
            freezeConn = nil
        end
        if humanoid then
            humanoid.WalkSpeed, humanoid.JumpPower = walkSpeedValue, 50
        end
    end
end

-- Teleport Logic
local function getTeleportDestinations()
    local teleList = {}
    -- Islands
    local islandLocations = Workspace:FindFirstChild("!!!! ISLAND LOCATIONS !!!!")
    if islandLocations then
        for _, loc in ipairs(islandLocations:GetChildren()) do
            local part = loc:IsA("BasePart") and loc or loc:FindFirstChildWhichIsA("BasePart")
            if part then
                table.insert(teleList, {
                    label = "[🏝️ Island] " .. loc.Name,
                    pos = part.Position
                })
            end
        end
    end
    -- Enchanting Altar
    local altar = Workspace:FindFirstChild("! ENCHANTING ALTAR !")
    if altar and altar:FindFirstChild("EnchantLocation") then
        table.insert(teleList, {
            label = "[🏛️ Enchant Altar]",
            pos = altar.EnchantLocation.Position
        })
    end
    -- NPCs
    local npcFolder = ReplicatedStorage:FindFirstChild("NPC")
    if npcFolder then
        for _, npc in ipairs(npcFolder:GetChildren()) do
            local part = npc.PrimaryPart or npc:FindFirstChild("HumanoidRootPart")
            if part then
                table.insert(teleList, {
                    label = "[🧙‍♂️ NPC] " .. npc.Name,
                    pos = part.Position
                })
            end
        end
    end
    -- Players
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(teleList, {
                label = "[👤 Player] " .. p.Name,
                pos = p.Character.HumanoidRootPart.Position
            })
        end
    end
    -- Props / Events
    local props = Workspace:FindFirstChild("Props")
    if props then
        for _, model in ipairs(props:GetChildren()) do
            if model:IsA("Model") then
                local part = model:FindFirstChildWhichIsA("BasePart")
                if part then
                    table.insert(teleList, {
                        label = "[🗺️ Event] " .. model.Name,
                        pos = part.Position
                    })
                end
            end
        end
    end
    return teleList
end

-- =================================================================
-- SECTION: UI Tabs & Components Population
-- =================================================================

-- Main Tab
local Main = main:AddTab("Main")
main:SelectTab()

-- Info Section
local MainSection = Main:AddSection({
    Title = "📢 Information - Fish It",
    Default = true
})
MainSection:AddParagraph({
    Title = "⚡ FI-SHIT UPDATE !",
    Description = "• Version : 1.0.0 "
})
MainSection:AddParagraph({
    Title = "🔔 What's New?",
    Description = "- adjust / increase speed auto fish 2x\n- pengoptimalan auto fish\n- fix auto stop fish\n- fix air walk bug\n- add character freeze ( combo air walk )\n- add teleport to new fishing rod \n- add teleport to main temple \n- add teleport to treasure ruins \n- add buy event trigger ( ini bukan exploit cuma alat bantu beli event cuaca, jadi tetap pakai coin )\n- add afk blackscreen rendering\n- coming soon!"
})

-- Auto Features Section
local AutoSection = Main:AddSection({
    Title = "🔥 Auto Features",
    Description = "Automated actions for efficiency"
})

AutoSection:AddToggle("AutoFish", {
    Title = "Auto Fish",
    Default = false,
    Description = "Auto fishing (start/stop)",
    Callback = function(state)
        autoFishOn = state
        if autoFishOn then
            lib:Notification("Auto Fish", "Started!", 2.5)
            netFolder["RE/EquipToolFromHotbar"]:FireServer(1)
            task.spawn(function()
                while autoFishOn do
                    pcall(function()
                        netFolder["RF/ChargeFishingRod"]:InvokeServer(tick())
                        task.wait()
                        netFolder["RF/RequestFishingMinigameStarted"]:InvokeServer(-1, 1)
                        task.wait(0.001)
                        netFolder["RE/FishingCompleted"]:FireServer()
                    end)
                    task.wait(0.01)
                end
                pcall(function()
                    netFolder["RF/CancelFishingInputs"]:InvokeServer()
                    netFolder["RE/FishingStopped"]:FireServer()
                    task.wait(0.01)
                    netFolder["RE/UnequipToolFromHotbar"]:FireServer()
                end)
            end)
        else
            lib:Notification("Auto Fish", "Stopped!", 2.5)
        end
    end
})

AutoSection:AddToggle("InfOxygenToggle", {
    Title = "Infinity Oxygen",
    Default = false,
    Description = "Anti-drown even with 0 oxygen",
    Callback = function(state)
        infOxygenOn = state
        local remoteName = "URE/UpdateOxygen"
        local remote = netFolder:FindFirstChild(remoteName)
        if infOxygenOn then
            if remote then
                remote:Destroy()
            end
        else
            if not netFolder:FindFirstChild(remoteName) then
                Instance.new("RemoteEvent", netFolder).Name = remoteName
            end
        end
        lib:Notification("Infinity Oxygen", infOxygenOn and "ON" or "OFF", 2.5)
    end
})

AutoSection:AddButton({
    Title = "Sell All Items",
    Color = Color3.fromRGB(255, 140, 80),
    Callback = function()
        local remote = netFolder:FindFirstChild("RF/SellAllItems")
        if remote and remote:IsA("RemoteFunction") then
            local success, result = pcall(function()
                return remote:InvokeServer()
            end)
            lib:Notification("Sell All", success and "Successfully sold all items!" or "Failed: " .. tostring(result), 3)
        else
            lib:Notification("Sell All", "Remote not found!", 2.5)
        end
    end
})

-- Movement & Utilities Section
local MovementSection = Main:AddSection({
    Title = "🏃💨 Movement & Utilities",
    Description = "Player, boat, and utility controls"
})

MovementSection:AddSlider("SpeedSlider", {
    Title = "Walkspeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(val)
        walkSpeedValue = val
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeedValue
        end
        lib:Notification("Speed", "Set to " .. walkSpeedValue, 2)
    end
})

MovementSection:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Default = false,
    Description = "Pass through walls and objects",
    Callback = function(state)
        noclipOn = state;
        lib:Notification("Noclip", noclipOn and "ON" or "OFF", 2.5)
    end
})

MovementSection:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Default = false,
    Description = "Jump without limits",
    Callback = function(state)
        infiniteJumpOn = state;
        lib:Notification("Infinite Jump", infiniteJumpOn and "ON" or "OFF", 2.5)
    end
})

MovementSection:AddToggle("AirWalkToggle", {
    Title = "Airwalk",
    Default = false,
    Description = "Walk on an invisible platform in the air",
    Callback = function(state)
        if state then
            enableAirWalk()
        else
            disableAirWalk()
        end
        lib:Notification("Airwalk", state and "ON" or "OFF", 2.5)
    end
})

MovementSection:AddToggle("FreezeCharToggle", {
    Title = "Freeze Character",
    Default = false,
    Description = "Lock your character's position",
    Callback = function(state)
        freezeCharacter(state);
        lib:Notification("Freeze", state and "Frozen" or "Unfrozen", 2.5)
    end
})

MovementSection:AddParagraph({
    Title = "How to use Teleport?",
    Description = "Click the button below to open the location list, then minimize this menu to select."
})

MovementSection:AddButton({
    Title = "Open Teleport Menu",
    Color = Color3.fromRGB(80, 200, 255),
    Callback = function()
        local destinations = getTeleportDestinations()
        createTeleportDialog(destinations)
    end
})

-- Static Teleports
local staticTeleports = {{
    Title = "TP Lost Isle: Treasure Ruins",
    Color = Color3.fromRGB(255, 215, 0),
    Path = {"Islands", "Lost Isle", "Treasure Ruins"}
}, {
    Title = "TP Lost Isle: Fishing Rod Ruins",
    Color = Color3.fromRGB(80, 160, 255),
    Path = {"Islands", "Lost Isle", "Fishing Rod Ruins"}
}, {
    Title = "TP Lost Isle: Main Temple",
    Color = Color3.fromRGB(200, 170, 255),
    Path = {"Islands", "Lost Isle", "Main Temple"}
}}
for _, tele in ipairs(staticTeleports) do
    MovementSection:AddButton({
        Title = tele.Title,
        Color = tele.Color,
        Callback = function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local target = Workspace
            for i, v in ipairs(tele.Path) do
                target = target and target:FindFirstChild(v)
            end

            if root and target and target:IsA("Model") then
                root.CFrame = target:GetPivot() + Vector3.new(0, 5, 0)
                lib:Notification("Teleport", "Teleported to " .. tele.Path[#tele.Path] .. "!", 3)
            else
                lib:Notification("Teleport", "Target object not found!", 3)
            end
        end
    })
end

-- Boat Controls
MovementSection:AddSlider("BoatSlider", {
    Title = "Boat Type",
    Min = 1,
    Max = 14,
    Default = 1,
    Callback = function(val)
        boatType = math.floor(val);
        lib:Notification("Boat Type", "Selected: " .. boatType, 1)
    end
})
MovementSection:AddButton({
    Title = "Spawn Boat",
    Color = Color3.fromRGB(90, 200, 120),
    Callback = function()
        pcall(netFolder["RF/SpawnBoat"].InvokeServer, netFolder["RF/SpawnBoat"], boatType);
        lib:Notification("Boat", "Spawned: " .. boatType, 3)
    end
})
MovementSection:AddButton({
    Title = "Despawn Boat",
    Color = Color3.fromRGB(200, 90, 120),
    Callback = function()
        pcall(netFolder["RF/DespawnBoat"].InvokeServer, netFolder["RF/DespawnBoat"]);
        lib:Notification("Boat", "Despawned!", 3)
    end
})

-- ESP Section
local ESPSection = Main:AddSection({
    Title = "👁 ESP & Visuals",
    Description = "Visual tools to track players"
})
ESPSection:AddToggle("ESPToggle", {
    Title = "Player ESP",
    Default = true,
    Description = "Shows name & distance. Green for friends, white for others.",
    Callback = function(state)
        espOn = state;
        lib:Notification("ESP", espOn and "ON" or "OFF", 2.5)
    end
})

-- AFK Blackscreen Section
local FPSSection = Main:AddSection({
    Title = "🛑 AFK Blackscreen",
    Description = "Optimized black screen for AFK with a timer"
})
FPSSection:AddToggle("AFKBlackScreenToggle", {
    Title = "AFK Blackscreen",
    Default = false,
    Description = "Disables rendering for performance, shows only a black screen + timer.",
    Callback = function(state)
        blackScreenOn = state
        if blackScreenOn then
            enableBlackScreen()
        else
            disableBlackScreen()
        end
        lib:Notification("AFK Blackscreen", blackScreenOn and "ON (AFK Mode)" or "OFF", 2.5)
    end
})

-- Utility Tab
local UtilityTab = main:AddTab("Utility")
local UtilitySection = UtilityTab:AddSection({
    Title = "⚡ Quick Utilities",
    Description = "Fast actions & server tools"
})
UtilitySection:AddButton({
    Title = "Respawn Character",
    Color = Color3.fromRGB(255, 180, 50),
    Callback = function()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
})
UtilitySection:AddButton({
    Title = "Rejoin Server",
    Color = Color3.fromRGB(80, 180, 255),
    Callback = function()
        TeleportService:Teleport(game.PlaceId, player)
    end
})
UtilitySection:AddToggle("AntiAfkToggle", {
    Title = "Anti AFK",
    Default = false,
    Description = "Prevents being kicked for inactivity",
    Callback = function(state)
        antiAfkOn = state
        if antiAfkOn then
            afkConn = player.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        elseif afkConn then
            afkConn:Disconnect();
            afkConn = nil
        end
        lib:Notification("Anti AFK", antiAfkOn and "ON" or "OFF", 2.5)
    end
})

-- Event Tab
local EventTab = main:AddTab("Event")
local EventSection = EventTab:AddSection({
    Title = "🗓️ Events",
    Description = "Special remote calls & actions"
})

-- Weather Events
local weatherEvents = {{
    Title = "Purchase: Shark Hunt",
    Weather = "Shark Hunt",
    Color = Color3.fromRGB(60, 180, 255)
}, {
    Title = "Purchase: Cloudy",
    Weather = "Cloudy",
    Color = Color3.fromRGB(170, 170, 170)
}, {
    Title = "Purchase: Snow",
    Weather = "Snow",
    Color = Color3.fromRGB(210, 215, 255)
}, {
    Title = "Purchase: Wind",
    Weather = "Wind",
    Color = Color3.fromRGB(140, 180, 255)
}, {
    Title = "Purchase: Storm",
    Weather = "Storm",
    Color = Color3.fromRGB(130, 130, 180)
}}
for _, event in ipairs(weatherEvents) do
    EventSection:AddButton({
        Title = event.Title,
        Color = event.Color,
        Description = "Invoke RF/PurchaseWeatherEvent for " .. event.Weather,
        Callback = function()
            local remote = netFolder["RF/PurchaseWeatherEvent"]
            local s, r = pcall(remote.InvokeServer, remote, event.Weather)
            lib:Notification("Event", s and "Purchased " .. event.Weather .. "!" or "Failed: " .. tostring(r), 3)
        end
    })
end

-- Replion Update
EventSection:AddDropdown("RodIndexDropdown", {
    Title = "Select Rod Index",
    Values = {"1", "2", "3"},
    Default = "1",
    Callback = function(v)
        rodIndex = tonumber(v)
    end
})
EventSection:AddDropdown("EnchantIdDropdown", {
    Title = "Select Enchant ID",
    Values = {"1", "2", "3"},
    Default = "1",
    Callback = function(v)
        enchantId = tonumber(v)
    end
})
EventSection:AddButton({
    Title = "Send Replion Update",
    Color = Color3.fromRGB(255, 100, 100),
    Description = "Firesignal to Replion Update",
    Callback = function()
        firesignal(Update.OnClientEvent, "\8", {"Inventory", "Fishing Rods", rodIndex, "Metadata"}, {
            EnchantId = enchantId
        })
        lib:Notification("Replion Update", "Data sent (Rod=" .. rodIndex .. ", Enchant=" .. enchantId .. ")", 3)
    end
})

-- Config Tab
local Config = main:AddTab("Config")
FlagsManager:SetLibrary(lib)
FlagsManager:SetIgnoreIndexes({})
FlagsManager:SetFolder("Config/FishIt")
FlagsManager:InitSaveSystem(Config)

-- =================================================================
-- SECTION: Core Loops & Connections
-- =================================================================

-- Noclip Loop
RunService.Stepped:Connect(function()
    if noclipOn and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Infinite Jump Connection
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpOn and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ESP and Oxygen Loop
RunService.RenderStepped:Connect(function()
    -- ESP Logic
    if espOn then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local tag = hrp:FindFirstChild("ESPTag") or Instance.new("BillboardGui", hrp)
                tag.Name = "ESPTag"
                tag.Size = UDim2.new(0, 130, 0, 30)
                tag.Adornee = hrp
                tag.AlwaysOnTop = true
                tag.MaxDistance = 10000

                local lbl = tag:FindFirstChild("Info") or Instance.new("TextLabel", tag)
                lbl.Name = "Info"
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 12
                lbl.TextStrokeTransparency = 0.5

                local dist = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                lbl.TextColor3 = player:IsFriendsWith(p.UserId) and Color3.fromRGB(0, 255, 0) or Color3.new(1, 1, 1)
                lbl.Text = p.Name .. " | " .. dist .. "m"
            end
        end
    else -- Cleanup ESP tags
        for _, m in ipairs(Workspace:GetDescendants()) do
            if m.Name == "ESPTag" and m:IsA("BillboardGui") then
                m:Destroy()
            end
        end
    end

    -- Infinity Oxygen Logic
    if infOxygenOn and player.Character and player.Character:FindFirstChild("Oxygen") then
        player.Character.Oxygen.Value = player.Character.Oxygen.MaxValue or 100
    end
end)

lib:Notification('Fi-Shit UI Revamped', 'Loaded successfully!', 3)
