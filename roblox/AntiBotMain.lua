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
local warnIfScam = false -- Print a message to the console if there is a user that is said to be a bot
local alertUsersIfScam = false -- Tell the rest of the players in the server if a scam bot was found
local removeMessages = false -- Remove the scam messages if a user is found to be a bot
local individualHighNumber = 1 -- If there are this number messages or more marked as scam, the user will face the desired punishments (THE LOWER THE NUMBER THE FASTER THE SYSTEM WILL WORK)
local totalHighNumber = 0.4 -- If the total scam score is greater than or equal to this number, the user will face the desired punishments (THE LOWER THE NUMBER THE FASTER THE SYSTEM WILL WORK)
local meathod = "total" -- The meathod that controls how the AI tabulates the data
-- "total" - Adds up the scam and not scam score, and checks to see if it's higher than the number (the one you put under "totalHighNumber")
-- "individual" - Checks how many of the scam messages were sent

--[[
  ___  __  ____  ____ 
 / __)/  \(    \(  __)
( (__(  O )) D ( ) _) 
 \___)\__/(____/(____)
]]--
-- Variables
local http = game:GetService('HttpService')
local url = "https://antibot.codehouse.repl.co"

-- When a player joins
game:GetService("Players").PlayerAdded:Connect(function(plr)
	local id = plr.UserId
	local name = plr.Name
	local messages = {}
	local time = 1
	
-- Chats
	plr.Chatted:Connect(function(msg)
		table.insert(messages, msg)
	end)
	
-- Time in game
	--local start = tick()
	--while plr.Parent do
	--	time = time + (tick() - start)
	--	start = tick()
	--	wait()
	--end
	
-- Get our data in a table
	local bodyData = {
		name = name,
		id = id,
		chats = messages,
		timeInGame = time
	}	
	
-- Make our request
while wait(5) do
	if plr then	
		local request = http:RequestAsync({Url = url.."/new", Method="POST", Headers = {["Content-Type"] = "application/json"}, Body = http:JSONEncode(bodyData)})	
			-- If got a successful response
			local totalScam = 0
			local totalNotScam = 0
			local totalAreScams = 0
		
			if request["StatusCode"] == 200 then
				local data = http:JSONDecode(request["Body"])
					if data.data ~= nil and #data.data >= 1 then
						for i = 1, #data.data do
							if data.data[i].scam ~= nil or data.data[i].notscam ~= nil then
								if meathod == "total" then
								totalScam = totalScam + data.data[i].scam
								totalNotScam = totalNotScam + data.data[i].notscam
								if totalScam >= totalHighNumber then
									if kickIfScam then
										plr:Kick("AntiBot \n You have been flagged by our auto bot detection system")
										return
									end
									if warnIfScam then
										warn("AntiBot || "..plr.Name.." has been flagged by the auto bot detection system. || MORE INFO: Scam Likelihood: "..tostring(data.data[i].scam).." | Not A Scam Likelihood: "..tostring(data.data[i].notscam))
										return
									end
									if alertUsersIfScam then
										local ChatService = require(game:GetService("ServerScriptService"):WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
							
										if not ChatService:GetChannel("All") then
											while true do
											local ChannelName = ChatService.ChannelAdded:Wait()
											if ChannelName == "All" then
												break
												end
											end
										end
						
										local noti = ChatService:AddSpeaker("AntiBot Notification")
										noti:JoinChannel("All")

										noti:SetExtraData("NameColor", Color3.fromRGB(41, 255, 6))
										noti:SetExtraData("ChatColor", Color3.fromRGB(255, 255, 204))

										noti:SayMessage(plr.Name.." has been flagged by the auto bot detection system.", "All")
						
										return
									end
								 end
								elseif meathod == "individual" then
									if data.data[i].scam > data.data[i].notscam then
									totalAreScams = totalAreScams + 1
									if totalAreScams >= individualHighNumber then
										if kickIfScam then
											plr:Kick("AntiBot \n You have been flagged by our auto bot detection system")
											return
										end
										if warnIfScam then
											warn("AntiBot || "..plr.Name.." has been flagged by the auto bot detection system. || MORE INFO: Scam Likelihood: "..tostring(data.data[i].scam).." | Not A Scam Likelihood: "..tostring(data.data[i].notscam))
											return
										end
										if alertUsersIfScam then
											local ChatService = require(game:GetService("ServerScriptService"):WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))

											if not ChatService:GetChannel("All") then
												while true do
													local ChannelName = ChatService.ChannelAdded:Wait()
													if ChannelName == "All" then
														break
													end
												end
											end

											local noti = ChatService:AddSpeaker("AntiBot Notification")
											noti:JoinChannel("All")
	
											noti:SetExtraData("NameColor", Color3.fromRGB(41, 255, 6))
											noti:SetExtraData("ChatColor", Color3.fromRGB(255, 255, 204))

											noti:SayMessage(plr.Name.." has been flagged by the auto bot detection system.", "All")

											return
										end
									end
								end 
							end 
						end
					end
				end
			end
		end
	end
end)
