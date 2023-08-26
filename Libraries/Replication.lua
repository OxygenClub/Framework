repeat wait() until Utility and Connection

local Replication = {
    Players = {},
    PlayerAdded = Connection:New(),
    LocalPlayer = nil,
}

-- // I did everything to make this fast LOL
local Next = next

function GetRootPart(humanoid: userdata)
    if not humanoid then
        return
    end

    return humanoid.RootPart
end

function IsAlive(player: userdata)
    local Character = player.Character

    if not Character then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return false
    end

    local Health = Humanoid.Health
    if Health <= 0 then
        return false
    end

    local RootPart = GetRootPart(Humanoid)
    if not RootPart then
        return
    end

    return true
end

Utility:Connect(Services.RunService.RenderStepped, function()
    for _,v in Next, Replication.Players do
        local NewTable = {
            Player = _,
        }

        local Player = NewTable.Player

        if NewTable.Player.Character then
            NewTable.Character = NewTable.Player.Character
        end

        if NewTable.Character and NewTable.Character:FindFirstChildOfClass("Humanoid") then
            NewTable.Humanoid = NewTable.Character:FindFirstChildOfClass("Humanoid")
        end

        if NewTable.Humanoid then
            NewTable.RootPart = GetRootPart(NewTable.Humanoid)
        end

        NewTable.Status = IsAlive(Player)
        
        if Player == Services.LocalPlayer then
            Replication.LocalPlayer = Replication.Players[Player]
        end

        Replication.Players[Player] = NewTable
    end
end)

for _,v in Next, Services.Players:GetPlayers() do
    Replication.Players[v] = {
        Player = v,
    }
end

Utility:Connect(Services.Players.PlayerAdded, function(player)
    Replication.Players[player] = {
        Player = player,
    }

    Replication.PlayerAdded:Fire(Replication.Players[player])
end)

Utility:Connect(Services.Players.PlayerRemoving, function(player)
    Replication.Players[player] = nil
end)

return Replication