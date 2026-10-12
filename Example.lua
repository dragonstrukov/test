local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dragonstrukov/test/main/Library.lua"
))()

local Window = Library:CreateWindow({
    Name = "My Hub",
    Description = "Example script",
    Version = "v1.0",
    FooterText = "made with UI Library",
    ToggleKey = Enum.KeyCode.RightShift,
    ThreeDIcons = true, -- Or use ["3DIcons"] = true
})

-- A standalone sample Part: the library clones it into a ViewportFrame icon.
local ThreeDIconModel = Instance.new("Part")
ThreeDIconModel.Name = "Example3DIcon"
ThreeDIconModel.Shape = Enum.PartType.Ball
ThreeDIconModel.Size = Vector3.new(1.4, 1.4, 1.4)
ThreeDIconModel.Material = Enum.Material.Neon
ThreeDIconModel.Color = Color3.fromRGB(246, 92, 82)

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
    Options = {
        { Text = "Legit", Icon = ThreeDIconModel },
        { Text = "Rage", Icon = "zap" },
        { Text = "Silent", Icon3D = ThreeDIconModel, IconOptions = { Rotation = Vector3.new(0, 30, 0) } },
    },
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
    { Text = "Start", Icon = ThreeDIconModel, Callback = function() print("Start!") end },
    { Text = "Stop", Icon = "pause", Callback = function() print("Stop!") end },
})

MoveTab:CreateSection("Speed", 1):CreateButton({
    Name = "Reset Speed",
    Icon = ThreeDIconModel,
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
