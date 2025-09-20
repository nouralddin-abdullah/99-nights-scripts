-- ################################# --
-- ## Authentication Script ## --
-- ################################# --

-- Configure your links here
local MAIN_SCRIPT_URL = "https://pastefy.app/BiEtJLKA/raw" -- Paste your Main Script URL here
local KEY_URL = "https://pastefy.app/Q4X1xLAN/raw" -- Paste your Key URL here
local SHORTCUT_LINK = "https://exe-links.com/99-nights-key" -- Paste the link required to get the key
local DISCORD_LINK = "https://discord.gg/pH3NyVYC72" -- Discord link

-- Authentication settings
local REQUIRE_KEY = true -- Set to false to skip key verification and run script directly

-- ################################# --
-- ## UI and Logic ## --
-- ################################# --

local CoreGui = game:GetService("CoreGui")

-- Function to load the main script
local function loadMainScript()
    local mainScriptSuccess, mainScriptContent = pcall(function()
        return game:HttpGet(MAIN_SCRIPT_URL)
    end)

    if mainScriptSuccess then
        loadstring(mainScriptContent)()
        print("Main script loaded successfully!")
    else
        warn("Failed to load main script: " .. tostring(mainScriptContent))
    end
end

-- Check if key verification is required
if not REQUIRE_KEY then
    print("Key verification disabled. Loading main script directly...")
    
    -- Create simple interface without key
    local SimpleScreen = Instance.new("ScreenGui")
    SimpleScreen.Name = "SimpleAuthScreen"
    SimpleScreen.Parent = CoreGui
    SimpleScreen.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(350, 200)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.Parent = SimpleScreen
    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Title.Text = "🌟 Welcome to 99 Nights 🌟"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Parent = MainFrame
    local UICorner2 = Instance.new("UICorner", Title)
    UICorner2.CornerRadius = UDim.new(0, 10)

    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Size = UDim2.new(1, -20, 0, 30)
    WelcomeLabel.Position = UDim2.new(0, 10, 0, 50)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "Choose one of the following options:"
    WelcomeLabel.Font = Enum.Font.Gotham
    WelcomeLabel.TextSize = 14
    WelcomeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    WelcomeLabel.Parent = MainFrame

    local StartButton = Instance.new("TextButton")
    StartButton.Size = UDim2.new(1, -40, 0, 35)
    StartButton.Position = UDim2.new(0, 20, 0, 90)
    StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    StartButton.Text = "🚀 Start Script"
    StartButton.Font = Enum.Font.GothamBold
    StartButton.TextSize = 14
    StartButton.TextColor3 = Color3.new(1, 1, 1)
    StartButton.Parent = MainFrame
    local UICorner3 = Instance.new("UICorner", StartButton)
    UICorner3.CornerRadius = UDim.new(0, 8)

    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Size = UDim2.new(1, -40, 0, 35)
    DiscordButton.Position = UDim2.new(0, 20, 0, 135)
    DiscordButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
    DiscordButton.Text = "💬 Join Discord"
    DiscordButton.Font = Enum.Font.GothamBold
    DiscordButton.TextSize = 14
    DiscordButton.TextColor3 = Color3.new(1, 1, 1)
    DiscordButton.Parent = MainFrame
    local UICorner4 = Instance.new("UICorner", DiscordButton)
    UICorner4.CornerRadius = UDim.new(0, 8)

    -- Button events
    StartButton.MouseButton1Click:Connect(function()
        SimpleScreen:Destroy()
        loadMainScript()
    end)

    DiscordButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
            DiscordButton.Text = "✅ Discord link copied!"
            DiscordButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            task.wait(2)
            DiscordButton.Text = "💬 Join Discord"
            DiscordButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
        end
    end)

    return
end

-- If REQUIRE_KEY = true, show authentication interface
print("Key verification enabled. Showing authentication interface...")

