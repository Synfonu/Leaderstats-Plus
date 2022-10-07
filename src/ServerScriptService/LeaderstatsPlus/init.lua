--[[

    ❓ Leaderstats Plus is a simple service designed to make Data saving and leaderstats easier
    than ever to use. With built-in data saving and leaderstats, you don't need to worry
    about making your own systems to manage this stuff.

    📁 Leaderstats Plus is registered with MIT license, you can find more information on LICENSE
    file in the GitHub repository: https://github.com/Synfonu/EasyStat
    
    🛑 It is recommended that you don't edit this file unless you fully understand what you are 
    doing. If anything goes wrong, please create an issue: https://github.com/Synfonu/Leaderstats-Plus/issues/new

--]]

local Oops = require(script.Oops)
local ProfileService = require(script.ProfileService)
local Players = game:GetService("Players")

local ProfileStore = nil
local LeaderstatsPlus = Oops.class{}

local CoreSettings = { -- These can either be edited here or with the :Set() function.
    KickMessage = "We failed to load your data, please rejoin and try again.";

    Key = "LP_%s";
    DataName = "MdXIQwIHW8"; -- Changing this will reset ALL saved data! ⚠
}

local MainValues = {}
local AlreadySetValues = false

---

function LeaderstatsPlus:setDataValues(values: table)    
    if AlreadySetValues then
        error("[LeaderstatsPlus]: You cannot run :setDataValues() more than once!")
        return
    end

    AlreadySetValues = true

    if typeof(values) == "table" then
        for dataName, defaultValue in pairs(values) do
            MainValues[dataName] = defaultValue
        end
    end

    ProfileStore = ProfileService.GetProfileStore("MdXIQwIHW8", MainValues)
end

function LeaderstatsPlus:__init(player: Player)
    self.Key = string.format(CoreSettings.Key, tostring(player.UserId))
    self.Player = player

    if MainValues == {} then
        error("[LeaderstatsPlus]: Values not set!")
        return false
    else
        local Profile = ProfileStore:LoadProfileAsync(self.Key)

        if Profile ~= nil then
            Profile:AddUserId(player.UserId)
            Profile:Reconcile()
            Profile:ListenToRelease(function()
                self = nil
                player:Kick(CoreSettings.KickMessage)
            end)

            if player:IsDescendantOf(Players) == true then
                self.Profile = Profile
                local leaderstats = player:FindFirstChild("leaderstats") or Instance.new("Folder")
                leaderstats.Name = "leaderstats"
                leaderstats.Parent = player

                local total = 0

                for dataName, value in pairs(Profile.Data) do
                    if total > 4 then continue end
                              
                    if MainValues[dataName] == nil then
                        Profile.Data[dataName] = nil
                        continue
                    end
            
                    local val = Instance.new("StringValue")
                    val.Name = dataName
                    val.Value = tostring(value)
                    val.Parent = leaderstats

                    player:SetAttribute(dataName, value)

                    player:GetAttributeChangedSignal(dataName):Connect(function()
                        val.Value = tostring(player:GetAttribute(dataName))
                        Profile.Data[dataName] = player:GetAttribute(dataName)
                    end)

                    val:GetPropertyChangedSignal("Value"):Connect(function()
                        if val.Value ~= tostring(player:GetAttribute(dataName)) then
                            -- unregistered leaderstat change
                            warn("[LeaderstatsPlus]: Leaderstats were changed unexpectedly, in future please use player:SetAttribute().")
                            player:SetAttribute(dataName, val.Value)
                        end
                    end)

                    total += 1
                end

                if total > 4 then
                    warn("[LeaderstatsPlus]: You have registered "..total.."/4 values. Roblox Leaderstats only support 4 values.")
                end
            else
                Profile:Release()
            end
        else
            player:Kick(CoreSettings.KickMessage)
        end
    end
end

return LeaderstatsPlus