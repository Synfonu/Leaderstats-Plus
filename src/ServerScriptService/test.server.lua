local lsp = require(game:GetService("ServerScriptService").LeaderstatsPlus)
lsp:setDataValues({
    ["Emoji"] = "😻";
    ["Cash"] = 100;
})

lsp:setPrefix("Emoji", "-")
lsp:setPrefix("Cash", "$")

local emojis = {"😀","😁","😂","🤣","😃","😄","😅","😗","🤨","🤔","🤩","🤗","🙂","☺","😚","😙","😐","😑","😶","🙄","😏","😣","😥","😮"}

game.Players.PlayerAdded:Connect(function(player)
    lsp(player)

    while player do
        player:SetAttribute("Emoji", emojis[math.random(#emojis)])
        player:SetAttribute("Cash", math.random(1000000,5000000))
       task.wait(1)
    end
end)