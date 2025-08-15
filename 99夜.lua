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

-- 获取角色
local function getCharacter()
    local player = game.Players.LocalPlayer
    return player.Character or player.CharacterAdded:Wait()
end

-- 物品配置表（包含所有物品）
local itemConfig = {
    -- 原有物品
    {name = "Log", display = "木头", espColor = Color3.fromRGB(139, 69, 19)},
    {name = "Carrot", display = "胡萝卜", espColor = Color3.fromRGB(255, 165, 0)},
    {name = "Berry", display = "浆果", espColor = Color3.fromRGB(255, 0, 0)},
    {name = "Bolt", display = "螺栓", espColor = Color3.fromRGB(255, 255, 0)},
    {name = "Broken Fan", display = "风扇", espColor = Color3.fromRGB(100, 100, 100)},
    {name = "Coal", display = "煤炭", espColor = Color3.fromRGB(0, 0, 0)},
    {name = "Coin Stack", display = "钱堆", espColor = Color3.fromRGB(255, 215, 0)},
    {name = "Fuel Canister", display = "燃料罐", espColor = Color3.fromRGB(255, 50, 50)},
    {name = "Item Chest", display = "宝箱", espColor = Color3.fromRGB(210, 180, 140)},
    {name = "Old Flashlight", display = "手电筒", espColor = Color3.fromRGB(200, 200, 200)},
    {name = "Old Radio", display = "收音机", espColor = Color3.fromRGB(150, 150, 150)},
    {name = "Rifle Ammo", display = "步枪子弹", espColor = Color3.fromRGB(150, 75, 0)},
    {name = "Revolver Ammo", display = "左轮子弹", espColor = Color3.fromRGB(150, 75, 0)},
    {name = "Sheet Metal", display = "金属板", espColor = Color3.fromRGB(192, 192, 192)},
    {name = "Revolver", display = "左轮", espColor = Color3.fromRGB(75, 75, 75)},
    {name = "Rifle", display = "步枪", espColor = Color3.fromRGB(75, 75, 75)},
    {name = "Bandage", display = "绷带", espColor = Color3.fromRGB(255, 240, 245)},
    {name = "Crossbow Cultist", display = "敌人", espColor = Color3.fromRGB(255, 0, 0)},
    {name = "Bear", display = "熊", espColor = Color3.fromRGB(139, 69, 19)},
    {name = "Alpha Wolf", display = "阿尔法狼", espColor = Color3.fromRGB(128, 128, 128)},
    {name = "Wolf", display = "狼", espColor = Color3.fromRGB(192, 192, 192)},
    {name = "Lost Child", display = "孩子", espColor = Color3.fromRGB(255, 255, 255)},
    -- 新增物品
    {name = "Chair", display = "椅子", espColor = Color3.fromRGB(160, 82, 45)},
    {name = "Tyre", display = "轮胎", espColor = Color3.fromRGB(20, 20, 20)},
    {name = "Alien Chest", display = "外星宝箱", espColor = Color3.fromRGB(0, 255, 0)}
}

-- 篝火坐标
local BONFIRE_POSITION = Vector3.new(0.18914015591144562, 7.830996513366699, -0.3412143290042877)

