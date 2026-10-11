local Library = {}
Library.Version = "1.0.0"
Library.Version = "1.1.0"
Library.Flags = {}

local TweenService = game:GetService("TweenService")
    return card
end

local function createKeybindOverlay()
local TextService = game:GetService("TextService")
local KB_WIDTH = 216
local TOGGLE_ENTRY_ID = "__toggle_menu"

local KEY_ALIASES = {
    RightShift = "RShift",
    LeftShift = "LShift",
    RightControl = "RCtrl",
    LeftControl = "LCtrl",
    RightAlt = "RAlt",
    LeftAlt = "LAlt",
    CapsLock = "Caps",
    Backspace = "Bksp",
    Delete = "Del",
    Insert = "Ins",
    PageUp = "PgUp",
    PageDown = "PgDn",
    Return = "Enter",
    KeypadEnter = "NumEnt",
    KeypadPlus = "Num+",
    KeypadMinus = "Num-",
    KeypadMultiply = "Num*",
    KeypadDivide = "Num/",
    KeypadPeriod = "Num.",
    Space = "Space",
    QuotedDouble = "\"",
    Quote = "'",
    Minus = "-",
    Equals = "=",
    LeftBracket = "[",
    RightBracket = "]",
    BackSlash = "\\",
    Semicolon = ";",
    Comma = ",",
    Period = ".",
    Slash = "/",
}

local function formatKeyName(key)
    key = tostring(key or "None")
    if key == "" then return "None" end
    if KEY_ALIASES[key] then return KEY_ALIASES[key] end
    local num = string.match(key, "^Keypad(.+)$")
    if num then return "Num" .. num end
    return key
end

local function keyCodeName(key)
    if typeof(key) == "EnumItem" then
        return key.Name
    end
    if type(key) == "string" and key ~= "" then
        return key
    end
    return "RightShift"
end

