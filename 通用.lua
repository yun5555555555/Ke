local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/china-ui/refs/heads/main/main%20(2).lua"))()

-- 渐变文字函数
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

local Window
local isUIOpen = false
local playernamedied = ""
local dropdown = {}
local autoInteract = false
local Jump = false
local ENABLED = false

-- 更新玩家列表
local function UpdatePlayerList()
    dropdown = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        dropdown[player.UserId] = player.Name
    end
end

-- 通知函数
local function Notify(top, text, ico, dur)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = top,
        Text = text,
        Icon = ico,
        Duration = dur,
    })
end

-- 创建主窗口
local function createWindow()
    Window = WindUI:CreateWindow({
        Title = "科脚本-洛天依",
        Icon = "zap",
        IconThemed = true,
        Author = "作者qq:2875456271",
        Folder = "KeScript",
        Size = UDim2.fromOffset(350, 500),
        Transparent = true,
        Theme = "Dark",
        User = {
            Enabled = true,
            Callback = function() print("点击用户信息") end,
            Anonymous = true
        },
        SideBarWidth = 220,
        ScrollBarEnabled = true
    })

    -- 主功能标签页
    local MainTab = Window:Tab({
        Title = "主功能",
        Icon = "zap",
        Locked = false,
    })

    local CombatSection = MainTab:Section({Title = "自瞄与子追", Opened = true})

-- 自瞄功能
CombatSection:Button({
    Title = "自瞄/死亡消失",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/ZYMlyhhz/raw",false))()
    end
})

CombatSection:Button({
    Title = "宙斯自瞄",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20Aimbot.lua"))()
    end
})

CombatSection:Button({
    Title = "英文自瞄",
    Callback = function()
        loadstring(game:HttpGet("https://rentry.co/n55gmtpi/raw", true))()
    end
})

-- 自瞄距离选项
local aimDistanceOptions = {
    {distance = 50, url = "https://pastefy.app/b3uXjRF6/raw"},
    {distance = 100, url = "https://pastefy.app/tQrd2r0L/raw"},
    {distance = 150, url = "https://pastefy.app/UOQWFvGp/raw"},
    {distance = 200, url = "https://pastefy.app/b5CuDuer/raw"},
    {distance = 250, url = "https://pastefy.app/p2huH7eF/raw"},
    {distance = 300, url = "https://pastefy.app/nIyVhrvV/raw"},
    {distance = 350, url = "https://pastefy.app/pnjKHMvV/raw"},
    {distance = 400, url = "https://pastefy.app/LQuP7sjj/raw"},
    {distance = 600, url = "https://pastefy.app/WmcEe2HB/raw"}
}

for _, option in ipairs(aimDistanceOptions) do
    CombatSection:Button({
        Title = "自瞄"..option.distance,
        Callback = function()
            loadstring(game:HttpGet(option.url, false))()
        end
    })
end

CombatSection:Button({
    Title = "自瞄全屏",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/n5LhGGgf/raw",false))()
    end
})

-- 子弹追踪功能
CombatSection:Button({
    Title = "阿尔子追",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/sgbs/main/%E4%B8%81%E4%B8%81%20%E6%B1%89%E5%8C%96%E8%87%AA%E7%9E%84.txt"))()
    end
})

