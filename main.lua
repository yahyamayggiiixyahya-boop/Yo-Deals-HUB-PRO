-- سكريبت خفيف وسريع جداً لتشغيل يوديلز والانتي بات فقط بدون أي قوائم

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-/refs/heads/main/main.lua"))()
    end)
end)

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/anti_bat/refs/heads/main/anti_bat"))()
    end)
end)
