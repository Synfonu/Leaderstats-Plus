local lsp = require(game:GetService("ServerScriptService").LeaderstatsPlus)
lsp:setDataValues({
    Cash = 100;
})


--

game:GetService("Players").PlayerAdded:Connect(function(player)
    local playerData = lsp(player)
    
    task.wait(3)

    player:FindFirstChild("leaderstats"):WaitForChild("Cash").Value += 100
end)