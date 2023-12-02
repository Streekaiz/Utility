local Library = {
    Drawings = {},
    Instances = {},
    Connections = {},
    Client = {
        FPS = 0,
        Ping = 0,
        Memory = 0
    }
}

function Library:Get(String)
    if string.find(String, "https://") then
        return loadstring(game:HttpGet(String, true))()
    else
        return game:GetService(String)
    end
end

function Library:Connect(Type, Function)
    local Connection = Type:Connect(Function); table.insert(Library.Connections, Connection)

    return Connection
end

function Library:Draw(Type, Properties)
    local Drawing = Drawing.new(Type); table.insert(Library.Drawings, Drawing)
    for i, v in next, Properties do
        Drawing[i] = v
    end
    return Drawing
end

function Library:Instance(Type, Properties)
    local Instance = Instance.new(Type)
    for i, v in next, Properties do
        Instance[i] = v 
    end
    return Instance
end

function Library:ChangeProperties(Object, Properties)
    for i, v in next, Properties do 
        Object[i] = v 
    end
end

function Library:GetPlayers()
    local Players = {} 
    for i, v in next Utility:Get("Players"):GetPlayers() do 
        if v == Utility:Get("Players").LocalPlayer then 
            return 
        end 
        table.insert(Players, v) 
    end
    return Players
end

function Library:GetClosestTarget()
    local Distance = math.huge
    local Target
        for _, v in next, Library:Get("Players"):GetPlayers() do
            if v ~= Library:Get("Players").LocalPlayer and Library:IsAlive(v) then
                local Position,OnScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local Magnitude = (Vector2.new(Position.X, Position.Y) - Vector2.new(Library:Get("Players").LocalPlayer:GetMouse().X, Library:Get("Players").LocalPlayer:GetMouse().Y)).magnitude
                --
                if Magnitude < Distance and OnScreen then
                        Target = Player
                        Distance = Magnitude
                    end
                end
            end 
    return Target
end

function Library:GetClient(Object, Target)
    local Player = Target or 
    if Object == "Name" then
        return Utility:Get("Players").LocalPlayer.Name
    elseif Object == "Display" then
        return Utility:Get("Players").LocalPlayer.DisplayName
    elseif Object == "Humanoid" and Library:IsAlive(Utility:Get("Players").LocalPlayer) then
        return Utility:Get("Players").LocalPlayer.Character.Humanoid
    elseif Object == "HumanoidRootPart" and Library:IsAlive(Utility:Get("Players").LocalPlayer) then
        return Utility:Get("Players").LocalPlayer.Character.HumanoidRootPart
    elseif Object == "Character" and Library:IsAlive(Utility:Get("Players").LocalPlayer) then
        return Utility:Get("Players").LocalPlayer.Character
    elseif Object == "Health" and Library:IsAlive(Utility:Get("Players").LocalPlayer) then
        return Utility:Get("Players").LocalPlayer.Character.Humanoid.Health
    end
end

function Library:GetIcon(Name)
    Name = Name:lower()

    for i, v in next, loadstring(game:HttpGet("https://pastebin.com/raw/HU5xCuxp", true))() do
        if string.find(i, Name) then
            return v
        end
    end
end

function Library:IsFriendly(Player)
    return Player.Team == Utility:Get("Players").LocalPlayer.Team
end

function Library:IsAlive(Player)
    if Player:FindFirstChild("Character") then
        if Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Humanoid").Health > 0 then
            return true
        end
    end
    
    return false
end

function Library:Unload()
    for i, v in next, Library.Drawings do
        v:Remove()
    end

    for i, v in next, Library.Instances do
        v:Destroy()
    end

    for i, v in next, Library.Connections do
        v:Disconnect()
    end
end

Library:Connect(Library:Get("RunService").RenderStepped, function(delta)
    Library.Client.FPS = 1 / delta

end)
