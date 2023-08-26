repeat wait() until Utility

local Connection = {}

function Connection:New()
    local CustomEvent = {}
    local Listeners = {}
    
    function CustomEvent:Connect(callback: func)
        local Connection = {
            Callback = callback,
            Disconnect = function()
                for _,v in next, Listeners do
                    if v == Connection then
                        table.remove(v, _)
                        break
                    end
                end
            end
        }
        table.insert(Listeners, Connection)
        return Connection
    end
    
    function CustomEvent:Fire(...)
        for _,v in next, Listeners do
            v.Callback(...)
        end
    end
    
    return CustomEvent
end

return Connection