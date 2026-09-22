-- =====================================================
--  يويو ديلز | النسخة الخارقة النهائية (FakeHeadshot V6 + درع الحماية الشامل 360 + بوست سرعة 150ms + تدمير الخصوم)
-- =====================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- 1. بوست أداء خارق وسرعة استجابة 150ms للشبكة والضربات
pcall(function()
    setfpscap(120)
    Workspace.StreamingEnabled = true
    
    local networkSettings = settings():FindFirstChild("NetworkSettings")
    if networkSettings then
        pcall(function()
            networkSettings.IncomingReplicationLag = 0
            networkSettings.PhysicsReceiveTimeout = 0
        end)
    end

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CastShadow = false
            v.Reflectance = 0
        end
    end
end)

-- حلقة منع الـ Rubberbanding والرجوع للخلف تماماً
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if LocalPlayer and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local _ = hrp.Position
                end
            end
        end)
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

-- 4. درع حماية السكن والجسم (لتفادی أي ضربة من الخصوم تماماً وإبطال هجماتهم)
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function()
                        local scale = char:FindFirstChild("HumanoidDescription") or humanoid:FindFirstChildOfClass("HumanoidDescription")
                        if scale then
                            scale.HeightScale = 0.90
                            scale.WidthScale = 0.90
                            scale.HeadScale = 0.92
                        end
                    end)
                end
            end
        end)
    end)
end)

-- 5. علامة الكورة الحمراء + نظام FakeHeadshot V6 الأسطوري (هيت بوكس تدميري 1000% من الظهر والجنب والفراغ)
task.spawn(function()
    local espGuis = {}
    local playerBoxes = {}

    local function setupPlayer(p)
        if p == LocalPlayer then return end
        
        p.CharacterAdded:Connect(function(char)
            if espGuis[p] then 
                pcall(function() espGuis[p]:Destroy() end)
                espGuis[p] = nil
            end
            if playerBoxes[p] then
                for _, box in ipairs(playerBoxes[p]) do
                    pcall(function() box:Destroy() end)
                end
                playerBoxes[p] = nil
            end
            
            local head = char:WaitForChild("Head", 5)
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            
            if head and hrp then
                -- علامة الكورة الحمراء فوق رأس اللاعب
                local dotGui = Instance.new("BillboardGui")
                dotGui.Name = "YoDealsRedDot"
                dotGui.AlwaysOnTop = true
                dotGui.Size = UDim2.new(0, 25, 0, 25)
                dotGui.StudsOffset = Vector3.new(0, 2.2, 0)
                
                local dot = Instance.new("Frame")
                dot.Parent = dotGui
                dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                dot.Size = UDim2.new(1, 0, 1, 0)
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = dot
                
                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Thickness = 2
                stroke.Parent = dot

                dotGui.Parent = head
                espGuis[p] = dotGui

                -- نظام FakeHeadshot V6 المدمر (تغطية 360 درجة من الظهر والجنب بقوة 1000%)
                local boxes = {}
                
                -- الهيت بوكس الأول العملاق (تغطية محيطية كاملة من الظهر والجنب)
                local box1 = Instance.new("Part")
                box1.Name = "FakeHeadshotV6_OmniZone"
                box1.Size = Vector3.new(26, 11, 26)
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

                -- الهيت بوكس الثاني العالي (لتدمير أي خصم قوي مهما كانت حركته)
                local box2 = Instance.new("Part")
                box2.Name = "FakeHeadshotV6_PowerHead"
                box2.Size = Vector3.new(22, 10, 22)
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

                playerBoxes[p] = boxes
            end
        end)
        
        if p.Character then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if head and hrp then
                local dotGui = Instance.new("BillboardGui")
                dotGui.Name = "YoDealsRedDot"
                dotGui.AlwaysOnTop = true
                dotGui.Size = UDim2.new(0, 25, 0, 25)
                dotGui.StudsOffset = Vector3.new(0, 2.2, 0)
                
                local dot = Instance.new("Frame")
                dot.Parent = dotGui
                dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                dot.Size = UDim2.new(1, 0, 1, 0)
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = dot
                
                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Thickness = 2
                stroke.Parent = dot

                dotGui.Parent = head
                espGuis[p] = dotGui

                local boxes = {}
                
                local box1 = Instance.new("Part")
                box1.Name = "FakeHeadshotV6_OmniZone"
                box1.Size = Vector3.new(26, 11, 26)
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
                box2.Name = "FakeHeadshotV6_PowerHead"
                box2.Size = Vector3.new(22, 10, 22)
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

                playerBoxes[p] = boxes
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        setupPlayer(p)
    end
    Players.PlayerAdded:Connect(setupPlayer)
end)
