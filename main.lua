-- Genv Logged By Crxkv And Enzo
-- Yo Deals Custom Hub + Anti Bat V2 + Violette TP Bat + Anti Medusa + يحيى في 2 + Aimbot Integration

-- 1. تشغيل سكريبت Yo Deals الأساسي
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-/refs/heads/main/main.lua"))()
    end)
    if not success then
        warn("[Yo Deals] Failed to load initial script: " .. tostring(err))
    end
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
if not player then
    warn("[YoDealsHub] Run this as a client LocalScript.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")
local previous = playerGui:FindFirstChild("YoDealsHub")
if previous then
    previous:Destroy()
end

-- متغيرات التحكم والوظائف الأساسية
local AntiResetEnabled = false
local AntiBatEnabled = false
local AntiBatV2Enabled = false
local AntiMedusaEnabled = false
local YahyaV2Enabled = false
local MedusaToolDetected = false
local InfiniteJumpEnabled = false
local InfiniteJumpHoldEnabled = false
local AntiKickEnabled = false
local VioletteBatUIEnabled = false
local InputSourceEnabled = false

local IsJumpingHold = false
local AntiBatConn = nil
local AntiBatV2Connection = nil
local AntiResetConn = nil
local AntiMedusaConn = nil
local YahyaV2Conn = nil
local JumpHoldConn = nil

local deathCoords = CFrame.new(1000003.56, 999999.69, 8.17)

-- متغيرات وسكربت الـ Aimbot المدمج
local AimbotState = {enabled = false, speed = 56.5, meleeOffset = 2, autoDropBrainrot = true, highlightEnabled = true}

local function findBat()
    local c = player.Character
    if not c then return nil end
    local bp = player:FindFirstChildOfClass("Backpack")
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
        end
    end
    local SlapList = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
    for _, name in ipairs(SlapList) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    return nil
end

local aimbotHighlight = Instance.new("Highlight")
aimbotHighlight.Name = "AimbotESP"
aimbotHighlight.FillColor = Color3.fromRGB(255, 0, 0)
aimbotHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
aimbotHighlight.FillTransparency = 0.5
aimbotHighlight.OutlineTransparency = 0
aimbotHighlight.Adornee = nil
pcall(function() aimbotHighlight.Parent = game:GetService("CoreGui") end)
if not aimbotHighlight.Parent then aimbotHighlight.Parent = playerGui end

local aimbotLockedTarget = nil
local aimbotNoTargetSince = nil
local aimbotConnection = nil
local antiDieConns = {}

local function _aimbotTargetValid(tc)
    if not tc or not tc.Parent then return false end
    local hum = tc:FindFirstChildOfClass("Humanoid")
    local hrp2 = tc:FindFirstChild("HumanoidRootPart")
    return hum and hrp2
end

local function _aimbotGetTarget(myHRP)
    if aimbotLockedTarget and not _aimbotTargetValid(aimbotLockedTarget) then
        aimbotLockedTarget = nil
    end
    if aimbotLockedTarget then
        return aimbotLockedTarget:FindFirstChild("HumanoidRootPart"), aimbotLockedTarget
    end
    local best, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and _aimbotTargetValid(p.Character) then
            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
            local d = (tHRP.Position - myHRP.Position).Magnitude
            if d < bestDist then bestDist = d; best = p.Character end
        end
    end
    aimbotLockedTarget = best
    return best and best:FindFirstChild("HumanoidRootPart"), best
end

local function _activateAntiDie()
    for _, c in ipairs(antiDieConns) do pcall(function() c:Disconnect() end) end
    antiDieConns = {}
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.BreakJointsOnDeath = false
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    table.insert(antiDieConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then hum.Health = hum.MaxHealth end
    end))
end

local function isHoldingBrainrot()
    local char = player.Character
    if not char then return false end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            local n = obj.Name:lower()
            if not n:find("bat") and not n:find("slap") and not n:find("medusa") then
                return true
            end
        end
    end
    return false
end

local function dropBrainrot()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Jump = true
        task.wait(0.1)
        hum.Jump = false
    end
end

local function startAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    _activateAntiDie()
    aimbotConnection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char or not char.Parent then return end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local myH = char:FindFirstChildOfClass("Humanoid")
        if not myH or myH.Health <= 0 then return end
        if not AimbotState.enabled then
            if AimbotState.highlightEnabled then aimbotHighlight.Adornee = nil end
            return
        end
        myH.AutoRotate = false
        local bat = findBat()
        if bat and bat.Parent ~= char then pcall(function() myH:EquipTool(bat) end) end
        if AimbotState.autoDropBrainrot and isHoldingBrainrot() then dropBrainrot() end
        myH:Move(Vector3.new(0, 0, 0), false)
        local tHRP, tChar = _aimbotGetTarget(myHRP)
        if tHRP and tChar and tHRP.Parent and tChar.Parent then
            aimbotNoTargetSince = nil
            if AimbotState.highlightEnabled then aimbotHighlight.Adornee = tChar end
            local tVel = tHRP.AssemblyLinearVelocity
            local predictTime = math.clamp(tVel.Magnitude / 150, 0.05, 0.2)
            local predicted = tHRP.Position + tVel * predictTime
            local behindOffset = -tHRP.CFrame.LookVector * AimbotState.meleeOffset
            local headTopOffset = Vector3.new(0, 2.6, 0)
            local standPos = predicted + behindOffset + headTopOffset
            local moveDir = standPos - myHRP.Position
            local lookTarget = Vector3.new(predicted.X, myHRP.Position.Y, predicted.Z)
            if (lookTarget - myHRP.Position).Magnitude > 0.1 then
                myHRP.CFrame = CFrame.lookAt(myHRP.Position, lookTarget) * CFrame.Angles(math.rad(-15), 0, 0)
            end
            if moveDir.Magnitude > 1 then
                myHRP.AssemblyLinearVelocity = moveDir.Unit * AimbotState.speed
            else
                myHRP.AssemblyLinearVelocity = tVel
            end
        else
            if not aimbotNoTargetSince then aimbotNoTargetSince = tick() end
            if tick() - aimbotNoTargetSince > 1.5 then
                aimbotLockedTarget = nil
                if myHRP and myHRP.Parent then myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
                if AimbotState.highlightEnabled then aimbotHighlight.Adornee = nil end
            end
        end
    end)
