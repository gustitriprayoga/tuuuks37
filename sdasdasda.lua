-- =================================================================
-- SECTION: SERVICES, VARIABLES & LIBRARIES (TETAP SAMA)
-- =================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Remote Event References (TETAP SAMA)
local Update = ReplicatedStorage.Packages._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Update
local netFolder = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- =================================================================
-- SECTION: GLOBAL STATE & FEATURE FUNCTIONS (TETAP SAMA)
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
local blackScreenOn = false

-- Fungsi-fungsi inti dari skrip lama Anda dipertahankan sepenuhnya
local function enableAirWalk()
    -- ... (Semua kode fungsi enableAirWalk Anda ada di sini, tidak diubah)
    if airwalkPlatform then
        return
    end
    airwalkPlatform = Instance.new("Part", Workspace)
    airwalkPlatform.Name = "RavAirPlatform";
    airwalkPlatform.Size = Vector3.new(6, 0.5, 6)
    airwalkPlatform.Anchored = true;
    airwalkPlatform.CanCollide = true;
    airwalkPlatform.Transparency = 0.7
    airwalkPlatform.Color = Color3.fromRGB(80, 200, 255);
    airwalkPlatform.Material = Enum.Material.ForceField
    airwalkConn = RunService.RenderStepped:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            airwalkPlatform.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -3.2, 0)
        end
    end)
end

local function disableAirWalk()
    -- ... (Semua kode fungsi disableAirWalk Anda ada di sini, tidak diubah)
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
    -- ... (Semua kode fungsi freezeCharacter Anda ada di sini, tidak diubah)
    local char = player.Character;
    if not char then
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart");
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

local function getTeleportDestinations()
    -- ... (Semua kode fungsi getTeleportDestinations Anda ada di sini, tidak diubah)
    local teleList = {};
    local islandLocations = Workspace:FindFirstChild("!!!! ISLAND LOCATIONS !!!!");
    if islandLocations then
        for _, loc in ipairs(islandLocations:GetChildren()) do
            local part = loc:IsA("BasePart") and loc or loc:FindFirstChildWhichIsA("BasePart");
            if part then
                table.insert(teleList, {
                    label = "[🏝️ Island] " .. loc.Name,
                    pos = part.Position
                })
            end
        end
    end
    local altar = Workspace:FindFirstChild("! ENCHANTING ALTAR !");
    if altar and altar:FindFirstChild("EnchantLocation") then
        table.insert(teleList, {
            label = "[🏛️ Enchant Altar]",
            pos = altar.EnchantLocation.Position
        })
    end
    local npcFolder = ReplicatedStorage:FindFirstChild("NPC");
    if npcFolder then
        for _, npc in ipairs(npcFolder:GetChildren()) do
            local part = npc.PrimaryPart or npc:FindFirstChild("HumanoidRootPart");
            if part then
                table.insert(teleList, {
                    label = "[🧙‍♂️ NPC] " .. npc.Name,
                    pos = part.Position
                })
            end
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(teleList, {
                label = "[👤 Player] " .. p.Name,
                pos = p.Character.HumanoidRootPart.Position
            })
        end
    end
    local props = Workspace:FindFirstChild("Props");
    if props then
        for _, model in ipairs(props:GetChildren()) do
            if model:IsA("Model") then
                local part = model:FindFirstChildWhichIsA("BasePart");
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

-- Fungsi AFK Blackscreen (TETAP SAMA)
local afkBlackScreenGui, oldCameraType, oldCameraSubject, timerConn, startTime
-- ... (Semua logika black screen Anda ada di sini, tidak diubah)
afkBlackScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"));
afkBlackScreenGui.Name = "AFKBlackScreen";
afkBlackScreenGui.ResetOnSpawn = false;
afkBlackScreenGui.IgnoreGuiInset = true;
afkBlackScreenGui.Enabled = false;
local blackFrame = Instance.new("Frame", afkBlackScreenGui);
blackFrame.Name = "BlackFrame";
blackFrame.Size = UDim2.new(1, 0, 1, 0);
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0);
blackFrame.BorderSizePixel = 0;
local timerLabel = Instance.new("TextLabel", blackFrame);
timerLabel.Name = "TimerLabel";
timerLabel.BackgroundTransparency = 1;
timerLabel.Size = UDim2.new(0, 300, 0, 60);
timerLabel.Position = UDim2.new(0.5, -150, 0.5, -30);
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
timerLabel.Font = Enum.Font.GothamBold;
timerLabel.TextSize = 36;
timerLabel.Text = "AFK: 00:00:00";
timerLabel.TextStrokeTransparency = 0.5;
timerLabel.TextStrokeColor3 = Color3.fromRGB(50, 50, 50);
local camera = Workspace.CurrentCamera;
local function toTimeString(seconds)
    local hours = string.format("%02d", math.floor(seconds / 3600));
    local mins = string.format("%02d", math.floor(seconds / 60) % 60);
    local secs = string.format("%02d", seconds % 60);
    return hours .. ":" .. mins .. ":" .. secs
