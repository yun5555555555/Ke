local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local function gradientText(text, colorA, colorB)
    if type(text) ~= "string" then return text end
    local result = {}
    for i = 1, #text do
        local ratio = (i-1)/(#text-1)
        local r = math.floor(colorA.R + (colorB.R-colorA.R)*ratio * 255)
        local g = math.floor(colorA.G + (colorB.G-colorA.G)*ratio * 255)
        local b = math.floor(colorA.B + (colorB.B-colorA.B)*ratio * 255)
        table.insert(result, string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i,i)))
    end
    return table.concat(result)
end

local function getCharacter()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then return character end
    
    local startTime = tick()
    while tick() - startTime < 10 do
        character = player.Character
        if character then return character end
        wait(0.1)
    end
    return nil
end

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local function getWorkspaceDescendants()
    local descendants = {}
    local success, result = pcall(function()
        return Workspace:GetDescendants()
    end)
    return success and result or {}
end

local WorkspaceDescendants = getWorkspaceDescendants()

local GhostLock = true
local Cursed = {}

for _, obj in ipairs(WorkspaceDescendants) do
    if obj:IsA("Model") and (obj.Name == "Ouija Board" or obj.Name == "SummoningCircle") then
        Cursed = obj
    elseif obj:IsA("Tool") and obj.Name == "Tarot Cards" then
        Cursed = obj
    end
end

local EMFCount = 0
local EMFBillboardGuiConn

local function createEMFIndicator(part)
    local gui = Instance.new("BillboardGui")
    gui.Name = "EMFIndicator"
    gui.Size = UDim2.new(0, 40, 0, 20)
    gui.AlwaysOnTop = true
    gui.Parent = part
    
    local label = Instance.new("TextLabel")
    label.Text = "互动"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(70, 255, 0)
    label.TextSize = 10
    label.Parent = gui
end

local function onEMFAdded(descendant)
    if descendant:IsA("Part") and descendant.Name == "EMFPart" then
        EMFCount = EMFCount + 1
        createEMFIndicator(descendant)
    end
end

local function GhostESP()
    while not GhostLock do
        for _, ghost in ipairs(Workspace:GetChildren()) do
            if ghost.Name == "Ghost" and ghost:IsA("Model") then
                for _, part in ipairs(ghost:GetChildren()) do
                    if part:IsA("MeshPart") and not part:FindFirstChild("GhostESP") then
                        local adornment = Instance.new("BoxHandleAdornment")
                        adornment.Name = "GhostESP"
                        adornment.Size = Vector3.new(1, 1, 1)
                        adornment.AlwaysOnTop = true
                        adornment.ZIndex = 5
                        adornment.Transparency = 0.4
                        adornment.Adornee = part
                        adornment.Parent = part
                    end
                end
            end
        end
        wait(1)
    end
end

local spiritBoxLock = false
local function onSpiritBoxSound(sound)
    if not spiritBoxLock then
        WindUI:Notify({
            Title = "精灵盒",
            Content = "检测到声音: "..sound.Name,
            Duration = 5,
            Image = "check"
        })
        spiritBoxLock = true
    end
end

local function initFreezeTemp()
    local attempts = 0
    local found = false
    
    while attempts < 30 and not found do
        for _, obj in ipairs(WorkspaceDescendants) do
            if obj.Name == "_____Temperature" and obj:IsA("NumberValue") then
                if obj.Value < 0 and obj.Value > -3 then
                    WindUI:Notify({
                        Title = "冻结温度",
                        Content = "当前温度: "..obj.Value,
                        Duration = 5,
                        Image = "check"
                    })
                    found = true
                    break
                end
            end
        end
        attempts = attempts + 1
        wait(1)
    end
    
    if not found then
        WindUI:Notify({
            Title = "冻结温度",
            Content = "未检测到低温",
            Duration = 5,
            Image = "triangle-alert"
        })
    end
end

