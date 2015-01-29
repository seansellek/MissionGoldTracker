local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("GARRISON_MISSION_BONUS_ROLL_COMPLETE"); -- Fired when bonuse reward earned/not earned


function frame:OnEvent(event, arg1, arg2)
 if event == "ADDON_LOADED" and arg1 == "MissionGoldTracker" then
  -- Our saved variables are ready at this point. If there are none, both variables will set to nil.
  if mgt_totalGold == nil then
   mgt_totalGold = 0; -- This is the first time this addon is loaded; initialize the count to 0.
  end
  if mgt_beginDate == nil then
   mgt_beginDate = date("%m/%d/%y");
  end
 elseif event == "GARRISON_MISSION_BONUS_ROLL_COMPLETE" and arg2 then
    for id, reward in pairs(m) do
        if id == arg1 then
            mgt_totalGold= mgt_totalGold + reward;
        end
    end
 end
end

frame:SetScript("OnEvent", frame.OnEvent);
SLASH_MISSIONGOLDTRACKER1 = "/mgt";
function SlashCmdList.MISSIONGOLDTRACKER(msg)
 print("You've earned " .. GetCoinTextureString(mgt_totalGold) .. " since " .. mgt_beginDate);
end