repeat wait() until Utility --[[and Fonts]]

local Library = {
    Theme = {
        ["Text"] = Services.NewRGB(200, 200, 200),
        ["Background"] = Services.NewRGB(25, 25, 25),
        ["Content Background"] = Services.NewRGB(30, 30, 30),
        ["Border"] = Services.NewRGB(5, 5, 5),
        ["Inline"] = Services.NewRGB(55, 55, 55),
    },
    ThemeInstances = {},
    ThemeMap = {},
    Instances = {},
} do
    function Library:New(type: string, properties: table, instances: table)
        properties = properties or {}

        local Obj = Utility:NewInstance(type, {}, self.Instances)

        for _,v in next, properties do
            if _ == "Theme" then
                Library:AddTheme(Obj, v)
            else
                Obj[_] = v
            end
        end

        pcall(function()
            Obj.BorderSizePixel = 0
        end)

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

    function Library:UpdateTheme(theme: string)
        for _,v in next, self.ThemeInstances do
            for i,a in next, v.Properties do
                if type(a) == "string" then
                    if theme == nil then
                        v.Instance[i] = self.Theme[a]
                    else
                        if theme == a then
                            v.Instance[i] = self.Theme[a]
                        end
                    end
                else
                    v.Instance[i] = a()
                end
            end
        end
    end

    function Library:ChangeTheme(theme: string, color: color3)
        if self.Theme[theme] then
            self.Theme[theme] = color
        end

        Library:UpdateTheme(theme)
    end

    function Library:Window(cfg: table)
        cfg = cfg or {}

        Utility:Default(cfg, {
            Size = Services.NewUDim2(0, 400, 0, 450),
        })

        local ScreenGui = Library:New("ScreenGui", {Parent = game.CoreGui})

        local WindowOutline = Library:New("Frame", {
            Name = "WindowOutline",
            Parent = ScreenGui,
            Theme = {
                BackgroundColor3 = "Border",
            },
            Position = Services.NewUDim2(0.5, -cfg.Size.X.Offset / 2, 0.5, -cfg.Size.Y.Offset / 2),
            Size = cfg.Size,
        })
        
        local WindowInline = Library:New("Frame", {
            Name = "WindowInline",
            Parent = WindowOutline,
            Theme = {
                BackgroundColor3 = "Inline",
            },
            Position = Services.NewUDim2(0, 1, 0, 1),
            Size = Services.NewUDim2(1, -2, 1, -2),
        })
        
        local WindowInlineBackground = Library:New("Frame", {
            Name = "WindowInlineBackground",
            Parent = WindowInline,
            Theme = {
                BackgroundColor3 = "Content Background",
            },            
            Position = Services.NewUDim2(0, 1, 0, 1),
            Size = Services.NewUDim2(1, -2, 1, -2),
        })

        local PanelInline = Library:New("Frame", {
            Name = "PanelInline",
            Parent = WindowInlineBackground,
            Theme = {
                BackgroundColor3 = "Inline",
            },
            Position = Services.NewUDim2(0, 3, 0, 3),
            Size = Services.NewUDim2(1, -6, 1, -6),
        })
        
        local PanelOutline = Library:New("Frame", {
            Name = "PanelOutline",
            Parent = PanelInline,
            Theme = {
                BackgroundColor3 = "Border",
            },
            Position = Services.NewUDim2(0, 1, 0, 1),
            Size = Services.NewUDim2(1, -2, 1, -2),
        })
        
        local PanelBackground = Library:New("Frame", {
            Name = "PanelBackground",
            Parent = PanelOutline,
            Theme = {
                BackgroundColor3 = "Background",
            },
            Position = Services.NewUDim2(0, 1, 0, 1),
            Size = Services.NewUDim2(1, -2, 1, -2),
        })

        --[[local TabsInline = Library:New("Frame", {
            Name = "TabsInline",
            Parent = PanelBackground,
            Theme = {
                BackgroundColor3 = "Inline",
            },
            Position = Services.NewUDim2(0, 10, 0, 10),
            Size = Services.NewUDim2(1, -20, 0, 30),
        })
        
        local TabsBackground = Library:New("Frame", {
            Name = "TabsBackground",
            Parent = TabsInline,
            Theme = {
                BackgroundColor3 = "Content Background",
            },
            Position = Services.NewUDim2(0, 1, 0, 1),
            Size = Services.NewUDim2(1, -2, 1, -2),
        })]]
    end
end

return Library