-- 使用 WindUI 库
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 渐变文字效果（优化版）
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

-- 获取本地玩家角色的便捷函数
local function getCharacter()
    local player = game.Players.LocalPlayer
    return player.Character or player.CharacterAdded:Wait()
end

-- 欢迎弹窗（已移除退出游戏功能）
local function showWelcome()
    local welcomeMsg = gradientText("Roblox 外挂", Color3.fromHex("#FF0000"), Color3.fromHex("#00FF00"))
    
    WindUI:Popup({
        Title = "欢迎使用外挂",
        Content = "欢迎使用基于 " .. welcomeMsg .. " 的 Roblox 外挂系统",
        Buttons = {
            {
                Title = "取消",
                Callback = function() 
                    print("用户取消了外挂") 
                end,
                Variant = "Secondary"
            },
            {
                Title = "进入外挂",
                Callback = createMainUI,
                Variant = "Primary"
            }
        }
    })
end

-- 主外挂界面
function createMainUI()
    -- 主窗口
    local mainWindow = WindUI:CreateWindow({
        Title = "Roblox 外挂面板",
        Size = UDim2.fromOffset(600, 480),
        Theme = "Dark",
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })

    -- 主要功能区域
    local mainTab = mainWindow:Section({
        Title = "外挂功能",
        Opened = true,
    }):Tab({ Title = "主功能", Icon = "tools" })

    -- 1. 无敌模式开关
    mainTab:Toggle({
        Title = "无敌模式",
        Desc = "开启后角色将不会受到任何伤害",
        Value = false,
        Callback = function(state)
            print("无敌模式: " .. tostring(state))
            -- 这里可以添加无敌模式的实现
        end
    })

    -- 2. 重生角色按钮
    mainTab:Button({
        Title = "重生角色",
        Desc = "立即重置你的角色",
        Callback = function()
            local character = getCharacter()
            if character then
                character:BreakJoints()
                print("角色已重生")
            end
        end
    })

    -- 3. 移动速度设置
    mainTab:Input({
        Title = "设置移动速度",
        Desc = "输入你想要的行走速度值 (16-500)",
        Placeholder = "输入速度...",
        Default = "16",
        Callback = function(speedStr)
            local speed = tonumber(speedStr)
            if speed and speed >= 16 and speed <= 500 then
                local character = getCharacter()
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = speed
                    print("速度设置为: " .. speed)
                end
            else
                print("请输入16到500之间的有效数字")
            end
        end
    })

    -- 4. 快速传送下拉菜单
    local teleportOptions = {
        { Title = "出生点", Callback = function() print("传送到出生点") end },
        { Title = "随机位置", Callback = function() print("传送到随机位置") end }
    }
    
    -- 添加玩家选项（示例）
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(teleportOptions, {
                Title = "玩家: "..player.Name,
                Callback = function() 
                    print("尝试传送到 "..player.Name)
                    -- 这里可以添加传送逻辑
                end
            })
        end
    end
    
    mainTab:Dropdown({
        Title = "快速传送",
        Desc = "选择一个地点或玩家进行传送",
        Options = teleportOptions,
        Default = 1,
        Callback = function(selectedOption)
            if selectedOption.Callback then
                selectedOption.Callback()
            end
        end
    })

    -- 高级功能区域
    local featuresTab = mainWindow:Section({
        Title = "高级功能",
        Opened = false,
    }):Tab({ Title = "参数", Icon = "settings" })

    -- 跳跃高度设置
    featuresTab:Input({
        Title = "设置跳跃高度",
        Desc = "输入你想要的跳跃力量值 (50-1000)",
        Placeholder = "输入跳跃高度...",
        Default = "50",
        Callback = function(jumpStr)
            local jump = tonumber(jumpStr)
            if jump and jump >= 50 and jump <= 1000 then
                local character = getCharacter()
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.JumpPower = jump
                    print("跳跃高度设置为: " .. jump)
                end
            else
                print("请输入50到1000之间的有效数字")
            end
        end
    })

    -- 隐身模式开关
    featuresTab:Toggle({
        Title = "隐身模式",
        Desc = "开启后你的角色模型将变得透明",
        Value = false,
        Callback = function(state)
            local character = getCharacter()
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = state and 0.8 or 0
                    end
                end
                print("隐身模式: " .. tostring(state))
            end
        end
    })

    -- 自动拾取开关
    featuresTab:Toggle({
        Title = "自动拾取",
        Desc = "自动拾取附近地上的物品",
        Value = false,
        Callback = function(state)
            print("自动拾取: " .. tostring(state))
            -- 这里可以添加自动拾取逻辑
        end
    })

    -- 关闭窗口时的清理
    mainWindow:OnClose(function()
        -- 恢复默认设置
        local character = getCharacter()
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
            character.Humanoid.JumpPower = 50
        end
        print("外挂面板已关闭")
    end)
end

-- 启动外挂界面
showWelcome()