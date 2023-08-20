local Players = game.Players
local LocalPlayer = Players.LocalPlayer

return {
    Players = Players,
    LocalPlayer = LocalPlayer,
    RunService = game.RunService,
    UserInputService = game.UserInputService,
    NewRGB = Color3.fromRGB,
    NewHSV = Color3.fromHSV,
    NewInstance = Instance.new,
    NewVector2 = Vector2.new,
    NewVector3 = Vector3.new,
    NewUDim2 = UDim2.new,
    NewUDim = UDim.new,
    NewDrawing = Drawing.new,
    HttpService = game.HttpService,
    TweenService = game.TweenService,
}