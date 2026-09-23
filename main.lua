-- =====================================================
--  يويو ديلز | النسخة المصغرة الخفيفة (90 FPS + قائمة اليمين + السكريبتات الأساسية)
-- =====================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- 1. بوست أداء خفيف ومحدد على 90 فريم لجهازك لتجنب أي ثقل
pcall(function()
    setfpscap(90)
    Workspace.StreamingEnabled = true
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.CastShadow = false end
    end
end)

-- 2. تشغيل السكريبتين الأساسيين في الخلفية
task.spawn(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-/refs/heads/main/main.lua"))() end)
end)

task.spawn(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_batV1/refs/heads/main/anti_batV1"))() end)
end)

-- 3. القائمة المصغرة (مثبتة على الجنب الأيمن تماماً بعيداً عن منيو الهاك)
task.spawn(function()
    pcall(function()
        if CoreGui:FindFirstChild("YoDealsMenuFinal") then CoreGui.YoDealsMenuFinal:Destroy() end

        local Gui = Instance.new("ScreenGui", CoreGui)
        Gui.Name = "YoDealsMenuFinal"
        Gui.IgnoreGuiInset = true

        local Frame = Instance.new("Frame", Gui)
        Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        Frame.BackgroundTransparency = 0.2
        -- التثبيت على الجنب الأيمن تماماً
        Frame.Position = UDim2.new(0.85, 0, 0.15, 0)
        Frame.Size = UDim2.new(0, 130, 0, 80)
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

        local Btn = Instance.new("TextButton", Frame)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Btn.Position = UDim2.new(0.1, 0, 0.4, 0)
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
    end)
end)

-- 4. علامة الكورة الحمراء البسيطة جداً فوق اللاعبين
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
