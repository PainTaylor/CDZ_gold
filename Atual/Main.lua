if not storage.timers then  storage.timers = {  time = 1 } end
local widgetTC = setupUI([[
Panel
  size: 14 14
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  Label
    id: lblTimer
    color: orange
    font: verdana-11px-rounded
    height: 12
    background-color: #00000040
    opacity: 0.87
    text-auto-resize: true
    !text: tr('00:00:00 Horas')

]], modules.game_interface.getMapPanel())

 doFormatinTime = function(v)
     hours = string.format(v['hour'])
     mins = string.format(v['min'])
     seconds = string.format(v['sec'])
    return hours .. ":" .. mins .. ":" .. seconds .. " Horas"
end
tmrMacro2 = macro(1000, function(widget)
    real_time = os.date('*t', os.time())
-----------------------------
-- CODIGO AQUI
-----------------------------
    schedule(100, function()
        tmrMacro2:setOn()
        widgetTC.lblTimer:setText(doFormatinTime(real_time))
    end)
-----------------------------
        tmrMacro2:setOff()
        return
    widgetTC.lblTimer:setText(doFormatinTime(real_time)) 
end)

onTextMessage(function(mode, text)
 for _, p in ipairs(getSpectators(posz())) do
  if p:isPlayer() and text:find(p:getName()) and text:find('attack by') then
      storage.lastattacker = p:getName()
      storage.timehours = hours
      storage.timemin = mins
      storage.timesec = seconds
  end
 end
end)

onKeyDown(function(keys)
    if keys == 'Tab' and storage.lastattacker and storage.timehours and storage.timemin and storage.timesec then
info(storage.lastattacker)
        info(storage.lastattacker .. storage.timehours .. ':' .. storage.timemin .. ':' .. storage.timesec)
    end
end)

local panelName = "alarms"
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Alarms')

  Button
    id: alerts
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit

]])
ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {}
end

local config = storage[panelName]

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
end

local window = UI.createWindow("AlarmsWindow")
window:hide()

ui.alerts.onClick = function()
  window:show()
  window:raise()
  window:focus()
end

local widgets = 
{
  "AlarmCheckBox", 
  "AlarmCheckBoxAndSpinBox", 
  "AlarmCheckBoxAndTextEdit"
}

local parents = 
{
  window.list, 
  window.settingsList
}


-- type
addAlarm = function(id, title, defaultValue, alarmType, parent, tooltip)
  local widget = UI.createWidget(widgets[alarmType], parents[parent])
  widget:setId(id)

  if type(config[id]) ~= 'table' then
    config[id] = {}
  end

  widget.tick:setText(title)
  widget.tick:setChecked(config[id].enabled)
  widget.tick:setTooltip(tooltip)
  widget.tick.onClick = function()
    config[id].enabled = not config[id].enabled
    widget.tick:setChecked(config[id].enabled)
  end

  if alarmType > 1 and type(config[id].value) == 'nil' then
    config[id].value = defaultValue
  end

  if alarmType == 2 then
    widget.value:setValue(config[id].value)
    widget.value.onValueChange = function(widget, value)
      config[id].value = value
    end
  elseif alarmType == 3 then
    widget.text:setText(config[id].value)
    widget.text.onTextChange = function(widget, newText)
      config[id].value = newText
    end
  end

end

-- settings
addAlarm("ignoreFriends", "Ignore Friends", true, 1, 2)
addAlarm("flashClient", "Flash Client", true, 1, 2)

-- alarm list
addAlarm("damageTaken", "Damage Taken", false, 1, 1)
addAlarm("lowHealth", "Low Health", 20, 2, 1)
addAlarm("lowMana", "Low Mana", 20, 2, 1)
addAlarm("playerAttack", "Player Attack", false, 1, 1)

UI.Separator(window.list)

