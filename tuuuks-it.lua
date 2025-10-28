local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Update = ReplicatedStorage.Packages._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Update -- RemoteEvent 

local lib = loadstring(game:HttpGet("https://cdn.x-zone.id/Library/Lib"))()
local FlagsManager = loadstring(game:HttpGet("https://cdn.x-zone.id/Library/ConfigManager"))()

local main = lib:Load({
    Title = "🎣 FI-SHIT | By Rav",
    ToggleButton = "rbxassetid://138498482261906",
    BindGui = Enum.KeyCode.RightControl,
})

-- main features tab
local Main = main:AddTab("Main")
main:SelectTab()

-- 1. INFORMASI UMUM (DIPERBARUI UNTUK KERAPIHAN)
local InfoSection = Main:AddSection({
    Title = "📌 INFORMASI FI-SHIT | RAV GUI",
    Description = "Versi terbaru dan panduan dasar.",
    Default = true,
    Locked = false
})

InfoSection:AddParagraph({
    Title = "• Status Versi",
    Description = "⚡ Versi Aktif: 1.0.0 "
})

InfoSection:AddParagraph({
    Title = "• Tombol Panggil Menu",
    Description = "Tekan [CTRL KANAN] untuk membuka/menutup GUI. (Tombol Minimize/Floating Window dikontrol oleh Library UI)"
})

-- 2. CHANGELOG/PEMBARUAN (DIPISAHKAN)
local ChangelogSection = Main:AddSection({
    Title = "🔔 Pembaruan (Changelog)",
    Description = "Daftar fitur terbaru dan perbaikan:",
    Default = false, -- Dibuat false agar menu terlihat rapi saat awal
    Locked = false
})

ChangelogSection:AddParagraph({
    Title = "⚡ WHATS NEW?",
    Description = "- adjust / increase speed auto fish 2x\n- pengoptimalan auto fish\n- fix auto stop fish\n- fix air walk bug\n- add character freeze ( combo air walk )\n- add teleport to new fishing rod \n- add teleport to main temple \n- add teleport to treasure ruins \n- add buy event trigger ( ini bukan exploit cuma alat bantu beli event cuaca, jadi tetap pakai coin )\n- add afk blackscreen rendering\n- coming soon!"
})

-- auto features section
local AutoSection = Main:AddSection({
    Title = "🔥 auto features",
    Description = "automated actions for efficiency",
    Default = false,
    Locked = false
})

-- movement & utilities section
local MovementSection = Main:AddSection({
    Title = "🏃💨 movement & utilities",
    Description = "player, boat, and utility controls",
    Default = false,
    Locked = false
})

-- esp section
local ESPSection = Main:AddSection({
    Title = "👁 esp & visuals",
    Description = "visual tools to track players",
    Default = false,
    Locked = false
})

-- utility tab
local UtilityTab = main:AddTab("Utility")
local UtilitySection = UtilityTab:AddSection({
    Title = "⚡ quick utilities",
    Description = "fast actions & server tools"
})

-- event tab
local EventTab = main:AddTab("Event")
local EventSection = EventTab:AddSection({
    Title = "🗓️ events",
    Description = "special remote calls & actions",
    Default = false,
    Locked = false
})

-- blackscreen afk section
local FPSSection = Main:AddSection({
    Title = "🛑 afk blackscreen",
    Description = "blackscreen rendering untuk afk dengan timer",
    Default = false,
    Locked = false
})

-- variabel global
local blackScreenOn = false
local afkBlackScreenOn = false
local startTime = 0
local timerConn

-- gui afk blackscreen
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local afkBlackScreenGui = Instance.new("ScreenGui")
afkBlackScreenGui.Name = "AFKBlackScreen"
afkBlackScreenGui.ResetOnSpawn = false
afkBlackScreenGui.IgnoreGuiInset = true
afkBlackScreenGui.Enabled = false
afkBlackScreenGui.Parent = player:WaitForChild("PlayerGui")

