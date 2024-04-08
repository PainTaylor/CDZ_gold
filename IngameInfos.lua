setDefaultTab("Main")

onTextMessage(function(mode, text)
  if text:find('Completo') then
    if text:find('Graad') then
      quest = 'graad'
    end
    if text:find('Cassius') then
      quest = 'cassios'
    end
    if text:find('Soldier') then
      quest = 'soldier'
    end
    if text:find('Daichi') then
      quest = 'daichi'
    end
  end
end)



onTalk(function(name, level, mode, text, channelId, pos)
if name == 'Grande Mestre' and text:find('faltam') then
  if text:find('Cassius') then
    actualquest = 'cassios'
  end
  if text:find('Soldiers') then
    actualquest = 'soldier'
  end
  if text:find('Daichi') then
    actualquest = 'daichi'
  end
  if text:find('Graad') then
    actualquest = 'graad'
  end
end
end)

local privateTabs = addSwitch("openPMTabs", "PM Tabs", function(widget) widget:setOn(not widget:isOn()) storage.OpenPrivateTabs = widget:isOn() end, parent)
privateTabs:setOn(storage.OpenPrivateTabs)

onTalk(function(name, level, mode, text, channelId, pos)
    if mode == 4 and privateTabs:isOn() then
        local g_console = modules.game_console
        local privateTab = g_console.getTab(name)
        if privateTab == nil then
            privateTab = g_console.addTab(name, true)
            g_console.addPrivateText(g_console.applyMessagePrefixies(name, level, text), g_console.SpeakTypesSettings['private'], name, false, name)
            playSound("/sounds/Private Message.ogg")
        end
        return
    end
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if (name ~= 'Blessing') then return; end              
  if (mode ~= 51) then return; end
  if (text:find('deseja comprar {bless}?')) then
    schedule(500, function()
      NPC.say('yes')
  end)
  end
  if (text:find('da bless vai ser')) then
    schedule(500, function()
      NPC.say('yes')
  end)
    info('pass1')
  end
end);



onTalk(function(name, level, mode, text, channelId, pos)
  if (name ~= 'Mu [Durability]') then return; end              
  if (mode ~= 51) then return; end
  if (text:find('posso restaurar a durabilidade dos seus itens. Basta me dizer qual slot gostaria de restaurar')) then
    schedule(500, function()
      NPC.say('tudo')
  end)
    schedule(1000, function()
      NPC.say('yes')
  end)
  end
end);

onTalk(function(name, level, mode, text, channelId, pos)
  if (name ~= 'Merchant') then return; end              
  if (mode ~= 51) then return; end
  if (text:find('he')) then
    schedule(500, function()
      NPC.say('trade')
  end)
  end
end);




storage.durability = nil
onTextMessage(function(mode, text)
local _, startIndex = text:find('Arm:');
local endIndex, _ = text:find(',');
local _, efistartIndex = text:find('Durability: ');
local efiendIndex, _ = text:find('It');
  if text:find('You see a') and startIndex and endIndex then
    storage.ActualArm = tonumber(text:sub(startIndex+1, endIndex-1))
    if (text:find('dubhe')) and text:find('Arm:') then
      storage.BaseArm = 245
    end
    if (text:find('sereia')) and text:find('Arm:') then
      storage.BaseArm = 265
    end
    if (text:find('touro')) and text:find('Arm:') then
      storage.BaseArm = 265
    end
    if (text:find('cancer')) and text:find('Arm:') then
      storage.BaseArm = 270
    end
    if (text:find('peixes')) and text:find('Arm:') then
      storage.BaseArm = 270
    end
    if (text:find('chrysaor')) and text:find('Arm:') then
      storage.BaseArm = 270
    end
    if (text:find('aquario')) and text:find('Arm:') then
      storage.BaseArm = 275
    end
    if (text:find('kraken')) and text:find('Arm:') then
      storage.BaseArm = 280
    end
    if (text:find('capricornio')) and text:find('Arm:') then
      storage.BaseArm = 290
    end
    if (text:find('escorpiao')) and text:find('Arm:') then
      storage.BaseArm = 300
    end
    if (text:find('aries')) and text:find('Arm:') then
      storage.BaseArm = 300
    end
    if (text:find('libra')) and text:find('Arm:') then
      storage.BaseArm = 325
    end
    if (text:find('sagitario')) and text:find('Arm:') then
      storage.BaseArm = 335
    end
    if text:find('Durability') and efiendIndex then
      durabilityPercentage = text:sub(efistartIndex, efiendIndex-4);
      storage.durability = tonumber(durabilityPercentage)
    end
    storage.CalcEficience = (((storage.ActualArm*(100))/storage.BaseArm))
    storage.truearm = ((storage.ActualArm * 100)/storage.durability)
    formula = ((storage.truearm *(100))/storage.BaseArm)
    if storage.CalcEficience and storage.truearm and formula then
      info('Rare: '.. math.floor(formula) .. '%')
      info('ArmorTotal: ' .. math.floor(storage.truearm))
    end
  end
end)

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

onTextMessage(function(mode, text)
  if text:find('Task') and text:find('Completo') then
    playSound('/sounds/magnum.ogg')
      g_window.setTitle(player:getName() .. " - Task Complete")
  end
end)

onTalk(function(name, level, mode, text, channelId, pos)
if name ~= 'Grande Mestre' then return end
if text:find('Caso queira você pode tentar pegar outra missão') then
  g_window.setTitle("CDZ Gold - " .. player:getName())
end
end)