local function keyBadgeWidth(text)
    local ok, bounds = pcall(function()
        return TextService:GetTextSize(text, 10, Enum.Font.GothamBold, Vector2.new(140, 16))
    end)
    local width = (ok and bounds and bounds.X) or (#text * 7)
    if width < 18 then width = 18 end
    if width > 108 then width = 108 end
    return math.floor(width + 12)
end

local KeybindHolder = Instance.new("Frame")
KeybindHolder.Name = "Keybinds"
KeybindHolder.AnchorPoint = Vector2.new(0, 0)
KeybindHolder.Position = UDim2.new(0, 16, 0.32, 0)
KeybindHolder.Size = UDim2.new(0, KB_WIDTH, 0, 0)
KeybindHolder.AutomaticSize = Enum.AutomaticSize.Y
KeybindHolder.BorderSizePixel = 0
KeybindHolder.Active = true
KeybindHolder.Visible = false
KeybindHolder.ZIndex = 60
KeybindHolder.Parent = ScreenGui
bindColor(KeybindHolder, "BackgroundColor3", "CardBg")

local keybindScale = Instance.new("UIScale")
keybindScale.Scale = UI_SCALE
keybindScale.Parent = KeybindHolder

local function kbCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function kbStroke(parent, thickness)
    local stroke = Instance.new("UIStroke")
    bindColor(stroke, "Color", "Border")
    stroke.Thickness = thickness or 0.8
    stroke.Parent = parent
    return stroke
end

kbCorner(KeybindHolder, 8)
kbStroke(KeybindHolder, 0.8)

local kbPad = Instance.new("UIPadding")
kbPad.PaddingTop = UDim.new(0, 10)
kbPad.PaddingBottom = UDim.new(0, 10)
kbPad.PaddingLeft = UDim.new(0, 12)
kbPad.PaddingRight = UDim.new(0, 12)
kbPad.Parent = KeybindHolder

local kbLayout = Instance.new("UIListLayout")
kbLayout.SortOrder = Enum.SortOrder.LayoutOrder
kbLayout.Padding = UDim.new(0, 6)
kbLayout.Parent = KeybindHolder

local kbHeader = Instance.new("Frame")
kbHeader.Name = "Header"
kbHeader.Size = UDim2.new(1, 0, 0, 18)
kbHeader.BackgroundTransparency = 1
kbHeader.BorderSizePixel = 0
kbHeader.Active = true
kbHeader.LayoutOrder = 1
kbHeader.ZIndex = 61
kbHeader.Parent = KeybindHolder

local kbIcon = Instance.new("ImageLabel")
kbIcon.Name = "Icon"
kbIcon.Size = UDim2.new(0, 14, 0, 14)
kbIcon.Position = UDim2.new(0, 0, 0.5, -7)
kbIcon.BackgroundTransparency = 1
kbIcon.Image = resolveIcon("keyboard")
kbIcon.ScaleType = Enum.ScaleType.Fit
kbIcon.ZIndex = 62
kbIcon.Parent = kbHeader
tintIcon(kbIcon, "keyboard", "Accent")

local kbTitle = Instance.new("TextLabel")
kbTitle.Name = "Title"
kbTitle.Size = UDim2.new(1, -36, 1, 0)
kbTitle.Position = UDim2.new(0, 20, 0, 0)
kbTitle.BackgroundTransparency = 1
kbTitle.Text = "Keybinds"
kbTitle.Font = Enum.Font.GothamBold
kbTitle.TextSize = 13
kbTitle.TextXAlignment = Enum.TextXAlignment.Left
kbTitle.TextTruncate = Enum.TextTruncate.AtEnd
kbTitle.ZIndex = 62
kbTitle.Parent = kbHeader
bindColor(kbTitle, "TextColor3", "TextPrimary")

local kbChevron = Instance.new("ImageButton")
kbChevron.Name = "Collapse"
kbChevron.Size = UDim2.new(0, 14, 0, 14)
kbChevron.Position = UDim2.new(1, -14, 0.5, -7)
kbChevron.BackgroundTransparency = 1
kbChevron.Image = ICONS.Chevron
kbChevron.AutoButtonColor = false
kbChevron.ZIndex = 63
kbChevron.Parent = kbHeader
bindColor(kbChevron, "ImageColor3", "Accent")

local kbDivider = Instance.new("Frame")
kbDivider.Name = "Divider"
kbDivider.Size = UDim2.new(1, 0, 0, 1)
kbDivider.BorderSizePixel = 0
kbDivider.LayoutOrder = 2
kbDivider.ZIndex = 61
kbDivider.Parent = KeybindHolder
bindColor(kbDivider, "BackgroundColor3", "Divider")

local kbList = Instance.new("Frame")
kbList.Name = "List"
kbList.Size = UDim2.new(1, 0, 0, 0)
kbList.AutomaticSize = Enum.AutomaticSize.Y
kbList.BackgroundTransparency = 1
kbList.BorderSizePixel = 0
kbList.LayoutOrder = 3
kbList.ZIndex = 61
kbList.Parent = KeybindHolder

local kbListLayout = Instance.new("UIListLayout")
kbListLayout.SortOrder = Enum.SortOrder.LayoutOrder
kbListLayout.Padding = UDim.new(0, 4)
kbListLayout.Parent = kbList

local kbEmpty = Instance.new("TextLabel")
kbEmpty.Name = "Empty"
kbEmpty.Size = UDim2.new(1, 0, 0, 16)
kbEmpty.BackgroundTransparency = 1
kbEmpty.Text = "No keybinds"
kbEmpty.Font = Enum.Font.Gotham
kbEmpty.TextSize = 11
kbEmpty.TextXAlignment = Enum.TextXAlignment.Left
kbEmpty.LayoutOrder = 0
kbEmpty.Visible = true
kbEmpty.ZIndex = 62
kbEmpty.Parent = kbList
bindColor(kbEmpty, "TextColor3", "TextMuted")

local kbEntries = {}
local kbById = {}
local kbOrder = 0
local kbHideUnbound = false
local kbCollapsed = false
local kbShowToggle = true
local kbToggleName = "Toggle Menu"
local kbVisible = false
local kbAutoShow = options.KeybindList == nil
local kbToggleHandle = nil
local kbApplyingVisible = false

local function entryVisible(entry)
    if entry.hidden then return false end
    if kbHideUnbound and (entry.key == "None" or entry.key == "") then
        return false
    end
    return true
end

local function refreshKeybindEmpty()
    local any = false
    for _, entry in ipairs(kbEntries) do
        local show = entryVisible(entry)
        if entry.row then
            entry.row.Visible = show
        end
        if show then any = true end
    end
    kbList.Visible = not kbCollapsed
    kbDivider.Visible = not kbCollapsed
    kbEmpty.Visible = not any
    if not any then
        kbEmpty.Text = kbHideUnbound and "Nothing bound" or "No keybinds"
    end
end

local function renderKeybindEntry(entry)
    if not entry or not entry.row then return end
    entry.nameLabel.Text = entry.name
    local shown = formatKeyName(entry.key)
    entry.badge.Text = shown
    local width = keyBadgeWidth(shown)
    entry.badge.Size = UDim2.new(0, width, 0, 16)
    entry.nameLabel.Size = UDim2.new(1, -(width + 8), 1, 0)
    local token = (entry.key == "None" or entry.key == "") and "TextDim" or "Accent"
    bindColor(entry.badge, "TextColor3", token)
    refreshKeybindEmpty()
end

local function createKeybindRow(entry)
    local row = Instance.new("Frame")
    row.Name = "Bind"
    row.Size = UDim2.new(1, 0, 0, 18)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.LayoutOrder = entry.order
    row.ZIndex = 62
    row.Parent = kbList

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, -48, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 63
    nameLabel.Parent = row
    bindColor(nameLabel, "TextColor3", "TextPrimary")

    local badge = Instance.new("TextLabel")
    badge.Name = "Key"
    badge.AnchorPoint = Vector2.new(1, 0.5)
    badge.Position = UDim2.new(1, 0, 0.5, 0)
    badge.Size = UDim2.new(0, 36, 0, 16)
    badge.BorderSizePixel = 0
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 10
    badge.TextXAlignment = Enum.TextXAlignment.Center
    badge.TextTruncate = Enum.TextTruncate.AtEnd
    badge.ZIndex = 63
    badge.Parent = row
    bindColor(badge, "BackgroundColor3", "BadgeBg")
    bindColor(badge, "TextColor3", "TextMuted")
    kbCorner(badge, 3)
    kbStroke(badge)

    entry.row = row
    entry.nameLabel = nameLabel
    entry.badge = badge
    renderKeybindEntry(entry)
end

local function registerOverlayKeybind(info)
    info = info or {}
    local id = info.Id
    if id == nil or id == "" then
        kbOrder = kbOrder + 1
        id = "kb" .. kbOrder
    else
        id = tostring(id)
    end

    local existing = kbById[id]
    if existing then
        if info.Name ~= nil then existing.name = tostring(info.Name) end
        if info.Key ~= nil then existing.key = tostring(info.Key) end
        if info.Hidden ~= nil then existing.hidden = info.Hidden and true or false end
        renderKeybindEntry(existing)
        return id
    end

    if info.Order == nil then
        kbOrder = kbOrder + 1
    end
    local entry = {
        id = id,
        name = tostring(info.Name or info.Title or "Keybind"),
        key = tostring(info.Key or info.Default or "None"),
        order = info.Order or kbOrder,
        hidden = info.Hidden and true or false,
    }
    kbById[id] = entry
    table.insert(kbEntries, entry)
    createKeybindRow(entry)
    return id
end

local function updateOverlayKeybind(id, key, name)
    local entry = kbById[tostring(id)]
    if not entry then return end
    if key ~= nil then entry.key = tostring(key) end
    if name ~= nil then entry.name = tostring(name) end
    renderKeybindEntry(entry)
end

local function removeOverlayKeybind(id)
    id = tostring(id)
    local entry = kbById[id]
    if not entry then return end
    kbById[id] = nil
    for i, item in ipairs(kbEntries) do
        if item == entry then
            table.remove(kbEntries, i)
            break
        end
    end
    if entry.row then entry.row:Destroy() end
    refreshKeybindEmpty()
end

local function setKeybindListCollapsed(collapsed)
    kbCollapsed = collapsed and true or false
    kbChevron.Rotation = kbCollapsed and -90 or 0
    refreshKeybindEmpty()
end

local function setKeybindListVisible(visible, fromToggle)
    kbVisible = visible and true or false
    KeybindHolder.Visible = kbVisible
    if not kbVisible then
        kbAutoShow = false
    end
    if not fromToggle and kbToggleHandle and not kbApplyingVisible then
        kbApplyingVisible = true
        kbToggleHandle.Set(kbVisible)
        kbApplyingVisible = false
    end
end

local function setKeybindListTitle(text)
    kbTitle.Text = tostring(text)
end

local function applyKeybindListOptions(opts)
    if opts == false then
        setKeybindListVisible(false)
        return
    end
    if opts == true or opts == nil then
        setKeybindListVisible(true)
        return
    end
    if type(opts) ~= "table" then return end

    if opts.Title ~= nil or opts.Name ~= nil then
        setKeybindListTitle(opts.Title or opts.Name)
    end
    if opts.Position ~= nil and typeof(opts.Position) == "UDim2" then
        KeybindHolder.Position = opts.Position
    end
    if opts.HideUnbound ~= nil then
        kbHideUnbound = opts.HideUnbound and true or false
        refreshKeybindEmpty()
    end
    if opts.ToggleKeyName ~= nil then
        kbToggleName = tostring(opts.ToggleKeyName)
        if kbById[TOGGLE_ENTRY_ID] then
            updateOverlayKeybind(TOGGLE_ENTRY_ID, nil, kbToggleName)
        end
    end
    if opts.ShowToggleKey ~= nil then
        kbShowToggle = opts.ShowToggleKey and true or false
        if kbById[TOGGLE_ENTRY_ID] then
            kbById[TOGGLE_ENTRY_ID].hidden = not kbShowToggle
            renderKeybindEntry(kbById[TOGGLE_ENTRY_ID])
        end
    end
    if opts.Collapsed ~= nil then
        setKeybindListCollapsed(opts.Collapsed)
    end
    if opts.Visible ~= nil then
        setKeybindListVisible(opts.Visible)
    end
end

if type(options.KeybindList) == "table" then
    kbAutoShow = false
    applyKeybindListOptions(options.KeybindList)
    if options.KeybindList.Visible == nil then
        setKeybindListVisible(true)
    end
elseif options.KeybindList == false then
    kbAutoShow = false
    kbVisible = false
    KeybindHolder.Visible = false
elseif options.KeybindList == true then
    kbAutoShow = false
    setKeybindListVisible(true)
end

registerOverlayKeybind({
    Id = TOGGLE_ENTRY_ID,
    Name = kbToggleName,
    Key = keyCodeName(options.ToggleKey or Enum.KeyCode.RightShift),
    Order = -100,
    Hidden = not kbShowToggle,
})

kbChevron.MouseButton1Click:Connect(function()
    setKeybindListCollapsed(not kbCollapsed)
end)
kbChevron.MouseEnter:Connect(function()
    tweenColors(kbChevron, TWEEN_FAST, {ImageColor3 = "AccentSoft"}):Play()
end)
kbChevron.MouseLeave:Connect(function()
    tweenColors(kbChevron, TWEEN_FAST, {ImageColor3 = "Accent"}):Play()
end)

do
    local dragging = false
    local dragStart, startPos
    kbHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = KeybindHolder.Position
        end
    end)
    trackConn(UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local delta = input.Position - dragStart
        KeybindHolder.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end))
    trackConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
