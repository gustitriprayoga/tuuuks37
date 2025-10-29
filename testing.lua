-- ================================================================================= --
--                             SERVICES & UI SETUP                                   --
-- ================================================================================= --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

if not LocalPlayer then
    repeat
        task.wait()
    until Players.LocalPlayer
end

-- Memuat library WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ================================================================================= --
--                             VARIABEL KONTROL                                      --
-- ================================================================================= --
local autoClickerOn = false
local clickInterval = 0.01 -- Interval klik secepat mungkin (100 klik/detik)

-- ================================================================================= --
--                      FUNGSI SIMULASI INPUT KRITIS                                 --
-- ================================================================================= --

-- Fungsi yang mensimulasikan Mouse Down/Up di tengah layar
local function SendMouseClickAtCenter(isDown)
    local screenCenter = UserInputService:GetMouseLocation()

    -- Mencoba mendapatkan posisi tengah Viewport secara akurat
    if CurrentCamera then
        screenCenter = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
    end

    local x = screenCenter.X
    local y = screenCenter.Y

    -- Menggunakan fungsi executor umum (diasumsikan tersedia)
    pcall(function()
        if isDown then
            if mouse1press then
                mouse1press(x, y)
            end
        else
            if mouse1release then
                mouse1release(x, y)
            end
        end
    end)
end

-- ================================================================================= --
--                             MEMBUAT JENDELA UTAMA (WINDUI)                        --
-- ================================================================================= --

local Window = WindUI:CreateWindow({
    Title = "Aggressive Clicker",
    Author = "by G",
    Size = UDim2.fromOffset(580, 460),
    BackgroundImageTransparency = 0.5
})

Window:EditOpenButton({
    Title = "MENU",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true
})

-- ================================================================================= --
--                             KONTEN TAB UTAMA (CLICKER)                            --
-- ================================================================================= --

local MainTab = Window:Tab({
    Title = "Clicker",
    Icon = "mouse-pointer"
})

-- 1. Toggle: Auto Clicker (Logika Spam)
MainTab:Toggle({
    Title = "🖱️ Auto Clicker Instan",
    Description = "Mengklik di tengah layar secepat mungkin (0.01s interval).",
    Value = false,
    Callback = function(val)
        autoClickerOn = val

        if autoClickerOn then
            WindUI:Notify({
                Title = "Auto Clicker",
                Content = "Dimulai! Mengklik di tengah layar.",
                Duration = 2
            })

            task.spawn(function()
                while autoClickerOn do
                    -- Simulasi Mouse Down dan Mouse Up secepat mungkin
                    SendMouseClickAtCenter(true)
                    task.wait(0.01) -- Jeda minimal
                    SendMouseClickAtCenter(false)

                    task.wait(clickInterval) -- Jeda antara siklus klik
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Clicker",
                Content = "Dihentikan.",
                Duration = 2
            })
        end
    end
})

-- ================================================================================= --
--                                     FINALISASI                                    --
-- ================================================================================= --

print("Aggressive Auto Clicker Loaded Successfully!")
WindUI:Notify({
    Title = "Aggressive Clicker",
    Content = "UI minimal siap digunakan.",
    Duration = 4
})