addAlarm("privateMsg", "Private Message", false, 1, 1)
addAlarm("defaultMsg", "Default Message", false, 1, 1)
addAlarm("customMessage", "Custom Message:", "", 3, 1, "You can add text, that if found in any incoming message will trigger alert.\n You can add many, just separate them by comma.")

UI.Separator(window.list)

addAlarm("creatureDetected", "Creature Detected", false, 1, 1)
addAlarm("playerDetected", "Player Detected", false, 1, 1)
addAlarm("creatureName", "Creature Name:", "", 3, 1, "You can add a name or part of it, that if found in any visible creature name will trigger alert.\nYou can add many, just separate them by comma.")


local lastCall = now
local function alarm(file, windowText)
  if now - lastCall < 2000 then return end -- 2s delay
  lastCall = now

  if not g_resources.fileExists(file) then
    file = "/sounds/alarm.ogg"
    lastCall = now + 4000 -- alarm.ogg length is 6s
  end

  
  if modules.game_bot.g_app.getOs() == "windows" and config.flashClient.enabled then
    g_window.flash()
  end
  g_window.setTitle(player:getName() .. " - " .. windowText)
  playSound(file)
end

-- damage taken & custom message
onTextMessage(function(mode, text)
  if not config.enabled then return end
  if mode == 22 and config.damageTaken.enabled then
    return alarm('/sounds/magnum.ogg', "Damage Received!")
  end

  if config.customMessage.enabled then
    local alertText = config.customMessage.value
    if alertText:len() > 0 then
      text = text:lower()
      local parts = string.split(alertText, ",")

      for i=1,#parts do
        local part = parts[i]
        part = part:trim()
        part = part:lower()

        if text:find(part) then
          return alarm('/sounds/magnum.ogg', "Special Message!")
        end
      end
    end
  end
end)

-- default & private message
onTalk(function(name, level, mode, text, channelId, pos)
  if not config.enabled then return end
  if name == player:getName() then return end -- ignore self messages
  if config.ignoreFriends.enabled and isFriend(name) then return end -- ignore friends if enabled

  if mode == 1 and config.defaultMsg.enabled then
    return alarm("/sounds/magnum.ogg", "Default Message!")
  end

  if mode == 4 and config.privateMsg.enabled then
    return alarm("/sounds/Private_Message.ogg", "Private Message!")
  end
end)

-- health & mana
macro(100, function() 
  if not config.enabled then return end
  if config.lowHealth.enabled then
    if hppercent() < config.lowHealth.value then
      return alarm("/sounds/Low_Health.ogg", "Low Health!")
    end
  end

  if config.lowMana.enabled then
    if hppercent() < config.lowMana.value then
      return alarm("/sounds/Low_Mana.ogg", "Low Mana!")
    end
  end

  for i, spec in ipairs(getSpectators()) do
    if not spec:isLocalPlayer() and not (config.ignoreFriends.enabled and isFriend(spec)) then

      if config.creatureDetected.enabled then
        return alarm("/sounds/magnum.ogg", "Creature Detected!")
      end

      if spec:isPlayer() then 
        if spec:isTimedSquareVisible() and config.playerAttack.enabled then
          return alarm("/sounds/Player_Attack.ogg", "Player Attack!")
        end
        if config.playerDetected.enabled then
          return alarm("/sounds/Player_Detected.ogg", "Player Detected!")
        end
      end

      if config.creatureName.enabled then
        local name = spec:getName():lower()
        local fragments = string.split(config.creatureName.value, ",")
        
        for i=1,#fragments do
          local frag = fragments[i]:trim():lower()

          if name:lower():find(frag) then
            return alarm("/sounds/alarm.ogg", "Special Creature Detected!")
          end
        end
      end
    end
  end
end)

UI.Separator()

--[[
  configuration for check players
  example made on server Gunzodus

  example link for player overview:
  https://www.gunzodus.net/character/show/Sir_Vithrax

  *note that space in character name was replaced with underscore (_) - this character will be important

  in this case:
  link = "https://www.gunzodus.net/character/show/" -- everything with all the characters up to the start of the name
  spacing = "_" -- space replacement in character name
]]