end

local function flashKeybind(entry)
    if not entry.badge or not entry.row or not entry.row.Visible then return end
    tweenColors(entry.badge, TWEEN_FAST, {BackgroundColor3 = "Accent", TextColor3 = "KnobOn"}):Play()
    task.delay(0.16, function()
        if not entry.badge or not entry.badge.Parent then return end
        local token = (entry.key == "None" or entry.key == "") and "TextDim" or "Accent"
        tweenColors(entry.badge, TWEEN_FAST, {BackgroundColor3 = "BadgeBg", TextColor3 = token}):Play()
    end)
end

trackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if isClosed or gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if not KeybindHolder.Visible or kbCollapsed then return end
    local pressed = input.KeyCode.Name
    for _, entry in ipairs(kbEntries) do
        if entry.key == pressed and entry.row and entry.row.Visible then
            flashKeybind(entry)
        end
    end
end))

local function overlayKeybindHandle(id)
    return {
        Id = id,
        Set = function(key, maybeKey)
            if maybeKey ~= nil then key = maybeKey end
            updateOverlayKeybind(id, key)
        end,
        SetName = function(name, maybeName)
            if maybeName ~= nil then name = maybeName end
            updateOverlayKeybind(id, nil, name)
        end,
        Remove = function() removeOverlayKeybind(id) end,
        Get = function()
            local entry = kbById[id]
            return entry and entry.key or "None"
        end,
    }
