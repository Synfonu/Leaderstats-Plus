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

local CoreSettings = {
    KickMessage = "We failed to load your data, please rejoin and try again.";

    Key = "LP_%s";
    DataName = "MdXIQwIHW8"; -- Changing this will reset ALL saved data! ⚠;
}

local MainValues = {}
local Prefixes = {}
local AlreadySetValues = false

---

-- Function by @Dev_Ryan
local letters = {"K","M","B","T","q","Q","s","S","O","N","d","U","D"}
local function formatNumber(n)
    if typeof(n) ~= "number" then return n end

    if not tonumber(n) then return n end
    if n < 10000 then return math.floor(n) end
    local d = math.floor(math.log10(n)/3)*3
    local s = tostring(n/(10^d)):sub(1,5)
    return s..tostring(letters[math.floor(d/3)])
end

--

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
            
                    player:SetAttribute(dataName, value)
                    local val = Instance.new("StringValue")
                    val.Name = dataName
                    val.Parent = leaderstats

                    if Prefixes[dataName] ~= nil then
                        val.Value = Prefixes[dataName]..formatNumber(player:GetAttribute(dataName))
                    else
                        val.Value = formatNumber(player:GetAttribute(dataName))
                    end

                    player:GetAttributeChangedSignal(dataName):Connect(function()
                        if Prefixes[dataName] ~= nil then
                            val.Value = Prefixes[dataName]..formatNumber(player:GetAttribute(dataName))
                        else
                            val.Value = formatNumber(player:GetAttribute(dataName))
                        end

                        Profile.Data[dataName] = player:GetAttribute(dataName)
                    end)

                    val:GetPropertyChangedSignal("Value"):Connect(function()
                        local trueValue = tostring(player:GetAttribute(dataName))
                        local stringValue = trueValue:sub(1)

                        warn(stringValue, trueValue)

                        if trueValue ~= stringValue then
                            error("[LeaderstatsPlus]: Leaderstats were changed unexpectedly, you must use player:SetAttribute(valueName).")
                        end
                    end)

                    total += 1
                end

                if total > 4 then
                    warn("[LeaderstatsPlus]: You have registered "..total.."/4 values. Roblox Leaderstats only support 4 values.")
                end

                return self
            else
                Profile:Release()
            end
        else
            player:Kick(CoreSettings.KickMessage)
        end
    end
end

function LeaderstatsPlus:setPrefix(valName, pref)
    pref = tostring(pref)

    if MainValues[valName] ~= nil and pref ~= nil and (pref:len() > 1) == false then
        Prefixes[valName] = pref
    elseif (pref:len() > 1) == true then
        error("[LeaderstatsPlus]: Your prefix for "..valName.." is too long! Limit is 1 character.")
    end
end


return LeaderstatsPlus