local link = "https://www.gunzodus.net/character/show/"
local spacing = "_"



-- do not edit below

local tabs = {"Friends", "Enemies", "BlackList"}
local panelName = "playerList"
local colors = {"#03C04A", "#fc4c4e", "orange"}

if not storage[panelName] then
    storage[panelName] = {
      enemyList = {},
      friendList = {},
      blackList = {},
      groupMembers = true,
      outfits = false,
      marks = false,
      highlight = false
    }
end

local config = storage[panelName]
local playerTables = {config.friendList, config.enemyList, config.blackList}

-- functions
local function clearCachedPlayers()
  CachedFriends = {}
  CachedEnemies = {}
end

local refreshStatus = function()
    for _, spec in ipairs(getSpectators()) do
      if spec:isPlayer() and not spec:isLocalPlayer() then
        if config.outfits then
          local specOutfit = spec:getOutfit()
          if isFriend(spec:getName()) then
            if config.highlight then
              spec:setMarked('#0000FF')
            end
            specOutfit.head = 88
            specOutfit.body = 88
            specOutfit.legs = 88
            specOutfit.feet = 88
            if storage.BOTserver.outfit then
              local voc = vBot.BotServerMembers[spec:getName()]
              specOutfit.addons = 3 
              if voc == 1 then
                specOutfit.type = 131
              elseif voc == 2 then
                specOutfit.type = 129
              elseif voc == 3 then
                specOutfit.type = 130
              elseif voc == 4 then
                specOutfit.type = 144
              end
            end
            spec:setOutfit(specOutfit)
          elseif isEnemy(spec:getName()) then
            if config.highlight then
              spec:setMarked('#FF0000')
            end
            specOutfit.head = 94
            specOutfit.body = 94
            specOutfit.legs = 94
            specOutfit.feet = 94
            spec:setOutfit(specOutfit)
          end
        end
      end
    end
end
refreshStatus()

local checkStatus = function(creature)
    if not creature:isPlayer() or creature:isLocalPlayer() then return end
  
    local specName = creature:getName()
    local specOutfit = creature:getOutfit()
  
    if isFriend(specName) then
      if config.highlight then
        creature:setMarked('#0000FF')
      end
      if config.outfits then
        specOutfit.head = 88
        specOutfit.body = 88
        specOutfit.legs = 88
        specOutfit.feet = 88
        if storage.BOTserver.outfit then
          local voc = vBot.BotServerMembers[creature:getName()]
          specOutfit.addons = 3 
          if voc == 1 then
            specOutfit.type = 131
          elseif voc == 2 then
            specOutfit.type = 129
          elseif voc == 3 then
            specOutfit.type = 130
          elseif voc == 4 then
            specOutfit.type = 144
          end
        end
        creature:setOutfit(specOutfit)
      end
    elseif isEnemy(specName) then
      if config.highlight then
        creature:setMarked('#FF0000')
      end
      if config.outfits then
        specOutfit.head = 94
        specOutfit.body = 94
        specOutfit.legs = 94
        specOutfit.feet = 94
        creature:setOutfit(specOutfit)
      end
    end
end


