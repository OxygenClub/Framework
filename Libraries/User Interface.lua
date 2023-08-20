repeat wait() until Utility

local Library = {
    Theme = {
        ["Text"] = Services.NewRGB(200, 200, 200),
    },
    ThemeInstances = {},
    ThemeMap = {},
    Instances = {},
} do
    function Library:New(type: string, properties: table, instances: table)
        properties = properties or {}

        local Obj = Utility:NewInstance(type, properties, self.Instances)

        if instances then
            table.insert(instances, Obj)
        end

        return Obj
    end

    function Library:AddTheme(instance: userdata, properties: table)
        local Data = {
            Instance = instance,
            Properties = properties,
            Index = #self.ThemeInstances + 1,
        }

        for _,v in next, Data.Properties do
            if type(v) == "string" then
                Data.Instance[_] = self.Theme[v]
            else
                Data.Instance[_] = v()
            end
        end

        table.insert(self.ThemeInstances, Data)
        self.ThemeMap[instance] = Data
    end

    function Library:UpdateTheme()
        for _,v in next, self.ThemeInstances do
            for i,a in next, v.Properties do
                if type(a) == "string" then
                    v.Instance[i] = self.Theme[a]
                else
                    v.Instance[i] = a()
                end
            end
        end
    end
end

return Library