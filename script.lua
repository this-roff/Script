-- ================== SCRIPT DEWA UNTUK BROOKHAVEN ==================
-- Fitur: Kill Aura, Freeze All, Fly All, Spin All, Invisible All, Teleport All, Fake 18+, Loop Sound, Auto Crash, God Mode, Infinite Jump, Speed Hack, Noclip, dan Server Crash.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ================== KONFIGURASI ==================
local Config = {
    GodMode = false,
    InfiniteJump = false,
    SpeedHack = false,
    Noclip = false,
    KillAura = false,
    FreezeAll = false,
    FlyAll = false,
    SpinAll = false,
    InvisibleAll = false,
    TeleportAll = false,
    Fake18Plus = false,
    LoopSound = false,
    AutoCrash = false,
    ServerCrash = false,
    TargetList = {},
    SpeedValue = 50,
    JumpValue = 100,
}

-- ================== FUNGSI UTAMA ==================

-- 1. GOD MODE (Tidak Bisa Mati)
local function GodMode()
    while Config.GodMode do
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 100
                humanoid.MaxHealth = 100
                humanoid.BreakJointsOnDeath = false
            end
        end
        wait(0.1)
    end
end

-- 2. INFINITE JUMP
local function InfiniteJump()
    while Config.InfiniteJump do
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = Config.JumpValue
            end
        end
        wait(0.1)
    end
end

-- 3. SPEED HACK
local function SpeedHack()
    while Config.SpeedHack do
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Config.SpeedValue
            end
        end
        wait(0.1)
    end
end

-- 4. NOCLIP (Tembus Dinding)
local function Noclip()
    while Config.Noclip do
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        wait(0.1)
    end
end

-- 5. KILL AURA (Auto Kill Semua Player)
local function KillAura()
    while Config.KillAura do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local humanoid = plr.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid.Health = 0
                end
            end
        end
        wait(0.3)
    end
end

-- 6. FREEZE ALL (Bekukan Semua Player)
local function FreezeAll()
    while Config.FreezeAll do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local humanoid = plr.Character:FindFirstChild("Humanoid")
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if humanoid then
                    humanoid.WalkSpeed = 0
                    humanoid.JumpPower = 0
                end
                if root then
                    root.Anchored = true
                end
            end
        end
        wait(0.5)
    end
end

-- 7. FLY ALL (Buat Semua Player Terbang)
local function FlyAll()
    while Config.FlyAll do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local humanoid = plr.Character:FindFirstChild("Humanoid")
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if humanoid and root then
                    humanoid.PlatformStand = true
                    root.Velocity = Vector3.new(0, 100, 0)
                end
            end
        end
        wait(0.5)
    end
end

-- 8. SPIN ALL (Buat Semua Player Berputar)
local function SpinAll()
    while Config.SpinAll do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local spin = TweenService:Create(root, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true), {CFrame = root.CFrame * CFrame.Angles(0, math.rad(360), 0)})
                    spin:Play()
                end
            end
        end
        wait(0.5)
    end
end

-- 9. INVISIBLE ALL (Buat Semua Player Tidak Terlihat)
local function InvisibleAll()
    while Config.InvisibleAll do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, v in pairs(plr.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Transparency = 1
                    end
                end
            end
        end
        wait(0.5)
    end
end

-- 10. TELEPORT ALL (Teleport Semua Player ke Random)
local function TeleportAll()
    while Config.TeleportAll do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local randomPos = Vector3.new(math.random(-500, 500), 50, math.random(-500, 500))
                    root.CFrame = CFrame.new(randomPos)
                end
            end
        end
        wait(1)
    end
end

-- 11. FAKE 18+ (Notifikasi Palsu untuk Semua Player)
local function Fake18PlusAll()
    while Config.Fake18Plus do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "⚠️ 18+ WARNING",
                    Text = "This player has been reported for inappropriate content.",
                    Duration = 10,
                })
                -- Efek layar merah
                local screenGui = Instance.new("ScreenGui")
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                frame.BackgroundTransparency = 0.5
                frame.Parent = screenGui
                screenGui.Parent = plr.PlayerGui
                wait(2)
                screenGui:Destroy()
            end
        end
        wait(3)
    end
end

-- 12. LOOP SOUND (Mainkan Suara Terus Menerus untuk Semua Player)
local function LoopSoundAll()
    while Config.LoopSound do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://5698696114"
                sound.Volume = 10
                sound.Parent = plr.Character:FindFirstChild("Head") or workspace
                sound:Play()
                wait(2)
                sound:Destroy()
            end
        end
    end
end

-- 13. AUTO CRASH (Buat Game Target Lag/Crash)
local function AutoCrashAll()
    while Config.AutoCrash do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for i = 1, 50 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(10, 10, 10)
                    part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
                    part.Anchored = true
                    part.Parent = workspace
                    wait(0.01)
                    part:Destroy()
                end
            end
        end
        wait(1)
    end
end