rootWidget = g_ui.getRootWidget()
if rootWidget then
    local ListWindow = UI.createWindow('PlayerListWindow', rootWidget)
    ListWindow:hide()

    UI.Button("Player Lists", function() 
        ListWindow:show()
        ListWindow:raise()
        ListWindow:focus()
    end)

    -- settings
    ListWindow.settings.Members:setChecked(config.groupMembers)
    ListWindow.settings.Members.onClick = function(widget)
      config.groupMembers = not config.groupMembers
      if not config.groupMembers then
        clearCachedPlayers()
      end
      refreshStatus()
      widget:setChecked(config.groupMembers)
    end
    ListWindow.settings.Outfit:setChecked(config.outfits)
    ListWindow.settings.Outfit.onClick = function(widget)
      config.outfits = not config.outfits
      widget:setChecked(config.outfits)
      refreshStatus()
    end
    ListWindow.settings.NeutralsAreEnemy:setChecked(config.marks)
    ListWindow.settings.NeutralsAreEnemy.onClick = function(widget)
      config.marks = not config.marks
      widget:setChecked(config.marks)
    end
    ListWindow.settings.Highlight:setChecked(config.highlight)
    ListWindow.settings.Highlight.onClick = function(widget)
      config.highlight = not config.highlight
      widget:setChecked(config.highlight)
    end

    ListWindow.settings.AutoAdd:setChecked(config.autoAdd)
    ListWindow.settings.AutoAdd.onClick = function(widget)
      config.autoAdd = not config.autoAdd
      widget:setChecked(config.autoAdd)
    end

    local TabBar = ListWindow.tmpTabBar
    TabBar:setContentWidget(ListWindow.tmpTabContent)
    local blacklistList

    for v = 1, 3 do
        local listPanel = g_ui.createWidget("tPanel") -- Creates Panel
        local playerList = playerTables[v]
        listPanel:setId(tabs[v].."Tab")
        TabBar:addTab(tabs[v], listPanel)

        -- elements
        local addButton = listPanel.add
        local nameTab = listPanel.name
        local list = listPanel.list
        if v == 3 then
          blacklistList = list
        end

        for i, name in ipairs(playerList) do
            local label = UI.createWidget("PlayerLabel", list)
            label:setText(name)
            label.remove.onClick = function()
                table.remove(playerList, table.find(playerList, name))
                label:destroy()
                clearCachedPlayers()
                refreshStatus()
            end
            label.onMouseRelease = function(widget, mousePos, mouseButton)
              if mouseButton == 2 then
                local child = rootWidget:recursiveGetChildByPos(mousePos)
                if child == widget then
                  local menu = g_ui.createWidget('PopupMenu')
                  menu:setId("blzMenu")
                  menu:setGameMenu(true)
                  menu:addOption('Check Player', function()
                    local name = widget:getText():gsub(" ", spacing)
                    g_platform.openUrl(link..name)
                  end, "")
                  menu:addOption('Copy Name', function()
                    g_window.setClipboardText(widget:getText())
                  end, "")
                  menu:display(mousePos)
                  return true
                end
              end
            end
        end

        local tabButton = TabBar.buttonsPanel:getChildren()[v]

        tabButton.onStyleApply = function(widget)
            if TabBar:getCurrentTab() == widget then
                widget:setColor(colors[v])
            end 
        end

        -- callbacks
        addButton.onClick = function()
            local names = string.split(nameTab:getText(), ",")

            if #names == 0 then
              warn("vBot[PlayerList]: Name is missing!")
              return
            end

            for i=1,#names do
              local name = names[i]:trim()
              if name:len() == 0 then
                  warn("vBot[PlayerList]: Name is missing!")
              else
                  if not table.find(playerList, name) then
                      table.insert(playerList, name)
                      local label = UI.createWidget("PlayerLabel", list)
                      label:setText(name)
                      label.remove.onClick = function()
                          table.remove(playerList, table.find(playerList, name))
                          label:destroy()
                      end
                      label.onMouseRelease = function(widget, mousePos, mouseButton)
                        if mouseButton == 2 then
                          local child = rootWidget:recursiveGetChildByPos(mousePos)
                          if child == widget then
                            local menu = g_ui.createWidget('PopupMenu')
                            menu:setId("blzMenu")
                            menu:setGameMenu(true)
                            menu:addOption('Check Player', function()
                              local name = widget:getText():gsub(" ", "_")
                              local link = "https://www.gunzodus.net/character/show/"
                              g_platform.openUrl(link..name)
                            end, "")
                            menu:addOption('Copy Name', function()
                              g_window.setClipboardText(widget:getText())
                            end, "")
                            menu:display(mousePos)
                            return true
                          end
                        end
                      end
                      nameTab:setText("")
                  else
                      warn("vBot[PlayerList]: Player ".. name .." is already added!")
                      nameTab:setText("")
                  end
                  clearCachedPlayers()
                  refreshStatus()
              end
            end
        end

        nameTab.onKeyPress = function(widget, keyCode, keyboardModifiers)
          if keyCode ~= 5 then
            return false
          end
          addButton.onClick()
          return true
        end
    end

    function addBlackListPlayer(name)
      if table.find(config.blackList, name) then return end

      table.insert(config.blackList, name)
      local label = UI.createWidget("PlayerLabel", blacklistList)
      label:setText(name)
      label.remove.onClick = function()
          table.remove(playerList, table.find(playerList, name))
          label:destroy()
      end
      label.onMouseRelease = function(widget, mousePos, mouseButton)
        if mouseButton == 2 then
          local child = rootWidget:recursiveGetChildByPos(mousePos)
          if child == widget then
            local menu = g_ui.createWidget('PopupMenu')
            menu:setId("blzMenu")
            menu:setGameMenu(true)
            menu:addOption('Check Player', function()
              local name = widget:getText():gsub(" ", "_")
              local link = "https://www.gunzodus.net/character/show/"
              g_platform.openUrl(link..name)
            end, "")
            menu:addOption('Copy Name', function()
              g_window.setClipboardText(widget:getText())
            end, "")
            menu:display(mousePos)
            return true
          end
        end
      end
    end
