-- ============================================================
-- PART 1: KONFIGURASI LENGKAP
-- ============================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

-- Konfigurasi Utama
local Config = {
    -- Aim
    AimLock = false,
    AimSmoothness = 0.25,
    AimFOV = 150,
    AimTeamCheck = true,
    AimTargetPart = "Head",
    AimPrediction = false,
    AimPredictionAmount = 0.2,
    SilentAim = false,
    TriggerBot = false,
    TriggerBotDelay = 0.1,
    
    -- ESP
    ESP = false,
    ESPBox = false,
    ESPBoxColor = Color3.fromRGB(0, 150, 255),
    ESPBoxThickness = 1,
    ESPName = false,
    ESPNameColor = Color3.fromRGB(255, 255, 255),
    ESPLine = false,
    ESPLineColor = Color3.fromRGB(0, 150, 255),
    ESPHealth = false,
    ESPHealthColor = Color3.fromRGB(255, 0, 0),
    ESPTeamColor = false,
    ESPDistance = false,
    
    -- Visual
    FOVCircle = false,
    FOVRadius = 150,
    FOVColor = Color3.fromRGB(0, 150, 255),
    Chams = false,
    ChamsColor = Color3.fromRGB(0, 150, 255),
    
    -- Misc
    Target = nil,
    ESPObjects = {},
    Keybinds = {
        AimLock = Enum.KeyCode.LeftAlt,
        ESP = Enum.KeyCode.F,
        TriggerBot = Enum.KeyCode.T,
    }
}
print("PART 1 LOADED ✅")
-- ============================================================
-- PART 2: FUNGSI UTILITY
-- ============================================================
local function GetClosestPlayer()
    local closest, distance = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToScreenPoint(root.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).magnitude
                if dist < distance and dist < Config.FOVRadius then
                    closest, distance = plr, dist
                end
            end
        end
    end
    return closest
end

local function GetPlayersInFOV()
    local players = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToScreenPoint(root.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).magnitude
                if dist < Config.FOVRadius then
                    table.insert(players, {player = plr, distance = dist})
                end
            end
        end
    end
    table.sort(players, function(a, b) return a.distance < b.distance end)
    return players
end

local function IsTeamMate(plr)
    if not Config.AimTeamCheck then return false end
    return plr.Team == LocalPlayer.Team
end

local function GetPlayerColor(plr)
    if Config.ESPTeamColor and IsTeamMate(plr) then
        return Color3.fromRGB(0, 255, 0) -- Hijau untuk teammate
    else
        return Color3.fromRGB(255, 0, 0) -- Merah untuk musuh
    end
end

local function GetPart(plr, partName)
    if not plr or not plr.Character then return nil end
    return plr.Character:FindFirstChild(partName) or plr.Character:FindFirstChild("HumanoidRootPart")
end

print("PART 2 LOADED ✅")
-- ============================================================
-- PART 3: AIM LOCK, SILENT AIM, TRIGGER BOT
-- ============================================================
local FOVCircleObject = nil

local function CreateFOVCircle()
    if FOVCircleObject then FOVCircleObject:Destroy() end
    if not Config.FOVCircle then return end
    local circle = Drawing.new("Circle")
    circle.Thickness = 1
    circle.NumSides = 32
    circle.Radius = Config.FOVRadius
    circle.Filled = false
    circle.Color = Config.FOVColor
    circle.Transparency = 0.5
    circle.Visible = true
    circle.ZIndex = 0
    circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircleObject = circle
end

local function UpdateFOVCircle()
    if FOVCircleObject then
        FOVCircleObject.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        FOVCircleObject.Radius = Config.FOVRadius
    end
end

local function AimLock()
    while Config.AimLock do
        local target = GetClosestPlayer()
        if target and target.Character then
            local root = GetPart(target, Config.AimTargetPart)
            if root then
                local targetPos = root.Position
                if Config.AimPrediction then
                    local velocity = target.Character.HumanoidRootPart.Velocity
                    targetPos = targetPos + velocity * Config.AimPredictionAmount
                end
                local lookAt = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(lookAt, Config.AimSmoothness)
            end
        end
        wait(0.01)
    end
end

local function SilentAim()
    while Config.SilentAim do
        local target = GetClosestPlayer()
        if target and target.Character then
            local root = GetPart(target, Config.AimTargetPart)
            if root then
                local targetPos = root.Position
                local lookAt = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                Camera.CFrame = lookAt
            end
        end
        wait(0.01)
    end
end

