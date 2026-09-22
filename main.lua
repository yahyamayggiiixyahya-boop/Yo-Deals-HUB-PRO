-- =====================================================
--  يويو ديلز | النسخة الهادئة النهائية (شاشة ثابتة تماماً بدون أي هزة + هيت بوكس عملاق 50 + بوست أداء)
-- =====================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- 1. بوست أداء قوي جداً وتثبيت الـ FPS ومنع التهنيج مهما كثرت السكريبتات
pcall(function()
    setfpscap(120)
    settings():GetService("NetworkSettings").IncomingReplicationLag = 0
    Workspace.StreamingEnabled = true
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CastShadow = false
        end
    end
end)

-- 2. تشغيل السكريبتات الأساسية (YoDeals + Anti-Bat V1) بأقصى سرعة في الخلفية
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

-- 4. النقطة الحمراء + هيت بوكس عملاق جداً (مقاس 50) يغطي كل محيط اللاعب + شاشة ثابتة 100% ومفيش أي هزة
task.spawn(function()
    local espDots = {}

    local function setupPlayerESP(p)
        if p == LocalPlayer then return end
        
        p.CharacterAdded:Connect(function(char)
            if espDots[p] then 
                pcall(function() espDots[p]:Destroy() end)
                espDots[p] = nil
            end
            
            local head = char:WaitForChild("Head", 5)
            if head then
                local dotGui = Instance.new("BillboardGui")
                dotGui.Name = "YoDealsRedDot"
                dotGui.AlwaysOnTop = true
                dotGui.Size = UDim2.new(1, 0, 1, 0)
                dotGui.StudsOffset = Vector3.new(0, 0.8, 0)
                
                local dot = Instance.new("Frame")
                dot.Parent = dotGui
                dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                dot.Size = UDim2.new(0, 8, 0, 8)
                dot.Position = UDim2.new(0.5, -4, 0.5, -4)
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = dot
                
                dotGui.Parent = head
                espDots[p] = dotGui
            end
        end)
        
        if p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local dotGui = Instance.new("BillboardGui")
                dotGui.Name = "YoDealsRedDot"
                dotGui.AlwaysOnTop = true
                dotGui.Size = UDim2.new(1, 0, 1, 0)
                dotGui.StudsOffset = Vector3.new(0, 0.8, 0)
                
                local dot = Instance.new("Frame")
                dot.Parent = dotGui
                dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                dot.Size = UDim2.new(0, 8, 0, 8)
                dot.Position = UDim2.new(0.5, -4, 0.5, -4)
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = dot
                
                dotGui.Parent = head
                espDots[p] = dotGui
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        setupPlayerESP(p)
    end
    Players.PlayerAdded:Connect(setupPlayerESP)

    local frameCounter = 0
    RunService.RenderStepped:Connect(function()
        pcall(function()
            frameCounter = frameCounter + 1
            
            -- هيت بوكس ضخم وواسع جداً (مقاس 50) عشان تضرب بالعصا في الفراغ أو الجنب وتجيب الهدف فوراً
            if frameCounter % 2 == 0 then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        local head = p.Character:FindFirstChild("Head")
                        
                        if hrp then
                            hrp.Size = Vector3.new(50, 50, 50)
                            hrp.Transparency = 1
                            hrp.CanCollide = false
                        end
                        
                        if head then
                            head.Size = Vector3.new(18, 18, 18)
                            head.Transparency = 1
                        end
                    end
                end
            end
            -- تم إلغاء حركة الكاميرا تماماً لتظل الشاشة مستقرة وهادئة وخالية من أي اهتزاز
        end)
    end)
end)