local blackFrame = Instance.new("Frame")
blackFrame.Name = "BlackFrame"
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.Position = UDim2.new(0, 0, 0, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BorderSizePixel = 0
blackFrame.Parent = afkBlackScreenGui

local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "TimerLabel"
timerLabel.BackgroundTransparency = 1
timerLabel.Size = UDim2.new(0, 260, 0, 56)
timerLabel.Position = UDim2.new(0.5, -130, 0.5, -28)
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 32
timerLabel.Text = "AFK: 00:00"
timerLabel.Parent = blackFrame

local timerCorner = Instance.new("UICorner")
timerCorner.CornerRadius = UDim.new(0, 16)
timerCorner.Parent = timerLabel

local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local oldCameraType = camera.CameraType
local oldCameraSubject = camera.CameraSubject

local function toTimeString(seconds)
    local mins = math.floor(seconds/60)
    local secs = math.floor(seconds%60)
    return string.format("%02d:%02d", mins, secs)
end

local function enableBlackScreen()
    afkBlackScreenOn = true
    startTime = os.time()
    oldCameraType = camera.CameraType
    oldCameraSubject = camera.CameraSubject
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CameraSubject = nil
    camera.CFrame = CFrame.new(0, 0, 0)
    afkBlackScreenGui.Enabled = true
    timerLabel.Text = "AFK: 00:00"
    if timerConn then timerConn:Disconnect() end
    timerConn = game:GetService("RunService").RenderStepped:Connect(function()
        local elapsed = os.time() - startTime
        timerLabel.Text = "AFK: " .. toTimeString(elapsed)
    end)
end

local function disableBlackScreen()
    afkBlackScreenOn = false
    camera.CameraType = oldCameraType
    camera.CameraSubject = oldCameraSubject
    afkBlackScreenGui.Enabled = false
    if timerConn then timerConn:Disconnect() timerConn = nil end
end

FPSSection:AddToggle("AFKBlackScreenToggle", {
    Title = "afk blackscreen",
    Default = false,
    Description = "matikan rendering, cuma layar hitam + timer",
    Callback = function(state)
        blackScreenOn = state
        if blackScreenOn then
            enableBlackScreen()
            lib:Notification("afk blackscreen", "blackscreen on (afk mode)!", 2.5)
        else
            disableBlackScreen()
            lib:Notification("afk blackscreen", "blackscreen off!", 2.5)
        end
    end,
})

-- ======= sisa script dari kode awal (tetap utuh) =======
local autoFishOn, noclipOn, infiniteJumpOn, espOn, airWalkOn = false, false, false, false, false
local godModeOn, infOxygenOn = false, false

local rs = game:GetService("ReplicatedStorage")
local netFolder = rs.Packages._Index["sleitnick_net@0.2.0"].net
local remoteName = "URE/UpdateOxygen"

-- infinity oxygen
AutoSection:AddToggle("InfOxygenToggle", {
    Title = "infinity oxygen",
    Default = false,
    Description = "anti meninggal meskipun oxygen 0",
    Callback = function(state)
        infOxygenOn = state
        local remote = netFolder:FindFirstChild(remoteName)
        if infOxygenOn then
            if remote then remote:Destroy() end
        else
            if not netFolder:FindFirstChild(remoteName) then
                local newRemote = Instance.new("RemoteEvent")
                newRemote.Name = remoteName
                newRemote.Parent = netFolder
            end
        end
        lib:Notification("infinity oxygen", infOxygenOn and "on" or "off", 2.5)
    end,
})

game:GetService("RunService").RenderStepped:Connect(function()
    if infOxygenOn then
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Oxygen") then
            char.Oxygen.Value = char.Oxygen.MaxValue or 100
        end
    end
end)

-- sell all items
AutoSection:AddButton({
    Title = "sell all",
    Color = Color3.fromRGB(255,140,80),
    Callback = function()
        local remote = netFolder:FindFirstChild("RF/SellAllItems")
        if remote and remote:IsA("RemoteFunction") then
            local success, result = pcall(function()
                return remote:InvokeServer()
            end)
            if success then
                lib:Notification("sell all", "berhasil menjual semua item!", 2.5)
            else
                lib:Notification("sell all", "gagal: " .. tostring(result), 3)
            end
        else
            lib:Notification("sell all", "remote ga ketemu!", 2.5)
        end
    end,
})

-- auto fish
AutoSection:AddToggle("AutoFish", {
    Title = "auto fish",
    Default = false,
    Description = "auto fishing (start/stop)",
    Callback = function(state)
        autoFishOn = state
        local nf = game:GetService("ReplicatedStorage"):WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
        if autoFishOn then
            lib:Notification("auto fish", "started!", 2.5)
            nf["RE/EquipToolFromHotbar"]:FireServer(1)
            task.wait(0.1)
            task.spawn(function()
                while autoFishOn do
                    pcall(function()
                        nf["RF/ChargeFishingRod"]:InvokeServer(tick())
                        task.wait()
                        nf["RF/RequestFishingMinigameStarted"]:InvokeServer(-1,1)
                        nf["RF/RequestFishingMinigameStarted"]:InvokeServer(-1,1)
                        task.wait(0.001)
                        nf["RE/FishingCompleted"]:FireServer()
                        nf["RE/FishingCompleted"]:FireServer()
                    end)
                    task.wait(0.01)
                end
                pcall(function()
                    nf["RF/CancelFishingInputs"]:InvokeServer()
                    nf["RF/RequestFishingMinigameStarted"]:InvokeServer(-100.0,100.0)
                    nf["RF/RequestFishingMinigameStarted"]:InvokeServer(-100.0,100.0)
                    nf["RE/FishingCompleted"]:FireServer()
                    nf["RE/FishingCompleted"]:FireServer()
                    nf["RE/FishingStopped"]:FireServer()
                    nf["RE/FishingStopped"]:FireServer()
                    task.wait(0.01)
                    nf["RE/UnequipToolFromHotbar"]:FireServer()
                    nf["RE/UnequipToolFromHotbar"]:FireServer()
                end)
            end)
        else
            lib:Notification("auto fish", "stopped!", 2.5)
        end
    end,
})

-- walkspeed slider
local walkSpeedValue = 16
MovementSection:AddSlider("SpeedSlider", {
    Title = "walkspeed",
    Description = "ubah kecepatan",
    Min = 1,
    Max = 200,
    Default = 18,
    Callback = function(val)
        walkSpeedValue = val
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = walkSpeedValue end
        lib:Notification("speed", "set to "..walkSpeedValue, 2)
    end,
})

-- noclip toggle
MovementSection:AddToggle("NoclipToggle", {
    Title = "noclip",
    Default = false,
    Description = "nembus benda kaya dinding",
    Callback = function(state)
        noclipOn = state
        lib:Notification("noclip", noclipOn and "on" or "off", 2.5)
    end,
})

game:GetService("RunService").Stepped:Connect(function()
    if noclipOn then
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- infinite jump
MovementSection:AddToggle("InfJumpToggle", {
    Title = "inf jump",
    Default = false,
    Description = "lompat tanpa batas",
    Callback = function(state)
        infiniteJumpOn = state
        lib:Notification("inf jump", infiniteJumpOn and "on" or "off", 2.5)
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpOn and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- esp
ESPSection:AddToggle("ESPToggle", {
    Title = "esp",
    Default = true,
    Description = "nama & jarak, hijau kalau teman, putih kalau bukan",
    Callback = function(state)
        espOn = state
        lib:Notification("esp", espOn and "on" or "off", 2.5)
    end,
})

game:GetService("RunService").RenderStepped:Connect(function()
    if not espOn then
        for _, m in ipairs(workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") then
                local t = m.HumanoidRootPart:FindFirstChild("ESPTag")
                if t then t:Destroy() end
            end
        end
        return
    end
    for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            if not hrp:FindFirstChild("ESPTag") then
                local tag = Instance.new("BillboardGui", hrp)
                tag.Name = "ESPTag"
                tag.Size = UDim2.new(0,130,0,30)
                tag.Adornee = hrp
                tag.AlwaysOnTop = true
                tag.MaxDistance = 10000
                local lbl = Instance.new("TextLabel", tag)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 12
                lbl.TextStrokeTransparency = 0.5
                lbl.Name = "Info"
            end
            local dist = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
            local lbl = hrp.ESPTag.Info
            lbl.TextColor3 = player:IsFriendsWith(v.UserId) and Color3.fromRGB(0,255,0) or Color3.new(1,1,1)
            lbl.Text = v.Name.." | "..dist.."m"
        end
    end
end)

-- airwalk & freeze
local airwalkPlatform, airwalkConn
local freezeConn
local freezePosition

local function createAirPlatform()
    if airwalkPlatform then return end
    airwalkPlatform = Instance.new("Part")
    airwalkPlatform.Name = "RavAirPlatform"
    airwalkPlatform.Size = Vector3.new(6,0.5,6)
    airwalkPlatform.Anchored = true
    airwalkPlatform.CanCollide = true
    airwalkPlatform.Transparency = 0.7
    airwalkPlatform.Color = Color3.fromRGB(80,200,255)
    airwalkPlatform.Parent = workspace
end

local function enableAirWalk()
    createAirPlatform()
    airwalkConn = game:GetService("RunService").RenderStepped:Connect(function()
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                airwalkPlatform.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.2, root.Position.Z)
            end
        end
    end)
end

local function disableAirWalk()
    if airwalkConn then airwalkConn:Disconnect() airwalkConn = nil end
    if airwalkPlatform then airwalkPlatform:Destroy() airwalkPlatform = nil end
end

local function freezeCharacter(state)
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if state then
            if root then
                freezePosition = root.CFrame
                freezeConn = game:GetService("RunService").RenderStepped:Connect(function()
                    root.CFrame = freezePosition
                end)
            end
            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end
        else
            if freezeConn then freezeConn:Disconnect() freezeConn = nil end
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
    end
end

MovementSection:AddToggle("AirWalkToggle", {
    Title = "airwalk",
    Default = false,
    Description = "jalan di udara",
    Callback = function(state)
        if state then enableAirWalk() else disableAirWalk() end
        lib:Notification("airwalk", state and "on" or "off", 2.5)
    end,
})

MovementSection:AddToggle("FreezeCharToggle", {
    Title = "freeze character",
    Default = false,
    Description = "kunci posisi karakter",
    Callback = function(state)
        freezeCharacter(state)
        lib:Notification("freeze", state and "frozen" or "unfrozen", 2.5)
    end,
})

-- tutorial teleport
MovementSection:AddParagraph({
    Title = "cara pakai teleport ?",
    Description = "click 1x tombol teleport terus minimize menu"
})

MovementSection:AddButton({
    Title = "teleport",
    Color = Color3.fromRGB(80,200,255),
    Callback = function()
        local teleList = {}
        local isl = workspace:FindFirstChild("!!!! ISLAND LOCATIONS !!!!")
        if isl then
            for _, c in ipairs(isl:GetChildren()) do
                local p = c:IsA("BasePart") and c or c:FindFirstChildWhichIsA("BasePart")
                if p then table.insert(teleList, {label="[🏝 pulau] "..c.Name, pos=p.Position}) end
            end
        end
        local altar = workspace:FindFirstChild("! ENCHANTING ALTAR !")
        if altar and altar:FindFirstChild("EnchantLocation") then
            table.insert(teleList, {label="[🏛️ altar enchant]", pos=altar.EnchantLocation.Position})
        end
        local nf = rs:FindFirstChild("NPC")
        if nf then
            for _, n in ipairs(nf:GetChildren()) do
                local p = n.PrimaryPart or n:FindFirstChild("HumanoidRootPart")
                if p then table.insert(teleList, {label="[🧙‍♂️ npc] "..n.Name, pos=p.Position}) end
            end
        end
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(teleList, {label="[👤 player] "..v.Name, pos=v.Character.HumanoidRootPart.Position})
            end
        end
        local props = workspace:FindFirstChild("Props")
        if props then
            for _, m in ipairs(props:GetChildren()) do
                if m:IsA("Model") then
                    local p = m:FindFirstChildWhichIsA("BasePart")
                    if p then table.insert(teleList, {label="[🗺️ event] "..m.Name, pos=p.Position}) end
                end
            end
        end
        if #teleList == 0 then
            lib:Notification("teleport", "ga ada target!", 2.5)
            return
        end
        local dialogGui = Instance.new("ScreenGui")
        dialogGui.Name = "TeleportDialog"
        dialogGui.ResetOnSpawn = false
        dialogGui.Parent = player:WaitForChild("PlayerGui")
        local frame = Instance.new("Frame", dialogGui)
        frame.Size = UDim2.new(0, 270, 0, 340)
        frame.Position = UDim2.new(0.5, -135, 0.5, -170)
        frame.BackgroundColor3 = Color3.fromRGB(40,40,60)
        frame.BorderSizePixel = 0
        frame.Active = true
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0,16)
        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1,0,0,36)
        title.Position = UDim2.new(0,0,0,0)
        title.BackgroundTransparency = 1
        title.Text = "pilih lokasi teleport"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 17
        title.TextColor3 = Color3.new(1,1,1)
        local closeBtn = Instance.new("TextButton", frame)
        closeBtn.Size = UDim2.new(0,32,0,32)
        closeBtn.Position = UDim2.new(1,-38,0,2)
        closeBtn.Text = "✖"
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 18
        closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
        closeBtn.TextColor3 = Color3.new(1,1,1)
        local closeCorner = Instance.new("UICorner", closeBtn)
        closeCorner.CornerRadius = UDim.new(0,8)
        closeBtn.MouseButton1Click:Connect(function()
            dialogGui:Destroy()
        end)
        local scroll = Instance.new("ScrollingFrame", frame)
        scroll.Size = UDim2.new(1,-16,1,-48)
        scroll.Position = UDim2.new(0,8,0,40)
        scroll.BackgroundColor3 = Color3.fromRGB(50,55,70)
        scroll.BorderSizePixel = 0
        scroll.ClipsDescendants = true
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.ScrollBarThickness = 8
        local scrollCorner2 = Instance.new("UICorner", scroll)
        scrollCorner2.CornerRadius = UDim.new(0,8)
        local layout = Instance.new("UIListLayout", scroll)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0,6)
        for _, item in ipairs(teleList) do
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1,0,0,32)
            btn.Text = item.label
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.BackgroundColor3 = Color3.fromRGB(65,140,210)
            btn.TextColor3 = Color3.new(1,1,1)
            local btnC = Instance.new("UICorner", btn)
            btnC.CornerRadius = UDim.new(0,8)
            btn.MouseButton1Click:Connect(function()
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = CFrame.new(item.pos + Vector3.new(0,3,0))
                    lib:Notification("teleport", "teleported to: "..item.label, 2.5)
                end
                dialogGui:Destroy()
            end)
        end
        task.defer(function()
            scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+12)
        end)
    end,
})

