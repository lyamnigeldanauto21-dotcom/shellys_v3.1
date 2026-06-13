-- Shelly's Hub V5.0 [Player, Visuals, & Automations Unified Engine]
-- Optimizations: Strict Global Instance Registry, Network-Level Remote Interception, Tween Sizing Arrays

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Prevent duplication crashes
if PlayerGui:FindFirstChild("ShellyHubV5") then
    PlayerGui.ShellyHubV5:Destroy()
end

-- Screen Interface Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShellyHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Application Config State Matrix
local Flags = {
    WalkSpeedValue = 16,
    InfiniteStamina = false,
    TwistedESP = false,
    GeneratorESP = false,
    ItemESP = false,
    AutoSkillCheck = false
}

local RenderTracker = {
    Twisteds = {},
    Generators = {},
    Items = {}
}

local ItemKeywords = {"tape", "medkit", "candy", "speed", "bandage", "capsule", "health"}

-- ==========================================
-- ENGINE: PLAYER BOOST LOOPS
-- ==========================================
task.spawn(function()
    while RunService.RenderStepped:Wait() do
        pcall(function()
            local Character = LocalPlayer.Character
            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                if Humanoid then
                    if Flags.WalkSpeedValue > 16 then
                        Humanoid.WalkSpeed = Flags.WalkSpeedValue
                    end
                    if Flags.InfiniteStamina then
                        local StaminaObj = Character:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina")
                        if StaminaObj and StaminaObj:IsA("NumberValue") then
                            StaminaObj.Value = 100
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- ENGINE: CORE INTERFACE DESIGN & TABS
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 320)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(36, 36, 44)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Title Bar
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -60, 1, 0)
HeaderTitle.Position = UDim2.new(0, 16, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "SHELLY'S HUB — V5.0"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar Navigation View
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 130, 1, -46)
TabBar.Position = UDim2.new(0, 0, 0, 46)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 12)
TabPadding.PaddingLeft = UDim.new(0, 8)
TabPadding.PaddingRight = UDim.new(0, 8)
TabPadding.Parent = TabBar

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "Pages"
PagesFolder.Parent = MainFrame

local function CreatePage(pageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = pageName .. "Page"
    Page.Size = UDim2.new(1, -130, 1, -46)
    Page.Position = UDim2.new(0, 130, 0, 46)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.CanvasSize = UDim2.new(0, 0, 0, 380)
    Page.ScrollBarThickness = 2
    Page.Visible = false
    Page.Parent = PagesFolder

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 12)
    PagePadding.PaddingLeft = UDim.new(0, 12)
    PagePadding.PaddingRight = UDim.new(0, 12)
    PagePadding.Parent = Page

    local PageList = Instance.new("UIListLayout")
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 8)
    PageList.Parent = Page

    return Page
end

-- Instantiate Requested Target Containers
local PlayerPage = CreatePage("Player")
local VisualPage = CreatePage("Visual")
local AutomationPage = CreatePage("Automation")

