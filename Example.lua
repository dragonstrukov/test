local Library = loadstring(game:HttpGet(
local librarySource = game:HttpGet(
    "https://raw.githubusercontent.com/dragonstrukov/test/main/Library.lua"
))()
)
local loadLibrary, loadError = loadstring(librarySource)
if not loadLibrary then
    error(loadError or "Failed to load Library.lua", 0)
end
local Library = loadLibrary()

local Window = Library:CreateWindow({
    Name = "My Hub",
    ToggleKey = Enum.KeyCode.RightShift,
})

local Keybinds = Window:CreateKeybindList({
    Title = "Keybinds",
    Visible = true,
    Position = UDim2.new(0, 16, 0.32, 0),
})

local Features = Window:CreateCategory("Features")

local CombatTab = Window:CreateTab("Combat", "zap")
})

Target:CreateKeybind({
    Name = "Toggle UI Key",
    Name = "Aura Key",
    Description = "Press to change, Esc to clear",
    Default = "None",
    Default = "G",
    Flag = "AuraKey",
    Callback = function(key)
        print("Key:", key)
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

Window:Notify({
    Title = "Loaded",
    Content = "Welcome to My Hub!",
    Content = "Keybinds overlay is on the left.",
    Duration = 3,
    Icon = "circle-check",
    Icon = "keyboard",
})

task.spawn(function()
