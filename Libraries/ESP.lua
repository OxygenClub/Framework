repeat wait() until Replication and Utility

local ESP = {
    Enabled = true,

    LimitDistance = {
        Enabled = false,
        Amount = 200,   
    },

    ["Enemy"] = {},
    ["Team"] = {},
    ["Self"] = {},

    Players = {},
    FadingPlayers = {},
}

function ESP:GetFlags(player: userdata)
    local Group = "Enemy"

    if player == Services.LocalPlayer then
        Group = "Self"
    elseif player == Services.LocalPlayer.Team then
        Group = "Team"
    end

    return ESP[Group]
end

function ESP:PlayerValid(player: userdata)
    if not ESP.Enabled then
        return false
    end

    local Flags = ESP:GetFlags(player.Player)
    if not Flags.Enabled then
        return false
    end

    local LocalRootPartPosition = Replication.LocalPlayer.RootPart.Position or nil
    local RootPartPosition = player.RootPart.Position or nil
    
    if LocalRootPartPosition and RootPartPosition and self.LimitDistance.Amount > Utility:GetDistance(LocalRootPartPosition, RootPartPosition) then
        return false
    end

    return true
end

function ESP:AddPlayer(player: userdata)
    if not self.Players[player.Player] then
        local PlayerTable = {}

        local Player = player.Player

        PlayerTable.Drawings = {
            [""]
        }

        PlayerTable.Loops = {}

        PlayerTable.Loops["RenderStepped"] = Utility:Connect(Services.RunService.RenderStepped, function()
            if player.Status then
                local Character = player.Character
                local Humanoid = player.Humanoid
                local RootPart = player.RootPart

                self.FadingPlayers[Player] = {
                    Fading = false,
                    Tool = Character:FindFirstChildOfClass("Tool") or nil,
                    RootPart = {
                        Position = RootPart.Position,
                        Size = RootPart.Size,
                        CFrame = RootPart.CFrame,
                    },
                    Humanoid = {
                        Health = Humanoid.Health,
                        MaxHealth = Humanoid.MaxHealth,
                        RootPart = RootPart,
                    },
                    Tick = tick(),
                }
            end

            local FadedPlayer = self.FadingPlayers[Player] or nil

            local RootPart = FadedPlayer and FadedPlayer.RootPart or nil
            local Humanoid = FadedPlayer and FadedPlayer.Humanoid or nil

            if RootPart and Humanoid then

            end
        end)

        PlayerTable.Loops["Heartbeat"] = Utility:Connect(Services.RunService.Heartbeat, function()
        
        end)

        self.Players[player.Player] = PlayerTable
    end
end

function ESP:RemovePlayer(player: userdata)
    if self.Players[player] then
        local PlayerTable = self.Players[player]

        for _,v in next, PlayerTable.Drawings do
            if type(v) == "table" then
                v:Remove()
            else
                v:Destroy()
            end
        end

        PlayerTable.Loops["RenderStepped"]:Disconnect()
        PlayerTable.Loops["Heartbeat"]:Disconnect()

        self.Players[player] = nil
    end
end

for _,v in next, Replication.Players do
    ESP:AddPlayer(v)
end

Utility:Connect(Replication.PlayerAdded, function(player)
    ESP:AddPlayer(player)
end)

Utility:Connect(Services.Players.PlayerRemoving, function(player)
    ESP:RemovePlayer(player)
end)

return ESP