-- 14. SERVER CRASH (Membuat Server Lag Berat)
local function ServerCrash()
    while Config.ServerCrash do
        for i = 1, 1000 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(10, 10, 10)
            part.Position = Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
            part.Anchored = true
            part.Parent = workspace
            wait(0.001)
            part:Destroy()
        end
        wait(0.5)
    end
end

-- ================== GUI DENGAN INPUT USN ==================
local function CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TrollGUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 550)
    frame.Position = UDim2.new(0, 10, 0.5, -275)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.8
    frame.Visible = true
    frame.Parent = screenGui
    
    -- Judul
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "⚡ SCRIPT DEWA ⚡"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    -- Input Box untuk USN
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.9, 0, 0, 35)
    inputBox.Position = UDim2.new(0.05, 0, 0, 40)
    inputBox.PlaceholderText = "Masukkan Username Target (Opsional)"
    inputBox.Text = ""
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    inputBox.BackgroundTransparency = 0.5
    inputBox.Parent = frame
    
    -- Tombol Set Target
    local setBtn = Instance.new("TextButton")
    setBtn.Size = UDim2.new(0.9, 0, 0, 30)
    setBtn.Position = UDim2.new(0.05, 0, 0, 80)
    setBtn.Text = "🔍 SET TARGET"
    setBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    setBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    setBtn.BackgroundTransparency = 0.5
    setBtn.Parent = frame
    
    setBtn.MouseButton1Click:Connect(function()
        local name = inputBox.Text
        if name ~= "" then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Name:lower() == name:lower() or plr.DisplayName:lower() == name:lower() then
                    table.insert(Config.TargetList, plr)
                    print("✅ Target added: " .. plr.Name)
                    title.Text = "✅ TARGET: " .. plr.Name
                    wait(2)
                    title.Text = "⚡ SCRIPT DEWA ⚡"
                    return
                end
            end
            print("❌ Player not found!")
        end
    end)
    
    -- Tombol Aksi (dalam 2 kolom)
    local buttons = {
        "God Mode", "Infinite Jump", "Speed Hack", "Noclip", 
        "Kill Aura", "Freeze All", "Fly All", "Spin All", 
        "Invisible All", "Teleport All", "Fake 18+", "Loop Sound", 
        "Auto Crash", "Server Crash"
    }
    
    for i, btnText in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        local row = math.floor((i-1) / 2)
        local col = (i-1) % 2
        btn.Size = UDim2.new(0.43, 0, 0, 30)
        btn.Position = UDim2.new(0.05 + col * 0.5, 0, 0, 130 + row * 35)
        btn.Text = btnText
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.BackgroundTransparency = 0.5
        btn.Parent = frame
        
        btn.MouseButton1Click:Connect(function()
            if btnText == "God Mode" then
                Config.GodMode = not Config.GodMode
                if Config.GodMode then GodMode() end
            elseif btnText == "Infinite Jump" then
                Config.InfiniteJump = not Config.InfiniteJump
                if Config.InfiniteJump then InfiniteJump() end
            elseif btnText == "Speed Hack" then
                Config.SpeedHack = not Config.SpeedHack
                if Config.SpeedHack then SpeedHack() end
            elseif btnText == "Noclip" then
                Config.Noclip = not Config.Noclip
                if Config.Noclip then Noclip() end
            elseif btnText == "Kill Aura" then
                Config.KillAura = not Config.KillAura
                if Config.KillAura then KillAura() end
            elseif btnText == "Freeze All" then
                Config.FreezeAll = not Config.FreezeAll
                if Config.FreezeAll then FreezeAll() end
            elseif btnText == "Fly All" then
                Config.FlyAll = not Config.FlyAll
                if Config.FlyAll then FlyAll() end
            elseif btnText == "Spin All" then
                Config.SpinAll = not Config.SpinAll
                if Config.SpinAll then SpinAll() end
            elseif btnText == "Invisible All" then
                Config.InvisibleAll = not Config.InvisibleAll
                if Config.InvisibleAll then InvisibleAll() end
            elseif btnText == "Teleport All" then
                Config.TeleportAll = not Config.TeleportAll
                if Config.TeleportAll then TeleportAll() end
            elseif btnText == "Fake 18+" then
                Config.Fake18Plus = not Config.Fake18Plus
                if Config.Fake18Plus then Fake18PlusAll() end
            elseif btnText == "Loop Sound" then
                Config.LoopSound = not Config.LoopSound
                if Config.LoopSound then LoopSoundAll() end
            elseif btnText == "Auto Crash" then
                Config.AutoCrash = not Config.AutoCrash
                if Config.AutoCrash then AutoCrashAll() end
            elseif btnText == "Server Crash" then
                Config.ServerCrash = not Config.ServerCrash
                if Config.ServerCrash then ServerCrash() end
            end
        end)
    end
end

-- ================== START ==================
CreateGUI()
print("⚡ Script Dewa Loaded!")
print("📌 Masukkan username target (opsional) di GUI, lalu pilih fitur.")
print("📌 Fitur 'All' berlaku untuk semua player di server.")