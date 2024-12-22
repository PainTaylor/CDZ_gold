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

storage.timercheckarmor = now

macro(200, function()
  if storage.timercheckarmor < now then
    itemtocheck = getInventoryItem(SlotBody)
    itemdisc = itemtocheck:getTooltip()
    if itemdisc then
      startIndex = itemdisc:find('Durability: ')
      endIndex = itemdisc:find('It')
      if startIndex and endIndex then
        durabilityPercentage = itemdisc:sub(startIndex+11, endIndex-5)
        storage.durability = tonumber(durabilityPercentage)
      end
      if storage.durability == nil then
        storage.durability = 0
      end
      storage.timercheckarmor = now + 6000
    end
  end
end)

UI.TextEdit(storage.mindurability or "80", function(widget, newText)
storage.mindurability = newText
end)

Backincave = macro(200, function()end)
StopTemple = macro(200, 'SafeStop', function()
    if IsInGreeceTemple() then
        CaveBot.setOff()
    end
end)
UI.Separator()
--------------------------------------------------------
safecavebot = macro(2000, 'SafeCavebot', function()end)
CountDeath = function()
    if storage.countdeath == nil then
        storage.countdeath = 0
    end
    storage.countdeath = storage.countdeath + 1
end

cavebotdelay = function(death)
    if storage.countdeath then
        death = storage.countdeath
    end
    delay(300000 * death)
end

onTextMessage(function(mode, text)
    if safecavebot.isOff() then return end
    if text:find("You are dead") then
        CountDeath()
    end
end)

macro(200, function()
    if safecavebot.isOff() or storage.countdeath == nil then return end
    if storage.countdeath >= 5 then
        CaveBot.setOff()
    end
end)

onKeyDown(function(keys)
    if keys == 'Ctrl+0' then
        storage.countdeath = 0
    end
end)

onCreatureAppear(function(creature)
    if isinGreciaCity() then return end
    if isEnemy(creature) then
        safecavebot.setOn()
    end
end)

---------------------------------------

xth = 700
yth = 10

local widget = setupUI([[
Panel
  height: 400
  width: 900
]], g_ui.getRootWidget())

local deaths = g_ui.loadUIFromString([[
Label
  color: white
  background-color: black
  opacity: 0.85
  text-horizontal-auto-resize: true  
]], widget)

 

macro(1, function()
    if storage.countdeath then
    deaths:setColor('blue')
    deaths:setText("Deaths: " .. storage.countdeath .. ' ')
    if storage.countdeath == 4 then
    deaths:setColor('yellow')
        elseif storage.countdeath >= 5 then
    deaths:setColor('red')
    deaths:setText("Deaths: " .. storage.countdeath .. ' Press Ctrl + 0 to reset ')
end
end
end)

 

deaths:setPosition({y = yth, x =  xth})

--------------------------------------------------------------

setDefaultTab("Cave")


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


-- load all otui files, order doesn't matter
local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local configFiles = g_resources.listDirectoryFiles("/bot/" .. configName .. "/vBot", true, false)
for i, file in ipairs(configFiles) do
  local ext = file:split(".")
  if ext[#ext]:lower() == "ui" or ext[#ext]:lower() == "otui" then
    g_ui.importStyle(file)
  end
end

local function loadScript(name)
  return dofile("/vBot/" .. name .. ".lua")
end

-- here you can set manually order of scripts
-- libraries should be loaded first
local luaFiles = {
  --"main",
  --"items",
  "vlib",
  "new_cavebot_lib",
  --"configs", -- do not change this and above
  --"extras",
  "cavebot",
  --"playerlist",
  --"BotServer",
  --"alarms",
  --"Conditions",
  --"Equipper",
  --"pushmax",
  --"combo",
  --"HealBot",
  --"new_healer",
  --"AttackBot", -- last of major modules
  --"ingame_editor",
  --"Dropper",
  --"Containers",
  --"quiver_manager",
  --"quiver_label",
  --"tools",
  --"antiRs",
  --"depot_withdraw",
  --"eat_food",
  --"equip",
  --"exeta",
  --"analyzer",
  --"spy_level",
  --"supplies",
  --"depositer_config",
  --"npc_talk",
  --"xeno_menu",
  --"hold_target",
  --"cavebot_control_panel"
}

for i, file in ipairs(luaFiles) do
  loadScript(file)
end

--info('Loaded Cave')

schedule(300, function()
    use(storage.nhpitem)
end)

onTextMessage(function(mode, text)
    if text:find('rainbow') and text:find('Using one of') then
        storage.potaamout = tonumber(text:match('%d+'))
    end
    if text:find('Using the last') and text:find('rainbow') then
        storage.potaamout = 0
    end
end)

Potx,Poty = 100, 0


local widget = setupUI([[
Panel
  height: 400
  width: 900
]], g_ui.getRootWidget())

local ammoutpot = g_ui.loadUIFromString([[
Label
  color: white
  background-color: black
  opacity: 0.85
  text-horizontal-auto-resize: true  
]], widget)

 

macro(1, function()
    if storage.potaamout then
    if storage.potaamout and storage.potaamout >= 50 then
        ammoutpot:setColor('green')
    elseif storage.potaamout < 50 then
        ammoutpot:setColor('red')
    end
        ammoutpot:setText('Numero de Pot:  ' .. (storage.potaamout))
    end
end)
 

ammoutpot:setPosition({y = Poty+50, x =  Potx})


macro(200, 'No Pot Stop', function()
    if isInPz() and storage.potaamout == 0 then
        CaveBot.setOff()
    end
end)