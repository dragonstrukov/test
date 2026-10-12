local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dragonstrukov/test/main/Library.lua"
))()

local Window = Library:CreateWindow({
    Name = "My Hub",
    Description = "Example script",
    Version = "v1.0",
    FooterText = "made with UI Library",
    ToggleKey = Enum.KeyCode.RightShift,
})

local Keybinds = Window:CreateKeybindList({
    Title = "Keybinds",
    Visible = true,
    Position = UDim2.new(0, 16, 0.32, 0),
})

local Features = Window:CreateCategory("Features")

local CombatTab = Window:CreateTab("Combat", "zap")
local MoveTab = Window:CreateTab({ Name = "Movement", Icon = "move" })

local Fight = CombatTab:CreateSection("Fighting", 1)
local Target = CombatTab:CreateSection("Target", 2)

local aura = Fight:CreateToggle({
    Name = "Attack Aura",
    Description = "Automatically attacks nearby players",
    Default = false,
    Flag = "AttackAura",
    Callback = function(value)
        print("Aura:", value)
    end,
})

Fight:CreateSlider({
    Name = "Range",
    Description = "Attack distance in studs",
    Min = 5, Max = 30, Default = 12, Decimals = 0,
    Flag = "AuraRange",
    Callback = function(value)
        print("Range:", value)
    end,
})

Fight:CreateDropdown({
    Name = "Mode",
    Options = { "Legit", "Rage", "Silent" },
    Default = "Legit",
    Flag = "AuraMode",
    Callback = function(text, index)
        print("Mode:", text, index)
    end,
})

Fight:CreateMultiDropdown({
    Name = "Targets",
    Options = { "Players", "NPCs", "Bosses" },
    Default = { "Players" },
    Flag = "AuraTargets",
    Callback = function(picked)
        print("Targets:", table.concat(picked, ", "))
    end,
})

Target:CreateInput({
    Name = "Username",
    Description = "Player to target",
    Placeholder = "Type a name...",
    Default = "",
    Flag = "TargetName",
    Callback = function(text)
        print("Target:", text)
    end,
})

Target:CreateKeybind({
    Name = "Aura Key",
    Description = "Press to change, Esc to clear",
    Default = "G",
    Flag = "AuraKey",
    Callback = function(key)
        print("Key:", key)
    end,
})

