-- =============================================================================
-- SCORPION X - UI LIBRARY ENGINE (VERSIONE COMPLETA AGGIORNATA)
-- =============================================================================
local Library = {}

function Library:Inizializza(titoloHub, idIconaPulsante, tastoChiusuraDefault)
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui", 10) or player.PlayerGui

    -- Rimozione vecchie istanze
    local oldGui = playerGui:FindFirstChild("ScorpioXMenu") or CoreGui:FindFirstChild("ScorpioXMenu")
    if oldGui then oldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScorpioXMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 100

    local successo = pcall(function() ScreenGui.Parent = CoreGui end)
    if not successo then ScreenGui.Parent = playerGui end

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Active = true
    MainFrame.Draggable = true 
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui

    local UICornerFrame = Instance.new("UICorner")
    UICornerFrame.CornerRadius = UDim.new(0, 10)
    UICornerFrame.Parent = MainFrame

    local UIStrokeFrame = Instance.new("UIStroke")
    UIStrokeFrame.Thickness = 1.5
    UIStrokeFrame.Color = Color3.fromRGB(150, 255, 0)
    UIStrokeFrame.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 10)
    TopBarCorner.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = tostring(titoloHub):upper()
    TitleLabel.Parent = TopBar

    -- PULSANTE FLUTTUANTE (Apertura/Chiusura)
    local ToggleMenuBtn
    if idIconaPulsante and idIconaPulsante ~= "" then
        local pulitoID = tostring(idIconaPulsante):match("%d+")
        ToggleMenuBtn = Instance.new("ImageButton")
        ToggleMenuBtn.Image = "rbxassetid://" .. pulitoID
        ToggleMenuBtn.ScaleType = Enum.ScaleType.Crop
        ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    else
        ToggleMenuBtn = Instance.new("TextButton")
        ToggleMenuBtn.Text = "SCO X"
        ToggleMenuBtn.TextColor3 = Color3.fromRGB(150, 255, 0)
        ToggleMenuBtn.Font = Enum.Font.SourceSansBold
        ToggleMenuBtn.TextSize = 14
        ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end

    ToggleMenuBtn.Name = "ToggleMenuBtn"
    ToggleMenuBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleMenuBtn.Position = UDim2.new(0, 20, 0.3, 0)
    ToggleMenuBtn.Active = true
    ToggleMenuBtn.Draggable = true 
    ToggleMenuBtn.Parent = ScreenGui

    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(1, 0)
    UICornerBtn.Parent = ToggleMenuBtn

    local UIStrokeBtn = Instance.new("UIStroke")
    UIStrokeBtn.Thickness = 1.5
    UIStrokeBtn.Color = Color3.fromRGB(150, 255, 0)
    UIStrokeBtn.Parent = ToggleMenuBtn

    ToggleMenuBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- CHIUSURA DA TASTIERA
    local menuBind = tastoChiusuraDefault or Enum.KeyCode.RightControl
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == menuBind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- SIDEBAR
    local SideBar = Instance.new("ScrollingFrame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 130, 0, 285)
    SideBar.Position = UDim2.new(0, 10, 0, 45)
    SideBar.BackgroundTransparency = 1
    SideBar.CanvasSize = UDim2.new(0, 0, 0, 400)
    SideBar.ScrollBarThickness = 0
    SideBar.Parent = MainFrame

    local SideBarList = Instance.new("UIListLayout")
    SideBarList.Padding = UDim.new(0, 5)
    SideBarList.SortOrder = Enum.SortOrder.LayoutOrder
    SideBarList.Parent = SideBar

    -- CONTENT CONTAINER
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(0, 360, 0, 285)
    ContentContainer.Position = UDim2.new(0, 150, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local InterfacciaEngine = { tabs = {}, tabButtons = {}, primaTab = nil, activeDropdownContainer = nil, activeDropdownFrame = nil }

    -- FUNZIONE: NOTIFICA TOAST
    function Library:Notifica(titolo, messaggio, durata)
        durata = durata or 4
        local NotificationStorage = ScreenGui:FindFirstChild("NotificationStorage")
        if not NotificationStorage then
            NotificationStorage = Instance.new("Frame")
            NotificationStorage.Name = "NotificationStorage"
            NotificationStorage.Size = UDim2.new(0, 250, 0, 400)
            NotificationStorage.Position = UDim2.new(1, -260, 1, -410)
            NotificationStorage.BackgroundTransparency = 1
            NotificationStorage.Parent = ScreenGui

            local layout = Instance.new("UIListLayout")
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            layout.Padding = UDim.new(0, 8)
            layout.Parent = NotificationStorage
        end

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(1, 0, 0, 60)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        NotifFrame.Parent = NotificationStorage

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = NotifFrame

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(150, 255, 0)
        stroke.Parent = NotifFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 20)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextColor3 = Color3.fromRGB(150, 255, 0)
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = titolo:upper()
        titleLabel.Parent = NotifFrame

        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -20, 0, 30)
        msgLabel.Position = UDim2.new(0, 10, 0, 22)
        msgLabel.BackgroundTransparency = 1
        msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        msgLabel.Font = Enum.Font.SourceSans
        msgLabel.TextSize = 12
        msgLabel.TextWrapped = true
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextYAlignment = Enum.TextYAlignment.Top
        msgLabel.Text = messaggio
        msgLabel.Parent = NotifFrame

        task.spawn(function()
            task.wait(durata)
            local info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(NotifFrame, info, {BackgroundTransparency = 1}):Play()
            TweenService:Create(titleLabel, info, {TextTransparency = 1}):Play()
            TweenService:Create(msgLabel, info, {TextTransparency = 1}):Play()
            local sTween = TweenService:Create(stroke, info, {Transparency = 1})
            sTween:Play()
            sTween.Completed:Connect(function() NotifFrame:Destroy() end)
        end)
    end

    -- STRUTTURA: CREA TAB
    function InterfacciaEngine:CreaTab(name, order)
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = name .. "Tab"
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
        contentFrame.ScrollBarThickness = 3
        contentFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 255, 0)
        contentFrame.Visible = false
        contentFrame.ClipsDescendants = true
        contentFrame.Parent = ContentContainer

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 6)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = contentFrame

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)

        self.tabs[name] = contentFrame

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 120, 0, 32)
        tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabBtn.Font = Enum.Font.SourceSansSemibold
        tabBtn.TextSize = 13
        tabBtn.Text = "  " .. name
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.LayoutOrder = order
        tabBtn.Parent = SideBar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Thickness = 1
        btnStroke.Color = Color3.fromRGB(40, 40, 40)
        btnStroke.Parent = tabBtn

        if not self.primaTab then self.primaTab = name end

        tabBtn.MouseButton1Click:Connect(function()
            if self.activeDropdownFrame then
                self.activeDropdownFrame.Visible = false
                self.activeDropdownFrame.Size = UDim2.new(1, 0, 0, 0)
                self.activeDropdownContainer.Size = UDim2.new(0.95, 0, 0, 35)
                self.activeDropdownFrame = nil
                self.activeDropdownContainer = nil
            end
            for tName, frame in pairs(self.tabs) do frame.Visible = (tName == name) end
            for bName, btn in pairs(self.tabButtons) do
                if bName == name then
                    btn.BackgroundColor3 = Color3.fromRGB(150, 255, 0)
                    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
        end)

        self.tabButtons[name] = tabBtn
        return contentFrame
    end

    -- ELEMENTO: SEZIONE
    function InterfacciaEngine:AggiungiSezione(parentTab, text)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.95, 0, 0, 25)
        container.BackgroundTransparency = 1
        container.Parent = parentTab

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(150, 255, 0)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = "—— " .. text:upper() .. " ——"
        label.Parent = container

        return container
    end

    -- ELEMENTO: PARAGRAFO
    function InterfacciaEngine:AggiungiParagrafo(parentTab, titoloTesto, corpoTesto)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.95, 0, 0, 60)
        container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        container.Parent = parentTab

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = container

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(40, 40, 40)
        stroke.Parent = container

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 20)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextColor3 = Color3.fromRGB(150, 255, 0)
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = titoloTesto:upper()
        titleLabel.Parent = container

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -20, 1, -25)
        textLabel.Position = UDim2.new(0, 10, 0, 22)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        textLabel.Font = Enum.Font.SourceSans
        textLabel.TextSize = 11
        textLabel.TextWrapped = true
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.TextYAlignment = Enum.TextYAlignment.Top
        textLabel.Text = corpoTesto
        textLabel.Parent = container

        textLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
            container.Size = UDim2.new(0.95, 0, 0, textLabel.TextBounds.Y + 35)
        end)

        return container
    end

    -- ELEMENTO: BUTTON
    function InterfacciaEngine:AggiungiButton(parentTab, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansSemibold
        btn.TextSize = 13
        btn.Text = text
        btn.Parent = parentTab

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Thickness = 1
        btnStroke.Color = Color3.fromRGB(150, 255, 0)
        btnStroke.Parent = btn

        btn.MouseButton1Click:Connect(function()
            callback()
        end)

        return btn
    end

    -- ELEMENTO: TOGGLE
    function InterfacciaEngine:AggiungiToggle(parentTab, titleText, descText, defaultState, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.95, 0, 0, 48)
        container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        container.Parent = parentTab

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = container
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(40, 40, 40)
        stroke.Parent = container

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.7, 0, 0, 20)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Font = Enum.Font.SourceSansSemibold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = titleText
        titleLabel.Parent = container

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.7, 0, 0, 18)
        descLabel.Position = UDim2.new(0, 10, 0, 23)
        descLabel.BackgroundTransparency = 1
        descLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
        descLabel.Font = Enum.Font.SourceSans
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Text = descText
        descLabel.Parent = container

        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 42, 0, 22)
        toggleBg.Position = UDim2.new(1, -52, 0.5, -11)
        toggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleBg.Parent = container

        local toggleBgCorner = Instance.new("UICorner")
        toggleBgCorner.CornerRadius = UDim.new(1, 0)
        toggleBgCorner.Parent = toggleBg

        local toggleBall = Instance.new("Frame")
        toggleBall.Size = UDim2.new(0, 16, 0, 16)
        toggleBall.Position = UDim2.new(0, 3, 0, 3)
        toggleBall.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        toggleBall.Parent = toggleBg

        local toggleBallCorner = Instance.new("UICorner")
        toggleBallCorner.CornerRadius = UDim.new(1, 0)
        toggleBallCorner.Parent = toggleBall

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.Parent = container

        local state = defaultState
        local function updateVisual()
            toggleBg.BackgroundColor3 = state and Color3.fromRGB(150, 255, 0) or Color3.fromRGB(40, 40, 40)
            toggleBall.Position = state and UDim2.new(0, 23, 0, 3) or UDim2.new(0, 3, 0, 3)
            toggleBall.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
        end

        updateVisual()
        clickBtn.MouseButton1Click:Connect(function()
            state = not state
            updateVisual()
            callback(state)
        end)

        return container
    end

    -- ELEMENTO: DROPDOWN
    function InterfacciaEngine:AggiungiDropdown(parentTab, options, defaultText, callback)
        local dropContainer = Instance.new("Frame")
        dropContainer.Size = UDim2.new(0.95, 0, 0, 35)
        dropContainer.BackgroundTransparency = 1
        dropContainer.ClipsDescendants = true
        dropContainer.Parent = parentTab

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size = UDim2.new(1, 0, 0, 35)
        dropBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        dropBtn.TextColor3 = Color3.fromRGB(150, 255, 0)
        dropBtn.Font = Enum.Font.SourceSansBold
        dropBtn.TextSize = 13
        dropBtn.Text = "  " .. defaultText:upper() .. "  ▼"
        dropBtn.TextXAlignment = Enum.TextXAlignment.Left
        dropBtn.Parent = dropContainer

        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 6)
        dropCorner.Parent = dropBtn
        
        local dropStroke = Instance.new("UIStroke")
        dropStroke.Thickness = 1
        dropStroke.Color = Color3.fromRGB(50, 50, 50)
        dropStroke.Parent = dropBtn

        local dropListFrame = Instance.new("ScrollingFrame")
        dropListFrame.Name = "DropList"
        dropListFrame.Size = UDim2.new(1, 0, 0, 0)
        dropListFrame.Position = UDim2.new(0, 0, 0, 38)
        dropListFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        dropListFrame.Visible = false
        dropListFrame.ScrollBarThickness = 3
        dropListFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 255, 0)
        dropListFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
        dropListFrame.Parent = dropContainer
        
        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0, 6)
        dCorner.Parent = dropListFrame

        local dStroke = Instance.new("UIStroke")
        dStroke.Thickness = 1
        dStroke.Color = Color3.fromRGB(150, 255, 0)
        dStroke.Parent = dropListFrame

        local dropLayout = Instance.new("UIListLayout")
        dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
        dropLayout.Parent = dropListFrame

        for i, val in ipairs(options) do
            local opt = Instance.new("TextButton")
            opt.Size = UDim2.new(1, 0, 0, 30)
            opt.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            opt.TextColor3 = Color3.fromRGB(255, 255, 255)
            opt.Font = Enum.Font.SourceSans
            opt.TextSize = 12
            opt.Text = "   " .. tostring(val.Text or val)
            opt.TextXAlignment = Enum.TextXAlignment.Left
            opt.LayoutOrder = i
            opt.Parent = dropListFrame

            opt.Activated:Connect(function()
                dropBtn.Text = "  " .. tostring(val.Text or val):upper() .. "  ▼"
                dropListFrame.Visible = false
                dropListFrame.Size = UDim2.new(1, 0, 0, 0)
                dropContainer.Size = UDim2.new(0.95, 0, 0, 35)
                InterfacciaEngine.activeDropdownFrame = nil
                InterfacciaEngine.activeDropdownContainer = nil
                callback(val.Value or val)
            end)
        end

        dropBtn.Activated:Connect(function()
            if dropListFrame.Visible then
                dropListFrame.Visible = false
                dropListFrame.Size = UDim2.new(1, 0, 0, 0)
                dropContainer.Size = UDim2.new(0.95, 0, 0, 35)
                InterfacciaEngine.activeDropdownFrame = nil
                InterfacciaEngine.activeDropdownContainer = nil
            else
                if InterfacciaEngine.activeDropdownFrame and InterfacciaEngine.activeDropdownFrame ~= dropListFrame then
                    InterfacciaEngine.activeDropdownFrame.Visible = false
                    InterfacciaEngine.activeDropdownFrame.Size = UDim2.new(1, 0, 0, 0)
                    InterfacciaEngine.activeDropdownContainer.Size = UDim2.new(0.95, 0, 0, 35)
                end
                
                dropListFrame.Visible = true
                local altezzaLista = math.min(#options * 30, 120)
                dropListFrame.Size = UDim2.new(1, 0, 0, altezzaLista)
                dropContainer.Size = UDim2.new(0.95, 0, 0, 35 + altezzaLista + 5)
                
                InterfacciaEngine.activeDropdownFrame = dropListFrame
                InterfacciaEngine.activeDropdownContainer = dropContainer
            end
        end)
    end

    -- ELEMENTO: SLIDER
    function InterfacciaEngine:AggiungiSlider(parentTab, titleText, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.95, 0, 0, 50)
        container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        container.Parent = parentTab

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = container

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.7, 0, 0, 20)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Font = Enum.Font.SourceSansSemibold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = titleText
        titleLabel.Parent = container

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.25, 0, 0, 20)
        valueLabel.Position = UDim2.new(0.7, 10, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextColor3 = Color3.fromRGB(150, 255, 0)
        valueLabel.Font = Enum.Font.SourceSansBold
        valueLabel.TextSize = 13
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Text = tostring(default)
        valueLabel.Parent = container

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(0.9, 0, 0, 6)
        sliderBg.Position = UDim2.new(0.05, 0, 0.7, 0)
        sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBg.Parent = container

        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(1, 0)
        sliderBgCorner.Parent = sliderBg

        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(150, 255, 0)
        sliderFill.Parent = sliderBg

        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(1, 0)
        sliderFillCorner.Parent = sliderFill

        local dragging = false
        local function update(input)
            local percentage = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            local value = math.floor(min + ((max - min) * percentage))
            valueLabel.Text = tostring(value)
            callback(value)
        end

        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        return container
    end

    -- ELEMENTO: TEXTBOX
    function InterfacciaEngine:AggiungiTextBox(parentTab, titleText, placeholderText, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.95, 0, 0, 45)
        container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        container.Parent = parentTab

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = container

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Font = Enum.Font.SourceSansSemibold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = titleText
        titleLabel.Parent = container

        local boxContainer = Instance.new("Frame")
        boxContainer.Size = UDim2.new(0.5, 0, 0, 26)
        boxContainer.Position = UDim2.new(0.5, -10, 0.5, -13)
        boxContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        boxContainer.Parent = container

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 4)
        boxCorner.Parent = boxContainer

        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, -10, 1, 0)
        textBox.Position = UDim2.new(0, 5, 0, 0)
        textBox.BackgroundTransparency = 1
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        textBox.PlaceholderText = placeholderText
        textBox.Text = ""
        textBox.Font = Enum.Font.SourceSans
        textBox.TextSize = 12
        textBox.TextXAlignment = Enum.TextXAlignment.Left
        textBox.ClearTextOnFocus = false
        textBox.Parent = boxContainer

        textBox.FocusLost:Connect(function(enterPressed)
            callback(textBox.Text, enterPressed)
        end)

        return container
    end

    -- ELEMENTO: KEYBIND
    function InterfacciaEngine:AggiungiKeybind(parentTab, titleText, defaultKey, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.95, 0, 0, 40)
        container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        container.Parent = parentTab

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = container

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Font = Enum.Font.SourceSansSemibold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = titleText
        titleLabel.Parent = container

        local bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.new(0, 80, 0, 24)
        bindBtn.Position = UDim2.new(1, -90, 0.5, -12)
        bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        bindBtn.TextColor3 = Color3.fromRGB(150, 255, 0)
        bindBtn.Font = Enum.Font.SourceSansBold
        bindBtn.TextSize = 12
        bindBtn.Text = defaultKey.Name
        bindBtn.Parent = container

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 4)
        bCorner.Parent = bindBtn

        local currentKey = defaultKey
        local listening = false

        bindBtn.MouseButton1Click:Connect(function()
            listening = true
            bindBtn.Text = "..."
            bindBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                currentKey = input.KeyCode
                bindBtn.Text = currentKey.Name
                bindBtn.TextColor3 = Color3.fromRGB(150, 255, 0)
                callback(currentKey, false)
            elseif not listening and input.KeyCode == currentKey then
                callback(currentKey, true)
            end
        end)

        return container
    end

    -- AUTO-OPEN FIRST TAB
    task.spawn(function()
        task.wait(0.2)
        if self.primaTab and self.tabs[self.primaTab] then
            self.tabs[self.primaTab].Visible = true
            local btn = self.tabButtons[self.primaTab]
            if btn then
                btn.BackgroundColor3 = Color3.fromRGB(150, 255, 0)
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end)

    return InterfacciaEngine
end

return Library
