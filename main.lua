-- =====================================================
--  يويو ديلز | النسخة الخفيفة الشاملة (Main + Anti-Bat + V1 + 120 FPS Boost)
-- =====================================================

-- تشغيل السكريبت الرئيسي (Main YoDeals)
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-/refs/heads/main/main.lua"))()
    end)
end)

-- تشغيل الانتي بات الأساسي (Anti-Bat Classic)
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_bat/refs/heads/main/anti_bat"))()
    end)
end)

-- تشغيل انتي بات فيرجن 1 (Anti-Bat V1)
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_batV1/refs/heads/main/anti_batV1"))()
    end)
end)

-- تشغيل بوست الفريمات (120 FPS Lock & Optimization) في الخلفية
task.spawn(function()
    pcall(function()
        -- تثبيت الفريمات على 120 (أو فك الـ Cap المسموح به من الجهاز)
        setfpscap(120)
        
        -- تحسين إعدادات الأداء في الخلفية لمنع اللاغ والدراوب فريم
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.Brightness = 2
        
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterTransparency = 0
            Terrain.WaterReflectance = 0
        end

        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end

        Workspace.DescendantAdded:Connect(function(v)
            task.spawn(function()
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end)
        end)
    end)
end)