end

local function stopAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    local char = player.Character
    local r = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if r then r.AssemblyLinearVelocity = Vector3.zero end
    if hum then hum.AutoRotate = true end
    aimbotLockedTarget = nil
    aimbotNoTargetSince = nil
    if AimbotState.highlightEnabled then aimbotHighlight.Adornee = nil end
end

local function addCorner(parent, radius)
    local object = Instance.new("UICorner")
    object.CornerRadius = UDim.new(0, radius)
    object.Parent = parent
    return object
end

local function borderSequence()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.235294, 0, 0)),
        ColorSequenceKeypoint.new(0.35, Color3.new(0.705882, 0.0784314, 0.0784314)),
        ColorSequenceKeypoint.new(0.6, Color3.new(1, 0.235294, 0.235294)),
        ColorSequenceKeypoint.new(1, Color3.new(0.470588, 0, 0)),
    })
end

local function addGradientStroke(parent, thickness, initialRotation)
    local object = Instance.new("UIStroke")
    object.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    object.Thickness = thickness
    object.Color = Color3.new(1, 1, 1)
    object.Parent = parent

    local visual = Instance.new("UIGradient")
    visual.Color = borderSequence()
    visual.Rotation = initialRotation or 0
    visual.Parent = object

    return object, visual
end

local function makeDraggable(target)
    local dragging = false
    local dragStart = Vector2.zero
    local startPosition = target.Position

    target.Active = true

    target.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragStart = input.Position
        startPosition = target.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart
        target.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

-- منطق الـ Anti Reset
local function startAntiReset()
    if AntiResetConn then AntiResetConn:Disconnect() end
    AntiResetConn = RunService.Heartbeat:Connect(function()
        if not AntiResetEnabled then return end
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                humanoid.Health = 100
            end
        end
    end)
end

local function stopAntiReset()
    if AntiResetConn then
        AntiResetConn:Disconnect()
        AntiResetConn = nil
    end
end

-- منطق الـ Anti Bat العادي
local function startAntiBat()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if AntiBatConn then AntiBatConn:Disconnect() end
    AntiBatConn = RunService.Heartbeat:Connect(function()
        if not AntiBatEnabled or not root or not root.Parent then return end
        local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
        RunService.RenderStepped:Wait()
        root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
    end)
end

local function stopAntiBat()
    if AntiBatConn then
        AntiBatConn:Disconnect()
        AntiBatConn = nil
    end
end

-- منطق الـ Anti Bat V2 (تشغيل الـ Loadstring الجديد)
local function startAntiBatV2()
    if AntiBatV2Connection then return end
    AntiBatV2Enabled = true
    pcall(function()
        AntiBatV2Connection = loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/98873f97ed10761e0613d10ab6e9e455.lua"))()
    end)
end

local function stopAntiBatV2()
    AntiBatV2Enabled = false
    -- إذا كان الـ script يرجع دالة أو اتصال يمكن إغلاقه نضعه هنا، أو نتركه يتوقف بحسب السكريبت نفسه
    AntiBatV2Connection = nil
end

-- منطق الـ Anti Medusa
local function findCarpet()
    local char = player.Character
    if not char then return nil end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("carpet") then
                return tool
            end
        end
    end
    return nil
end

local function instaResetMedusa()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local carpet = findCarpet()
    if carpet then
        hum:EquipTool(carpet)
        task.wait(0.1)
    end

    root.CFrame = deathCoords

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not char or not char.Parent then
            conn:Disconnect()
            return
        end
        local r = char:FindFirstChild("HumanoidRootPart")
        if not r then conn:Disconnect() return end
        r.CFrame = deathCoords
        local h2 = char:FindFirstChildOfClass("Humanoid")
        if h2 and h2.Health <= 0 then
            conn:Disconnect()
        end
    end)
end

local function startAntiMedusa()
    if AntiMedusaConn then AntiMedusaConn:Disconnect() end

    AntiMedusaConn = RunService.Heartbeat:Connect(function()
        if not AntiMedusaEnabled then return end

        local char = player.Character
        if not char then return end

        local hasMedusa = false
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("medusa") or name:find("head") then
                    hasMedusa = true
                    if not MedusaToolDetected then
                        MedusaToolDetected = true
                        task.delay(1, function()
                            if AntiMedusaEnabled and MedusaToolDetected then
                                instaResetMedusa()
                                MedusaToolDetected = false
                            end
                        end)
                    end
                    break
                end
            end
        end

        if not hasMedusa then
            MedusaToolDetected = false
        end
    end)
end

local function stopAntiMedusa()
    if AntiMedusaConn then
        AntiMedusaConn:Disconnect()
        AntiMedusaConn = nil
    end
    MedusaToolDetected = false
end

-- منطق زر "يحيى في 2"
local resetCooldown = 0