end

onTextMessage(function(mode,text)
  if not config.autoAdd then return end
  if CaveBot.isOff() or TargetBot.isOff() then return end
  if not text:find("Warning! The murder of") then return end

    text = string.split(text, "Warning! The murder of ")[1]
    text = string.split(text, " was not justified.")[1]

    addBlackListPlayer(text)
end)

onCreatureAppear(function(creature)
    checkStatus(creature)
  end)
  
onPlayerPositionChange(function(x,y)
  if x.z ~= y.z then
    schedule(20, function()
      refreshStatus()
    end)
  end
end)

UI.Separator()


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

---------------------------------------------------------------------------------------------------------------------------
--talkedSpecs = {}

--UI.TextEdit(storage.lider or "Blintz", function(widget, newText)
        --storage.lider = newText
    --end)

--aviso = macro(100, 'aviso guild', function()
--    for name, _ in pairs(talkedSpecs) do
--       if not getCreatureByName(name) then
--            talkedSpecs[name] = nil
--        end
--    end
--    for _, spec in ipairs(getSpectators()) do
--        if spec ~= player and spec:isPlayer() and not isFriend(spec) then
--           if spec:getEmblem() ~= 1 then
--                local specName = spec:getName()
--                if not talkedSpecs[specName] and (spec:getName() ~= storage.excluido and spec:getName() ~= storage.excluido2 and spec:getName() ~= storage.excluido3 and spec:getName() ~= storage.excluido4) then
--                    talkPrivate(storage.lider, specName .. " - " .. hours .. ':' .. mins .. ':' .. seconds)
--                    talkedSpecs[specName] = true
--               end
--            end
--       end
--    end
--end)

-------------------------------------------------------------------

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

local panelName = "playerList"
  local ui = setupUI([[
Panel
  height: 18

  Button
    id: editList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    background: #292A2A
    height: 18
    text: Player Lists
  ]], parent)
  ui:setId(panelName)
