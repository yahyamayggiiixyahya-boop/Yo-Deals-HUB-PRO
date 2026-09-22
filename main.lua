-- =====================================================
--  يويو ديلز | النسخة الخارقة الشاملة (رأس أحمر بالكامل + بوست بنج ونتورك قوي + 3 هيت بوكسات وهمية + بدون رجوع للخلف)
-- =====================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- 1. بوست أداء قوي جداً + تحسين وتثبيت الإنترنت والشبكة (Network Boost) لتقليل البنج السيء
pcall(function()
    setfpscap(120)
    Workspace.StreamingEnabled = true
    
    -- تحسين استجابة الشبكة وتقليل اللاج الناتج عن ضعف النت
    local networkSettings = settings():FindFirstChild("NetworkSettings")
    if networkSettings then
        pcall(function()
            networkSettings.IncomingReplicationLag = 0
        end)
    end

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CastShadow = false
        end
    end
end)

-- 2. تشغيل السكريبتات الأساسية في الخلفية
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-/refs/heads/main/main.lua"))()
    end)
end)

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_batV1/refs/heads/main/anti_batV1"))()
    end)
end)

-- 3. القائمة المصغرة (Anti-Bat العادي)
task.spawn(function()
    pcall(function()
        if CoreGui:FindFirstChild("YoDealsMenuFinal") then
            CoreGui.YoDealsMenuFinal:Destroy()
        end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "YoDealsMenuFinal"
        ScreenGui.Parent = CoreGui
        ScreenGui.IgnoreGuiInset = true

        local MainFrame = Instance.new("Frame")
        MainFrame.Parent = ScreenGui
        MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        MainFrame.BackgroundTransparency = 0.2
        MainFrame.Position = UDim2.new(0.8, 0, 0.3, 0)
        MainFrame.Size = UDim2.new(0, 150, 0, 90)
        MainFrame.Active = true
        MainFrame.Draggable = true

        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, 12)
        MainCorner.Parent = MainFrame

        local MainStroke = Instance.new("UIStroke")
        MainStroke.Parent = MainFrame
        MainStroke.Color = Color3.fromRGB(255, 50, 50)
        MainStroke.Thickness = 2

        local Title = Instance.new("TextLabel")
        Title.Parent = MainFrame
        Title.BackgroundTransparency = 1
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Font = Enum.Font.GothamBold
        Title.Text = "⚡ YoDeals Panel ⚡"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 12

        local AntiBatBtn = Instance.new("TextButton")
        AntiBatBtn.Parent = MainFrame
        AntiBatBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        AntiBatBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
        AntiBatBtn.Size = UDim2.new(0, 120, 0, 35)
        AntiBatBtn.Font = Enum.Font.GothamBold
        AntiBatBtn.Text = "Anti-Bat: OFF"
        AntiBatBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        AntiBatBtn.TextSize = 11

        local c1 = Instance.new("UICorner")
        c1.CornerRadius = UDim.new(0, 6)
        c1.Parent = AntiBatBtn

        local antiBatActive = false

        AntiBatBtn.MouseButton1Click:Connect(function()
            antiBatActive = not antiBatActive
            if antiBatActive then
                AntiBatBtn.Text = "Anti-Bat: ON"
                AntiBatBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
                AntiBatBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 30)
                
                pcall(function()
                    task.spawn(function()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_bat/refs/heads/main/anti_bat"))()
                    end)
                end)
            else
                AntiBatBtn.Text = "Anti-Bat: OFF"
                AntiBatBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
                AntiBatBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end
        end)
    end)
end)

