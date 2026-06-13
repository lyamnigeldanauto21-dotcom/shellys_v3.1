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
    KeySystem = false
})

------------------------------------------------------------------------
-- TABS DECLARATION
------------------------------------------------------------------------
local MainTab     = Window:CreateTab("🛠️ Main", nil)
local ShellyTab   = Window:CreateTab("🐢 Shelly", nil)
local VisualsTab  = Window:CreateTab("👁️ Visuals", nil)
local MovementTab = Window:CreateTab("⚡ Movement", nil)
local TeleportTab = Window:CreateTab("📊 Teleport", nil)
local SettingsTab = Window:CreateTab("⚙️ Settings", nil)

------------------------------------------------------------------------
-- [ 🛠️ MAIN TAB ] - CREDITS ONLY
------------------------------------------------------------------------

MainTab:CreateSection("Credits")

MainTab:CreateParagraph({
    Title = "👑 Created By:", 
    Content = "Shellaes Dw"
})

MainTab:CreateParagraph({
    Title = "✨ Honorable Mentions:", 
    Content = "Riddance & Noxious"
})

MainTab:CreateParagraph({
    Title = "🤝 Relational Mentions:", 
    Content = "NOVA & IDK"
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
