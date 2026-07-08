function Library:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScorpionX_GUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 300, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Nero profondo
    
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = name -- Qui apparirà "Scorpion X Hub"
    Title.TextColor3 = Color3.fromRGB(255, 170, 0) -- Giallo scorpione
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.BackgroundTransparency = 1
    
    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 12)
    
    -- Effetto bordo
    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(255, 170, 0)
    UIStroke.Thickness = 2
    
    return MainFrame
end