-- berbagai teleport statis
MovementSection:AddButton({
    Title = "teleport lost isle: treasure ruins",
    Color = Color3.fromRGB(255, 215, 0),
    Description = "teleport ke lost isle - treasure ruins",
    Callback = function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local objFolder = workspace.Islands:FindFirstChild("Lost Isle")
        local treasureModel = objFolder and objFolder:FindFirstChild("Treasure Ruins")
        if root and treasureModel and treasureModel:IsA("Model") then
            root.CFrame = treasureModel:GetPivot() + Vector3.new(0,3,0)
            lib:Notification("teleport", "teleported to treasure ruins!", 3)
        else
            lib:Notification("teleport", "object ga valid!", 3)
        end
    end
})

MovementSection:AddButton({
    Title = "teleport lost isle: fishing rod ruins",
    Color = Color3.fromRGB(80, 160, 255),
    Description = "teleport ke lost isle - fishing rod ruins",
    Callback = function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local objFolder = workspace.Islands:FindFirstChild("Lost Isle")
        local fishingRodModel = objFolder and objFolder:FindFirstChild("Fishing Rod Ruins")
        if root and fishingRodModel and fishingRodModel:IsA("Model") then
            root.CFrame = fishingRodModel:GetPivot() + Vector3.new(0,3,0)
            lib:Notification("teleport", "teleported to fishing rod ruins!", 3)
        else
            lib:Notification("teleport", "object ga valid!", 3)
        end
    end
})

