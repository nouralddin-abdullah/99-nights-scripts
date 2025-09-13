-- Sapling Planter - V13 (Enhanced GUI with Dragging & Minimize)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- NEW: Get a reference to the map's ground to use in our whitelist
local groundPart = workspace:WaitForChild("Map"):WaitForChild("Ground")

--============================================================================--
--      [[ CONFIGURATION ]]
--============================================================================--
local CONFIG = {
    SHAPES = {"Square", "Circle", "Star"},
    DEFAULT_SHAPE = "Square",
    DEFAULT_SIZE = 40, 
    MIN_SIZE = 10,
    MAX_SIZE = 200,
    DEFAULT_SPACING = 8,
    MIN_SPACING = 4,
    MAX_SPACING = 20,
    DEFAULT_HEIGHT_OFFSET = 0.5,
    MIN_HEIGHT_OFFSET = 0,
    MAX_HEIGHT_OFFSET = 20,
    HIGHLIGHT_COLOR = Color3.fromRGB(120, 255, 120)
}

-- Enhanced UI Theme
local THEME = {
    COLORS = {
        PRIMARY = Color3.fromRGB(64, 128, 255),
        PRIMARY_HOVER = Color3.fromRGB(74, 138, 255),
        SECONDARY = Color3.fromRGB(45, 45, 50),
        BACKGROUND = Color3.fromRGB(25, 25, 30),
        SURFACE = Color3.fromRGB(35, 35, 40),
        SUCCESS = Color3.fromRGB(76, 175, 80),
        SUCCESS_HOVER = Color3.fromRGB(86, 185, 90),
        WARNING = Color3.fromRGB(255, 152, 0),
        WARNING_HOVER = Color3.fromRGB(255, 162, 20),
        DANGER = Color3.fromRGB(244, 67, 54),
        DANGER_HOVER = Color3.fromRGB(254, 77, 64),
        TEXT = Color3.fromRGB(255, 255, 255),
        TEXT_SECONDARY = Color3.fromRGB(200, 200, 200),
        ACCENT = Color3.fromRGB(156, 39, 176)
    }
}

--============================================================================--
--      [[ SCRIPT STATE & CORE LOGIC (Same as original) ]]
--============================================================================--
local currentShape, currentSize, currentSpacing, currentHeightOffset = CONFIG.DEFAULT_SHAPE, CONFIG.DEFAULT_SIZE, CONFIG.DEFAULT_SPACING, CONFIG.DEFAULT_HEIGHT_OFFSET
local shapePoints, highlightParts, isPlanting, guiElements = {}, {}, false, {}
local previewDebounceThread, DEBOUNCE_TIME = nil, 0.2

local function getCenterPoint() 
    local fireCenter = workspace.Map and workspace.Map.Campground and workspace.Map.Campground.MainFire and workspace.Map.Campground.MainFire.Center
    if fireCenter then 
        return fireCenter.Position 
    else 
        return player.Character and player.Character.PrimaryPart.Position or Vector3.zero 
    end 
end

local function clearHighlights() 
    for _, part in ipairs(highlightParts) do 
        part:Destroy() 
    end
    highlightParts = {} 
end

local function clearShape() 
    clearHighlights()
    shapePoints = {}
    if guiElements.ProgressLabel then 
        guiElements.ProgressLabel.Text = "Progress: N/A" 
    end
    print("Shape cleared.") 
end

local function createHighlight(position, index) 
    local highlight = Instance.new("Part")
    highlight.Name = "PlantingHighlight"
    highlight.Shape = Enum.PartType.Ball
    highlight.Size = Vector3.new(3, 3, 3)
    highlight.Anchored = true
    highlight.CanCollide = false
    highlight.Color = CONFIG.HIGHLIGHT_COLOR
    highlight.Material = Enum.Material.Neon
    highlight.Transparency = 0.6
    highlight.CFrame = CFrame.new(position)
    highlight.Parent = workspace
    highlightParts[index] = highlight 
end