local function TriggerBot()
    while Config.TriggerBot do
        local target = GetClosestPlayer()
        if target and target.Character then
            local root = GetPart(target, Config.AimTargetPart)
            if root then
                local pos, onScreen = Camera:WorldToScreenPoint(root.Position)
                if onScreen then
                    -- Simulate shoot (sesuaikan dengan game)
                    -- Contoh: game:GetService("ReplicatedStorage").Shoot:FireServer()
                end
            end
        end
        wait(Config.TriggerBotDelay)
    end
end

local function ToggleAim()
    Config.AimLock = not Config.AimLock
    if Config.AimLock then task.spawn(AimLock) end
    print("Aim Lock:", Config.AimLock and "ON" or "OFF")
end

local function ToggleSilentAim()
    Config.SilentAim = not Config.SilentAim
    if Config.SilentAim then task.spawn(SilentAim) end
    print("Silent Aim:", Config.SilentAim and "ON" or "OFF")
end

local function ToggleTriggerBot()
    Config.TriggerBot = not Config.TriggerBot
    if Config.TriggerBot then task.spawn(TriggerBot) end
    print("Trigger Bot:", Config.TriggerBot and "ON" or "OFF")
end

print("PART 3 LOADED ✅")
-- ============================================================
-- PART 4: ESP (BOX, NAME, LINE, HEALTH, DISTANCE)
-- ============================================================
local function CreateESP(plr)
    if not plr.Character then return end
    local root = plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local espData = {}
    local color = GetPlayerColor(plr)
    
    -- Box ESP
    if Config.ESPBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(3, 5, 1)
        box.Adornee = root
        box.Color3 = Config.ESPBoxColor
        box.AlwaysOnTop = true
        box.ZIndex = 0
        box.Visible = true
        box.Parent = root
        espData.box = box
    end
    
    -- Name ESP
    if Config.ESPName then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 100, 0, 20)
        billboard.Adornee = root
        billboard.Parent = root
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = plr.Name
        label.TextColor3 = Config.ESPNameColor
        label.TextScaled = true
        label.Parent = billboard
        espData.name = billboard
    end
    
    -- Line ESP
    if Config.ESPLine then
        local line = Instance.new("LineHandleAdornment")
        line.Length = 50
        line.Thickness = 1
        line.Color3 = Config.ESPLineColor
        line.Adornee = root
        line.AlwaysOnTop = true
        line.Parent = root
        espData.line = line
    end
    
    -- Health ESP (Bar)
    if Config.ESPHealth then
        local healthGui = Instance.new("BillboardGui")
        healthGui.Size = UDim2.new(0, 50, 0, 5)
        healthGui.Adornee = root
        healthGui.Parent = root
        
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Config.ESPHealthColor
        healthBar.BackgroundTransparency = 0.5
        healthBar.Parent = healthGui
        espData.health = healthBar
    end
    
    -- Distance ESP
    if Config.ESPDistance then
        local distBillboard = Instance.new("BillboardGui")
        distBillboard.Size = UDim2.new(0, 50, 0, 15)
        distBillboard.Adornee = root
        distBillboard.Position = UDim2.new(0, 0, 0, 25)
        distBillboard.Parent = root
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 1, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        distLabel.TextScaled = true
        distLabel.Parent = distBillboard
        espData.distance = distBillboard
    end
    
    espData.plr = plr
    table.insert(Config.ESPObjects, espData)
end

local function UpdateESP()
    while Config.ESP do
        for i, esp in pairs(Config.ESPObjects) do
            if not esp.plr or not esp.plr.Character then
                if esp.box then esp.box:Destroy() end
                if esp.name then esp.name:Destroy() end
                if esp.line then esp.line:Destroy() end
                if esp.health then esp.health:Destroy() end
                if esp.distance then esp.distance:Destroy() end
                table.remove(Config.ESPObjects, i)
            else
                -- Update distance
                if esp.distance then
                    local dist = (Camera.CFrame.Position - esp.plr.Character.HumanoidRootPart.Position).magnitude
                    esp.distance.Text = math.floor(dist) .. "m"
                end
                -- Update health
                if esp.health then
                    local humanoid = esp.plr.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.health.Size = UDim2.new(healthPercent, 0, 1, 0)
                    end
                end
            end
        end
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local exists = false
                for _, esp in pairs(Config.ESPObjects) do
                    if esp.plr == plr then exists = true; break end
                end
                if not exists then
                    CreateESP(plr)
                end
            end
        end
        wait(0.1)
    end
end

