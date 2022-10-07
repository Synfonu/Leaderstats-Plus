local lsp = require(game:GetService("ServerScriptService").LeaderstatsPlus)
lsp:setDataValues({
    Cash = 100;
})


--

game:GetService("Players").PlayerAdded:Connect(function(player)
    local playerData = lsp(player)

    local currentCash = player:GetAttribute("Cash")
    player:SetAttribute("Cash", currentCash + 100)
end)