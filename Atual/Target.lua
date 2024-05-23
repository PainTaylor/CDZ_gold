setDefaultTab("Target")
TargetBot.getCurrentProfile = function()
  return storage._configs.targetbot_configs.selected
end

local botConfigName = modules.game_bot.contentsPanel.config:getCurrentOption().text
TargetBot.setCurrentProfile = function(name)
  if not g_resources.fileExists("/bot/"..botConfigName.."/targetbot_configs/"..name..".json") then
    return warn("there is no targetbot profile with that name!")
  end
  TargetBot.setOff()
  storage._configs.targetbot_configs.selected = name
  TargetBot.setOn()
end
TargetBot = {} -- global namespace
importStyle("/targetbot/looting.otui")
importStyle("/targetbot/target.otui")
importStyle("/targetbot/creature_editor.otui")
dofile("/targetbot/creature.lua")
dofile("/targetbot/creature_attack.lua")
dofile("/targetbot/creature_editor.lua")
dofile("/targetbot/creature_priority.lua")
dofile("/targetbot/looting.lua")
dofile("/targetbot/walking.lua")
-- main targetbot file, must be last
dofile("/targetbot/target.lua")

--info('Loaded Target')