Target:CreateColorPicker({
    Name = "Highlight Color",
    Default = Color3.fromRGB(246, 92, 82),
    Flag = "ESColor",
    Callback = function(color)
        print("Color:", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
    end,
})

Target:CreateProgressBar({
    Name = "Charge",
    Description = "Hold to charge",
    Default = 35,
    Interactive = true,
    Flag = "Charge",
    Callback = function(value)
        print("Charge:", value)
    end,
})

Fight:CreateButtonRow("Actions", {
    { Text = "Start", Callback = function() print("Start!") end },
    { Text = "Stop", Callback = function() print("Stop!") end },
})

MoveTab:CreateSection("Speed", 1):CreateButton({
    Name = "Reset Speed",
    Callback = function() print("Speed reset") end,
})

Fight:CreateDivider()
local statusLabel = Fight:CreateLabel("Status: idle")

local Speed = MoveTab:CreateSection("Speed", 1)
Speed:CreateToggle({
    Name = "Keybind Overlay",
    Description = "Show the on-screen Keybinds list",
    Default = true,
    Callback = function(value)
        Keybinds:SetVisible(value)
    end,
})
Speed:CreateKeybind({
    Name = "Speed Key",
    Description = "Shown in the Keybinds overlay",
    Default = "V",
    Flag = "SpeedKey",
    Callback = function(key)
        print("Speed key:", key)
    end,
})
Speed:CreateSlider({
    Name = "Walk Speed", Min = 16, Max = 200, Default = 16, Decimals = 0,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = value end
    end,
})

-- Browse: a gallery of universal scripts loaded from a JSON API, so the list
-- is the same for every user and can be updated without touching the script.
-- JSON format: {"items": [{"name", "category", "rating", "author", "image", "url"}, ...]}
-- (see browse.json in the repo).
local BROWSE_API = "https://raw.githubusercontent.com/dragonstrukov/test/arena/a5c5a8e6-test/browse.json"
-- after merging to main: "https://raw.githubusercontent.com/dragonstrukov/test/main/browse.json"

-- Shown right away and kept if the API is unreachable (offline / 404).
local BROWSE_FALLBACK = {
    { Name = "Example Hub",   Category = "Universal", Rating = 96, Author = "dragonstrukov", Image = "rbxassetid://81973586053257",  Fit = true, Data = "https://raw.githubusercontent.com/dragonstrukov/test/main/Example.lua" },
    { Name = "Attack Aura",   Category = "Combat",    Rating = 88, Author = "dragonstrukov", Image = "rbxassetid://130551565616516", Fit = true, Data = "https://raw.githubusercontent.com/dragonstrukov/test/main/Example.lua" },
    { Name = "Walk Speed",    Category = "Movement",  Rating = 79, Author = "dragonstrukov", Image = "rbxassetid://110273524101447", Fit = true, Data = "https://raw.githubusercontent.com/dragonstrukov/test/main/Example.lua" },
    { Name = "Player ESP",    Category = "Visuals",   Rating = 91, Author = "dragonstrukov", Image = "rbxassetid://100033680381365", Fit = true, Data = "https://raw.githubusercontent.com/dragonstrukov/test/main/Example.lua" },
    { Name = "Anti AFK",      Category = "Misc",      Rating = 99, Author = "dragonstrukov", Image = "rbxassetid://98083086936965",  Fit = true, Data = "https://raw.githubusercontent.com/dragonstrukov/test/main/Example.lua" },
    { Name = "Noclip",        Category = "Movement",  Rating = 77, Author = "dragonstrukov", Image = "rbxassetid://113822048130017", Fit = true, Data = "https://raw.githubusercontent.com/dragonstrukov/test/main/Example.lua" },
}

Window:CreateCategory("Library")
local Browse = Window:CreateBrowseTab({
    Name = "Browse",
    Icon = "store",
    Source = BROWSE_API,          -- JSON API; remove it to use only Items
    Items = BROWSE_FALLBACK,      -- optional: shown until the API answers
    Categories = { "Universal", "Combat", "Movement", "Visuals", "Misc" }, -- omit to build them from the items
    SortModes = { "Hot", "New", "A-Z" },
    PageSize = 9,
    Columns = 3,
    SearchPlaceholder = "Search scripts...",
    OnLoad = function(items)
        Window:Notify({ Title = "Browse", Content = #items .. " scripts loaded from API", Icon = "circle-check", Duration = 2 })
    end,
    Callback = function(item)
        -- item.Name, item.Category, item.Rating, item.Author, item.Data (= "url"), item.Raw (= original JSON)
        if not item.Data then return end
        Window:Notify({ Title = "Browse", Content = "Loading " .. item.Name .. "...", Icon = "download", Duration = 2 })
        task.spawn(function()
            local ok, err = pcall(function()
                loadstring(game:HttpGet(tostring(item.Data)))()
            end)
            if not ok then
                Window:Notify({ Title = "Browse", Content = "Failed: " .. tostring(err), Icon = "alert-triangle", Duration = 4 })
            end
        end)
    end,
})

-- The same panel can also be driven from code:
-- Browse:SetItems({ { Name = "Local script", Category = "Misc", Rating = 50, Data = "https://..." } })
-- Browse:Search("esp") / Browse:SetCategory("Visuals") / Browse:SetSort("New") / Browse:Refresh()

Window:CreateCategory({ Name = "Manager", Collapsed = true })
Window:CreateThemeTab("Themes", "palette")

Window:Notify({
    Title = "Loaded",
    Content = "Keybinds overlay is on the left.",
    Duration = 3,
    Icon = "keyboard",
})

task.spawn(function()
    task.wait(3)
    aura:Set(true)
    print("Aura flag:", Library.Flags["AttackAura"])
    statusLabel.Set("Status: running")
    task.wait(3)
    aura:Set(false)
    statusLabel.Set("Status: idle")
end)