local function previewShape()
    clearShape()
    local centerPoint = getCenterPoint()
    local pointsToCalculate = {}
    
    if currentShape == "Square" then
        local halfWidth = currentSize / 2
        local numPointsPerSide = math.floor((halfWidth * 2) / currentSpacing)
        for i = 0, numPointsPerSide do
            local pos = -halfWidth + (i * currentSpacing)
            table.insert(pointsToCalculate, centerPoint + Vector3.new(pos, 50, halfWidth))
            table.insert(pointsToCalculate, centerPoint + Vector3.new(pos, 50, -halfWidth))
            if i > 0 and i < numPointsPerSide then 
                table.insert(pointsToCalculate, centerPoint + Vector3.new(halfWidth, 50, pos))
                table.insert(pointsToCalculate, centerPoint + Vector3.new(-halfWidth, 50, pos)) 
            end
        end
    elseif currentShape == "Circle" then
        local radius = currentSize
        local circumference = 2 * math.pi * radius
        local numPoints = math.floor(circumference / currentSpacing)
        for i = 1, numPoints do 
            local angle = (i / numPoints) * 2 * math.pi
            local x = radius * math.cos(angle)
            local z = radius * math.sin(angle)
            table.insert(pointsToCalculate, centerPoint + Vector3.new(x, 50, z)) 
        end
    elseif currentShape == "Star" then
        local outerRadius = currentSize
        local innerRadius = outerRadius / 2
        local numPoints = 5
        for i = 0, (numPoints * 2) - 1 do 
            local radius = (i % 2 == 0) and outerRadius or innerRadius
            local angle = (i / (numPoints * 2)) * 2 * math.pi
            local x = radius * math.cos(angle - math.pi/2)
            local z = radius * math.sin(angle - math.pi/2)
            table.insert(pointsToCalculate, centerPoint + Vector3.new(x, 50, z)) 
        end
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Whitelist
    rayParams.FilterDescendantsInstances = {groundPart}
    
    for i, point in ipairs(pointsToCalculate) do
        local result = workspace:Raycast(point, Vector3.new(0, -100, 0), rayParams)
        if result and result.Instance then
            local groundPos = result.Position + Vector3.new(0, currentHeightOffset, 0)
            table.insert(shapePoints, {position = groundPos, status = "Empty", highlightIndex = i})
            createHighlight(groundPos, i)
        end
    end
    
    if guiElements.ProgressLabel then 
        guiElements.ProgressLabel.Text = "Progress: 0 / " .. #shapePoints 
    end
end

--============================================================================--
--      [[ ENHANCED GUI CREATION WITH DRAGGING & MINIMIZE ]]
--============================================================================--

-- Utility functions for enhanced UI
local function createRoundedFrame(parent, size, position, backgroundColor, cornerRadius)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = backgroundColor
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or 8)
    corner.Parent = frame
    
    return frame
end

local function createButton(parent, size, position, text, backgroundColor, textColor, onClick)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = backgroundColor
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = textColor
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Add hover effect
    local originalColor = backgroundColor
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.new(
            originalColor.R + 0.1,
            originalColor.G + 0.1, 
            originalColor.B + 0.1
        )})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = originalColor})
        tween:Play()
    end)
    
    if onClick then
        button.MouseButton1Click:Connect(onClick)
    end
    
    return button
end

local function createLabel(parent, size, position, text, textColor, textSize, font)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = textColor or THEME.COLORS.TEXT
    label.TextSize = textSize or 14
    label.Font = font or Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SaplingPlanterEnhanced"
screenGui.ResetOnSpawn = false

-- Main container with shadow effect
local shadowFrame = createRoundedFrame(screenGui, UDim2.new(0, 300, 0, 450), UDim2.new(0, 15, 0.5, -225), Color3.fromRGB(0, 0, 0), 12)
shadowFrame.BackgroundTransparency = 0.7

local mainFrame = createRoundedFrame(screenGui, UDim2.new(0, 290, 0, 440), UDim2.new(0, 10, 0.5, -220), THEME.COLORS.BACKGROUND, 12)

-- Minimize state variables
local isMinimized = false
local originalSize = mainFrame.Size
local minimizedSize = UDim2.new(0, 290, 0, 50)

-- Header with gradient and dragging functionality
local headerFrame = createRoundedFrame(mainFrame, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 10), THEME.COLORS.PRIMARY, 8)
local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.COLORS.PRIMARY),
    ColorSequenceKeypoint.new(1, THEME.COLORS.ACCENT)
})
headerGradient.Rotation = 45
headerGradient.Parent = headerFrame

local titleLabel = createLabel(headerFrame, UDim2.new(1, -80, 1, 0), UDim2.new(0, 20, 0, 0), "🌱 Sapling Planter", THEME.COLORS.TEXT, 18, Enum.Font.GothamBold)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize button
local minimizeBtn = createButton(headerFrame, UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10), "–", THEME.COLORS.SECONDARY, THEME.COLORS.TEXT, nil)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold

