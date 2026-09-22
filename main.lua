-- =====================================================
--  يويو ديلز | التعديل النهائي والنهائي (انتي-بات سريع + هيت بوكس أوتوماتيكي بدون أزرار)
-- =====================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 1. بوسط سريع للنت وإلغاء الـ Replication Lag لضمان استقرار البينج وسرعة الاستجابة
pcall(function()
    setfpscap(90)
    settings():GetService("NetworkSettings").IncomingReplicationLag = 0
end)

-- 2. تشغيل السكربتات الأساسية (YoDeals + Anti-Bat V1) بأقصى سرعة فوراً في الخلفية
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

-- 3. بناء القائمة المصغرة البسيطة الخاصة بـ (Anti-Bat العادي) فقط
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

        -- زرار واحد فقط لـ Anti-Bat العادي
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

-- 4. حلقة أوتوماتيكية بالكامل تكبر هيت بوكس اللاعبين فوراً من تلقاء نفسها بدون أي أزرار
task.spawn(function()
    local frameCounter = 0
    RunService.RenderStepped:Connect(function()
        pcall(function()
            frameCounter = frameCounter + 1
            if frameCounter % 2 == 0 then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        local head = p.Character:FindFirstChild("Head")
                        
                        if hrp then
                            hrp.Size = Vector3.new(12, 12, 12)
                            hrp.Transparency = 0.85
                            hrp.CanCollide = false
                        end
                        
                        if head then
                            head.Size = Vector3.new(6, 6, 6)
                            head.Transparency = 0.7
                        end
                    end
                end
            end
        end)
    end)
end)
