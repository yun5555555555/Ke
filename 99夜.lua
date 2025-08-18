local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/china-ui/refs/heads/main/main%20(2).lua"))()

-- 全局服务引用
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- 本地玩家引用
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

-- 功能状态
local Features = {
    KillAura = false,
    AutoChop = false,
    AutoEat = false,
    ChildESP = false,
    ChestESP = false,
    InstantInteract = false
}

-- 黑名单
local Blacklist = {}

-- 客户端模块
local ClientModule
local EatRemote
local function GetClientModule()
    if not ClientModule then
        ClientModule = require(LP:WaitForChild("PlayerScripts"):WaitForChild("Client"))
        EatRemote = ClientModule and ClientModule.Events and ClientModule.Events.RequestConsumeItem
    end
    return ClientModule, EatRemote
end

-- 优化后的ESP功能
local ESPHandles = {}

local function AddESP(target, name, distance, enabled)
    if not target or not target:IsDescendantOf(Workspace) then return end
    
    local rootPart = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
    if not rootPart then return end

    -- 如果已经存在ESP则更新
    if ESPHandles[target] then
        ESPHandles[target].billboard.Enabled = enabled
        if enabled then
            ESPHandles[target].billboard.TextLabel.Text = name .. "\n" .. math.floor(distance) .. "m"
        end
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..name
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0, 100, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = enabled
    billboard.MaxDistance = 150
    billboard.Parent = rootPart

    local label = Instance.new("TextLabel")
    label.Text = name .. "\n" .. math.floor(distance) .. "m"
    label.Size = UDim2.new(1, 0, 0, 40)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.3
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard
    
    if name:match("Chest") then
        local image = Instance.new("ImageLabel")
        image.Position = UDim2.new(0, 20, 0, 40)
        image.Size = UDim2.new(0, 60, 0, 60)
        image.Image = "rbxassetid://18660563116"
        image.BackgroundTransparency = 1
        image.Parent = billboard
    end

    ESPHandles[target] = {
        billboard = billboard,
        connection = target.AncestryChanged:Connect(function()
            if not target:IsDescendantOf(Workspace) then
                if ESPHandles[target] then
                    ESPHandles[target].billboard:Destroy()
                    ESPHandles[target].connection:Disconnect()
                    ESPHandles[target] = nil
                end
            end
        end)
    }
end

-- 清除所有ESP
local function ClearAllESP()
    for target, data in pairs(ESPHandles) do
        if data.billboard then
            data.billboard:Destroy()
        end
        if data.connection then
            data.connection:Disconnect()
        end
    end
    ESPHandles = {}
    WindUI:Notify({Title = "提示", Content = "已清除所有透视", Duration = 2})
end

-- 优化后的自动进食功能
local function TryEatFood(food)
    local _, remote = GetClientModule()
    if not remote then 
        WindUI:Notify({Title = "错误", Content = "无法获取进食远程函数", Duration = 5})
        return 
    end

    if not ReplicatedStorage:FindFirstChild("TempStorage") then
        WindUI:Notify({Title = "错误", Content = "找不到临时存储", Duration = 5})
        return
    end

    -- 复制物品到临时存储
    local foodClone = food:Clone()
    foodClone.Parent = ReplicatedStorage.TempStorage
    
    local success, result = pcall(function()
        return remote:InvokeServer(foodClone)
    end)

    if success and result and result.Success then
        WindUI:Notify({Title = "提示", Content = "✅成功吃下 " .. food.Name, Duration = 5})
    else
        WindUI:Notify({Title = "提示", Content = "❌️进食失败", Duration = 5})
    end
    
    -- 删除克隆体
    foodClone:Destroy()
end

