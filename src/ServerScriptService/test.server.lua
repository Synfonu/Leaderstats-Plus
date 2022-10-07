local lsp = require(game:GetService("ServerScriptService").LeaderstatsPlus)
lsp:setDataValues({
    Cash = 1000
})


--

game:GetService("Players").PlayerAdded:Connect(function(player)
    local playerData = lsp(player)

    task.wait(3)

    local currentCash = player:GetAttribute("Cash")
    player:SetAttribute("Cash", 500)
end)