-- Dragging functionality
local isDragging = false
local dragStart = nil
local startPos = nil

headerFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        shadowFrame.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + 5, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + 5)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- Content frame (will be hidden/shown when minimizing)
local contentFrame = createRoundedFrame(mainFrame, UDim2.new(1, 0, 1, -50), UDim2.new(0, 0, 0, 50), Color3.fromRGB(0, 0, 0), 0)
contentFrame.BackgroundTransparency = 1

-- Minimize functionality
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and minimizedSize or originalSize
    local targetShadowSize = isMinimized and UDim2.new(0, 300, 0, 60) or UDim2.new(0, 300, 0, 450)
    
    minimizeBtn.Text = isMinimized and "+" or "–"
    contentFrame.Visible = not isMinimized
    
    local tween1 = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize})
    local tween2 = TweenService:Create(shadowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetShadowSize})
    
    tween1:Play()
    tween2:Play()
end)

-- Shape selection section
local shapeSection = createRoundedFrame(contentFrame, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 15), THEME.COLORS.SURFACE, 6)
local shapeSectionLabel = createLabel(shapeSection, UDim2.new(1, -15, 0, 20), UDim2.new(0, 15, 0, 5), "Shape Configuration", THEME.COLORS.TEXT_SECONDARY, 12, Enum.Font.GothamMedium)

local shapeDropdown = createRoundedFrame(shapeSection, UDim2.new(1, -30, 0, 25), UDim2.new(0, 15, 0, 20), THEME.COLORS.SECONDARY, 4)
local shapeLabel = createLabel(shapeDropdown, UDim2.new(1, -30, 1, 0), UDim2.new(0, 10, 0, 0), "Shape: " .. currentShape, THEME.COLORS.TEXT, 13)

local shapeBtn = Instance.new("TextButton")
shapeBtn.Size = UDim2.new(1, 0, 1, 0)
shapeBtn.BackgroundTransparency = 1
shapeBtn.Text = ""
shapeBtn.Parent = shapeDropdown

local dropdownIcon = createLabel(shapeDropdown, UDim2.new(0, 20, 1, 0), UDim2.new(1, -25, 0, 0), "▼", THEME.COLORS.TEXT_SECONDARY, 10)
dropdownIcon.TextXAlignment = Enum.TextXAlignment.Center

-- Create dropdown at screen level with higher ZIndex to fix overlap issue
local shapeOptionsFrame = createRoundedFrame(screenGui, UDim2.new(0, 260, 0, 90), UDim2.new(0, 25, 0, 200), THEME.COLORS.SECONDARY, 4)
shapeOptionsFrame.Visible = false
shapeOptionsFrame.ClipsDescendants = true
shapeOptionsFrame.ZIndex = 10

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = shapeOptionsFrame

shapeBtn.MouseButton1Click:Connect(function() 
    shapeOptionsFrame.Visible = not shapeOptionsFrame.Visible
    dropdownIcon.Text = shapeOptionsFrame.Visible and "▲" or "▼"
    
    -- Position dropdown relative to the button
    if shapeOptionsFrame.Visible then
        local buttonPos = shapeDropdown.AbsolutePosition
        local buttonSize = shapeDropdown.AbsoluteSize
        shapeOptionsFrame.Position = UDim2.new(0, buttonPos.X, 0, buttonPos.Y + buttonSize.Y + 5)
    end
end)

-- Hide dropdown when clicking elsewhere
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local framePos = shapeOptionsFrame.AbsolutePosition
        local frameSize = shapeOptionsFrame.AbsoluteSize
        
        if shapeOptionsFrame.Visible and (mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or 
           mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y) then
            -- Check if click was on the dropdown button
            local buttonPos = shapeDropdown.AbsolutePosition
            local buttonSize = shapeDropdown.AbsoluteSize
            if not (mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
                    mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y) then
                shapeOptionsFrame.Visible = false
                dropdownIcon.Text = "▼"
            end
        end
    end
end)

for i, shapeName in ipairs(CONFIG.SHAPES) do
    local optionBtn = createButton(shapeOptionsFrame, UDim2.new(1, -10, 0, 25), UDim2.new(0, 5, 0, 0), shapeName, THEME.COLORS.BACKGROUND, THEME.COLORS.TEXT, function()
        currentShape = shapeName
        shapeLabel.Text = "Shape: " .. currentShape
        shapeOptionsFrame.Visible = false
        dropdownIcon.Text = "▼"
        previewShape()
    end)
    optionBtn.Font = Enum.Font.Gotham
    optionBtn.TextSize = 12
    optionBtn.ZIndex = 11
