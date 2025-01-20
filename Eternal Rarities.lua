repeat task.wait() until game:IsLoaded()

local PlayersService = game:GetService('Players')
repeat task.wait() until PlayersService.LocalPlayer
repeat task.wait() until PlayersService.LocalPlayer.Character

local function preventIdleKick()
    if getconnections then
        for _, connection in ipairs(getconnections(PlayersService.LocalPlayer.Idled)) do
            connection:Disable()
        end
    end

    PlayersService.LocalPlayer.Idled:Connect(function()
        local VirtualUserService = game:GetService('VirtualUser')
        local CurrentCamera = game:GetService('Workspace').CurrentCamera
        VirtualUserService:Button2Down(Vector2.new(0,0), CurrentCamera.CFrame)
        task.wait(1)
        VirtualUserService:Button2Up(Vector2.new(0,0), CurrentCamera.CFrame)
    end)
end

task.spawn(preventIdleKick)

local function loadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        return result
    else
        error("Failed to load module from " .. url .. ": " .. result)
    end
end

local Library = loadModule('https://raw.githubusercontent.com/SlamminPig/6FootScripts/main/Utilities/Linoria/Library.lua')

local Window = Library:CreateWindow({
    Title = 'Eternal Rarities X! | Scripts',
    Center = true,
    AutoShow = true,
    ShowCustomCursor = false,
    Resizable = true
})

local MainTab = Window:AddTab('Main')
local MainTabBox = MainTab:AddLeftTabbox()
local MainSection = MainTabBox:AddTab('Main')

local function createToggle(name, text, default, callback)
    MainSection:AddToggle(name, { Text = text, Default = default }):OnChanged(function(state)
        if state then
            task.spawn(callback)
        end
    end)
end

local function sequentialUpgrade(toggleName, basePath, prefix, maxCount)
    while Toggles[toggleName].Value do
        for i = 1, maxCount do
            if not Toggles[toggleName].Value then break end
            
            local buttonName = prefix .. tostring(i)
            local success = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ResetLayer"):FireServer(basePath:WaitForChild(buttonName))
            end)
            
            task.wait(0.1)
        end
    end
end

createToggle('collectJourney', 'Auto Collect Journey', false, function()
    while Toggles.collectJourney.Value do
        task.wait(0.1)
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ResetLayer"):FireServer(workspace:WaitForChild("Areas"):WaitForChild("Space Construction"):WaitForChild("Buttons"):WaitForChild("Journey"):WaitForChild("Journey"))
    end
end)

createToggle('buyJourneyUpgrades', 'Auto Journey Upgrades', false, function()
    local journeyPath = workspace:WaitForChild("Areas"):WaitForChild("Space Construction"):WaitForChild("Buttons"):WaitForChild("Journey")
    sequentialUpgrade('buyJourneyUpgrades', journeyPath, "J", 12)
end)

createToggle('collectRocketFuel', 'Auto Collect Rocket Fuel', false, function()
    while Toggles.collectRocketFuel.Value do
        task.wait(0.1)
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ResetLayer"):FireServer(workspace:WaitForChild("Areas"):WaitForChild("Space Construction"):WaitForChild("Buttons"):WaitForChild("Journey"):WaitForChild("RocketFuel"))
    end
end)

createToggle('collectMagic', 'Auto Collect Magic', false, function()
    while Toggles.collectMagic.Value do
        task.wait(0.1)
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ResetLayer"):FireServer(workspace:WaitForChild("Areas"):WaitForChild("Cherry Forest"):WaitForChild("Buttons"):WaitForChild("Magic"))
    end
end)

createToggle('buyMagicUpgrades', 'Auto Magic Upgrades', false, function()
    local magicPath = workspace:WaitForChild("Areas"):WaitForChild("Cherry Forest"):WaitForChild("Buttons"):WaitForChild("Magic")
    sequentialUpgrade('buyMagicUpgrades', magicPath, "M", 23)
end)

local SettingsTab = Window:AddTab('Settings')
local CreditsTabBox = SettingsTab:AddRightTabbox()
local CreditsSection = CreditsTabBox:AddTab('Credits')

CreditsSection:AddButton('Kill Script', function()
    Library:Unload()
end)
