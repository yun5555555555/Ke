local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 渐变文本函数
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

-- 获取角色函数（带超时）
local function getCharacter()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then return character end
    
    local startTime = tick()
    while tick() - startTime < 10 do -- 10秒超时
        character = player.Character
        if character then return character end
        wait(0.1)
    end
    return nil
end

-- 服务
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- 安全获取后代
local function getWorkspaceDescendants()
    local descendants = {}
    local success, result = pcall(function()
        return Workspace:GetDescendants()
    end)
    return success and result or {}
end

local WorkspaceDescendants = getWorkspaceDescendants()

-- 幽灵锁定
local GhostLock = true

-- 初始化诅咒道具
local Cursed = {}
for _, CursedSpawns in ipairs(WorkspaceDescendants) do
    if CursedSpawns:IsA("Model") and CursedSpawns.Name == "Ouija Board" then
        Cursed = CursedSpawns
    end
    if CursedSpawns:IsA("Model") and CursedSpawns.Name == "SummoningCircle" then
        Cursed = CursedSpawns
    end
    if CursedSpawns:IsA("Tool") and CursedSpawns.Name == "Tarot Cards" then
        Cursed = CursedSpawns
    end
end

-- 互动透视
local EMFBillboardGuiDescendantAdded
function EMFBillboardGui(descendant)
    if descendant:IsA("Part") and descendant.Name == "EMFPart" then
        local BillboardGui = Instance.new("BillboardGui")
        local TextLabel = Instance.new("TextLabel")

        BillboardGui.Name = "EMFBillboardGui"
        BillboardGui.Parent = descendant
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 40, 0, 20)

        TextLabel.Parent = BillboardGui
        TextLabel.Text = "互动"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(0, 40, 0, 20)
        TextLabel.TextColor3 = Color3.fromRGB(70, 255, 0)
        TextLabel.TextSize = 10
    end
end

-- EMF出现次数
local EMFCount = 0
function MapDescendantAdded(descendant)
    if descendant:IsA("Part") and descendant.Name == "EMFPart" then
        EMFCount = EMFCount + 1
    end
end

-- 幽灵透视
function GhostESP()
    repeat
        for _, Ghost in ipairs(Workspace:GetChildren()) do
            if Ghost.Name == "Ghost" and Ghost:IsA("Model") then
                local GhostParts = Ghost:GetChildren()
                for _, GhostPart in ipairs(GhostParts) do
                    if GhostPart:IsA("MeshPart") then
                        local New = GhostPart:FindFirstChild("GhostESP")
                        if not New then
                            local boxHandleAdornment = Instance.new("BoxHandleAdornment")
                            boxHandleAdornment.Name = "GhostESP"
                            boxHandleAdornment.Size = Vector3.new(1, 1, 1)
                            boxHandleAdornment.AlwaysOnTop = true
                            boxHandleAdornment.ZIndex = 5
                            boxHandleAdornment.Parent = GhostPart
                            boxHandleAdornment.Adornee = GhostPart
                            boxHandleAdornment.Transparency = 0.4
                        end
                    end
                end
            end
        end
        wait(1)
    until GhostLock
end

-- 精灵盒功能
local Lock2 = false
function onchildAdded(child)
    if child:IsA("Sound") then
        local childName = string.lower(child.Name)
        if Lock2 == false then
            WindUI:Notify({
                Title = "精灵盒",
                Content = "精灵盒获取成功: " .. childName,
                Duration = 5,
                Image = "check",
            })
        end
        Lock2 = true
    end
end

