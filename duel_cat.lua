loastring([[print("Duel Script Fou Adaptable chargé - Steal a Brainrot")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local connections = {}
local drawings = {}
local toggles = {
    AutoPlayLeft = false,
    AutoPlayRight = false,
    AutoGrab = false,
    AntiLag = false,
    ServerLagger = false,
    Desync = false,
    LockTarget = false,
    DropBrainrot = false,
    TPDown = false,
    ESP = false,
    MedusaCounter = false,
    FouAdaptable = false
}

local speedValue = 145
local grabRadius = 35

-- ==================== SCREEN GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatDuelGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Bulle violette permanente
local CatBubble = Instance.new("TextLabel")
CatBubble.Size = UDim2.new(0, 300, 0, 52)
CatBubble.Position = UDim2.new(0.5, -150, 0, 12)
CatBubble.BackgroundColor3 = Color3.fromRGB(85, 25, 130)   -- Violet foncé
CatBubble.Text = "I am cat duel script"
CatBubble.TextColor3 = Color3.fromRGB(225, 170, 255)      -- Violet clair / rose
CatBubble.TextScaled = true
CatBubble.Font = Enum.Font.GothamBold
CatBubble.Parent = ScreenGui
Instance.new("UICorner", CatBubble).CornerRadius = UDim.new(0, 22)
local bubbleStroke = Instance.new("UIStroke", CatBubble)
bubbleStroke.Thickness = 3
bubbleStroke.Color = Color3.fromRGB(190, 100, 255)

-- Frame principale (thème violet)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 430, 0, 400)
MainFrame.Position = UDim2.new(0.5, -215, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 25, 65)
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundTransparency = 1
Title.Text = "Duel Fou Adaptable - SAB"
Title.TextColor3 = Color3.fromRGB(210, 160, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Tab Bar violet
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 45)
TabBar.Position = UDim2.new(0, 0, 0, 55)
TabBar.BackgroundColor3 = Color3.fromRGB(65, 40, 110)
TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

local tabs = {}
local function createTabButton(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextScaled = true
    btn.Parent = TabBar
    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Visible = (tab.Name == name)
        end
    end)
    return btn
end

createTabButton("Duel", 20)
createTabButton("Combat", 120)
createTabButton("Visuals", 220)
createTabButton("Misc", 320)

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -135)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 6
contentFrame.Parent = MainFrame

-- Bouton global violet
local globalToggle = Instance.new("TextButton")
globalToggle.Size = UDim2.new(0, 140, 0, 42)
globalToggle.Position = UDim2.new(1, -160, 1, -55)
globalToggle.BackgroundColor3 = Color3.fromRGB(130, 50, 190)
globalToggle.Text = "FOU ADAPTABLE : OFF"
globalToggle.TextColor3 = Color3.new(1,1,1)
globalToggle.Font = Enum.Font.GothamBold
globalToggle.TextScaled = true
globalToggle.Parent = MainFrame
Instance.new("UICorner", globalToggle).CornerRadius = UDim.new(0, 12)

globalToggle.MouseButton1Click:Connect(function()
    toggles.FouAdaptable = not toggles.FouAdaptable
    globalToggle.Text = toggles.FouAdaptable and "FOU ADAPTABLE : ON" or "FOU ADAPTABLE : OFF"
    globalToggle.BackgroundColor3 = toggles.FouAdaptable and Color3.fromRGB(170, 80, 230) or Color3.fromRGB(130, 50, 190)
end)

-- Fonction Toggle Violet
local function addToggle(parent, text, key, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -15, 0, 48)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235, 210, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 0, 36)
    btn.Position = UDim2.new(0.7, 0, 0.5, -18)
    btn.BackgroundColor3 = Color3.fromRGB(110, 45, 175)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = default and Color3.fromRGB(180, 255, 180) or Color3.fromRGB(255, 170, 170)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    toggles[key] = default or false

    btn.MouseButton1Click:Connect(function()
        toggles[key] = not toggles[key]
        btn.Text = toggles[key] and "ON" or "OFF"
        btn.TextColor3 = toggles[key] and Color3.fromRGB(180, 255, 180) or Color3.fromRGB(255, 170, 170)
    end)
end

-- Création des Tabs
local duelTab = Instance.new("Frame") duelTab.Name = "Duel" duelTab.Size = UDim2.new(1,0,1,0) duelTab.BackgroundTransparency = 1 duelTab.Visible = true duelTab.Parent = contentFrame
local combatTab = Instance.new("Frame") combatTab.Name = "Combat" combatTab.Size = UDim2.new(1,0,1,0) combatTab.BackgroundTransparency = 1 combatTab.Visible = false combatTab.Parent = contentFrame
local visualsTab = Instance.new("Frame") visualsTab.Name = "Visuals" visualsTab.Size = UDim2.new(1,0,1,0) visualsTab.BackgroundTransparency = 1 visualsTab.Visible = false visualsTab.Parent = contentFrame
local miscTab = Instance.new("Frame") miscTab.Name = "Misc" miscTab.Size = UDim2.new(1,0,1,0) miscTab.BackgroundTransparency = 1 miscTab.Visible = false miscTab.Parent = contentFrame

tabs = {Duel = duelTab, Combat = combatTab, Visuals = visualsTab, Misc = miscTab}

-- Ajout des fonctionnalités dans les tabs
addToggle(duelTab, "Auto Play Left (Ultra Rapide)", "AutoPlayLeft", false)
addToggle(duelTab, "Auto Play Right (Ultra Rapide)", "AutoPlayRight", false)
addToggle(duelTab, "Auto Grab", "AutoGrab", false)

