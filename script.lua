--[[
    قائمة ديد ريلز - فوز فوري بالعملات
    الميزات:
    1. زر فوز سحري يجمع كل العملات
    2. زر إعادة تعيين اللعبة
    3. زر إخفاء/إظهار القائمة
    4. عرض عدد العملات الحالي
    5. تصميم فخم أحمر/أسود
]]

-- إنشاء الواجهة
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ألوان التصميم
local ColorScheme = {
    Main = Color3.fromRGB(30, 0, 0),
    Secondary = Color3.fromRGB(80, 0, 0),
    Accent = Color3.fromRGB(255, 40, 40),
    Text = Color3.fromRGB(255, 255, 255)
}

-- إنشاء الجرافيك
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadReelsMenu"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.1, 0, 0.5, -90)
MainFrame.BackgroundColor3 = ColorScheme.Main
MainFrame.BorderColor3 = ColorScheme.Accent
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- العنوان
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "ديد ريلز - 506"
Title.TextColor3 = ColorScheme.Accent
Title.TextSize = 24
Title.Font = Enum.Font.GothamBlack
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- زر الإغلاق
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "X"
CloseButton.TextSize = 20
CloseButton.TextColor3 = ColorScheme.Text
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = ColorScheme.Secondary
CloseButton.BorderSizePixel = 0
CloseButton.ZIndex = 2
CloseButton.Parent = MainFrame

-- عرض العملات
local CoinsLabel = Instance.new("TextLabel")
CoinsLabel.Name = "CoinsLabel"
CoinsLabel.Text = "العملات: جاري التحميل..."
CoinsLabel.TextColor3 = ColorScheme.Text
CoinsLabel.TextSize = 18
CoinsLabel.Font = Enum.Font.GothamBold
CoinsLabel.Size = UDim2.new(1, -20, 0, 30)
CoinsLabel.Position = UDim2.new(0, 10, 0, 50)
CoinsLabel.BackgroundTransparency = 1
CoinsLabel.Parent = MainFrame

-- زر الفوز السحري
local WinButton = Instance.new("TextButton")
WinButton.Name = "WinButton"
WinButton.Text = "فوز سحري 🎰"
WinButton.TextColor3 = Color3.fromRGB(255, 255, 0)
WinButton.TextSize = 20
WinButton.Font = Enum.Font.GothamBold
WinButton.Size = UDim2.new(0.9, 0, 0, 40)
WinButton.Position = UDim2.new(0.05, 0, 0, 90)
WinButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
WinButton.BorderSizePixel = 0
WinButton.Parent = MainFrame

-- زر إعادة التعيين
local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Text = "إعادة تعيين"
ResetButton.TextColor3 = ColorScheme.Text
ResetButton.TextSize = 18
ResetButton.Font = Enum.Font.Gotham
ResetButton.Size = UDim2.new(0.4, 0, 0, 30)
ResetButton.Position = UDim2.new(0.05, 0, 0, 140)
ResetButton.BackgroundColor3 = ColorScheme.Secondary
ResetButton.BorderSizePixel = 0
ResetButton.Parent = MainFrame

-- وظائف الفوز
local function CollectAllCoins()
    -- محاولة العثور على العملات في أماكن مختلفة
    local coinTypes = {"Coins", "Money", "Gold", "Points", "Tokens"}
    local totalCollected = 0
    
    -- البحث في Workspace
    for _, coinType in ipairs(coinTypes) do
        local coins = workspace:FindFirstChild(coinType)
        if coins and coins:IsA("Folder") then
            for _, coin in ipairs(coins:GetChildren()) do
                if coin:IsA("BasePart") then
                    coin:Destroy()
                    totalCollected += 100
                end
            end
        end
    end
    
    -- البحث في اللاعب
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, coinType in ipairs(coinTypes) do
            local coinValue = leaderstats:FindFirstChild(coinType)
            if coinValue and coinValue:IsA("IntValue") then
                coinValue.Value += 10000
                totalCollected += 10000
            end
        end
    end
    
    -- البحث في ReplicatedStorage
    local repStorage = game:GetService("ReplicatedStorage")
    for _, coinType in ipairs(coinTypes) do
        local coinValue = repStorage:FindFirstChild(coinType)
        if coinValue and coinValue:IsA("IntValue") then
            coinValue.Value += 5000
            totalCollected += 5000
        end
    end
    
    return totalCollected
end

local function TriggerWin()
    -- محاولة إيجاد أحداث الفوز
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotes then
        local winRemote = remotes:FindFirstChild("Win") or remotes:FindFirstChild("Complete")
        if winRemote and winRemote:IsA("RemoteEvent") then
            winRemote:FireServer()
            return true
        elseif winRemote and winRemote:IsA("RemoteFunction") then
            winRemote:InvokeServer()
            return true
        end
    end
    
    -- إذا لم يتم العثور على حدث الفوز
    return false
end

-- تحديث عرض العملات
local function UpdateCoinsDisplay()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local coinTypes = {"Coins", "Money", "Gold", "Points", "Tokens"}
        for _, coinType in ipairs(coinTypes) do
            local coinValue = leaderstats:FindFirstChild(coinType)
            if coinValue and coinValue:IsA("IntValue") then
                CoinsLabel.Text = "العملات: " .. coinValue.Value
                return
            end
        end
    end
    CoinsLabel.Text = "العملات: غير معروف"
end

-- إضافة وظائف الأزرار
WinButton.MouseButton1Click:Connect(function()
    local coinsCollected = CollectAllCoins()
    local winTriggered = TriggerWin()
    
    if coinsCollected > 0 then
        WinButton.Text = "تم الجمع! +" .. coinsCollected
        task.wait(1)
        WinButton.Text = "فوز سحري 🎰"
    end
    
    if winTriggered then
        WinButton.Text = "تم الفوز! 🏆"
        task.wait(2)
        WinButton.Text = "فوز سحري 🎰"
    end
end)

ResetButton.MouseButton1Click:Connect(function()
    player:LoadCharacter()
    CoinsLabel.Text = "العملات: جاري التحديث..."
    task.wait(1)
    UpdateCoinsDisplay()
end)

-- إغلاق القائمة
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- تحديث العملات بانتظام
RunService.Heartbeat:Connect(function()
    UpdateCoinsDisplay()
end)

-- اختصار لوحة المفاتيح لإظهار/إخفاء القائمة
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- التهيئة الأولية
task.wait(1)
UpdateCoinsDisplay()