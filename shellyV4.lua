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

-- Tabs
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
-- [ SHELLY TAB: Auto Skill Check ]
------------------------------------------------------------------------
ShellyTab:CreateSection("Automation")
_G.AutoSkill = false

ShellyTab:CreateToggle({
    Name = "Auto Skill Check",
    Callback = function(Value)
        _G.AutoSkill = Value
        task.spawn(function()
            while _G.AutoSkill do
                -- REPLACE THESE NAMES WITH ACTUAL UI NAMES
                local gui = LocalPlayer.PlayerGui:FindFirstChild("MinigameGui")
                if gui and gui.Enabled then
                    local needle = gui:FindFirstChild("Indicator", true)
                    local target = gui:FindFirstChild("SuccessZone", true)
                    if needle and target then
                        local needleX = needle.AbsolutePosition.X
                        local targetX = target.AbsolutePosition.X
                        local targetSize = target.AbsoluteSize.X
                        
                        if needleX >= targetX and needleX <= (targetX + targetSize) then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
                            task.wait(0.2)
                        end
                    end
                end
                task.wait()
            end
        end)
    end
})

------------------------------------------------------------------------
-- [ VISUALS TAB: ESP (Outline + Text) ]
------------------------------------------------------------------------
VisualsTab:CreateSection("ESP - Outlines & Labels")
_G.ESPEnabled = false

local function applyESP(target, labelText, color)
    if not target:FindFirstChild("ESPHighlight") then
        local hl = Instance.new("Highlight", target)
        hl.Name = "ESPHighlight"
        hl.FillTransparency = 1
        hl.OutlineColor = color
    end
    if not target:FindFirstChild("ESPLabel") then
        local bg = Instance.new("BillboardGui", target)
        bg.Name = "ESPLabel"
        bg.Size = UDim2.new(0, 100, 0, 50)
        bg.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bg)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = labelText
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
    end
end

VisualsTab:CreateToggle({
    Name = "Enable All ESP",
    Callback = function(Value)
        _G.ESPEnabled = Value
        RunService.Heartbeat:Connect(function()
            if not _G.ESPEnabled then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                -- Update these names to match the game's actual object names
                if obj.Name == "Generator" then applyESP(obj, "Machine", Color3.new(0, 1, 1))
                elseif obj.Name == "Twisted" then applyESP(obj, "Twisted", Color3.new(1, 0, 0))
                elseif obj:GetAttribute("IsItem") then applyESP(obj, "Item", Color3.new(1, 1, 0))
                end
            end
        end)
    end
})
