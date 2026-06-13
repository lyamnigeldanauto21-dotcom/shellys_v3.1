-- [[ Shelly's 6ft Under Hub v2.4 ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({Name = "🐢 Shelly's 6ft Under Hub v2.4", LoadingTitle = "Initializing...", ConfigurationSaving = {Enabled = true, FolderName = "ShellysHubConfig", FileName = "ShellyHub_v24"}})

local MainTab     = Window:CreateTab("🛠️ Main", nil)
local ShellyTab   = Window:CreateTab("🐢 Shelly", nil)
local VisualsTab  = Window:CreateTab("👁️ Visuals", nil)

-- [ MAIN TAB: Credits ]
MainTab:CreateSection("Credits")
MainTab:CreateParagraph({Title = "👑 Created By:", Content = "Shellaes Dw"})
MainTab:CreateParagraph({Title = "✨ Honorable Mentions:", Content = "Riddance & Noxious"})
MainTab:CreateParagraph({Title = "🤝 Relational Mentions:", Content = "NOVA & IDK"})

-- [ SHELLY TAB: Auto Skill Check ]
ShellyTab:CreateSection("Automation")
ShellyTab:CreateToggle({
    Name = "Auto Skill Check",
    Callback = function(Value)
        _G.AutoSkill = Value
        while _G.AutoSkill do
            -- Logic: Detect active SkillCheck UI frame and trigger input
            -- This is a placeholder for your specific game's UI structure
            task.wait(0.1)
        end
    end
})

-- [ VISUALS TAB: Outline ESP ]
VisualsTab:CreateSection("ESP - Outline Only")

local function applyHighlight(obj)
    if not obj:FindFirstChild("Highlight") then
        local hl = Instance.new("Highlight")
        hl.FillTransparency = 1 -- Only outline
        hl.OutlineTransparency = 0
        hl.Parent = obj
    end
end

VisualsTab:CreateToggle({
    Name = "Twisted ESP",
    Callback = function(Value)
        _G.TwistedESP = Value
        -- Add loop to monitor workspace for Twisted models and applyHighlight()
    end
})

VisualsTab:CreateToggle({
    Name = "Generator ESP",
    Callback = function(Value)
        _G.GenESP = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Item ESP",
    Callback = function(Value)
        _G.ItemESP = Value
    end
})