end

local KeybindListApi = {}

function KeybindListApi:SetVisible(visible)
    setKeybindListVisible(visible)
end

function KeybindListApi:IsVisible()
    return kbVisible and KeybindHolder.Visible
end

function KeybindListApi:Toggle()
    setKeybindListVisible(not kbVisible)
end

function KeybindListApi:SetTitle(text)
    setKeybindListTitle(text)
end

function KeybindListApi:SetPosition(position)
    if typeof(position) == "UDim2" then
        KeybindHolder.Position = position
    end
end

function KeybindListApi:Collapse(collapsed)
    if type(collapsed) ~= "boolean" then
        setKeybindListCollapsed(not kbCollapsed)
    else
        setKeybindListCollapsed(collapsed)
    end
end

function KeybindListApi:Add(entryOptions)
    entryOptions = entryOptions or {}
    local id = registerOverlayKeybind({
        Id = entryOptions.Id or entryOptions.Flag,
        Name = entryOptions.Name or entryOptions.Title,
        Key = entryOptions.Key or entryOptions.Default or "None",
    })
    return overlayKeybindHandle(id)
end

function KeybindListApi:Remove(id)
    removeOverlayKeybind(id)
end

function KeybindListApi:Set(id, key)
    updateOverlayKeybind(id, key)