-- 冻结温度功能
local function initFreezeTemp()
    local Lock = false
    spawn(function()
        local maxAttempts = 30 -- 最大尝试次数
        local attempts = 0
        
        repeat
            attempts = attempts + 1
            local success, result = pcall(function()
                for _, workspaces in ipairs(WorkspaceDescendants) do
                    if workspaces.Name == "_____Temperature" and workspaces:IsA("NumberValue") then
                        if workspaces.Value < 0 and workspaces.Value > -3 then
                            local WorkspaceValue = tonumber(workspaces.Value)
                            WindUI:Notify({
                                Title = "冻结温度",
                                Content = "冻结温度获取成功: " .. WorkspaceValue,
                                Duration = 5,
                                Image = "check",
                            })
                            Lock = true
                            return
                        end
                    end
                end
            end)
            
            if not success then
                warn("冻结温度检测错误: " .. tostring(result))
            end
            
            wait(1)
        until Lock or attempts >= maxAttempts
        
        if not Lock then
            WindUI:Notify({
                Title = "冻结温度",
                Content = "未检测到冻结温度",
                Duration = 5,
                Image = "triangle-alert",
            })
        end
    end)
end

-- 玩家加入记录
local function onPlayerJoin(player)
    WindUI:Notify({
        Title = "玩家加入记录",
        Content = "有新玩家加入了本局: " .. player.Name,
        Duration = 5,
        Image = "triangle-alert",
    })
end