-- 物品配置
local itemConfig = {
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
    {name = "Chair", display = "椅子", espColor = Color3.fromRGB(160, 82, 45)},
    {name = "Tyre", display = "轮胎", espColor = Color3.fromRGB(20, 20, 20)},
    {name = "Alien Chest", display = "外星宝箱", espColor = Color3.fromRGB(0, 255, 0)},
    {name = "Leather Body", display = "皮革", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Thorn Body", display = "荆棘铠甲", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Iron Body", display = "铁甲", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Chest", display = "宝箱", espColor = Color3.fromRGB(210, 180, 140)},
    {name = "Lost Child", display = "走失的孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Lost Child1", display = "走失的孩子1", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Lost Child2", display = "走失的孩子2", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Lost Child3", display = "走失的孩子3", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Dino Kid", display = "恐龙孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "kraken kid", display = "海怪孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Squid kid", display = "鱿鱼孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Koala Kid", display = "考拉孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "koala", display = "考拉", espColor = Color3.fromRGB(0, 255, 255)}
}

local BONFIRE_POSITION = Vector3.new(0.189, 7.831, -0.341)

-- 优化后的物品查找功能
local function findItems(itemName)
    local found = {}
    local folders = {"ltems", "Items", "MapItems", "WorldItems"}
    
    for _, folderName in ipairs(folders) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, item in ipairs(folder:GetDescendants()) do
                if item.Name == itemName and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChild("Handle")
                    if primaryPart then
                        table.insert(found, {model = item, part = primaryPart})
                    end
                end
            end
        end
    end
    
    return found
end

-- 优化后的传送功能
local function teleportToItem(itemName, displayName)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        WindUI:Notify({Title = "错误", Content = "角色未准备好", Duration = 2})
        return
    end
    
    local items = findItems(itemName)
    if #items == 0 then
        WindUI:Notify({Title = "提示", Content = "未找到"..displayName, Duration = 2})
        return
    end
    
    local closest = nil
    local minDist = math.huge
    local charPos = Character.HumanoidRootPart.Position
    
    for _, item in ipairs(items) do
        local dist = (item.part.Position - charPos).Magnitude
        if dist < minDist then
            minDist = dist
            closest = item.part
        end
    end
    
    if closest then
        Character:MoveTo(closest.Position + Vector3.new(0, 3, 0))
        WindUI:Notify({Title = "成功", Content = "已传送到"..displayName, Duration = 2})
    end
end

-- 优化后的篝火传送
local function teleportToBonfire()
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        WindUI:Notify({Title = "错误", Content = "角色未准备好", Duration = 2})
        return
    end
    
    Character:MoveTo(BONFIRE_POSITION)
    WindUI:Notify({Title = "成功", Content = "已传送回篝火", Duration = 2})
end

-- 优化后的物品召回功能（使用RequestStartDraggingItem远程事件）
local function teleportItemsToPlayer(itemName, displayName)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        WindUI:Notify({Title = "错误", Content = "角色未准备好", Duration = 2})
        return
    end
    
    local items = findItems(itemName)
    if #items == 0 then
        WindUI:Notify({Title = "提示", Content = "未找到"..displayName, Duration = 2})
        return
    end
    
    local charPos = Character.HumanoidRootPart.Position
    local radius = 5
    local angleStep = (2 * math.pi) / #items
    
    -- 检查远程事件是否存在
    local dragEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") and 
                     ReplicatedStorage.RemoteEvents:FindFirstChild("RequestStartDraggingItem")
    
    if not dragEvent then
        WindUI:Notify({Title = "错误", Content = "找不到拖拽物品的远程事件", Duration = 2})
        return
    end
    
    -- 逐个召回物品
    for i, item in ipairs(items) do
        local angle = angleStep * i
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        local targetPos = charPos + Vector3.new(x, 0, z)
        
        -- 使用远程事件召回物品
        local args = {
            [1] = item.model
        }
        dragEvent:FireServer(unpack(args))
        
        -- 短暂延迟确保物品被正确抓取
        task.wait(0.1)
        
        -- 模拟释放物品到目标位置
        if item.model:FindFirstChild("Handle") then
            item.model.Handle.CFrame = CFrame.new(targetPos)
        elseif item.part then
            item.part.CFrame = CFrame.new(targetPos)
        end
    end
    
    WindUI:Notify({
        Title = "成功", 
        Content = "已将"..#items.."个"..displayName.."传送到你旁边", 
        Duration = 2
    })
end

-- 优化后的ESP切换功能
local function toggleESP(itemName, displayName, color)
    -- 如果已经存在则关闭
    if _G["ESP_"..itemName] then
        for _, gui in ipairs(_G["ESP_"..itemName].guis) do
            if gui then
                gui:Destroy()
            end
        end
        if _G["ESP_"..itemName].conn then
            _G["ESP_"..itemName].conn:Disconnect()
        end
        _G["ESP_"..itemName] = nil
        WindUI:Notify({Title = "提示", Content = "已关闭"..displayName.."透视", Duration = 2})
        return
    end
    
    local items = findItems(itemName)
    _G["ESP_"..itemName] = {guis = {}}
    
    local function createESP(itemPart)
        if not itemPart or not itemPart:IsDescendantOf(Workspace) then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_"..itemName
        billboard.Adornee = itemPart
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 150
        
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
        
        -- 添加监听器，当物品被移除时清除ESP
        local conn = itemPart.AncestryChanged:Connect(function()
            if not itemPart:IsDescendantOf(Workspace) then
                if billboard then
                    billboard:Destroy()
                end
                if conn then
                    conn:Disconnect()
                end
            end
        end)
    end
    
    for _, item in ipairs(items) do
        createESP(item.part)
    end
    
    -- 监听新生成的物品
    _G["ESP_"..itemName].conn = Workspace.DescendantAdded:Connect(function(descendant)
        if descendant.Name == itemName and descendant:IsA("Model") then
            local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChild("Handle")
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

-- 优化后的自动功能主循环
local lastKillAura, lastAutoChop, lastAutoEat = 0, 0, 0
local connection
RunService.Heartbeat:Connect(function()
    local now = tick()
    
    -- 检查角色是否有效
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        Character = LP.Character or LP.CharacterAdded:Wait()
        return
    end
    
    -- 瞬间互动
    if Features.InstantInteract then
        if not connection then
            connection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                if prompt then
                    prompt.HoldDuration = 0
                    fireproximityprompt(prompt)
                end
            end)
        end
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end

    -- 杀戮光环
    if Features.KillAura and now - lastKillAura >= 0.7 then
        lastKillAura = now
        if Character:FindFirstChild("ToolHandle") then
            local tool = Character.ToolHandle.OriginalItem.Value
            if tool and ({["Old Axe"] = true, ["Good Axe"] = true, ["Spear"] = true, ["Hatchet"] = true, ["Bone Club"] = true})[tool.Name] then
                for _, target in next, Workspace.Characters:GetChildren() do
                    if target:IsA("Model") and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("HitRegisters") then
                        local distance = (Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
                        if distance <= 100 then
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(target, tool, true, Character.HumanoidRootPart.CFrame)
                        end
                    end
                end
            end
        end
    end

    -- 自动砍树
    if Features.AutoChop and now - lastAutoChop >= 0.7 then
        lastAutoChop = now
        if Character:FindFirstChild("ToolHandle") then
            local tool = Character.ToolHandle.OriginalItem.Value
            if tool and ({["Old Axe"] = true, ["Stone Axe"] = true, ["Iron Axe"] = true})[tool.Name] then
                local function ChopTree(path)
                    for _, tree in next, path:GetChildren() do
                        task.wait(.1)
                        if tree:IsA("Model") and ({["Small Tree"] = true, ["TreeBig1"] = true, ["TreeBig2"] = true, ["TreeBig3"] = true})[tree.Name] and tree:FindFirstChild("HitRegisters") then
                            local trunk = tree:FindFirstChild("Trunk") or tree:FindFirstChild("HumanoidRootPart") or tree.PrimaryPart
                            if trunk then
                                local distance = (Character.HumanoidRootPart.Position - trunk.Position).Magnitude
                                if distance <= 100 then
                                    ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(tree, tool, true, Character.HumanoidRootPart.CFrame)
                                end
                            end
                        end
                    end
                end
                ChopTree(Workspace.Map.Foliage)
                ChopTree(Workspace.Map.Landmarks)
            end
        end
    end

    -- 自动进食
    if Features.AutoEat and now - lastAutoEat >= 10 then
        lastAutoEat = now
        local foundFood = false
        for _, obj in pairs(Workspace.Items:GetChildren()) do
            if obj:IsA("Model") and ({["Carrot"] = true, ["Berry"] = true, ["Morsel"] = false, ["Cooked Morsel"] = true, ["Steak"] = false, ["Cooked Steak"] = true})[obj.Name] then
                local mainPart = obj:FindFirstChild("Handle") or obj.PrimaryPart
                if mainPart then
                    local distance = (mainPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance < 25 then
                        foundFood = true
                        TryEatFood(obj)
                        break
                    end
                end
            end
        end
        if not foundFood then
            WindUI:Notify({Title = "提示", Content = "25米范围内无食物", Duration = 5})
        end
    end

    -- ESP更新
    if Features.ChestESP then
        for _, chest in next, Workspace.Items:GetChildren() do
            if chest.Name:match("Chest") and chest:IsA("Model") and not table.find(Blacklist, chest) and chest:FindFirstChild("Main") then
                local distance = (Character.HumanoidRootPart.Position - chest.Main.Position).Magnitude
                AddESP(chest, "宝箱", distance, true)
            end
        end
    end

    if Features.ChildESP then
        for _, child in next, Workspace.Characters:GetChildren() do
            if table.find({"Lost Child", "Lost Child1", "Lost Child2", "Lost Child3", "Dino Kid", "kraken kid", "Squid kid", "Koala Kid", "koala"}, child.Name) 
               and child:FindFirstChild("HumanoidRootPart") and not table.find(Blacklist, child) then
                local distance = (Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude
                AddESP(child, "孩子", distance, true)
            end
        end
    end
end)

-- 玩家列表管理
local PlayerList = {}
local function UpdatePlayerList()
    PlayerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(PlayerList, player.Name)
    end
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- 创建UI窗口
local function createWindow()
    Window = WindUI:CreateWindow({
        Title = "99夜脚本-优化版",
        Icon = "zap",
        IconThemed = true,
        Author = "科脚本",
        Folder = "99NightScript",
        Size = UDim2.fromOffset(300, 300),
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
    local MainTab = Window:Tab({Title = "主要功能", Icon = "zap"})

    MainTab:Toggle({
        Title = "杀戮光环",
        Description = "自动攻击附近敌人(100米)",
        Value = false,
        Callback = function(value)
            Features.KillAura = value
            WindUI:Notify({
                Title = "提示",
                Content = value and "已开启杀戮光环" or "已关闭杀戮光环",
                Duration = 2
            })
        end
    })

    MainTab:Toggle({
        Title = "自动砍树",
        Description = "自动砍伐附近树木(100米)",
        Value = false,
        Callback = function(value)
            Features.AutoChop = value
            WindUI:Notify({
                Title = "提示",
                Content = value and "已开启自动砍树" or "已关闭自动砍树",
                Duration = 2
            })
        end
    })

    MainTab:Toggle({
        Title = "自动进食",
        Description = "自动吃附近食物(25米)",
        Value = false,
        Callback = function(value)
            Features.AutoEat = value
            WindUI:Notify({
                Title = "提示",
                Content = value and "已开启自动进食" or "已关闭自动进食",
                Duration = 2
            })
        end
    })

    MainTab:Toggle({
        Title = "瞬间互动",
        Description = "立即完成所有互动",
        Value = false,
        Callback = function(value)
            Features.InstantInteract = value
            WindUI:Notify({
                Title = "提示",
                Content = value and "已开启瞬间互动" or "已关闭瞬间互动",
                Duration = 2
            })
        end
    })

    MainTab:Button({
        Title = "传送回篝火",
        Description = "传送到篝火位置",
        Callback = teleportToBonfire
    })

    -- 透视功能标签页
    local ESPTab = Window:Tab({Title = "透视功能", Icon = "eye"})

    ESPTab:Toggle({
        Title = "宝箱透视",
        Description = "显示所有宝箱位置",
        Value = false,
        Callback = function(value)
            Features.ChestESP = value
            WindUI:Notify({
                Title = "提示",
                Content = value and "已开启宝箱透视" or "已关闭宝箱透视",
                Duration = 2
            })
        end
    })

    ESPTab:Toggle({
        Title = "走失的孩子透视",
        Description = "显示所有走失的孩子",
        Value = false,
        Callback = function(value)
            Features.ChildESP = value
            WindUI:Notify({
                Title = "提示",
                Content = value and "已开启孩子透视" or "已关闭孩子透视",
                Duration = 2
            })
        end
    })
    
    -- 添加物品透视按钮
    for _, item in ipairs(itemConfig) do
        ESPTab:Button({
            Title = item.display.."透视",
            Description = "切换"..item.display.."的透视",
            Callback = function() 
                toggleESP(item.name, item.display, item.espColor) 
            end
        })
    end

    -- 传送功能标签页
    local TeleportTab = Window:Tab({Title = "传送功能", Icon = "map-pin"})
    
    -- 玩家传送
    TeleportTab:Dropdown({
        Title = "传送玩家",
        Description = "选择要传送到的玩家",
        Values = PlayerList,
        Callback = function(selected)
            local target = Players[selected]
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Character:PivotTo(target.Character.HumanoidRootPart.CFrame)
                WindUI:Notify({
                    Title = "成功",
                    Content = "已传送到玩家 "..selected,
                    Duration = 2
                })
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "无法传送到该玩家",
                    Duration = 2
                })
            end
        end
    })
    
    -- 物品传送
    for _, item in ipairs(itemConfig) do
        TeleportTab:Button({
            Title = "传送到"..item.display,
            Description = "传送到最近的"..item.display,
            Callback = function()
                teleportToItem(item.name, item.display)
            end
        })
    end

    -- 收集功能标签页
    local CollectTab = Window:Tab({Title = "收集功能", Icon = "package"})
    
    for _, item in ipairs(itemConfig) do
        CollectTab:Button({
            Title = "召唤"..item.display,
            Description = "将附近"..item.display.."传送到你身边",
            Callback = function()
                teleportItemsToPlayer(item.name, item.display)
            end
        })
    end

    -- 设置标签页
    local SettingsTab = Window:Tab({Title = "设置", Icon = "settings"})

    -- 主题选择
    local themes = {}
    for name in pairs(WindUI:GetThemes()) do
        table.insert(themes, name)
    end

    SettingsTab:Dropdown({
        Title = "界面主题",
        Description = "更改UI主题颜色",
        Values = themes,
        Callback = function(theme)
            WindUI:SetTheme(theme)
            WindUI:Notify({
                Title = "提示",
                Content = "已切换主题为 "..theme,
                Duration = 2
            })
        end
    })

    SettingsTab:Button({
        Title = "清除所有透视",
        Description = "关闭所有透视效果",
        Callback = ClearAllESP
    })

    SettingsTab:Button({
        Title = "重新加载脚本",
        Description = "重新加载所有功能",
        Callback = function()
            WindUI:Notify({
                Title = "提示",
                Content = "正在重新加载脚本...",
                Duration = 2
            })
            wait(1)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/99night-script/main/optimized.lua"))()
        end
    })
end

-- 欢迎弹窗
WindUI:Popup({
    Title = "欢迎使用99夜优化脚本",
    Content = "已修复所有已知问题，请享受游戏！",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary"
        },
        {
            Title = "开始使用",
            Callback = createWindow,
            Variant = "Primary"
        }
    }
})