MovementSection:AddButton({
    Title = "teleport lost isle: main temple",
    Color = Color3.fromRGB(200, 170, 255),
    Description = "teleport ke lost isle - main temple",
    Callback = function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local objFolder = workspace.Islands:FindFirstChild("Lost Isle")
        local mainTempleModel = objFolder and objFolder:FindFirstChild("Main Temple")
        if root and mainTempleModel and mainTempleModel:IsA("Model") then
            root.CFrame = mainTempleModel:GetPivot() + Vector3.new(0,3,0)
            lib:Notification("teleport", "teleported to main temple!", 3)
        else
            lib:Notification("teleport", "object ga valid!", 3)
        end
    end
})

-- spawn & despawn boat
local boatType = 1
MovementSection:AddSlider("BoatSlider", {
    Title = "boat type",
    Description = "pilih tipe boat (1-14)",
    Min = 1,
    Max = 14,
    Default = 1,
    Callback = function(val)
        boatType = math.floor(val)
        lib:Notification("boat type", "selected: "..boatType, 1)
    end,
})

MovementSection:AddButton({
    Title = "spawn boat",
    Color = Color3.fromRGB(90,200,120),
    Callback = function()
        pcall(function() netFolder["RF/SpawnBoat"]:InvokeServer(boatType) end)
        lib:Notification("boat", "spawned: "..boatType, 3)
    end,
})