CombatSection:Button({
    Title = "俄州子追",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/ClasiniZukov/e7547e7b48fa90d10eb7f85bd3569147/raw/f95cd3561a3bb3ac6172a14eb74233625b52e757/gistfile1.txt"))()
    end
})
    local PlayerSection = MainTab:Section({Title = "玩家功能", Opened = true})
    
    -- 玩家下拉菜单
    local PlayersDropdown = PlayerSection:Dropdown({
        Title = "选择玩家",
        Values = dropdown,
        Callback = function(v)
            playernamedied = v
        end
    })
    
    -- 更新玩家列表
    UpdatePlayerList()
    PlayersDropdown:Refresh(dropdown)
    
    -- 玩家事件监听
    game.Players.PlayerAdded:Connect(function(player)
        dropdown[player.UserId] = player.Name
        PlayersDropdown:AddOption(player.Name)
    end)
    
    game.Players.PlayerRemoved:Connect(function(player)
        PlayersDropdown:RemoveOption(player.Name)
        for k, v in pairs(dropdown) do
            if v == player.Name then
                dropdown[k] = nil
            end
        end
    end)
    
    -- 传送功能
    PlayerSection:Button({
        Title = "传送到玩家",
        Callback = function()
            local HumRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
            local tp_player = game.Players:FindFirstChild(playernamedied)
            if tp_player and tp_player.Character and tp_player.Character.HumanoidRootPart then
                HumRoot.CFrame = tp_player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                Notify("提示", "已经传送到玩家身边", "", 3)
            else
                Notify("错误", "无法传送 玩家已消失", "", 3)
            end
        end
    })
    
    PlayerSection:Button({
        Title = "把玩家传送过来",
        Callback = function()
            local HumRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
            local tp_player = game.Players:FindFirstChild(playernamedied)
            if tp_player and tp_player.Character and tp_player.Character.HumanoidRootPart then
                tp_player.Character.HumanoidRootPart.CFrame = HumRoot.CFrame + Vector3.new(0, 3, 0)
                Notify("提示", "已传送玩家过来", "", 3)
            else
                Notify("错误", "无法传送 玩家已消失", "", 3)
            end
        end
    })
    
    PlayerSection:Toggle({
        Title = "查看玩家视角",
        Value = false,
        Callback = function(state)
            if state then
                game:GetService('Workspace').CurrentCamera.CameraSubject =
                    game:GetService('Players'):FindFirstChild(playernamedied).Character.Humanoid
                Notify("提示", "已开启玩家视角", "", 3)
            else
                Notify("提示", "已关闭玩家视角", "", 3)
                local lp = game.Players.LocalPlayer
                game:GetService('Workspace').CurrentCamera.CameraSubject = lp.Character.Humanoid
            end
        end
    })

    -- 角色功能
    local CharacterSection = MainTab:Section({Title = "修改", Opened = true})
    
    CharacterSection:Slider({
        Title = "步行速度",
        Min = 16,
        Max = 400,
        Default = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed,
        Callback = function(Speed)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Speed
        end
    })
    
    CharacterSection:Slider({
        Title = "跳跃高度",
        Min = 50,
        Max = 400,
        Default = game.Players.LocalPlayer.Character.Humanoid.JumpPower,
        Callback = function(Jump)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Jump
        end
    })
    
    CharacterSection:Slider({
        Title = "重力设置",
        Min = 0,
        Max = 1000,
        Default = 196.2,
        Callback = function(Value)
            game.Workspace.Gravity = Value
        end
    })
    
    CharacterSection:Toggle({
        Title = "无限跳跃",
        Value = false,
        Callback = function(Value)
            Jump = Value
            game.UserInputService.JumpRequest:Connect(function()
                if Jump then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    })
    
    CharacterSection:Toggle({
        Title = "夜视功能",
        Value = false,
        Callback = function(Value)
            if Value then
                game.Lighting.Ambient = Color3.new(1, 1, 1)
            else
                game.Lighting.Ambient = Color3.new(0, 0, 0)
            end
        end
    })
    
    CharacterSection:Toggle({
        Title = "自动互动",
        Value = false,
        Callback = function(state)
            autoInteract = state
            while autoInteract do
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") then
                        fireproximityprompt(descendant)
                    end
                end
                task.wait(0.25)
            end
        end
    })

    -- 视觉功能
    local VisualSection = MainTab:Section({Title = "视觉功能", Opened = true})
    
    VisualSection:Button({
        Title = "透视功能",
        Callback = function()  
            _G.FriendColor = Color3.fromRGB(0, 0, 255)
            local function ApplyESP(v)
                if v.Character and v.Character:FindFirstChildOfClass'Humanoid' then
                    v.Character.Humanoid.NameDisplayDistance = 9e9
                    v.Character.Humanoid.NameOcclusion = "NoOcclusion"
                    v.Character.Humanoid.HealthDisplayDistance = 9e9
                    v.Character.Humanoid.HealthDisplayType = "AlwaysOn"
                end
            end
            
            for i,v in pairs(game.Players:GetPlayers()) do
                ApplyESP(v)
                v.CharacterAdded:Connect(function()
                    task.wait(0.33)
                    ApplyESP(v)
                end)
            end
            
            game.Players.PlayerAdded:Connect(function(v)
                ApplyESP(v)
                v.CharacterAdded:Connect(function()
                    task.wait(0.33)
                    ApplyESP(v)
                end)
            end)
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            
            for i, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if not v.Character.HumanoidRootPart:FindFirstChild("Highlight") then
                        local highlightClone = highlight:Clone()
                        highlightClone.Adornee = v.Character
                        highlightClone.Parent = v.Character.HumanoidRootPart
                        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                end
            end
            
            game.Players.PlayerAdded:Connect(function(player)
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if not player.Character.HumanoidRootPart:FindFirstChild("Highlight") then
                        local highlightClone = highlight:Clone()
                        highlightClone.Adornee = player.Character
                        highlightClone.Parent = player.Character.HumanoidRootPart
                    end
                end
            end)
        end
    })
    
    VisualSection:Button({
        Title = "范围修复",
        Callback = function()
            _G.HeadSize = 15
            _G.Disabled = true
            
            game:GetService('RunService').RenderStepped:connect(function()
                if _G.Disabled then
                    for i,v in next, game:GetService('Players'):GetPlayers() do
                        if v.Name ~= game.Players.LocalPlayer.Name and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                            v.Character.HumanoidRootPart.Material = "Neon"
                            v.Character.HumanoidRootPart.CanCollide = false
                        end
                    end
                end
            end)
        end
    })
    
    VisualSection:Textbox({
        Title = "自定义范围大小",
        Default = "15",
        Callback = function(Value)
            _G.HeadSize = tonumber(Value) or 15
            _G.Disabled = true
        end
    })

    -- 工具功能
    local ToolsSection = MainTab:Section({Title = "工具功能", Opened = true})
    
    ToolsSection:Button({
        Title = "Dex抓包工具",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoFenHG/Dex-Explorer/refs/heads/main/Dex-Explorer.lua"))()
        end
    })
    
    ToolsSection:Button({
        Title = "Spy调试工具",
        Callback = function()
            getgenv().Spy="汉化Spy" 
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/spy%E6%B1%89%E5%8C%96%20(1).txt"))()
        end
    })
    
    ToolsSection:Button({
        Title = "指令",
        Callback = function()
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
        end
    })
    
    local SettingsTab = Window:Tab({
        Title = "设置",
        Icon = "settings",
        Locked = false,
    })

    local themeValues = {}
    for name, _ in pairs(WindUI:GetThemes()) do
        table.insert(themeValues, name)
    end

    SettingsTab:Dropdown({
        Title = "更改UI主题",
        Multi = false,
        AllowNone = false,
        Value = nil,
        Values = themeValues,
        Callback = function(theme)
            WindUI:SetTheme(theme)
        end
    }):Select(WindUI:GetCurrentTheme())

    -- 添加关闭UI按钮
    SettingsTab:Button({
        Title = "关闭界面",
        Desc = "隐藏脚本窗口",
        Callback = function()
            if Window then
                Window:Hide()
                isUIOpen = false
            end
        end
    })

    -- 窗口关闭回调
    Window:OnClose(function()
        isUIOpen = false
        print("脚本面板已关闭")
    end)
end

-- 显示欢迎弹窗
local function showWelcome()
    local welcomeMsg = gradientText("科脚本", Color3.fromHex("#FF0000"), Color3.fromHex("#00FF00"))
    
    WindUI:Popup({
        Title = "欢迎使用外挂",
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
                Title = "进入通用",
                Callback = function()
                    if not Window then
                        createWindow()
                    end
                    Window:Show()
                    isUIOpen = true
                end,
                Variant = "Primary"
            }
        }
    })
