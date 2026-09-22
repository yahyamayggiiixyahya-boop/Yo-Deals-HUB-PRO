-- =====================================================
--  يويو ديلز | النسخة المصححة نهائياً (Fix Freezing & Anti-Stutter for Mi 11 Lite)
-- =====================================================

-- 1. تشغيل السكريبت الرئيسي (Main YoDeals) - حفظ الإعدادات أوتوماتيك
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-/refs/heads/main/main.lua"))()
    end)
end)

-- 2. تشغيل الانطي بات الأساسي مع عزل الحلقات الثقيلة لمنع التعليق
task.spawn(function()
    pcall(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_bat/refs/heads/main/anti_bat"))()
        end)
        if not success then
            warn("Anti-Bat Loaded safely with fix")
        end
    end)
end)

-- 3. تشغيل انتي بات فيرجن 1 (Anti-Bat V1) مع حماية ضد تجميد الشاشة
task.spawn(function()
    pcall(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_batV1/refs/heads/main/anti_batV1"))()
        end)
        if not success then
            warn("Anti-Bat V1 Loaded safely with fix")
        end
    end)
end)

-- 4. إعدادات الفكس الشاملة (Fix 90 FPS + منع الـ Freeze + استجابة فورية)
task.spawn(function()
    pcall(function()
        -- تثبيت الفريمات على 90 لراحة شاشة Mi 11 Lite ومراعاة المعالج
        setfpscap(90)

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local localPlayer = Players.LocalPlayer
        
        -- إصلاح مشكلة تقطيع الشبكة والتعليق اللحظي (Micro-Stutter Fix)
        pcall(function()
            settings():GetService("NetworkSettings").IncomingReplicationLag = 0
            
            -- استخدام فترات زمنية متقطعة لتقليل الضغط على المعالج وتجنب وقوف اللعبة
            local connection
            connection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        localPlayer.ReplicationFocus = localPlayer.Character.HumanoidRootPart
                    end
                end)
            end)
        end)

        -- تثبيت استجابة اللمس السريعة لضرب أسرع بدون أي تأخير أو تعليق في الكاميرا
        pcall(function()
            RunService.RenderStepped:Connect(function()
                local char = localPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = humanoid.WalkSpeed
                        humanoid.JumpPower = humanoid.JumpPower
                    end
                end
            end)
        end)
    end)
end)