-- 安全创建UI
local function createMainUI()
    local success, mainWindow = pcall(function()
        return WindUI:CreateWindow({
            Title = "科脚本-恐鬼症",
            Size = UDim2.fromOffset(600, 480),
            Theme = "Dark",
            SideBarWidth = 200,
            ScrollBarEnabled = true,
        })
    end)
    
    if not success or not mainWindow then
        warn("创建主窗口失败: " .. tostring(mainWindow))
        return
    end
    
    local sectionSuccess, mainSection = pcall(function()
        return mainWindow:Section({
            Title = "功能",
            Opened = true,
        })
    end)
    
    if not sectionSuccess or not mainSection then
        warn("创建主部分失败: " .. tostring(mainSection))
        return
    end
    
    local tabSuccess, mainTab = pcall(function()
        return mainSection:Tab({ Title = "主功能", Icon = "tools" })
    end)
    
    if not tabSuccess or not mainTab then
        warn("创建主标签页失败: " .. tostring(mainTab))
        return
    end
    
    -- 证据段落
    pcall(function()
        mainTab:Paragraph({
            Title = "互动(电磁场读取)",
            Content = "出现次数: " .. EMFCount
        })
        
        mainTab:Paragraph({
            Title = "冻结温度",
            Content = "获取中..."
        })
        
        mainTab:Paragraph({
            Title = "精灵盒(道具需要在鬼房)",
            Content = "捕捉中..."
        })
    end)
    
    -- 玩家功能
    pcall(function() mainTab:Divider({Title = "玩家功能"}) end)
    
    pcall(function()
        mainTab:Toggle({
            Title = "穿门",
            Value = false,
            Callback = function(Value)
                for _, Doors in ipairs(WorkspaceDescendants) do
                    if Doors:IsA("Folder") and Doors.Name == "Doors" then
                        local ModelDoors = Doors:GetDescendants()
                        for _, ModelDoor in ipairs(ModelDoors) do
                            if ModelDoor:IsA("MeshPart") or ModelDoor:IsA("Part") then
                                if ModelDoor.Name == "RightDoor" or ModelDoor.Name == "LeftDoor" or ModelDoor.Name == "Door" then
                                    ModelDoor.CanCollide = not Value
                                end
                            end
                        end
                    end
                end
            end
        })
    end)
    
    pcall(function()
        mainTab:Button({
            Title = "夜视",
            Callback = function()
                Lighting.Brightness = 2
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                Lighting.GlobalShadows = false
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.FogStart = 0
                
                -- 安全移除大气效果
                local atmosphere = Lighting:FindFirstChild("Atmosphere")
                if atmosphere and atmosphere:IsA("Atmosphere") then
                    atmosphere:Destroy()
                end
            end
        })
    end)
    
    pcall(function()
        mainTab:Toggle({
            Title = "稳定速度+无限体力",
            Value = false,
            Callback = function(Value)
                local deadValue = LocalPlayer:FindFirstChild("Dead")
                if deadValue and deadValue:IsA("BoolValue") then
                    deadValue.Value = Value
                end
                
                if Value then
                    WindUI:Notify({
                        Title = "告知",
                        Content = "开启后加速无法关闭，除非游戏重置移动速度",
                        Duration = 5,
                        Image = "triangle-alert",
                    })
                end
            end
        })
    end)
    
    -- 透视功能
    pcall(function() mainTab:Divider({Title = "透视功能"}) end)
    
    pcall(function()
        mainTab:Toggle({
            Title = "幽灵",
            Value = false,
            Callback = function(Value)
                if GhostLock then
                    GhostLock = false
                    GhostESP()
                else
                    GhostLock = true
                end
            end
        })
    end)
    
    pcall(function()
        mainTab:Toggle({
            Title = "互动",
            Value = false,
            Callback = function(Value)
                if Value then
                    local map = Workspace:FindFirstChild("Map")
                    if map then
                        EMFBillboardGuiDescendantAdded = map.DescendantAdded:Connect(EMFBillboardGui)
                    end
                else
                    if EMFBillboardGuiDescendantAdded then
                        EMFBillboardGuiDescendantAdded:Disconnect()
                    end
                end
            end
        })
    end)
    
    pcall(function()
        mainTab:Toggle({
            Title = "诅咒道具",
            Value = false,
            Callback = function(Value)
                if Cursed then
                    if Value then
                        local CursedHighlight = Cursed:FindFirstChild("CursedESP")
                        if not CursedHighlight then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Name = "CursedESP"
                            Highlight.Parent = Cursed
                            Highlight.FillTransparency = 1
                            Highlight.OutlineColor = Color3.fromRGB(255, 170, 127)
                            Highlight.OutlineTransparency = 0.2
                        end
                    else
                        local CursedHighlightDestroy = Cursed:FindFirstChild("CursedESP")
                        if CursedHighlightDestroy then
                            CursedHighlightDestroy:Destroy()
                        end
                    end
                end
            end
        })
    end)
    
    pcall(function()
        mainTab:Toggle({
            Title = "巫毒娃娃",
            Value = false,
            Callback = function(Value)
                local VoodooDoll = Workspace:FindFirstChild("VoodooDoll")
                if VoodooDoll then
                    if Value then
                        local VoodooDollHighlightRepeat = VoodooDoll:FindFirstChild("VoodooDollESP")
                        if not VoodooDollHighlightRepeat then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Name = "VoodooDollESP"
                            Highlight.Parent = VoodooDoll
                            Highlight.FillTransparency = 1
                            Highlight.OutlineColor = Color3.fromRGB(0,255,255)
                            Highlight.OutlineTransparency = 0.5
                        end
                    else
                        local VoodooDollHighlightRepeatDestroy = VoodooDoll:FindFirstChild("VoodooDollESP")
                        if VoodooDollHighlightRepeatDestroy then
                            VoodooDollHighlightRepeatDestroy:Destroy()
                        end
                    end
                end
            end
        })
    end)
    
    pcall(function()
        mainTab:Toggle({
            Title = "发电机",
            Value = false,
            Callback = function(Value)
                local Map = Workspace:FindFirstChild("Map")
                if Map then
                    local Generators = Map:FindFirstChild("Generators")
                    if Generators then
                        local GeneratorMesh = Generators:FindFirstChild("GeneratorMesh")
                        if GeneratorMesh then
                            if Value then
                                local GeneratorsHighlightRepeat = GeneratorMesh:FindFirstChild("GeneratorsESP")
                                if not GeneratorsHighlightRepeat then
                                    local Highlight = Instance.new("Highlight")
                                    Highlight.Name = "GeneratorsESP"
                                    Highlight.Parent = GeneratorMesh
                                    Highlight.FillTransparency = 1
                                    Highlight.OutlineColor = Color3.fromRGB(255, 255, 127)
                                    Highlight.OutlineTransparency = 0.3
                                end
                            else
                                local GeneratorsHighlightRepeatDestroy = GeneratorMesh:FindFirstChild("GeneratorsESP")
                                if GeneratorsHighlightRepeatDestroy then
                                    GeneratorsHighlightRepeatDestroy:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        })
    end)
    
    -- 恶搞功能
    pcall(function() mainTab:Divider({Title = "恶搞功能"}) end)
    
    pcall(function()
        mainTab:Button({
            Title = "自杀",
            Callback = function()
                local character = getCharacter()
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Health = 0
                    else
                        WindUI:Notify({
                            Title = "错误",
                            Content = "找不到Humanoid对象",
                            Duration = 5,
                            Image = "triangle-alert",
                        })
                    end
                else
                    WindUI:Notify({
                        Title = "错误",
                        Content = "找不到角色对象",
                        Duration = 5,
                        Image = "triangle-alert",
                    })
                end
            end
        })
    end)
    
    -- 公告标签页
    local announcementTab = mainWindow:Section({
        Title = "公告",
        Opened = true,
    }):Tab({ Title = "公告", Icon = "bell-ring" })
    
    pcall(function()
        announcementTab:Paragraph({Title = "[+]添加[卡密]功能", Content = "为了能更好的集中一个群内"})
        announcementTab:Paragraph({Title = "[+]修复[穿门]功能", Content = "修复了无法穿其他地图的大门了"})
        announcementTab:Paragraph({Title = "[+]添加[自杀]功能", Content = "可以让自己随时随地死亡了"})
        announcementTab:Paragraph({Title = "[+]透视更改", Content = "可以关闭啦"})
        announcementTab:Paragraph({Title = "[+]布局重组", Content = "更美观啦"})
        announcementTab:Paragraph({Title = "[+]公告窗口", Content = "可以查看更详细的更新内容啦"})
    end)
    
    -- 防巡查标签页
    local playerTab = mainWindow:Section({
        Title = "防巡查",
        Opened = true,
    }):Tab({ Title = "玩家加入记录", Icon = "triangle-alert" })
    
    pcall(function()
        playerTab:Paragraph({Title = "玩家加入监控", Content = "当有新玩家加入时会在此显示"})
    end)
    
    -- 初始化事件监听
    local map = Workspace:FindFirstChild("Map")
    if map then
        map.DescendantAdded:Connect(MapDescendantAdded)
    else
        warn("找不到Map对象")
    end
    
    Players.PlayerAdded:Connect(onPlayerJoin)
    
    -- 初始化精灵盒监听
    local Spirit = Workspace:GetDescendants()
    local Name = "Spirit Box"
    for _, SpiritName in ipairs(Spirit) do
        if SpiritName:IsA("Tool") and SpiritName.Name == Name then
            local Handle = SpiritName:FindFirstChild("Handle")
            if Handle then
                Handle.ChildAdded:Connect(onchildAdded)
            end
        end
    end
    
    -- 初始化冻结温度
    initFreezeTemp()
end

-- 安全显示欢迎窗口
local function showWelcome()
    local welcomeMsg = gradientText("科脚本", Color3.fromHex("#FF0000"), Color3.fromHex("#00FF00"))
    
    WindUI:Popup({
        Title = "欢迎使用科脚本",
        Content = "尊贵的科脚本用户祝您平平安安，健健康康",
        Buttons = {
            {
                Title = "取消",
                Callback = function() 
                    print("用户取消了外挂") 
                end,
                Variant = "Secondary"
            },
            {
                Title = "开始",
                Callback = createMainUI,
                Variant = "Primary"
            }
        }
    })
end


local Tab = Window:Tab({
    Title = "设置",
    Icon = "settings",
    Locked = false,
})
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

Tab:Dropdown({
    Title = "更改ui颜色",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})

-- 延迟启动UI
spawn(function()
    wait(1) -- 等待1秒让环境稳定
    showWelcome()
end)

-- 连接事件
spawn(function()
    wait(2) -- 等待2秒再连接事件
    
    local map = Workspace:FindFirstChild("Map")
    if map then
        map.DescendantAdded:Connect(MapDescendantAdded)
    end
    
    Players.PlayerAdded:Connect(onPlayerJoin)
end)