end
local function enableBlackScreen()
    startTime = os.time();
    oldCameraType, oldCameraSubject = camera.CameraType, camera.CameraSubject;
    camera.CameraType = Enum.CameraType.Scriptable;
    afkBlackScreenGui.Enabled = true;
    timerLabel.Text = "AFK: 00:00:00";
    if timerConn then
        timerConn:Disconnect()
    end
    timerConn = RunService.RenderStepped:Connect(function()
        timerLabel.Text = "AFK: " .. toTimeString(os.time() - startTime)
    end)
end
local function disableBlackScreen()
    camera.CameraType = oldCameraType;
    camera.CameraSubject = oldCameraSubject;
    afkBlackScreenGui.Enabled = false;
    if timerConn then
        timerConn:Disconnect();
        timerConn = nil
    end
end

-- =================================================================
-- SECTION: UI DENGAN RAYFIELD (BAGIAN YANG DIUBAH)
-- =================================================================

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "🎣 FI-SHIT | By G",
    LoadingTitle = "FI-SHIT Interface",
    LoadingSubtitle = "by 10sDev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItConfig",
        FileName = "MainSettings"
    },
    KeySystem = false
})

-- TAB: MAIN
local MainTab = Window:CreateTab("Main", 4483362458)

-- Section: Info
local InfoSection = MainTab:CreateSection("📢 Information - Fish It")
InfoSection:CreateParagraph({
    Title = "⚡ FI-SHIT UPDATE !",
    Content = "• Version : 1.0.0 "
})
InfoSection:CreateParagraph({
    Title = "🔔 What's New?",
    Content = "- adjust / increase speed auto fish 2x\n- pengoptimalan auto fish\n- fix auto stop fish\n- fix air walk bug\n- add character freeze ( combo air walk )\n- add teleport to new fishing rod \n- add teleport to main temple \n- add teleport to treasure ruins \n- add buy event trigger ( ini bukan exploit cuma alat bantu beli event cuaca, jadi tetap pakai coin )\n- add afk blackscreen rendering\n- coming soon!"
})

-- Section: Auto Features
local AutoSection = MainTab:CreateSection("🔥 Auto Features")
AutoSection:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = autoFishOn, -- Menggunakan state lama
    Flag = "AutoFishToggle",
    Callback = function(state)
        -- LOGIKA LAMA ANDA, TIDAK DIUBAH
        autoFishOn = state
        if autoFishOn then
            Window:Notify({
                Title = "Auto Fish",
                Content = "Started!",
                Duration = 2.5
            })
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
            Window:Notify({
                Title = "Auto Fish",
                Content = "Stopped!",
                Duration = 2.5
            })
        end
    end
})
AutoSection:CreateToggle({
    Name = "Infinity Oxygen",
    CurrentValue = infOxygenOn,
    Flag = "InfOxygenToggle",
    Callback = function(state)
        -- LOGIKA LAMA ANDA, TIDAK DIUBAH
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
        Window:Notify({
            Title = "Infinity Oxygen",
            Content = infOxygenOn and "ON" or "OFF",
            Duration = 2.5
        })
    end
})
AutoSection:CreateButton({
    Name = "Sell All Items",
    Callback = function()
        -- LOGIKA LAMA ANDA, TIDAK DIUBAH
        local remote = netFolder:FindFirstChild("RF/SellAllItems")
        if remote and remote:IsA("RemoteFunction") then
            local success, result = pcall(function()
                return remote:InvokeServer()
            end)
            Window:Notify({
                Title = "Sell All",
                Content = success and "Successfully sold all items!" or "Failed: " .. tostring(result),
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Sell All",
                Content = "Remote not found!",
                Duration = 2.5
            })
        end
    end
})

