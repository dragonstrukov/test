local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dragonstrukov/test/main/Library.lua"
))()
local function installKeybindOverlay(Library)
    if Library.__KeybindOverlay then
        return Library
    end
    Library.__KeybindOverlay = true

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")

    local function guiParent()
        local ok, hui = pcall(function()
            return (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
        end)
        if ok and typeof(hui) == "Instance" then
            return hui
        end
        local probe = Instance.new("Folder")
        local okCore = pcall(function()
            probe.Parent = CoreGui
        end)
        probe:Destroy()
        if okCore then
            return CoreGui
        end
        return Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local function corner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius)
        c.Parent = parent
        return c
    end

    local function stroke(parent, color)
        local s = Instance.new("UIStroke")
        s.Color = color
        s.Thickness = 0.8
        s.Parent = parent
        return s
    end

    local function keyName(key)
        if typeof(key) == "EnumItem" then
            return key.Name
        end
        if type(key) == "string" and key ~= "" then
            return key
        end
        return "RightShift"
    end

    local function shortKey(key)
        local aliases = {
            RightShift = "RShift", LeftShift = "LShift",
            RightControl = "RCtrl", LeftControl = "LCtrl",
            RightAlt = "RAlt", LeftAlt = "LAlt",
            CapsLock = "Caps", Backspace = "Bksp",
            Delete = "Del", Return = "Enter", Space = "Space",
        }
        key = tostring(key or "None")
        if key == "" then
            return "None"
        end
        return aliases[key] or key
    end

    local oldCreateWindow = Library.CreateWindow
    function Library:CreateWindow(options)
        options = options or {}
        local Window = oldCreateWindow(self, options)
        if Window.CreateKeybindList then
            return Window
        end

        local rows = {}
        local order = 0
        local collapsed = false
        local hideUnbound = false
        local showToggle = true
        local listVisible = false
        local titleText = "Keybinds"

        local screen = Instance.new("ScreenGui")
        screen.Name = "KeybindsOverlay"
        screen.ResetOnSpawn = false
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screen.Parent = guiParent()

        local holder = Instance.new("Frame")
        holder.Name = "Keybinds"
        holder.Size = UDim2.new(0, 216, 0, 0)
        holder.AutomaticSize = Enum.AutomaticSize.Y
        holder.Position = UDim2.new(0, 16, 0.32, 0)
        holder.BackgroundColor3 = Color3.fromRGB(18, 13, 16)
        holder.BorderSizePixel = 0
        holder.Active = true
        holder.Visible = false
        holder.ZIndex = 60
        holder.Parent = screen
        corner(holder, 8)
        stroke(holder, Color3.fromRGB(36, 24, 28))

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)
        pad.Parent = holder

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.Parent = holder

        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 18)
        header.BackgroundTransparency = 1
        header.Active = true
        header.LayoutOrder = 1
        header.Parent = holder

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 14, 0, 14)
        icon.Position = UDim2.new(0, 0, 0.5, -7)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://121474456068237"
        icon.ImageColor3 = Color3.fromRGB(246, 92, 82)
        icon.Parent = header

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 1, 0)
        title.Position = UDim2.new(0, 20, 0, 0)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Color3.fromRGB(235, 235, 235)
        title.Text = "Keybinds"
        title.Parent = header

        local chevron = Instance.new("ImageButton")
        chevron.Size = UDim2.new(0, 14, 0, 14)
        chevron.Position = UDim2.new(1, -14, 0.5, -7)
        chevron.BackgroundTransparency = 1
        chevron.Image = "rbxassetid://7733717447"
        chevron.ImageColor3 = Color3.fromRGB(246, 92, 82)
        chevron.AutoButtonColor = false
        chevron.Parent = header

        local divider = Instance.new("Frame")
        divider.Size = UDim2.new(1, 0, 0, 1)
        divider.BackgroundColor3 = Color3.fromRGB(48, 36, 40)
        divider.BorderSizePixel = 0
        divider.LayoutOrder = 2
        divider.Parent = holder

        local list = Instance.new("Frame")
        list.Size = UDim2.new(1, 0, 0, 0)
        list.AutomaticSize = Enum.AutomaticSize.Y
        list.BackgroundTransparency = 1
        list.LayoutOrder = 3
        list.Parent = holder

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 4)
        listLayout.Parent = list

        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 16)
        empty.BackgroundTransparency = 1
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 11
        empty.TextXAlignment = Enum.TextXAlignment.Left
        empty.TextColor3 = Color3.fromRGB(120, 110, 115)
        empty.Text = "No keybinds"
        empty.LayoutOrder = 0
        empty.Parent = list

        local function rowVisible(row)
            if row.hidden then
                return false
            end
            if hideUnbound and (row.key == "None" or row.key == "") then
                return false
            end
            return true
        end

        local function refresh()
            local any = false
            for _, row in pairs(rows) do
                local show = rowVisible(row)
                if row.frame then
                    row.frame.Visible = show
                end
                if show then
                    any = true
                end
            end
            list.Visible = not collapsed
            divider.Visible = not collapsed
            empty.Visible = not any
            empty.Text = hideUnbound and "Nothing bound" or "No keybinds"
        end

        local function paint(row)
            local shown = shortKey(row.key)
            row.badge.Text = shown
            local width = math.max(32, math.min(108, #shown * 7 + 12))
            row.badge.Size = UDim2.new(0, width, 0, 16)
            row.nameLabel.Size = UDim2.new(1, -(width + 8), 1, 0)
            row.nameLabel.Text = row.name
            if row.key == "None" or row.key == "" then
                row.badge.TextColor3 = Color3.fromRGB(72, 64, 68)
            else
                row.badge.TextColor3 = Color3.fromRGB(246, 92, 82)
            end
            refresh()
        end

        local function ensureRow(id, name, key, rowOrder, hidden)
            local row = rows[id]
            if not row then
                order = order + 1
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 18)
                frame.BackgroundTransparency = 1
                frame.LayoutOrder = rowOrder or order
                frame.Parent = list

                local nameLabel = Instance.new("TextLabel")
                nameLabel.BackgroundTransparency = 1
                nameLabel.Font = Enum.Font.GothamMedium
                nameLabel.TextSize = 12
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                nameLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
                nameLabel.Parent = frame

                local badge = Instance.new("TextLabel")
                badge.AnchorPoint = Vector2.new(1, 0.5)
                badge.Position = UDim2.new(1, 0, 0.5, 0)
                badge.BackgroundColor3 = Color3.fromRGB(25, 18, 22)
                badge.Font = Enum.Font.GothamBold
                badge.TextSize = 10
                badge.TextXAlignment = Enum.TextXAlignment.Center
                badge.Parent = frame
                corner(badge, 3)
                stroke(badge, Color3.fromRGB(36, 24, 28))

                row = {
                    frame = frame,
                    nameLabel = nameLabel,
                    badge = badge,
                    name = name,
                    key = tostring(key or "None"),
                    hidden = hidden and true or false,
                }
                rows[id] = row
            else
                if name ~= nil then
                    row.name = name
                end
                if key ~= nil then
                    row.key = tostring(key)
                end
                if hidden ~= nil then
                    row.hidden = hidden and true or false
                end
            end
            paint(row)
            return row
        end

        local function setVisible(visible)
            listVisible = visible and true or false
            holder.Visible = listVisible
        end

        local function applyOptions(opts)
            if opts == false then
                setVisible(false)
                return
            end
            if opts == true or opts == nil then
                setVisible(true)
                return
            end
            if type(opts) ~= "table" then
                return
            end
            if opts.Title or opts.Name then
                titleText = tostring(opts.Title or opts.Name)
                title.Text = titleText
            end
            if opts.Position and typeof(opts.Position) == "UDim2" then
                holder.Position = opts.Position
            end
            if opts.HideUnbound ~= nil then
                hideUnbound = opts.HideUnbound and true or false
                refresh()
            end
            if opts.ShowToggleKey ~= nil then
                showToggle = opts.ShowToggleKey and true or false
                if rows.__toggle_menu then
                    rows.__toggle_menu.hidden = not showToggle
                    paint(rows.__toggle_menu)
                end
            end
            if opts.ToggleKeyName and rows.__toggle_menu then
                rows.__toggle_menu.name = tostring(opts.ToggleKeyName)
                paint(rows.__toggle_menu)
            end
            if opts.Collapsed ~= nil then
                collapsed = opts.Collapsed and true or false
                chevron.Rotation = collapsed and -90 or 0
                refresh()
            end
            if opts.Visible ~= nil then
                setVisible(opts.Visible)
            end
        end

        ensureRow("__toggle_menu", "Toggle Menu", keyName(options.ToggleKey or Enum.KeyCode.RightShift), -100, false)

        local api = {}
        function api:SetVisible(visible)
            setVisible(visible)
        end
        function api:IsVisible()
            return listVisible
        end
        function api:Toggle()
            setVisible(not listVisible)
        end
        function api:SetTitle(text)
            title.Text = tostring(text)
        end
        function api:SetPosition(position)
            if typeof(position) == "UDim2" then
                holder.Position = position
            end
        end
        function api:Collapse(value)
            if type(value) ~= "boolean" then
                collapsed = not collapsed
            else
                collapsed = value
            end
            chevron.Rotation = collapsed and -90 or 0
            refresh()
        end
        function api:Add(entry)
            entry = entry or {}
            local id = entry.Id or entry.Flag or ("manual" .. tostring(order + 1))
            ensureRow(id, entry.Name or entry.Title or "Keybind", entry.Key or entry.Default or "None")
            return {
                Set = function(key)
                    ensureRow(id, nil, key)
                end,
                Remove = function()
                    local row = rows[id]
                    if row and row.frame then
                        row.frame:Destroy()
                    end
                    rows[id] = nil
                    refresh()
                end,
            }
        end

        function Window:CreateKeybindList(listOptions)
            applyOptions(listOptions == nil and true or listOptions)
            if type(listOptions) == "table" and listOptions.Visible == nil then
                setVisible(true)
            end
            return api
        end
        Window.KeybindList = Window.CreateKeybindList
        Window.AddKeybindList = Window.CreateKeybindList
        function Window:SetKeybindListVisible(visible)
            setVisible(visible)
        end
        function Window:GetKeybindList()
            return api
        end

        local function hookSection(Section)
            local raw = Section.CreateKeybind
            if not raw or Section.__KeybindHooked then
                return
            end
            Section.__KeybindHooked = true
            local function wrapped(self, kOpts, ...)
                kOpts = kOpts or {}
                local name = kOpts.OverlayName or kOpts.Name or kOpts.Title or "Keybind"
                local show = kOpts.Overlay ~= false and kOpts.ShowInOverlay ~= false
                local id = kOpts.Flag or ("kb" .. tostring(order + 1))
                local userCallback = kOpts.Callback
                if show then
                    kOpts.Callback = function(key)
                        ensureRow(id, name, key)
                        if userCallback then
                            userCallback(key)
                        end
                    end
                end
                local handle = raw(self, kOpts, ...)
                if show and type(handle) == "table" then
                    local initial = kOpts.Default or kOpts.Value or "None"
                    if handle.Get then
                        local ok, value = pcall(handle.Get)
                        if ok and value ~= nil then
                            initial = value
                        end
                    end
                    ensureRow(id, name, initial)
                    local oldSet = handle.Set
                    handle.Set = function(a, b)
                        local key = b
                        if b == nil then
                            key = a
                        end
                        if oldSet then
                            oldSet(a, b)
                        end
                        if type(key) ~= "table" then
                            ensureRow(id, name, key)
                        end
                    end
                end
                return handle
            end
            Section.CreateKeybind = wrapped
            Section.CreateBind = wrapped
            Section.AddKeybind = wrapped
            Section.AddBind = wrapped
        end

        local oldCreateTab = Window.CreateTab
        local function wrappedTab(self, ...)
            local Tab = oldCreateTab(self, ...)
            local oldCreateSection = Tab.CreateSection
            function Tab:CreateSection(...)
                local Section = oldCreateSection(self, ...)
                hookSection(Section)
                return Section
            end
            Tab.AddSection = Tab.CreateSection
            return Tab
        end
        Window.CreateTab = wrappedTab
        Window.AddTab = wrappedTab

        chevron.MouseButton1Click:Connect(function()
            api:Collapse()
        end)

        local dragging = false
        local dragStart, startPos
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = holder.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging then
                return
            end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            local delta = input.Position - dragStart
            holder.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        local oldDestroy = Window.Destroy
        function Window:Destroy()
            screen:Destroy()
            if oldDestroy then
                oldDestroy(self)
            end
        end

        return Window
    end

    return Library
end

local librarySource = game:HttpGet(
    "https://raw.githubusercontent.com/dragonstrukov/test/7fb8a33/Library.lua"
)
local loadLibrary, loadError = loadstring(librarySource)
if not loadLibrary then
    error(loadError or "Failed to load Library.lua", 0)
end
local Library = installKeybindOverlay(loadLibrary())

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