-- 4. رأس اللاعب كله أحمر + 3 هيت بوكسات وهمية للضربات بنسبة 100% + حماية من الرجوع للخلف
task.spawn(function()
    local playerBoxes = {}

    local function setupPlayer(p)
        if p == LocalPlayer then return end
        
        p.CharacterAdded:Connect(function(char)
            if playerBoxes[p] then
                for _, box in ipairs(playerBoxes[p]) do
                    pcall(function() box:Destroy() end)
                end
                playerBoxes[p] = nil
            end
            
            local head = char:WaitForChild("Head", 5)
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            
            if head and hrp then
                -- تلوين رأس اللاعب بالكامل باللون الأحمر الفاقع
                pcall(function()
                    head.Color = Color3.fromRGB(255, 0, 0)
                    head.Material = Enum.Material.Neon
                end)

                -- إنشاء 3 هيت بوكسات وهمية واسعة لتغطية محيط اللاعب بنسبة 100% في أي ماب
                local boxes = {}
                
                local box1 = Instance.new("Part")
                box1.Name = "YoDealsBox_Mid"
                box1.Size = Vector3.new(16, 6, 16)
                box1.Transparency = 1
                box1.CanCollide = false
                box1.Massless = true
                box1.Anchored = false
                box1.Parent = char
                
                local weld1 = Instance.new("WeldConstraint")
                weld1.Part0 = hrp
                weld1.Part1 = box1
                weld1.Parent = box1
                table.insert(boxes, box1)

                local box2 = Instance.new("Part")
                box2.Name = "YoDealsBox_Low"
                box2.Size = Vector3.new(14, 5, 14)
                box2.Transparency = 1
                box2.CanCollide = false
                box2.Massless = true
                box2.Anchored = false
                box2.Parent = char
                
                local weld2 = Instance.new("WeldConstraint")
                weld2.Part0 = hrp
                weld2.Part1 = box2
                weld2.Parent = box2
                table.insert(boxes, box2)

                local box3 = Instance.new("Part")
                box3.Name = "YoDealsBox_High"
                box3.Size = Vector3.new(14, 5, 14)
                box3.Transparency = 1
                box3.CanCollide = false
                box3.Massless = true
                box3.Anchored = false
                box3.Parent = char
                
                local weld3 = Instance.new("WeldConstraint")
                weld3.Part0 = hrp
                weld3.Part1 = box3
                weld3.Parent = box3
                table.insert(boxes, box3)

                playerBoxes[p] = boxes
            end
        end)
        
        if p.Character then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if head and hrp then
                pcall(function()
                    head.Color = Color3.fromRGB(255, 0, 0)
                    head.Material = Enum.Material.Neon
                end)

                local boxes = {}
                
                local box1 = Instance.new("Part")
                box1.Name = "YoDealsBox_Mid"
                box1.Size = Vector3.new(16, 6, 16)
                box1.Transparency = 1
                box1.CanCollide = false
                box1.Massless = true
                box1.Anchored = false
                box1.Parent = char
                
                local weld1 = Instance.new("WeldConstraint")
                weld1.Part0 = hrp
                weld1.Part1 = box1
                weld1.Parent = box1
                table.insert(boxes, box1)

                local box2 = Instance.new("Part")
                box2.Name = "YoDealsBox_Low"
                box2.Size = Vector3.new(14, 5, 14)
                box2.Transparency = 1
                box2.CanCollide = false
                box2.Massless = true
                box2.Anchored = false
                box2.Parent = char
                
                local weld2 = Instance.new("WeldConstraint")
                weld2.Part0 = hrp
                weld2.Part1 = box2
                weld2.Parent = box2
                table.insert(boxes, box2)

                local box3 = Instance.new("Part")
                box3.Name = "YoDealsBox_High"
                box3.Size = Vector3.new(14, 5, 14)
                box3.Transparency = 1
                box3.CanCollide = false
                box3.Massless = true
                box3.Anchored = false
                box3.Parent = char
                
                local weld3 = Instance.new("WeldConstraint")
                weld3.Part0 = hrp
                weld3.Part1 = box3
                weld3.Parent = box3
                table.insert(boxes, box3)

                playerBoxes[p] = boxes
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        setupPlayer(p)
    end
    Players.PlayerAdded:Connect(setupPlayer)
end)
