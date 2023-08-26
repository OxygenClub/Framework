repeat wait() until Services

local Utility = {
    Instances = {},
    Drawings = {},
    Connections = {},
    BindToRenderSteps = {},
} do
    function Utility:NewInstance(type: string, properties: table, instances: table)
        local Obj = Services.NewInstance(type)

        properties = properties or {}
        
        for _,v in next, properties do
            Obj[_] = v
        end

        table.insert(self.Instances, Obj)

        if instances then
            table.insert(instances, Obj)
        end

        return Obj
    end

    function Utility:NewDrawing(type: string, properties: table, drawings: table)
        local Obj = Services.NewDrawing(type)

        properties = properties or {}
        
        for _,v in next, properties do
            Obj[_] = v
        end

        table.insert(self.Drawings, Obj)

        if drawings then
            table.insert(drawings, Obj)
        end

        return Obj
    end

    function Utility:Connect(signal: signal, callback: func)
        local Connection = signal:Connect(callback)

        table.insert(self.Connections, Connection)

        return Connection
    end

    function Utility:Disconnect(connection: connection)
        self.Connections[table.find(self.Connections, connection)] = nil
        connection:Disconnect()
    end

    function Utility:Lerp(delta: int, from: int, to: int)
        if delta > 1 then
            return to
        elseif delta < 0 then
            return from
        end

        return from + (to - from) * delta
    end

    function Utility:GetRootPart(humanoid: userdata)
        if not humanoid then
            return
        end

        return humanoid.RootPart
    end

    function Utility:IsAlive(player: userdata)
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

        local RootPart = Utility:GetRootPart(Humanoid)
        if not RootPart then
            return
        end

        return true
    end

    function Utility:GetDistance(from: vector, to: vector)
        return (from - to).Magnitude
    end

    function Utility:CFrameToVector3(cframe: cframe)
        return Services.NewVector3(cframe.X, cframe.Y, cframe.Z)
    end

    function Utility:GetCase(text: string, case: string)
        if case:lower() == "uppercase" then
            return text:upper()
        elseif case:lower() == "lowercase" then
            return text:lower()
        else
            return text
        end
    end
    
    function Utility:Default(tbl: table, values: table)
        for _,v in next, values do
            if tbl[_] == nil then
                tbl[_] = v
            end
        end
    end

    function Utility:Unload()
        for _,v in next, self.Instances do
            v:Destroy()
        end

        for _,v in next, self.Drawings do
            v:Remove()
        end

        for _,v in next, self.Connections do
            v:Disconnect()
        end

        for _,v in next, self.BindToRenderSteps do
            Services.RunService:UnbindFromRenderStep(v)
        end

        for _,v in next, Loader.FilesLoaded do
            getgenv()[v] = nil
        end

        return 0
    end
end

return Utility