local function forceResetYahyaV2()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local PM = player.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = require(PM:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

local function startYahyaV2()
    if YahyaV2Conn then return end
    YahyaV2Enabled = true
    YahyaV2Conn = RunService.Heartbeat:Connect(function()
        if not YahyaV2Enabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local isRagdolled = (state == Enum.HumanoidStateType.Physics or
                             state == Enum.HumanoidStateType.Ragdoll or
                             state == Enum.HumanoidStateType.FallingDown)

        if isRagdolled then
            local now = tick()
            if now - resetCooldown > 0.15 then
                resetCooldown = now
                forceResetYahyaV2()
            end
        end
    end)
end

local function stopYahyaV2()
    YahyaV2Enabled = false
    if YahyaV2Conn then
        YahyaV2Conn:Disconnect()
        YahyaV2Conn = nil
    end
end

-- منطق الـ Input Source
local function toggleInputSourceUI(state)
    InputSourceEnabled = state
    if InputSourceEnabled then
        if playerGui:FindFirstChild("CustomInputSourceUI") then
            playerGui.CustomInputSourceUI:Destroy()
        end

        local inputGui = Instance.new("ScreenGui")
        inputGui.Name = "CustomInputSourceUI"
        inputGui.ResetOnSpawn = false
        inputGui.DisplayOrder = 99999
        inputGui.Parent = playerGui

        local inputBox = Instance.new("TextButton")
        inputBox.Name = "InputBox"
        inputBox.Size = UDim2.new(0, 110, 0, 40)
        inputBox.Position = UDim2.new(0.5, -55, 0.85, 0)
        inputBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        inputBox.BorderSizePixel = 0
        inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        inputBox.Font = Enum.Font.GothamBold
        inputBox.TextSize = 14
        inputBox.Text = "انبوت"
        inputBox.Active = true
        inputBox.Draggable = true
        inputBox.Parent = inputGui
        addCorner(inputBox, 8)
        addGradientStroke(inputBox, 1.5, 0)

        inputBox.MouseButton1Click:Connect(function()
            AimbotState.enabled = not AimbotState.enabled
            if AimbotState.enabled then startAimbot() else stopAimbot() end
        end)
    else
        if playerGui:FindFirstChild("CustomInputSourceUI") then
            playerGui.CustomInputSourceUI:Destroy()
        end
    end
end

-- منطق الـ Infinite Jump
local function startJumpHoldLoop()
    if JumpHoldConn then JumpHoldConn:Disconnect() end
    JumpHoldConn = RunService.Heartbeat:Connect(function()
        if not InfiniteJumpHoldEnabled or not IsJumpingHold then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        IsJumpingHold = true
    end
    if input.KeyCode == Enum.KeyCode.M then
        AimbotState.enabled = not AimbotState.enabled
        if AimbotState.enabled then startAimbot() else stopAimbot() end
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        IsJumpingHold = false
    end
end)

UserInputService.JumpRequest:Connect(function()
    if not InfiniteJumpEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

-- منطق الـ Anti Kick / E01
local function isCarrying()
    local char = player.Character
    if not char then return false end
    
    for _, child in pairs(char:GetChildren()) do
        local name = child.Name:lower()
        if name:find("brainrot") or name:find("brain") or name:find("animal") or 
           name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
            return true
        end
    end
    
    for attrName, attrValue in pairs(char:GetAttributes()) do
        local name = attrName:lower()
        if (name:find("carrying") or name:find("carry") or name:find("stealing") or 
            name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
            return true
        end
    end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
        return true
    end
    
    return false
end

local function showSideCountdown()
    if playerGui:FindFirstChild("SideAntiKickUI") then
        playerGui.SideAntiKickUI:Destroy()
    end

    local sideGui = Instance.new("ScreenGui")
    sideGui.Name = "SideAntiKickUI"
    sideGui.ResetOnSpawn = false
    sideGui.DisplayOrder = 99998
    sideGui.Parent = playerGui

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 220, 0, 45)
    card.Position = UDim2.new(0, 15, 0.5, -22)
    card.BackgroundColor3 = Color3.new(0.109804, 0.0235294, 0.0352941)
    card.BackgroundTransparency = 0.1
    card.BorderSizePixel = 0
    card.Parent = sideGui
    addCorner(card, 12)
    addGradientStroke(card, 1.2, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 60, 60)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local duration = 3.0
    local startTime = tick()
    local finished = false
    local conn

    conn = RunService.RenderStepped:Connect(function()
        if not AntiKickEnabled or finished then
            sideGui:Destroy()
            if conn then conn:Disconnect() end
            return
        end

        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)

        if remaining > 0 then
            label.Text = string.format("⚠️ E01 WAIT: (%.1fs)", remaining)
        else
            finished = true
            label.Text = "⚡ STEAL NOW!"
            label.TextColor3 = Color3.fromRGB(50, 255, 130)
            task.delay(1.5, function()
                if sideGui then sideGui:Destroy() end
            end)
            if conn then conn:Disconnect() end
        end
    end)
end

task.spawn(function()
    local wasCarryingState = false
    while task.wait(0.1) do
        if AntiKickEnabled then
            local currentlyCarrying = isCarrying()
            if not wasCarryingState and currentlyCarrying then
                showSideCountdown()
            end
            wasCarryingState = currentlyCarrying
        else
            wasCarryingState = false
        end
    end
end)

-- دمج سكريبت Violette TP Bat
local function toggleVioletteBatScript(state)
    VioletteBatUIEnabled = state
    if VioletteBatUIEnabled then
        if playerGui:FindFirstChild("VioletteTPBat") then
            playerGui.VioletteTPBat:Destroy()
        end

        task.spawn(function()
            local C_BORDER = Color3.fromRGB(140, 50, 255)
            local C_PANEL = Color3.fromRGB(15, 8, 25)
            local C_TEXT_TITLE = Color3.fromRGB(255, 255, 255)
            local C_TEXT_SUB = Color3.fromRGB(110, 95, 130)
            local C_INACTIVE = Color3.fromRGB(255, 80, 100)
            local C_ACTIVE = Color3.fromRGB(100, 255, 120)
            local C_TOGGLE_ON = Color3.fromRGB(220, 220, 220)
            local C_TOGGLE_OFF = Color3.fromRGB(40, 30, 50)

            local bgImageFileName = "Violette_Background_V2.png"
            local bgImageUrl = "https://files.catbox.moe/mnjism.png"
            local customBgAsset = ""

            pcall(function()
                if isfile and getcustomasset and writefile then
                    if not isfile(bgImageFileName) then
                        local imgData = game:HttpGet(bgImageUrl)
                        writefile(bgImageFileName, imgData)
                    end
                    customBgAsset = getcustomasset(bgImageFileName)
                end
            end)

            local ConfigFile = "Violette_AutoBat_Config.json"
            local Config = { Position = {X_Scale = 0.5, X_Offset = -160, Y_Scale = 0.5, Y_Offset = -120} }

            local function SaveConfig()
                if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end) end
            end
            local function LoadConfig()
                if isfile and isfile(ConfigFile) then
                    local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
                    if success and data and data.Position then Config.Position = data.Position end
                end
            end
            LoadConfig()

            local State = { autoBatToggled = false, hittingCooldown = false, guiVisible = true }
            local Keys = { autoBat = Enum.KeyCode.X, guiHide = Enum.KeyCode.RightControl }
            local h, hrp = nil, nil

            local gui = Instance.new("ScreenGui")
            gui.Name = "VioletteTPBat"
            gui.ResetOnSpawn = false
            gui.DisplayOrder = 99997
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = playerGui

            local main = Instance.new("Frame", gui)
            main.Name = "Main"; main.Size = UDim2.new(0, 320, 0, 250)
            main.Position = UDim2.new(Config.Position.X_Scale, Config.Position.X_Offset, Config.Position.Y_Scale, Config.Position.Y_Offset)
            main.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
            main.BackgroundTransparency = customBgAsset ~= "" and 1 or 0
            main.BorderSizePixel = 0; main.Active = true
            main.ZIndex = 1
            Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
            local mainStroke = Instance.new("UIStroke", main); mainStroke.Color = C_BORDER; mainStroke.Thickness = 2

            local bgLabel = Instance.new("ImageLabel", main)
            bgLabel.Size = UDim2.new(1, 0, 1, 0)
            bgLabel.BackgroundTransparency = 1
            bgLabel.Image = customBgAsset
            bgLabel.ScaleType = Enum.ScaleType.Crop
            bgLabel.ZIndex = 0
            Instance.new("UICorner", bgLabel).CornerRadius = UDim.new(0, 12)

            local dragging, dragInput, dragStart, mainStart = false, nil, nil, nil
            main.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; dragStart = inp.Position; mainStart = main.Position
                    inp.Changed:Connect(function()
                        if inp.UserInputState == Enum.UserInputState.End then 
                            dragging = false
                            Config.Position = {X_Scale = main.Position.X.Scale, X_Offset = main.Position.X.Offset, Y_Scale = main.Position.Y.Scale, Y_Offset = main.Position.Y.Offset}
                            SaveConfig()
                        end
                    end)
                end
            end)
            main.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if inp == dragInput and dragging then
                    local dx = inp.Position.X - dragStart.X
                    local dy = inp.Position.Y - dragStart.Y
                    main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
                end
            end)

            local titleDot = Instance.new("Frame", main)
            titleDot.Size = UDim2.new(0, 10, 0, 10); titleDot.Position = UDim2.new(0, 16, 0, 18)
            titleDot.BackgroundColor3 = C_BORDER; titleDot.BorderSizePixel = 0; titleDot.ZIndex = 5
            Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

            local titleLbl = Instance.new("TextLabel", main)
            titleLbl.Size = UDim2.new(0, 200, 0, 20); titleLbl.Position = UDim2.new(0, 36, 0, 12)
            titleLbl.BackgroundTransparency = 1; titleLbl.Text = "VIOLETTE TP BAT"
            titleLbl.TextColor3 = C_TEXT_TITLE; titleLbl.Font = Enum.Font.GothamBlack; titleLbl.TextSize = 16
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.ZIndex = 5

            local subLbl = Instance.new("TextLabel", main)
            subLbl.Size = UDim2.new(0, 200, 0, 14); subLbl.Position = UDim2.new(0, 36, 0, 32)
            subLbl.BackgroundTransparency = 1; subLbl.Text = "BY F3NDS"
            subLbl.TextColor3 = C_TEXT_SUB; subLbl.Font = Enum.Font.Gotham; subLbl.TextSize = 11
            subLbl.TextXAlignment = Enum.TextXAlignment.Left; subLbl.ZIndex = 5

            local closeBtn = Instance.new("TextButton", main)
            closeBtn.Size = UDim2.new(0, 24, 0, 24); closeBtn.Position = UDim2.new(1, -32, 0, 16)
            closeBtn.BackgroundColor3 = Color3.fromRGB(15, 10, 20); closeBtn.BackgroundTransparency = 0.5; closeBtn.Text = "[]"
            closeBtn.TextColor3 = C_TEXT_TITLE; closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 12; closeBtn.ZIndex = 5
            Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
            closeBtn.MouseButton1Click:Connect(function() 
                State.autoBatToggled = false 
                VioletteBatUIEnabled = false
                gui:Destroy() 
            end)

            local sepLine = Instance.new("Frame", main)
            sepLine.Size = UDim2.new(1, 0, 0, 2); sepLine.Position = UDim2.new(0, 0, 0, 56)
            sepLine.BackgroundColor3 = C_BORDER; sepLine.BorderSizePixel = 0; sepLine.ZIndex = 5
            sepLine.BackgroundTransparency = 0.2

            local function CreatePanel(yPos, height)
                local p = Instance.new("Frame", main)
                p.Size = UDim2.new(1, -24, 0, height); p.Position = UDim2.new(0, 12, 0, yPos)
                p.BackgroundColor3 = C_PANEL
                p.BackgroundTransparency = 0.9 
                p.ZIndex = 4
                Instance.new("UICorner", p).CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", p)
                stroke.Color = C_BORDER; stroke.Thickness = 1.5; stroke.Transparency = 0
                return p
            end

            local statusPanel = CreatePanel(68, 42)
            local statusDot = Instance.new("Frame", statusPanel)
            statusDot.Size = UDim2.new(0, 8, 0, 8); statusDot.Position = UDim2.new(0, 14, 0.5, -4)
            statusDot.BackgroundColor3 = C_INACTIVE; statusDot.BorderSizePixel = 0; statusDot.ZIndex = 6
            Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
            local statusTxt = Instance.new("TextLabel", statusPanel)
            statusTxt.Size = UDim2.new(0, 100, 1, 0); statusTxt.Position = UDim2.new(0, 30, 0, 0)
            statusTxt.BackgroundTransparency = 1; statusTxt.Text = "Status"
            statusTxt.TextColor3 = C_TEXT_TITLE; statusTxt.Font = Enum.Font.GothamBold; statusTxt.TextSize = 13
            statusTxt.TextXAlignment = Enum.TextXAlignment.Left; statusTxt.ZIndex = 6
            local statusVal = Instance.new("TextLabel", statusPanel)
            statusVal.Size = UDim2.new(0, 100, 1, 0); statusVal.Position = UDim2.new(1, -114, 0, 0)
            statusVal.BackgroundTransparency = 1; statusVal.Text = "INACTIVE"
            statusVal.TextColor3 = C_INACTIVE; statusVal.Font = Enum.Font.GothamBlack; statusVal.TextSize = 14
            statusVal.TextXAlignment = Enum.TextXAlignment.Right; statusVal.ZIndex = 6

            local batPanel = CreatePanel(120, 60)
            local batTitle = Instance.new("TextLabel", batPanel)
            batTitle.Size = UDim2.new(0, 150, 0, 20); batTitle.Position = UDim2.new(0, 14, 0, 10)
            batTitle.BackgroundTransparency = 1; batTitle.Text = "Auto Bat"
            batTitle.TextColor3 = C_TEXT_TITLE; batTitle.Font = Enum.Font.GothamBlack; batTitle.TextSize = 15
            batTitle.TextXAlignment = Enum.TextXAlignment.Left; batTitle.ZIndex = 6
            local batSub = Instance.new("TextLabel", batPanel)
            batSub.Size = UDim2.new(0, 200, 0, 14); batSub.Position = UDim2.new(0, 14, 0, 32)
            batSub.BackgroundTransparency = 1; batSub.Text = "Teleport-swing nearest player"
            batSub.TextColor3 = C_TEXT_SUB; batSub.Font = Enum.Font.Gotham; batSub.TextSize = 11
            batSub.TextXAlignment = Enum.TextXAlignment.Left; batSub.ZIndex = 6

            local keybindLbl = Instance.new("TextLabel", batPanel)
            keybindLbl.Size = UDim2.new(0, 30, 0, 20); keybindLbl.Position = UDim2.new(1, -100, 0.5, -10)
            keybindLbl.BackgroundTransparency = 1; keybindLbl.Text = "["..Keys.autoBat.Name.."]"
            keybindLbl.TextColor3 = C_BORDER; keybindLbl.Font = Enum.Font.GothamBlack; keybindLbl.TextSize = 13; keybindLbl.ZIndex = 6

            local toggleBg = Instance.new("Frame", batPanel)
            toggleBg.Size = UDim2.new(0, 48, 0, 24); toggleBg.Position = UDim2.new(1, -62, 0.5, -12)
            toggleBg.BackgroundColor3 = C_TOGGLE_OFF; toggleBg.BorderSizePixel = 0; toggleBg.ZIndex = 6
            Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
            local toggleStroke = Instance.new("UIStroke", toggleBg)
            toggleStroke.Color = C_BORDER; toggleStroke.Thickness = 1.5
            local toggleDot = Instance.new("Frame", toggleBg)
            toggleDot.Size = UDim2.new(0, 18, 0, 18); toggleDot.Position = UDim2.new(0, 3, 0.5, -9)
            toggleDot.BackgroundColor3 = C_TOGGLE_ON; toggleDot.BorderSizePixel = 0; toggleDot.ZIndex = 7
            Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

            local btnPanel = CreatePanel(190, 42)
            local mainBtn = Instance.new("TextButton", btnPanel)
            mainBtn.Size = UDim2.new(1, 0, 1, 0); mainBtn.BackgroundTransparency = 1
            mainBtn.Text = "TAP TO TOGGLE AUTO BAT"
            mainBtn.TextColor3 = C_TEXT_TITLE; mainBtn.Font = Enum.Font.GothamBlack; mainBtn.TextSize = 12; mainBtn.ZIndex = 6

            local function updateVisuals()
                local on = State.autoBatToggled
                statusVal.Text = on and "ACTIVE" or "INACTIVE"
                statusVal.TextColor3 = on and C_ACTIVE or C_INACTIVE
                statusDot.BackgroundColor3 = on and C_ACTIVE or C_INACTIVE
                TweenService:Create(toggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                }):Play()
            end

            mainBtn.MouseButton1Click:Connect(function()
                State.autoBatToggled = not State.autoBatToggled
                updateVisuals()
            end)
            
            local invisibleToggleBtn = Instance.new("TextButton", batPanel)
            invisibleToggleBtn.Size = UDim2.new(0, 50, 1, 0); invisibleToggleBtn.Position = UDim2.new(1, -65, 0, 0)
            invisibleToggleBtn.BackgroundTransparency = 1; invisibleToggleBtn.Text = ""; invisibleToggleBtn.ZIndex = 10
            invisibleToggleBtn.MouseButton1Click:Connect(function()
                State.autoBatToggled = not State.autoBatToggled
                updateVisuals()
            end)

            local function getBat()
                local char = player.Character; if not char then return nil end
                local tool = char:FindFirstChild("Bat"); if tool then return tool end
                local bp = player:FindFirstChild("Backpack")
                if bp then tool = bp:FindFirstChild("Bat"); if tool then tool.Parent = char; return tool end end
                return nil
            end

            local function tryHitBat()
                if State.hittingCooldown then return end; State.hittingCooldown = true
                pcall(function()
                    local bat = getBat(); if bat then
                        bat:Activate(); local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if ev then ev:FireServer() end
                    end
                end)
                task.delay(0.08, function() State.hittingCooldown = false end)
            end

            local function getClosestPlayer()
                if not hrp then return nil, math.huge end
                local cp, cd = nil, math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local tr = p.Character:FindFirstChild("HumanoidRootPart")
                        if tr then local d = (hrp.Position - tr.Position).Magnitude; if d < cd then cd = d; cp = p end end
                    end
                end
                return cp, cd
            end

            local function setupChar(char)
                task.wait(0.1)
                h = char:WaitForChild("Humanoid", 5); hrp = char:WaitForChild("HumanoidRootPart", 5)
            end

            player.CharacterAdded:Connect(setupChar)
            if player.Character then task.spawn(function() setupChar(player.Character) end) end

            RunService.Heartbeat:Connect(function()
                if not (State.autoBatToggled and h and hrp) then return end
                local target, dist = getClosestPlayer()
                if target and target.Character then
                    local tr = target.Character:FindFirstChild("HumanoidRootPart")
                    if tr then
                        if sethiddenproperty then sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end
                        local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                        if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = CFrame.new(targetPos) end
                        local cam = workspace.CurrentCamera
                        cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                        tryHitBat()
                    end
                end
            end)
        end)
    else
        if playerGui:FindFirstChild("VioletteTPBat") then
            playerGui.VioletteTPBat:Destroy()
        end
    end
