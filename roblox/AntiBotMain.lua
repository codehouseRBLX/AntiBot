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
local filterInsteadOfHide = true -- The message will be displayed as "[Content Deleted]" instead of just disappearing. Only works if removeMessages is on. This is more efficient and the chat will load faster.

local individualHighNumber = 1 -- If there are this number messages or more marked as scam, the user will face the desired punishments (THE LOWER THE NUMBER THE FASTER THE SYSTEM WILL WORK)
local totalHighNumber = 0.4 -- If the total scam score is greater than or equal to this number, the user will face the desired punishments (THE LOWER THE NUMBER THE FASTER THE SYSTEM WILL WORK)

local method = "total" -- The meathod that controls how the AI tabulates the data
-- "total" - Adds up the scam and not scam score, and checks to see if it's higher than the number (the one you put under "totalHighNumber")
-- "individual" - Checks how many of the scam messages were sent




-- // Do not change the ones below unless you known what you are doing!
local API_URL = "https://antibot.codehouse.repl.co" -- If you are self hosting the anti bot change the url to yours
local MAX_FILTER_RETRIES = 3
local FILTER_BACKOFF_INTERVALS = {.5, 1, 3}
local MAX_FILTER_DURATION = 25
--- Constants used to decide when to notify that the chat filter is having issues filtering messages.
local FILTER_NOTIFCATION_THRESHOLD = 3 --Number of notifcation failures before an error message is output.
local FILTER_NOTIFCATION_INTERVAL = 60 --Time between error messages.
local FILTER_THRESHOLD_TIME = 60 --If there has not been an issue in this many seconds, the count of issues resets.


--[[
  ___  __  ____  ____ 
 / __)/  \(    \(  __)
( (__(  O )) D ( ) _) 
 \___)\__/(____/(____)
]]--
-- // Variables
local MessageCache, PlayerData, BannedIds, ChatLocalization = {}, {}, {}, nil
local HttpService, Players, ServerScriptService, RunService = game:GetService("HttpService"), game:GetService("Players"), game:GetService("ServerScriptService"), game:GetService("RunService")
local HashLib, ChatService = require(script:WaitForChild("HashLib")), require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
local Sha1 = HashLib.sha1
pcall(function() ChatLocalization = require(game:GetService("Chat"):FindFirstChild("ClientChatModules"):FindFirstChild("ChatLocalization")) end)
if ChatLocalization == nil then ChatLocalization = {} end
if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization:FormatMessageToSend(_, Str) return Str end
end
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
		Plr:Kick("AntiBot\nYou have been banned from the server due to scam messages.\nIf you belive this is a mistake, please contact the game creator.")
		return
	end

	PlayerData[Plr] = {TotalAreScams = 0, TotalAreNotScams = 0}
end)

-- // Functions
local function Punish(Plr, Scams, NotScams)
	if kickIfScam and Plr.MembershipType == Enum.MembershipType.None then
		if canBanBots and Plr.AccountAge < 12 then
			BannedIds[Plr.UserId] = true
		end
		Plr:Kick("AntiBot\nYou have been kicked from the server due to scam messages.\nIf you belive this is a mistake, please contact the game creator.")
	end
	if warnIfScam then
		warn("AntiBot || "..Plr.Name.." has been flagged by the auto bot detection system. || MORE INFO: Scam Likelihood: "..tostring(Scams).." | Not A Scam Likelihood: "..tostring(NotScams))
	end
	local SystemChannel = ChatService:GetChannel("System")
	if alertUsersIfScam and SystemChannel then
		SystemChannel:SendSystemMessage(Plr.Name.." has been flagged by the auto bot detection system.", {ChatColor = Color3.fromRGB(255, 255, 255)})
	end
end

local LastFilterNoficationTime, LastFilterIssueTime, FilterIssueCount = 0
local function OnFilterFail()
	if (time() - LastFilterIssueTime) > FILTER_THRESHOLD_TIME then FilterIssueCount = 0 end

	FilterIssueCount += 1
	LastFilterIssueTime = time()
	local systemChannel = ChatService:GetChannel("System")
	if systemChannel and FilterIssueCount >= FILTER_NOTIFCATION_THRESHOLD and (time() - LastFilterNoficationTime) > FILTER_NOTIFCATION_INTERVAL then
		LastFilterNoficationTime = time()
		systemChannel:SendSystemMessage(
			ChatLocalization:FormatMessageToSend(
				"GameChat_ChatService_ChatFilterIssues",
				"The chat filter is currently experiencing issues and messages may be slow to appear."
			)
			errorExtraData
		)
	end
end

local function ValidateMessage(sender, message, channelName)
	local Speaker = ChatService:GetSpeaker(sender)
	local Plr = Speaker:GetPlayer()
	if not Plr or string.sub(message, 1, 3) == "/e " or not RunService:IsServer() or RunService:IsStudio() then
		return false
	end

	local NotScams, Scams = 0, 0
	local MessageHash = Sha1(string.lower(message))
	if MessageCache[MessageHash] then
		NotScams, Scams = unpack(MessageCache[MessageHash])
	else
		local bodyData = {
			chats = {message}
		}

		local Success, Body, Start, Tries = false, nil, os.clock(), 0
		repeat
			Start, Tries = os.clock(), Tries + 1
			local Success = xpcall(function()
				Body = HttpService:JSONDecode(HttpService:RequestAsync({Url = API_URL.."/new", Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(bodyData)}).Body)	
			end, function(Err)
				warn("An error occured while trying to connect to the anti-bot API. Reason: ", Err)
			end)
		until (Success or Tries > MAX_FILTER_RETRIES) or wait(FILTER_BACKOFF_INTERVALS[math.min(#FILTER_BACKOFF_INTERVALS, Tries)]) and false

		if Success and Body and Body.data and #Body.data >= 1 then
			NotScams, Scams = Body.data[1].notscam, Body.data[1].scam
			if Start - os.clock() > MAX_FILTER_DURATION then OnFilterFail() end
		else
			OnFilterFail()
		end

		MessageCache[MessageHash] = {NotScams, Scams}
	end


	if method == "total" and Scams > NotScams and Scams + PlayerData[Plr].TotalAreScams >= totalHighNumber or Scams > NotScams and Scams >= individualHighNumber then
		if method == "total" then
			PlayerData[Plr].TotalAreScams, PlayerData[Plr].TotalAreNotScams = Scams, NotScams
		end
		if Plr then
			Speaker:SendSystemMessage("Your message was detected as scam".. (removeMessages and " and was not sent" or "") .. ". If you belive this is a mistake, please contact the game creator.", "All")
			Punish(Plr, Scams, NotScams)
		end

		return true
	end

	return false
end

local function Run(ChatService)
	local function checkMessageAntiBot(sender, message, channelName)
		if not removeMessages then
			coroutine.wrap(pcall)(ValidateMessage, sender, message, channelName)
		elseif ValidateMessage(sender, message, channelName) then
			return true
		end

		return false
	end

	local function filterMessageASync(sender, messageObject, channelName)
		if ValidateMessage(sender, messageObject.Message, channelName) then
			messageObject.Message = "[ Content Deleted ]"
		end
	end

	if filterInsteadOfHide and removeMessages then
		ChatService:RegisterFilterMessageFunction("AntiBotMessageCheckFilter", filterMessageASync)
	else
		ChatService:RegisterProcessCommandsFunction("AntiBotMessageCheck", checkMessageAntiBot)
	end
end

return Run