-- Section: Movement & Utilities
local MovementSection = MainTab:CreateSection("🏃💨 Movement & Utilities")
MovementSection:CreateSlider({
    Name = "Walkspeed",
    Range = {16, 200},
    CurrentValue = walkSpeedValue,
    Flag = "WalkSpeedSlider",
    Callback = function(val)
        -- LOGIKA LAMA ANDA, TIDAK DIUBAH
        walkSpeedValue = val
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeedValue
        end
    end
})
MovementSection:CreateToggle({
    Name = "Noclip",
    CurrentValue = noclipOn,
    Flag = "NoclipToggle",
    Callback = function(state)
        noclipOn = state;
        Window:Notify({
            Title = "Noclip",
            Content = noclipOn and "ON" or "OFF",
            Duration = 2.5
        })
    end
})
MovementSection:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = infiniteJumpOn,
    Flag = "InfJumpToggle",
    Callback = function(state)
        infiniteJumpOn = state;
        Window:Notify({
            Title = "Infinite Jump",
            Content = infiniteJumpOn and "ON" or "OFF",
            Duration = 2.5
        })
    end
})
MovementSection:CreateToggle({
    Name = "Airwalk",
    CurrentValue = airWalkOn,
    Flag = "AirWalkToggle",
    Callback = function(state)
        -- MEMANGGIL FUNGSI LAMA ANDA
        airWalkOn = state
        if state then
            enableAirWalk()
        else
            disableAirWalk()
        end
        Window:Notify({
            Title = "Airwalk",
            Content = state and "ON" or "OFF",
            Duration = 2.5
        })
    end
})
MovementSection:CreateToggle({
    Name = "Freeze Character",
    CurrentValue = false,
    Flag = "FreezeCharToggle",
    Callback = function(state)
        -- MEMANGGIL FUNGSI LAMA ANDA
        freezeCharacter(state);
        Window:Notify({
            Title = "Freeze",
            Content = state and "Frozen" or "Unfrozen",
            Duration = 2.5
        })
    end
})

-- Section: Boat Controls
local BoatSection = MainTab:CreateSection("🚤 Boat Controls")
BoatSection:CreateSlider({
    Name = "Boat Type",
    Range = {1, 14},
    CurrentValue = boatType,
    Increment = 1,
    Flag = "BoatTypeSlider",
    Callback = function(val)
        boatType = math.floor(val)
    end
})
BoatSection:CreateButton({
    Name = "Spawn Boat",
    Callback = function()
        -- LOGIKA LAMA ANDA, TIDAK DIUBAH
        pcall(netFolder["RF/SpawnBoat"].InvokeServer, netFolder["RF/SpawnBoat"], boatType);
        Window:Notify({
            Title = "Boat",
            Content = "Spawned: " .. boatType,
            Duration = 3
        })
    end
})
BoatSection:CreateButton({
    Name = "Despawn Boat",
    Callback = function()
        -- LOGIKA LAMA ANDA, TIDAK DIUBAH
        pcall(netFolder["RF/DespawnBoat"].InvokeServer, netFolder["RF/DespawnBoat"]);
        Window:Notify({
            Title = "Boat",
            Content = "Despawned!",
            Duration = 3
        })
    end
})

-- Section: ESP
local ESPSection = MainTab:CreateSection("👁 ESP & Visuals")
ESPSection:CreateToggle({
    Name = "Player ESP",
    CurrentValue = espOn,
    Flag = "ESPToggle",
    Callback = function(state)
        espOn = state;
        Window:Notify({
            Title = "ESP",
            Content = espOn and "ON" or "OFF",
            Duration = 2.5
        })
    end
})

-- Section: AFK Blackscreen
local AFKSection = MainTab:CreateSection("🛑 AFK Blackscreen")
AFKSection:CreateToggle({
    Name = "AFK Blackscreen",
    CurrentValue = blackScreenOn,
    Flag = "AFKBlackScreenToggle",
    Callback = function(state)
        -- MEMANGGIL FUNGSI LAMA ANDA
        blackScreenOn = state
        if blackScreenOn then
            enableBlackScreen()
        else
            disableBlackScreen()
        end
        Window:Notify({
            Title = "AFK Blackscreen",
            Content = blackScreenOn and "ON (AFK Mode)" or "OFF",
            Duration = 2.5
        })
    end
})

-- TAB: TELEPORT
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local teleportSection
local function populateTeleportTab()
    if teleportSection then
        teleportSection:Destroy()
    end -- Hapus section lama
    teleportSection = TeleportTab:CreateSection("📍 Locations")

    local destinations = getTeleportDestinations()
    if #destinations == 0 then
        teleportSection:CreateLabel("No teleport locations found.")
        return
    end

    for _, item in ipairs(destinations) do
        teleportSection:CreateButton({
            Name = item.label,
            Callback = function()
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = CFrame.new(item.pos + Vector3.new(0, 3, 0))
                    Window:Notify({
                        Title = "Teleport",
                        Content = "Teleported to: " .. item.label,
                        Duration = 2.5
                    })
                end
            end
        })
    end
end
TeleportTab:CreateButton({
    Name = "Refresh Locations",
    Callback = populateTeleportTab
})
populateTeleportTab() -- Muat pertama kali