end

-- 初始化
showWelcome()

-- 添加键盘快捷键控制
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F5 and not gameProcessed then
        if Window then
            if isUIOpen then
                Window:Hide()
                isUIOpen = false
            else
                Window:Show()
                isUIOpen = true
            end
        end
    end
end)

-- 创建FPS显示
local function createFPSDisplay()
    local FpsGui = Instance.new("ScreenGui")
    local FpsLabel = Instance.new("TextLabel")
    
    FpsGui.Name = "FPSGui"
    FpsGui.ResetOnSpawn = false
    FpsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FpsGui.Parent = game.CoreGui
    
    FpsLabel.Name = "FpsLabel"
    FpsLabel.Parent = FpsGui
    FpsLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    FpsLabel.BackgroundTransparency = 1
    FpsLabel.Position = UDim2.new(0.75, 0, 0.010, 0)
    FpsLabel.Size = UDim2.new(0, 133, 0, 30)
    FpsLabel.Font = Enum.Font.GothamSemibold
    FpsLabel.Text = "FPS: 0 | Time: 00:00:00"
    FpsLabel.TextColor3 = Color3.new(1, 1, 1)
    FpsLabel.TextScaled = true
    FpsLabel.TextSize = 14
    FpsLabel.TextWrapped = true
    
    local Heartbeat = game:GetService("RunService").Heartbeat
    local LastIteration, Start = tick(), tick()
    local FrameUpdateTable = {}
    
    Heartbeat:Connect(function()
        LastIteration = tick()
        for Index = #FrameUpdateTable, 1, -1 do
            FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
        end
        FrameUpdateTable[1] = LastIteration
        
        local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
        CurrentFPS = CurrentFPS - CurrentFPS % 1
        
        FpsLabel.Text = string.format("FPS: %d | Time: %s", CurrentFPS, os.date("%H:%M:%S"))
    end)
end

createFPSDisplay()