end

function KeybindListApi:Configure(opts)
    kbAutoShow = false
    applyKeybindListOptions(opts)
end

local function noteKeybindForOverlay()
    if kbAutoShow then
        setKeybindListVisible(true)
    end
end

local function createList(listOptions)
    kbAutoShow = false
    if listOptions == nil or listOptions == true then
        setKeybindListVisible(true)
    elseif listOptions == false then
        setKeybindListVisible(false)
    else
        applyKeybindListOptions(listOptions)
        if type(listOptions) == "table" and listOptions.Visible == nil then
            setKeybindListVisible(true)
        end
    end
    return KeybindListApi
end

return {
    register = registerOverlayKeybind,
    update = updateOverlayKeybind,
    setVisible = setKeybindListVisible,
    apply = applyKeybindListOptions,
    note = noteKeybindForOverlay,
    api = KeybindListApi,
    createList = createList,
    setScale = function(scale)
        keybindScale.Scale = scale
    end,
    isVisible = function()
        return kbVisible
    end,
    setToggleHandle = function(handle)
        kbToggleHandle = handle
    end,
}
end

local KeybindsOverlay = createKeybindOverlay()

local STARTUP_THEME = nil

local function writeCustomConfig()
    }
end

local function addKeybind(card, name, description, defaultKey, callback)
local function addKeybind(card, name, description, defaultKey, callback, extra)
    extra = extra or {}
    local row = createRow(card, name, description, {sideWidth = 94})

    local badge = Instance.new("TextButton")
    local listening = false
    local listener
    local currentKey = defaultKey or "None"
    local overlayId = nil
    if extra.Show ~= false then
        overlayId = KeybindsOverlay.register({
            Id = extra.Id,
            Name = extra.DisplayName or name,
            Key = currentKey,
        })
        KeybindsOverlay.note()
    end

    local function syncOverlay()
        if overlayId then
            KeybindsOverlay.update(overlayId, currentKey)
        end
    end

    resetBtn.MouseButton1Click:Connect(function()
        if listener then
        currentKey = "None"
        badge.Text = "None"
        bindColor(badge, "TextColor3", "TextMuted")
        syncOverlay()
        if callback then callback("None") end
    end)

    badge.MouseButton1Click:Connect(function()
        if listening then
            if listener then listener:Disconnect() end
            badge.Text = defaultKey or "None"
            if listener then
                listener:Disconnect()
                listener = nil
            end
            badge.Text = currentKey
            bindColor(badge, "TextColor3", "TextMuted")
            listening = false
            return
                bindColor(badge, "TextColor3", "TextMuted")
                listening = false
                listener:Disconnect()
                syncOverlay()
                if callback then callback(badge.Text) end
            end
        end))
            currentKey = tostring(value)
            badge.Text = currentKey
            bindColor(badge, "TextColor3", "TextMuted")
            syncOverlay()
            if callback then callback(currentKey) end
        end,
        Get = function() return currentKey end,
        UI_SCALE = scale
        mainScale.Scale = scale
        notifyScale.Scale = scale
        KeybindsOverlay.setScale(scale)
        Main.Size = UDim2.new(0, newW / scale, 0, newH / scale)
    end))

    end },
})

