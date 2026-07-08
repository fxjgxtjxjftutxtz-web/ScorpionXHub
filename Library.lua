local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Library:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = "ScorpionX_GUI"
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 250, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 170, 0)
    
    -- Dragging Logic
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, -30, 0, 40)
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 170, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    
    local MinBtn = Instance.new("TextButton", MainFrame)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -35, 0, 5)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local min = false
    MinBtn.MouseButton1Click:Connect(function()
        min = not min
        MainFrame:TweenSize(min and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 400), "Out", "Quart", 0.3)
    end)

    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -10, 1, -50)
    Container.Position = UDim2.new(0, 5, 0, 45)
    Container.BackgroundTransparency = 1
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)
    
    return Container
end

function Library:AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.Text = text
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
end

function Library:AddToggle(parent, text, callback)
    local Tgl = Instance.new("TextButton", parent)
    Tgl.Size = UDim2.new(1, 0, 0, 30)
    Tgl.Text = text .. ": OFF"
    Tgl.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local active = false
    Tgl.MouseButton1Click:Connect(function()
        active = not active
        Tgl.Text = text .. (active and ": ON" or ": OFF")
        Tgl.BackgroundColor3 = active and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(40, 40, 40)
        callback(active)
    end)
    Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 5)
end

function Library:AddSlider(parent, text, min, max, callback)
    local Slider = Instance.new("Frame", parent)
    Slider.Size = UDim2.new(1, 0, 0, 40)
    Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local Bar = Instance.new("Frame", Slider)
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    local Label = Instance.new("TextLabel", Slider)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Text = text
    Label.BackgroundTransparency = 1
    
    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = (input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X
            pos = math.clamp(pos, 0, 1)
            Bar.Size = UDim2.new(pos, 0, 1, 0)
            callback(math.floor(min + (max - min) * pos))
        end
    end)
    Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 5)
end

function Library:AddTextBox(parent, placeholder, callback)
    local Box = Instance.new("TextBox", parent)
    Box.Size = UDim2.new(1, 0, 0, 30)
    Box.PlaceholderText = placeholder
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Box.FocusLost:Connect(function(enterPressed)
        if enterPressed then callback(Box.Text) end
    end)
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 5)
end

function Library:Notify(title, text)
    local N = Instance.new("Frame", game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScorpionX_GUI"))
    N.Size = UDim2.new(0, 200, 0, 50)
    N.Position = UDim2.new(1, -210, 0, 10)
    N.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    local L = Instance.new("TextLabel", N)
    L.Size = UDim2.new(1,0,1,0)
    L.Text = title .. ": " .. text
    L.TextColor3 = Color3.new(1,1,1)
    task.wait(3)
    N:Destroy()
end

return Library
