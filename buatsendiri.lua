-- ================================================================================= --
--                             SERVICES & UI SETUP                                   --
-- ================================================================================= --
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService") -- Ditambahkan

if not LocalPlayer then
    repeat
        task.wait()
    until Players.LocalPlayer
end

-- Memuat library WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ================================================================================= --
--                          REMOTE EVENT REFERENCES (SAFE)                           --
-- ================================================================================= --
-- Menambahkan kembali pencarian remote event yang aman untuk netFolder
local netFolder = nil
pcall(function()
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages then
        local index = packages:FindFirstChild("_Index")
        if index then
            local sleitnick = index:FindFirstChild("sleitnick_net@0.2.0")
            if sleitnick then
                netFolder = sleitnick:FindFirstChild("net")
            end
        end
    end
end)

-- Variabel kontrol
local autofishInstan = false
local perfectCast = false -- Dipertahankan untuk penggunaan di masa depan (jika diperlukan)

-- ================================================================================= --
--                             MEMBUAT JENDELA UTAMA                                 --
-- ================================================================================= --

-- 1. Membuat Window Utama
local Window = WindUI:CreateWindow({
    Title = "Auto Fish",
    Author = "by G",
    Size = UDim2.fromOffset(580, 460),
    BackgroundImageTransparency = 0.5
})

-- 2. Mengkustomisasi Tombol Pembuka
Window:EditOpenButton({
    Title = "Buka",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true
})

-- ================================================================================= --
--                             KONTEN TAB AUTO FISH                                  --
-- ================================================================================= --

-- 1. Membuat Tab Fishing
local FishingTab = Window:Tab({
    Title = "Fishing",
    Icon = "fish"
})

-- Hanya buat logika jika netFolder ditemukan
if netFolder then
    -- Referensi remote events spesifik untuk logika ini
    local equipRemote = netFolder:FindFirstChild("RE/EquipToolFromHotbar")
    local chargeRodRemote = netFolder:FindFirstChild("RF/ChargeFishingRod")
    local requestMinigameRemote = netFolder:FindFirstChild("RF/RequestFishingMinigameStarted")
    local fishingCompletedRemote = netFolder:FindFirstChild("RE/FishingCompleted")
    local cancelFishingInputsRemote = netFolder:FindFirstChild("RF/CancelFishingInputs")
    local fishingStoppedRemote = netFolder:FindFirstChild("RE/FishingStopped")
    local unequipRemote = netFolder:FindFirstChild("RE/UnequipToolFromHotbar")

    -- 1. Toggle: Auto Fishing Instan (Menggunakan Logika yang Diberikan)
    FishingTab:Toggle({
        Title = "🎣 Auto Fishing Instan",
        Description = "Menggunakan exploit timing dasar untuk Instan Fishing.",
        Value = false,
        Callback = function(state)
            autofishInstan = state -- Mengganti autoFishOn
            if autofishInstan then
                WindUI:Notify({
                    Title = "Auto Fish",
                    Content = "Started!",
                    Duration = 2.5
                })

                -- Memastikan remote events ada sebelum mencoba FireServer
                if not (equipRemote and chargeRodRemote and requestMinigameRemote and fishingCompletedRemote) then
                    WindUI:Notify({
                        Title = "ERROR",
                        Content = "Remote Events tidak lengkap. Fitur dimatikan.",
                        Duration = 5
                    })
                    autofishInstan = false
                    return
                end

                equipRemote:FireServer(1)
                task.spawn(function()
                    while autofishInstan do
                        pcall(function()
                            chargeRodRemote:InvokeServer(tick())
                            task.wait()
                            requestMinigameRemote:InvokeServer(-1, 1)
                            task.wait(0.001)
                            fishingCompletedRemote:FireServer()
                        end)
                        task.wait(0.01)
                    end
                    -- Logika cleanup saat dimatikan
                    pcall(function()
                        if cancelFishingInputsRemote then
                            cancelFishingInputsRemote:InvokeServer()
                        end
                        if fishingStoppedRemote then
                            fishingStoppedRemote:FireServer()
                        end
                        task.wait(0.01)
                        if unequipRemote then
                            unequipRemote:FireServer()
                        end
                    end)
                end)
            else
                WindUI:Notify({
                    Title = "Auto Fish",
                    Content = "Stopped!",
                    Duration = 2.5
                })
            end
        end
    })

    -- 2. Toggle: Autofish Clicker (Tombol placeholder)
    FishingTab:Toggle({
        Title = "🖱️ Autofish Clicker",
        Description = "Menggantikan klik manual untuk mempercepat aksi.",
        Value = false,
        Callback = function(val)
            WindUI:Notify({
                Title = "Clicker",
                Content = "Status diubah menjadi: " .. tostring(val),
                Duration = 2
            })
        end
    })

    -- 3. Toggle: Perfect Cast (Tombol baru)
    FishingTab:Toggle({
        Title = "✨ Perfect Cast",
        Description = "Menggunakan koordinat pasti untuk lemparan sempurna (hanya berguna untuk logika sebelumnya).",
        Value = false,
        Callback = function(val)
            -- Variabel perfectCast tetap bisa diatur jika nanti diperlukan untuk variasi logika Instan
            -- Anda bisa mendeklarasikan local perfectCast = val di awal skrip jika ingin menggunakannya
            WindUI:Notify({
                Title = "Perfect Cast",
                Content = "Status diubah menjadi: " .. tostring(val),
                Duration = 2
            })
        end
    })

else
    -- Pesan jika fitur tidak bisa dimuat
    FishingTab:Button({
        Title = "Fitur Auto Fish Gagal Dimuat",
        Description = "Folder 'net' untuk remote events tidak ditemukan di game ini."
    })
end

-- ================================================================================= --
--                                     FINALISASI                                    --
-- ================================================================================= --

print("UI Auto Fish Final (Minimal) Loaded Successfully!")
WindUI:Notify({
    Title = "Autofish By G",
    Content = "UI Auto Fish berhasil dimuat!",
    Duration = 4
})
