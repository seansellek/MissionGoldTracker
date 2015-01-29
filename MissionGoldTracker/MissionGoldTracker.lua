local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("GARRISON_MISSION_BONUS_ROLL_COMPLETE"); -- Fired when bonuse reward earned/not earned


function frame:OnEvent(event, arg1, arg2) --Main Function. Initializes variables on first run and listens and responds to gold-rewarding missions being successfully completed.
 if event == "ADDON_LOADED" and arg1 == "MissionGoldTracker" then
  -- SavedVariables should be loaded at this point, following IF statements check if they exist and initialize them if they don't
  if mgt_totalGold == nil then
   mgt_totalGold = 0; 
  end
  if mgt_beginDate == nil then
   mgt_beginDate = date("*t");
  end
  if type(mgt_beginDate) == "string" then --converts old "string" date to new date table
  	local pattern = "(%d+)/(%d+)/(%d+)"
    local xyear, xmonth, xday = mgt_beginDate:match(pattern)
    local convertedTimestamp = time({year = xyear, month = xmonth, 
        day = xday})
  	mgt_beginDate = date("*t", convertedTimestamp);
  end
 elseif event == "GARRISON_MISSION_BONUS_ROLL_COMPLETE" and arg2 then --Listens for successful mission completion
    for mgt_id, mgt_reward in pairs(mgt_goldMissions) do 
        if mgt_id == arg1 then -- Checks if mission completed rewards gold
            mgt_totalGold= mgt_totalGold + mgt_reward; -- Adds mission's gold reward to the total
        end
    end
 end
end

function goldPerWeek(beginDate, goldEarned) -- Function to calculate income in gold per week
    local timePassed = time() - time(beginDate); -- Calculates seconds passed since beginDate 
    local weeksPassed = timePassed*0.0000115741/7; -- converts seconds into days, then weeks
    local income = goldEarned/weeksPassed; -- Gold/Week
    return GetCoinTextureString(income);
end

frame:SetScript("OnEvent", frame.OnEvent); -- Responds to /mgt
SLASH_MISSIONGOLDTRACKER1 = "/mgt";
function SlashCmdList.MISSIONGOLDTRACKER(msg)
 print("You've earned " .. GetCoinTextureString(mgt_totalGold) .. " or " .. goldPerWeek(mgt_beginDate,mgt_totalGold) .. " per week on garrison missions ssince " .. date("%m/%d/%y",time(mgt_beginDate)) .. ".");
end