local lsp = require(game:GetService("ServerScriptService").LeaderstatsPlus)
lsp:setDataValues({
    ["Emoji"] = "๐ป";
    ["Cash"] = 100;
})

lsp:setPrefix("Emoji", "-")
lsp:setPrefix("Cash", "$")

local emojis = {"๐","๐","๐","๐คฃ","๐","๐","๐","๐","๐คจ","๐ค","๐คฉ","๐ค","๐","โบ","๐","๐","๐","๐","๐ถ","๐","๐","๐ฃ","๐ฅ","๐ฎ"}

game.Players.PlayerAdded:Connect(function(player)
    lsp(player)

    while player do
        player:SetAttribute("Emoji", emojis[math.random(#emojis)])
        player:SetAttribute("Cash", math.random(1000000,5000000))
       task.wait(1)
    end
end)