local function onPlayerJoined(player)
    WindUI:Notify({
        Title = "玩家加入",
        Content = player.Name.." 加入了游戏",
        Duration = 5,
        Image = "triangle-alert"
    })
end

local function createMainUI()
    local mainWindow = WindUI:CreateWindow({
        Title = "恐鬼症辅助",
        Size = UDim2.fromOffset(600, 480),
        Theme = "Dark",
        SideBarWidth = 200
    })
    
    local mainSection = mainWindow:Section({Title = "功能", Opened = true})
    local mainTab = mainSection:Tab({Title = "主要功能", Icon = "tools"})
    
    mainTab:Paragraph({Title = "EMF计数器", Content = "检测到 "..EMFCount.." 次互动"})
    mainTab:Paragraph({Title = "温度检测", Content = "正在监测中..."})
    mainTab:Paragraph({Title = "精灵盒", Content = "等待声音输入..."})
    
    mainTab:Divider({Title = "玩家功能"})
    
    mainTab:Toggle({
        Title = "穿墙模式",
        Value = false,
        Callback = function(enabled)
            for _, door in ipairs(WorkspaceDescendants) do
                if door:IsA("BasePart") and (door.Name == "Door" or door.Name:find("Door")) then
                    door.CanCollide = not enabled
                end
            end
        end
    })
    
    mainTab:Button({
        Title = "夜视模式",
        Callback = function()
            Lighting.Brightness = 2
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
        end
    })
    
    mainTab:Toggle({
        Title = "无限体力",
        Value = false,
        Callback = function(enabled)
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetAttribute("Stamina", enabled and 100 or nil)
                end
            end
        end
    })
    
    mainTab:Divider({Title = "透视功能"})
    
    mainTab:Toggle({
        Title = "幽灵透视",
        Value = false,
        Callback = function(enabled)
            GhostLock = not enabled
            if enabled then
                coroutine.wrap(GhostESP)()
            end
        end
    })
    
    mainTab:Toggle({
        Title = "互动透视",
        Value = false,
        Callback = function(enabled)
            if enabled then
                EMFBillboardGuiConn = Workspace.DescendantAdded:Connect(onEMFAdded)
            elseif EMFBillboardGuiConn then
                EMFBillboardGuiConn:Disconnect()
            end
        end
    })
    
    mainTab:Toggle({
        Title = "诅咒物品",
        Value = false,
        Callback = function(enabled)
            if Cursed then
                local highlight = Cursed:FindFirstChild("CursedHighlight")
                if enabled and not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "CursedHighlight"
                    highlight.FillTransparency = 1
                    highlight.OutlineColor = Color3.fromRGB(255, 170, 127)
                    highlight.Parent = Cursed
                elseif not enabled and highlight then
                    highlight:Destroy()
                end
            end
        end
    })
    
    local settingsTab = mainWindow:Section({Title = "设置"}):Tab({Title = "设置", Icon = "settings"})
    
    local themes = {}
    for name in pairs(WindUI:GetThemes()) do
        table.insert(themes, name)
    end
    
    settingsTab:Dropdown({
        Title = "界面主题",
        Values = themes,
        Callback = function(theme)
            WindUI:SetTheme(theme)
        end
    })
    
    Players.PlayerAdded:Connect(onPlayerJoined)
    
    local map = Workspace:FindFirstChild("Map")
    if map then
        map.DescendantAdded:Connect(onEMFAdded)
    end
    
    for _, tool in ipairs(Workspace:GetDescendants()) do
        if tool:IsA("Tool") and tool.Name == "Spirit Box" then
            tool.Handle.ChildAdded:Connect(onSpiritBoxSound)
        end
    end
    
    coroutine.wrap(initFreezeTemp)()
end

WindUI:Popup({
    Title = "欢迎使用",
    Content = "恐鬼症辅助脚本已加载",
    Buttons = {
        {Title = "开始使用", Callback = createMainUI, Variant = "Primary"},
        {Title = "退出", Callback = function() end}
    }
})