local lsp = require(game:GetService("ServerScriptService").LeaderstatsPlus)
lsp:setDataValues({Cash = 0})
lsp:setPrefix("Cash", "$")

game.Players.PlayerAdded:Connect(function(player)
    lsp(player)

    while player do
        player:SetAttribute("Cash", player:GetAttribute("Cash") + 10000)
       task.wait()
    end
end)