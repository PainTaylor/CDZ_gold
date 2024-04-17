setDefaultTab("Cave")

macro(100, 'Check Armor', function()
  if storage.timecheck < now then
  storage.timecheck = now + 60000
  g_game.look(getInventoryItem(SlotBody))
end
end)

UI.TextEdit(storage.mindurability or "80", function(widget, newText)
storage.mindurability = newText
end)

Backincave = macro(200, '100%',function()end)

UI.Separator()

-- Cavebot by otclient@otclient.ovh
-- visit http://bot.otclient.ovh/

setDefaultTab("Cave")

macro(200, 'safe hunt', function()
if hppercent() < 50 then
CaveBot.setOff()
end
if hppercent() == 100 and manapercent() == 100 then
CaveBot.setOn()
end
end)


CaveBot = {} -- global namespace
CaveBot.Extensions = {}
importStyle("/cavebot/cavebot.otui")
importStyle("/cavebot/config.otui")
importStyle("/cavebot/editor.otui")
importStyle("/cavebot/supply.otui")
dofile("/cavebot/actions.lua")
dofile("/cavebot/config.lua")
dofile("/cavebot/editor.lua")
dofile("/cavebot/example_functions.lua")
dofile("/cavebot/recorder.lua")
dofile("/cavebot/walking.lua")
-- in this section you can add extensions, check extension_template.lua
--dofile("/cavebot/extension_template.lua")
dofile("/cavebot/depositer.lua")
dofile("/cavebot/supply.lua")
-- main cavebot file, must be last
dofile("/cavebot/cavebot.lua")