ui:setId(panelName)
local playerListWindow = setupUI([[
PlayerName < Label
  background-color: alpha
  text-offset: 2 0
  focusable: true
  height: 16

  $focus:
    background-color: #00000055

  Button
    id: remove
    !text: tr('x')
    anchors.right: parent.right
    margin-right: 15
    width: 15
    height: 15

MainWindow
  !text: tr('Player Lists')
  size: 580 350
  @onEscape: self:hide()

  Label
    anchors.left: FriendList.left
    anchors.top: parent.top
    anchors.right: FriendList.right
    text-align: center
    text: Friends List
    margin-right: 3 

  TextList
    id: FriendList
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 15
    margin-bottom: 5
    margin-right: 3
    padding: 1
    width: 180
    height: 160
    vertical-scrollbar: FriendListScrollBar

  VerticalScrollBar
    id: FriendListScrollBar
    anchors.top: FriendList.top
    anchors.bottom: FriendList.bottom
    anchors.right: FriendList.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: FriendName
    anchors.right: FriendList.right
    anchors.left: FriendList.left
    anchors.top: FriendList.bottom
    margin-right: 3    
    margin-top: 5

  Button
    id: AddFriend
    !text: tr('Add Friend')
    anchors.right: FriendList.right
    anchors.left: FriendList.left
    anchors.top: prev.bottom
    margin-right: 3    
    margin-top: 3

  Label
    anchors.right: EnemyList.right
    anchors.top: parent.top
    anchors.left: EnemyList.left
    text-align: center
    text: Enemy List
    margin-left: 3     

  TextList
    id: EnemyList
    anchors.top: parent.top
    anchors.left: FriendList.right
    margin-top: 15
    margin-bottom: 5
    margin-left: 3
    padding: 1
    width: 180
    height: 160
    vertical-scrollbar: EnemyListScrollBar

  VerticalScrollBar
    id: EnemyListScrollBar
    anchors.top: EnemyList.top
    anchors.bottom: EnemyList.bottom
    anchors.right: EnemyList.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: EnemyName
    anchors.left: EnemyList.left
    anchors.right: EnemyList.right
    anchors.top: EnemyList.bottom
    margin-left: 3    
    margin-top: 5

  Button
    id: AddEnemy
    !text: tr('Add Enemy')
    anchors.left: EnemyList.left
    anchors.right: EnemyList.right
    anchors.top: prev.bottom
    margin-left: 3    
    margin-top: 3

  Label
    anchors.right: BlackList.right
    anchors.top: parent.top
    anchors.left: BlackList.left
    text-align: center
    text: Anty RS List
    margin-left: 3   

  TextList
    id: BlackList
    anchors.top: parent.top
    anchors.left: EnemyList.right
    margin-top: 15
    margin-bottom: 5
    margin-left: 3
    padding: 1
    width: 180
    height: 160
    vertical-scrollbar: BlackListScrollBar

  VerticalScrollBar
    id: BlackListScrollBar
    anchors.top: BlackList.top
    anchors.bottom: BlackList.bottom
    anchors.right: BlackList.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: BlackName
    anchors.left: BlackList.left
    anchors.right: BlackList.right
    anchors.top: BlackList.bottom
    margin-left: 3    
    margin-top: 5

  Button
    id: AddBlack
    !text: tr('Add Anty-RS')
    anchors.left: BlackList.left
    anchors.right: BlackList.right
    anchors.top: prev.bottom
    margin-left: 3    
    margin-top: 3

  BotSwitch
    id: Members
    anchors.left: parent.left
    anchors.top: AddEnemy.bottom
    margin-top: 15
    width: 135
    text-align: center
    text: Group Members  

  BotSwitch
    id: Outfit
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    margin-left: 3
    width: 135
    text-align: center
    text: Color Outfits

  BotSwitch
    id: Marks
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    width: 135
    margin-left: 3
    text-align: center
    text: Not Ally = Enemy    

  BotSwitch
    id: Highlight    
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    width: 135
    margin-left: 3
    text-align: center
    text: Highlight     

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8    

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 5    
]], g_ui.getRootWidget())

