local Loader = {
    Workspace = "Framework",
    Names = {
        ["User Interface"] = "Library",
    },
    Ignored = {
        ["Loader.lua"] = "Loader",
        ["Ignore"] = "Ignore",
    },
    FilesLoaded = {},
} do
    function Loader:GetFiles(files: table)
        local UnpackedFiles = {}

        for _,v in next, files do
            local File = v:match(".*\\(.*)")

            if self.Ignored[File] then
                continue
            end

            if not isfolder(v) and not File:find(".lua") then
                continue
            end

            if isfolder(v) then
                local NewFiles = self:GetFiles(listfiles(v)) or {}
                
                for _,v in next, NewFiles do
                    table.insert(UnpackedFiles, v)
                end
            else
                table.insert(UnpackedFiles, v)
            end
        end

        return UnpackedFiles
    end

    function Loader:RunFiles(files: table)
        for _,v in next, files do
            local File = v:match(".*\\(.*)"):gsub(".lua", "")
            local FileName = self.Names[File] or File

            -- // i do this bcuz we do 'repeat wait()' in the scripts
            task.spawn(function()
                local HasErrored, Message = pcall(function()
                    getgenv()[FileName] = loadstring(readfile(v))()
                    self.FilesLoaded[FileName] = FileName
                end)

                if not HasErrored then
                    print(("\n[Loader]: An error has occurred!\n   File: %s,\n   File Name: %s,\n   Message: %s."):format(v, FileName, Message))
                else
                    print(("\n[Loader]: Successfully loaded!\n   File: %s,\n   File Name: %s."):format(v, FileName))
                end
            end)
        end
    end

    function Loader:Run(files: table)
        local NewFiles = self:GetFiles(files)

        if NewFiles then
            print("\n[Loader]: Initializing.")
            self:RunFiles(NewFiles)
        end
    end
end

getgenv()["Loader"] = Loader

if Utility then
    Utility:Unload()
end

Loader:Run(listfiles(Loader.Workspace))