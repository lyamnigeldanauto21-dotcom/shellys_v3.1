-- [[ Shelly's 6ft Under Hub v2.4 ]] --
-- UI Framework: Rayfield

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🐢 Shelly's 6ft Under Hub v2.4",
    LoadingTitle = "Shelly's Hub Loading...",
    LoadingSubtitle = "Preparing Underground Framework",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ShellysHubConfig",
        FileName = "ShellyHub_v24"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false -- Set to true if you ever want a key system later
})

------------------------------------------------------------------------
-- TABS DECLARATION
------------------------------------------------------------------------
local MainTab     = Window:CreateTab("🛠️ Main", nil) -- Title, Image
local ShellyTab   = Window:CreateTab("🐢 Shelly", nil)
local VisualsTab  = Window:CreateTab("👁️ Visuals", nil)
local MovementTab = Window:CreateTab("⚡ Movement", nil)
local TeleportTab = Window:CreateTab("📊 Teleport", nil)
local SettingsTab = Window:CreateTab("⚙️ Settings", nil)

------------------------------------------------------------------------
-- [ 🛠️ MAIN TAB ] - EXPLOITS & AUTOMATION SECTION
------------------------------------------------------------------------

Rayfield:Notify({
    Title = "Hub Initialized",
    Content = "Successfully loaded Shelly's 6ft Under Hub!",
    Duration = 5,
    Image = nil,
})

-- Section: Exploits
local ExploitsSection = MainTab:CreateSection("Exploits")

local GodmodeToggle = MainTab:CreateToggle({
    Name = "Toggle Godmode (In-Shell)",
    CurrentValue = false,
    Flag = "GodmodeToggle", 
    Callback = function(Value)
        -- 'Value' is a boolean (true/false) based on whether the toggle is on/off
        if Value then
            print("Godmode Activated")
            -- Insert your custom code here for when it's enabled
        else
            print("Godmode Deactivated")
            -- Insert your custom code here for when it's disabled
        end
    end,
})

local NoclipToggle = MainTab:CreateToggle({
    Name = "No-Clip Underground",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        if Value then
            print("No-Clip Underground Enabled")
        else
            print("No-Clip Underground Disabled")
        end
    end,
})

local SpeedSlider = MainTab:CreateSlider({
    Name = "Set Custom Speed/Stamina",
    Min = 16,        -- Default Roblox WalkSpeed
    Max = 100,       -- Maximum limit
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(Value)
        print("Custom Speed/Stamina set to: " .. tostring(Value))
        -- Example logic to apply to local player:
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

-- Section: Shelly Automation
local AutomationSection = MainTab:CreateSection("Shelly Automation")

local AutoShellToggle = MainTab:CreateToggle({
    Name = "Auto-Shell on Danger Threshold (20% HP)",
    CurrentValue = false,
    Flag = "AutoShell",
    Callback = function(Value)
        if Value then
            print("Auto-Shell Watcher Active")
            -- You can place a loop or a connection to check Health here
        else
            print("Auto-Shell Watcher Deactivated")
        end
    end,
})

------------------------------------------------------------------------
-- FILLER TABS (Ready for your custom functions)
------------------------------------------------------------------------
ShellyTab:CreateSection("Shelly Specific Tweaks")
VisualsTab:CreateSection("ESP & Render Toggles")
MovementTab:CreateSection("Physics Modifications")
TeleportTab:CreateSection("Waypoints & Coordinates")
SettingsTab:CreateSection("UI Customization")

SettingsTab:CreateButton({
    Name = "Destroy UI / Unload Hub",
    Callback = function()
        Rayfield:Destroy()
    end,
})
