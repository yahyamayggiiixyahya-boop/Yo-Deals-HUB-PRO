-- =====================================================
--  يويو ديلز | النسخة الحرة الذكية (90 FPS + مساعدة أيم مرنة بدون كاميرا لوك)
-- =====================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 1. بوست أداء (90 FPS) + تثبيت الشبكة لمنع الـ Lag
pcall(function()
    setfpscap(90)
    Workspace.StreamingEnabled = true
    
    local networkSettings = settings():FindFirstChild("NetworkSettings")
    if networkSettings then
        pcall(function()
            networkSettings.IncomingReplicationLag = 0
            networkSettings.PhysicsReceiveTimeout = 0
        end)
    end

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.CastShadow = false end
    end
end)

-- 2. تشغيل السكريبتين الأساسيين في الخلفية (مع ريست سكريبت الـ anti_batV1 لضمان ظهوره دائماً)
task.spawn(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-/refs/heads/main/main.lua"))() end)
end)

task.spawn(function()
    pcall(function()
        for _, gui in ipairs(CoreGui:GetChildren()) do
            if gui.Name:lower():find("antibat") or gui.Name:lower():find("bat") then
                gui:Destroy()
            end
        end
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_batV1/refs/heads/main/anti_batV1"))()
    end)
end)

-- 3. مساعدة أيم مرنة وحرة (تنعيم حركة الإدخال نحو الهدف بدون قفل الكاميرا)
local assistEnabled = false
task.spawn(function()
    pcall(function()
        RunService.RenderStepped:Connect(function()
            if not assistEnabled then return end
            pcall(function()
                local mouse = LocalPlayer:GetMouse()
                local target = mouse.Target
                if target and target.Parent then
                    local humanoid = target.Parent:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 and target.Parent ~= LocalPlayer.Character then
                        -- مساعد إدخال خفيف جداً يحسن استجابة السحب نحو اللاعب بحرية تامة دون إجبار الكاميرا
                        local currentPos = Camera.CFrame
                        local targetPos = CFrame.new(Camera.CFrame.Position, target.Position)
                        Camera.CFrame = currentPos:Lerp(targetPos, 0.05) -- نسبة نعومة عالية تتيح لك الحركة والحرية
                    end
                end
            end)
        end)
    end)
end)

-- 4. القائمة المصغرة (مثبتة على الجنب الأيمن تماماً وقابلة للسحب)
task.spawn(function()
    pcall(function()
        if CoreGui:FindFirstChild("YoDealsMenuFinal") then CoreGui.YoDealsMenuFinal:Destroy() end

        local Gui = Instance.new("ScreenGui", CoreGui)
        Gui.Name = "YoDealsMenuFinal"
        Gui.IgnoreGuiInset = true

        local Frame = Instance.new("Frame", Gui)
        Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        Frame.BackgroundTransparency = 0.2
        Frame.Position = UDim2.new(0.85, 0, 0.15, 0)
        Frame.Size = UDim2.new(0, 130, 0, 120)
        Frame.Active = true
        Frame.Draggable = true

        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", Frame)
        stroke.Color = Color3.fromRGB(255, 50, 50)
        stroke.Thickness = 1.5

        local Title = Instance.new("TextLabel", Frame)
        Title.BackgroundTransparency = 1
        Title.Size = UDim2.new(1, 0, 0, 25)
        Title.Font = Enum.Font.GothamBold
        Title.Text = "⚡ YoDeals ⚡"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 11

        -- زر Anti-Bat
        local Btn = Instance.new("TextButton", Frame)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Btn.Position = UDim2.new(0.1, 0, 0.25, 0)
        Btn.Size = UDim2.new(0, 104, 0, 32)
        Btn.Font = Enum.Font.GothamBold
        Btn.Text = "Anti-Bat: OFF"
        Btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        Btn.TextSize = 10
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        local active = false
        Btn.MouseButton1Click:Connect(function()
            active = not active
            if active then
                Btn.Text = "Anti-Bat: ON"
                Btn.TextColor3 = Color3.fromRGB(50, 255, 50)
                Btn.BackgroundColor3 = Color3.fromRGB(20, 60, 30)
                task.spawn(function()
                    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_bat/refs/heads/main/anti_bat"))() end)
                end)
            else
                Btn.Text = "Anti-Bat: OFF"
                Btn.TextColor3 = Color3.fromRGB(255, 100, 100)
                Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end
        end)

        -- زر Aim Assist الحر الجديد
        local AssistBtn = Instance.new("TextButton", Frame)
        AssistBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        AssistBtn.Position = UDim2.new(0.1, 0, 0.62, 0)
        AssistBtn.Size = UDim2.new(0, 104, 0, 32)
        AssistBtn.Font = Enum.Font.GothamBold
        AssistBtn.Text = "Aim-Assist: OFF"
        AssistBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        AssistBtn.TextSize = 10
        Instance.new("UICorner", AssistBtn).CornerRadius = UDim.new(0, 6)

        AssistBtn.MouseButton1Click:Connect(function()
            assistEnabled = not assistEnabled
            if assistEnabled then
                AssistBtn.Text = "Aim-Assist: ON"
                AssistBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
                AssistBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 30)
            else
                AssistBtn.Text = "Aim-Assist: OFF"
                AssistBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
                AssistBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end
        end)
    end)
end)

-- 5. علامة الكورة الحمراء البسيطة جداً فوق اللاعبين
task.spawn(function()
    local function addDot(p)
        if p == LocalPlayer then return end
        p.CharacterAdded:Connect(function(char)
            local head = char:WaitForChild("Head", 5)
            if head and not head:FindFirstChild("YoDealsRedDot") then
                local bg = Instance.new("BillboardGui", head)
                bg.Name = "YoDealsRedDot"
                bg.AlwaysOnTop = true
                bg.Size = UDim2.new(0, 20, 0, 20)
                bg.StudsOffset = Vector3.new(0, 2, 0)
                
                local f = Instance.new("Frame", bg)
                f.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                f.Size = UDim2.new(1, 0, 1, 0)
                Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
            end
        end)
        if p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("YoDealsRedDot") then
                local bg = Instance.new("BillboardGui", head)
                bg.Name = "YoDealsRedDot"
                bg.AlwaysOnTop = true
                bg.Size = UDim2.new(0, 20, 0, 20)
                bg.StudsOffset = Vector3.new(0, 2, 0)
                
                local f = Instance.new("Frame", bg)
                f.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                f.Size = UDim2.new(1, 0, 1, 0)
                Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
            end
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do addDot(p) end
    Players.PlayerAdded:Connect(addDot)
end)