end

-- بناء واجهة المستخدم الرئيسية مع زيادة الطول لاستيعاب الزر الجديد
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YoDealsHub"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local borderWrap = Instance.new("Frame")
borderWrap.Name = "SquircleBorderWrap"
borderWrap.Size = UDim2.new(0, 280, 0, 600)
borderWrap.Position = UDim2.new(0.5, -140, 0.5, -300)
borderWrap.BackgroundColor3 = Color3.new(0.0627451, 0.0156863, 0.0235294)
borderWrap.BackgroundTransparency = 0.15
borderWrap.BorderSizePixel = 0
borderWrap.Active = true
borderWrap.ZIndex = 10
borderWrap.Parent = screenGui
addCorner(borderWrap, 20)

local _, outerBorderGradient = addGradientStroke(borderWrap, 2, 0)
makeDraggable(borderWrap)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "SquircleMainFrame"
mainFrame.Size = UDim2.new(1, -4, 1, -4)
mainFrame.Position = UDim2.new(0, 2, 0, 2)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 11
mainFrame.Parent = borderWrap
addCorner(mainFrame, 18)

local headerGlow = Instance.new("Frame")
headerGlow.Name = "HeaderGlow"
headerGlow.Size = UDim2.new(1, 0, 0, 70)
headerGlow.Position = UDim2.fromOffset(0, 0)
headerGlow.BackgroundColor3 = Color3.new(1, 0.156863, 0.156863)
headerGlow.BackgroundTransparency = 0.9
headerGlow.BorderSizePixel = 0
headerGlow.ZIndex = 12
headerGlow.Parent = mainFrame
addCorner(headerGlow, 18)

