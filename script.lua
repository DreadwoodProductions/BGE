local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/SlamminPig/6FootScripts/main/Utilities/Linoria/Library.lua'))();
local Functions = loadstring(game:HttpGet('https://burnaly.com/BGE/Functions.lua'))();
 
local Window = Library:CreateWindow({ Title = 'BGE | Scripts', Center = true, AutoShow = true, ShowCustomCursor = false, Resizable = true })
local MainTab = Window:AddTab('Main');
local MainTabbox1 = MainTab:AddLeftTabbox();
local Main = MainTabbox1:AddTab('Main');
 
Main:AddToggle('autoBlow', { Text = 'Auto Blow', Default = false }):OnChanged(function()
    if Toggles.autoBlow.Value then
        task.spawn(function()
            while Toggles.autoBlow.Value do
                Functions.blowBubble()
                task.wait()
            end
        end)
        -- print('Blowing!')
    end
end);
 
Main:AddToggle('autoCollect', { Text = 'Auto Collect Candy', Default = false }):OnChanged(function()
    if Toggles.autoCollect.Value then
        task.spawn(function()
            while Toggles.autoCollect.Value and task.wait(0.1) do
                Functions.collectCandy()
            end
        end)
    end
end);
 
local Eggs = {}
local EggDropdown
 
-- Function to populate Eggs table and update dropdown
local function updateEggs()
    Eggs = {}
    for _, egg in pairs(workspace.Eggs:GetChildren()) do
        table.insert(Eggs, egg.Name)
    end
    table.sort(Eggs)
 
    if EggDropdown then
        EggDropdown:SetValues(Eggs)
    else
        EggDropdown = Main:AddDropdown('selectedEgg', { Text = 'Select An Egg', Default = '', Values = Eggs })
    end
end
 
-- Wait for the game to load
game:GetService("Players").LocalPlayer.OnSpawn:Connect(function()
    wait(2) -- Wait an additional 2 seconds to ensure everything is loaded
    updateEggs()
end)
 
-- Periodically update the Eggs table and dropdown
spawn(function()
    while wait(10) do -- Update every 10 seconds
        updateEggs()
    end
end)
 
Main:AddToggle('autoEgg', { Text = 'Auto Buy Eggs', Default = false }):OnChanged(function()
    if Toggles.autoEgg.Value then
        task.spawn(function()
            while Toggles.autoEgg.Value do
                local selectedEgg = Options.selectedEgg.Value
                if selectedEgg ~= "" then
                    Functions.purchaseEgg(selectedEgg)
                else
                    print("Please select an egg first!")
                end
                task.wait()
            end
        end)
        -- print('Buying Eggs!')
    end
end);
 
local SettingsTab = Window:AddTab('Settings');
local CreditsTab = SettingsTab:AddRightTabbox();
local Credits = CreditsTab:AddTab('Credits');
 
Credits:AddButton('Kill Script', function() Library:Unload() end)
