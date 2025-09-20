--[[
    99 Night At Forest - Player Module (Initial Phase)
    This script currently ONLY initializes the UI and adds core player attribute controls.
    Scope (as requested):
      - GUI initialization with a single "Player" tab/section
      - Controls for player character attributes:
          * Speed (WalkSpeed)
          * Jump (JumpPower)
          * Noclip (disables collisions on the local character parts)
    No extra features beyond those listed are added in this phase.
]]

-- Load external UI library
local ApocLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/nouralddin-abdullah/Apoc/refs/heads/main/toasty.lua"))()

-- Services / core references
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Camera control state
local CameraControl = {
    OriginalCameraType = nil,
    OriginalCFrame = nil,
    FrozenConnection = nil,
    IsFrozen = false
}

-- Global teleportation state control
local TeleportationControl = {
    IsBusy = false,
    CurrentItem = nil,
    StartTime = 0
}

-- Create main window
local Window = ApocLibrary:CreateWindow({
    Name = "ToastyXD Hub",
    Icon = 4483362458, -- Placeholder asset id (update if you have a custom icon)
    LoadingTitle = "99 Night Interface",
    LoadingSubtitle = "Loading script...",
    ShowText = "99NF",
    Theme = "Default",
    ToggleUIKeybind = 'K',
    DisableApocPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Create Info tab (Important Information)
InfoTab = Window:CreateTab("Information", 4483362458)
InfoSection = InfoTab:CreateSection("Important Information")

-- Create Misc tab
MiscTab = Window:CreateTab("Misc", 4483362458)
MiscSection = MiscTab:CreateSection("Miscellaneous")

-- Single Player tab & section (as requested)
PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerSection = PlayerTab:CreateSection("Player Settings")

-- Create Combat tab
CombatTab = Window:CreateTab("Combat", 4483362458)
CombatSection = CombatTab:CreateSection("Auto Attack")

-- Create Trees tab
TreesTab = Window:CreateTab("Trees", 4483362458)
TreesSection = TreesTab:CreateSection("Tree Cutting")

-- Create Campfire tab
CampfireTab = Window:CreateTab("Campfire", 4483362458)
CampfireSection = CampfireTab:CreateSection("Auto Refill")

-- Create Crafting tab
CraftingTab = Window:CreateTab("Crafting", 4483362458)
CraftingSection = CraftingTab:CreateSection("Scrapper Machine")

-- Create Food tab
FoodTab = Window:CreateTab("Food", 4483362458)
FoodSection = FoodTab:CreateSection("Food Transport")

-- Create Animal Pelts tab
AnimalPeltsTab = Window:CreateTab("Animal Pelts", 4483362458)
AnimalPeltsSection = AnimalPeltsTab:CreateSection("Animal Pelts Transport")

-- Create Healing tab
HealingTab = Window:CreateTab("Healing", 4483362458)
HealingSection = HealingTab:CreateSection("Healing Items Transport")

-- Create Ammo tab
AmmoTab = Window:CreateTab("Ammo", 4483362458)
AmmoSection = AmmoTab:CreateSection("Ammo Transport")

-- Create Chests tab
ChestsTab = Window:CreateTab("Chests", 4483362458)
ChestsSection = ChestsTab:CreateSection("Chest Finder")

-- Create ESP tab
ESPTab = Window:CreateTab("ESP", 4483362458)
ESPSection = ESPTab:CreateSection("Visual ESP")

-- Create Skybase tab
SkybaseTab = Window:CreateTab("Skybase", 4483362458)
SkybaseSection = SkybaseTab:CreateSection("Auto Survival")

-- Create Lost Children tab
LostChildrenTab = Window:CreateTab("Lost Children", 4483362458)
LostChildrenSection = LostChildrenTab:CreateSection("Child Rescue")

GUITap = Window:CreateTab("GUIS", 4483362458)
GUISection = GUITap:CreateSection("Independant GUI's Section")

-- Create Credits tab
CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsSection = CreditsTab:CreateSection("About Developer & Support")


-- English Translation Mappings for Display Names
DisplayTranslations = {
    -- Tree Types
    ["Every tree"] = "Every Tree",
    ["Small Tree"] = "Small Tree",
    ["Snowy Small Tree"] = "Snowy Small Tree",
    ["TreeBig1"] = "Large Tree Type 1",
    ["TreeBig2"] = "Large Tree Type 2", 
    ["TreeBig3"] = "Large Tree Type 3",
    
    -- Refill Items
    ["All"] = "All Items",
    ["Log"] = "Log",
    ["Coal"] = "Coal",
    ["Biofuel"] = "Biofuel",
    ["Fuel Canister"] = "Fuel Canister",
    ["Oil Barrel"] = "Oil Barrel",

    -- Scrap Items
    ["Bolt"] = "Bolt",
    ["Sheet Metal"] = "Sheet Metal",
    ["Broken Fan"] = "Broken Fan",
    ["Old Radio"] = "Old Radio",
    ["Broken Microwave"] = "Broken Microwave",
    ["Tyre"] = "Tire",
    ["Metal Chair"] = "Metal Chair",
    ["Old Car Engine"] = "Old Car Engine",
    ["Washing Machine"] = "Washing Machine",
    ["Cultist Experiment"] = "Cultist Experiment",
    ["Cultist Prototype"] = "Cultist Prototype",
    ["UFO Scrap"] = "UFO Scrap",
    
    -- Cultist Gem
    ["Cultist Gem"] = "Cultist Gem",
    
    -- Food Items
    ["All Food"] = "All Food",
    ["Cake"] = "Cake",
    ["Ribs"] = "Ribs",
    ["Steak"] = "Steak",
    ["Morsel"] = "Morsel",
    ["Carrot"] = "Carrot",
    ["Corn"] = "Corn",
    ["Pumpkin"] = "Pumpkin",
    ["Berry"] = "Berry",
    ["Apple"] = "Apple",
    ["Chili"] = "Chili",
    
    -- Animal Pelts
    ["Bunny Foot"] = "Bunny Foot",
    ["Wolf Pelt"] = "Wolf Pelt",
    ["Alpha Wolf Pelt"] = "Alpha Wolf Pelt",
    ["Bear Pelt"] = "Bear Pelt",
    ["Arctic Fox Pelt"] = "Arctic Fox Pelt",
    ["Polar Bear Pelt"] = "Polar Bear Pelt",
    ["Mammoth Tusk"] = "Mammoth Tusk",
    
    -- Healing Items
    ["All Healing"] = "All Healing Items",
    ["Bandage"] = "Bandage",
    ["Medkit"] = "Medical Kit",
    
    -- Ammo Items
    ["All Ammo"] = "All Ammo Types",
    ["Revolver Ammo"] = "Revolver Ammo",
    ["Rifle Ammo"] = "Rifle Ammo",
    ["Shotgun Ammo"] = "Shotgun Ammo",
    
    -- Entities
    ["Cultist"] = "Cultist",
    ["Crossbow Cultist"] = "Crossbow Cultist",
    ["Juggernaut Cultist"] = "Juggernaut Cultist",
    ["Wolf"] = "Wolf",
    ["Alpha Wolf"] = "Alpha Wolf",
    ["Bear"] = "Bear",
    ["Polar Bear"] = "Polar Bear",
    ["The Deer"] = "The Deer",
    ["Alien"] = "Alien",
    ["Alien Elite"] = "Alien Elite",
    ["Arctic Fox"] = "Arctic Fox",
    ["Mammoth"] = "Mammoth",
    ["Bunny"] = "Bunny",
    
    -- Destinations
    ["Player"] = "Player",
    ["Campfire"] = "Campfire", 
    ["Scrapper"] = "Scrapper",
    ["Sack"] = "Sack",
    
    -- General Terms
    ["Enable"] = "Enable",
    ["Disable"] = "Disable",
    ["None"] = "None"
}

-- Function to get English display translation or return original if not found
local function GetDisplayText(englishText)
    return DisplayTranslations[englishText] or englishText
end

-- Function to create translated dropdown options
local function CreateTranslatedOptions(englishArray)
    local translatedArray = {}
    for i, englishItem in ipairs(englishArray) do
        translatedArray[i] = GetDisplayText(englishItem)
    end
    return translatedArray
end

-- Player attribute control state
local PlayerControl = {
    SpeedEnabled = false,
    SpeedValue = 32, -- default WalkSpeed override
    JumpEnabled = false,
    JumpValue = 50,  -- default JumpPower override
    FlyEnabled = false, -- replaces previous Noclip
    FlySpeed = 60, -- studs/second
    OriginalsStored = false,
    OriginalWalkSpeed = nil,
    OriginalJumpPower = nil
}

-- Trap control state
local TrapControl = {
    AutoTrapEnabled = false,
    TargetPlayer = "None",
    LastTrapUpdate = 0,
    TrapUpdateCooldown = 0.1, -- Update trap position every 0.1 seconds (much faster)
    OriginalTrapSizes = {}, -- Store original sensor sizes
    ActiveTraps = {} -- Track active traps for cleanup
}

-- Combat control state
local CombatControl = {
    KillAuraEnabled = false,
    UltraKillEnabled = false, -- New option to attack all targets in range
    AuraRange = 1000, -- studs - increased to 1000 as requested
    LastAuraAttack = 0,
    AttackCooldown = 0.9, -- Fixed axe cooldown timing (0.9 seconds)
    DebugMode = false, -- Disabled debug messages
    InitialAxe = nil, -- Track the axe user had when first enabling kill aura
    CurrentAxe = nil, -- Track currently equipped axe
    WeaponType = "General Axe", -- Selected weapon type
    -- Firearm options
    InstantReloadEnabled = false,
    ReloadTime = 0,
    FireRateEnabled = false,
    FireRate = 0.05
}

-- Store original weapon values for restoration
local OriginalWeaponValues = {}

-- Firearm modification functions
local function storeOriginalValues(weapon)
    if weapon:GetAttribute("ToolName") == "Firearm" and not OriginalWeaponValues[weapon] then
        OriginalWeaponValues[weapon] = {
            ReloadTime = weapon:GetAttribute("ReloadTime"),
            FireRate = weapon:GetAttribute("FireRate")
        }
    end
end

local function patchWeapon(weapon)
    if weapon:GetAttribute("ToolName") == "Firearm" then
        storeOriginalValues(weapon)
        
        if CombatControl.InstantReloadEnabled then
            weapon:SetAttribute("ReloadTime", CombatControl.ReloadTime)
        else
            -- Restore original reload time if disabled
            local original = OriginalWeaponValues[weapon]
            if original and original.ReloadTime then
                weapon:SetAttribute("ReloadTime", original.ReloadTime)
            end
        end
        
        if CombatControl.FireRateEnabled then
            weapon:SetAttribute("FireRate", CombatControl.FireRate)
        else
            -- Restore original firerate if disabled
            local original = OriginalWeaponValues[weapon]
            if original and original.FireRate then
                weapon:SetAttribute("FireRate", original.FireRate)
            end
        end
    end
end

local function updateAllFirearms()
    local player = Players.LocalPlayer
    local inventory = player:WaitForChild("Inventory")
    
    for _, item in ipairs(inventory:GetChildren()) do
        patchWeapon(item)
    end
end

local function initializeFirearmModification()
    local player = Players.LocalPlayer
    local inventory = player:WaitForChild("Inventory")
    
    for _, item in ipairs(inventory:GetChildren()) do
        patchWeapon(item)
    end
    
    inventory.ChildAdded:Connect(function(newItem)
        patchWeapon(newItem)
    end)
end

-- Weapon Types for Kill Aura
local WeaponTypes = {
    "General Axe",
    "Spear", 
    "Morningstar",
    "Ice Sword",
    "Infernal Sword",
    "Laser Sword",
    "Poison Spear",
    "Trident",
    "Katana"
}

-- Trees control state
local TreesControl = {
    ChoppingAuraEnabled = false,
    UltraChoppingEnabled = false, -- New option to chop all trees in range
    ChoppingRange = 1000, -- studs
    LastChoppingAttack = 0,
    ChoppingCooldown = 0.9, -- Same cooldown as combat
    DebugMode = false, -- Disabled debug messages
    ActiveBillboards = {}, -- Track active health displays
    UltraChopCount = 3, -- Configurable count for ultra chopping (1-6)
    TargetTreeType = "Every tree", -- Which tree type to target
    CurrentTargets = {} -- Array to track trees currently being chopped
}

-- Tree types array
local TreeTypes = {
    "Every tree",
    "Small Tree",
    "Snowy Small Tree", 
    "TreeBig1",
    "TreeBig2",
    "TreeBig3"
}

-- Campfire control state
local CampfireControl = {
    AutoRefillEnabled = false,
    ContinuousRefillEnabled = false, -- Refill without percentage consideration
    RefillPercentage = 25, -- Percentage threshold to trigger refill
    RefillItemType = "All", -- What items to use for refilling
    TeleportDestination = "Campfire", -- Where to teleport items (default: Campfire)
    TeleportHeight = 35, -- Height for teleportation (0-50 studs)
    LastRefillCheck = 0,
    RefillCheckCooldown = 1, -- Configurable cooldown (0.5-2 seconds)
    DebugMode = false, -- Disabled debug messages
    TeleportedItems = {}, -- Track items teleported with UltimateItemTransporter
    SavedPlayerPosition = nil -- Saved position when teleporter is enabled
}

-- Refill item types array
local RefillItemTypes = {
    "All",
    "Log",
    "Coal",
    "Biofuel",
    "Fuel Canister",
    "Oil Barrel"
}

-- Crafting control state
local CraftingControl = {
    ProduceScrapEnabled = false,
    ProduceWoodEnabled = false,
    ProduceCultistGemEnabled = false,
    ScrapItemType = "All", -- What items to use for scrap production
    WoodItemType = "All", -- What items to use for wood production (should be logs)
    CultistGemItemType = "All", -- What items to use for cultist gem production
    TeleportDestination = "Scrapper", -- Where to teleport items (default: Scrapper)
    TeleportHeight = 35, -- Height for teleportation (0-50 studs)
    TeleportCooldown = 15, -- Customizable teleport cooldown (default: 15 seconds)
    LastCraftingCheck = 0,
    ScrapCooldown = 1.5, -- Fixed cooldown for scrap production (3.5 seconds)
    WoodCooldown = 1.5, -- Fixed cooldown for wood production (2 seconds)
    CultistGemCooldown = 15, -- Fixed cooldown for cultist gem production (10 seconds)
    DebugMode = false, -- Disabled debug messages
    UsedItemsForCampfire = {}, -- Track items used for campfire to avoid conflicts
    UsedItemsForCrafting = {}, -- Track items used for crafting to avoid conflicts
    TeleportedItems = {}, -- Track items teleported with UltimateItemTransporter
    SavedPlayerPosition = nil -- Saved position when crafting is enabled
}

-- Food control state
local FoodControl = {
    TeleportFoodEnabled = false,
    TeleportDestination = "Player", -- "Player" or "Campfire"
    FoodItemType = "All", -- What food items to teleport
    TeleportHeight = 35, -- Height for teleportation (0-50 studs)
    LastFoodTeleport = 0,
    TeleportCooldown = 1, -- Configurable cooldown (0.5-5 seconds)
    DebugMode = false, -- Disabled debug messages
    TeleportedItems = {}, -- Track items that have been teleported to avoid re-teleporting
    SavedPlayerPosition = nil -- Saved position when teleporter is enabled
}

-- Animal Pelts control state
local AnimalPeltsControl = {
    TeleportPeltsEnabled = false,
    TeleportDestination = "Player", -- "Player" or "Campfire"
    PeltItemType = "Bunny Foot", -- What pelt items to teleport
    TeleportHeight = 35, -- Height for teleportation (0-50 studs)
    LastPeltTeleport = 0,
    TeleportCooldown = 1, -- Configurable cooldown (0.5-5 seconds)
    DebugMode = false, -- Disabled debug messages
    TeleportedItems = {}, -- Track items that have been teleported to avoid re-teleporting
    SavedPlayerPosition = nil -- Saved position when teleporter is enabled
}

-- Healing control state
local HealingControl = {
    TeleportHealingEnabled = false,
    TeleportDestination = "Player", -- "Player" or "Campfire"
    HealingItemType = "Bandage", -- What healing items to teleport
    TeleportHeight = 35, -- Height for teleportation (0-50 studs)
    LastHealingTeleport = 0,
    TeleportCooldown = 1, -- Configurable cooldown (0.5-5 seconds)
    DebugMode = false, -- Disabled debug messages
    TeleportedItems = {}, -- Track items that have been teleported to avoid re-teleporting
    SavedPlayerPosition = nil -- Saved position when teleporter is enabled
}

-- Ammo control state
local AmmoControl = {
    TeleportAmmoEnabled = false,
    TeleportDestination = "Player", -- "Player" only for ammo
    AmmoItemType = "All", -- What ammo items to teleport
    TeleportHeight = 35, -- Height for teleportation (0-50 studs)
    LastAmmoTeleport = 0,
    TeleportCooldown = 1, -- Configurable cooldown (0.5-5 seconds)
    DebugMode = false, -- Disabled debug messages
    TeleportedItems = {}, -- Track items that have been teleported to avoid re-teleporting
    SavedPlayerPosition = nil -- Saved position when teleporter is enabled
}

-- Lighting control state
local LightingControl = {
    AlwaysDayEnabled = false,
    Connection = nil,
    OriginalSettings = {},
    ColorCorrection = nil
}

-- Always Day Lighting functionality
local function initializeLighting()
    local Lighting = game:GetService("Lighting")
    
    -- Find or create the ColorCorrection effect
    LightingControl.ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not LightingControl.ColorCorrection then
        LightingControl.ColorCorrection = Instance.new("ColorCorrectionEffect")
        LightingControl.ColorCorrection.Parent = Lighting
    end
    
    -- Store the game's original settings
    LightingControl.OriginalSettings = {
        ClockTime = Lighting.ClockTime,
        Brightness = LightingControl.ColorCorrection.Brightness,
        Saturation = LightingControl.ColorCorrection.Saturation,
        TintColor = LightingControl.ColorCorrection.TintColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor
    }
end

local function applyCustomLighting()
    local Lighting = game:GetService("Lighting")
    local ALWAYS_DAY_SETTINGS = {
        ClockTime = 14,
        Brightness = 0.1,
        Saturation = 0.05,
        TintColor = Color3.fromRGB(255, 255, 255),
        FogStart = 2000,
        FogEnd = 10000,
        FogColor = Color3.fromRGB(195, 200, 210)
    }
    
    Lighting.ClockTime = ALWAYS_DAY_SETTINGS.ClockTime
    Lighting.FogStart = ALWAYS_DAY_SETTINGS.FogStart
    Lighting.FogEnd = ALWAYS_DAY_SETTINGS.FogEnd
    Lighting.FogColor = ALWAYS_DAY_SETTINGS.FogColor
    
    LightingControl.ColorCorrection.Enabled = true
    LightingControl.ColorCorrection.Brightness = ALWAYS_DAY_SETTINGS.Brightness
    LightingControl.ColorCorrection.Saturation = ALWAYS_DAY_SETTINGS.Saturation
    LightingControl.ColorCorrection.TintColor = ALWAYS_DAY_SETTINGS.TintColor
end

local function restoreOriginalLighting()
    local Lighting = game:GetService("Lighting")
    local original = LightingControl.OriginalSettings
    
    Lighting.ClockTime = original.ClockTime
    Lighting.FogStart = original.FogStart
    Lighting.FogEnd = original.FogEnd
    Lighting.FogColor = original.FogColor
    
    LightingControl.ColorCorrection.Brightness = original.Brightness
    LightingControl.ColorCorrection.Saturation = original.Saturation
    LightingControl.ColorCorrection.TintColor = original.TintColor
end

local function onRenderStep()
    if LightingControl.AlwaysDayEnabled then
        applyCustomLighting()
    end
end

local function toggleAlwaysDay(enabled)
    LightingControl.AlwaysDayEnabled = enabled
    
    if enabled then
        if not LightingControl.Connection then
            LightingControl.Connection = RunService.RenderStepped:Connect(onRenderStep)
        end
    else
        if LightingControl.Connection then
            LightingControl.Connection:Disconnect()
            LightingControl.Connection = nil
        end
        restoreOriginalLighting()
    end
end

-- ESP control state
local ESPControl = {
    Enabled = false,
    ESPObjects = {}, -- Store ESP GUI objects for cleanup
    Categories = {
        Food = false,
        AnimalPelts = false,
        Healing = false,
        Ammo = false,
        Entities = false,
        Chests = false,
        Players = false
    },
    Colors = {
        Food = Color3.fromRGB(255, 165, 0), -- Orange
        AnimalPelts = Color3.fromRGB(139, 69, 19), -- Brown
        Healing = Color3.fromRGB(0, 255, 0), -- Green
        Ammo = Color3.fromRGB(255, 255, 0), -- Yellow
        Entities = Color3.fromRGB(255, 100, 100), -- Light Red
        Chests = Color3.fromRGB(255, 0, 255), -- Magenta
        Players = Color3.fromRGB(255, 0, 0) -- Red
    }
}

-- Skybase control state
local SkybaseControl = {
    GuiEnabled = false,
    PlatformModel = nil,
    SkybaseGui = nil,
    MOVE_INCREMENT = 2, -- How far the platform moves per click
    SmartAutoEatEnabled = false,
    HungerThreshold = 50, -- Default hunger threshold
    LastHungerCheck = 0,
    HungerCheckCooldown = 5, -- Check every 5 seconds to avoid spam
    -- Anti-AFK variables
    AntiAfkEnabled = false,
    AntiAfkConnection = nil,
    LastJumpTime = 0,
    JumpInterval = 300 -- 5 minutes (300 seconds)
}

-- Lost Children control state
local LostChildrenControl = {
    RescueEnabled = false,
    OriginalPosition = nil,
    RescuedChildren = {}, -- Track which children have been rescued
    VisitedWolves = {}, -- Track visited wolf positions and surrounding areas
    CurrentStep = "idle", -- idle, searching, rescuing, returning
    LastTeleportPosition = nil,
    TeleportCooldown = 2, -- Seconds between teleports (increased to 4)
    LastTeleportTime = 0,
    OriginalGravity = nil -- Store original gravity value
}

-- Lost Children GUI variables (declared here for global access)
local LostChildrenToggle = nil
local LostChildrenStatus = nil

-- Children data mapping
local ChildrenData = {
    ["Lost Child"] = {name = "Dino", tent = "TentDinoKid"},
    ["Lost Child2"] = {name = "Kraken", tent = "TentKrakenKid"}, 
    ["Lost Child3"] = {name = "Squid", tent = "TentSquidKid"},
    ["Lost Child4"] = {name = "Koala", tent = "TentKoalaKid"}
}

-- Scrap item types array
local ScrapItemTypes = {
    "All",
    "Bolt",
    "Sheet Metal", 
    "Broken Fan",
    "Old Radio",
    "Broken Microwave",
    "Tyre",
    "Metal Chair",
    "Old Car Engine",
    "Washing Machine",
    "Cultist Experiment",
    "Cultist Prototype",
    "UFO Scrap"
}

-- Wood item types array (for crafting)
local WoodItemTypes = {
    "All",
    "Log"
}

-- Cultist Gem item types array (for crafting)
local CultistGemItemTypes = {
    "All",
    "Cultist Gem"
}

-- Food item types array
local FoodItemTypes = {
    "All",
    "Cake", 
    "Ribs",
    "Steak",
    "Morsel",
    "Carrot",
    "Corn",
    "Pumpkin",
    "Berry",
    "Apple",
    "Chili"
}

-- Smart Auto Eat food items (specific foods for hunger management)
local SmartEatFoodTypes = {
    "Carrot",
    "Corn", 
    "Pumpkin",
    "Cake"
}

-- Animal Pelts item types array
local AnimalPeltTypes = {
    "Bunny Foot",
    "Wolf Pelt",
    "Alpha Wolf Pelt",
    "Bear Pelt",
    "Arctic Fox Pelt",
    "Polar Bear Pelt",
    "Mammoth Tusk"
}

-- Healing item types array
local HealingItemTypes = {
    "Bandage",
    "Medkit"
}

-- Ammo item types array
local AmmoItemTypes = {
    "All",
    "Revolver Ammo",
    "Rifle Ammo",
    "Shotgun Ammo",
    "Fuel Canister"
}

-- Entities item types array (Creatures/Mobs)
local EntityTypes = {
    "Cultist",
    "Crossbow Cultist",
    "Juggernaut Cultist",
    "Wolf",
    "Alpha Wolf", 
    "Bear",
    "Polar Bear",
    "The Deer",
    "Alien",
    "Alien Elite",
    "Arctic Fox",
    "Mammoth",
    "Bunny"
}

-- Food teleport destinations
local FoodDestinations = {
    "Player",
    "Campfire"
}

-- Animal Pelts teleport destinations
local PeltDestinations = {
    "Player",
    "Campfire"
}

-- Healing teleport destinations
local HealingDestinations = {
    "Player",
    "Campfire"
}

-- Campfire teleport destinations  
local CampfireDestinations = {
    "Campfire",
    "Player",
    "Sack"
}

-- Crafting teleport destinations
local CraftingDestinations = {
    "Scrapper",
    "Player",
    "Sack"
}

-- Unified axe management (shared between combat and chopping)
local AxeManager = {
    LastEquipTime = 0,
    EquipCooldown = 0.1, -- Prevent spam equipping
    CurrentlyEquipped = nil
}

-- Direct axe equipping function (called before each action)
local function EquipBestAxeNow()
    -- Get player's inventory
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if not inventory then
        return false
    end
    
    -- Get the correct remotes from ReplicatedStorage
    local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
    if not remoteEvents then
        return false
    end
    
    local equipItemRemote = remoteEvents:FindFirstChild("EquipItemHandle")
    if not equipItemRemote then
        return false
    end
    
    -- Define axe hierarchy (best to worst)
    local axeHierarchy = {
        "Chainsaw",     -- Highest tier
        "Strong Axe",   -- High tier
        "Ice Axe",      -- Mid tier
        "Good Axe",     -- Low tier
        "Old Axe"       -- Base tier
    }
    
    local axeToUse = nil
    local axeToUseName = nil
    
    -- Find the best available axe
    for _, axeName in ipairs(axeHierarchy) do
        local axe = inventory:FindFirstChild(axeName)
        if axe then
            axeToUse = axe
            axeToUseName = axeName
            break
        end
    end
    
    if not axeToUse then
        return false -- No axe found
    end
    
    -- Always equip the axe (no caching)
    local equipSuccess = pcall(function()
        local equipArgs = {
            [1] = "FireAllClients",
            [2] = axeToUse
        }
        equipItemRemote:FireServer(unpack(equipArgs))
    end)
    
    if equipSuccess then
        AxeManager.CurrentlyEquipped = axeToUseName
        return true, axeToUse
    end
    
    return false
end

-- Function to equip best weapon based on weapon type
local function EquipBestWeapon(weaponType)
    -- Get player's inventory
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if not inventory then
        return false
    end
    
    -- Get the correct remotes from ReplicatedStorage
    local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
    if not remoteEvents then
        return false
    end
    
    local equipItemRemote = remoteEvents:FindFirstChild("EquipItemHandle")
    if not equipItemRemote then
        return false
    end
    
    local weaponToUse = nil
    local weaponToUseName = nil
    
    if weaponType == "General Axe" then
        -- Use the existing axe hierarchy
        local axeHierarchy = {
            "Chainsaw",     -- Highest tier
            "Strong Axe",   -- High tier
            "Ice Axe",      -- Mid tier
            "Good Axe",     -- Low tier
            "Old Axe"       -- Base tier
        }
        
        -- Find the best available axe
        for _, axeName in ipairs(axeHierarchy) do
            local axe = inventory:FindFirstChild(axeName)
            if axe then
                weaponToUse = axe
                weaponToUseName = axeName
                break
            end
        end
    else
        -- For other weapon types, find the exact weapon
        local weapon = inventory:FindFirstChild(weaponType)
        if weapon then
            weaponToUse = weapon
            weaponToUseName = weaponType
        end
    end
    
    if not weaponToUse then
        return false -- No weapon found
    end
    
    -- Equip the weapon
    local equipSuccess = pcall(function()
        local equipArgs = {
            [1] = "FireAllClients",
            [2] = weaponToUse
        }
        equipItemRemote:FireServer(unpack(equipArgs))
    end)
    
    if equipSuccess then
        return true, weaponToUse
    end
    
    return false
end

-- Fly input tracking
local FlyKeys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    LeftShift = false
}

UserInputService.InputBegan:Connect(function(input, gpe)
    -- Allow LeftShift even if game processed it (sprint binding) so down-fly still works
    if gpe and input.KeyCode ~= Enum.KeyCode.LeftShift then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.W then FlyKeys.W = true
    elseif kc == Enum.KeyCode.A then FlyKeys.A = true
    elseif kc == Enum.KeyCode.S then FlyKeys.S = true
    elseif kc == Enum.KeyCode.D then FlyKeys.D = true
    elseif kc == Enum.KeyCode.Space then FlyKeys.Space = true
    elseif kc == Enum.KeyCode.LeftShift then FlyKeys.LeftShift = true end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    local kc = input.KeyCode
    if kc == Enum.KeyCode.W then FlyKeys.W = false
    elseif kc == Enum.KeyCode.A then FlyKeys.A = false
    elseif kc == Enum.KeyCode.S then FlyKeys.S = false
    elseif kc == Enum.KeyCode.D then FlyKeys.D = false
    elseif kc == Enum.KeyCode.Space then FlyKeys.Space = false
    elseif kc == Enum.KeyCode.LeftShift then FlyKeys.LeftShift = false end
end)

-- Store original humanoid properties (once per character spawn)
local function StoreOriginals(humanoid)
    if PlayerControl.OriginalsStored or not humanoid then return end
    PlayerControl.OriginalWalkSpeed = humanoid.WalkSpeed
    if humanoid.UseJumpPower then
        PlayerControl.OriginalJumpPower = humanoid.JumpPower
    else
        PlayerControl.OriginalJumpPower = humanoid.JumpHeight
    end
    PlayerControl.OriginalsStored = true
end

-- Apply speed if enabled
local function ApplySpeed(humanoid)
    if PlayerControl.SpeedEnabled and humanoid then
        humanoid.WalkSpeed = PlayerControl.SpeedValue
    elseif humanoid and PlayerControl.OriginalWalkSpeed then
        humanoid.WalkSpeed = PlayerControl.OriginalWalkSpeed
    end
end

-- Apply jump if enabled
local function ApplyJump(humanoid)
    if not humanoid then return end
    if PlayerControl.JumpEnabled then
        if humanoid.UseJumpPower then
            humanoid.JumpPower = PlayerControl.JumpValue
        else
            humanoid.JumpHeight = PlayerControl.JumpValue
        end
    elseif PlayerControl.OriginalJumpPower then
        if humanoid.UseJumpPower then
            humanoid.JumpPower = PlayerControl.OriginalJumpPower
        else
            humanoid.JumpHeight = PlayerControl.OriginalJumpPower
        end
    end
end

-- Get all player names for dropdown
local function GetPlayerNames()
    local playerNames = {"None"}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

-- Find all bear traps in workspace
local function FindAllBearTraps()
    local traps = {}
    local structuresFolder = workspace:FindFirstChild("Structures")
    if not structuresFolder then
        return traps
    end
    
    for _, structure in pairs(structuresFolder:GetChildren()) do
        if structure.Name == "Bear Trap" then
            table.insert(traps, structure)
        end
    end
    
    return traps
end

-- Set trap at location
local function SetTrap(trap)
    if not trap then return false end
    
    -- Check if trap is already set
    local trapSet = trap:GetAttribute("TrapSet")
    if trapSet == true then
        return true -- Trap is already set, no need to call remote
    end
    
    -- Only call RequestSetTrap if trap is not set (TrapSet is false or nil)
    local success = pcall(function()
        local args = {[1] = trap}
        game:GetService("ReplicatedStorage").RemoteEvents.RequestSetTrap:FireServer(unpack(args))
    end)
    
    return success
end

-- Modify trap sensor size
local function ModifyTrapSensor(trap, size)
    if not trap then return end
    
    local trapSensor = trap:FindFirstChild("TrapSensor")
    if trapSensor then
        -- Store original size if not already stored
        if not TrapControl.OriginalTrapSizes[trap] then
            TrapControl.OriginalTrapSizes[trap] = trapSensor.Size
        end
        
        trapSensor.Size = size
    end
end

-- Restore trap sensor to original size
local function RestoreTrapSensor(trap)
    if not trap then return end
    
    local trapSensor = trap:FindFirstChild("TrapSensor")
    local originalSize = TrapControl.OriginalTrapSizes[trap]
    
    if trapSensor and originalSize then
        trapSensor.Size = originalSize
    end
end

-- Move trap to target player position
local function MoveTrapToPlayer(trap, targetPlayerName)
    if not trap or targetPlayerName == "None" then return false end
    
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    -- Get player's humanoid root part position
    local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
    
    -- Position trap exactly under player's feet (ground level)
    -- Using Y offset of -3 to place it slightly underground for better triggering
    local trapPosition = targetPosition + Vector3.new(0, -3, 0)
    
    -- Move trap to position
    if trap.PrimaryPart then
        trap:SetPrimaryPartCFrame(CFrame.new(trapPosition))
    elseif trap:FindFirstChild("Root") then
        trap.Root.CFrame = CFrame.new(trapPosition)
    end
    
    return true
end

-- Update auto trap system
local function UpdateAutoTrap()
    if not TrapControl.AutoTrapEnabled or TrapControl.TargetPlayer == "None" then
        return
    end
    
    local currentTime = tick()
    if currentTime - TrapControl.LastTrapUpdate < TrapControl.TrapUpdateCooldown then
        return
    end
    
    TrapControl.LastTrapUpdate = currentTime
    
    -- Find target player
    local targetPlayer = game.Players:FindFirstChild(TrapControl.TargetPlayer)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    -- Find all bear traps
    local bearTraps = FindAllBearTraps()
    
    for _, trap in pairs(bearTraps) do
        -- Set expanded sensor size
        ModifyTrapSensor(trap, Vector3.new(25, 25, 25))
        
        -- Set trap
        SetTrap(trap)
        
        -- Move trap to target player
        MoveTrapToPlayer(trap, TrapControl.TargetPlayer)
        
        -- Set trap again after moving
        SetTrap(trap)
        
        -- Track this trap as active
        TrapControl.ActiveTraps[trap] = true
    end
end

-- Cleanup trap system when disabled
local function CleanupTraps()
    -- Restore all trap sensors to original size
    for trap, _ in pairs(TrapControl.ActiveTraps) do
        if trap and trap.Parent then
            RestoreTrapSensor(trap)
        end
    end
    
    -- Clear active traps
    TrapControl.ActiveTraps = {}
end

-- Debug function to print messages to dev console (defined at top level)
local function DebugMsg(tag, message)
    -- Debug disabled - no output
end

-- Camera freeze/unfreeze functions
local function FreezeCamera()
    if CameraControl.IsFrozen then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    -- Store original camera settings
    CameraControl.OriginalCameraType = camera.CameraType
    CameraControl.OriginalCFrame = camera.CFrame
    CameraControl.IsFrozen = true
    
    -- Set camera to scriptable and freeze at current position
    camera.CameraType = Enum.CameraType.Scriptable
    
    -- Create connection to maintain frozen position
    CameraControl.FrozenConnection = RunService.RenderStepped:Connect(function()
        if CameraControl.IsFrozen and CameraControl.OriginalCFrame then
            camera.CFrame = CameraControl.OriginalCFrame
        end
    end)
end

local function UnfreezeCamera()
    if not CameraControl.IsFrozen then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    -- Disconnect the frozen connection
    if CameraControl.FrozenConnection then
        CameraControl.FrozenConnection:Disconnect()
        CameraControl.FrozenConnection = nil
    end
    
    -- Restore original camera type
    if CameraControl.OriginalCameraType then
        camera.CameraType = CameraControl.OriginalCameraType
    end
    
    CameraControl.IsFrozen = false
    CameraControl.OriginalCFrame = nil
    CameraControl.OriginalCameraType = nil
end

-- Helper functions for item collision control
local function disableItemCollisions(item)
    local originalStates = {}
    for _, part in ipairs(item:GetDescendants()) do
        if part:IsA("BasePart") then
            originalStates[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    return originalStates
end

local function restoreItemCollisions(originalStates)
    for part, canCollide in pairs(originalStates) do
        if part and part.Parent then
            part.CanCollide = canCollide
        end
    end
end

-- Simple sack helper functions using ItemBag children count
local function findPlayerInventorySack()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local inventory = player:FindFirstChild("Inventory")
    
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item.Name:find("Sack") then
                return item
            end
        end
    end
    return nil
end

local function getSackInfo()
    local sack = findPlayerInventorySack()
    if not sack then
        return 0, 0
    end
    
    local capacity = sack:GetAttribute("Capacity") or 0
    local itemBag = game:GetService("Players").LocalPlayer:FindFirstChild("ItemBag")
    local currentItems = itemBag and #itemBag:GetChildren() or 0
    
    return capacity, currentItems
end

local function isSackFull()
    local capacity, currentItems = getSackInfo()
    return currentItems >= capacity
end

-- Ultimate Item Transporter Function
local function UltimateItemTransporter(targetItem, destinationPart, trackingTable, teleportCooldown, savedPlayerPosition, teleportHeight)
    if not targetItem or not targetItem.Parent then
        return false
    end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local rootPart = char.HumanoidRootPart
    local itemPart = targetItem.PrimaryPart or targetItem:FindFirstChildOfClass("BasePart")
    
    if not itemPart then
        return false
    end
    
    -- Use provided height or default to 35
    local height = teleportHeight or 35
    local destinationCFrame = nil
    
    if destinationPart == "Player" then
        if savedPlayerPosition then
            destinationCFrame = savedPlayerPosition * CFrame.new(0, height, 0)
        else
            destinationCFrame = rootPart.CFrame * CFrame.new(0, height, 0)
        end
    elseif typeof(destinationPart) == "Instance" then
        local targetPart = nil
        if destinationPart:IsA("BasePart") then
            targetPart = destinationPart
        elseif destinationPart:IsA("Model") then
            targetPart = destinationPart.PrimaryPart or destinationPart:FindFirstChildOfClass("BasePart")
        end
        
        if targetPart then
            destinationCFrame = targetPart.CFrame * CFrame.new(0, height, 0)
        else
            return false
        end
    else
        return false
    end
    
    itemPart.CFrame = destinationCFrame
    itemPart.AssemblyLinearVelocity = Vector3.zero
    itemPart.AssemblyAngularVelocity = Vector3.zero
    
    rootPart.CFrame = destinationCFrame * CFrame.new(0, 5, 0)
    
    task.wait(0.1)
    
    local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
    if remoteEvents then
        local requestStartDragging = remoteEvents:FindFirstChild("RequestStartDraggingItem")
        if requestStartDragging then
            pcall(function()
                requestStartDragging:FireServer(targetItem)
            end)
        end
    end
    
    local proximityPrompt = targetItem:FindFirstChildOfClass("ProximityPrompt", true)
    if proximityPrompt then
        pcall(function()
            fireproximityprompt(proximityPrompt)
        end)
    end
    
    local clickDetector = targetItem:FindFirstChildOfClass("ClickDetector", true)
    if clickDetector then
        pcall(function()
            fireclickdetector(clickDetector)
        end)
    end
    
    if trackingTable and targetItem then
        trackingTable[targetItem] = tick()
    end
    
    return true
end

-- Fast Scrapper Transporter Function - Optimized for high-speed item collection
local function FastScrapperTransporter(targetItem, destinationPart, trackingTable, teleportCooldown, savedPlayerPosition, teleportHeight)
    if not targetItem or not targetItem.Parent then
        return false
    end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local rootPart = char.HumanoidRootPart
    local itemPart = targetItem.PrimaryPart or targetItem:FindFirstChildOfClass("BasePart")
    
    if not itemPart then
        return false
    end
    
    -- Use provided height or default to 35
    local height = teleportHeight or 35
    local destinationCFrame = nil
    
    if destinationPart == "Player" then
        if savedPlayerPosition then
            destinationCFrame = savedPlayerPosition * CFrame.new(0, height, 0)
        else
            destinationCFrame = rootPart.CFrame * CFrame.new(0, height, 0)
        end
    elseif typeof(destinationPart) == "Instance" then
        local targetPart = nil
        if destinationPart:IsA("BasePart") then
            targetPart = destinationPart
        elseif destinationPart:IsA("Model") then
            targetPart = destinationPart.PrimaryPart or destinationPart:FindFirstChildOfClass("BasePart")
        end
        
        if targetPart then
            destinationCFrame = targetPart.CFrame * CFrame.new(0, height, 0)
        else
            return false
        end
    else
        return false
    end
    
    -- Fast teleportation - teleport item and player simultaneously
    itemPart.CFrame = destinationCFrame
    itemPart.AssemblyLinearVelocity = Vector3.zero
    itemPart.AssemblyAngularVelocity = Vector3.zero
    rootPart.CFrame = destinationCFrame * CFrame.new(0, 5, 0)
    
    -- Reduced wait time for faster processing
    task.wait(0.05)
    
    -- Send drag request immediately - optimized for speed
    local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
    if remoteEvents then
        local requestStartDragging = remoteEvents:FindFirstChild("RequestStartDraggingItem")
        if requestStartDragging then
            pcall(function()
                requestStartDragging:FireServer(targetItem)
            end)
        end
    end
    
    -- Use custom teleport cooldown instead of fixed value
    if trackingTable and targetItem then
        trackingTable[targetItem] = tick()
    end
    
    return true
end

-- Simple Sack Refill Process
local function SackRefillProcess(foundItem)
    local sack = findPlayerInventorySack()
    if not sack then
        CampfireControl.AutoRefillEnabled = false
        return false
    end
    
    if isSackFull() then
        CampfireControl.AutoRefillEnabled = false
        UnfreezeCamera()
        CampfireControl.SavedPlayerPosition = nil
        return false
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local originalPosition = CampfireControl.SavedPlayerPosition or humanoidRootPart.CFrame
    
    local rootPart = foundItem:FindFirstChild("Root") or foundItem.PrimaryPart
    if not rootPart then
        return false
    end
    
    -- Teleport player to item
    humanoidRootPart.CFrame = rootPart.CFrame + Vector3.new(0, 5, 0)
    wait(0.1)
    
    -- Bag item
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local bagStoreRemote = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if bagStoreRemote then
        bagStoreRemote = bagStoreRemote:FindFirstChild("RequestBagStoreItem")
        if bagStoreRemote then
            pcall(function()
                bagStoreRemote:InvokeServer(sack, foundItem)
            end)
        end
    end
    
    wait(0.3)
    
    -- Always return to original position after collecting item
    humanoidRootPart.CFrame = originalPosition
    
    -- Check if sack is now full
    if isSackFull() then
        CampfireControl.AutoRefillEnabled = false
        UnfreezeCamera()
        CampfireControl.SavedPlayerPosition = nil
    end
    
    return true
end

-- Simple Sack Crafting Process
local function SackCraftingProcess(foundItem)
    local sack = findPlayerInventorySack()
    if not sack then
        CraftingControl.ProduceScrapEnabled = false
        CraftingControl.ProduceWoodEnabled = false
        CraftingControl.ProduceCultistGemEnabled = false
        return false
    end
    
    if isSackFull() then
        CraftingControl.ProduceScrapEnabled = false
        CraftingControl.ProduceWoodEnabled = false
        CraftingControl.ProduceCultistGemEnabled = false
        UnfreezeCamera()
        CraftingControl.SavedPlayerPosition = nil
        return false
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local originalPosition = CraftingControl.SavedPlayerPosition or humanoidRootPart.CFrame
    
    local rootPart = foundItem:FindFirstChild("Root") or foundItem.PrimaryPart
    if not rootPart then
        return false
    end
    
    -- Teleport player to item
    humanoidRootPart.CFrame = rootPart.CFrame + Vector3.new(0, 5, 0)
    wait(0.9)
    
    -- Bag item
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local bagStoreRemote = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if bagStoreRemote then
        bagStoreRemote = bagStoreRemote:FindFirstChild("RequestBagStoreItem")
        if bagStoreRemote then
            pcall(function()
                bagStoreRemote:InvokeServer(sack, foundItem)
            end)
        end
    end
    
    wait(0.9)
    
    -- Always return to original position after collecting item
    humanoidRootPart.CFrame = originalPosition
    
    -- Check if sack is now full
    if isSackFull() then
        CraftingControl.ProduceScrapEnabled = false
        CraftingControl.ProduceWoodEnabled = false
        CraftingControl.ProduceCultistGemEnabled = false
        UnfreezeCamera()
        CraftingControl.SavedPlayerPosition = nil
    end
    
    return true
end

-- Get campfire fuel percentage
local function GetCampfireFuelPercentage()
    local campfire = workspace:FindFirstChild("Map")
    if campfire then
        campfire = campfire:FindFirstChild("Campground")
        if campfire then
            campfire = campfire:FindFirstChild("MainFire")
            if campfire then
                local fuelRemaining = campfire:GetAttribute("FuelRemaining") or 0
                local fuelTarget = campfire:GetAttribute("FuelTarget") or 1
                return (fuelRemaining / fuelTarget) * 100
            end
        end
    end
    return 100 -- Default to full if can't find campfire
end



-- Find refill items in workspace
local function FindRefillItems()
    local items = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return items
    end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        local shouldAdd = false
        local itemPart = nil
        local itemType = nil
        
        -- Skip items that are being used for crafting
        if CraftingControl.UsedItemsForCrafting[item] then
            continue
        end
        
        -- Check for Log items
        local mainPart = item:FindFirstChild("Main")
        if mainPart and (item.Name:lower():find("log") or item.Name:lower():find("wood")) then
            itemPart = mainPart
            itemType = "Log"
            shouldAdd = true
        end
        
        -- Check for Coal items
        local coalPart = item:FindFirstChild("Coal")
        if coalPart then
            itemPart = coalPart
            itemType = "Coal"
            shouldAdd = true
        end
        
        -- Check for Fuel Canister items
        if mainPart and item.Name == "Fuel Canister" then
            itemPart = mainPart
            itemType = "Fuel Canister"
            shouldAdd = true
        end
        
        -- Check for Oil Barrel items
        if mainPart and item.Name == "Oil Barrel" then
            itemPart = mainPart
            itemType = "Oil Barrel"
            shouldAdd = true
        end
        
        -- Only add if we should and it matches our filter
        if shouldAdd and itemPart then
            if CampfireControl.RefillItemType == "All" or CampfireControl.RefillItemType == itemType then
                table.insert(items, {
                    Item = item,
                    Part = itemPart,
                    Type = itemType,
                    Position = itemPart.Position
                })
            end
        end
    end
    
    return items
end

-- Teleport refill item to campfire using UltimateItemTransporter
local function TeleportItemToCampfire(item, itemPart)
    local destination
    if CampfireControl.TeleportDestination == "Campfire" then
        destination = workspace.Map.Campground.MainFire
    elseif CampfireControl.TeleportDestination == "Player" then
        destination = "Player"
    elseif CampfireControl.TeleportDestination == "Sack" then
        local success = SackRefillProcess(item)
        if success then
            CampfireControl.TeleportedItems[item] = tick()
        end
        return success
    end
    
    if destination then
        print("🚀 Using UltimateItemTransporter for campfire refill to " .. CampfireControl.TeleportDestination .. ": " .. item.Name)
        local success = UltimateItemTransporter(item, destination, nil, 120, CampfireControl.SavedPlayerPosition, CampfireControl.TeleportHeight)
        if success then
            print("✅ Campfire refill successful")
            return true
        else
            print("❌ Campfire refill failed")
            return false
        end
    end
    return false
end

-- Execute campfire refill
local function UpdateCampfireRefill()
    if not CampfireControl.AutoRefillEnabled then
        return
    end
    
    local currentTime = tick()
    if currentTime - CampfireControl.LastRefillCheck < CampfireControl.RefillCheckCooldown then
        return
    end
    
    CampfireControl.LastRefillCheck = currentTime
    
    -- Check fuel percentage (skip if continuous refill is enabled)
    if not CampfireControl.ContinuousRefillEnabled then
        local fuelPercentage = GetCampfireFuelPercentage()
        if fuelPercentage > CampfireControl.RefillPercentage then
            return -- No need to refill yet
        end
    end
    
    -- Find refill items
    local refillItems = FindRefillItems()
    if #refillItems == 0 then
        return -- No items available
    end
    
    -- Clean up teleported items tracking (remove items that no longer exist)
    local validTeleportedItems = {}
    for item, timestamp in pairs(CampfireControl.TeleportedItems) do
        if item.Parent and (currentTime - timestamp) < 120 then -- 30 second cooldown per item
            validTeleportedItems[item] = timestamp
        end
    end
    CampfireControl.TeleportedItems = validTeleportedItems
    
    -- Filter out already teleported items
    local availableItems = {}
    for _, itemData in ipairs(refillItems) do
        if not CampfireControl.TeleportedItems[itemData.Item] then
            table.insert(availableItems, itemData)
        end
    end
    
    -- Update refillItems to only include available items
    refillItems = availableItems
    
    if #refillItems == 0 then
        return -- No new items to teleport
    end
    
    -- Sort by distance to player (prioritize closer items)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local playerPos = char.HumanoidRootPart.Position
        table.sort(refillItems, function(a, b)
            local distA = (playerPos - a.Position).Magnitude
            local distB = (playerPos - b.Position).Magnitude
            return distA < distB
        end)
    end
    
    -- Teleport the closest item to campfire
    local item = refillItems[1]
    
    -- Mark item immediately to prevent duplicate attempts
    CampfireControl.TeleportedItems[item.Item] = currentTime
    print("🔒 Item marked as teleporting for campfire: " .. item.Item.Name)
    
    local success = TeleportItemToCampfire(item.Item, item.Part)
    
    if success then
        -- Mark item as used for campfire to avoid conflicts with crafting
        CraftingControl.UsedItemsForCampfire[item.Item] = true
        -- Use the configurable cooldown for next refill attempt
        CampfireControl.LastRefillCheck = currentTime
    else
        -- If teleport failed, remove the mark so it can be tried again
        CampfireControl.TeleportedItems[item.Item] = nil
        print("❌ Campfire teleport failed - removing mark")
    end
end

-- Find scrap items in workspace (avoiding conflicts with campfire)
local function FindScrapItems()
    local items = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return items
    end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        local shouldAdd = false
        local itemPart = nil
        local itemType = nil
        
        -- Skip items that are being used for campfire
        if CraftingControl.UsedItemsForCampfire[item] then
            continue
        end
        
        -- Check for scrap items
        local mainPart = item:FindFirstChild("Main")
        if mainPart then
            -- Check specific scrap item types
            if item.Name == "Bolt" then
                itemPart = mainPart
                itemType = "Bolt"
                shouldAdd = true
            elseif item.Name == "Sheet Metal" then
                itemPart = mainPart
                itemType = "Sheet Metal"
                shouldAdd = true
            elseif item.Name == "Broken Fan" then
                itemPart = mainPart
                itemType = "Broken Fan"
                shouldAdd = true
            elseif item.Name == "Old Radio" then
                itemPart = mainPart
                itemType = "Old Radio"
                shouldAdd = true
            elseif item.Name == "Broken Microwave" then
                itemPart = mainPart
                itemType = "Broken Microwave"
                shouldAdd = true
            elseif item.Name == "Tyre" then
                itemPart = mainPart
                itemType = "Tyre"
                shouldAdd = true
            elseif item.Name == "Metal Chair" then
                itemPart = mainPart
                itemType = "Metal Chair"
                shouldAdd = true
            elseif item.Name == "Old Car Engine" then
                itemPart = mainPart
                itemType = "Old Car Engine"
                shouldAdd = true
            elseif item.Name == "Washing Machine" then
                itemPart = mainPart
                itemType = "Washing Machine"
                shouldAdd = true
            elseif item.Name == "Cultist Experiment" then
                itemPart = mainPart
                itemType = "Cultist Experiment"
                shouldAdd = true
            elseif item.Name == "Cultist Prototype" then
                itemPart = mainPart
                itemType = "Cultist Prototype"
                shouldAdd = true
            elseif item.Name == "UFO Scrap" then
                itemPart = mainPart
                itemType = "UFO Scrap"
                shouldAdd = true
            end
        end
        
        -- Only add if we should and it matches our filter
        if shouldAdd and itemPart then
            if CraftingControl.ScrapItemType == "All" or CraftingControl.ScrapItemType == itemType then
                table.insert(items, {
                    Item = item,
                    Part = itemPart,
                    Type = itemType,
                    Position = itemPart.Position
                })
            end
        end
    end
    
    return items
end

-- Find wood items for crafting (avoiding conflicts with campfire)
local function FindWoodItemsForCrafting()
    local items = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return items
    end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        local shouldAdd = false
        local itemPart = nil
        local itemType = nil
        
        -- Skip items that are being used for campfire
        if CraftingControl.UsedItemsForCampfire[item] then
            continue
        end
        
        -- Check for Log items for wood crafting
        local mainPart = item:FindFirstChild("Main")
        if mainPart and (item.Name:lower():find("log") or item.Name:lower():find("wood")) then
            itemPart = mainPart
            itemType = "Log"
            shouldAdd = true
        end
        
        -- Only add if we should and it matches our filter
        if shouldAdd and itemPart then
            if CraftingControl.WoodItemType == "All" or CraftingControl.WoodItemType == itemType then
                table.insert(items, {
                    Item = item,
                    Part = itemPart,
                    Type = itemType,
                    Position = itemPart.Position
                })
            end
        end
    end
    
    return items
end

-- Find cultist gem items for crafting (avoiding conflicts with campfire)
local function FindCultistGemItemsForCrafting()
    local items = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return items
    end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        local shouldAdd = false
        local itemPart = nil
        local itemType = nil
        
        -- Skip items that are being used for campfire
        if CraftingControl.UsedItemsForCampfire[item] then
            continue
        end
        
        -- Check for Cultist Gem items for crafting
        local mainPart = item:FindFirstChild("Main")
        if mainPart and item.Name == "Cultist Gem" then
            itemPart = mainPart
            itemType = "Cultist Gem"
            shouldAdd = true
        end
        
        -- Only add if we should and it matches our filter
        if shouldAdd and itemPart then
            if CraftingControl.CultistGemItemType == "All" or CraftingControl.CultistGemItemType == itemType then
                table.insert(items, {
                    Item = item,
                    Part = itemPart,
                    Type = itemType,
                    Position = itemPart.Position
                })
            end
        end
    end
    
    return items
end

-- Get player position for teleporting food items
local function GetPlayerPosition()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Return position 5 studs in front of the player and 35 studs above for proper falling (matching campfire height)
        local rootPart = char.HumanoidRootPart
        local lookDirection = rootPart.CFrame.LookVector
        return rootPart.CFrame.Position + (lookDirection * 5) + Vector3.new(0, 35, 0)
    end
    return nil
end

-- Find food items in workspace
local function FindFoodItems()
    local items = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return items
    end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        local shouldAdd = false
        local itemPart = nil
        local itemType = nil
        
        -- Skip items that have already been teleported
        if FoodControl.TeleportedItems[item] then
            continue
        end
        
        -- Check for specific food items (only non-harvesting items)
        if item.Name == "Cake" then
            itemPart = item:FindFirstChild("Meat") or item:FindFirstChild("Handle") or item:FindFirstChild("Main") or item:GetChildren()[1]
            itemType = "Cake"
            shouldAdd = true
        elseif item.Name == "Ribs" then
            itemPart = item:FindFirstChild("Meat") or item:FindFirstChild("Handle") or item:FindFirstChild("Main") or item:GetChildren()[1]
            itemType = "Ribs"
            shouldAdd = true
        elseif item.Name == "Steak" then
            itemPart = item:FindFirstChild("Meat") or item:FindFirstChild("Handle") or item:FindFirstChild("Main") or item:GetChildren()[1]
            itemType = "Steak"
            shouldAdd = true
        elseif item.Name == "Morsel" then
            itemPart = item:FindFirstChild("Meat") or item:FindFirstChild("Handle") or item:FindFirstChild("Main") or item:GetChildren()[1]
            itemType = "Morsel"
            shouldAdd = true
        end
        
        -- Only add if we should and it matches our filter and has a valid part
        if shouldAdd and itemPart and itemPart:IsA("BasePart") then
            if FoodControl.FoodItemType == "All" or FoodControl.FoodItemType == itemType then
                table.insert(items, {
                    Item = item,
                    Part = itemPart,
                    Type = itemType,
                    Position = itemPart.Position
                })
            end
        end
    end
    
    return items
end

-- Destination functions for UltimateItemTransporter
local function GetFoodDestination()
    if FoodControl.TeleportDestination == "Player" then
        return "Player"
    elseif FoodControl.TeleportDestination == "Campfire" then
        return workspace.Map.Campground.MainFire
    end
    return "Player" -- Default fallback
end

local function GetAnimalPeltsDestination()
    if AnimalPeltsControl.TeleportDestination == "Player" then
        return "Player"
    elseif AnimalPeltsControl.TeleportDestination == "Campfire" then
        return workspace.Map.Campground.MainFire
    end
    return "Player" -- Default fallback
end

local function GetHealingDestination()
    if HealingControl.TeleportDestination == "Player" then
        return "Player"
    elseif HealingControl.TeleportDestination == "Campfire" then
        return workspace.Map.Campground.MainFire
    end
    return "Player" -- Default fallback
end

local function GetAmmoDestination()
    if AmmoControl.TeleportDestination == "Player" then
        return "Player"
    elseif AmmoControl.TeleportDestination == "Campfire" then
        return workspace.Map.Campground.MainFire
    end
    return "Player" -- Default fallback
end

-- Execute food teleportation
local function UpdateFoodTeleport()
    if not FoodControl.TeleportFoodEnabled then
        return
    end
    
    local currentTime = tick()
    if currentTime - FoodControl.LastFoodTeleport < FoodControl.TeleportCooldown then
        return
    end
    
    FoodControl.LastFoodTeleport = currentTime
    
    -- Clean up teleported items tracking (remove items that no longer exist)
    local validTeleportedItems = {}
    for item, timestamp in pairs(FoodControl.TeleportedItems) do
        if item.Parent and (currentTime - timestamp) < 120 then -- 30 second cooldown per item
            validTeleportedItems[item] = timestamp
        end
    end
    FoodControl.TeleportedItems = validTeleportedItems
    
    -- Debug: Print current teleported items count
    local count = 0
    for _ in pairs(FoodControl.TeleportedItems) do count = count + 1 end
    print("🔍 Currently tracking " .. count .. " teleported food items")
    
    -- Find food items
    local foodItems = FindFoodItems()
    if #foodItems == 0 then
        return -- No items available
    end
    
    -- Filter out already teleported items
    local availableItems = {}
    for _, itemData in ipairs(foodItems) do
        if not FoodControl.TeleportedItems[itemData.Item] then
            table.insert(availableItems, itemData)
        else
            print("🚫 Skipping already teleported item: " .. itemData.Item.Name)
        end
    end
    
    print("📦 Found " .. #foodItems .. " total food items, " .. #availableItems .. " available for teleport")
    
    if #availableItems == 0 then
        return -- No new items to teleport
    end
    
    -- Sort by distance to player (prioritize closer items)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local playerPos = char.HumanoidRootPart.Position
        table.sort(availableItems, function(a, b)
            local distA = (playerPos - a.Position).Magnitude
            local distB = (playerPos - b.Position).Magnitude
            return distA < distB
        end)
    end
    
    -- Use UltimateItemTransporter for the closest food item
    local item = availableItems[1]
    local destination = GetFoodDestination()
    print("🎯 Attempting to teleport: " .. item.Item.Name .. " to " .. tostring(destination))
    
    -- Mark item as being teleported IMMEDIATELY to prevent duplicate attempts
    FoodControl.TeleportedItems[item.Item] = currentTime
    print("🔒 Item marked as teleporting: " .. item.Item.Name)
    
    local success = UltimateItemTransporter(item.Item, destination, nil, 120, FoodControl.SavedPlayerPosition, FoodControl.TeleportHeight) -- Pass nil for tracking since we handle it here
    
    if success then
        print("✅ Food teleport successful")
        -- Use the configurable cooldown for next teleport attempt
        FoodControl.LastFoodTeleport = currentTime
    else
        print("❌ Food teleport failed - removing mark")
        -- Remove mark if teleport failed
        FoodControl.TeleportedItems[item.Item] = nil
    end
end

-- Find animal pelt items in workspace
local function FindAnimalPeltItems()
    local items = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return items
    end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        local shouldAdd = false
        local itemPart = nil
        local itemType = nil
        
        -- Skip items that have already been teleported
        if AnimalPeltsControl.TeleportedItems[item] then
            continue
        end
        
        -- Check for specific animal pelt items
        if item.Name == "Bunny Foot" then
            itemPart = item:FindFirstChild("Main") or item:FindFirstChild("Handle") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Bunny Foot"
            shouldAdd = true
        elseif item.Name == "Wolf Pelt" then
            itemPart = item:FindFirstChild("Main") or item:FindFirstChild("Handle") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Wolf Pelt"
            shouldAdd = true
        elseif item.Name == "Alpha Wolf Pelt" then
            itemPart = item:FindFirstChild("Main") or item:FindFirstChild("Handle") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Alpha Wolf Pelt"
            shouldAdd = true
        elseif item.Name == "Bear Pelt" then
            itemPart = item:FindFirstChild("Main") or item:FindFirstChild("Handle") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Bear Pelt"
            shouldAdd = true
        elseif item.Name == "Arctic Fox Pelt" then
            itemPart = item:FindFirstChild("Main") or item:FindFirstChild("Handle") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Arctic Fox Pelt"
            shouldAdd = true
        elseif item.Name == "Polar Bear Pelt" then
            itemPart = item:FindFirstChild("Main") or item:FindFirstChild("Handle") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Polar Bear Pelt"
            shouldAdd = true
        elseif item.Name == "Mammoth Tusk" then
            itemPart = item:FindFirstChild("Main") or item:FindFirstChild("Handle") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Mammoth Tusk"
            shouldAdd = true
        end
        
        -- Only add if we should and it matches our filter and has a valid part
        if shouldAdd and itemPart and itemPart:IsA("BasePart") then
            if AnimalPeltsControl.PeltItemType == itemType then
                table.insert(items, {
                    Item = item,
                    Part = itemPart,
                    Type = itemType,
                    Position = itemPart.Position
                })
            end
        end
    end
    
    return items
end

-- Execute animal pelts teleportation
local function UpdateAnimalPeltsTeleport()
    if not AnimalPeltsControl.TeleportPeltsEnabled then
        return
    end
    
    local currentTime = tick()
    if currentTime - AnimalPeltsControl.LastPeltTeleport < AnimalPeltsControl.TeleportCooldown then
        return
    end
    
    AnimalPeltsControl.LastPeltTeleport = currentTime
    
    -- Clean up teleported items tracking (remove items that no longer exist)
    local validTeleportedItems = {}
    for item, timestamp in pairs(AnimalPeltsControl.TeleportedItems) do
        if item.Parent and (currentTime - timestamp) < 120 then -- 30 second cooldown per item
            validTeleportedItems[item] = timestamp
        end
    end
    AnimalPeltsControl.TeleportedItems = validTeleportedItems
    
    -- Find animal pelt items
    local peltItems = FindAnimalPeltItems()
    if #peltItems == 0 then
        return -- No items available
    end
    
    -- Filter out already teleported items
    local availableItems = {}
    for _, itemData in ipairs(peltItems) do
        if not AnimalPeltsControl.TeleportedItems[itemData.Item] then
            table.insert(availableItems, itemData)
        end
    end
    
    if #availableItems == 0 then
        return -- No new items to teleport
    end
    
    -- Sort by distance to player (prioritize closer items)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local playerPos = char.HumanoidRootPart.Position
        table.sort(availableItems, function(a, b)
            local distA = (playerPos - a.Position).Magnitude
            local distB = (playerPos - b.Position).Magnitude
            return distA < distB
        end)
    end
    
    -- Use UltimateItemTransporter for the closest animal pelt item
    local item = availableItems[1]
    local destination = GetAnimalPeltsDestination()
    
    -- Mark item as being teleported IMMEDIATELY to prevent duplicate attempts
    AnimalPeltsControl.TeleportedItems[item.Item] = currentTime
    
    local success = UltimateItemTransporter(item.Item, destination, nil, 120, AnimalPeltsControl.SavedPlayerPosition, AnimalPeltsControl.TeleportHeight) -- Pass nil for tracking since we handle it here
    
    if success then
        -- Use the configurable cooldown for next teleport attempt
        AnimalPeltsControl.LastPeltTeleport = currentTime
    else
        -- Remove mark if teleport failed
        AnimalPeltsControl.TeleportedItems[item.Item] = nil
    end
end

-- Find healing items in workspace
local function FindHealingItems()
    local items = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return items
    end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        local shouldAdd = false
        local itemPart = nil
        local itemType = nil
        
        -- Skip items that have already been teleported
        if HealingControl.TeleportedItems[item] then
            continue
        end
        
        -- Check for specific healing items
        if item.Name == "Bandage" then
            itemPart = item:FindFirstChild("Handle") or item:FindFirstChild("Main") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Bandage"
            shouldAdd = true
        elseif item.Name == "Medkit" then
            itemPart = item:FindFirstChild("Handle") or item:FindFirstChild("Main") or item:FindFirstChild("Meat") or item:GetChildren()[1]
            itemType = "Medkit"
            shouldAdd = true
        end
        
        -- Only add if we should and it matches our filter and has a valid part
        if shouldAdd and itemPart and itemPart:IsA("BasePart") then
            if HealingControl.HealingItemType == itemType then
                table.insert(items, {
                    Item = item,
                    Part = itemPart,
                    Type = itemType,
                    Position = itemPart.Position
                })
            end
        end
    end
    
    return items
end

-- Execute healing items teleportation
local function UpdateHealingTeleport()
    if not HealingControl.TeleportHealingEnabled then
        return
    end
    
    local currentTime = tick()
    if currentTime - HealingControl.LastHealingTeleport < HealingControl.TeleportCooldown then
        return
    end
    
    HealingControl.LastHealingTeleport = currentTime
    
    -- Clean up teleported items tracking (remove items that no longer exist)
    local validTeleportedItems = {}
    for item, timestamp in pairs(HealingControl.TeleportedItems) do
        if item.Parent and (currentTime - timestamp) < 120 then -- 30 second cooldown per item
            validTeleportedItems[item] = timestamp
        end
    end
    HealingControl.TeleportedItems = validTeleportedItems
    
    -- Find healing items
    local healingItems = FindHealingItems()
    if #healingItems == 0 then
        return -- No items available
    end
    
    -- Filter out already teleported items
    local availableItems = {}
    for _, itemData in ipairs(healingItems) do
        if not HealingControl.TeleportedItems[itemData.Item] then
            table.insert(availableItems, itemData)
        end
    end
    
    if #availableItems == 0 then
        return -- No new items to teleport
    end
    
    -- Sort by distance to player (prioritize closer items)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local playerPos = char.HumanoidRootPart.Position
        table.sort(availableItems, function(a, b)
            local distA = (playerPos - a.Position).Magnitude
            local distB = (playerPos - b.Position).Magnitude
            return distA < distB
        end)
    end
    
    -- Use UltimateItemTransporter for the closest healing item
    local item = availableItems[1]
    local destination = GetHealingDestination()
    
    -- Mark item as being teleported IMMEDIATELY to prevent duplicate attempts
    HealingControl.TeleportedItems[item.Item] = currentTime
    
    local success = UltimateItemTransporter(item.Item, destination, nil, 120, HealingControl.SavedPlayerPosition, HealingControl.TeleportHeight) -- Pass nil for tracking since we handle it here
    
    if success then
        -- Use the configurable cooldown for next teleport attempt
        HealingControl.LastHealingTeleport = currentTime
    else
        -- Remove mark if teleport failed
        HealingControl.TeleportedItems[item.Item] = nil
    end
end

-- Ammo teleport functions (same logic as healing/food)
local function FindAmmoItems()
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return {}
    end
    
    local ammoItems = {}
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        -- Skip if already teleported
        if AmmoControl.TeleportedItems[item] then
            continue
        end
        
        local shouldInclude = false
        if AmmoControl.AmmoItemType == "All" then
            for _, ammoType in pairs(AmmoItemTypes) do
                if ammoType ~= "All" and item.Name == ammoType then
                    shouldInclude = true
                    break
                end
            end
        else
            shouldInclude = (item.Name == AmmoControl.AmmoItemType)
        end
        
        if shouldInclude then
            local itemPart = nil
            if item:IsA("BasePart") then
                itemPart = item
            elseif item:IsA("Model") then
                itemPart = item.PrimaryPart or item:FindFirstChildOfClass("BasePart")
            end
            
            if itemPart then
                table.insert(ammoItems, {
                    Item = item,
                    Part = itemPart,
                    Position = itemPart.Position
                })
            end
        end
    end
    
    return ammoItems
end

local function UpdateAmmoTeleport()
    if not AmmoControl.TeleportAmmoEnabled then
        return
    end
    
    local currentTime = tick()
    if currentTime - AmmoControl.LastAmmoTeleport < AmmoControl.TeleportCooldown then
        return
    end
    
    local ammoItems = FindAmmoItems()
    if #ammoItems == 0 then
        return
    end
    
    -- Clean up teleported items tracking (remove items that no longer exist)
    local validTeleportedItems = {}
    for item, timestamp in pairs(AmmoControl.TeleportedItems) do
        if item.Parent and (currentTime - timestamp) < 120 then -- 30 second cooldown per item
            validTeleportedItems[item] = timestamp
        end
    end
    AmmoControl.TeleportedItems = validTeleportedItems
    
    -- Filter out already teleported items
    local availableItems = {}
    for _, itemData in ipairs(ammoItems) do
        if not AmmoControl.TeleportedItems[itemData.Item] then
            table.insert(availableItems, itemData)
        end
    end
    
    if #availableItems == 0 then
        return -- No new items to teleport
    end
    
    -- Sort by distance to player (get closest first)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local playerPos = char.HumanoidRootPart.Position
        table.sort(availableItems, function(a, b)
            local distA = (playerPos - a.Position).Magnitude
            local distB = (playerPos - b.Position).Magnitude
            return distA < distB
        end)
    end
    
    -- Use UltimateItemTransporter for the closest ammo item
    local item = availableItems[1]
    local destination = GetAmmoDestination()
    
    -- Mark item as being teleported IMMEDIATELY to prevent duplicate attempts
    AmmoControl.TeleportedItems[item.Item] = currentTime
    
    local success = UltimateItemTransporter(item.Item, destination, nil, 120, AmmoControl.SavedPlayerPosition, AmmoControl.TeleportHeight) -- Pass nil for tracking since we handle it here
    
    if success then
        -- Use the configurable cooldown for next teleport attempt
        AmmoControl.LastAmmoTeleport = currentTime
    else
        -- Remove mark if teleport failed
        AmmoControl.TeleportedItems[item.Item] = nil
    end
end

-- Simple chest finding and teleport function
local function FindAndTeleportToChest(chestName)
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        -- Removed notification as requested
        return
    end
    
    local foundChests = {}
    
    -- Find all chests of the specified type
    for _, item in pairs(itemsFolder:GetChildren()) do
        if item.Name == chestName then
            -- Check for opened attribute - look for any attribute containing "Opened"
            local isOpened = false
            for attributeName, attributeValue in pairs(item:GetAttributes()) do
                if string.find(attributeName, "Opened") and attributeValue == true then
                    isOpened = true
                    break
                end
            end
            
            if not isOpened then
                -- Get position
                local position = Vector3.new(0, 0, 0)
                if item:IsA("BasePart") then
                    position = item.Position
                elseif item:IsA("Model") and item.PrimaryPart then
                    position = item.PrimaryPart.Position
                elseif item:IsA("Model") then
                    for _, child in pairs(item:GetChildren()) do
                        if child:IsA("BasePart") then
                            position = child.Position
                            break
                        end
                    end
                end
                
                table.insert(foundChests, {
                    Object = item,
                    Position = position
                })
            end
        end
    end
    
    if #foundChests == 0 then
        -- Removed notification as requested
        return
    end
    
    -- Sort by distance to player (get closest)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local playerPos = char.HumanoidRootPart.Position
        table.sort(foundChests, function(a, b)
            local distA = (playerPos - a.Position).Magnitude
            local distB = (playerPos - b.Position).Magnitude
            return distA < distB
        end)
        
        -- Teleport to closest chest
        local closestChest = foundChests[1]
        local targetPosition = closestChest.Position + Vector3.new(0, 5, 0)
        char.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        
        -- Removed notification as requested
    end
end

-- Chest summary function
local function ShowChestSummary()
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        -- Removed notification as requested
        return
    end
    
    local chestTypes = {
        "Item Chest",
        "Item Chest2", 
        "Item Chest3",
        "Item Chest4",
        "Item Chest5",
        "Item Chest6",
        "Volcanic Chest1",
        "Volcanic Chest2",
        "Snow Chest1",
        "Snow Chest2"
    }
    
    local chestCounts = {}
    local totalChests = 0
    local totalOpened = 0
    
    -- Initialize counts
    for _, chestType in pairs(chestTypes) do
        chestCounts[chestType] = {available = 0, opened = 0}
    end
    
    -- Scan all items
    for _, item in pairs(itemsFolder:GetChildren()) do
        for _, chestType in pairs(chestTypes) do
            if item.Name == chestType then
                -- Check for opened attribute - look for any attribute containing "Opened"
                local isOpened = false
                for attributeName, attributeValue in pairs(item:GetAttributes()) do
                    if string.find(attributeName, "Opened") and attributeValue == true then
                        isOpened = true
                        break
                    end
                end
                
                if isOpened then
                    chestCounts[chestType].opened = chestCounts[chestType].opened + 1
                    totalOpened = totalOpened + 1
                else
                    chestCounts[chestType].available = chestCounts[chestType].available + 1
                end
                totalChests = totalChests + 1
                break
            end
        end
    end
    
    -- Build summary message
    local summaryLines = {}
    table.insert(summaryLines, "=== CHEST SUMMARY ===")
    table.insert(summaryLines, "")
    
    for _, chestType in pairs(chestTypes) do
        local available = chestCounts[chestType].available
        local opened = chestCounts[chestType].opened
        local total = available + opened
        
        if total > 0 then
            table.insert(summaryLines, chestType .. ": " .. available .. " available, " .. opened .. " opened")
        else
            table.insert(summaryLines, chestType .. ": None found")
        end
    end
    
    table.insert(summaryLines, "")
    table.insert(summaryLines, "TOTAL: " .. (totalChests - totalOpened) .. " available / " .. totalChests .. " total")
    
    local summaryContent = table.concat(summaryLines, "\n")
    
    -- Removed notification as requested - summary content available but not displayed
end

-- Chest dropdown data storage for each chest type
local ChestDropdowns = {}
local ChestDropdownData = {}

-- Initialize chest types and their dropdown data
local ChestTypes = {
    "Item Chest",
    "Item Chest2", 
    "Item Chest3",
    "Item Chest4",
    "Item Chest5",
    "Item Chest6",
    "Snow Chest1",
    "Snow Chest2",
    "Volcanic Chest1",
    "Volcanic Chest2",
    "Snow Chest1",
    "Snow Chest2"
}

-- Initialize dropdown data for each chest type
for _, chestType in pairs(ChestTypes) do
    ChestDropdownData[chestType] = {
        Options = {"None"},
        ChestObjects = {}
    }
end

-- Function to scan and build chest dropdown options for all chest types
local function UpdateAllChestDropdowns()
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        -- Removed notification as requested - no notifications needed
        return
    end
    
    -- Reset all dropdown data
    for _, chestType in pairs(ChestTypes) do
        ChestDropdownData[chestType].Options = {"None"}
        ChestDropdownData[chestType].ChestObjects = {}
    end
    
    -- Scan all items and categorize by chest type
    for _, item in pairs(itemsFolder:GetChildren()) do
        for _, chestType in pairs(ChestTypes) do
            if item.Name == chestType then
                -- Check for opened attribute - look for any attribute containing "Opened"
                local isOpened = false
                for attributeName, attributeValue in pairs(item:GetAttributes()) do
                    if string.find(attributeName, "Opened") and attributeValue == true then
                        isOpened = true
                        break
                    end
                end
                
                if not isOpened then -- Only available chests
                    -- Get position
                    local position = Vector3.new(0, 0, 0)
                    if item:IsA("BasePart") then
                        position = item.Position
                    elseif item:IsA("Model") and item.PrimaryPart then
                        position = item.PrimaryPart.Position
                    elseif item:IsA("Model") then
                        for _, child in pairs(item:GetChildren()) do
                            if child:IsA("BasePart") then
                                position = child.Position
                                break
                            end
                        end
                    end
                    
                    local optionText = string.format("[%.0f, %.0f, %.0f]", 
                        position.X, position.Y, position.Z)
                    
                    table.insert(ChestDropdownData[chestType].Options, optionText)
                    table.insert(ChestDropdownData[chestType].ChestObjects, {
                        Object = item,
                        Position = position,
                        Type = chestType
                    })
                end
                break
            end
        end
    end
    
    -- Update all actual dropdowns if they exist
    for chestType, dropdown in pairs(ChestDropdowns) do
        if dropdown then
            dropdown:Refresh(ChestDropdownData[chestType].Options)
        end
    end
    
    -- Removed notification as requested - no notifications needed
end

-- Function to teleport to selected chest from specific chest type dropdown
local function TeleportToSelectedChestByType(chestType, selectedOption)
    if selectedOption == "None" then
        return
    end
    
    -- Find the chest object based on selected option for this chest type
    local selectedChest = nil
    for _, chestData in pairs(ChestDropdownData[chestType].ChestObjects) do
        local optionText = string.format("[%.0f, %.0f, %.0f]", 
            chestData.Position.X, chestData.Position.Y, chestData.Position.Z)
        
        if optionText == selectedOption then
            selectedChest = chestData
            break
        end
    end
    
    if selectedChest and selectedChest.Object and selectedChest.Object.Parent then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local targetPosition = selectedChest.Position + Vector3.new(0, 5, 0)
            char.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
            -- Removed notification as requested
        end
    else
        -- Refresh this specific dropdown since the chest is no longer available
        UpdateAllChestDropdowns()
    end
end

-- ========== ESP SYSTEM (ELEGANT & MODERN) ==========

-- Create elegant ESP for an object
local function CreateESP(object, text, color)
    local espFolder = workspace:FindFirstChild("ESP_Elements")
    if not espFolder then
        espFolder = Instance.new("Folder")
        espFolder.Name = "ESP_Elements"
        espFolder.Parent = workspace
    end
    
    -- Get object position
    local position = Vector3.new(0, 0, 0)
    if object:IsA("BasePart") then
        position = object.Position
    elseif object:IsA("Model") and object.PrimaryPart then
        position = object.PrimaryPart.Position
    elseif object:IsA("Model") then
        for _, child in pairs(object:GetChildren()) do
            if child:IsA("BasePart") then
                position = child.Position
                break
            end
        end
    end
    
    -- Create BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. object.Name
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Parent = espFolder
    
    -- Create main frame with modern design
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    -- Add subtle gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.1, 0.1, 0.1)),
        ColorSequenceKeypoint.new(1, Color3.new(0.05, 0.05, 0.05))
    })
    gradient.Rotation = 90
    gradient.Parent = frame
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Add subtle stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    
    -- Create text label
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -10, 1, 0)
    textLabel.Position = UDim2.new(0, 5, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = frame
    
    -- Add distance calculation (OPTIMIZED VERSION)
    local function updateDistance()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and textLabel.Parent then
            local distance = math.floor((char.HumanoidRootPart.Position - position).Magnitude)
            -- Only update text if distance actually changed to reduce GUI updates
            local newText = text .. " [" .. distance .. "m]"
            if textLabel.Text ~= newText then
                textLabel.Text = newText
            end
        end
    end
    
    -- Update distance initially
    updateDistance()
    
    -- Create attachment point
    local attachment = Instance.new("Attachment")
    attachment.Parent = object:IsA("BasePart") and object or (object:IsA("Model") and object.PrimaryPart) or object:FindFirstChildOfClass("BasePart")
    if attachment.Parent then
        billboard.Adornee = attachment.Parent
    end
    
    -- Store ESP data
    local espData = {
        Billboard = billboard,
        Object = object,
        UpdateDistance = updateDistance,
        Attachment = attachment
    }
    
    -- Add to ESP objects for management
    table.insert(ESPControl.ESPObjects, espData)
    
    return espData
end

-- Remove all ESP elements
local function ClearAllESP()
    for _, espData in pairs(ESPControl.ESPObjects) do
        if espData.Billboard and espData.Billboard.Parent then
            espData.Billboard:Destroy()
        end
    end
    ESPControl.ESPObjects = {}
    
    -- Clean up ESP folder
    local espFolder = workspace:FindFirstChild("ESP_Elements")
    if espFolder then
        espFolder:Destroy()
    end
end

-- Update ESP for specific category (OPTIMIZED VERSION - FIXED TOGGLE OFF)
local function UpdateESPCategory(category)
    local itemsFolder = workspace:FindFirstChild("Items")
    local charactersFolder = workspace:FindFirstChild("Characters")
    
    if not itemsFolder and category ~= "Players" and category ~= "Entities" then
        return
    end
    
    if category == "Entities" and not charactersFolder then
        return
    end
    
    -- First, remove all ESP for this category if it's disabled
    for i = #ESPControl.ESPObjects, 1, -1 do
        local espData = ESPControl.ESPObjects[i]
        if espData and espData.Object then
            local shouldRemove = false
            
            -- Check if this ESP belongs to the current category
            if category == "Food" then
                for _, foodType in pairs(FoodItemTypes) do
                    if foodType ~= "All" and espData.Object.Name == foodType then
                        shouldRemove = true
                        break
                    end
                end
            elseif category == "AnimalPelts" then
                for _, peltType in pairs(AnimalPeltTypes) do
                    if espData.Object.Name == peltType then
                        shouldRemove = true
                        break
                    end
                end
            elseif category == "Healing" then
                for _, healingType in pairs(HealingItemTypes) do
                    if espData.Object.Name == healingType then
                        shouldRemove = true
                        break
                    end
                end
            elseif category == "Ammo" then
                for _, ammoType in pairs(AmmoItemTypes) do
                    if ammoType ~= "All" and espData.Object.Name == ammoType then
                        shouldRemove = true
                        break
                    end
                end
            elseif category == "Entities" then
                for _, entityType in pairs(EntityTypes) do
                    if espData.Object.Name == entityType then
                        shouldRemove = true
                        break
                    end
                end
            elseif category == "Chests" then
                for _, chestType in pairs(ChestTypes) do
                    if espData.Object.Name == chestType then
                        shouldRemove = true
                        break
                    end
                end
            elseif category == "Players" then
                if espData.Object:IsA("Model") and espData.Object:FindFirstChild("Humanoid") and espData.Object ~= LocalPlayer.Character then
                    shouldRemove = true
                end
            end
            
            if shouldRemove then
                if espData.Billboard and espData.Billboard.Parent then
                    espData.Billboard:Destroy()
                end
                table.remove(ESPControl.ESPObjects, i)
            end
        end
    end
    
    -- If category is disabled, we're done (ESP removed above)
    if not ESPControl.Categories[category] then
        return
    end
    
    -- Create a set of existing ESP objects for this category to avoid duplicates
    local existingESP = {}
    for _, espData in pairs(ESPControl.ESPObjects) do
        if espData.Object and espData.Object.Parent then
            existingESP[espData.Object] = espData
        end
    end
    
    -- Clean up invalid ESP (objects that no longer exist)
    for i = #ESPControl.ESPObjects, 1, -1 do
        local espData = ESPControl.ESPObjects[i]
        if not espData.Object or not espData.Object.Parent then
            if espData.Billboard and espData.Billboard.Parent then
                espData.Billboard:Destroy()
            end
            table.remove(ESPControl.ESPObjects, i)
        end
    end
    
    if category == "Food" then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if not existingESP[item] then -- Only create ESP if it doesn't exist
                for _, foodType in pairs(FoodItemTypes) do
                    if foodType ~= "All" and item.Name == foodType then
                        CreateESP(item, "🍖 " .. foodType, ESPControl.Colors.Food)
                        break
                    end
                end
            end
        end
    elseif category == "AnimalPelts" then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if not existingESP[item] then
                for _, peltType in pairs(AnimalPeltTypes) do
                    if item.Name == peltType then
                        CreateESP(item, "🦊 " .. peltType, ESPControl.Colors.AnimalPelts)
                        break
                    end
                end
            end
        end
    elseif category == "Healing" then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if not existingESP[item] then
                for _, healingType in pairs(HealingItemTypes) do
                    if item.Name == healingType then
                        CreateESP(item, "💊 " .. healingType, ESPControl.Colors.Healing)
                        break
                    end
                end
            end
        end
    elseif category == "Ammo" then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if not existingESP[item] then
                for _, ammoType in pairs(AmmoItemTypes) do
                    if ammoType ~= "All" and item.Name == ammoType then
                        CreateESP(item, "🔫 " .. ammoType, ESPControl.Colors.Ammo)
                        break
                    end
                end
            end
        end
    elseif category == "Entities" then
        -- Entities are found in workspace.Characters folder
        local charactersFolder = workspace:FindFirstChild("Characters")
        if charactersFolder then
            for _, entity in pairs(charactersFolder:GetChildren()) do
                if entity:IsA("Model") and entity:FindFirstChild("NPC") and entity:FindFirstChild("HumanoidRootPart") and not existingESP[entity] then
                    for _, entityType in pairs(EntityTypes) do
                        if entity.Name == entityType then
                            CreateESP(entity, "👹 " .. entityType, ESPControl.Colors.Entities)
                            break
                        end
                    end
                end
            end
        end
    elseif category == "Chests" then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if not existingESP[item] then
                for _, chestType in pairs(ChestTypes) do
                    if item.Name == chestType then
                        -- Check if chest is not opened
                        local isOpened = false
                        for attributeName, attributeValue in pairs(item:GetAttributes()) do
                            if string.find(attributeName, "Opened") and attributeValue == true then
                                isOpened = true
                                break
                            end
                        end
                        
                        if not isOpened then
                            CreateESP(item, "📦 " .. chestType, ESPControl.Colors.Chests)
                        end
                        break
                    end
                end
            end
        end
    elseif category == "Players" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not existingESP[player.Character] then
                CreateESP(player.Character, "👤 " .. player.Name, ESPControl.Colors.Players)
            end
        end
    end
end

-- Update all ESP (OPTIMIZED VERSION)
local lastESPUpdate = 0
local espUpdateInterval = 1 -- Update ESP every 1 second instead of every frame

local function UpdateAllESP()
    if not ESPControl.Enabled then
        ClearAllESP()
        return
    end
    
    local currentTime = tick()
    
    -- Only update distance every frame (lightweight)
    for _, espData in pairs(ESPControl.ESPObjects) do
        if espData.UpdateDistance and espData.Billboard.Parent then
            pcall(espData.UpdateDistance)
        end
    end
    
    -- Only rescan for new/removed items every 1 second (heavy operation)
    if currentTime - lastESPUpdate >= espUpdateInterval then
        lastESPUpdate = currentTime
        
        -- Update each category
        for category, enabled in pairs(ESPControl.Categories) do
            if enabled then
                UpdateESPCategory(category)
            end
        end
    end
end

-- Teleport crafting item to scrapper using FastScrapperTransporter (optimized)
local function TeleportItemToScrapper(item, itemPart)
    local destination
    if CraftingControl.TeleportDestination == "Scrapper" then
        destination = workspace.Map.Campground.Scrapper
    elseif CraftingControl.TeleportDestination == "Player" then
        destination = "Player"
    elseif CraftingControl.TeleportDestination == "Sack" then
        local success = SackCraftingProcess(item)
        if success then
            CraftingControl.TeleportedItems[item] = tick()
        end
        return success
    end
    
    if destination then
        -- Use FastScrapperTransporter for optimized speed and custom cooldown
        local success = FastScrapperTransporter(
            item, 
            destination, 
            CraftingControl.TeleportedItems, 
            CraftingControl.TeleportCooldown, -- Use configurable cooldown
            CraftingControl.SavedPlayerPosition, 
            CraftingControl.TeleportHeight
        )
        if success then
            return true
        else
            print("❌ Fast scrapper teleport failed")
            return false
        end
    end
    return false
end

-- Execute crafting operations
local function UpdateCrafting()
    if not CraftingControl.ProduceScrapEnabled and not CraftingControl.ProduceWoodEnabled and not CraftingControl.ProduceCultistGemEnabled then
        return
    end
    
    local currentTime = tick()
    
    -- Always use the TeleportCooldown from slider for all crafting operations
    if currentTime - CraftingControl.LastCraftingCheck < CraftingControl.TeleportCooldown then
        return
    end
    
    CraftingControl.LastCraftingCheck = currentTime
    
    -- Clear old tracking (cleanup)
    local validCampfireItems = {}
    for item, _ in pairs(CraftingControl.UsedItemsForCampfire) do
        if item.Parent then
            validCampfireItems[item] = true
        end
    end
    CraftingControl.UsedItemsForCampfire = validCampfireItems
    
    local validCraftingItems = {}
    for item, _ in pairs(CraftingControl.UsedItemsForCrafting) do
        if item.Parent then
            validCraftingItems[item] = true
        end
    end
    CraftingControl.UsedItemsForCrafting = validCraftingItems
    
    local success = false
    
    if CraftingControl.ProduceScrapEnabled then
        -- Clean up teleported items only if they no longer exist (keep them marked for 300 seconds)
        local validTeleportedItems = {}
        for item, timestamp in pairs(CraftingControl.TeleportedItems) do
            if item.Parent and (currentTime - timestamp) < 300 then -- Keep items marked for 5 minutes instead of slider cooldown
                validTeleportedItems[item] = timestamp
            end
        end
        CraftingControl.TeleportedItems = validTeleportedItems
        
        -- Find and process scrap items
        local scrapItems = FindScrapItems()
        for _, itemData in ipairs(scrapItems) do
            if not CraftingControl.TeleportedItems[itemData.Item] then
                -- Mark item immediately to prevent duplicate attempts
                CraftingControl.TeleportedItems[itemData.Item] = currentTime
                
                -- Found available item, teleport it
                if TeleportItemToScrapper(itemData.Item, itemData.Part) then
                    CraftingControl.UsedItemsForCrafting[itemData.Item] = true
                end
                break -- Only process one item per cycle for better performance
            end
        end
    elseif CraftingControl.ProduceWoodEnabled then
        -- Find and process wood items
        local woodItems = FindWoodItemsForCrafting()
        for _, itemData in ipairs(woodItems) do
            if not CraftingControl.TeleportedItems[itemData.Item] then
                -- Mark item immediately to prevent duplicate attempts
                CraftingControl.TeleportedItems[itemData.Item] = currentTime
                
                -- Found available item, teleport it
                if TeleportItemToScrapper(itemData.Item, itemData.Part) then
                    CraftingControl.UsedItemsForCrafting[itemData.Item] = true
                end
                break -- Only process one item per cycle
            end
        end
    elseif CraftingControl.ProduceCultistGemEnabled then
        -- Find and process cultist gem items
        local cultistGemItems = FindCultistGemItemsForCrafting()
        for _, itemData in ipairs(cultistGemItems) do
            if not CraftingControl.TeleportedItems[itemData.Item] then
                -- Mark item immediately to prevent duplicate attempts
                CraftingControl.TeleportedItems[itemData.Item] = currentTime
                
                -- Found available item, teleport it
                if TeleportItemToScrapper(itemData.Item, itemData.Part) then
                    CraftingControl.UsedItemsForCrafting[itemData.Item] = true
                end
                break -- Only process one item per cycle
            end
        end
    end
end

-- Forward declare functions so they can be called from StepUpdate
local UpdateKillAura
local UpdateChoppingAura

-- Per-step maintenance (fly + reinforce overrides so sprint system doesn't permanently override)
local function StepUpdate()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if PlayerControl.FlyEnabled and humanoid and root then
            -- Disable default physics constraints for smoother fly
            humanoid.PlatformStand = true

            -- Disable collisions while flying
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end

            local cam = workspace.CurrentCamera
            local moveVec = Vector3.zero
            if cam then
                local cf = cam.CFrame
                local forward = cf.LookVector -- full look (includes pitch)
                local right = cf.RightVector
                local fScale, rScale = 0, 0
                if FlyKeys.W then fScale += 1 end
                if FlyKeys.S then fScale -= 1 end
                if FlyKeys.D then rScale += 1 end
                if FlyKeys.A then rScale -= 1 end
                if fScale ~= 0 then moveVec += forward * fScale end
                if rScale ~= 0 then moveVec += right * rScale end
            end
            -- Manual vertical overrides (Space / Shift) stack with camera aim
            if FlyKeys.Space then moveVec += Vector3.new(0,1,0) end
            if FlyKeys.LeftShift then moveVec += Vector3.new(0,-1,0) end
            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit * PlayerControl.FlySpeed
            else
                -- If no input, explicitly stop all movement (prevents slow descent)
                moveVec = Vector3.zero
            end
            root.AssemblyLinearVelocity = moveVec
        else
            if humanoid then
                humanoid.PlatformStand = false
                -- Continuous speed / jump reinforcement (handles sprint module overwriting values)
                if PlayerControl.SpeedEnabled and PlayerControl.SpeedValue and math.abs(humanoid.WalkSpeed - PlayerControl.SpeedValue) > 0.05 then
                    humanoid.WalkSpeed = PlayerControl.SpeedValue
                end
                if PlayerControl.JumpEnabled and PlayerControl.JumpValue then
                    if humanoid.UseJumpPower then
                        if math.abs(humanoid.JumpPower - PlayerControl.JumpValue) > 0.05 then
                            humanoid.JumpPower = PlayerControl.JumpValue
                        end
                    else
                        if math.abs(humanoid.JumpHeight - PlayerControl.JumpValue) > 0.05 then
                            humanoid.JumpHeight = PlayerControl.JumpValue
                        end
                    end
                end
            end
        end
        
        -- Kill Aura enforcement
        if CombatControl.KillAuraEnabled and UpdateKillAura then
            pcall(UpdateKillAura)
        end
        
        -- Chopping Aura enforcement
        if TreesControl.ChoppingAuraEnabled and UpdateChoppingAura then
            pcall(UpdateChoppingAura)
        end
        
        -- Campfire Refill enforcement
        if CampfireControl.AutoRefillEnabled then
            pcall(UpdateCampfireRefill)
        end
        
        -- Crafting enforcement
        if CraftingControl.ProduceScrapEnabled or CraftingControl.ProduceWoodEnabled or CraftingControl.ProduceCultistGemEnabled then
            pcall(UpdateCrafting)
        end
        
        -- Food teleport enforcement
        if FoodControl.TeleportFoodEnabled then
            pcall(UpdateFoodTeleport)
        end
        
        -- Animal Pelts teleport enforcement
        if AnimalPeltsControl.TeleportPeltsEnabled then
            pcall(UpdateAnimalPeltsTeleport)
        end
        
        -- Healing teleport enforcement
        if HealingControl.TeleportHealingEnabled then
            pcall(UpdateHealingTeleport)
        end
        
        -- Ammo teleport enforcement
        if AmmoControl.TeleportAmmoEnabled then
            pcall(UpdateAmmoTeleport)
        end
        
        -- ESP system enforcement
        if ESPControl.Enabled then
            pcall(UpdateAllESP)
        end
        
        -- Auto trap enforcement
        if TrapControl.AutoTrapEnabled then
            pcall(UpdateAutoTrap)
        end
    end
end

-- Get Client module for damage dealing - more aggressive search
local function GetClientModule()
    -- Method 1: Direct require from PlayerScripts
    local success, client = pcall(function()
        return require(LocalPlayer.PlayerScripts.Client)
    end)
    
    if success and client then
        return client
    end
    
    -- Method 2: Search for Client in player scripts
    for _, script in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
        if script:IsA("ModuleScript") and script.Name == "Client" then
            local success2, client2 = pcall(function()
                return require(script)
            end)
            
            if success2 and client2 then
                return client2
            end
        end
    end
    
    -- Method 3: Try common game frameworks
    local commonPaths = {
        LocalPlayer.PlayerScripts.Framework,
        LocalPlayer.PlayerScripts.System,
        LocalPlayer.PlayerScripts.GameClient,
        LocalPlayer.PlayerScripts.Main,
        game:GetService("ReplicatedStorage").Modules,
        game:GetService("ReplicatedStorage").Framework,
        game:GetService("ReplicatedStorage").Shared
    }
    
    for _, path in pairs(commonPaths) do
        if path then
            local success3, client3 = pcall(function()
                return require(path)
            end)
            
            if success3 and client3 then
                return client3
            end
        end
    end
    
    -- Method 4: Create our own bare minimal client structure
    local customClient = {
        Events = {}
    }
    
    -- Find remote events in ReplicatedStorage
    local function findRemoteEvents()
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                customClient.Events[obj.Name] = obj
            end
        end
    end
    
    pcall(findRemoteEvents)
    
    -- Check if we found any events
    local eventCount = 0
    for _ in pairs(customClient.Events) do
        eventCount += 1
    end
    
    if eventCount > 0 then
        return customClient
    end
    
    return nil
end

-- Find hostile entities in range - simplified without debug messages
local function FindHostileEntities()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then 
        return {} 
    end
    
    local playerPos = char.HumanoidRootPart.Position
    local entities = {}
    local entityCount = 0
    
    -- METHOD 1: Check workspace.Characters (common structure)
    local charactersFolder = workspace:FindFirstChild("Characters")
    if charactersFolder then
        for _, entity in pairs(charactersFolder:GetChildren()) do
            if entity == char then continue end
            
            local humanoid = entity:FindFirstChildOfClass("Humanoid")
            local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Torso") or entity:FindFirstChild("UpperTorso")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local distance = (playerPos - rootPart.Position).Magnitude
                if distance <= CombatControl.AuraRange then
                    entityCount += 1
                    table.insert(entities, {
                        Entity = entity,
                        Type = game.Players:GetPlayerFromCharacter(entity) and "Player" or "NPC",
                        Distance = distance,
                        RootPart = rootPart
                    })
                end
            end
        end
    end
    
    -- METHOD 2: Direct workspace search for models with humanoids
    for _, entity in pairs(workspace:GetChildren()) do
        if entity:IsA("Model") and entity ~= char and entity.Name ~= "Characters" then
            local humanoid = entity:FindFirstChildOfClass("Humanoid")
            local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Torso") or entity:FindFirstChild("UpperTorso")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local distance = (playerPos - rootPart.Position).Magnitude
                if distance <= CombatControl.AuraRange then
                    -- Check if already found to avoid duplicates
                    local alreadyFound = false
                    for _, existingEntity in pairs(entities) do
                        if existingEntity.Entity == entity then
                            alreadyFound = true
                            break
                        end
                    end
                    
                    if not alreadyFound then
                        entityCount += 1
                        table.insert(entities, {
                            Entity = entity,
                            Type = game.Players:GetPlayerFromCharacter(entity) and "Player" or "NPC",
                            Distance = distance,
                            RootPart = rootPart
                        })
                    end
                end
            end
        end
    end
    
    -- METHOD 3: Check for enemies in common locations
    local commonEnemyFolders = {"NPCs", "Enemies", "Creatures", "Monsters", "Mobs", "Hostiles"}
    for _, folderName in ipairs(commonEnemyFolders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, entity in pairs(folder:GetDescendants()) do
                if entity:IsA("Model") and entity ~= char then
                    local humanoid = entity:FindFirstChildOfClass("Humanoid")
                    local rootPart = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Torso") or entity:FindFirstChild("UpperTorso")
                    
                    if humanoid and rootPart and humanoid.Health > 0 then
                        local distance = (playerPos - rootPart.Position).Magnitude
                        if distance <= CombatControl.AuraRange then
                            -- Check if already found to avoid duplicates
                            local alreadyFound = false
                            for _, existingEntity in pairs(entities) do
                                if existingEntity.Entity == entity then
                                    alreadyFound = true
                                    break
                                end
                            end
                            
                            if not alreadyFound then
                                entityCount += 1
                                table.insert(entities, {
                                    Entity = entity,
                                    Type = "NPC",
                                    Distance = distance,
                                    RootPart = rootPart
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Sort by distance (closest first)
    table.sort(entities, function(a, b) return a.Distance < b.Distance end)
    return entities
end

-- Create billboard GUI for tree health display
local function CreateTreeHealthGUI(tree, treePart)
    -- Remove existing billboard if it exists
    local existingBillboard = treePart:FindFirstChild("TreeHealthGUI")
    if existingBillboard then
        existingBillboard:Destroy()
    end
    
    -- Create new billboard GUI
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "TreeHealthGUI"
    billboardGui.Adornee = treePart
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    
    -- Create background frame
    local frame = Instance.new("Frame")
    frame.Parent = billboardGui
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    -- Create health bar
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Parent = frame
    healthBar.Size = UDim2.new(0.9, 0, 0.4, 0)
    healthBar.Position = UDim2.new(0.05, 0, 0.1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    healthBar.BorderSizePixel = 0
    
    -- Create health bar background
    local healthBg = Instance.new("Frame")
    healthBg.Parent = frame
    healthBg.Size = UDim2.new(0.9, 0, 0.4, 0)
    healthBg.Position = UDim2.new(0.05, 0, 0.1, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBg.BorderSizePixel = 0
    healthBg.ZIndex = healthBar.ZIndex - 1
    
    -- Create health text
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Parent = frame
    healthText.Size = UDim2.new(1, 0, 0.4, 0)
    healthText.Position = UDim2.new(0, 0, 0.55, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "100/100"
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextScaled = true
    healthText.Font = Enum.Font.SourceSansBold
    
    billboardGui.Parent = treePart
    
    -- Store reference for cleanup
    TreesControl.ActiveBillboards[tree] = billboardGui
    
    return billboardGui
end

-- Update tree health display
local function UpdateTreeHealthGUI(tree, treePart)
    local billboard = TreesControl.ActiveBillboards[tree]
    if not billboard or not billboard.Parent then
        -- Create new billboard if it doesn't exist
        billboard = CreateTreeHealthGUI(tree, treePart)
    end
    
    local currentHealth = tree:GetAttribute("Health") or 0
    local maxHealth = tree:GetAttribute("MaxHealth") or currentHealth
    
    if maxHealth <= 0 then maxHealth = 100 end -- Fallback
    
    local healthPercentage = math.max(0, currentHealth / maxHealth)
    
    -- Update health bar
    local healthBar = billboard:FindFirstChild("Frame"):FindFirstChild("HealthBar")
    if healthBar then
        healthBar.Size = UDim2.new(0.9 * healthPercentage, 0, 0.4, 0)
        
        -- Color based on health percentage
        if healthPercentage > 0.6 then
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
        elseif healthPercentage > 0.3 then
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
        end
    end
    
    -- Update health text
    local healthText = billboard:FindFirstChild("Frame"):FindFirstChild("HealthText")
    if healthText then
        healthText.Text = math.floor(currentHealth) .. "/" .. math.floor(maxHealth)
    end
    
    -- Remove billboard if tree is dead
    if currentHealth <= 0 then
        task.delay(2, function() -- Keep it visible for 2 seconds after death
            if billboard and billboard.Parent then
                billboard:Destroy()
            end
            TreesControl.ActiveBillboards[tree] = nil
        end)
    end
end

-- Clean up billboard GUIs
local function CleanupTreeGUIs()
    for tree, billboard in pairs(TreesControl.ActiveBillboards) do
        if not tree.Parent or not billboard.Parent then
            if billboard and billboard.Parent then
                billboard:Destroy()
            end
            TreesControl.ActiveBillboards[tree] = nil
        end
    end
end

-- Validate and clean current targets (remove dead/missing trees)
local function ValidateCurrentTargets()
    local validTargets = {}
    
    for _, targetData in ipairs(TreesControl.CurrentTargets) do
        local tree = targetData.Tree
        -- Check if tree still exists and has health > 0
        if tree and tree.Parent and tree:GetAttribute("Health") and tree:GetAttribute("Health") > 0 then
            table.insert(validTargets, targetData)
        else
            -- Remove billboard for dead/missing tree
            if TreesControl.ActiveBillboards[tree] then
                local billboard = TreesControl.ActiveBillboards[tree]
                if billboard and billboard.Parent then
                    billboard:Destroy()
                end
                TreesControl.ActiveBillboards[tree] = nil
            end
        end
    end
    
    TreesControl.CurrentTargets = validTargets
end

-- Find trees in range for chopping
local function FindTreesInRange()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then 
        return {} 
    end
    
    local playerPos = char.HumanoidRootPart.Position
    local trees = {}
    
    -- Look for trees in workspace.Map.Foliage (as specifically requested)
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        local foliageFolder = mapFolder:FindFirstChild("Foliage")
        if foliageFolder then
            for _, tree in pairs(foliageFolder:GetChildren()) do
                -- Check if it has Health attribute (indicates it's a choppable tree)
                if tree:GetAttribute("Health") then
                -- Filter by tree type if not "Every tree"
                local shouldTarget = false
                if TreesControl.TargetTreeType == "Every tree" then
                    shouldTarget = true
                else
                    -- Use exact matching for tree type
                    shouldTarget = tree.Name == TreesControl.TargetTreeType
                end                    if shouldTarget then
                        local treePart = tree:FindFirstChild("Part") or tree:FindFirstChild("Trunk") or tree
                        if treePart and treePart:IsA("BasePart") then
                            local distance = (playerPos - treePart.Position).Magnitude
                            if distance <= TreesControl.ChoppingRange then
                                table.insert(trees, {
                                    Tree = tree,
                                    Part = treePart,
                                    Distance = distance,
                                    Name = tree.Name,
                                    Health = tree:GetAttribute("Health") or 0,
                                    MaxHealth = tree:GetAttribute("MaxHealth") or tree:GetAttribute("Health") or 0
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Sort by distance (closest first)
    table.sort(trees, function(a, b) return a.Distance < b.Distance end)
    return trees
end

-- Execute chopping aura attack
UpdateChoppingAura = function()
    if not TreesControl.ChoppingAuraEnabled then
        return -- Chopping aura is disabled
    end
    
    local currentTime = tick()
    -- Use same cooldown as combat
    if currentTime - TreesControl.LastChoppingAttack < TreesControl.ChoppingCooldown then 
        return 
    end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then 
        return 
    end
    
    -- Clean up old billboard GUIs
    CleanupTreeGUIs()
    
    -- Validate current targets (remove dead/missing trees)
    ValidateCurrentTargets()
    
    -- Try to equip best axe using new direct system
    local success, equippedAxe = EquipBestAxeNow()
    if not success or not equippedAxe then
        return -- Failed to equip axe
    end
    
    -- Small delay after equipping
    task.wait(0.05)
    
    -- Determine how many targets we need based on mode
    local maxTargets = TreesControl.UltraChoppingEnabled and TreesControl.UltraChopCount or 1
    
    -- Only search for new targets if we don't have enough current targets
    if #TreesControl.CurrentTargets < maxTargets then
        local availableTrees = FindTreesInRange()
        
        -- Filter out trees we're already targeting
        local newTrees = {}
        for _, treeData in ipairs(availableTrees) do
            local alreadyTargeting = false
            for _, currentTarget in ipairs(TreesControl.CurrentTargets) do
                if currentTarget.Tree == treeData.Tree then
                    alreadyTargeting = true
                    break
                end
            end
            
            if not alreadyTargeting then
                table.insert(newTrees, treeData)
            end
        end
        
        -- Add new targets up to our maximum
        local targetsNeeded = maxTargets - #TreesControl.CurrentTargets
        for i = 1, math.min(targetsNeeded, #newTrees) do
            table.insert(TreesControl.CurrentTargets, newTrees[i])
        end
    end
    
    -- If we still have no targets, return
    if #TreesControl.CurrentTargets == 0 then
        return
    end
    
    -- Get the correct remotes from ReplicatedStorage
    local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
    if not remoteEvents then
        return
    end
    
    local toolDamageRemote = remoteEvents:FindFirstChild("ToolDamageObject")
    if not toolDamageRemote then
        return
    end
    
    -- Attack our current targets
    TreesControl.LastChoppingAttack = currentTime
    local overallSuccess = true
    
    -- Create/update health displays for all current targets first
    for _, targetData in ipairs(TreesControl.CurrentTargets) do
        UpdateTreeHealthGUI(targetData.Tree, targetData.Part)
    end
    
    -- Attack ALL current targets simultaneously (no delays between attacks)
    for _, targetData in ipairs(TreesControl.CurrentTargets) do
        local chopSuccess = pcall(function()
            local chopArgs = {
                [1] = targetData.Tree,  -- The tree to chop
                [2] = equippedAxe,      -- The axe we're using
                [3] = "1_9303764245",   -- Tree damage identifier (different from combat)
                [4] = char.HumanoidRootPart.CFrame -- Player's CFrame
            }
            
            toolDamageRemote:InvokeServer(unpack(chopArgs))
        end)
        
        if not chopSuccess then
            overallSuccess = false
        end
    end
    
    -- Update all health displays after all attacks
    task.delay(0.1, function()
        for _, targetData in ipairs(TreesControl.CurrentTargets) do
            if targetData.Tree.Parent then
                UpdateTreeHealthGUI(targetData.Tree, targetData.Part)
            end
        end
    end)
    
    -- If chopping failed, reset axe tracking to force re-detection
    if not overallSuccess then
        AxeManager.CurrentlyEquipped = nil
    end
end

-- Execute kill aura attack using the correct RemoteSpy structure (upgrade detection fix)
UpdateKillAura = function()
    local currentTime = tick()
    -- Use fixed axe cooldown timing (0.9 seconds)
    if currentTime - CombatControl.LastAuraAttack < CombatControl.AttackCooldown then 
        return 
    end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then 
        return 
    end
    
    -- Try to equip best weapon using new weapon system
    local success, equippedWeapon = EquipBestWeapon(CombatControl.WeaponType)
    if not success or not equippedWeapon then
        return -- Failed to equip weapon
    end
    
    -- Small delay after equipping
    task.wait(0.05)
    
    local entities = FindHostileEntities()
    if #entities == 0 then
        return 
    end
    
    -- Get the correct remotes from ReplicatedStorage
    local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
    if not remoteEvents then
        return
    end
    
    local toolDamageRemote = remoteEvents:FindFirstChild("ToolDamageObject")
    if not toolDamageRemote then
        return
    end
    
    -- Step 4: Attack targets based on mode
    CombatControl.LastAuraAttack = currentTime
    local overallSuccess = true
    
    if CombatControl.UltraKillEnabled then
        -- Ultra Kill Mode: Attack ALL targets in range
        local attackCount = 0
        local successCount = 0
        
        for _, entityData in ipairs(entities) do
            local damageSuccess = pcall(function()
                local damageArgs = {
                    [1] = entityData.Entity,  -- Each target entity
                    [2] = equippedWeapon,     -- The weapon we're using
                    [3] = "2_9303764245",     -- The damage identifier from RemoteSpy
                    [4] = char.HumanoidRootPart.CFrame -- Player's CFrame
                }
                
                toolDamageRemote:InvokeServer(unpack(damageArgs))
            end)
            
            attackCount = attackCount + 1
            if damageSuccess then
                successCount = successCount + 1
            else
                overallSuccess = false
            end
            
            -- Small delay between attacks to avoid overwhelming server
            if attackCount % 3 == 0 then
                task.wait(0.05) -- Brief pause every 3 attacks
            end
        end
        
    else
        -- Standard Kill Mode: Attack closest target only
        local target = entities[1] -- Primary target for single mode
        local damageSuccess = pcall(function()
            local damageArgs = {
                [1] = target.Entity,  -- The closest target entity
                [2] = equippedWeapon, -- The weapon we're using
                [3] = "2_9303764245", -- The damage identifier from RemoteSpy
                [4] = char.HumanoidRootPart.CFrame -- Player's CFrame
            }
            
            toolDamageRemote:InvokeServer(unpack(damageArgs))
        end)
        
        if not damageSuccess then
            overallSuccess = false
        end
    end
    
    -- If damage failed, reset tracking to force re-detection
    if not overallSuccess then
        AxeManager.CurrentlyEquipped = nil
    end
end

-- Execute second kill aura attack (independent system)
-- Unified update for current character
local function UpdateAll()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    StoreOriginals(humanoid)
    ApplySpeed(humanoid)
    ApplyJump(humanoid)
end

-- Character spawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
    PlayerControl.OriginalsStored = false
    char:WaitForChild("Humanoid")
    task.delay(0.25, UpdateAll)
end)

--============================================================================--
--      [[ SMART AUTO EAT FUNCTIONS ]]
--============================================================================--

-- Function to find closest food item on ground
local function findClosestFood()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then 
        return nil 
    end
    
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then 
        return nil 
    end
    
    local closestItem = nil
    local closestDist = math.huge
    
    for _, item in ipairs(itemsFolder:GetChildren()) do
        -- Check if this item is one of our target food types
        for _, foodType in ipairs(SmartEatFoodTypes) do
            if item.Name == foodType then
                local itemPart = item:IsA("Model") and item.PrimaryPart or item
                if itemPart and itemPart:IsA("BasePart") then
                    local dist = (rootPart.Position - itemPart.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestItem = item
                    end
                end
                break
            end
        end
    end
    
    return closestItem, closestDist
end

-- Function to consume food item
local function consumeFood(foodItem)
    if not foodItem then 
        return false 
    end
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    
    if not remoteEvents then
        return false
    end
    
    local consumeRemote = remoteEvents:FindFirstChild("RequestConsumeItem")
    if not consumeRemote then
        return false
    end
    
    local success, result = pcall(function()
        return consumeRemote:InvokeServer(foodItem)
    end)
    
    return success
end

-- Function to check hunger and eat if needed
local function checkHungerAndEat()
    -- First check if enabled
    if not SkybaseControl.SmartAutoEatEnabled then 
        return 
    end
    
    local currentTime = tick()
    if currentTime - SkybaseControl.LastHungerCheck < SkybaseControl.HungerCheckCooldown then
        return
    end
    SkybaseControl.LastHungerCheck = currentTime
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    
    if not character then 
        return 
    end
    
    -- Check player's hunger attribute (always check player first)
    local hungerAttribute = player:GetAttribute("Hunger")
    if not hungerAttribute then 
        return 
    end
    
    -- If hunger is at or below threshold, try to eat
    if hungerAttribute <= SkybaseControl.HungerThreshold then
        local foodItem, distance = findClosestFood()
        if foodItem and distance <= 50 then -- Only try to eat if food is within 50 studs
            consumeFood(foodItem)
        end
    end
end

-- Function to check anti-AFK system and make character jump every 5 minutes
local function checkAntiAfk()
    -- First check if enabled
    if not SkybaseControl.AntiAfkEnabled then 
        return 
    end
    
    local currentTime = tick()
    if currentTime - SkybaseControl.LastJumpTime < SkybaseControl.JumpInterval then
        return
    end
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    
    if not character then 
        return 
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then 
        return 
    end
    
    -- Make the character jump to prevent AFK kick
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    SkybaseControl.LastJumpTime = currentTime
    
    print("🦘 Anti-AFK: Character jumped to prevent kick")
end

--============================================================================--
--      [[ LOST CHILDREN FUNCTIONS ]]
--============================================================================--

-- Function to enable/disable noclip
local function setNoclip(enabled)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end
end

-- Function to check which children are already rescued
local function checkRescuedChildren()
    local rescued = {}
    local structuresFolder = workspace:FindFirstChild("Structures")
    
    print("🔍 Checking for rescued children...")
    
    if structuresFolder then
        print("✅ Found Structures folder")
        
        -- Debug: List all structures
        print("📋 Available structures:")
        for _, structure in pairs(structuresFolder:GetChildren()) do
            print("  - " .. structure.Name)
        end
        
        for childName, data in pairs(ChildrenData) do
            local tent = structuresFolder:FindFirstChild(data.tent)
            if tent then
                rescued[childName] = true
                print("✅ Found tent for " .. childName .. ": " .. data.tent)
            else
                print("❌ Missing tent for " .. childName .. ": " .. data.tent)
                
                -- Try alternative tent naming patterns
                local alternativeTents = {
                    data.tent,
                    data.tent:gsub("Kid", ""),  -- Remove "Kid" suffix
                    data.tent:gsub("Tent", ""), -- Remove "Tent" prefix
                    "Tent" .. data.name,        -- Use just the child name
                    data.name .. "Tent",        -- Name + Tent
                    data.name .. "Kid",         -- Name + Kid
                }
                
                for _, altTent in pairs(alternativeTents) do
                    local foundTent = structuresFolder:FindFirstChild(altTent)
                    if foundTent then
                        rescued[childName] = true
                        print("✅ Found alternative tent for " .. childName .. ": " .. altTent)
                        break
                    end
                end
            end
        end
    else
        print("❌ Structures folder not found!")
    end
    
    local rescueCount = 0
    for _ in pairs(rescued) do rescueCount = rescueCount + 1 end
    print("📊 Total rescued children detected: " .. rescueCount .. "/4")
    
    return rescued
end

-- Function to find any sack in player inventory
local function findPlayerSack()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local inventory = player:FindFirstChild("Inventory")
    
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item.Name:find("Sack") then
                return item
            end
        end
    end
    
    return nil
end

-- Function to check if a position has been visited or is too close to visited areas
local function isPositionVisited(position)
    for _, visitedPos in pairs(LostChildrenControl.VisitedWolves) do
        local distance = (position - visitedPos).Magnitude
        if distance < 150 then -- Mark areas within 150 studs as visited
            return true
        end
    end
    return false
end

-- Function to mark a wolf position and surrounding area as visited
local function markWolfAreaAsVisited(position)
    table.insert(LostChildrenControl.VisitedWolves, position)
    
    -- Also mark surrounding wolves and alpha wolves in the area as visited
    local charactersFolder = workspace:FindFirstChild("Characters")
    if charactersFolder then
        for _, entity in pairs(charactersFolder:GetChildren()) do
            if entity.Name == "Wolf" or entity.Name == "Alpha Wolf" then
                local humanoidRootPart = entity:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local entityPos = humanoidRootPart.Position
                    local distance = (entityPos - position).Magnitude
                    if distance < 150 then -- Mark wolves within 150 studs
                        table.insert(LostChildrenControl.VisitedWolves, entityPos)
                    end
                end
            end
        end
    end
end

-- Function to find wolves/alpha wolves for teleportation
local function findWolvesForTeleport()
    local charactersFolder = workspace:FindFirstChild("Characters")
    if not charactersFolder then return {} end
    
    local wolves = {}
    local usedPositions = {}
    
    -- Find all wolves and alpha wolves
    for _, entity in pairs(charactersFolder:GetChildren()) do
        if entity.Name == "Wolf" or entity.Name == "Alpha Wolf" then
            local humanoidRootPart = entity:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local position = humanoidRootPart.Position
                local tooClose = false
                
                -- Check if this position has been visited
                if isPositionVisited(position) then
                    tooClose = true
                end
                
                -- Check if this wolf is too close to any previously selected wolf in this search
                for _, usedPos in pairs(usedPositions) do
                    local distance = (position - usedPos).Magnitude
                    if distance < 150 then -- Minimum 150 studs apart
                        tooClose = true
                        break
                    end
                end
                
                -- Also check distance from last teleport position
                if LostChildrenControl.LastTeleportPosition then
                    local lastDistance = (position - LostChildrenControl.LastTeleportPosition).Magnitude
                    if lastDistance < 150 then
                        tooClose = true
                    end
                end
                
                if not tooClose then
                    -- Add 50 studs height for safety
                    local safePosition = position + Vector3.new(0, 50, 0)
                    table.insert(wolves, safePosition)
                    table.insert(usedPositions, position)
                end
            end
        end
    end
    
    return wolves
end

-- Function to find lost child in workspace
local function findLostChild()
    local charactersFolder = workspace:FindFirstChild("Characters")
    if not charactersFolder then return nil end
    
    for childName, _ in pairs(ChildrenData) do
        if not LostChildrenControl.RescuedChildren[childName] then
            local child = charactersFolder:FindFirstChild(childName)
            if child then
                return child, childName
            end
        end
    end
    
    return nil, nil
end

-- Function to teleport player to position
local function teleportPlayer(position)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(position)
        LostChildrenControl.LastTeleportPosition = position
        LostChildrenControl.LastTeleportTime = tick()
    end
end

-- Function to bag a child
local function bagChild(child, sack)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local bagStoreRemote = ReplicatedStorage:FindFirstChild("RemoteEvents")
    
    if bagStoreRemote then
        bagStoreRemote = bagStoreRemote:FindFirstChild("RequestBagStoreItem")
        if bagStoreRemote then
            local success = pcall(function()
                bagStoreRemote:InvokeServer(sack, child)
            end)
            return success
        end
    end
    
    return false
end

-- Function to perform rescue sequence
local function performRescueSequence()
    if not LostChildrenControl.RescueEnabled then return end
    
    local currentTime = tick()
    if currentTime - LostChildrenControl.LastTeleportTime < LostChildrenControl.TeleportCooldown then
        return -- Still in cooldown
    end
    
    -- Check if we have a sack
    local sack = findPlayerSack()
    if not sack then
        return -- No sack available
    end
    
    -- Look for any lost child
    local child, childName = findLostChild()
    
    if child then
        -- Found a child! Try to rescue
        LostChildrenControl.CurrentStep = "rescuing"
        
        -- Teleport to child first
        local childPart = child:FindFirstChild("HumanoidRootPart")
        if childPart then
            teleportPlayer(childPart.Position + Vector3.new(0, 5, 0))
            
            task.wait(1)
            
            -- Try to bag the child (skip campfire drop)
            if bagChild(child, sack) then
                -- Successfully bagged - mark as rescued and continue searching
                LostChildrenControl.RescuedChildren[childName] = true
                LostChildrenControl.CurrentStep = "searching"
                print("✅ Successfully bagged " .. childName .. " - continuing search...")
            end
        end
    else
        -- No child found, do brute force teleport
        LostChildrenControl.CurrentStep = "searching"
        
        local wolves = findWolvesForTeleport()
        if #wolves > 0 then
            -- Teleport to a random wolf position
            local randomWolf = wolves[math.random(1, #wolves)]
            teleportPlayer(randomWolf)
            
            -- Mark this wolf area as visited
            markWolfAreaAsVisited(randomWolf - Vector3.new(0, 50, 0)) -- Remove the height offset for marking
            
            print("🐺 Teleported to wolf area and marked as visited (Total visited: " .. #LostChildrenControl.VisitedWolves .. ")")
        else
            -- No unvisited wolves found, reset visited list and try again
            print("🔄 All wolf areas visited, resetting search pattern...")
            LostChildrenControl.VisitedWolves = {}
            
            -- Try again with fresh wolf list
            wolves = findWolvesForTeleport()
            if #wolves > 0 then
                local randomWolf = wolves[math.random(1, #wolves)]
                teleportPlayer(randomWolf)
                markWolfAreaAsVisited(randomWolf - Vector3.new(0, 50, 0))
                print("🐺 Fresh search: Teleported to wolf area")
            else
                print("❌ No wolves found in the map!")
            end
        end
    end
end

-- Function to stop rescue process
local function stopRescueProcess()
    LostChildrenControl.RescueEnabled = false
    LostChildrenControl.CurrentStep = "returning"
    
    -- Disable noclip
    setNoclip(false)
    
    -- Restore original gravity
    if LostChildrenControl.OriginalGravity then
        workspace.Gravity = LostChildrenControl.OriginalGravity
        LostChildrenControl.OriginalGravity = nil
        print("🌍 Gravity restored to normal")
    end
    
    -- Return to original position
    if LostChildrenControl.OriginalPosition then
        teleportPlayer(LostChildrenControl.OriginalPosition)
        LostChildrenControl.OriginalPosition = nil
    end
    
    LostChildrenControl.CurrentStep = "idle"
end

-- Function to start rescue process
local function startRescueProcess()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then return end
    
    -- Save original position
    LostChildrenControl.OriginalPosition = humanoidRootPart.Position
    
    -- Save original gravity and set to 0 for flying
    LostChildrenControl.OriginalGravity = workspace.Gravity
    workspace.Gravity = 0
    print("🚀 Gravity set to 0 - Player can now fly freely")
    
    -- Enable noclip
    setNoclip(true)
    
    -- Check which children are already rescued
    LostChildrenControl.RescuedChildren = checkRescuedChildren()
    
    -- Clear visited wolves list for fresh start
    LostChildrenControl.VisitedWolves = {}
    print("🔄 Cleared visited wolves list for fresh search")
    
    -- Start the process
    LostChildrenControl.RescueEnabled = true
    LostChildrenControl.CurrentStep = "searching"
end

-- Function to get rescue progress
local function getRescueProgress()
    local total = 0
    local rescued = 0
    
    for _ in pairs(ChildrenData) do
        total = total + 1
    end
    
    for _ in pairs(LostChildrenControl.RescuedChildren) do
        rescued = rescued + 1
    end
    
    return rescued, total
end

-- Use Heartbeat (post-physics) so gravity doesn't cause slow descent during fly
RunService.Heartbeat:Connect(function()
    StepUpdate()
    checkHungerAndEat() -- Check hunger every frame (but with cooldown)
    checkAntiAfk() -- Check anti-AFK system
    
    -- Lost Children Rescue System
    if LostChildrenControl.RescueEnabled then
        -- Check if all children are collected first
        local rescued, total = getRescueProgress()
        
        if rescued >= total then
            -- All 4 children collected! Just stop and return home
            print("🎉 All " .. total .. " children collected in sacks! Mission complete!")
            stopRescueProcess()
            if LostChildrenToggle then
                LostChildrenToggle:Set(false)
            end
            if LostChildrenStatus then
                LostChildrenStatus.Text = "Status: All children collected! ✅"
            end
        else
            -- Still need to collect more children
            performRescueSequence()
        end
        
        -- Update GUI status (only if GUI elements exist)
        if LostChildrenStatus then
            local statusText = "Status: "
            if LostChildrenControl.CurrentStep == "searching" then
                statusText = statusText .. "Searching for children... (" .. rescued .. "/" .. total .. ")"
            elseif LostChildrenControl.CurrentStep == "rescuing" then
                statusText = statusText .. "Rescuing child... (" .. rescued .. "/" .. total .. ")"
            elseif LostChildrenControl.CurrentStep == "returning" then
                statusText = statusText .. "Returning to original location..."
            else
                statusText = statusText .. "Active (" .. rescued .. "/" .. total .. ")"
            end
            LostChildrenStatus.Text = statusText
        end
    else
        if LostChildrenStatus then
            LostChildrenStatus.Text = "Status: Inactive"
        end
    end
end)

-- Info Section Content
InfoTab:CreateLabel("📖 Please read before using:")
InfoTab:CreateLabel("🔥 Fire Setup:")
InfoTab:CreateLabel("Make sure to upgrade your fire to maximum level.")
InfoTab:CreateLabel("Items may glitch if you teleport them from unopened")
InfoTab:CreateLabel("map areas to your location.")
InfoTab:CreateLabel("🎯 Transport Options:")
InfoTab:CreateLabel("Each transport feature has two destination options:")
InfoTab:CreateLabel("• Player: Teleports items to your location")
InfoTab:CreateLabel("• Campfire/Scrapper: Teleports to the specified station")
InfoTab:CreateLabel("Choose the option that works best for you!")
InfoTab:CreateLabel("🐛 Found issues or have ideas?")
InfoTab:CreateLabel("Join the Discord community! You can find the link")
InfoTab:CreateLabel("in the Credits section above.")
InfoTab:CreateLabel("We welcome bug reports and feature suggestions!")

--============================================================================--
--      [[ SKYBASE FUNCTIONS ]]
--============================================================================--

-- Function to create the platform
local function createOrDeletePlatform()
    -- If platform already exists, delete it
    if SkybaseControl.PlatformModel then
        SkybaseControl.PlatformModel:Destroy()
        SkybaseControl.PlatformModel = nil
        return
    end

    local character = game.Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    SkybaseControl.PlatformModel = Instance.new("Model")
    SkybaseControl.PlatformModel.Name = "CustomBuildPlatform"
    SkybaseControl.PlatformModel.Parent = workspace

    local startPosition = rootPart.CFrame * CFrame.new(0, -5, -15)

    -- Get dimensions from the GUI inputs (default to 4x4)
    local xSize = 4
    local zSize = 4
    
    if SkybaseControl.SkybaseGui and SkybaseControl.SkybaseGui.Parent then
        local xInput = SkybaseControl.SkybaseGui:FindFirstChild("MainFrame"):FindFirstChild("XInput")
        local yInput = SkybaseControl.SkybaseGui:FindFirstChild("MainFrame"):FindFirstChild("YInput")
        if xInput then xSize = tonumber(xInput.Text) or 4 end
        if yInput then zSize = tonumber(yInput.Text) or 4 end
    end

    -- Create the grid of parts
    for x = 1, xSize do
        for z = 1, zSize do
            local part = Instance.new("Part")
            part.Name = "Grass"
            part.Size = Vector3.new(4, 0.5, 4)
            part.Anchored = true
            part.CanCollide = true
            part.Color = Color3.fromRGB(83, 126, 62)
            part.Material = Enum.Material.Grass
            part.Transparency = 0.5
            
            local xOffset = (x - (xSize + 1) / 2) * 4
            local zOffset = (z - (zSize + 1) / 2) * 4
            part.CFrame = startPosition * CFrame.new(xOffset, 0, zOffset)
            part.Parent = SkybaseControl.PlatformModel
        end
    end
end

-- Function to move the platform
local function movePlatform(directionVector)
    if not SkybaseControl.PlatformModel then return end
    SkybaseControl.PlatformModel:TranslateBy(directionVector * SkybaseControl.MOVE_INCREMENT)
end

-- Function to create the improved Skybase GUI
local function createSkybaseGui()
    if SkybaseControl.SkybaseGui then return end
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SkybaseGui"
    screenGui.ResetOnSpawn = false
    SkybaseControl.SkybaseGui = screenGui

    -- Main Frame (draggable) - Extra small size for mobile compatibility
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 180, 0, 220)
    mainFrame.Position = UDim2.new(0.5, -90, 0.5, -110)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Add drop shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    -- Fix title bar corners to only round top
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🏗️ Sky Base"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton

    -- Size Input Section
    local sizeLabel = Instance.new("TextLabel")
    sizeLabel.Name = "SizeLabel"
    sizeLabel.Size = UDim2.new(1, -20, 0, 25)
    sizeLabel.Position = UDim2.new(0, 10, 0, 50)
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Text = "📏 Platform Size:"
    sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    sizeLabel.TextScaled = true
    sizeLabel.Font = Enum.Font.SourceSansBold
    sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    sizeLabel.Parent = mainFrame

    -- X Size Input
    local xInput = Instance.new("TextBox")
    xInput.Name = "XInput"
    xInput.Size = UDim2.new(0.4, -5, 0, 35)
    xInput.Position = UDim2.new(0, 10, 0, 80)
    xInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    xInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    xInput.PlaceholderText = "Width (X)"
    xInput.Text = "4"
    xInput.Font = Enum.Font.SourceSans
    xInput.TextScaled = true
    xInput.Parent = mainFrame

    local xCorner = Instance.new("UICorner")
    xCorner.CornerRadius = UDim.new(0, 6)
    xCorner.Parent = xInput

    -- Y Size Input
    local yInput = Instance.new("TextBox")
    yInput.Name = "YInput"
    yInput.Size = UDim2.new(0.4, -5, 0, 35)
    yInput.Position = UDim2.new(0.6, 5, 0, 80)
    yInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    yInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    yInput.PlaceholderText = "Length (Y)"
    yInput.Text = "4"
    yInput.Font = Enum.Font.SourceSans
    yInput.TextScaled = true
    yInput.Parent = mainFrame

    local yCorner = Instance.new("UICorner")
    yCorner.CornerRadius = UDim.new(0, 6)
    yCorner.Parent = yInput

    -- Create/Delete Platform Button
    local createButton = Instance.new("TextButton")
    createButton.Name = "CreateButton"
    createButton.Size = UDim2.new(1, -20, 0, 40)
    createButton.Position = UDim2.new(0, 10, 0, 125)
    createButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    createButton.Text = "🏗️ Create Platform"
    createButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    createButton.TextScaled = true
    createButton.Font = Enum.Font.SourceSansBold
    createButton.Parent = mainFrame

    local createCorner = Instance.new("UICorner")
    createCorner.CornerRadius = UDim.new(0, 8)
    createCorner.Parent = createButton

    -- Movement Controls Label
    local moveLabel = Instance.new("TextLabel")
    moveLabel.Name = "MoveLabel"
    moveLabel.Size = UDim2.new(1, -20, 0, 25)
    moveLabel.Position = UDim2.new(0, 10, 0, 175)
    moveLabel.BackgroundTransparency = 1
    moveLabel.Text = "🎮 Movement Controls:"
    moveLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    moveLabel.TextScaled = true
    moveLabel.Font = Enum.Font.SourceSansBold
    moveLabel.TextXAlignment = Enum.TextXAlignment.Left
    moveLabel.Parent = mainFrame

    -- Movement Buttons
    local function createMoveButton(name, text, position, size, color)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = size
        button.Position = position
        button.BackgroundColor3 = color
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.SourceSansBold
        button.Parent = mainFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button

        return button
    end

    -- Movement button layout (organized grid)
    local upBtn = createMoveButton("UpButton", "⬆️ Up", UDim2.new(0.5, -40, 0, 205), UDim2.new(0, 80, 0, 25), Color3.fromRGB(70, 130, 180))
    local downBtn = createMoveButton("DownButton", "⬇️ Down", UDim2.new(0.5, -40, 0, 285), UDim2.new(0, 80, 0, 25), Color3.fromRGB(70, 130, 180))
    
    -- Left and Right buttons (middle row, left side)
    local leftBtn = createMoveButton("LeftButton", "⬅️ Left", UDim2.new(0, 10, 0, 235), UDim2.new(0, 65, 0, 25), Color3.fromRGB(100, 100, 100))
    local rightBtn = createMoveButton("RightButton", "➡️ Right", UDim2.new(0, 10, 0, 265), UDim2.new(0, 65, 0, 25), Color3.fromRGB(100, 100, 100))
    
    -- Forward and Back buttons (middle row, right side)
    local fwdBtn = createMoveButton("ForwardButton", "🔼 Forward", UDim2.new(1, -75, 0, 235), UDim2.new(0, 65, 0, 25), Color3.fromRGB(50, 150, 50))
    local backBtn = createMoveButton("BackButton", "🔽 Back", UDim2.new(1, -75, 0, 265), UDim2.new(0, 65, 0, 25), Color3.fromRGB(150, 50, 50))

    -- Info Label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Size = UDim2.new(1, -20, 0, 30)
    infoLabel.Position = UDim2.new(0, 10, 0, 315)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "💡 Tip: Drag the window from the top bar"
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextWrapped = true
    infoLabel.Parent = mainFrame

    -- Connect button events
    createButton.MouseButton1Click:Connect(function()
        createOrDeletePlatform()
        -- Update button text and color
        if SkybaseControl.PlatformModel then
            createButton.Text = "🗑️ Delete Platform"
            createButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            createButton.Text = "🏗️ Create Platform"
            createButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        end
    end)

    -- Movement button connections
    upBtn.MouseButton1Click:Connect(function() movePlatform(Vector3.new(0, 1, 0)) end)
    downBtn.MouseButton1Click:Connect(function() movePlatform(Vector3.new(0, -1, 0)) end)
    leftBtn.MouseButton1Click:Connect(function() movePlatform(Vector3.new(-1, 0, 0)) end)
    rightBtn.MouseButton1Click:Connect(function() movePlatform(Vector3.new(1, 0, 0)) end)
    
    fwdBtn.MouseButton1Click:Connect(function()
        local lookVector = player.Character.HumanoidRootPart.CFrame.LookVector
        movePlatform(Vector3.new(lookVector.X, 0, lookVector.Z).Unit)
    end)
    
    backBtn.MouseButton1Click:Connect(function()
        local lookVector = player.Character.HumanoidRootPart.CFrame.LookVector
        movePlatform(-Vector3.new(lookVector.X, 0, lookVector.Z).Unit)
    end)

    -- Close button connection
    closeButton.MouseButton1Click:Connect(function()
        SkybaseControl.GuiEnabled = false
        screenGui:Destroy()
        SkybaseControl.SkybaseGui = nil
        -- Also delete platform when closing GUI
        if SkybaseControl.PlatformModel then
            SkybaseControl.PlatformModel:Destroy()
            SkybaseControl.PlatformModel = nil
        end
    end)

    -- Parent to PlayerGui
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Function to destroy Skybase GUI
local function destroySkybaseGui()
    if SkybaseControl.SkybaseGui then
        SkybaseControl.SkybaseGui:Destroy()
        SkybaseControl.SkybaseGui = nil
    end
    -- Also delete platform
    if SkybaseControl.PlatformModel then
        SkybaseControl.PlatformModel:Destroy()
        SkybaseControl.PlatformModel = nil
    end
end

-- Initialize lighting system
initializeLighting()

-- Reveal All Map Control
local RevealMapControl = {
    IsRevealing = false,
    TeleportCooldown = 1,
    VisitedPositions = {},
    GrassParts = {},
    RevealThread = nil,
    LastGrassCount = 0
}

local function roundPosition(position, precision)
    precision = precision or 1
    return Vector3.new(
        math.floor(position.X / precision + 0.5) * precision,
        math.floor(position.Y / precision + 0.5) * precision,
        math.floor(position.Z / precision + 0.5) * precision
    )
end

local function positionToString(position)
    local rounded = roundPosition(position, 5) -- Round to nearest 5 studs for position matching
    return string.format("%.0f,%.0f,%.0f", rounded.X, rounded.Y, rounded.Z)
end

local function isPositionVisited(position)
    local posKey = positionToString(position)
    return RevealMapControl.VisitedPositions[posKey] ~= nil
end

local function markPositionVisited(position)
    local posKey = positionToString(position)
    RevealMapControl.VisitedPositions[posKey] = true
end

local function refreshGrassParts()
    local newGrassParts = {}
    local groundFolder = workspace.Map and workspace.Map.Ground
    if groundFolder then
        for _, part in pairs(groundFolder:GetChildren()) do
            if part.Name == "Grass" and part:IsA("BasePart") then
                if not isPositionVisited(part.Position) then
                    table.insert(newGrassParts, part)
                end
            end
        end
    end
    
    local newCount = #newGrassParts
    local hasNewParts = newCount > RevealMapControl.LastGrassCount
    RevealMapControl.LastGrassCount = newCount
    RevealMapControl.GrassParts = newGrassParts
    
    return hasNewParts
end

local function teleportToGrassPart(grassPart)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and grassPart then
        -- Check if this position was already visited (double-check)
        if isPositionVisited(grassPart.Position) then
            return false
        end
        
        local position = grassPart.Position + Vector3.new(0, 35, 0) -- Teleport 35 studs above the grass
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
        
        -- Mark this position as visited
        markPositionVisited(grassPart.Position)

        return true
    end
    return false
end

local function startRevealingMap()
    if RevealMapControl.IsRevealing then
        return
    end
    
    -- Don't reset visited positions - keep memory of previously visited places
    -- RevealMapControl.VisitedPositions = {} -- REMOVED - this was causing revisits
    RevealMapControl.LastGrassCount = 0
    
    refreshGrassParts()
    
    if #RevealMapControl.GrassParts == 0 then
        return
    end
    
    RevealMapControl.IsRevealing = true
    
    RevealMapControl.RevealThread = task.spawn(function()
        while RevealMapControl.IsRevealing do
            -- Refresh grass parts to check for newly loaded areas
            local hasNewParts = refreshGrassParts()
            
            if #RevealMapControl.GrassParts == 0 then
                -- No more unvisited grass parts, we're done
                break
            end
            
            -- Get the next unvisited grass part
            local grassPart = RevealMapControl.GrassParts[1]
            
            if grassPart and teleportToGrassPart(grassPart) then
                -- Successfully teleported, wait for cooldown
                task.wait(RevealMapControl.TeleportCooldown)
                
                -- After teleporting, wait a bit more for potential new areas to load
                task.wait(0.1)
            else
                -- If teleportation failed, refresh the list and try again
                task.wait(0.1)
            end
        end
        
        if RevealMapControl.IsRevealing then
            RevealMapControl.IsRevealing = false
            -- Auto-turn off the toggle when completed
            if ApocLibrary and ApocLibrary.Flags and ApocLibrary.Flags["Misc_RevealAllMap"] then
                ApocLibrary.Flags["Misc_RevealAllMap"]:Set(false)
            end
        end
    end)
end

local function teleportToCampfire()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local campfire = workspace.Map and workspace.Map.Campground and workspace.Map.Campground.MainFire
        if campfire and campfire:FindFirstChild("Center") then
            local campfirePosition = campfire.Center.Position
            local teleportPosition = campfirePosition + Vector3.new(0, 5, 0)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        end
    end
end

local function stopRevealingMap()
    if RevealMapControl.RevealThread then
        task.cancel(RevealMapControl.RevealThread)
        RevealMapControl.RevealThread = nil
    end
    RevealMapControl.IsRevealing = false
    
    -- Teleport to campfire when stopping
    teleportToCampfire()
end

-- Misc GUI Controls
MiscTab:CreateLabel("After turning it off make sure to visit the campfire to restart the real time lighting")

MiscTab:CreateToggle({
    Name = "Always Day Light",
    CurrentValue = false,
    Flag = "Misc_AlwaysDayLight",
    Callback = function(v)
        toggleAlwaysDay(v)
    end
})

-- Performance Booster Section
MiscTab:CreateLabel("⚡ Performance Booster - Please note: Once you activate it, to disable you have to restart the game/server")

-- Performance Booster Control
local PerformanceBoosterControl = {
    IsActive = false,
    WorkspaceConnection = nil
}

local function optimizeObject(v)
    pcall(function()
        if not v or not v.Parent then return end
        
        if v:IsA("BasePart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end)
end

local function applyGlobalSettings()
    -- Terrain Settings
    local terrain = workspace:FindFirstChildOfClass('Terrain')
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
    end

    -- Lighting Settings (avoid conflict with Always Day Light)
    if not (ApocLibrary and ApocLibrary.Flags and ApocLibrary.Flags["Misc_AlwaysDayLight"] and ApocLibrary.Flags["Misc_AlwaysDayLight"].CurrentValue) then
        game:GetService("Lighting").GlobalShadows = false
    end
    game:GetService("Lighting").FogEnd = 9e9

    -- Graphics Quality Settings
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    -- Post-Processing Effects
    for i,v in pairs(game:GetService("Lighting"):GetDescendants()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end
end

local function activatePerformanceBooster()
    if PerformanceBoosterControl.IsActive then
        return
    end
    
    PerformanceBoosterControl.IsActive = true
    
    -- Apply global settings
    applyGlobalSettings()
    
    -- Optimize existing objects
    for i, v in pairs(workspace:GetDescendants()) do
        optimizeObject(v)
    end
    
    -- Connect to optimize new objects
    PerformanceBoosterControl.WorkspaceConnection = workspace.DescendantAdded:Connect(optimizeObject)
end

MiscTab:CreateToggle({
    Name = "Performance Booster",
    CurrentValue = false,
    Flag = "Misc_PerformanceBooster",
    Callback = function(v)
        if v then
            activatePerformanceBooster()
        end
        -- Note: Cannot be disabled once activated as per requirement
    end
})

-- Instant Open Chests Section
local InstantChestsControl = {
    IsActive = false,
    WorkspaceConnection = nil
}

local function patchChestPrompt(prompt)
    if prompt:IsA("ProximityPrompt") and prompt.Name == "ProximityInteraction" then
        local ancestor = prompt:FindFirstAncestorWhichIsA("Model")
        if ancestor and string.find(ancestor.Name, "Chest") then
            if prompt.HoldDuration > 0 then
                prompt.HoldDuration = 0
            end
        end
    end
end

local function activateInstantChests()
    if InstantChestsControl.IsActive then
        return
    end
    
    InstantChestsControl.IsActive = true
    
    -- Patch existing chest prompts
    for _, descendant in ipairs(workspace:GetDescendants()) do
        patchChestPrompt(descendant)
    end
    
    -- Watch for new chest prompts
    InstantChestsControl.WorkspaceConnection = workspace.DescendantAdded:Connect(patchChestPrompt)
end

local function deactivateInstantChests()
    if InstantChestsControl.WorkspaceConnection then
        InstantChestsControl.WorkspaceConnection:Disconnect()
        InstantChestsControl.WorkspaceConnection = nil
    end
    InstantChestsControl.IsActive = false
end

MiscTab:CreateToggle({
    Name = "Instant Open Chests",
    CurrentValue = false,
    Flag = "Misc_InstantOpenChests",
    Callback = function(v)
        if v then
            activateInstantChests()
        else
            deactivateInstantChests()
        end
    end
})

-- Reveal All Map Section
MiscTab:CreateLabel("🗺️ Map Revealing - Please make sure to max the campfire first, it would be much better")

MiscTab:CreateSlider({
    Name = "Teleport Cooldown",
    Range = {0, 5},
    Increment = 0.1,
    Suffix = " sec",
    CurrentValue = RevealMapControl.TeleportCooldown,
    Flag = "Misc_TeleportCooldown",
    Callback = function(val)
        RevealMapControl.TeleportCooldown = val
    end
})

MiscTab:CreateToggle({
    Name = "Reveal All Map",
    CurrentValue = false,
    Flag = "Misc_RevealAllMap",
    Callback = function(v)
        if v then
            startRevealingMap()
        else
            stopRevealingMap()
        end
    end
})

MiscTab:CreateButton({
    Name = "Clear Visited Positions",
    Callback = function()
        RevealMapControl.VisitedPositions = {}
        RevealMapControl.LastGrassCount = 0
        -- Also turn off the toggle if it's running
        if RevealMapControl.IsRevealing then
            stopRevealingMap()
            if ApocLibrary and ApocLibrary.Flags and ApocLibrary.Flags["Misc_RevealAllMap"] then
                ApocLibrary.Flags["Misc_RevealAllMap"]:Set(false)
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "🌸 Collect All Flowers",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local playerPos = char.HumanoidRootPart.Position
        local count = 0
        for _, landmark in pairs(workspace.Map.Landmarks:GetDescendants()) do
            if landmark.Name == "Flower" and landmark:FindFirstChild("HRP") then
                landmark.HRP.CFrame = CFrame.new(playerPos + Vector3.new(math.random(-5,5), 2, math.random(-5,5)))
                count = count + 1
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "🪙 Collect All Coins",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local playerPos = char.HumanoidRootPart.Position
        local count = 0
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name == "Coin Stack" and item:FindFirstChild("Main") then
                item.Main.CFrame = CFrame.new(playerPos + Vector3.new(math.random(-5,5), 2, math.random(-5,5)))
                count = count + 1
            end
        end
    end
})

-- Auto Stronghold control state
local AutoStrongholdControl = {
    Enabled = false,
    Connection = nil,
    LastCheck = 0,
    InProgress = false
}

-- Auto Stronghold function
local function AutoStronghold()
    if AutoStrongholdControl.InProgress then return end
    
    local currentTime = tick()
    if currentTime - AutoStrongholdControl.LastCheck < 5 then return end
    AutoStrongholdControl.LastCheck = currentTime
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    local success, result = pcall(function()
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        -- Case 1: Check if diamond chest exists and is unlocked (event completed by another user)
        local diamondChest = workspace.Items:FindFirstChild("Stronghold Diamond Chest")
        if diamondChest and (diamondChest:GetAttribute("Locked") == false or diamondChest:GetAttribute("Locked") == nil) then
            -- Check if chest is already opened using same logic as chest section
            local isOpened = false
            for attributeName, attributeValue in pairs(diamondChest:GetAttributes()) do
                if string.find(attributeName, "Opened") and attributeValue == true then
                    isOpened = true
                    break
                end
            end
            
            -- Only proceed if chest is not already opened
            if not isOpened then
            AutoStrongholdControl.InProgress = true
            
            -- Go to loot zone and open the chest
            local stronghold = workspace.Map.Landmarks:FindFirstChild("Stronghold")
            if stronghold then
                local functionalFolder = stronghold:FindFirstChild("Functional", true)
                if functionalFolder then
                    local lootZones = functionalFolder:FindFirstChild("LootZones")
                    if lootZones and lootZones:GetChildren()[4] then
                        local finalZone = lootZones:GetChildren()[4]:FindFirstChild("Zone")
                        if finalZone then
                            rootPart.CFrame = finalZone.CFrame + Vector3.new(0, 5, 0)
                            task.wait(1)
                        end
                    end
                end
            end
            
            -- Open the diamond chest
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local openChestRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestOpenItemChest")
            openChestRemote:FireServer(diamondChest)
            
            AutoStrongholdControl.InProgress = false
            AutoStrongholdControl.Enabled = false
            if AutoStrongholdControl.Connection then
                AutoStrongholdControl.Connection:Disconnect()
                AutoStrongholdControl.Connection = nil
            end
            return
            end -- Close the isOpened check
        end
        
        -- Case 2: Check if event is ready to start (timer = 00s)
        local stronghold = workspace.Map.Landmarks:FindFirstChild("Stronghold")
        if not stronghold then return end
        
        local functionalFolder = stronghold:FindFirstChild("Functional", true)
        if not functionalFolder then return end
        
        local signTextLabel = functionalFolder:FindFirstChild("Sign", true)
            and functionalFolder.Sign:FindFirstChild("SurfaceGui", true)
            and functionalFolder.Sign.SurfaceGui:FindFirstChild("Frame", true)
            and functionalFolder.Sign.SurfaceGui.Frame:FindFirstChild("Body", true)
        
        if not signTextLabel then return end
        
        if signTextLabel.ContentText == "00s" then
            AutoStrongholdControl.InProgress = true
            
            local door = functionalFolder.EntryDoors:FindFirstChild("DoorLeft")
            if not door or not door.PrimaryPart then 
                AutoStrongholdControl.InProgress = false
                return 
            end
            
            rootPart.CFrame = door.PrimaryPart.CFrame * CFrame.new(0, 0, -3)
            task.wait(1)
            
            local prompt = door.Main.ProximityAttachment:FindFirstChild("ProximityInteraction")
            if prompt and prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
                prompt:InputHoldBegin()
                task.wait(0.1)
                prompt:InputHoldEnd()
                
                task.wait(1)
                local triggerZone = functionalFolder.EnemyWaves12.Wave1:FindFirstChild("TriggerZone")
                if triggerZone then
                    rootPart.CFrame = triggerZone.CFrame
                end
                
                task.wait(1)
                local lootZones = functionalFolder:FindFirstChild("LootZones")
                if lootZones and lootZones:GetChildren()[4] then
                    local finalZone = lootZones:GetChildren()[4]:FindFirstChild("Zone")
                    if finalZone then
                        rootPart.CFrame = finalZone.CFrame + Vector3.new(0, 5, 0)
                    end
                end
                
                spawn(function()
                    -- Keep checking until the event completes (diamond chest unlocked)
                    local diamondChest = workspace.Items:FindFirstChild("Stronghold Diamond Chest")
                    if diamondChest then
                        -- Keep checking every 2 seconds until chest is unlocked
                        repeat 
                            task.wait(2) 
                            diamondChest = workspace.Items:FindFirstChild("Stronghold Diamond Chest")
                        until not diamondChest or diamondChest:GetAttribute("Locked") == false or diamondChest:GetAttribute("Locked") == nil
                        
                        -- Reset InProgress flag so the system can detect the unlocked chest
                        AutoStrongholdControl.InProgress = false
                        
                        -- Small delay to ensure the system picks up the unlocked chest
                        task.wait(1)
                    else
                        AutoStrongholdControl.InProgress = false
                    end
                end)
            else
                AutoStrongholdControl.InProgress = false
            end
        end
    end)
end

MiscTab:CreateToggle({
    Name = "🏰 Auto Stronghold",
    CurrentValue = false,
    Flag = "Misc_AutoStronghold",
    Callback = function(v)
        AutoStrongholdControl.Enabled = v
        
        if v then
            AutoStrongholdControl.Connection = RunService.Heartbeat:Connect(function()
                if AutoStrongholdControl.Enabled then
                    AutoStronghold()
                end
            end)
        else
            if AutoStrongholdControl.Connection then
                AutoStrongholdControl.Connection:Disconnect()
                AutoStrongholdControl.Connection = nil
            end
            AutoStrongholdControl.InProgress = false
        end
    end
})

-- Fishing Always Correct Control
local FishingControl = {
    Enabled = false,
    Connection = nil,
    FishingFrame = nil
}

-- Function to make fishing minigame easy
local function makeFishingEasy()
    if not (FishingControl.FishingFrame and FishingControl.FishingFrame.Visible) then
        return
    end
    
    -- Find the success area in the fishing minigame
    local successArea = FishingControl.FishingFrame.TimingBar:FindFirstChild("SuccessArea")
    if successArea then
        -- Make the green success zone cover the entire bar (100%)
        successArea.Size = UDim2.new(1, 0, 1, 0)
        successArea.Position = UDim2.new(0, 0, 0, 0)
    end
end

-- Function to find the fishing frame
local function findFishingFrame()
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local interface = playerGui:FindFirstChild("Interface")
        if interface then
            return interface:FindFirstChild("FishingCatchFrame")
        end
    end
    return nil
end

-- Function to start fishing assistance
local function startFishingAssist()
    if FishingControl.Enabled then
        return
    end
    
    FishingControl.Enabled = true
    
    -- Wait for fishing frame to exist
    task.spawn(function()
        repeat task.wait(0.5) until findFishingFrame()
        FishingControl.FishingFrame = findFishingFrame()
        
        -- Listen for when the fishing minigame becomes visible
        FishingControl.FishingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
            if FishingControl.FishingFrame.Visible and FishingControl.Enabled then
                -- Start the assistance when minigame is visible
                if not FishingControl.Connection then
                    FishingControl.Connection = RunService.RenderStepped:Connect(makeFishingEasy)
                end
            else
                -- Stop assistance when minigame ends
                if FishingControl.Connection then
                    FishingControl.Connection:Disconnect()
                    FishingControl.Connection = nil
                end
            end
        end)
    end)
end

-- Function to stop fishing assistance
local function stopFishingAssist()
    FishingControl.Enabled = false
    if FishingControl.Connection then
        FishingControl.Connection:Disconnect()
        FishingControl.Connection = nil
    end
end

MiscTab:CreateToggle({
    Name = "🎣 Fishing Always Correct",
    CurrentValue = false,
    Flag = "Misc_FishingAlwaysCorrect",
    Callback = function(v)
        if v then
            startFishingAssist()
        else
            stopFishingAssist()
        end
    end
})

-- Player GUI Controls
PlayerTab:CreateToggle({
    Name = "Enable Speed",
    CurrentValue = false,
    Flag = "Player_EnableSpeed",
    Callback = function(v)
        PlayerControl.SpeedEnabled = v
        UpdateAll()
    end
})

PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = PlayerControl.SpeedValue,
    Flag = "Player_SpeedValue",
    Callback = function(val)
        PlayerControl.SpeedValue = val
        if PlayerControl.SpeedEnabled then UpdateAll() end
    end
})

PlayerTab:CreateToggle({
    Name = "Enable Jump",
    CurrentValue = false,
    Flag = "Player_EnableJump",
    Callback = function(v)
        PlayerControl.JumpEnabled = v
        UpdateAll()
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {25, 150},
    Increment = 1,
    Suffix = " jump",
    CurrentValue = PlayerControl.JumpValue,
    Flag = "Player_JumpValue",
    Callback = function(val)
        PlayerControl.JumpValue = val
        if PlayerControl.JumpEnabled then UpdateAll() end
    end
})

PlayerTab:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Flag = "Player_FlyMode",
    Callback = function(v)
        PlayerControl.FlyEnabled = v
        if not v then
            -- Reset velocity when disabling
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = PlayerControl.FlySpeed,
    Flag = "Player_FlySpeed",
    Callback = function(val)
        PlayerControl.FlySpeed = val
    end
})

-- Important Places Teleportation
PlayerTab:CreateLabel("🗺️ Important Places Teleportation:")
PlayerTab:CreateLabel("If teleportation doesn't work, try revealing the map first as some locations may not be loaded yet.")

PlayerTab:CreateDropdown({
    Name = "Teleport to Important Places",
    Options = {"Campfire", "Safe Place Underground", "Volcano Sacrifice", "Stronghold", "Fairy House", "Tool Workshop"},
    CurrentOption = {"Campfire"},
    Flag = "Player_TeleportLocation",
    Callback = function(options)
        local player = game.Players.LocalPlayer
        if not (player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
            return
        end
        
        local selectedLocation = options[1]
        local destination = nil
        local locationFound = false
        
        if selectedLocation == "Campfire" then
            local campfire = workspace.Map and workspace.Map.Campground and workspace.Map.Campground.MainFire
            if campfire and campfire:FindFirstChild("Center") then
                destination = campfire.Center.Position + Vector3.new(0, 5, 0)
                locationFound = true
            end
            
        elseif selectedLocation == "Safe Place Underground" then
            local baseplate = workspace.Map and workspace.Map:FindFirstChild("Baseplate")
            if baseplate then
                destination = baseplate.Position + Vector3.new(0, 3, 0)
                locationFound = true
            end
            
        elseif selectedLocation == "Volcano Sacrifice" then
            local volcano = workspace.Map and workspace.Map.Landmarks and workspace.Map.Landmarks:FindFirstChild("Volcano")
            if volcano and volcano:FindFirstChild("Functional") and volcano.Functional:FindFirstChild("Sacrifice") 
               and volcano.Functional.Sacrifice:FindFirstChild("Fuse") and volcano.Functional.Sacrifice.Fuse:FindFirstChild("Wedge") then
                destination = volcano.Functional.Sacrifice.Fuse.Wedge.Position + Vector3.new(0, 5, 0)
                locationFound = true
            end
            
        elseif selectedLocation == "Stronghold" then
            local stronghold = workspace.Map and workspace.Map.Landmarks and workspace.Map.Landmarks:FindFirstChild("Stronghold")
            if stronghold and stronghold:FindFirstChild("Functional") and stronghold.Functional:FindFirstChild("Sign") then
                destination = stronghold.Functional.Sign.Position + Vector3.new(0, 5, 0)
                locationFound = true
            end
            
        elseif selectedLocation == "Fairy House" then
            local fairyHouse = workspace.Map and workspace.Map.Landmarks and workspace.Map.Landmarks:FindFirstChild("Fairy House")
            if fairyHouse and fairyHouse:FindFirstChild("Fairy") and fairyHouse.Fairy:FindFirstChild("HumanoidRootPart") then
                destination = fairyHouse.Fairy.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
                locationFound = true
            end
            
        elseif selectedLocation == "Tool Workshop" then
            local toolWorkshop = workspace.Map and workspace.Map.Landmarks and workspace.Map.Landmarks:FindFirstChild("ToolWorkshop")
            if toolWorkshop and toolWorkshop:FindFirstChild("Main") then
                destination = toolWorkshop.Main.Position + Vector3.new(0, 5, 0)
                locationFound = true
            end
        end
        
        if locationFound and destination then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(destination)
        else
            ApocLibrary:Notify({
                Title = "Location Not Found",
                Content = "The location '" .. selectedLocation .. "' has not loaded yet. Try revealing the map first!",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
    end
})

-- Auto Trap Follow Player
PlayerTab:CreateLabel("🪤 Auto Trap Follow Player:")
PlayerTab:CreateLabel("Select a target player and enable to make all bear traps follow them.")

local TrapTargetDropdown
TrapTargetDropdown = PlayerTab:CreateDropdown({
    Name = "Target Player",
    Options = GetPlayerNames(),
    CurrentOption = {"None"},
    Flag = "Trap_TargetPlayer",
    Callback = function(options)
        TrapControl.TargetPlayer = options[1]
    end
})

PlayerTab:CreateToggle({
    Name = "Enable Auto Trap",
    CurrentValue = false,
    Flag = "Trap_AutoTrapEnabled",
    Callback = function(v)
        TrapControl.AutoTrapEnabled = v
        
        if v then
        else
            CleanupTraps()
        end
    end
})

PlayerTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local newOptions = GetPlayerNames()
        TrapTargetDropdown:Refresh(newOptions)
    end
})

-- Combat GUI Controls
CombatTab:CreateToggle({
    Name = "Enable Auto Attack",
    CurrentValue = false,
    Flag = "Combat_KillAura",
    Callback = function(v)
        CombatControl.KillAuraEnabled = v
        
        if v then
        else
        end
    end
})

CombatTab:CreateDropdown({
    Name = "Weapon Type",
    Options = WeaponTypes,
    CurrentOption = {WeaponTypes[1]},
    Flag = "Combat_WeaponType",
    Callback = function(options)
        CombatControl.WeaponType = options[1]
    end
})

CombatTab:CreateToggle({
    Name = "Ultra Kill",
    CurrentValue = false,
    Flag = "Combat_UltraKill",
    Callback = function(v)
        CombatControl.UltraKillEnabled = v
    end
})

CombatTab:CreateSlider({
    Name = "Attack Range",
    Range = {5, 500}, -- Increased max range to 1000 as requested
    Increment = 10,
    Suffix = " meters",
    CurrentValue = CombatControl.AuraRange,
    Flag = "Combat_AuraRange",
    Callback = function(val)
        CombatControl.AuraRange = val
    end
})

-- Firearm Options Section
local FirearmSection = CombatTab:CreateSection("Firearm Options")

CombatTab:CreateToggle({
    Name = "Instant Reload",
    CurrentValue = false,
    Flag = "Combat_InstantReload",
    Callback = function(v)
        CombatControl.InstantReloadEnabled = v
        if v then
            initializeFirearmModification()
        else
            updateAllFirearms() -- Restore original values when disabled
        end
    end
})

CombatTab:CreateSlider({
    Name = "Reload Time",
    Range = {0, 1.5},
    Increment = 0.1,
    Suffix = " sec",
    CurrentValue = CombatControl.ReloadTime,
    Flag = "Combat_ReloadTime",
    Callback = function(val)
        CombatControl.ReloadTime = val
        if CombatControl.InstantReloadEnabled then
            updateAllFirearms()
        end
    end
})

CombatTab:CreateToggle({
    Name = "Firerate",
    CurrentValue = false,
    Flag = "Combat_FireRate",
    Callback = function(v)
        CombatControl.FireRateEnabled = v
        if v then
            initializeFirearmModification()
        else
            updateAllFirearms() -- Restore original values when disabled
        end
    end
})

CombatTab:CreateSlider({
    Name = "Firerate Speed",
    Range = {0.05, 0.5},
    Increment = 0.01,
    Suffix = " sec",
    CurrentValue = CombatControl.FireRate,
    Flag = "Combat_FireRateSpeed",
    Callback = function(val)
        CombatControl.FireRate = val
        if CombatControl.FireRateEnabled then
            updateAllFirearms()
        end
    end
})

-- Trees GUI Controls
TreesTab:CreateToggle({
    Name = "Enable Auto Tree Chopping",
    CurrentValue = false,
    Flag = "Trees_ChoppingAura",
    Callback = function(v)
        TreesControl.ChoppingAuraEnabled = v
        
        if v then
        else
            -- Clear current targets when disabling
            TreesControl.CurrentTargets = {}
            -- Clean up all billboard GUIs when disabling
            for tree, billboard in pairs(TreesControl.ActiveBillboards) do
                if billboard and billboard.Parent then
                    billboard:Destroy()
                end
            end
            TreesControl.ActiveBillboards = {}
        end
    end
})

TreesTab:CreateToggle({
    Name = "Ultra Tree Chopping",
    CurrentValue = false,
    Flag = "Trees_UltraChopping",
    Callback = function(v)
        TreesControl.UltraChoppingEnabled = v
    end
})

TreesTab:CreateSlider({
    Name = "Chopping Range",
    Range = {5, 500},
    Increment = 10,
    Suffix = " meters",
    CurrentValue = TreesControl.ChoppingRange,
    Flag = "Trees_ChoppingRange",
    Callback = function(val)
        TreesControl.ChoppingRange = val
    end
})

TreesTab:CreateDropdown({
    Name = "Target Tree Type",
    Options = CreateTranslatedOptions(TreeTypes),
    CurrentOption = {GetDisplayText(TreeTypes[1])},
    Flag = "Trees_TargetType",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                TreesControl.TargetTreeType = english
                break
            end
        end
    end
})

TreesTab:CreateSlider({
    Name = "Ultra Chop Tree Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = " trees",
    CurrentValue = TreesControl.UltraChopCount,
    Flag = "Trees_UltraCount",
    Callback = function(val)
        TreesControl.UltraChopCount = val
    end
})

-- Campfire GUI Controls

CampfireTab:CreateDropdown({
    Name = "Transport To:",
    Options = CreateTranslatedOptions(CampfireDestinations),
    CurrentOption = {GetDisplayText(CampfireDestinations[1])},
    Flag = "Campfire_Destination",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                CampfireControl.TeleportDestination = english
                break
            end
        end
    end
})

CampfireTab:CreateSlider({
    Name = "Teleport Height",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 35,
    Flag = "Campfire_TeleportHeight",
    Callback = function(v)
        CampfireControl.TeleportHeight = v
    end
})

CampfireTab:CreateToggle({
    Name = "Smart Auto Refill (By %)",
    CurrentValue = false,
    Flag = "Campfire_AutoRefill",
    Callback = function(v)
        CampfireControl.AutoRefillEnabled = v
        -- Disable continuous refill if smart refill is enabled
        if v and CampfireControl.ContinuousRefillEnabled then
            CampfireControl.ContinuousRefillEnabled = false
        end
        -- Freeze/unfreeze camera based on teleporter state
        if v then
            FreezeCamera()
            -- Save current player position when refill is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                CampfireControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            UnfreezeCamera()
            CampfireControl.SavedPlayerPosition = nil
        end
    end
})

CampfireTab:CreateToggle({
    Name = "Continuous Refill (Always)",
    CurrentValue = false,
    Flag = "Campfire_ContinuousRefill",
    Callback = function(v)
        CampfireControl.ContinuousRefillEnabled = v
        -- Enable auto refill if continuous is enabled, disable smart mode
        if v then
            CampfireControl.AutoRefillEnabled = true
            FreezeCamera()
            -- Save current player position when continuous refill is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                CampfireControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            CampfireControl.AutoRefillEnabled = false
            UnfreezeCamera()
            CampfireControl.SavedPlayerPosition = nil
        end
    end
})

CampfireTab:CreateSlider({
    Name = "Refill Wait Time",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = " seconds",
    CurrentValue = CampfireControl.RefillCheckCooldown,
    Flag = "Campfire_RefillCooldown",
    Callback = function(val)
        CampfireControl.RefillCheckCooldown = val
    end
})

CampfireTab:CreateSlider({
    Name = "Refill Percentage",
    Range = {5, 95},
    Increment = 5,
    Suffix = "%",
    CurrentValue = CampfireControl.RefillPercentage,
    Flag = "Campfire_RefillPercentage",
    Callback = function(val)
        CampfireControl.RefillPercentage = val
    end
})

CampfireTab:CreateDropdown({
    Name = "Refill Item Type",
    Options = CreateTranslatedOptions(RefillItemTypes),
    CurrentOption = {GetDisplayText(RefillItemTypes[1])},
    Flag = "Campfire_RefillType",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                CampfireControl.RefillItemType = english
                break
            end
        end
    end
})

CampfireTab:CreateLabel("🚀 Uses advanced teleportation system")
CampfireTab:CreateLabel("🎯 35 meters up, 5 meters back for perfect drop")


-- Crafting GUI Controls

CraftingTab:CreateDropdown({
    Name = "Transport To:",
    Options = CreateTranslatedOptions(CraftingDestinations),
    CurrentOption = {GetDisplayText(CraftingDestinations[1])},
    Flag = "Crafting_Destination",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                CraftingControl.TeleportDestination = english
                break
            end
        end
    end
})

CraftingTab:CreateSlider({
    Name = "Teleport Height",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 35,
    Flag = "Crafting_TeleportHeight",
    Callback = function(v)
        CraftingControl.TeleportHeight = v
    end
})

CraftingTab:CreateSlider({
    Name = "Teleport Cooldown",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = " seconds",
    CurrentValue = 15,
    Flag = "Crafting_TeleportCooldown",
    Callback = function(v)
        CraftingControl.TeleportCooldown = v
        print("🔄 Teleport cooldown updated to: " .. v .. " seconds")
    end
})

CraftingTab:CreateParagraph({
    Title = "💡 Tip:",
    Content = "Use Transport To: Player if you encounter issues with the scrapper"
})


CraftingTab:CreateToggle({
    Name = "🔩 Produce Scrap",
    CurrentValue = false,
    Flag = "Crafting_ProduceScrap",
    Callback = function(v)
        CraftingControl.ProduceScrapEnabled = v
        -- Disable other production modes if scrap is enabled
        if v then
            CraftingControl.ProduceWoodEnabled = false
            CraftingControl.ProduceCultistGemEnabled = false
            FreezeCamera()
            -- Save current player position when scrap production is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                CraftingControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            UnfreezeCamera()
            CraftingControl.TeleportedItems = {}
            CraftingControl.SavedPlayerPosition = nil
        end
    end
})

CraftingTab:CreateDropdown({
    Name = "Scrap Item Type",
    Options = ScrapItemTypes,
    CurrentOption = {ScrapItemTypes[1]},
    Flag = "Crafting_ScrapType",
    Callback = function(options)
        CraftingControl.ScrapItemType = options[1]
    end
})

CraftingTab:CreateToggle({
    Name = "🪵 Produce Wood (⚠️ Use only one option)",
    CurrentValue = false,
    Flag = "Crafting_ProduceWood",
    Callback = function(v)
        CraftingControl.ProduceWoodEnabled = v
        -- Disable other production modes if wood is enabled
        if v then
            CraftingControl.ProduceScrapEnabled = false
            CraftingControl.ProduceCultistGemEnabled = false
            FreezeCamera()
            -- Save current player position when wood production is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                CraftingControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            UnfreezeCamera()
            CraftingControl.TeleportedItems = {}
            CraftingControl.SavedPlayerPosition = nil
        end
    end
})

CraftingTab:CreateDropdown({
    Name = "Wood Item Type",
    Options = WoodItemTypes,
    CurrentOption = {WoodItemTypes[1]},
    Flag = "Crafting_WoodType",
    Callback = function(options)
        CraftingControl.WoodItemType = options[1]
    end
})

CraftingTab:CreateToggle({
    Name = "💎 Produce Cultist Gem (⚠️ Use only one option)",
    CurrentValue = false,
    Flag = "Crafting_ProduceCultistGem",
    Callback = function(v)
        CraftingControl.ProduceCultistGemEnabled = v
        -- Disable other production modes if cultist gem is enabled
        if v then
            CraftingControl.ProduceScrapEnabled = false
            CraftingControl.ProduceWoodEnabled = false
            FreezeCamera()
            -- Save current player position when cultist gem production is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                CraftingControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            UnfreezeCamera()
            CraftingControl.TeleportedItems = {}
            CraftingControl.SavedPlayerPosition = nil
        end
    end
})

CraftingTab:CreateDropdown({
    Name = "Cultist Gem Item Type",
    Options = CultistGemItemTypes,
    CurrentOption = {CultistGemItemTypes[1]},
    Flag = "Crafting_CultistGemType",
    Callback = function(options)
        CraftingControl.CultistGemItemType = options[1]
    end
})



-- Food GUI Controls
FoodTab:CreateToggle({
    Name = "Enable Food Transporter",
    CurrentValue = false,
    Flag = "Food_TeleportEnabled",
    Callback = function(v)
        FoodControl.TeleportFoodEnabled = v
        -- Freeze/unfreeze camera based on teleporter state
        if v then
            FreezeCamera()
            -- Save current player position when teleporter is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                FoodControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            UnfreezeCamera()
            FoodControl.TeleportedItems = {}
            FoodControl.SavedPlayerPosition = nil
        end
    end
})

FoodTab:CreateDropdown({
    Name = "Transport To:",
    Options = CreateTranslatedOptions(FoodDestinations),
    CurrentOption = {GetDisplayText(FoodDestinations[1])},
    Flag = "Food_Destination",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                FoodControl.TeleportDestination = english
                break
            end
        end
    end
})

FoodTab:CreateSlider({
    Name = "Teleport Height",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 35,
    Flag = "Food_TeleportHeight",
    Callback = function(v)
        FoodControl.TeleportHeight = v
    end
})

FoodTab:CreateSlider({
    Name = "Transport Wait Time",
    Range = {0.5, 5},
    Increment = 0.5,
    Suffix = " seconds",
    CurrentValue = FoodControl.TeleportCooldown,
    Flag = "Food_TeleportCooldown",
    Callback = function(val)
        FoodControl.TeleportCooldown = val
    end
})

FoodTab:CreateDropdown({
    Name = "Food Type",
    Options = CreateTranslatedOptions(FoodItemTypes),
    CurrentOption = {GetDisplayText(FoodItemTypes[1])},
    Flag = "Food_ItemType",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                FoodControl.FoodItemType = english
                break
            end
        end
    end
})

-- Animal Pelts GUI Controls
AnimalPeltsTab:CreateToggle({
    Name = "Enable Animal Pelts Transporter",
    CurrentValue = false,
    Flag = "AnimalPelts_TeleportEnabled",
    Callback = function(v)
        AnimalPeltsControl.TeleportPeltsEnabled = v
        -- Freeze/unfreeze camera based on teleporter state
        if v then
            FreezeCamera()
            -- Save current player position when teleporter is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                AnimalPeltsControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            UnfreezeCamera()
            AnimalPeltsControl.TeleportedItems = {}
            AnimalPeltsControl.SavedPlayerPosition = nil
        end
    end
})

AnimalPeltsTab:CreateDropdown({
    Name = "Transport To:",
    Options = CreateTranslatedOptions(PeltDestinations),
    CurrentOption = {GetDisplayText(PeltDestinations[1])},
    Flag = "AnimalPelts_Destination",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                AnimalPeltsControl.TeleportDestination = english
                break
            end
        end
    end
})

AnimalPeltsTab:CreateSlider({
    Name = "Teleport Height",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 35,
    Flag = "AnimalPelts_TeleportHeight",
    Callback = function(v)
        AnimalPeltsControl.TeleportHeight = v
    end
})

AnimalPeltsTab:CreateSlider({
    Name = "Transport Wait Time",
    Range = {0.5, 5},
    Increment = 0.5,
    Suffix = " seconds",
    CurrentValue = AnimalPeltsControl.TeleportCooldown,
    Flag = "AnimalPelts_TeleportCooldown",
    Callback = function(val)
        AnimalPeltsControl.TeleportCooldown = val
    end
})

AnimalPeltsTab:CreateDropdown({
    Name = "Animal Pelt Type",
    Options = CreateTranslatedOptions(AnimalPeltTypes),
    CurrentOption = {GetDisplayText(AnimalPeltTypes[1])},
    Flag = "AnimalPelts_ItemType",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                AnimalPeltsControl.PeltItemType = english
                break
            end
        end
    end
})

-- Healing GUI Controls
HealingTab:CreateToggle({
    Name = "Enable Healing Items Transporter",
    CurrentValue = false,
    Flag = "Healing_TeleportEnabled",
    Callback = function(v)
        HealingControl.TeleportHealingEnabled = v
        -- Freeze/unfreeze camera based on teleporter state
        if v then
            FreezeCamera()
            -- Save current player position when teleporter is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                HealingControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            UnfreezeCamera()
            HealingControl.TeleportedItems = {}
            HealingControl.SavedPlayerPosition = nil
        end
    end
})

HealingTab:CreateDropdown({
    Name = "Transport To:",
    Options = CreateTranslatedOptions(HealingDestinations),
    CurrentOption = {GetDisplayText(HealingDestinations[1])},
    Flag = "Healing_Destination",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                HealingControl.TeleportDestination = english
                break
            end
        end
    end
})

HealingTab:CreateSlider({
    Name = "Teleport Height",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 35,
    Flag = "Healing_TeleportHeight",
    Callback = function(v)
        HealingControl.TeleportHeight = v
    end
})

HealingTab:CreateSlider({
    Name = "Transport Wait Time",
    Range = {0.5, 5},
    Increment = 0.5,
    Suffix = " seconds",
    CurrentValue = HealingControl.TeleportCooldown,
    Flag = "Healing_TeleportCooldown",
    Callback = function(val)
        HealingControl.TeleportCooldown = val
    end
})

HealingTab:CreateDropdown({
    Name = "Healing Item Type",
    Options = CreateTranslatedOptions(HealingItemTypes),
    CurrentOption = {GetDisplayText(HealingItemTypes[1])},
    Flag = "Healing_ItemType",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                HealingControl.HealingItemType = english
                break
            end
        end
    end
})

-- Auto Safe Place Section
local AutoSafePlaceControl = {
    IsActive = false,
    HealthThreshold = 25,
    TeleportLocation = "MainFire",
    HealthCheckThread = nil
}

local function teleportToSafePlace()
    local player = game.Players.LocalPlayer
    if not (player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
        return
    end
    
    local destination
    if AutoSafePlaceControl.TeleportLocation == "MainFire" then
        local campfire = workspace.Map and workspace.Map.Campground and workspace.Map.Campground.MainFire
        if campfire and campfire:FindFirstChild("Center") then
            destination = campfire.Center.Position + Vector3.new(0, 5, 0)
        end
    elseif AutoSafePlaceControl.TeleportLocation == "Underground" then
        local baseplate = workspace.Map and workspace.Map:FindFirstChild("Baseplate")
        if baseplate then
            destination = baseplate.Position + Vector3.new(0, 3, 0)
        end
    end
    
    if destination then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(destination)
    end
end

local function startHealthMonitoring()
    if AutoSafePlaceControl.HealthCheckThread then
        return
    end
    
    AutoSafePlaceControl.HealthCheckThread = task.spawn(function()
        while AutoSafePlaceControl.IsActive do
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health <= AutoSafePlaceControl.HealthThreshold then
                    teleportToSafePlace()
                    task.wait(2) -- Wait 2 seconds before checking again to prevent spam teleporting
                end
            end
            task.wait(0.5) -- Check health every 0.5 seconds
        end
    end)
end

local function stopHealthMonitoring()
    if AutoSafePlaceControl.HealthCheckThread then
        task.cancel(AutoSafePlaceControl.HealthCheckThread)
        AutoSafePlaceControl.HealthCheckThread = nil
    end
end

HealingTab:CreateToggle({
    Name = "Auto Safe Place",
    CurrentValue = false,
    Flag = "Healing_AutoSafePlace",
    Callback = function(v)
        AutoSafePlaceControl.IsActive = v
        if v then
            startHealthMonitoring()
        else
            stopHealthMonitoring()
        end
    end
})

HealingTab:CreateSlider({
    Name = "Health Threshold",
    Range = {1, 100},
    Increment = 1,
    Suffix = " HP",
    CurrentValue = AutoSafePlaceControl.HealthThreshold,
    Flag = "Healing_HealthThreshold",
    Callback = function(val)
        AutoSafePlaceControl.HealthThreshold = val
    end
})

HealingTab:CreateDropdown({
    Name = "Teleport Location",
    Options = {"MainFire", "Underground"},
    CurrentOption = {"MainFire"},
    Flag = "Healing_TeleportLocation",
    Callback = function(options)
        AutoSafePlaceControl.TeleportLocation = options[1]
    end
})

-- ========== AMMO TELEPORTER CONTROLS ==========

AmmoTab:CreateToggle({
    Name = "🔫 Enable Ammo Transporter",
    CurrentValue = false,
    Flag = "Ammo_EnableTeleport",
    Callback = function(v)
        AmmoControl.TeleportAmmoEnabled = v
        -- Freeze/unfreeze camera based on teleporter state
        if v then
            FreezeCamera()
            -- Save current player position when teleporter is enabled
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                AmmoControl.SavedPlayerPosition = player.Character.HumanoidRootPart.CFrame
            end
        else
            UnfreezeCamera()
            AmmoControl.TeleportedItems = {}
            AmmoControl.SavedPlayerPosition = nil
        end
    end
})

AmmoTab:CreateSlider({
    Name = "Teleport Height",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 35,
    Flag = "Ammo_TeleportHeight",
    Callback = function(v)
        AmmoControl.TeleportHeight = v
    end
})

AmmoTab:CreateSlider({
    Name = "Transport Wait Time",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = " seconds",
    CurrentValue = AmmoControl.TeleportCooldown,
    Flag = "Ammo_TeleportCooldown",
    Callback = function(val)
        AmmoControl.TeleportCooldown = val
    end
})

AmmoTab:CreateDropdown({
    Name = "Ammo Type",
    Options = CreateTranslatedOptions(AmmoItemTypes),
    CurrentOption = {GetDisplayText(AmmoItemTypes[1])},
    Flag = "Ammo_ItemType",
    Callback = function(options)
        -- Convert display selection back to English for code logic
        local selectedDisplay = options[1]
        for english, display in pairs(DisplayTranslations) do
            if display == selectedDisplay then
                AmmoControl.AmmoItemType = english
                break
            end
        end
    end
})

-- Create dropdowns for each chest type
for _, chestType in pairs(ChestTypes) do
    ChestDropdowns[chestType] = ChestsTab:CreateDropdown({
        Name = chestType,
        Options = {"None"},
        CurrentOption = {"None"},
        Flag = "ChestSelector_" .. chestType:gsub(" ", "_"), -- Create unique flag for each dropdown
        Callback = function(options)
            TeleportToSelectedChestByType(chestType, options[1])
        end
    })
end

-- Manual refresh button for all chest dropdowns
ChestsTab:CreateButton({
    Name = "🔄 Update All Chest Lists",
    Callback = function()
        UpdateAllChestDropdowns()
    end
})

-- ========== ESP GUI CONTROLS (ELEGANT & MODERN) ==========

-- Master ESP Toggle
ESPTab:CreateToggle({
    Name = "🔍 Enable ESP",
    CurrentValue = false,
    Flag = "ESP_Master",
    Callback = function(Value)
        ESPControl.Enabled = Value
        if not Value then
            ClearAllESP()
        else
            UpdateAllESP()
        end
    end
})

-- Individual Color Pickers for Each Category
ESPTab:CreateColorPicker({
    Name = "🍖 Food Color",
    Color = ESPControl.Colors.Food,
    Flag = "ESP_FoodColor",
    Callback = function(Value)
        ESPControl.Colors.Food = Value
        -- Update existing food ESP colors
        for _, espData in pairs(ESPControl.ESPObjects) do
            if espData.Billboard and espData.Billboard:FindFirstChild("Frame") and string.find(espData.Billboard.Frame.TextLabel.Text, "🍖") then
                local frame = espData.Billboard.Frame
                if frame:FindFirstChild("UIStroke") then
                    frame.UIStroke.Color = Value
                end
                if frame:FindFirstChild("TextLabel") then
                    frame.TextLabel.TextColor3 = Value
                end
            end
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "🦊 Animal Pelts Color",
    Color = ESPControl.Colors.AnimalPelts,
    Flag = "ESP_AnimalPeltsColor",
    Callback = function(Value)
        ESPControl.Colors.AnimalPelts = Value
        -- Update existing animal pelts ESP colors
        for _, espData in pairs(ESPControl.ESPObjects) do
            if espData.Billboard and espData.Billboard:FindFirstChild("Frame") and string.find(espData.Billboard.Frame.TextLabel.Text, "🦊") then
                local frame = espData.Billboard.Frame
                if frame:FindFirstChild("UIStroke") then
                    frame.UIStroke.Color = Value
                end
                if frame:FindFirstChild("TextLabel") then
                    frame.TextLabel.TextColor3 = Value
                end
            end
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "💊 Healing Color",
    Color = ESPControl.Colors.Healing,
    Flag = "ESP_HealingColor",
    Callback = function(Value)
        ESPControl.Colors.Healing = Value
        -- Update existing healing ESP colors
        for _, espData in pairs(ESPControl.ESPObjects) do
            if espData.Billboard and espData.Billboard:FindFirstChild("Frame") and string.find(espData.Billboard.Frame.TextLabel.Text, "💊") then
                local frame = espData.Billboard.Frame
                if frame:FindFirstChild("UIStroke") then
                    frame.UIStroke.Color = Value
                end
                if frame:FindFirstChild("TextLabel") then
                    frame.TextLabel.TextColor3 = Value
                end
            end
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "🔫 Ammo Color",
    Color = ESPControl.Colors.Ammo,
    Flag = "ESP_AmmoColor",
    Callback = function(Value)
        ESPControl.Colors.Ammo = Value
        -- Update existing ammo ESP colors
        for _, espData in pairs(ESPControl.ESPObjects) do
            if espData.Billboard and espData.Billboard:FindFirstChild("Frame") and string.find(espData.Billboard.Frame.TextLabel.Text, "🔫") then
                local frame = espData.Billboard.Frame
                if frame:FindFirstChild("UIStroke") then
                    frame.UIStroke.Color = Value
                end
                if frame:FindFirstChild("TextLabel") then
                    frame.TextLabel.TextColor3 = Value
                end
            end
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "👹 Entities Color",
    Color = ESPControl.Colors.Entities,
    Flag = "ESP_EntitiesColor",
    Callback = function(Value)
        ESPControl.Colors.Entities = Value
        -- Update existing entities ESP colors
        for _, espData in pairs(ESPControl.ESPObjects) do
            if espData.Billboard and espData.Billboard:FindFirstChild("Frame") and string.find(espData.Billboard.Frame.TextLabel.Text, "👹") then
                local frame = espData.Billboard.Frame
                if frame:FindFirstChild("UIStroke") then
                    frame.UIStroke.Color = Value
                end
                if frame:FindFirstChild("TextLabel") then
                    frame.TextLabel.TextColor3 = Value
                end
            end
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "📦 Chests Color",
    Color = ESPControl.Colors.Chests,
    Flag = "ESP_ChestsColor",
    Callback = function(Value)
        ESPControl.Colors.Chests = Value
        -- Update existing chests ESP colors
        for _, espData in pairs(ESPControl.ESPObjects) do
            if espData.Billboard and espData.Billboard:FindFirstChild("Frame") and string.find(espData.Billboard.Frame.TextLabel.Text, "📦") then
                local frame = espData.Billboard.Frame
                if frame:FindFirstChild("UIStroke") then
                    frame.UIStroke.Color = Value
                end
                if frame:FindFirstChild("TextLabel") then
                    frame.TextLabel.TextColor3 = Value
                end
            end
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "👤 Players Color",
    Color = ESPControl.Colors.Players,
    Flag = "ESP_PlayersColor",
    Callback = function(Value)
        ESPControl.Colors.Players = Value
        -- Update existing players ESP colors
        for _, espData in pairs(ESPControl.ESPObjects) do
            if espData.Billboard and espData.Billboard:FindFirstChild("Frame") and string.find(espData.Billboard.Frame.TextLabel.Text, "👤") then
                local frame = espData.Billboard.Frame
                if frame:FindFirstChild("UIStroke") then
                    frame.UIStroke.Color = Value
                end
                if frame:FindFirstChild("TextLabel") then
                    frame.TextLabel.TextColor3 = Value
                end
            end
        end
    end
})

-- Category Toggles
ESPTab:CreateToggle({
    Name = "🍖 Food",
    CurrentValue = false,
    Flag = "ESP_Food",
    Callback = function(Value)
        ESPControl.Categories.Food = Value
        if ESPControl.Enabled then
            UpdateESPCategory("Food")
        end
    end
})

ESPTab:CreateToggle({
    Name = "🦊 Animal Pelts",
    CurrentValue = false,
    Flag = "ESP_AnimalPelts",
    Callback = function(Value)
        ESPControl.Categories.AnimalPelts = Value
        if ESPControl.Enabled then
            UpdateESPCategory("AnimalPelts")
        end
    end
})

ESPTab:CreateToggle({
    Name = "💊 Healing Items",
    CurrentValue = false,
    Flag = "ESP_Healing",
    Callback = function(Value)
        ESPControl.Categories.Healing = Value
        if ESPControl.Enabled then
            UpdateESPCategory("Healing")
        end
    end
})

ESPTab:CreateToggle({
    Name = "🔫 Ammo",
    CurrentValue = false,
    Flag = "ESP_Ammo",
    Callback = function(Value)
        ESPControl.Categories.Ammo = Value
        if ESPControl.Enabled then
            UpdateESPCategory("Ammo")
        end
    end
})

ESPTab:CreateToggle({
    Name = "👹 Entities",
    CurrentValue = false,
    Flag = "ESP_Entities",
    Callback = function(Value)
        ESPControl.Categories.Entities = Value
        if ESPControl.Enabled then
            UpdateESPCategory("Entities")
        end
    end
})

ESPTab:CreateToggle({
    Name = "📦 Chests",
    CurrentValue = false,
    Flag = "ESP_Chests",
    Callback = function(Value)
        ESPControl.Categories.Chests = Value
        if ESPControl.Enabled then
            UpdateESPCategory("Chests")
        end
    end
})

ESPTab:CreateToggle({
    Name = "👤 Players",
    CurrentValue = false,
    Flag = "ESP_Players",
    Callback = function(Value)
        ESPControl.Categories.Players = Value
        if ESPControl.Enabled then
            UpdateESPCategory("Players")
        end
    end
})

-- Utility Buttons
ESPTab:CreateButton({
    Name = "🔄 Update All ESP",
    Callback = function()
        if ESPControl.Enabled then
            ClearAllESP()
            UpdateAllESP()
        end
    end
})

ESPTab:CreateButton({
    Name = "🧹 Clear All ESP",
    Callback = function()
        ClearAllESP()
    end
})

-- ========== SKYBASE GUI CONTROLS ==========

SkybaseTab:CreateToggle({
    Name = "🏗️ Show Skybase Interface",
    CurrentValue = false,
    Flag = "Skybase_ShowGui",
    Callback = function(v)
        SkybaseControl.GuiEnabled = v
        if v then
            createSkybaseGui()
        else
            destroySkybaseGui()
        end
    end
})

SkybaseTab:CreateToggle({
    Name = "🍽️ Smart Auto Eating",
    CurrentValue = false,
    Flag = "Skybase_SmartAutoEat",
    Callback = function(v)
        SkybaseControl.SmartAutoEatEnabled = v
    end
})

SkybaseTab:CreateSlider({
    Name = "🎯 Hunger Threshold for Eating",
    Range = {20, 150},
    Increment = 5,
    Suffix = "points",
    CurrentValue = 50,
    Flag = "Skybase_HungerThreshold",
    Callback = function(v)
        SkybaseControl.HungerThreshold = v
    end
})

SkybaseTab:CreateToggle({
    Name = "⚡ Anti-AFK Protection",
    CurrentValue = false,
    Flag = "Skybase_AntiAfk",
    Callback = function(v)
        SkybaseControl.AntiAfkEnabled = v
        if v then
            SkybaseControl.LastJumpTime = tick()
            print("Anti-AFK Enabled - Will jump every 5 minutes")
        else
            print("Anti-AFK Disabled")
        end
    end
})

SkybaseTab:CreateLabel("To get maximum benefit, build a base in the sky")
SkybaseTab:CreateLabel("Then bring crop fields, try to get a large quantity and place them all on the base")
SkybaseTab:CreateLabel("🍎 Enable smart eating feature and set hunger to 100-150 as you prefer")
SkybaseTab:CreateLabel("Then go to your bed and sleep peacefully �")
SkybaseTab:CreateLabel("❤️ Happy gaming!")

-- Lost Children Controls
LostChildrenToggle = LostChildrenTab:CreateToggle({
    Name = "Enable Lost Children Rescue",
    CurrentValue = false,
    Flag = "RescueChildrenToggle",
    Callback = function(value)
        if value then
            startRescueProcess()
        else
            stopRescueProcess()
        end
    end
})

LostChildrenStatus = LostChildrenTab:CreateLabel("Status: Inactive")

LostChildrenTab:CreateLabel("ℹ️ How it works:")
LostChildrenTab:CreateLabel("• Make sure the fire is at maximum level")
LostChildrenTab:CreateLabel("• Make sure the sack has 4 empty spaces")
LostChildrenTab:CreateLabel("• Don't worry if it starts moving alone, it's searching for them")
LostChildrenTab:CreateLabel("• After collecting all children, it will return to your location")

-- Saplings GUI Toggle with Integrated Code
local SaplingsGUI = nil

-- Function to create the Saplings GUI directly
local function createSaplingsGUI()
    if SaplingsGUI then return end -- Already created
    
    -- Saplings GUI Variables and Configuration
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    -- Get a reference to the map's ground
    local groundPart = workspace:WaitForChild("Map"):WaitForChild("Ground")
    
    -- Configuration
    local CONFIG = {
        SHAPES = {"Square", "Circle", "Star"},
        DEFAULT_SHAPE = "Square",
        DEFAULT_SIZE = 40, 
        MIN_SIZE = 10,
        MAX_SIZE = 200,
        DEFAULT_SPACING = 8,
        MIN_SPACING = 2,
        MAX_SPACING = 20,
        DEFAULT_HEIGHT_OFFSET = 0.5,
        MIN_HEIGHT_OFFSET = 0,
        MAX_HEIGHT_OFFSET = 50,
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
    
    -- Script state variables
    local currentShape, currentSize, currentSpacing, currentHeightOffset = CONFIG.DEFAULT_SHAPE, CONFIG.DEFAULT_SIZE, CONFIG.DEFAULT_SPACING, CONFIG.DEFAULT_HEIGHT_OFFSET
    local shapePoints, highlightParts, isPlanting, guiElements = {}, {}, false, {}
    local previewDebounceThread, DEBOUNCE_TIME = nil, 0.2
    
    -- Core functions
    local function getCenterPoint() 
        local fireCenter = workspace.Map and workspace.Map.Campground and workspace.Map.Campground.MainFire and workspace.Map.Campground.MainFire.Center
        if fireCenter then 
            return fireCenter.Position 
        else 
            return player.Character and player.Character.PrimaryPart.Position or Vector3.zero 
        end 
    end
    
    local function clearHighlights() 
        -- Clear tracked highlights
        for _, part in ipairs(highlightParts) do 
            if part and part.Parent then
                part:Destroy() 
            end
        end
        highlightParts = {} 
        
        -- Also clear any remaining PlantingHighlight parts in workspace (safety measure)
        for _, part in pairs(workspace:GetChildren()) do
            if part.Name == "PlantingHighlight" then
                part:Destroy()
            end
        end
    end
    
    local function clearShape() 
        clearHighlights()
        shapePoints = {}
        isPlanting = false  -- Also stop any ongoing planting
        if guiElements.ProgressLabel then 
            guiElements.ProgressLabel.Text = "Progress: N/A" 
        end
        print("Shape cleared completely.") 
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
        
        -- Add to highlights array for proper tracking
        table.insert(highlightParts, highlight)
    end
    
    local function previewShape(forceUpdate)
        -- Check if any planting is in progress by looking at existing planted points
        local plantedCount = 0
        for _, pointData in ipairs(shapePoints) do
            if pointData.isPlanted then
                plantedCount = plantedCount + 1
            end
        end
        
        -- Clear highlights in these cases:
        -- 1. Force update (from sliders/dropdown) - always clear highlights but preserve planted points data
        -- 2. No planting in progress AND no planted points (safe to clear everything)
        if forceUpdate then
            -- For force updates (slider/dropdown changes), always clear highlights
            clearHighlights()
            if plantedCount == 0 then
                -- If no planting progress, clear everything
                shapePoints = {}
            else
                -- If there's planting progress, preserve shapePoints but clear highlights
                print("Force update: cleared highlights, preserving", plantedCount, "planted points")
            end
        elseif not isPlanting and plantedCount == 0 then
            clearShape()
        elseif isPlanting or plantedCount > 0 then
            print("Preview skipped - planting in progress or has progress:", plantedCount, "/", #shapePoints)
            return
        end
        
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
        
        -- If we didn't clear shapePoints (preserving planted progress), rebuild from scratch
        if forceUpdate and #shapePoints > 0 then
            -- Clear shapePoints and rebuild completely for force updates
            shapePoints = {}
        end
        
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
        button.TextSize = 10
        button.Parent = parent
        button.Active = true  -- Ensure button is active for click detection
        button.AutoButtonColor = false  -- We'll handle color changes manually
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        
        -- Add hover effect
        local originalColor = backgroundColor
        button.MouseEnter:Connect(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.new(
                math.min(1, originalColor.R + 0.1),
                math.min(1, originalColor.G + 0.1), 
                math.min(1, originalColor.B + 0.1)
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
    
    -- Main container with shadow effect (Mobile-optimized size)
    local shadowFrame = createRoundedFrame(screenGui, UDim2.new(0, 180, 0, 250), UDim2.new(0, 15, 0.5, -125), Color3.fromRGB(0, 0, 0), 12)
    shadowFrame.BackgroundTransparency = 0.7
    
    local mainFrame = createRoundedFrame(screenGui, UDim2.new(0, 170, 0, 240), UDim2.new(0, 10, 0.5, -120), THEME.COLORS.BACKGROUND, 12)
    
    -- Minimize state variables
    local isMinimized = false
    local originalSize = mainFrame.Size
    local minimizedSize = UDim2.new(0, 170, 0, 40)
    
    -- Header with gradient and dragging functionality
    local headerFrame = createRoundedFrame(mainFrame, UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 8), THEME.COLORS.PRIMARY, 8)
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.COLORS.PRIMARY),
        ColorSequenceKeypoint.new(1, THEME.COLORS.ACCENT)
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = headerFrame
    
    local titleLabel = createLabel(headerFrame, UDim2.new(1, -60, 1, 0), UDim2.new(0, 15, 0, 0), "🌱 Sapling Planter", THEME.COLORS.TEXT, 14, Enum.Font.GothamBold)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Minimize button
    local minimizeBtn = createButton(headerFrame, UDim2.new(0, 22, 0, 22), UDim2.new(1, -28, 0, 6), "–", THEME.COLORS.SECONDARY, THEME.COLORS.TEXT, nil)
    minimizeBtn.TextSize = 16
    minimizeBtn.Font = Enum.Font.GothamBold
    
    -- Dragging functionality (Mobile and PC compatible)
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    headerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                          input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            shadowFrame.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + 5, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + 5)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    -- Content frame (will be hidden/shown when minimizing)
    local contentFrame = createRoundedFrame(mainFrame, UDim2.new(1, 0, 1, -35), UDim2.new(0, 0, 0, 35), Color3.fromRGB(0, 0, 0), 0)
    contentFrame.BackgroundTransparency = 1
    
    -- Minimize functionality
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and minimizedSize or originalSize
        local targetShadowSize = isMinimized and UDim2.new(0, 180, 0, 50) or UDim2.new(0, 180, 0, 250)
        
        minimizeBtn.Text = isMinimized and "+" or "–"
        contentFrame.Visible = not isMinimized
        
        local tween1 = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize})
        local tween2 = TweenService:Create(shadowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetShadowSize})
        
        tween1:Play()
        tween2:Play()
    end)
    
    -- Shape selection section
    local shapeSection = createRoundedFrame(contentFrame, UDim2.new(1, -20, 0, 32), UDim2.new(0, 10, 0, 10), THEME.COLORS.SURFACE, 6)
    local shapeSectionLabel = createLabel(shapeSection, UDim2.new(1, -15, 0, 14), UDim2.new(0, 12, 0, 2), "Shape Configuration", THEME.COLORS.TEXT_SECONDARY, 9, Enum.Font.GothamMedium)
    
    local shapeDropdown = createRoundedFrame(shapeSection, UDim2.new(1, -24, 0, 18), UDim2.new(0, 12, 0, 14), THEME.COLORS.SECONDARY, 4)
    local shapeLabel = createLabel(shapeDropdown, UDim2.new(1, -25, 1, 0), UDim2.new(0, 8, 0, 0), "Shape: " .. currentShape, THEME.COLORS.TEXT, 10)
    
    local shapeBtn = Instance.new("TextButton")
    shapeBtn.Size = UDim2.new(1, 0, 1, 0)
    shapeBtn.BackgroundTransparency = 1
    shapeBtn.Text = ""
    shapeBtn.Parent = shapeDropdown
    
    local dropdownIcon = createLabel(shapeDropdown, UDim2.new(0, 15, 1, 0), UDim2.new(1, -18, 0, 0), "▼", THEME.COLORS.TEXT_SECONDARY, 8)
    dropdownIcon.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Create dropdown at screen level with higher ZIndex to fix overlap issue (Mobile-optimized)
    local shapeOptionsFrame = createRoundedFrame(screenGui, UDim2.new(0, 150, 0, 65), UDim2.new(0, 25, 0, 200), THEME.COLORS.SECONDARY, 4)
    shapeOptionsFrame.Visible = false
    shapeOptionsFrame.ClipsDescendants = true
    shapeOptionsFrame.ZIndex = 12  -- High z-index for dropdown container
    shapeOptionsFrame.Active = true  -- Make frame active to capture clicks
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 1)
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
    
    -- Hide dropdown when clicking elsewhere (Mobile and PC compatible)
    local hideDropdownConnection
    hideDropdownConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) and not gameProcessed then
            local inputPos
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                inputPos = UserInputService:GetMouseLocation()
            else
                inputPos = input.Position
            end
            
            local framePos = shapeOptionsFrame.AbsolutePosition
            local frameSize = shapeOptionsFrame.AbsoluteSize
            
            if shapeOptionsFrame.Visible then
                -- Check if click was inside the dropdown options
                local clickedInDropdown = (inputPos.X >= framePos.X and inputPos.X <= framePos.X + frameSize.X and
                                         inputPos.Y >= framePos.Y and inputPos.Y <= framePos.Y + frameSize.Y)
                
                -- Check if click was on the dropdown button
                local buttonPos = shapeDropdown.AbsolutePosition
                local buttonSize = shapeDropdown.AbsoluteSize
                local clickedOnButton = (inputPos.X >= buttonPos.X and inputPos.X <= buttonPos.X + buttonSize.X and
                                       inputPos.Y >= buttonPos.Y and inputPos.Y <= buttonPos.Y + buttonSize.Y)
                
                -- Only hide if clicked outside both dropdown and button
                if not clickedInDropdown and not clickedOnButton then
                    shapeOptionsFrame.Visible = false
                    dropdownIcon.Text = "▼"
                end
            end
        end
    end)
    
    for i, shapeName in ipairs(CONFIG.SHAPES) do
        local optionBtn = createButton(shapeOptionsFrame, UDim2.new(1, -8, 0, 18), UDim2.new(0, 4, 0, (i-1) * 19), shapeName, THEME.COLORS.BACKGROUND, THEME.COLORS.TEXT, function()
            print("Shape selected:", shapeName, "Current shape was:", currentShape)
            currentShape = shapeName
            shapeLabel.Text = "Shape: " .. currentShape
            shapeOptionsFrame.Visible = false
            dropdownIcon.Text = "▼"
            print("Shape updated to:", currentShape, "Label updated to:", shapeLabel.Text)
            previewShape(true)  -- Force update for shape changes
        end)
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 9
        optionBtn.ZIndex = 15  -- Higher z-index for better click detection
        
        -- Add explicit active area to ensure clicks are detected
        optionBtn.Active = true
        optionBtn.AutoButtonColor = false
        
        -- Add click feedback
        optionBtn.MouseButton1Down:Connect(function()
            optionBtn.BackgroundColor3 = THEME.COLORS.PRIMARY
        end)
        
        optionBtn.MouseButton1Up:Connect(function()
            optionBtn.BackgroundColor3 = THEME.COLORS.BACKGROUND
        end)
    end
    
    -- Enhanced slider creation function (Mobile-optimized)
    local function createEnhancedSlider(parent, text, yPos, min, max, default, suffix)
        local sliderFrame = createRoundedFrame(parent, UDim2.new(1, -20, 0, 36), UDim2.new(0, 10, 0, yPos), THEME.COLORS.SURFACE, 6)
        
        local label = createLabel(sliderFrame, UDim2.new(1, -15, 0, 12), UDim2.new(0, 8, 0, 2), text, THEME.COLORS.TEXT_SECONDARY, 9, Enum.Font.GothamMedium)
        local valueLabel = createLabel(sliderFrame, UDim2.new(0, 50, 0, 12), UDim2.new(1, -58, 0, 2), default .. (suffix or ""), THEME.COLORS.TEXT, 9, Enum.Font.GothamBold)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local track = createRoundedFrame(sliderFrame, UDim2.new(1, -16, 0, 5), UDim2.new(0, 8, 0, 20), THEME.COLORS.BACKGROUND, 3)
        local progress = createRoundedFrame(track, UDim2.new((default - min) / (max - min), 0, 1, 0), UDim2.new(0, 0, 0, 0), THEME.COLORS.PRIMARY, 3)
        
        local handle = Instance.new("TextButton")
        handle.Size = UDim2.new(0, 12, 0, 12)
        handle.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
        handle.BackgroundColor3 = THEME.COLORS.TEXT
        handle.BorderSizePixel = 0
        handle.Text = ""
        handle.Parent = track
        
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(1, 0)
        handleCorner.Parent = handle
        
        local isSliderDragging = false
        
        -- Handle both mouse and touch input for mobile compatibility
        local function startDragging()
            isSliderDragging = true 
            handle.BackgroundColor3 = THEME.COLORS.PRIMARY
        end
        
        local function stopDragging()
            isSliderDragging = false
            handle.BackgroundColor3 = THEME.COLORS.TEXT
        end
        
        -- Mouse events (PC)
        handle.MouseButton1Down:Connect(startDragging)
        
        -- Touch events (Mobile)
        handle.TouchTap:Connect(startDragging)
        
        -- Allow clicking on track to move slider (Mobile-friendly)
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                local trackWidth = track.AbsoluteSize.X
                local trackX = track.AbsolutePosition.X
                local clickX = input.Position.X
                local handleX = math.clamp(clickX - trackX, 0, trackWidth)
                
                local percentage = handleX / trackWidth
                handle.Position = UDim2.new(percentage, -6, 0.5, -6)
                progress.Size = UDim2.new(percentage, 0, 1, 0)
                
                local value = min + (max - min) * percentage
                if suffix == " studs" then
                    value = math.floor(value)
                    valueLabel.Text = value .. suffix
                    if text == "Dimension" then
                        currentSize = value
                    elseif text == "Spacing" then
                        currentSpacing = value
                    end
                else
                    value = math.floor(value * 10) / 10
                    valueLabel.Text = string.format("%.1f", value) .. suffix
                    currentHeightOffset = value
                end
                
                -- Trigger preview update
                if previewDebounceThread then
                    task.cancel(previewDebounceThread)
                end
                previewDebounceThread = task.delay(DEBOUNCE_TIME, function()
                    previewShape(true)
                end)
                
                startDragging()
            end
        end)
        
        -- Universal input end detection
        UserInputService.InputEnded:Connect(function(input) 
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then 
                stopDragging()
            end 
        end)
        
        local updateValue = function(input)
            if not isSliderDragging then return end
            local trackWidth = track.AbsoluteSize.X
            local trackX = track.AbsolutePosition.X
            
            -- Handle both mouse and touch input
            local inputX
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                inputX = input.Position.X
            elseif input.UserInputType == Enum.UserInputType.Touch then
                inputX = input.Position.X
            else
                return
            end
            
            local handleX = math.clamp(inputX - trackX, 0, trackWidth)
            
            local percentage = handleX / trackWidth
            handle.Position = UDim2.new(percentage, -6, 0.5, -6)
            progress.Size = UDim2.new(percentage, 0, 1, 0)
            
            local value = min + (max - min) * percentage
            return value, valueLabel, suffix
        end
        
        return updateValue
    end
    
    -- Create enhanced sliders (Mobile-optimized spacing)
    local updateSize = createEnhancedSlider(contentFrame, "Dimension", 47, CONFIG.MIN_SIZE, CONFIG.MAX_SIZE, CONFIG.DEFAULT_SIZE, " studs")
    local updateSpacing = createEnhancedSlider(contentFrame, "Spacing", 87, CONFIG.MIN_SPACING, CONFIG.MAX_SPACING, CONFIG.DEFAULT_SPACING, " studs") 
    local updateHeight = createEnhancedSlider(contentFrame, "Height Offset", 127, CONFIG.MIN_HEIGHT_OFFSET, CONFIG.MAX_HEIGHT_OFFSET, CONFIG.DEFAULT_HEIGHT_OFFSET, " units")
    
    -- Handle slider updates (Support both mouse and touch)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
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
                    previewShape(true)  -- Force update for slider changes
                end)
            end
        end
    end)
    
    -- Action buttons section (Mobile-optimized)
    local buttonSection = createRoundedFrame(contentFrame, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 167), THEME.COLORS.SURFACE, 6)
    
    local previewBtn = createButton(buttonSection, UDim2.new(0.48, 0, 0, 20), UDim2.new(0, 8, 0, 5), "🔍 Preview", THEME.COLORS.PRIMARY, THEME.COLORS.TEXT, previewShape)
    local clearBtn = createButton(buttonSection, UDim2.new(0.48, 0, 0, 20), UDim2.new(0.52, 0, 0, 5), "🗑️ Clear", THEME.COLORS.DANGER, THEME.COLORS.TEXT, clearShape)
    
    -- Progress display (Mobile-optimized)
    local progressFrame = createRoundedFrame(buttonSection, UDim2.new(1, -16, 0, 16), UDim2.new(0, 8, 0, 29), THEME.COLORS.BACKGROUND, 4)
    local progressLabel = createLabel(progressFrame, UDim2.new(1, -12, 1, 0), UDim2.new(0, 12, 0, 0), "Progress: N/A", THEME.COLORS.TEXT, 9, Enum.Font.GothamMedium)
    progressLabel.TextXAlignment = Enum.TextXAlignment.Center
    guiElements.ProgressLabel = progressLabel
    
    -- Plant/Stop buttons (Mobile-optimized)
    local plantBtn = createButton(contentFrame, UDim2.new(1, -20, 0, 22), UDim2.new(0, 10, 0, 221), "🌱 Start Planting", THEME.COLORS.SUCCESS, THEME.COLORS.TEXT, nil)
    local stopBtn = createButton(contentFrame, UDim2.new(1, -20, 0, 22), UDim2.new(0, 10, 0, 221), "⏹️ Stop Planting", THEME.COLORS.WARNING, THEME.COLORS.TEXT, nil)
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
    
    -- Planting logic
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
                    
                    -- Teleport sapling directly to the destination position (exactly on the dot)
                    local saplingPart = saplingToPlant.PrimaryPart or saplingToPlant:FindFirstChildOfClass("BasePart")
                    if saplingPart then
                        saplingPart.CFrame = CFrame.new(pointData.position)
                        saplingPart.AssemblyLinearVelocity = Vector3.zero
                        saplingPart.AssemblyAngularVelocity = Vector3.zero
                    end
                    
                    local success, result = pcall(function() 
                        return plantRemote:InvokeServer(saplingToPlant, pointData.position) 
                    end)
                    
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
                    
                    -- Wait 0.2 seconds between each planting

                end
            end
            
            isPlanting = false
            setButtons(true)
            print("Planting process finished or paused.")
        end) 
    end)
    
    -- Parent to PlayerGui
    screenGui.Parent = player:WaitForChild("PlayerGui")
    SaplingsGUI = screenGui
    print("Saplings GUI created successfully!")
end

-- Function to destroy the Saplings GUI
local function destroySaplingsGUI()
    if SaplingsGUI then
        -- Clear any existing highlights first
        for _, part in ipairs(workspace:GetChildren()) do
            if part.Name == "PlantingHighlight" then
                part:Destroy()
            end
        end
        
        SaplingsGUI:Destroy()
        SaplingsGUI = nil
        print("Saplings GUI destroyed!")
    end
end

GUITap:CreateToggle({
    Name = "Saplings Planter GUI",
    CurrentValue = false,
    Flag = "GUI_SaplingsEnabled",
    Callback = function(v)
        if v then
            createSaplingsGUI()
        else
            destroySaplingsGUI()
        end
    end
})

-- Credits Section Content
CreditsTab:CreateLabel("Developer: Toasty")
CreditsTab:CreateLabel("Thank you for using this script!")

CreditsTab:CreateButton({
    Name = "📋 Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/DYNb3eHE")
        ApocLibrary:Notify({
            Title = "Discord Link Copied!",
            Content = "Discord link has been copied to clipboard",
            Duration = 3,
            Image = 4483362458,
        })
    end
})

CreditsTab:CreateLabel("Found a bug or have suggestions?")
CreditsTab:CreateLabel("Don't hesitate to report them on Discord!")
CreditsTab:CreateLabel("💡 Use Transport To: Player if the scrapper gets stuck")

-- Initial application (in case character already spawned)
task.delay(0.1, UpdateAll)

-- Initial chest dropdown population
task.delay(1, function()
    UpdateAllChestDropdowns()
end)