local ActiveTabBtn = nil
local function SwitchTab(tabName, button)
    for _, page in ipairs(PagesFolder:GetChildren()) do
        page.Visible = false
    end
    local targetPage = PagesFolder:FindFirstChild(tabName .. "Page")
    if targetPage then targetPage.Visible = true end

    if ActiveTabBtn then
        TweenService:Create(ActiveTabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(26, 26, 32), TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
    end
    ActiveTabBtn = button
    TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(242, 102, 102), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

local function CreateTabButton(tabName, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    Btn.Text = "  " .. tabName
    Btn.TextColor3 = Color3.fromRGB(150, 150, 160)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.LayoutOrder = order
    Btn.Parent = TabBar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function() SwitchTab(tabName, Btn) end)
    return Btn
end

-- Generate UI Buttons Exactly As Instructed
local pBtn = CreateTabButton("Player", 1)
local vBtn = CreateTabButton("Visual", 2)
local aBtn = CreateTabButton("Automation", 3)
SwitchTab("Player", pBtn)

-- Compact Round Minimizer Button
local LogoToggleBtn = Instance.new("TextButton")
LogoToggleBtn.Size = UDim2.new(0, 46, 0, 46)
LogoToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
LogoToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
LogoToggleBtn.Text = "S"
LogoToggleBtn.TextColor3 = Color3.fromRGB(242, 102, 102)
LogoToggleBtn.TextSize = 20
LogoToggleBtn.Font = Enum.Font.FredokaOne
LogoToggleBtn.Visible = false
LogoToggleBtn.Parent = ScreenGui
Instance.new("UICorner", LogoToggleBtn).CornerRadius = UDim.new(0, 23)
local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(242, 102, 102)
LogoStroke.Thickness = 1.5
LogoStroke.Parent = LogoToggleBtn

-- ==========================================
-- ENGINE: STABLE SYNCHRONIZED COUNT ESP
-- ==========================================
local function GetTrueRegistryCount(categoryKey)
    local total = 0
    for _ in pairs(RenderTracker[categoryKey]) do total = total + 1 end
    return total
end

local function RebuildActiveLabels(categoryKey, labelTag)
    local activeCount = GetTrueRegistryCount(categoryKey)
    for targetObj, _ in pairs(RenderTracker[categoryKey]) do
        local billboard = targetObj:FindFirstChild("ESPBillboard")
        if billboard then
            local textLabel = billboard:FindFirstChildOfClass("TextLabel")
            if textLabel then
                textLabel.Text = string.format("%s [%d Active]", labelTag, activeCount)
            end
        end
    end
end

local function ApplyRenderVisuals(instance, color, labelTag, categoryKey)
    local root = instance:IsA("Model") and (instance.PrimaryPart or instance:FindFirstChildWhichIsA("BasePart")) or (instance:IsA("BasePart") and instance)
    if not root or instance:FindFirstChild("ESPHighlight") then return end

    local Highlight = Instance.new("Highlight")
    Highlight.Name = "ESPHighlight"
    Highlight.FillColor = color
    Highlight.FillTransparency = 0.65
    Highlight.OutlineColor = color
    Highlight.OutlineTransparency = 0.1
    Highlight.Adornee = instance
    Highlight.Parent = instance

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESPBillboard"
    Billboard.Size = UDim2.new(0, 140, 0, 26)
    Billboard.AlwaysOnTop = true
    Billboard.Adornee = root
    Billboard.Parent = instance

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelTag
    Label.TextColor3 = color
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamBold
    Label.TextStrokeTransparency = 0.3
    Label.Parent = Billboard

    RebuildActiveLabels(categoryKey, labelTag)
end

local function RemoveRenderVisuals(instance, categoryKey, labelTag)
    local high = instance:FindFirstChild("ESPHighlight")
    local bill = instance:FindFirstChild("ESPBillboard")
    if high then high:Destroy() end
    if bill then bill:Destroy() end
    task.defer(function() RebuildActiveLabels(categoryKey, labelTag) end)
end

local function RefreshCategoryDrawStates(categoryKey, isEnabled, color, labelTag)
    for targetObj, _ in pairs(RenderTracker[categoryKey]) do
        if isEnabled then
            ApplyRenderVisuals(targetObj, color, labelTag, categoryKey)
        else
            RemoveRenderVisuals(targetObj, categoryKey, labelTag)
        end
    end
end

local function FilterAndRegister(descendant)
    if not descendant:IsA("Model") and not descendant:IsA("BasePart") then return end
    local lowerName = string.lower(descendant.Name)

    if descendant:IsA("Model") and (descendant:FindFirstChild("AnimationController") or descendant:FindFirstChildWhichIsA("Humanoid")) and not Players:GetPlayerFromCharacter(descendant) then
        RenderTracker.Twisteds[descendant] = true
        if Flags.TwistedESP then ApplyRenderVisuals(descendant, Color3.fromRGB(255, 62, 62), "⚠️ TWISTED", "Twisteds") end
        RebuildActiveLabels("Twisteds", "⚠️ TWISTED")
        return
    end

    if string.find(lowerName, "generator") or string.find(lowerName, "machine") then
        if descendant:FindFirstChildWhichIsA("ProximityPrompt", true) or descendant:FindFirstChild("Progress") or descendant:FindFirstChild("Vitals") then
            RenderTracker.Generators[descendant] = true
            if Flags.GeneratorESP then ApplyRenderVisuals(descendant, Color3.fromRGB(62, 255, 122), "⚙️ MACHINE", "Generators") end
            RebuildActiveLabels("Generators", "⚙️ MACHINE")
        end
        return
    end

    for _, match in ipairs(ItemKeywords) do
        if string.find(lowerName, match) and not string.find(lowerName, "door") then
            RenderTracker.Items[descendant] = true
            if Flags.ItemESP then ApplyRenderVisuals(descendant, Color3.fromRGB(252, 212, 62), "📦 ITEM", "Items") end
            RebuildActiveLabels("Items", "📦 ITEM")
            break
        end
    end
end

local function SafelyPurgeRegistry(descendant)
    if RenderTracker.Twisteds[descendant] then
        RenderTracker.Twisteds[descendant] = nil
        RemoveRenderVisuals(descendant, "Twisteds", "⚠️ TWISTED")
    elseif RenderTracker.Generators[descendant] then
        RenderTracker.Generators[descendant] = nil
        RemoveRenderVisuals(descendant, "Generators", "⚙️ MACHINE")
    elseif RenderTracker.Items[descendant] then
        RenderTracker.Items[descendant] = nil
        RemoveRenderVisuals(descendant, "Items", "📦 ITEM")
    end
end

for _, item in ipairs(Workspace:GetDescendants()) do task.spawn(FilterAndRegister, item) end
Workspace.DescendantAdded:Connect(FilterAndRegister)
Workspace.DescendantRemoving:Connect(SafelyPurgeRegistry)

-- ==========================================
-- ENGINE: HIGH-PERFORMANCE REMOTE LINK
-- ==========================================
local function InterceptSkillNetwork()
    local function AssessRemote(obj)
        if obj:IsA("RemoteEvent") and (string.find(obj.Name, "Skill") or string.find(obj.Name, "Minigame")) then
            obj.OnClientEvent:Connect(function(...)
                if Flags.AutoSkillCheck then
                    task.wait(0.05)
                    obj:FireServer(true)
                end
            end)
        end
    end

    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do task.spawn(AssessRemote, obj) end
    ReplicatedStorage.DescendantAdded:Connect(AssessRemote)
end
task.spawn(InterceptSkillNetwork)

-- ==========================================
-- ENGINE: RENDER ROW GENERATION UTILITIES
-- ==========================================
local function AddUiToggle(page, textLabel, flagKey, trackerKey, activeColor, tagText, isCustom)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 44)
    Row.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Row.BorderSizePixel = 0
    Row.Parent = page
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = textLabel
    Label.TextColor3 = Color3.fromRGB(230, 230, 235)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local SliderFrame = Instance.new("TextButton")
    SliderFrame.Size = UDim2.new(0, 46, 0, 22)
    SliderFrame.Position = UDim2.new(1, -56, 0.5, -11)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 54)
    SliderFrame.Text = ""
    SliderFrame.Parent = Row
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 11)

    local CirclePin = Instance.new("Frame")
    CirclePin.Size = UDim2.new(0, 16, 0, 16)
    CirclePin.Position = UDim2.new(0, 3, 0.5, -8)
    CirclePin.BackgroundColor3 = Color3.fromRGB(160, 160, 170)
    CirclePin.BorderSizePixel = 0
    CirclePin.Parent = SliderFrame
    Instance.new("UICorner", CirclePin).CornerRadius = UDim.new(0, 8)

    SliderFrame.MouseButton1Click:Connect(function()
        Flags[flagKey] = not Flags[flagKey]
        
        local PosX = Flags[flagKey] and UDim2.new(0, 27, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local BackColor = Flags[flagKey] and Color3.fromRGB(242, 102, 102) or Color3.fromRGB(42, 42, 54)
        local PinColor = Flags[flagKey] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)

        TweenService:Create(CirclePin, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = PosX, BackgroundColor3 = PinColor}):Play()
        TweenService:Create(SliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = BackColor}):Play()

        if not isCustom then
            RefreshCategoryDrawStates(trackerKey, Flags[flagKey], activeColor, tagText)
        end
    end)
