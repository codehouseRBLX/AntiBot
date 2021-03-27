--[[
                 _   _ ____        _   
     /\         | | (_)  _ \      | |  
    /  \   _ __ | |_ _| |_) | ___ | |_ 
   / /\ \ | '_ \| __| |  _ < / _ \| __|
  / ____ \| | | | |_| | |_) | (_) | |_ 
 /_/    \_\_| |_|\__|_|____/ \___/ \__|
                                       
        The easiest way to keep scam bots out of your game - Created by lxgh1lxy

This script is what powers AntiBot. To get started, please scroll down, and modify the settings to your liking.
	
Thanks for using AntiBot!
]]--


--[[
 ____  ____  ____  ____  __  __ _   ___  ____ 
/ ___)(  __)(_  _)(_  _)(  )(  ( \ / __)/ ___)
\___ \ ) _)   )(    )(   )( /    /( (_ \\___ \
(____/(____) (__)  (__) (__)\_)__) \___/(____/
]]--
local kickIfScam = true -- Kick the user that is said to be a bot
local warnIfScam = true -- Print a message to the console if there is a user that is said to be a bot
local alertUsersIfScam = false -- Tell the rest of the players in the server if a scam bot was found
local canBanBots = true -- If it bans 
local removeMessages = true -- Remove the scam messages if a user is found to be a bot. Suggested to be on 
local individualHighNumber = 1 -- If there are this number messages or more marked as scam, the user will face the desired punishments (THE LOWER THE NUMBER THE FASTER THE SYSTEM WILL WORK)
local totalHighNumber = 0.4 -- If the total scam score is greater than or equal to this number, the user will face the desired punishments (THE LOWER THE NUMBER THE FASTER THE SYSTEM WILL WORK)
local method = "total" -- The meathod that controls how the AI tabulates the data
-- "total" - Adds up the scam and not scam score, and checks to see if it's higher than the number (the one you put under "totalHighNumber")
-- "individual" - Checks how many of the scam messages were sent
local APIurl = "https://antibot.codehouse.repl.co" -- Do not change unless you known what you are doing

--[[
  ___  __  ____  ____ 
 / __)/  \(    \(  __)
( (__(  O )) D ( ) _) 
 \___)\__/(____/(____)
]]--
-- // Variables
local MessageCache, PlayerData, BannedIds = {}, {}, {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HashLib = require(script:WaitForChild("HashLib"))
local Sha1 = HashLib.sha1
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
if not ChatService:GetChannel("All") then
	while true do
		local ChannelName = ChatService.ChannelAdded:Wait()
		if ChannelName == "All" then
			break
		end
	end
end

local AntibotNotification = ChatService:AddSpeaker("Anti-Bot Notification")
AntibotNotification:JoinChannel("All")
AntibotNotification:SetExtraData("NameColor", Color3.fromRGB(234, 0, 0))
AntibotNotification:SetExtraData("ChatColor", Color3.fromRGB(255, 255, 255))

for _, v in ipairs(Players:GetPlayers()) do
	PlayerData[v] = {TotalAreScams = 0, TotalAreNotScams = 0}
end

-- When a player joins
Players.PlayerAdded:Connect(function(Plr)
	if BannedIds[Plr.UserId] then
		Plr:Kick("AntiBot\nYou have been banned from the server due to scam messages.\nIf you belive this is a mistake contact the game creator.")
		return
	end

	PlayerData[Plr] = {TotalAreScams = 0, TotalAreNotScams = 0}
end)

-- // Functions
local function Punish(Plr, Scams, NotScams)
	if kickIfScam and Plr.MembershipType == Enum.MembershipType.None then
		if canBanBots and Plr.AccountAge < 12 then
			table.insert(BannedIds, Plr.UserId)
		end
		Plr:Kick("AntiBot\nYou have been kicked from the server due to scam messages.\nIf you belive this is a mistake contact the game creator.")
	end
	if warnIfScam then
		warn("AntiBot || "..Plr.Name.." has been flagged by the auto bot detection system. || MORE INFO: Scam Likelihood: "..tostring(Scams).." | Not A Scam Likelihood: "..tostring(NotScams))
	end
	if alertUsersIfScam then
		AntibotNotification:SayMessage(Plr.Name.." has been flagged by the auto bot detection system.", "All")
	end
end

local function ValidateMessage(sender, message)
	local Plr = ChatService:GetSpeaker(sender):GetPlayer()
	if not Plr or string.sub(message, 1, 3) == "/e " then
		return false
	end

	local NotScams, Scams = 0, 0
	local MessageHash = Sha1(string.lower(message))
	if MessageCache[MessageHash] then
		NotScams, Scams = unpack(MessageCache[MessageHash])
	else
		local bodyData = {
			name = Plr.Name,
			id = Plr.UserId,
			chats = {message},
			timeInGame = 5
		}
		
		local Body
		local Success = xpcall(function()
			Body = HttpService:JSONDecode(HttpService:RequestAsync({Url = APIurl.."/new", Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(bodyData)}).Body)	
		end, function(Err)
			warn("An error occured while trying to connect to the anti-bot API. Reason: ", Err)
		end)

		if Success and Body and Body.Data and #Body.Data >= 1 then
			NotScams, Scams = Body.Data[1].notscam, Body.Data[1].scam
		end

		MessageCache[MessageHash] = {NotScams, Scams}
	end


	if method == "total" and Scams + PlayerData[Plr].TotalAreScams >= totalHighNumber or Scams >= individualHighNumber then
		if method == "total" then
			PlayerData[Plr].TotalAreScams, PlayerData[Plr].TotalAreNotScams = Scams, NotScams
		end
		if Plr then
			Punish(Plr, Scams, NotScams)
		end
		
		return true
	end

	return false
end

local function Run(ChatService)
	local function applyExtraFilters(sender, message, channelName)
		if ValidateMessage(sender, message) then
			ChatService:GetSpeaker(sender):SendMessage("Your message was detected as scam".. (removeMessages and " and was not sent" or "") .. ". If you belive this is a mistake contact the game creator.", "All", AntibotNotification.Name)

			return removeMessages
		end

		return false
	end

	ChatService:RegisterProcessCommandsFunction("applyExtraFilters", applyExtraFilters)
end

return Run