MovementSection:AddButton({
    Title = "despawn boat",
    Color = Color3.fromRGB(200,90,120),
    Callback = function()
        pcall(function() netFolder["RF/DespawnBoat"]:InvokeServer() end)
        lib:Notification("boat", "despawned!", 3)
    end,
})

-- purchase weather events
local weatherEvents = {
    {Title = "purchase weather: shark hunt", Weather = "Shark Hunt", Color = Color3.fromRGB(60,180,255)},
    {Title = "purchase weather: cloudy", Weather = "Cloudy", Color = Color3.fromRGB(170,170,170)},
    {Title = "purchase weather: snow", Weather = "Snow", Color = Color3.fromRGB(210,215,255)},
    {Title = "purchase weather: wind", Weather = "Wind", Color = Color3.fromRGB(140,180,255)},
    {Title = "purchase weather: storm", Weather = "Storm", Color = Color3.fromRGB(130,130,180)},
}

for _, event in ipairs(weatherEvents) do
    EventSection:AddButton({
        Title = event.Title,
        Color = event.Color,
        Description = "invoke rf/purchaseweatherevent "..event.Weather,
        Callback = function()
            local success, result = pcall(function()
                return rs.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]:InvokeServer(event.Weather)
            end)
            if success then
                lib:Notification("event", event.Weather.." di beli!", 5)
            else
                lib:Notification("event", "gagal: "..tostring(result), 1)
            end
        end
    })