end

local function AddUiSlider(page, textLabel, flagKey, min, max)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 54)
    Row.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Row.Parent = page
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 0, 24)
    Label.Position = UDim2.new(0, 14, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = textLabel
    Label.TextColor3 = Color3.fromRGB(230, 230, 235)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ValueDisplay = Instance.new("TextLabel")
    ValueDisplay.Size = UDim2.new(0.4, 0, 0, 24)
    ValueDisplay.Position = UDim2.new(1, -154, 0, 4)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = tostring(Flags[flagKey])
    ValueDisplay.TextColor3 = Color3.fromRGB(242, 102, 102)
    ValueDisplay.TextSize = 13
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    ValueDisplay.Parent = Row

    local SlideTrack = Instance.new("TextButton")
    SlideTrack.Size = UDim2.new(1, -28, 0, 6)
    SlideTrack.Position = UDim2.new(0, 14, 1, -16)
    SlideTrack.BackgroundColor3 = Color3.fromRGB(46, 46, 56)
    SlideTrack.Text = ""
    SlideTrack.Parent = Row
    Instance.new("UICorner", SlideTrack).CornerRadius = UDim.new(0, 3)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(242, 102, 102)
    Fill.BorderSizePixel = 0
    Fill.Parent = SlideTrack
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)

    local Pin = Instance.new("Frame")
    Pin.Size = UDim2.new(0, 14, 0, 14)
    Pin.Position = UDim2.new(0, -7, 0.5, -7)
    Pin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Pin.Parent = SlideTrack
    Instance.new("UICorner", Pin).CornerRadius = UDim.new(0, 7)

    local Moving = false
    local function ProcessSlide(input)
        local trackWidth = SlideTrack.AbsoluteSize.X
        local deltaX = math.clamp(input.Position.X - SlideTrack.AbsolutePosition.X, 0, trackWidth)
        local percentage = deltaX / trackWidth
        local numericVal = math.floor(min + (percentage * (max - min)))
        
        Flags[flagKey] = numericVal
        ValueDisplay.Text = tostring(numericVal)
        TweenService:Create(Fill, TweenInfo.new(0.06, Enum.EasingStyle.Quad), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        TweenService:Create(Pin, TweenInfo.new(0.06, Enum.EasingStyle.Quad), {Position = UDim2.new(percentage, -7, 0.5, -7)}):Play()
    end

    SlideTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Moving = true
            ProcessSlide(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Moving and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            ProcessSlide(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Moving = false
        end
    end)
end

-- ==========================================
-- UI CONTROLS ASSIGNMENT & REGISTRATION
-- ==========================================
AddUiSlider(PlayerPage, "Custom Walkspeed Boost", "WalkSpeedValue", 16, 45)
AddUiToggle(PlayerPage, "Infinite Stamina Loop", "InfiniteStamina", nil, nil, nil, true)

AddUiToggle(VisualPage, "Twisted Entity ESP", "TwistedESP", "Twisteds", Color3.fromRGB(255, 62, 62), "⚠️ TWISTED", false)
AddUiToggle(VisualPage, "Generator & Machine ESP", "GeneratorESP", "Generators", Color3.fromRGB(62, 255, 122), "⚙️ MACHINE", false)
AddUiToggle(VisualPage, "Interactive Item ESP