if not storage[panelName] then
  storage[panelName] = {
    enemyList = {},
    friendList = {},
    blackList = {},
    groupMembers = true,
    outfits = false,
    marks = false,
    highlight = false
  }
end

local config = storage[panelName]
-- for backward compability
if not config.blackList then
  config.blackList = {}
end


-- functions
local function clearCachedPlayers()
  CachedFriends = {}
  CachedEnemies = {}
end

local refreshStatus = function()
  for _, spec in ipairs(getSpectators()) do
    if spec:isPlayer() and not spec:isLocalPlayer() then
      if config.outfits then
        local specOutfit = spec:getOutfit()
        if isFriend(spec:getName()) then
          if config.highlight then
            spec:setMarked('#0000FF')
          end
          specOutfit.head = 88
          specOutfit.body = 88
          specOutfit.legs = 88
          specOutfit.feet = 88
          if storage.BOTserver.outfit then
            local voc = vBot.BotServerMembers[spec:getName()]
            specOutfit.addons = 3 
            if voc == 1 then
              specOutfit.type = 131
            elseif voc == 2 then
              specOutfit.type = 129
            elseif voc == 3 then
              specOutfit.type = 130
            elseif voc == 4 then
              specOutfit.type = 144
            end
          end
          spec:setOutfit(specOutfit)
        elseif isEnemy(spec:getName()) then
          if config.highlight then
            spec:setMarked('#FF0000')
          end
          specOutfit.head = 94
          specOutfit.body = 94
          specOutfit.legs = 94
          specOutfit.feet = 94
          spec:setOutfit(specOutfit)
        end
      end
    end
  end
end
refreshStatus()

local checkStatus = function(creature)
  if not creature:isPlayer() or creature:isLocalPlayer() then return end

  local specName = creature:getName()
  local specOutfit = creature:getOutfit()

  if isFriend(specName) then
    if config.highlight then
      creature:setMarked('#0000FF')
    end
    if config.outfits then
      specOutfit.head = 88
      specOutfit.body = 88
      specOutfit.legs = 88
      specOutfit.feet = 88
      if storage.BOTserver.outfit then
        local voc = vBot.BotServerMembers[creature:getName()]
        specOutfit.addons = 3 
        if voc == 1 then
          specOutfit.type = 131
        elseif voc == 2 then
          specOutfit.type = 129
        elseif voc == 3 then
          specOutfit.type = 130
        elseif voc == 4 then
          specOutfit.type = 144
        end
      end
      creature:setOutfit(specOutfit)
    end
  elseif isEnemy(specName) then
    if config.highlight then
      creature:setMarked('#FF0000')
    end
    if config.outfits then
      specOutfit.head = 94
      specOutfit.body = 94
      specOutfit.legs = 94
      specOutfit.feet = 94
      creature:setOutfit(specOutfit)
    end
  end
end

-- eof

-- UI
rootWidget = g_ui.getRootWidget()
playerListWindow:hide()

playerListWindow.Members:setOn(config.groupMembers)
playerListWindow.Members.onClick = function(widget)
  config.groupMembers = not config.groupMembers
  if not config then
    clearCachedPlayers()
  end
  refreshStatus()
  widget:setOn(config.groupMembers)
end
playerListWindow.Outfit:setOn(config.outfits)
playerListWindow.Outfit.onClick = function(widget)
  config.outfits = not config.outfits
  widget:setOn(config.outfits)
end
playerListWindow.Marks:setOn(config.marks)
playerListWindow.Marks.onClick = function(widget)
  config.marks = not config.marks
  widget:setOn(config.marks)
end
playerListWindow.Highlight:setOn(config.highlight)
playerListWindow.Highlight.onClick = function(widget)
  config.highlight = not config.highlight
  widget:setOn(config.highlight)
end