end

-- Enhanced slider creation function
local function createEnhancedSlider(parent, text, yPos, min, max, default, suffix)
    local sliderFrame = createRoundedFrame(parent, UDim2.new(1, -20, 0, 55), UDim2.new(0, 10, 0, yPos), THEME.COLORS.SURFACE, 6)
    
    local label = createLabel(sliderFrame, UDim2.new(1, -15, 0, 18), UDim2.new(0, 15, 0, 5), text, THEME.COLORS.TEXT_SECONDARY, 12, Enum.Font.GothamMedium)
    local valueLabel = createLabel(sliderFrame, UDim2.new(0, 80, 0, 18), UDim2.new(1, -95, 0, 5), default .. (suffix or ""), THEME.COLORS.TEXT, 12, Enum.Font.GothamBold)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local track = createRoundedFrame(sliderFrame, UDim2.new(1, -30, 0, 6), UDim2.new(0, 15, 0, 35), THEME.COLORS.BACKGROUND, 3)
    local progress = createRoundedFrame(track, UDim2.new((default - min) / (max - min), 0, 1, 0), UDim2.new(0, 0, 0, 0), THEME.COLORS.PRIMARY, 3)
    
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    handle.BackgroundColor3 = THEME.COLORS.TEXT
    handle.BorderSizePixel = 0
    handle.Text = ""
    handle.Parent = track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    local isSliderDragging = false
    
    handle.MouseButton1Down:Connect(function() 
        isSliderDragging = true 
        handle.BackgroundColor3 = THEME.COLORS.PRIMARY
    end)
    
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            isSliderDragging = false
            handle.BackgroundColor3 = THEME.COLORS.TEXT
        end 
    end)
    
    local function updateValue(input)
        if not isSliderDragging then return end
        local trackWidth = track.AbsoluteSize.X
        local mouseX = input.Position.X
        local trackX = track.AbsolutePosition.X
        local handleX = math.clamp(mouseX - trackX, 0, trackWidth)
        
        local percentage = handleX / trackWidth
        handle.Position = UDim2.new(percentage, -8, 0.5, -8)
        progress.Size = UDim2.new(percentage, 0, 1, 0)
        
        local value = min + (max - min) * percentage
        return value, valueLabel, suffix
    end
    
    return updateValue
end

-- Create enhanced sliders
local updateSize = createEnhancedSlider(contentFrame, "Dimension", 75, CONFIG.MIN_SIZE, CONFIG.MAX_SIZE, CONFIG.DEFAULT_SIZE, " studs")
local updateSpacing = createEnhancedSlider(contentFrame, "Spacing", 140, CONFIG.MIN_SPACING, CONFIG.MAX_SPACING, CONFIG.DEFAULT_SPACING, " studs") 
local updateHeight = createEnhancedSlider(contentFrame, "Height Offset", 205, CONFIG.MIN_HEIGHT_OFFSET, CONFIG.MAX_HEIGHT_OFFSET, CONFIG.DEFAULT_HEIGHT_OFFSET, " units")

-- Handle slider updates
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local valueChanged = false
        
        local newSize, sizeLabel, sizeSuffix = updateSize(input)
        if newSize and currentSize ~= math.floor(newSize) then
            currentSize = math.floor(newSize)
            sizeLabel.Text = currentSize .. (sizeSuffix or "")
            valueChanged = true
        end
        
        local newSpacing, spacingLabel, spacingSuffix = updateSpacing(input)
        if newSpacing and currentSpacing ~= math.floor(newSpacing) then
            currentSpacing = math.floor(newSpacing)
            spacingLabel.Text = currentSpacing .. (spacingSuffix or "")
            valueChanged = true
        end
        
        local newHeight, heightLabel, heightSuffix = updateHeight(input)
        if newHeight and currentHeightOffset ~= newHeight then
            currentHeightOffset = math.floor(newHeight * 10) / 10
            heightLabel.Text = string.format("%.1f", currentHeightOffset) .. (heightSuffix or "")
            valueChanged = true
        end
        
        if valueChanged then
            if previewDebounceThread then
                task.cancel(previewDebounceThread)
            end
            previewDebounceThread = task.delay(DEBOUNCE_TIME, function()
                previewShape()
            end)
        end
    end
end)