end

-- tambahan untuk firesignal update replion
local rodIndex = 1
local enchantId = 1
EventSection:AddDropdown("RodIndexDropdown", {
    Title = "pilih rod index",
    Values = "1","2","3",
    Default = "1",
    Callback = function(val)
        rodIndex = tonumber(val)
    end,
})

EventSection:AddDropdown("EnchantIdDropdown", {
    Title = "pilih enchant id",
    Values = "1","2","3",
    Default = "1",
    Callback = function(val)
        enchantId = tonumber(val)
    end,
})

EventSection:AddButton({
    Title = "send replion update",
    Color = Color3.fromRGB(255,100,100),
    Description = "firesignal ke replion update",
    Callback = function()
        firesignal(Update.OnClientEvent,
            "\8",
            {"Inventory","Fishing Rods", rodIndex, "Metadata"},
            {EnchantId = enchantId}
        )
        lib:Notification("replion update", "data dikirim (rod="..rodIndex..", enchant="..enchantId..")", 3)
    end,
})

-- quick utilities
UtilitySection:AddButton({
    Title = "respawn",
    Color = Color3.fromRGB(255,180,50),
    Callback = function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end,
})

UtilitySection:AddButton({
    Title = "rejoin public",
    Color = Color3.fromRGB(80,180,255),
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end,
})

UtilitySection:AddButton({
    Title = "rejoin private",
    Color = Color3.fromRGB(255,80,120),
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end,
})

-- anti afk
local afkConn
local antiAfkOn = false
UtilitySection:AddToggle("AntiAfkToggle", {
    Title = "anti afk",
    Default = false,
    Description = "mencegah kick saat idle",
    Callback = function(state)
        antiAfkOn = state
        if antiAfkOn then
            afkConn = player.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            lib:Notification("anti afk", "on", 2.5)
        else
            if afkConn then afkConn:Disconnect() afkConn = nil end
            lib:Notification("anti afk", "off", 2.5)
        end
    end,
})

lib:Notification('fi-shit', 'ravgui - beta test ui', 2)

local Config = main:AddTab("Config")
FlagsManager:SetLibrary(lib)
FlagsManager:SetIgnoreIndexes({})
FlagsManager:SetFolder("Config/FishIt")
FlagsManager:InitSaveSystem(Config)