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
    return player.Character or player.CharacterAdded:Wait()
end

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
                Callback = createMainUI,
                Variant = "Primary"
            }
        }
    })
end

function createMainUI()
    local mainWindow = WindUI:CreateWindow({
        Title = "科脚本-洛天依",
        Size = UDim2.fromOffset(600, 480),
        Theme = "Dark",
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })

    local mainSection = mainWindow:Section({
        Title = "主要功能",
        Opened = true
    })
    
    local mainTab = mainSection:Tab({ Title = "玩家传送", Icon = "map-pin" })

    mainTab:Button({
        Title = "木头",
        Desc = "传送木头",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Log" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的木头", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到木头", Duration = 3})
            end
        end
    })

    mainTab:Button({
        Title = "胡萝卜",
        Desc = "传送胡萝卜",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Carrot" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的胡萝卜", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到胡萝卜", Duration = 3})
            end
        end
    })

   mainTab:Button({
        Title = "浆果",
        Desc = "传送浆果",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Berry" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的浆果", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到浆果", Duration = 3})
            end
        end
    })

    mainTab:Button({
        Title = "螺栓",
        Desc = "传送螺栓",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Bolt" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的螺栓", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到螺栓", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "风扇",
        Desc = "传送风扇",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Broken Fan" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的风扇", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到风扇", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "煤炭",
        Desc = "传送煤炭",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Coal" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的煤炭", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到煤炭", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "钱堆",
        Desc = "传送钱堆",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Coin Stack" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的钱堆", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到钱堆", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "燃料罐",
        Desc = "传送燃料罐",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Fule Canister" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的燃料罐", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到燃料罐", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "宝箱",
        Desc = "传送宝箱",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "ltem Chest" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的宝箱", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到宝箱", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "手电筒",
        Desc = "传送手电筒",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Old Flashlight" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的手电筒", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到手电筒", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "收音机",
        Desc = "传送收音机",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Old Radio" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的收音机", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到收音机", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "步枪子弹",
        Desc = "传送步枪子弹",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Rifle Ammo" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的步枪子弹", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到螺栓", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "左轮子弹",
        Desc = "传送左轮子弹",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Revolver Ammo" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的左轮子弹", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到左轮子弹", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "金属板",
        Desc = "传送金属板",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Sheet Metal" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的金属板", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到金属板", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "左轮r",
        Desc = "传送左轮",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Revolver" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的左轮", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到左轮", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "步枪,
        Desc = "传送步枪",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Rifle" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的步枪", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到步枪", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "绷带",
        Desc = "传送绷带",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Bandage" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的螺栓", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到螺栓", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "敌人",
        Desc = "传送敌人",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Crossbow Cultist" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的敌人", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到螺栓", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "熊",
        Desc = "传送熊",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Beart" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的熊", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到熊", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "阿尔法狼",
        Desc = "传送阿尔法狼",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Alpha Wolf" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的阿尔法狼", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到阿尔法狼", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "狼",
        Desc = "传送狼",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Wolf" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的螺栓", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到螺栓", Duration = 3})
            end
        end
    })
    
    mainTab:Button({
        Title = "孩子",
        Desc = "传送孩子",
        Callback = function()
            local character = getCharacter()
            if not character or not character.PrimaryPart then
                WindUI:Notify({Title = "错误", Content = "无法获取角色", Duration = 3})
                return
            end
            
            local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
            if not itemsFolder then
                WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
                return
            end
            
            local closestLog = nil
            local closestDistance = math.huge
            local charPos = character.PrimaryPart.Position
            
            for _, item in ipairs(itemsFolder:GetDescendants()) do
                if item.Name == "Lost Child" and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local distance = (primaryPart.Position - charPos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestLog = primaryPart
                        end
                    end
                end
            end
            
            if closestLog then
                character:MoveTo(closestLog.Position + Vector3.new(0, 3, 0))
                WindUI:Notify({Title = "传送成功", Content = "已传送到最近的螺栓", Duration = 3})
            else
                WindUI:Notify({Title = "错误", Content = "未找到螺栓", Duration = 3})
            end
        end
    })
    
    local wupTab = mainSection:Tab({ Title = "物品传送", Icon = "map-pin" })
    
    
    
    
    
    local toushiTab = mainSection:Tab({ Title = "物品透视", Icon = "map-pin" })
    
   toushiTab:Button({
    Title = "木头",
    Desc = "透视木头",
    Callback = function()
        if _G.BoltHighlights then
            for _, highlight in pairs(_G.BoltHighlights) do
                highlight:Destroy()
            end
            _G.BoltHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭螺栓透视", Duration = 3})
            return
        end

        _G.BoltHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.BoltHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Log" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.BoltConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Log" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启木头透视", Duration = 3})
    end
})
    
toushiTab:Button({
    Title = "浆果",
    Desc = "透视浆果",
    Callback = function()
        if _G.BerryHighlights then
            for _, highlight in pairs(_G.BerryHighlights) do
                highlight:Destroy()
            end
            _G.BerryHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭浆果透视", Duration = 3})
            return
        end

        _G.BerryHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.BerryHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Berry" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.BerryConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Berry" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启浆果透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "螺栓",
    Desc = "透视螺栓",
    Callback = function()
        if _G.BoltHighlights then
            for _, highlight in pairs(_G.BoltHighlights) do
                highlight:Destroy()
            end
            _G.BoltHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭螺栓透视", Duration = 3})
            return
        end

        _G.BoltHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.BoltHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Bolt" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.BoltConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Bolt" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启螺栓透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "坏掉的风扇",
    Desc = "透视坏掉的风扇",
    Callback = function()
        if _G.BrokenFanHighlights then
            for _, highlight in pairs(_G.BrokenFanHighlights) do
                highlight:Destroy()
            end
            _G.BrokenFanHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭坏掉的风扇透视", Duration = 3})
            return
        end

        _G.BrokenFanHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.BrokenFanHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Broken Fan" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.BrokenFanConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Broken Fan" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启坏掉的风扇透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "胡萝卜",
    Desc = "透视胡萝卜",
    Callback = function()
        if _G.CarrotHighlights then
            for _, highlight in pairs(_G.CarrotHighlights) do
                highlight:Destroy()
            end
            _G.CarrotHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭胡萝卜透视", Duration = 3})
            return
        end

        _G.CarrotHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.CarrotHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Carrot" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.CarrotConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Carrot" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启胡萝卜透视", Duration = 3})
    end
})
            
toushiTab:Button({
    Title = "煤炭",
    Desc = "透视煤炭",
    Callback = function()
        if _G.CoalHighlights then
            for _, highlight in pairs(_G.CoalHighlights) do
                highlight:Destroy()
            end
            _G.CoalHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭煤炭透视", Duration = 3})
            return
        end

        _G.CoalHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.CoalHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Coal" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.CoalConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Coal" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启煤炭透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "钱币堆",
    Desc = "透视钱币堆",
    Callback = function()
        if _G.CoinStackHighlights then
            for _, highlight in pairs(_G.CoinStackHighlights) do
                highlight:Destroy()
            end
            _G.CoinStackHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭钱币堆透视", Duration = 3})
            return
        end

        _G.CoinStackHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.CoinStackHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Coin Stack" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.CoinStackConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Coin Stack" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启钱币堆透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "燃料罐",
    Desc = "透视燃料罐",
    Callback = function()
        if _G.FuleCanisterHighlights then
            for _, highlight in pairs(_G.FuleCanisterHighlights) do
                highlight:Destroy()
            end
            _G.FuleCanisterHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭燃料罐透视", Duration = 3})
            return
        end

        _G.FuleCanisterHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.FuleCanisterHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Fule Canister" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.FuleCanisterConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Fule Canister" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启燃料罐透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "物品箱",
    Desc = "透视物品箱",
    Callback = function()
        if _G.ltemChestHighlights then
            for _, highlight in pairs(_G.ltemChestHighlights) do
                highlight:Destroy()
            end
            _G.ltemChestHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭物品箱透视", Duration = 3})
            return
        end

        _G.ltemChestHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.ltemChestHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "ltem Chest" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.ltemChestConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "ltem Chest" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启物品箱透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "木头/原木",
    Desc = "透视木头/原木",
    Callback = function()
        if _G.LogHighlights then
            for _, highlight in pairs(_G.LogHighlights) do
                highlight:Destroy()
            end
            _G.LogHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭木头/原木透视", Duration = 3})
            return
        end

        _G.LogHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.LogHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Log" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.LogConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Log" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启木头/原木透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "旧手电筒",
    Desc = "透视旧手电筒",
    Callback = function()
        if _G.OldFlashlightHighlights then
            for _, highlight in pairs(_G.OldFlashlightHighlights) do
                highlight:Destroy()
            end
            _G.OldFlashlightHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭旧手电筒透视", Duration = 3})
            return
        end

        _G.OldFlashlightHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.OldFlashlightHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Old Flashlight" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.OldFlashlightConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Old Flashlight" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启旧手电筒透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "旧收音机",
    Desc = "透视旧收音机",
    Callback = function()
        if _G.OldRadioHighlights then
            for _, highlight in pairs(_G.OldRadioHighlights) do
                highlight:Destroy()
            end
            _G.OldRadioHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭旧收音机透视", Duration = 3})
            return
        end

        _G.OldRadioHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.OldRadioHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Old Radio" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.OldRadioConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Old Radio" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启旧收音机透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "左轮手枪弹药",
    Desc = "透视左轮手枪弹药",
    Callback = function()
        if _G.RevolverAmmoHighlights then
            for _, highlight in pairs(_G.RevolverAmmoHighlights) do
                highlight:Destroy()
            end
            _G.RevolverAmmoHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭左轮手枪弹药透视", Duration = 3})
            return
        end

        _G.RevolverAmmoHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.RevolverAmmoHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Revolver Ammo" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.RevolverAmmoConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Revolver Ammo" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启左轮手枪弹药透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "步枪弹药",
    Desc = "透视步枪弹药",
    Callback = function()
        if _G.RifleAmmoHighlights then
            for _, highlight in pairs(_G.RifleAmmoHighlights) do
                highlight:Destroy()
            end
            _G.RifleAmmoHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭步枪弹药透视", Duration = 3})
            return
        end

        _G.RifleAmmoHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.RifleAmmoHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Rifle Ammo" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.RifleAmmoConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Rifle Ammo" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启步枪弹药透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "金属板",
    Desc = "透视金属板",
    Callback = function()
        if _G.SheetMetalHighlights then
            for _, highlight in pairs(_G.SheetMetalHighlights) do
                highlight:Destroy()
            end
            _G.SheetMetalHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭金属板透视", Duration = 3})
            return
        end

        _G.SheetMetalHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.SheetMetalHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Sheet Metal" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.SheetMetalConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Sheet Metal" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启金属板透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "左轮手枪",
    Desc = "透视左轮手枪",
    Callback = function()
        if _G.RevolverHighlights then
            for _, highlight in pairs(_G.RevolverHighlights) do
                highlight:Destroy()
            end
            _G.RevolverHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭左轮手枪透视", Duration = 3})
            return
        end

        _G.RevolverHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.RevolverHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Revolver" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.RevolverConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Revolver" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启左轮手枪透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "步枪",
    Desc = "透视步枪",
    Callback = function()
        if _G.RifleHighlights then
            for _, highlight in pairs(_G.RifleHighlights) do
                highlight:Destroy()
            end
            _G.RifleHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭步枪透视", Duration = 3})
            return
        end

        _G.RifleHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.RifleHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Rifle" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.RifleConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Rifle" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启步枪透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "绷带",
    Desc = "透视绷带",
    Callback = function()
        if _G.BandageHighlights then
            for _, highlight in pairs(_G.BandageHighlights) do
                highlight:Destroy()
            end
            _G.BandageHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭绷带透视", Duration = 3})
            return
        end

        _G.BandageHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.BandageHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Bandage" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.BandageConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Bandage" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启绷带透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "北极狐",
    Desc = "透视北极狐",
    Callback = function()
        if _G.ArcticFoxHighlights then
            for _, highlight in pairs(_G.ArcticFoxHighlights) do
                highlight:Destroy()
            end
            _G.ArcticFoxHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭北极狐透视", Duration = 3})
            return
        end

        _G.ArcticFoxHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.ArcticFoxHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Arctic Fox" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.ArcticFoxConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Arctic Fox" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启北极狐透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "十字弓邪教徒",
    Desc = "透视十字弓邪教徒",
    Callback = function()
        if _G.CrossbowCultistHighlights then
            for _, highlight in pairs(_G.CrossbowCultistHighlights) do
                highlight:Destroy()
            end
            _G.CrossbowCultistHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭十字弓邪教徒透视", Duration = 3})
            return
        end

        _G.CrossbowCultistHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.CrossbowCultistHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Crossbow Cultist" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.CrossbowCultistConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Crossbow Cultist" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启十字弓邪教徒透视", Duration = 3})
    end
})


toushiTab:Button({
    Title = "迷路的孩子",
    Desc = "透视迷路的孩子",
    Callback = function()
        if _G.LostChildHighlights then
            for _, highlight in pairs(_G.LostChildHighlights) do
                highlight:Destroy()
            end
            _G.LostChildHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭迷路的孩子透视", Duration = 3})
            return
        end

        _G.LostChildHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.LostChildHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Lost Child" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.LostChildConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Lost Child" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启迷路的孩子透视", Duration = 3})
    end
})
            
toushiTab:Button({
    Title = "阿尔法狼",
    Desc = "透视阿尔法狼",
    Callback = function()
        if _G.CrossbowCultistHighlights then
            for _, highlight in pairs(_G.CrossbowCultistHighlights) do
                highlight:Destroy()
            end
            _G.CrossbowCultistHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭阿尔法狼透视", Duration = 3})
            return
        end

        _G.CrossbowCultistHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.CrossbowCultistHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Alpha Wolf" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.CrossbowCultistConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Alpha Wolf" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启阿尔法狼透视", Duration = 3})
    end
})

toushiTab:Button({
    Title = "熊",
    Desc = "透视熊",
    Callback = function()
        if _G.CrossbowCultistHighlights then
            for _, highlight in pairs(_G.CrossbowCultistHighlights) do
                highlight:Destroy()
            end
            _G.CrossbowCultistHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭熊透视", Duration = 3})
            return
        end

        _G.CrossbowCultistHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.CrossbowCultistHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Bear" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.CrossbowCultistConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Bear" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启熊透视", Duration = 3})
    end
})

toushiTab:Button({
    Title = "狼",
    Desc = "透视狼",
    Callback = function()
        if _G.CrossbowCultistHighlights then
            for _, highlight in pairs(_G.CrossbowCultistHighlights) do
                highlight:Destroy()
            end
            _G.CrossbowCultistHighlights = nil
            WindUI:Notify({Title = "提示", Content = "已关闭狼透视", Duration = 3})
            return
        end

        _G.CrossbowCultistHighlights = {}

        local itemsFolder = workspace:FindFirstChild("ltems") or workspace:FindFirstChild("Items")
        if not itemsFolder then
            WindUI:Notify({Title = "错误", Content = "未找到物品文件夹", Duration = 3})
            return
        end

        local function createHighlight(part)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            table.insert(_G.CrossbowCultistHighlights, highlight)
        end

        for _, item in ipairs(itemsFolder:GetDescendants()) do
            if item.Name == "Crossbow Cultist" and item:IsA("Model") then
                local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end

        _G.CrossbowCultistConnection = itemsFolder.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Crossbow Cultist" and descendant:IsA("Model") then
                local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart") or descendant:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    createHighlight(primaryPart)
                end
            end
        end)

        WindUI:Notify({Title = "提示", Content = "已开启狼透视", Duration = 3})
    end
})

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

showWelcome() 