-- Action buttons section
local buttonSection = createRoundedFrame(contentFrame, UDim2.new(1, -20, 0, 80), UDim2.new(0, 10, 0, 275), THEME.COLORS.SURFACE, 6)

local previewBtn = createButton(buttonSection, UDim2.new(0.48, 0, 0, 30), UDim2.new(0, 10, 0, 10), "🔍 Preview", THEME.COLORS.PRIMARY, THEME.COLORS.TEXT, previewShape)
local clearBtn = createButton(buttonSection, UDim2.new(0.48, 0, 0, 30), UDim2.new(0.52, 0, 0, 10), "🗑️ Clear", THEME.COLORS.DANGER, THEME.COLORS.TEXT, clearShape)

-- Progress display
local progressFrame = createRoundedFrame(buttonSection, UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, 45), THEME.COLORS.BACKGROUND, 4)
local progressLabel = createLabel(progressFrame, UDim2.new(1, -15, 1, 0), UDim2.new(0, 15, 0, 0), "Progress: N/A", THEME.COLORS.TEXT, 13, Enum.Font.GothamMedium)
progressLabel.TextXAlignment = Enum.TextXAlignment.Center
guiElements.ProgressLabel = progressLabel

-- Plant/Stop buttons
local plantBtn = createButton(contentFrame, UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 365), "🌱 Start Planting", THEME.COLORS.SUCCESS, THEME.COLORS.TEXT, nil)
local stopBtn = createButton(contentFrame, UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 365), "⏹️ Stop Planting", THEME.COLORS.WARNING, THEME.COLORS.TEXT, nil)
stopBtn.Visible = false

local function setButtons(canPlant) 
    plantBtn.Visible = canPlant
    stopBtn.Visible = not canPlant
    previewBtn.AutoButtonColor = canPlant
    clearBtn.AutoButtonColor = canPlant
end

stopBtn.MouseButton1Click:Connect(function() 
    isPlanting = false
    print("Planting paused.") 
end)

--============================================================================--
--      [[ PLANTING LOGIC (Same as original) ]]
--============================================================================--

plantBtn.MouseButton1Click:Connect(function() 
    if #shapePoints == 0 then 
        warn("Please preview a shape.") 
        return 
    end
    if isPlanting then 
        warn("Already planting.") 
        return 
    end
    
    isPlanting = true
    setButtons(false)
    
    task.spawn(function() 
        local plantRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem")
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then 
            warn("Character not found.")
            isPlanting = false
            setButtons(true)
            return 
        end
        
        local availableSaplings = {}
        for _, item in ipairs(workspace.Items:GetChildren()) do
            if item.Name == "Sapling" then 
                table.insert(availableSaplings, item) 
            end
        end
        
        local plantedCount = 0
        for _, pointData in ipairs(shapePoints) do
            if pointData.status == "Planted" then 
                plantedCount = plantedCount + 1 
            end
        end
        
        guiElements.ProgressLabel.Text = "Progress: " .. plantedCount .. " / " .. #shapePoints
        print("Found " .. #availableSaplings .. " saplings.")
        
        for i, pointData in ipairs(shapePoints) do
            if not isPlanting then break end
            
            if pointData.status == "Empty" then
                if #availableSaplings == 0 then 
                    print("Ran out of saplings.")
                    break 
                end
                
                local saplingToPlant = table.remove(availableSaplings, 1)
                local originalPos = rootPart.CFrame
                rootPart.CFrame = saplingToPlant:GetPivot() * CFrame.new(0, 3, 3)
                task.wait(0.2)
                
                local success, result = pcall(function() 
                    return plantRemote:InvokeServer(saplingToPlant, pointData.position) 
                end)
                
                rootPart.CFrame = originalPos
                
                if success and result then
                    print("Planted sapling #"..i)
                    pointData.status = "Planted"
                    plantedCount = plantedCount + 1
                    guiElements.ProgressLabel.Text = "Progress: " .. plantedCount .. " / " .. #shapePoints
                    
                    local highlight = highlightParts[pointData.highlightIndex]
                    if highlight then 
                        highlight:Destroy() 
                    end
                    highlightParts[pointData.highlightIndex] = nil
                else
                    warn("Failed to plant sapling #"..i)
                    table.insert(availableSaplings, 1, saplingToPlant)
                end
                
                task.wait(0.5)
            end
        end
        
        isPlanting = false
        setButtons(true)
        print("Planting process finished or paused.")
    end) 
end)

script.Parent = mainFrame
screenGui.Parent = player:WaitForChild("PlayerGui")
