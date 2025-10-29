local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

-- Remote Event References
local Update = ReplicatedStorage.Packages._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Update
local netFolder = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net


-- ================================================================================= --
--                             KONFIGURASI DASAR                                     --
-- ================================================================================= --
-- 1. Memuat library WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()



-- 2. Membuat Window Utama
local Window = WindUI:CreateWindow({
    Title = "My Super Hub",
    Author = "by .ftgs and .ftgs",
    Size = UDim2.fromOffset(580, 460),
    BackgroundImageTransparency = 0.5 -- Contoh transparansi
})

-- 3. Mengkustomisasi Tombol Pembuka (Opsional)
Window:EditOpenButton({
    Title = "Buka Menu",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
    Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true
})

-- ================================================================================= --
--                             PEMBUATAN TAB & FITUR                                 --
-- ================================================================================= --

-- PENTING: Beri nama variabel yang berbeda untuk setiap tab
local InfoTab = Window:Tab({
    Title = "INFO",
    Icon = "info"
})

local PlayerTab = Window:Tab({
    Title = "PLAYER",
    Icon = "person-standing"
})

local AutoTab = Window:Tab({
    Title = "AUTO",
    Icon = "bot"
})

-- ================================================================================= --
--                             MENGISI KONTEN TAB INFO                               --
-- ================================================================================= --