-- Create the interface
local KeyAuthScreen = Instance.new("ScreenGui")
KeyAuthScreen.Name = "KeyAuthScreen"
KeyAuthScreen.Parent = CoreGui
KeyAuthScreen.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(380, 280)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Parent = KeyAuthScreen
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "🔐 Verification Required"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = MainFrame
local UICorner2 = Instance.new("UICorner", Title)
UICorner2.CornerRadius = UDim.new(0, 10)

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 35)
KeyInput.Position = UDim2.new(0, 20, 0, 60)
KeyInput.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
KeyInput.PlaceholderText = "Enter key here..."
KeyInput.Text = ""
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 14
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Parent = MainFrame
local UICorner3 = Instance.new("UICorner", KeyInput)
UICorner3.CornerRadius = UDim.new(0, 8)

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0.48, 0, 0, 35)
GetKeyButton.Position = UDim2.new(0.02, 20, 0, 110)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GetKeyButton.Text = "🔑 Get Key"
GetKeyButton.Font = Enum.Font.GothamBold
GetKeyButton.TextSize = 12
GetKeyButton.TextColor3 = Color3.new(1, 1, 1)
GetKeyButton.Parent = MainFrame
local UICorner4 = Instance.new("UICorner", GetKeyButton)
UICorner4.CornerRadius = UDim.new(0, 8)

local CheckKeyButton = Instance.new("TextButton")
CheckKeyButton.Size = UDim2.new(0.48, 0, 0, 35)
CheckKeyButton.Position = UDim2.new(0.5, 0, 0, 110)
CheckKeyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CheckKeyButton.Text = "✅ Check Key"
CheckKeyButton.Font = Enum.Font.GothamBold
CheckKeyButton.TextSize = 12
CheckKeyButton.TextColor3 = Color3.new(1, 1, 1)
CheckKeyButton.Parent = MainFrame
local UICorner5 = Instance.new("UICorner", CheckKeyButton)
UICorner5.CornerRadius = UDim.new(0, 8)

local DiscordButton = Instance.new("TextButton")
DiscordButton.Size = UDim2.new(1, -40, 0, 35)
DiscordButton.Position = UDim2.new(0, 20, 0, 160)
DiscordButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
DiscordButton.Text = "💬 Join Discord"
DiscordButton.Font = Enum.Font.GothamBold
DiscordButton.TextSize = 14
DiscordButton.TextColor3 = Color3.new(1, 1, 1)
DiscordButton.Parent = MainFrame
local UICorner6 = Instance.new("UICorner", DiscordButton)
UICorner6.CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 30)
StatusLabel.Position = UDim2.new(0, 20, 0, 210)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Enter key or get a new one"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Button functions
GetKeyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(SHORTCUT_LINK)
        StatusLabel.Text = "Key link copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
        GetKeyButton.Text = "✅ Copied!"
        GetKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        task.wait(2)
        GetKeyButton.Text = "🔑 Get Key"
        GetKeyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    else
        StatusLabel.Text = "Could not copy link."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

DiscordButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
        StatusLabel.Text = "Discord link copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
        DiscordButton.Text = "✅ Discord link copied!"
        DiscordButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        task.wait(2)
        DiscordButton.Text = "💬 Join Discord"
        DiscordButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
    else
        StatusLabel.Text = "Could not copy link."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

CheckKeyButton.MouseButton1Click:Connect(function()
    StatusLabel.Text = "Checking..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

    -- Fetch the correct key from the link
    local success, correctKey = pcall(function()
        return game:HttpGet(KEY_URL)
    end)

    if not success then
        StatusLabel.Text = "Error: Cannot fetch key."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end

    -- Remove extra spaces from keys for proper comparison
    local enteredKey = KeyInput.Text:match("^%s*(.-)%s*$")
    correctKey = correctKey:match("^%s*(.-)%s*$")

    if enteredKey == correctKey then
        StatusLabel.Text = "Success! Loading script..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
        CheckKeyButton.Text = "✅ Valid Key!"
        CheckKeyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        task.wait(1)
        KeyAuthScreen:Destroy() -- Close key interface

        -- Load main script
        loadMainScript()
    else
        StatusLabel.Text = "Invalid key."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        CheckKeyButton.Text = "❌ Wrong Key"
        CheckKeyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(2)
        CheckKeyButton.Text = "✅ Check Key"
        CheckKeyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end)