local headerGlowGradient = Instance.new("UIGradient")
headerGlowGradient.Rotation = 90
headerGlowGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.15),
    NumberSequenceKeypoint.new(1, 1),
})
headerGlowGradient.Parent = headerGlow

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 46)
header.Position = UDim2.fromOffset(0, 0)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0
header.ZIndex = 13
header.Parent = mainFrame

local accent = Instance.new("Frame")
accent.Name = "Accent"
accent.Size = UDim2.new(0, 3, 0, 26)
accent.Position = UDim2.new(0, 8, 0, 10)
accent.BackgroundColor3 = Color3.new(1, 0.176471, 0.176471)
accent.BorderSizePixel = 0
accent.ZIndex = 14
accent.Parent = header
addCorner(accent, 2)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -66, 0, 18)
title.Position = UDim2.new(0, 16, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Cursed Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 14
title.Parent = header

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0.54902, 0.0392157, 0.0392157)),
    ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.27451, 0.27451)),
    ColorSequenceKeypoint.new(1, Color3.new(1, 0.705882, 0.705882)),
})
titleGradient.Rotation = 0
titleGradient.Parent = title

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, -66, 0, 13)
subtitle.Position = UDim2.new(0, 16, 0, 25)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Yo Deals x Cursed Hub"
subtitle.TextColor3 = Color3.new(1, 0.470588, 0.470588)
subtitle.TextTransparency = 0.25
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 14
subtitle.Parent = header