local function ToggleESP()
    Config.ESP = not Config.ESP
    if Config.ESP then
        task.spawn(UpdateESP)
        print("ESP ON")
    else
        for _, esp in pairs(Config.ESPObjects) do
            if esp.box then esp.box:Destroy() end
            if esp.name then esp.name:Destroy() end
            if esp.line then esp.line:Destroy() end
            if esp.health then esp.health:Destroy() end
            if esp.distance then esp.distance:Destroy() end
        end
        Config.ESPObjects = {}
        print("ESP OFF")
    end
end

print("PART 4 LOADED ✅")
-- ============================================================
-- PART 5: GUI PREMIUM & VISUAL EFFECTS
-- ============================================================
local function CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PremiumFPS"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "⚡ PREMIUM FPS ⚡"
    title.TextColor3 = Color3.fromRGB(0, 150, 255)
    title.BackgroundTransparency = 1
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 40)
    subtitle.Text = "by Kangho — FPS Click"
    subtitle.TextColor3 = Color3.fromRGB(100, 200, 255)
    subtitle.BackgroundTransparency = 1
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    local function createButton(text, yPos, callback, color)
        color = color or Color3.fromRGB(0, 100, 200)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.8, 0, 0, 35)
        btn.Position = UDim2.new(0.1, 0, 0, yPos)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        btn.Parent = mainFrame
        btn.MouseButton1Click:Connect(callback)
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end)
        return btn
    end
    
    createButton("🎯 Aim Lock (Toggle)", 80, ToggleAim)
    createButton("🤫 Silent Aim (Toggle)", 125, ToggleSilentAim)
    createButton("🔫 Trigger Bot (Toggle)", 170, ToggleTriggerBot)
    createButton("👁️ ESP (Toggle)", 215, ToggleESP)
    createButton("📦 ESP Box (Toggle)", 260, function()
        Config.ESPBox = not Config.ESPBox
        if Config.ESPBox then ToggleESP() ToggleESP() end
    end)
    createButton("🏷️ ESP Name (Toggle)", 305, function()
        Config.ESPName = not Config.ESPName
        if Config.ESPName then ToggleESP() ToggleESP() end
    end)
    createButton("📏 ESP Line (Toggle)", 350, function()
        Config.ESPLine = not Config.ESPLine
        if Config.ESPLine then ToggleESP() ToggleESP() end
    end)
    createButton("❤️ ESP Health (Toggle)", 395, function()
        Config.ESPHealth = not Config.ESPHealth
        if Config.ESPHealth then ToggleESP() ToggleESP() end
    end)
    createButton("⭕ FOV Circle (Toggle)", 440, function()
        Config.FOVCircle = not Config.FOVCircle
        if Config.FOVCircle then CreateFOVCircle()
        elseif FOVCircleObject then FOVCircleObject:Destroy(); FOVCircleObject = nil end
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    closeBtn.BackgroundTransparency = 0.5
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
    
    RunService.RenderStepped:Connect(function()
        if FOVCircleObject then UpdateFOVCircle() end
    end)
end

print("PART 5 LOADED ✅")
-- ============================================================
-- PART 6: KEYBINDS & CHAMS
-- ============================================================
local function Chams()
    while Config.Chams do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.Neon
                        part.Color = Config.ChamsColor
                    end
                end
            end
        end
        wait(0.5)
    end
end

local function ToggleChams()
    Config.Chams = not Config.Chams
    if Config.Chams then task.spawn(Chams) end
    print("Chams:", Config.Chams and "ON" or "OFF")
end

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.Keybinds.AimLock then
        ToggleAim()
    elseif input.KeyCode == Config.Keybinds.ESP then
        ToggleESP()
    elseif input.KeyCode == Config.Keybinds.TriggerBot then
        ToggleTriggerBot()
    end
end)

print("PART 6 LOADED ✅")
-- ============================================================
-- PART 7: START & LOADER
-- ============================================================
-- Jalankan GUI
task.spawn(CreateGUI)

-- Inisialisasi FOV
if Config.FOVCircle then task.spawn(CreateFOVCircle) end

print("⚡ PREMIUM FPS SCRIPT LOADED ⚡")
print("📌 Gunakan GUI untuk mengaktifkan fitur.")
print("📌 Keybinds: LeftAlt = Aim, F = ESP, T = Trigger Bot")
print("📌 Total Fitur: Aim Lock, Silent Aim, Trigger Bot, ESP (Box/Name/Line/Health/Distance), FOV, Chams")

-- Auto-start ESP
-- Config.ESP = true
-- task.spawn(UpdateESP)

print("PART 7 LOADED ✅ — SCRIPT SIAP DIGUNAKAN!")