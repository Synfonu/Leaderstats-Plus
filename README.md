# Leaderstats Plus

Leaderstats Plus is a simple service designed to make Data saving and leaderstats easier
than ever to use. With built-in data saving and leaderstats, you don't need to worry
about making your own systems to manage this stuff.

Utilising [ProfileService](https://github.com/MadStudioRoblox/ProfileService), Leaderstats Plus is safe from possible data loss and stress of other DataStore issues.

# How to Install
### Rojo
To install Leaderstats Plus with Rojo, head into the [ServerScriptService](https://github.com/Synfonu/Leaderstats-Plus/tree/master/src/ServerScriptService) folder download the LeaderstatsPlus folder into your ServerScriptService directory.

### Roblox
To install Leaderstats Plus with Roblox, download the [latest release](https://github.com/Synfonu/Leaderstats-Plus/releases) rbxm file and import it into Roblox Studio.

# Usage
[Example Code](https://github.com/Synfonu/Leaderstats-Plus/blob/master/src/ServerScriptService/test.server.lua)
```lua
local leaderstatsPlus = require(game:GetService("ServerScriptService").LeaderstatsPlus)
leaderstatsPlus:setDataValues({Cash = 100})

game:GetService("Players").PlayerAdded:Connect(function(player)
    local playerData = leaderstatsPlus(player)
    
    local currentCash = player:GetAttribute("Cash")
    player:SetAttribute("Cash", currentCash + 100) -- Login Bonus
end)
```
You should edit leaderstats by doing `player:SetAttribute(leaderstatName: string, newValue: any)` rather than editing the leaderstat value directly; editing it directly would work, it is not recommended.