if config.enemyList and #config.enemyList > 0 then
  for _, name in ipairs(config.enemyList) do
    local label = g_ui.createWidget("PlayerName", playerListWindow.EnemyList)
    label.remove.onClick = function(widget)
      table.removevalue(config.enemyList, label:getText())
      label:destroy()
    end
    label:setText(name)
  end
end

if config.blackList and #config.blackList > 0 then
  for _, name in ipairs(config.blackList) do
    local label = g_ui.createWidget("PlayerName", playerListWindow.BlackList)
    label.remove.onClick = function(widget)
      table.removevalue(config.blackList, label:getText())
      label:destroy()
    end
    label:setText(name)
  end
end

if config.friendList and #config.friendList > 0 then
  for _, name in ipairs(config.friendList) do
    local label = g_ui.createWidget("PlayerName", playerListWindow.FriendList)
    label.remove.onClick = function(widget)
      table.removevalue(config.friendList, label:getText())
      label:destroy()
    end
    label:setText(name)
  end
end

playerListWindow.AddFriend.onClick = function(widget)
  local friendName = playerListWindow.FriendName:getText()
  if friendName:len() > 0 and not table.contains(config.friendList, friendName, true) then
    table.insert(config.friendList, friendName)
    local label = g_ui.createWidget("PlayerName", playerListWindow.FriendList)
    label.remove.onClick = function(widget)
      table.removevalue(config.friendList, label:getText())
      label:destroy()
    end
    label:setText(friendName)
    playerListWindow.FriendName:setText('')
    clearCachedPlayers()
    refreshStatus()
  end
end

playerListWindow.AddEnemy.onClick = function(widget)
  local enemyName = playerListWindow.EnemyName:getText()
  if enemyName:len() > 0 and not table.contains(config.enemyList, enemyName, true) then
    table.insert(config.enemyList, enemyName)
    local label = g_ui.createWidget("PlayerName", playerListWindow.EnemyList)
    label.remove.onClick = function(widget)
      table.removevalue(config.enemyList, label:getText())
      label:destroy()
    end
    label:setText(enemyName)
    playerListWindow.EnemyName:setText('')
    clearCachedPlayers()
    refreshStatus()
  end
end 

playerListWindow.AddBlack.onClick = function(widget)
  local blackName = playerListWindow.BlackName:getText()
  if blackName:len() > 0 and not table.contains(config.blackList, blackName, true) then
    table.insert(config.blackList, blackName)
    local label = g_ui.createWidget("PlayerName", playerListWindow.BlackList)
    label.remove.onClick = function(widget)
      table.removevalue(config.blackList, label:getText())
      label:destroy()
    end
    label:setText(blackName)
    playerListWindow.BlackName:setText('')
    clearCachedPlayers()
    refreshStatus()
  end
end 

ui.editList.onClick = function(widget)
  playerListWindow:show()
  playerListWindow:raise()
  playerListWindow:focus()
end
playerListWindow.closeButton.onClick = function(widget)
  playerListWindow:hide()
end


-- execution

onCreatureAppear(function(creature)
checkStatus(creature)
end)

onPlayerPositionChange(function(x,y)
if x.z ~= y.z then
  schedule(20, function()
    refreshStatus()
  end)
end
end)

setDefaultTab("Main")
-- allows to test/edit bot lua scripts ingame, you can have multiple scripts like this, just change storage.ingame_lua
UI.Button("Ingame macro editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_macros or "", {title="Macro editor", description="You can add your custom macros (or any other lua code) here"}, function(text)
    storage.ingame_macros = text
    reload()
  end)
end)
UI.Button("Ingame hotkey editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="Hotkeys editor", description="You can add your custom hotkeys/singlehotkeys here"}, function(text)
    storage.ingame_hotkeys = text
    reload()
  end)
end)

UI.Separator()

for _, scripts in ipairs({storage.ingame_macros, storage.ingame_hotkeys}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame edior error:\n" .. result)
    end
  end
end

UI.Separator()


info('Loaded Main')