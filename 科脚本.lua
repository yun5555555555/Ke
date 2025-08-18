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

-- 创建主窗口
local function createWindow()
    Window = WindUI:CreateWindow({
        Title = "科脚本-洛天依",
        Icon = "zap",
        IconThemed = true,
        Author = "作者qq:2875456271",
        Folder = "KeScript",
        Size = UDim2.fromOffset(300, 240),
        Transparent = true,
        Theme = "Dark",
        User = {
            Enabled = true,
            Callback = function() print("点击用户信息") end,
            Anonymous = true
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true
    })

    -- 主功能标签页
    local MainTab = Window:Tab({
        Title = "主功能",
        Icon = "zap",
        Locked = false,
    })
    
    MainTab:Button({
        Title = "通用",
        Desc = "加载通用",
        Callback = function()
            local success = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/yun5555555555/Ke/refs/heads/main/%E9%80%9A%E7%94%A8.lua"))()
            end)
            WindUI:Notify({
                Title = "通用",
                Content = success and "加载成功" or "加载失败",
                Duration = 3
            })
        end
    })

    MainTab:Button({
        Title = "99夜脚本",
        Desc = "加载99夜游戏脚本",
        Callback = function()
            local success = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/yun5555555555/Ke/refs/heads/main/99%E5%A4%9C.lua"))()
            end)
            WindUI:Notify({
                Title = "99夜脚本",
                Content = success and "加载成功" or "加载失败",
                Duration = 3
            })
        end
    })

    MainTab:Button({
        Title = "恐鬼症脚本",
        Desc = "加载恐鬼症游戏脚本",
        Callback = function()
            local success = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/yun5555555555/Ke/refs/heads/main/%E9%AC%BC.lua"))()
            end)
            WindUI:Notify({
                Title = "恐鬼症脚本",
                Content = success and "加载成功" or "加载失败",
                Duration = 3
            })
        end
    })
    
    MainTab:Button({
        Title = "doors",
        Desc = "将要更新",
        Callback = function()
            local success = pcall(function()
                
            end)
            WindUI:Notify({
                Title = "doors未更新",
                Content = success and "加载成功" or "加载失败",
                Duration = 3
            })
        end
    })

    -- 设置标签页
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
                Title = "进入外挂",
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