local minimise = Instance.new("TextButton")
minimise.Name = "Minimize"
minimise.Size = UDim2.new(0, 24, 0, 24)
minimise.Position = UDim2.new(1, -42, 0.5, -12)
minimise.BackgroundColor3 = Color3.new(0.14902, 0.0313726, 0.0392157)
minimise.BackgroundTransparency = 0.15
minimise.AutoButtonColor = false
minimise.BorderSizePixel = 0
minimise.Font = Enum.Font.GothamBlack
minimise.Text = "-"
minimise.TextSize = 14
minimise.TextColor3 = Color3.new(1, 1, 1)
minimise.ZIndex = 14
minimise.Parent = header
addCorner(minimise, 8)

local _, minimiseGradient = addGradientStroke(minimise, 1.5, 0)

-- محتوى القائمة
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -28, 1, -54)
content.Position = UDim2.new(0, 14, 0, 48)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.CanvasSize = UDim2.new(0, 0, 0, 620)
content.ScrollBarThickness = 2
content.ZIndex = 13
content.Parent = mainFrame

local animatedCardShines = {}
local animatedCardStrokes = {}
local animatedToggleStrokes = {}

local function makeFeatureCard(cardName, text, yOffset, defaultState, callback)
    local card = Instance.new("Frame")
    card.Name = cardName
    card.Size = UDim2.new(1, 0, 0, 54)
    card.Position = UDim2.new(0, 0, 0, yOffset)
    card.BackgroundColor3 = Color3.new(0.109804, 0.0235294, 0.0352941)
    card.BackgroundTransparency = 0.1
    card.BorderSizePixel = 0
    card.ZIndex = 14
    card.Parent = content
    addCorner(card, 14)

    local _, cardStrokeGradient = addGradientStroke(card, 1.2, 0)
    table.insert(animatedCardStrokes, cardStrokeGradient)

    local shine = Instance.new("Frame")
    shine.Name = "Shine"
    shine.Size = UDim2.new(1, 0, 1, 0)
    shine.Position = UDim2.fromOffset(0, 0)
    shine.BackgroundColor3 = Color3.new(1, 1, 1)
    shine.BackgroundTransparency = 0.94
    shine.BorderSizePixel = 0
    shine.ZIndex = 14
    shine.Parent = card
    addCorner(shine, 14)

    local shineGradient = Instance.new("UIGradient")
    shineGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
    })
    shineGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    shineGradient.Rotation = 90
    shineGradient.Parent = shine
    table.insert(animatedCardShines, shineGradient)

    local row = Instance.new("Frame")
    row.Name = "Row"
    row.Size = UDim2.new(1, -20, 0, 30)
    row.Position = UDim2.new(0, 10, 0, 12)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.ZIndex = 15
    row.Parent = card

    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(0, 0, 0.5, -3)
    dot.BackgroundColor3 = defaultState and Color3.new(1, 0.235294, 0.235294) or Color3.new(0.352941, 0.0784314, 0.0784314)
    dot.BorderSizePixel = 0
    dot.ZIndex = 16
    dot.Parent = row
    addCorner(dot, 3)

    local featureLabel = Instance.new("TextLabel")
    featureLabel.Name = "Label"
    featureLabel.Size = UDim2.new(0.55, 0, 1, 0)
    featureLabel.Position = UDim2.new(0, 14, 0, 0)
    featureLabel.BackgroundTransparency = 1
    featureLabel.Text = text
    featureLabel.TextColor3 = Color3.new(1, 0.921569, 0.921569)
    featureLabel.Font = Enum.Font.GothamBold
    featureLabel.TextSize = 12
    featureLabel.TextXAlignment = Enum.TextXAlignment.Left
    featureLabel.ZIndex = 15
    featureLabel.Parent = row

    local track = Instance.new("TextButton")
    track.Name = "Toggle"
    track.Size = UDim2.new(0, 44, 0, 24)
    track.Position = UDim2.new(1, -50, 0.5, -12)
    track.BackgroundColor3 = defaultState and Color3.new(0.588235, 0.0588235, 0.0705882) or Color3.new(0.27451, 0.054902, 0.0705882)
    track.BorderSizePixel = 0
    track.AutoButtonColor = false
    track.Text = ""
    track.ZIndex = 15
    track.Parent = row
    addCorner(track, 12)

    local _, toggleStrokeGradient = addGradientStroke(track, 1, 0)
    table.insert(animatedToggleStrokes, toggleStrokeGradient)

    local knob = Instance.new("TextButton")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = defaultState and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = defaultState and Color3.new(1, 0.921569, 0.921569) or Color3.new(0.470588, 0.352941, 0.352941)
    knob.BackgroundTransparency = defaultState and 0 or 0.55
    knob.BorderSizePixel = 0
    knob.AutoButtonColor = false
    knob.Text = ""
    knob.ZIndex = 16
    knob.Parent = track
    addCorner(knob, 10)

    local currentState = defaultState

    local function render(animated)
        local tweenInfo = TweenInfo.new(animated and 0.18 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(track, tweenInfo, {
            BackgroundColor3 = currentState and Color3.new(0.588235, 0.0588235, 0.0705882) or Color3.new(0.27451, 0.054902, 0.0705882)
        }):Play()
        TweenService:Create(knob, tweenInfo, {
            Position = currentState and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = currentState and Color3.new(1, 0.921569, 0.921569) or Color3.new(0.470588, 0.352941, 0.352941),
            BackgroundTransparency = currentState and 0 or 0.55,
        }):Play()
        TweenService:Create(dot, tweenInfo, {
            BackgroundColor3 = currentState and Color3.new(1, 0.235294, 0.235294) or Color3.new(0.352941, 0.0784314, 0.0784314),
        }):Play()
    end

    local function toggle()
        currentState = not currentState
        render(true)
        if callback then
            callback(currentState)
        end
    end

    track.Activated:Connect(toggle)
    knob.Activated:Connect(toggle)
    render(false)

    return card
end

-- إضافة الأزرار بالترتيب في القائمة
makeFeatureCard("AntiResetCard", "Anti Reset", 0, AntiResetEnabled, function(state)
    AntiResetEnabled = state
    if AntiResetEnabled then startAntiReset() else stopAntiReset() end
end)

makeFeatureCard("AntiBatCard", "Anti Bat", 58, AntiBatEnabled, function(state)
    AntiBatEnabled = state
    if AntiBatEnabled then startAntiBat() else stopAntiBat() end
end)

makeFeatureCard("AntiBatV2Card", "anti bat v2", 116, AntiBatV2Enabled, function(state)
    AntiBatV2Enabled = state
    if AntiBatV2Enabled then startAntiBatV2() else stopAntiBatV2() end
end)

makeFeatureCard("AntiMedusaCard", "انتي مادوسه", 174, AntiMedusaEnabled, function(state)
    AntiMedusaEnabled = state
    if AntiMedusaEnabled then startAntiMedusa() else stopAntiMedusa() end
end)

makeFeatureCard("YahyaV2Card", "يحيى في 2", 232, YahyaV2Enabled, function(state)
    YahyaV2Enabled = state
    if YahyaV2Enabled then startYahyaV2() else stopYahyaV2() end
end)

makeFeatureCard("InputSourceCard", "Input Source", 290, InputSourceEnabled, function(state)
    toggleInputSourceUI(state)
end)

makeFeatureCard("AntiKickCard", "Anti Kick / E01", 348, AntiKickEnabled, function(state)
    AntiKickEnabled = state
end)

makeFeatureCard("InfJumpCard", "Inf Jump (Normal)", 406, InfiniteJumpEnabled, function(state)
    InfiniteJumpEnabled = state
end)

makeFeatureCard("InfJumpHoldCard", "Inf Jump (Hold)", 464, InfiniteJumpHoldEnabled, function(state)
    InfiniteJumpHoldEnabled = state
    if not InfiniteJumpHoldEnabled then IsJumpingHold = false end
end)

makeFeatureCard("VioletteBatCard", "Violette TP Bat UI", 522, VioletteBatUIEnabled, function(state)
    toggleVioletteBatScript(state)
end)

startJumpHoldLoop()

-- تصغير وتكبير الواجهة
local EXPANDED_SIZE = UDim2.new(0, 280, 0, 600)
local COLLAPSED_SIZE = UDim2.new(0, 280, 0, 50)
local EXPANDED_CONTENT_POSITION = UDim2.new(0, 14, 0, 48)
local COLLAPSED_CONTENT_POSITION = UDim2.new(0, 14, 0, -620)
local collapsed = false
local minimiseBusy = false

minimise.MouseButton1Click:Connect(function()
    if minimiseBusy then return end
    minimiseBusy = true
    collapsed = not collapsed
    minimise.Text = collapsed and "+" or "-"

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)

    if collapsed then
        content.Visible = true
        local bodyTween = TweenService:Create(content, tweenInfo, { Position = COLLAPSED_CONTENT_POSITION })
        local windowTween = TweenService:Create(borderWrap, tweenInfo, { Size = COLLAPSED_SIZE })
        bodyTween:Play()
        windowTween:Play()
        windowTween.Completed:Once(function()
            content.Visible = false
            minimiseBusy = false
        end)
    else
        content.Visible = true
        content.Position = COLLAPSED_CONTENT_POSITION
        local bodyTween = TweenService:Create(content, tweenInfo, { Position = EXPANDED_CONTENT_POSITION })
        local windowTween = TweenService:Create(borderWrap, tweenInfo, { Size = EXPANDED_SIZE })
        windowTween:Play()
        bodyTween:Play()
        windowTween.Completed:Once(function()
            content.Position = EXPANDED_CONTENT_POSITION
            minimiseBusy = false
        end)
    end
end)

-- حركة وتوهج الحدود
RunService.RenderStepped:Connect(function(deltaTime)
    local frameScale = deltaTime * 60
    outerBorderGradient.Rotation = (outerBorderGradient.Rotation + 0.9 * frameScale) % 360
    headerGlowGradient.Rotation = (headerGlowGradient.Rotation + 1.4 * frameScale) % 360
    titleGradient.Rotation = (titleGradient.Rotation + 1.2 * frameScale) % 360
    minimiseGradient.Rotation = (minimiseGradient.Rotation + 1.6 * frameScale) % 360

    for _, item in ipairs(animatedCardShines) do
        item.Rotation = (item.Rotation + 1.4 * frameScale) % 360
    end
    for _, item in ipairs(animatedCardStrokes) do
        item.Rotation = (item.Rotation + 1.8 * frameScale) % 360
    end
    for _, item in ipairs(animatedToggleStrokes) do
        item.Rotation = (item.Rotation + 1.8 * frameScale) % 360
    end
end)

print("[Yo Deals x Yahya Hub + Anti Bat V2] Loaded Successfully!")