-- TAB: UTILITY
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local UtilitySection = UtilityTab:CreateSection("⚡ Quick Utilities")
UtilitySection:CreateButton({
    Name = "Respawn Character",
    Callback = function()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
})
UtilitySection:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, player)
    end
})
UtilitySection:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = antiAfkOn,
    Flag = "AntiAfkToggle",
    Callback = function(state)
        -- LOGIKA LAMA ANDA, TIDAK DIUBAH
        antiAfkOn = state
        if antiAfkOn then
            afkConn = player.Idled:Connect(function()
                local vu = game:GetService("VirtualUser");
                vu:CaptureController();
                vu:ClickButton2(Vector2.new())
            end)
        elseif afkConn then
            afkConn:Disconnect();
            afkConn = nil
        end
        Window:Notify({
            Title = "Anti AFK",
            Content = antiAfkOn and "ON" or "OFF",
            Duration = 2.5
        })
    end
})

-- TAB: EVENT
local EventTab = Window:CreateTab("Event", 4483362458)
local EventSection = EventTab:CreateSection("🗓️ Events")
local weatherEvents = {"Shark Hunt", "Cloudy", "Snow", "Wind", "Storm"}
for _, eventName in ipairs(weatherEvents) do
    EventSection:CreateButton({
        Name = "Purchase: " .. eventName,
        Callback = function()
            -- LOGIKA LAMA ANDA, TIDAK DIUBAH
            local remote = netFolder["RF/PurchaseWeatherEvent"]
            local s, r = pcall(remote.InvokeServer, remote, eventName)
            Window:Notify({
                Title = "Event",
                Content = s and "Purchased " .. eventName .. "!" or "Failed: " .. tostring(r),
                Duration = 3
            })
        end
    })
end
local ReplionSection = EventTab:CreateSection("Replion Update")
ReplionSection:CreateDropdown({
    Name = "Select Rod Index",
    Options = {"1", "2", "3"},
    CurrentValue = tostring(rodIndex),
    Flag = "RodIndexDropdown",
    Callback = function(v)
        rodIndex = tonumber(v)
    end
})
ReplionSection:CreateDropdown({
    Name = "Select Enchant ID",
    Options = {"1", "2", "3"},
    CurrentValue = tostring(enchantId),
    Flag = "EnchantIdDropdown",
    Callback = function(v)
        enchantId = tonumber(v)
    end
})
ReplionSection:CreateButton({
    Name = "Send Replion Update",
    Callback = function()
        -- LOGIKA LAMA ANDA, TIDAK DIUBAH
        firesignal(Update.OnClientEvent, "\8", {"Inventory", "Fishing Rods", rodIndex, "Metadata"}, {
            EnchantId = enchantId
        })
        Window:Notify({
            Title = "Replion Update",
            Content = "Data sent (Rod=" .. rodIndex .. ", Enchant=" .. enchantId .. ")",
            Duration = 3
        })
    end
})

-- =================================================================
-- SECTION: CORE LOOPS & CONNECTIONS (TETAP SAMA)
-- =================================================================

-- Noclip, Infinite Jump, ESP, dan Oxygen loops dari skrip lama Anda dipertahankan sepenuhnya
RunService.Stepped:Connect(function()
    if noclipOn and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpOn and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
RunService.RenderStepped:Connect(function()
    if espOn then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart;
                local tag = hrp:FindFirstChild("ESPTag") or Instance.new("BillboardGui", hrp);
                tag.Name = "ESPTag";
                tag.Size = UDim2.new(0, 130, 0, 30);
                tag.Adornee = hrp;
                tag.AlwaysOnTop = true;
                tag.MaxDistance = 10000;
                local lbl = tag:FindFirstChild("Info") or Instance.new("TextLabel", tag);
                lbl.Name = "Info";
                lbl.Size = UDim2.new(1, 0, 1, 0);
                lbl.BackgroundTransparency = 1;
                lbl.Font = Enum.Font.GothamBold;
                lbl.TextSize = 12;
                lbl.TextStrokeTransparency = 0.5;
                local dist = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude);
                lbl.TextColor3 = player:IsFriendsWith(p.UserId) and Color3.fromRGB(0, 255, 0) or Color3.new(1, 1, 1);
                lbl.Text = p.Name .. " | " .. dist .. "m"
            end
        end
    else
        for _, m in ipairs(Workspace:GetDescendants()) do
            if m.Name == "ESPTag" and m:IsA("BillboardGui") then
                m:Destroy()
            end
        end
    end
    if infOxygenOn and player.Character and player.Character:FindFirstChild("Oxygen") then
        player.Character.Oxygen.Value = player.Character.Oxygen.MaxValue or 100
    end
end)

Window:Notify({
    Title = 'Fi-Shit UI Revamped',
    Content = 'Loaded successfully!',
    Duration = 3
})