KeybindsOverlay.setToggleHandle(addToggle(cardSettings, "Keybind List", "Show the on-screen keybind overlay", KeybindsOverlay.isVisible(), function(value)
    KeybindsOverlay.setVisible(value, true)
end))

local cardCustomTheme = createCard(Col1, "Custom Theme", 1, themeTabName)

local customPickers = {}
                if kOpts.Flag ~= nil then
                    Library.Flags[kOpts.Flag] = tostring(default)
                end
                local showInOverlay = kOpts.Overlay ~= false and kOpts.ShowInOverlay ~= false
                return addKeybind(body, kOpts.Name or kOpts.Title or "Keybind",
                    descOf(kOpts), tostring(default), flagCallback(kOpts.Flag, kOpts.Callback))
                    descOf(kOpts), tostring(default), flagCallback(kOpts.Flag, kOpts.Callback), {
                        Id = kOpts.Flag,
                        Show = showInOverlay,
                        DisplayName = kOpts.OverlayName,
                    })
            end
            Section.CreateBind = Section.CreateKeybind

        return Notify(opts)
    end

    function Window:CreateKeybindList(listOptions)
        return KeybindsOverlay.createList(listOptions)
    end
    Window.AddKeybindList = Window.CreateKeybindList
    Window.KeybindList = Window.CreateKeybindList

    function Window:GetKeybindList()
        return KeybindsOverlay.api
    end

    function Window:SetKeybindListVisible(visible)
        KeybindsOverlay.setVisible(visible)
    end

    function Window:SetTheme(themeName, silent)
        if silent then
            return setTheme(themeName)
