setDefaultTab("Main")
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

-------------------------------------------------------------------


info('Loaded Alarms')