-- 快速查找物品
local itemCache = {}
local function findItems(itemName)
    if itemCache[itemName] then return itemCache[itemName] end
    
    local found = {}
    local folders = {"ltems", "Items", "MapItems", "WorldItems"}
    
    for _, folderName in ipairs(folders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, item in ipairs(folder:GetDescendants()) do
                if item.Name == itemName and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
                    if primaryPart then
                        table.insert(found, {model = item, part = primaryPart})
                    end
                end
            end
        end
    end
    
    -- 缓存结果5秒
    itemCache[itemName] = found
    delay(5, function() itemCache[itemName] = nil end)
    
    return found
end

-- 传送功能
local function teleportToItem(itemName, displayName)
    local character = getCharacter()
    if not character or not character.PrimaryPart then return end
    
    local items = findItems(itemName)
    if #items == 0 then
        WindUI:Notify({Title = "提示", Content = "未找到"..displayName, Duration = 2})
        return
    end
    
    local closest = nil
    local minDist = math.huge
    local charPos = character.PrimaryPart.Position
    
    for _, item in ipairs(items) do
        local dist = (item.part.Position - charPos).Magnitude
        if dist < minDist then
            minDist = dist
            closest = item.part
        end
    end
    
    if closest then
        character:MoveTo(closest.Position + Vector3.new(0, 3, 0))
        WindUI:Notify({Title = "成功", Content = "已传送到"..displayName, Duration = 2})
    end
end

-- 传送到篝火
local function teleportToBonfire()
    local character = getCharacter()
    if not character or not character.PrimaryPart then return end
    
    character:MoveTo(BONFIRE_POSITION)
    WindUI:Notify({Title = "成功", Content = "已传送回篝火", Duration = 2})
end

-- 透视功能
local function toggleESP(itemName, displayName, color)
    if _G["ESP_"..itemName] then
        -- 关闭透视
        for _, gui in ipairs(_G["ESP_"..itemName].guis) do
            gui:Destroy()
        end
        _G["ESP_"..itemName].conn:Disconnect()
        _G["ESP_"..itemName] = nil
        WindUI:Notify({Title = "提示", Content = "已关闭"..displayName.."透视", Duration = 2})
        return
    end
    
    -- 开启透视
    local items = findItems(itemName)
    _G["ESP_"..itemName] = {guis = {}}
    
    local function createESP(itemPart)
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = itemPart
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 300
        
        local text = Instance.new("TextLabel")
        text.Text = displayName
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Font = Enum.Font.SourceSansBold
        text.TextSize = 18
        text.TextColor3 = color
        text.BackgroundTransparency = 1
        text.TextStrokeTransparency = 0.5
        text.TextStrokeColor3 = Color3.new(0, 0, 0)
        text.Parent = billboard
        
        billboard.Parent = itemPart
        table.insert(_G["ESP_"..itemName].guis, billboard)
    end
    
    -- 现有物品
    for _, item in ipairs(items) do
        createESP(item.part)
    end
    
    -- 新物品监听
    _G["ESP_"..itemName].conn = workspace.DescendantAdded:Connect(function(descendant)
        if descendant.Name == itemName and descendant:IsA("Model") then
            local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart")
            if primaryPart then
                createESP(primaryPart)
            end
        end
    end)
    
    WindUI:Notify({
        Title = "提示", 
        Content = "已开启"..displayName.."透视 ("..#items.."个)", 
        Duration = 2
    })
end

-- 创建主UI的函数（只在点击"进入外挂"后调用）
local function createMainUI()
    -- 创建主窗口
    local Window = WindUI:CreateWindow({
        Title = "科脚本-99夜",
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

    -- 主标签页
    local MainTab = Window:Tab({
        Title = "主功能",
        Icon = "zap",
        Locked = false,
    })

    -- 添加99夜功能按钮
    MainTab:Button({
        Title = "传送回篝火",
        Desc = "传送到固定篝火位置",
        Callback = teleportToBonfire
    })

    -- 添加物品传送按钮
    for _, item in ipairs(itemConfig) do
        MainTab:Button({
            Title = item.display,
            Desc = "传送到"..item.display,
            Callback = function() teleportToItem(item.name, item.display) end
        })
    end

    -- 透视标签页
    local ESPTab = Window:Tab({
        Title = "透视功能",
        Icon = "eye",
        Locked = false,
    })

    -- 添加透视按钮
    for _, item in ipairs(itemConfig) do
        ESPTab:Button({
            Title = item.display,
            Desc = "切换"..item.display.."透视",
            Callback = function() toggleESP(item.name, item.display, item.espColor) end
        })
    end

    -- 设置标签页
    local SettingsTab = Window:Tab({
        Title = "设置",
        Icon = "settings",
        Locked = false,
    })

    -- 主题选择
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

    -- 清理透视按钮
    SettingsTab:Button({
        Title = "清理所有透视",
        Desc = "释放内存并清除所有透视效果",
        Callback = function()
            for _, item in ipairs(itemConfig) do
                if _G["ESP_"..item.name] then
                    for _, gui in ipairs(_G["ESP_"..item.name].guis) do
                        gui:Destroy()
                    end
                    _G["ESP_"..item.name].conn:Disconnect()
                    _G["ESP_"..item.name] = nil
                end
            end
            WindUI:Notify({Title = "提示", Content = "已清理所有透视", Duration = 2})
        end
    })

    Window:OnClose(function()
        print("脚本面板已关闭")
    end)
end

-- 显示欢迎弹窗（主UI只在点击"进入外挂"后创建）
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
                Callback = createMainUI,  -- 点击后才创建主UI
                Variant = "Primary"
            }
        }
    })
end

showWelcome()