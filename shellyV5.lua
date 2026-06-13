-- [[ Shelly's 6ft Under Hub v2.4 ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "🐢 Shelly's 6ft Under Hub v2.4",
    LoadingTitle = "Initializing...",
    ConfigurationSaving = {Enabled = true, FolderName = "ShellysHubConfig", FileName = "ShellyHub_v24"}
})

-- Tabs Declaration
local MainTab     = Window:CreateTab("🛠️ Main", nil)
local ShellyTab   = Window:CreateTab("🐢 Shelly", nil)
local VisualsTab  = Window:CreateTab("👁️ Visuals", nil)

------------------------------------------------------------------------
-- [ MAIN TAB: Credits ]
------------------------------------------------------------------------
MainTab:CreateSection("Credits")
MainTab:CreateParagraph({Title = "👑 Created By:", Content = "Shellaes Dw"})
MainTab:CreateParagraph({Title = "✨ Honorable Mentions:", Content = "Riddance & Noxious"})
MainTab:CreateParagraph({Title = "🤝 Relational Mentions:", Content = "NOVA & IDK"})

------------------------------------------------------------------------
-- [ SHELLY TAB: Precision Auto Skill Check ]
------------------------------------------------------------------------
ShellyTab:CreateSection("Automation")
_G.AutoSkill = false

ShellyTab:CreateToggle({
    Name = "Auto Skill Check (Precision)",
    Callback = function(Value)
        _G.AutoSkill = Value
        task.spawn(function()
            while _G.AutoSkill do
                local gui = LocalPlayer.PlayerGui:FindFirstChild("MinigameGui", true)
                if gui and gui.Enabled then
                    local indicator = gui:FindFirstChild("Indicator", true)
                    local goldenZone = gui:FindFirstChild("SuccessZone", true)
                    
                    if indicator and goldenZone then
                        local indPos = indicator.AbsolutePosition.X
                        local zoneStart = goldenZone.AbsolutePosition.X
                        local zoneEnd = zoneStart + goldenZone.AbsoluteSize.X
                        local centerPoint = zoneStart + (goldenZone.AbsoluteSize.X / 2)
                        
                        if indPos >= zoneStart and indPos <= zoneEnd then
                            if math.abs(indPos - centerPoint) < (goldenZone.AbsoluteSize.X / 4) then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
                                task.wait(0.5) 
                            end
                        end
                    end
                end
                task.wait(0.01)
            end
        end)
    end
})

------------------------------------------------------------------------
-- [ VISUALS TAB: Individual Fredoka ESPs ]
------------------------------------------------------------------------
local function createESP(target, labelText, color)
    if target:FindFirstChild("ESPHighlight") then return end
    local hl = Instance.new("Highlight", target)
    hl.Name = "ESPHighlight"
    hl.FillTransparency = 1
    hl.OutlineColor = color
    
    local bg = Instance.new("BillboardGui", target)
    bg.Name = "ESPLabel"
    bg.Size = UDim2.new(0, 100, 0, 50)
    bg.AlwaysOnTop = true
    bg.StudsOffset = Vector3.new(0, 3, 0)
    
    local label = Instance.new("TextLabel", bg)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = color
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 18
    label.BackgroundTransparency = 1
end

local function removeESP(parent)
    for _, obj in pairs(parent:GetDescendants()) do
        if obj.Name == "ESPHighlight" or obj.Name == "ESPLabel" then obj:Destroy() end
    end
end

VisualsTab:CreateSection("ESP - Outlines & Labels")

VisualsTab:CreateToggle({
    Name = "Twisted ESP",
    Callback = function(Value)
        _G.TwistedESP = Value
        if not Value then removeESP(workspace) end
        task.spawn(function()
            while _G.TwistedESP do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and string.find(obj.Name, "Twisted") then
                        createESP(obj, "Twisted", Color3.fromRGB(255, 0, 0))
                    end
                end
                task.wait(1)
            end
        end)
    end
})

VisualsTab:CreateToggle({
    Name = "Generator ESP",
    Callback = function(Value)
        _G.GenESP = Value
        if not Value then removeESP(workspace) end
        task.spawn(function()
            while _G.GenESP do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name == "Generator" then
                        createESP(obj, "Machine", Color3.fromRGB(0, 255, 255))
                    end
                end
                task.wait(1)
            end
        end)
    end
})

VisualsTab:CreateToggle({
    Name = "Item ESP",
    Callback = function(Value)
        _G.ItemESP = Value
        if not Value then removeESP(workspace) end
        task.spawn(function()
            while _G.ItemESP do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:GetAttribute("IsItem") then
                        createESP(obj, "Item", Color3.fromRGB(255, 255, 0))
                    end
                end
                task.wait(1)
            end
        end)
    end
})
