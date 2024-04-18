setDefaultTab("Cave")

onKeyDown(function(keys)
  if keys == 'F12' then
    if CaveBot.isOn() then
      CaveBot.setOff()
      TargetBot.setOff()
    else
      CaveBot.setOn()
      TargetBot.setOn()
    end
  end
end)

storage.durability = nil

onTextMessage(function(mode, text)
local _, startIndex = text:find('Durability: ');
local endIndex, _ = text:find('It');
if text:find('Durability') and endIndex then
  durabilityPercentage = text:sub(startIndex, endIndex-4);
  storage.durability = tonumber(durabilityPercentage)
end
if text:find('Durability') and text:find('Broken') then
storage.durability = 0
end
end)

storage.timecheck = now

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

local logoutDeaths = 5  -- numero de mortes
if type(storage["death"]) ~= "table" then storage["death"] = { count = 0 } end
local deathCount = storage["death"].count
UI.Separator()
deathLabel = UI.Label("Death count: " .. deathCount)

if deathCount >= logoutDeaths then
  CaveBot:setOff()
  schedule(5000, function()
  storage["death"].count = 0
  end)
end

if deathCount >= 4 then
  deathLabel:setColor("red")
elseif deathCount >= 2 then
  deathLabel:setColor("orange")
else
  deathLabel:setColor("green")
end

UI.Button("Reset Deaths", function()
  storage["death"].count = 0
  deathLabel:setText("Death count: " .. storage["death"].count)
  deathLabel:setColor("green")
end )

local macroDeathCount = macro(1000, "Death Counter", function()

for i, rootW in pairs(g_ui.getRootWidget():getChildren()) do
  if rootW:getText() == "You are dead" then
    storage["death"].count = storage["death"].count + 1
    deathLabel:setText("Death count: " .. storage["death"].count)
    modules.client_entergame.CharacterList.doLogin()
    end
  end
end)

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


--info('Loaded Cave')