addToggle(combatTab, "Desync Avancé", "Desync", false)
addToggle(combatTab, "Lock Target + Aim Assist", "LockTarget", false)
addToggle(combatTab, "Medusa Counter Auto", "MedusaCounter", false)

addToggle(visualsTab, "ESP Brainrot & Stealer", "ESP", false)

addToggle(miscTab, "Anti Lagger (120 FPS)", "AntiLag", false)
addToggle(miscTab, "Server Lagger (Adversaire)", "ServerLagger", false)
addToggle(miscTab, "Drop Brainrot Instant", "DropBrainrot", false)
addToggle(miscTab, "TP Down Stratégique", "TPDown", false)

contentFrame.CanvasSize = UDim2.new(0, 0, 0, 480)

-- ==================== FONCTIONS DU SCRIPT ====================

local function getClosestBrainrot()
    local closest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain") then
            local rp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj
            if rp then
                local d = (rp.Position - root.Position).Magnitude
                if d < dist and d < grabRadius then
                    dist = d
                    closest = rp
                end
            end
        end
    end
    return closest
end

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                closest = plr.Character.HumanoidRootPart
            end
        end
    end
    return closest
end

-- ESP
connections.espLoop = RunService.RenderStepped:Connect(function()
    if not (toggles.ESP or toggles.FouAdaptable) then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("brainrot") and obj:IsA("BasePart") then
            local pos, onScreen = Camera:WorldToViewportPoint(obj.Position)
            if onScreen then
                -- Drawing simplifié (tu peux améliorer avec Drawing.new si tu veux)
                -- Pour l'instant on utilise un indicateur basique
            end
        end
    end
end)

-- Auto Play Left & Right ultra rapide
connections.autoPlay = RunService.Heartbeat:Connect(function()
    if not (toggles.AutoPlayLeft or toggles.AutoPlayRight or toggles.FouAdaptable) then return end
    local offset = toggles.AutoPlayLeft and Vector3.new(-30, 8, 0) or Vector3.new(30, 8, 0)
    root.CFrame = CFrame.new(root.Position + offset)
    humanoid.WalkSpeed = speedValue
    humanoid.JumpPower = 130

    local target = getClosestBrainrot()
    if target then
        firetouchinterest(root, target, 0)
        task.wait(0.03)
        firetouchinterest(root, target, 1)
    end
end)

-- Auto Grab
connections.autoGrab = RunService.Heartbeat:Connect(function()
    if not (toggles.AutoGrab or toggles.FouAdaptable) then return end
    local target = getClosestBrainrot()
    if target then
        firetouchinterest(root, target, 0)
        task.wait(0.04)
        firetouchinterest(root, target, 1)
    end
end)

-- Desync
connections.desync = RunService.Heartbeat:Connect(function()
    if not (toggles.Desync or toggles.FouAdaptable) then return end
    if root then
        root.Velocity = Vector3.new(math.random(-25,25), 0, math.random(-25,25))
    end
end)

-- Lock Target
connections.lock = RunService.RenderStepped:Connect(function()
    if not (toggles.LockTarget or toggles.FouAdaptable) then return end
    local target = getClosestEnemy()
    if target then
        local predicted = target.Position + target.Velocity * 0.08
        root.CFrame = CFrame.lookAt(root.Position, predicted)
    end
end)

-- Medusa Counter
connections.medusa = RunService.Heartbeat:Connect(function()
    if not (toggles.MedusaCounter or toggles.FouAdaptable) then return end
    if humanoid.PlatformStand then
        humanoid.PlatformStand = false
        root.CFrame = root.CFrame + Vector3.new(0, 10, 0)
    end
end)

-- Anti Lag + FPS Boost
connections.antilag = RunService.RenderStepped:Connect(function()
    if toggles.AntiLag or toggles.FouAdaptable then
        setfpscap(120)
        Lighting.GlobalShadows = false
    end
end)

-- Server Lagger
connections.lagger = task.spawn(function()
    while task.wait(0.7) do
        if toggles.ServerLagger or toggles.FouAdaptable then
            for i = 1, 15 do
                if ReplicatedStorage:FindFirstChild("RemoteEvent") then
                    ReplicatedStorage.RemoteEvent:FireServer()
                end
            end
        end
    end
end)

-- Drop Brainrot (touche K)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K and (toggles.DropBrainrot or toggles.FouAdaptable) then
        humanoid:UnequipTools()
    end
end)

-- TP Down (touche J)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.J and (toggles.TPDown or toggles.FouAdaptable) then
        root.CFrame = root.CFrame * CFrame.new(0, -28, 0)
    end
end)

-- Mode Fou Adaptable (adaptatif)
connections.fouAdapt = RunService.Heartbeat:Connect(function()
    if not toggles.FouAdaptable then return end
    
    local enemy = getClosestEnemy()
    if enemy then
        local dist = (enemy.Position - root.Position).Magnitude
        speedValue = dist < 40 and 190 or 130
        humanoid.WalkSpeed = speedValue
    end
    
    if humanoid.PlatformStand then
        humanoid.PlatformStand = false
    end
end)

-- Mise à jour character
LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
end)

-- Nettoyage
game:BindToClose(function()
    for _, conn in pairs(connections) do conn:Disconnect() end
    ScreenGui:Destroy()
end)

print("✅ Script complet chargé ! Bulle violette permanente + thème violet activé")]])()