local windowUI = setupUI([[
MainWindow
  id: main
  !text: tr('Minoru Teleport by Kays')
  size: 230 310
  scrollable: true
    
  ScrollablePanel
    id: TpList
    anchors.top: parent.top
    anchors.left: parent.left
    size: 190 225
    vertical-scrollbar: mainScroll

    Button
      !text: tr('Grecia')
      anchors.top: parent.top
      anchors.left: parent.left
      width: 165

    Button
      !text: tr('North City')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('Siberia')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('Bugavila')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165
      
    Button
      !text: tr('Medusa')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('Asgard')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

  VerticalScrollBar  
    id: mainScroll
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    step: 48
    pixels-scroll: true
    
  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 15

]], g_ui.getRootWidget());
windowUI:hide();

TpMinoru = {};
local MainPanel = windowUI.main;
local TpList = windowUI.TpList;

TpMinoru.close = function()
  windowUI:hide()
  schedule(1000, function()
      NPC.say('bye');
end)
end

TpMinoru.show = function()
    windowUI:show();
    windowUI:raise();
    windowUI:focus();
end

windowUI.closeButton.onClick = function()
    TpMinoru.close();
end

TpMinoru.tpToCity = function(city)
    NPC.say(city);
    schedule(500, function()
        NPC.say('yes');
    end);
end


for i, child in pairs(TpList:getChildren()) do
    child.onClick = function()
        TpMinoru.tpToCity(child:getText())
    end
end

onTalk(function(name, level, mode, text, channelId, pos)
  if (name ~= 'Athena Travel') then return; end              
  if (mode ~= 51) then return; end
  if (text:find('Para onde gostaria de ir?')) then 
      TpMinoru.show();
  else
      TpMinoru.close();
  end
end);

onKeyDown(function(keys)
    if (keys == 'Escape' and windowUI:isVisible())  then
        TpMinoru.close();
    end
end);


talkedSpecs = {}

UI.TextEdit(storage.lider or "Blintz", function(widget, newText)
        storage.lider = newText
    end)

aviso = macro(100, 'aviso guild', function()
    for name, _ in pairs(talkedSpecs) do
        if not getCreatureByName(name) then
            talkedSpecs[name] = nil
        end
    end
    for _, spec in ipairs(getSpectators()) do
        if spec ~= player and spec:isPlayer() and not isFriend(spec) then
            if spec:getEmblem() ~= 1 then
                local specName = spec:getName()
                if not talkedSpecs[specName] and (spec:getName() ~= storage.excluido and spec:getName() ~= storage.excluido2 and spec:getName() ~= storage.excluido3 and spec:getName() ~= storage.excluido4) then
                    talkPrivate(storage.lider, specName .. " - " .. hours .. ':' .. mins .. ':' .. seconds)
                    talkedSpecs[specName] = true
                end
            end
        end
    end
end)

local function add(t, text, color, last)
  table.insert(t, text)
  table.insert(t, color)
  if not last then
    table.insert(t, ", ")
    table.insert(t, "#FFFFFF")
  end
end

local t = {}
local mt = {}

local useLoot = macro(100000, function() end)
local tabName = "Loot"
local console = modules.game_console
local tab = console.getTab(tabName) or console.addTab(tabName, true)

onTextMessage(function(mode, text)
  if useLoot.isOff() then return end
  if not text:find("Loot of") or text:find('nothing') then return end
  local msg = text:split(":")
  add(t, os.date('%H:%M') .. ' ' .. msg[1] .. ": ", "#FFFFFF", true)
  if msg[2]:find("nothing") then
    add(t, msg[2], "red", true)
  else
    add(t, msg[2], "green", true)
  end
  console.addText(text, {
    color = '#00EB00'
   }, tabName, "")
  local panel = console.consoleTabBar:getTabPanel(tab)
  local consoleBuffer = panel:getChildById('consoleBuffer')
  local message = consoleBuffer:getLastChild()
  message:setColoredText(t)
  t = {}
end)

local console = modules.game_console
onTextMessage(function(mode, text)
    if not text:find("The murder of") then return end
 -- get/create tab and write raw message
    local tabName = "Frags Register"
    local tab = console.getTab(tabName) or console.addTab(tabName, true)
    console.addText(text, console.SpeakTypesSettings, tabName, "")
 end)

onTextMessage(function(mode, text)
    if not text:find("Loot of") then return end
    if text:find('Lendario') or text:find('Epico') or text:find('Raro') or text:find('Incomum') then
 -- get/create tab and write raw message
    local tabName = "Rare Drops"
    local tab = console.getTab(tabName) or console.addTab(tabName, true)
    console.addText(text, console.SpeakTypesSettings, tabName, "")
    end
 end)

onTextMessage(function(mode, text)
    if not text:find("You lose") then return end
    if text:find('hitpoints due to an attack by') then
 -- get/create tab and write raw message
    local tabName = "Dano Recebido PVP"
    local tab = console.getTab(tabName) or console.addTab(tabName, true)
    console.addText(text, console.SpeakTypesSettings, tabName, "")
    end
 end)

onTextMessage(function(mode, text)
    if not text:find("hitpoints due to your attack") or text:find("An ") then return end
 -- get/create tab and write raw message
    local tabName = "Dano Causado PVP"
    local tab = console.getTab(tabName) or console.addTab(tabName, true)
    console.addText(text, console.SpeakTypesSettings, tabName, "")
 end)

UI.Separator()