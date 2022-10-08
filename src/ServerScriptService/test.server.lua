local lsp = require(game:GetService("ServerScriptService").LeaderstatsPlus)
local players = game:GetService("Players")

lsp:setDataValues({Cash = 0})
players.PlayerAdded:Connect(function(player) lsp(player) end)

game.Workspace.Part.Touched:Connect(function(hit: Part) 
    if hit.Parent:IsA("Model") and hit.Parent:FindFirstChild("Humanoid") then
        local character = hit.Parent
        local player = players:GetPlayerFromCharacter(character)
        local currentCash = player:GetAttribute("Cash")

        player:SetAttribute("Cash", currentCash + 100)
    end
end)