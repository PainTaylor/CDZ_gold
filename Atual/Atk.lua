setDefaultTab("Atk")

macro(1000, 'Special Cast', function()
  if not g_game.isAttacking() then return end
  if soul() == 200 then
    say(storage.ultimate)
  end
end)

macro(100, 'Combo', function()
 if not g_game.isAttacking() then return end
  if player:getLevel() >= 250 then
   say(storage.combo4)
end
 if player:getLevel() >= 150 then
   say(storage.combo3)
end
 if player:getLevel() >= 50 then
   say(storage.combo2)
end
 if player:getLevel() >= 1 then
  say(storage.combo1)
end
end)

onKeyPress(function(keys)
    if storage.ultimate == nil or modules.game_console:isChatEnabled() then return end
    if keys == 'R' then
        say(storage.ultimate)
    end
end)

onKeyPress(function(keys)
    if storage.sspell == nil or modules.game_console:isChatEnabled() then return end
    if keys == 'F' then
        say(storage.sspell)
    end
end)

macro(200, "Face Target", function()
    local target = g_game.getAttackingCreature()
    if not target then return end
    local xDiff = target:getPosition().x > posx()
    local yDiff = target:getPosition().y > posy()
    local isXBigger = math.abs(target:getPosition().x - posx()) > math.abs(target:getPosition().y - posy())

    local dir = player:getDirection()
    if xDiff and isXBigger then  
        if dir ~= 1 then turn(1) end
        return
    elseif not xDiff and isXBigger then 
        if dir ~= 3 then turn(3) end
        return
    elseif yDiff and not isXBigger then
        if dir ~= 2 then turn(2) end
        return
    elseif not yDiff and not isXBigger  then 
        if dir ~= 0 then turn(0) end
        return
    end
end)

UI.Label("Enemys")

macro(1, "Chicletinho 90%", function()

for _,pla in ipairs(getSpectators(posz())) do

attacked = g_game.getAttackingCreature()

if not attacked or attacked:isMonster() or attacked:isPlayer() and pla:getHealthPercent() < attacked:getHealthPercent()*0.6 then
if pla:isPlayer() and pla:getHealthPercent() < 90 and pla:getEmblem() ~= 1 and pla:getSkull() <= 3 then 
g_game.attack(pla)
end
end

end

delay(100)

end)

------------------------------------------------------------------------------------

local friendList = {'toei', 'ryan', 'darknuss', ''}

--- nao editar nada abaixo disso

for index, friendName in ipairs(friendList) do
     friendList[friendName:lower():trim()] = true
    friendList[index] = nil
end





macro(1, 'Chiclete Ryan', function()
  local possibleTarget = false
  for _, creature in ipairs(getSpectators(posz())) do
    local specHP = creature:getHealthPercent()
    if creature:isPlayer() and specHP and specHP > 0 and specHP <= 90 then
      if not friendList[creature:getName():lower()] and creature:getEmblem() ~= 1 then
        if creature:canShoot() then
          if not possibleTarget or possibleTargetHP > specHP or (possibleTargetHP == specHP and possibleTarget:getId() < creature:getId()) then
            possibleTarget = creature
            possibleTargetHP = possibleTarget:getHealthPercent()
          end
        end
      end
    end
  end
  if possibleTarget and g_game.getAttackingCreature() ~= possibleTarget then
    g_game.attack(possibleTarget)
end
end)

----------------------------------------------------------------------------------------

local friendList = {'toei', 'ryan', 'darknuss', ''}

--- nao editar nada abaixo disso

for index, friendName in ipairs(friendList) do
     friendList[friendName:lower():trim()] = true
    friendList[index] = nil
end





macro(1, 'Enemy Full', function()
  local possibleTarget = false
  for _, creature in ipairs(getSpectators(posz())) do
    local specHP = creature:getHealthPercent()
    if creature:isPlayer() and specHP then
      if not friendList[creature:getName():lower()] and creature:getEmblem() ~= 1 then
        if creature:canShoot() then
          if not possibleTarget or possibleTargetHP > specHP or (possibleTargetHP == specHP and possibleTarget:getId() < creature:getId()) then
            possibleTarget = creature
            possibleTargetHP = possibleTarget:getHealthPercent()
          end
        end
      end
    end
  end
  if possibleTarget and g_game.getAttackingCreature() ~= possibleTarget then
    g_game.attack(possibleTarget)
end
end)

--------------------------------------------------------------------------------


UI.TextEdit(storage.ntarget or "Nejia", function(widget, newText)
storage.ntarget = newText
end)

UI.TextEdit(storage.ntarget2 or "Nejia", function(widget, newText)
storage.ntarget2 = newText
end)

atkname = macro(100, 'AttackName', function() 
if g_game.isAttacking() or g_game.isFollowing() then return end
  for _, spec in ipairs(getSpectators()) do
    local specifytarget = spec:getName()
    if (specifytarget == storage.ntarget or specifytarget == storage.ntarget2) and spec:isPlayer()  then
g_game.attack(spec)
    end
  end
end)

autoatackcave = macro(200000, 'AutoHunt',function()end)
onAttackingCreatureChange(function(creature, oldCreature)
  if autoatackcave.isOff() then return end
  if creature and creature:isPlayer() then
    TargetBot.setOff()
    CaveBot.setOff()
end
if oldCreature and oldCreature:isPlayer() then
TargetBot.setOn()
CaveBot.setOn()
  end
end)
-------------------------------------------------------------------------------------



local friendList = {'toei', 'ryan', 'darknuss', ''}

--- nao editar nada abaixo disso

for index, friendName in ipairs(friendList) do
     friendList[friendName:lower():trim()] = true
    friendList[index] = nil
end





macro(1, 'Ant-Caveira', function()
  local possibleTarget = false
  for _, creature in ipairs(getSpectators(posz())) do
    local specHP = creature:getHealthPercent()
    if creature:isPlayer() and specHP then
      if not friendList[creature:getName():lower()] and (creature:getSkull() ~= 0) and (creature:getShield() == 0) and (creature:getEmblem() ~= 1) then
        if creature:canShoot() then
          if not possibleTarget or possibleTargetHP > specHP or (possibleTargetHP == specHP and possibleTarget:getId() < creature:getId()) then
            possibleTarget = creature
            possibleTargetHP = possibleTarget:getHealthPercent()
          end
        end
      end
    end
  end
  if possibleTarget and g_game.getAttackingCreature() ~= possibleTarget then
    g_game.attack(possibleTarget)
end
end)


--onTextMessage(function(mode, text)
 --for _, p in ipairs(getSpectators(posz())) do
 -- if p:isPlayer() and text:find(p:getName()) and text:find('attack by') then
    --CaveBot.setOff()
    --TargetBot.setOff()
 -- end
--end
--end)


local friendList = {'toei', 'ryan', 'darknuss', ''}

--- nao editar nada abaixo disso

for index, friendName in ipairs(friendList) do
     friendList[friendName:lower():trim()] = true
    friendList[index] = nil
end





macro(1, 'Chiclete Ryan Friend', function()
  local possibleTarget = false
  for _, creature in ipairs(getSpectators(posz())) do
    local specHP = creature:getHealthPercent()
    if creature:isPlayer() and specHP and specHP > 0 and specHP <= 90 then
      if (not friendList[creature:getName():lower()] and not isFriend(creature)) and creature:getEmblem() ~= 1 then
        if creature:canShoot() then
          if not possibleTarget or possibleTargetHP > specHP or (possibleTargetHP == specHP and possibleTarget:getId() < creature:getId()) then
            possibleTarget = creature
            possibleTargetHP = possibleTarget:getHealthPercent()
          end
        end
      end
    end
  end
  if possibleTarget and g_game.getAttackingCreature() ~= possibleTarget then
    g_game.attack(possibleTarget)
end
end)

stopbotonattack = macro(200, 'StopBotOnAttack', function()end)
onTextMessage(function(mode, text)
  if stopbotonattack.isOff() then return end
 for _, p in ipairs(getSpectators(posz())) do
  if p:isPlayer() and text:find(p:getName()) and text:find('attack by') then
    CaveBot.setOff()
    TargetBot.setOff()
  end
end
end)

UI.Separator()
UI.Label("Follow")

UI.TextEdit(storage.follow or "Sealed Crystal East", function(widget, newText)
storage.follow = newText
end)

UI.TextEdit(storage.follow2 or "Sealed Crystal West", function(widget, newText)
storage.follow2 = newText
end)

macro(100, 'Follow Name', function() 
if g_game.isAttacking() or g_game.isFollowing() then return end
  for _, spec in ipairs(getSpectators()) do
    if spec:getName() == storage.follow or spec:getName() == storage.follow2 then
g_game.follow(spec)
    end
  end
end)


others = macro(100, 'OthersBot', function() 
if g_game.isAttacking() then return end
  for _, spec in ipairs(getSpectators()) do
    if spec:isMonster() then
   g_game.attack(spec)
    end
  end
end)

UI.Separator()

--info('Loaded Atk')


setDefaultTab("Atk")

local friendList = {'Paintaylor', 'Hellkays', 'Shurado', 'Gakido', 'Nigendo', 'Tendo', 'Jigokudo', 'Chikushodo', 'Found', 'Isawhim', 'Isawevenrything', 'Icanseeu','Valdez', 'Valdez Maker Um', 'Ysuka', 'Albatrxz', 'Poeta Mudo', 'Gabi', 'Sektr', 'Jabu', 'Aiolos', 'Perii', '', '', '', '', '', '', '', '', ''}

--- nao editar nada abaixo disso

for index, friendName in ipairs(friendList) do
     friendList[friendName:lower():trim()] = true
    friendList[index] = nil
end


local ignoreEmblems = {1,4} -- Guild Emblems (Allies)

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Fight Back (Revide)')
    font: verdana-11px-rounded

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
    font: verdana-11px-rounded
]])

local edit = setupUI([[
RevideBox < CheckBox
  font: verdana-11px-rounded
  margin-top: 5
  margin-left: 5
  anchors.top: prev.bottom
  anchors.left: parent.left
  anchors.right: parent.right
  color: lightGray

Panel
  height: 123

  RevideBox
    id: pauseTarget
    anchors.top: parent.top
    text: Pause TargetBot 
    !tooltip: tr('Pause TargetBot While fighting back.')

  RevideBox
    id: pauseCave
    text: Pause CaveBot 
    !tooltip: tr('Pause CaveBot While fighting back.')

  RevideBox
    id: followTarget
    text: Follow Target 
    !tooltip: tr('Set Chase Mode to Follow While fighting back.')

  RevideBox
    id: ignoreParty
    text: Ignore Party Members

  RevideBox
    id: ignoreGuild
    text: Ignore Guild Members

  RevideBox
    id: attackAll
    text: Attack All Skulled
    !tooltip: tr("Attack every skulled player, even if he didn't attacked you.")

  BotTextEdit
    id: esc
    width: 83
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    text: Escape
    color: red
    font: verdana-11px-rounded

  Label
    text: Cancel Attack:
    font: verdana-11px-rounded
    anchors.left: parent.left
    margin-left: 5
    anchors.verticalCenter: esc.verticalCenter
]])
edit:hide()

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end
-- End Basic UI

-- Storage
local st = "RevideFight"
storage[st] = storage[st] or {
  enabled = false,
  pauseTarget = true,
  pauseCave = true,
  followTarget = true,
  ignoreParty = false,
  ignoreGuild = false,
  attackAll = false,
  esc = "Escape",
}
local config = storage[st]

-- UI Functions
-- Main Button
ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
end

-- Checkboxes
do
  edit.pauseTarget:setChecked(config.pauseTarget)
  edit.pauseTarget.onClick = function(widget)
    config.pauseTarget = not config.pauseTarget
    widget:setChecked(config.pauseTarget)
    widget:setImageColor(config.pauseTarget and "green" or "red")
  end
  edit.pauseTarget:setImageColor(config.pauseTarget and "green" or "red")
  
  edit.pauseCave:setChecked(config.pauseCave)
  edit.pauseCave.onClick = function(widget)
    config.pauseCave = not config.pauseCave
    widget:setChecked(config.pauseCave)
    widget:setImageColor(config.pauseCave and "green" or "red")
  end
  edit.pauseCave:setImageColor(config.pauseCave and "green" or "red")

  edit.followTarget:setChecked(config.followTarget)
  edit.followTarget.onClick = function(widget)
    config.followTarget = not config.followTarget
    widget:setChecked(config.followTarget)
    widget:setImageColor(config.followTarget and "green" or "red")
  end
  edit.followTarget:setImageColor(config.followTarget and "green" or "red")

  edit.ignoreParty:setChecked(config.ignoreParty)
  edit.ignoreParty.onClick = function(widget)
    config.ignoreParty = not config.ignoreParty
    widget:setChecked(config.ignoreParty)
    widget:setImageColor(config.ignoreParty and "green" or "red")
  end
  edit.ignoreParty:setImageColor(config.ignoreParty and "green" or "red")

  edit.ignoreGuild:setChecked(config.ignoreGuild)
  edit.ignoreGuild.onClick = function(widget)
    config.ignoreGuild = not config.ignoreGuild
    widget:setChecked(config.ignoreGuild)
    widget:setImageColor(config.ignoreGuild and "green" or "red")
  end
  edit.ignoreGuild:setImageColor(config.ignoreGuild and "green" or "red")

  edit.attackAll:setChecked(config.attackAll)
  edit.attackAll.onClick = function(widget)
    config.attackAll = not config.attackAll
    widget:setChecked(config.attackAll)
    widget:setImageColor(config.attackAll and "green" or "red")
  end
  edit.attackAll:setImageColor(config.attackAll and "green" or "red")
end

-- TextEdit
edit.esc:setText(config.esc)
edit.esc.onTextChange = function(widget, text)
  config.esc = text
end
edit.esc:setTooltip("Hotkey to cancel attack.")

-- End of setup.

local target = nil
local c = config

-- Main Loop
macro(250, function()
  if not c.enabled then return end
  if not target then
    if c.pausedTarget then
      c.pausedTarget = false
      TargetBot.setOn()
    end
    if c.pausedCave then
      c.pausedCave = false
      CaveBot.setOn()
    end
    -- Search for attackers
    local creatures = getSpectators(false)
    for s, spec in ipairs(creatures) do
      if spec ~= player and spec:isPlayer() then
        if (c.attackAll and spec:getSkull() > 2) or spec:isTimedSquareVisible() then
          if c.ignoreParty or spec:getShield() < 3 then
            if c.ignoreGuild or not table.find(ignoreEmblems, spec:getEmblem()) then
              target = spec:getName()
              break
            end
          end
        end
      end
    end
    return
  end

  local creature = getPlayerByName(target)
  if friendList[creature:getName():lower()] then return end
  if not creature then target = nil return end
  if c.pauseTargetBot then
    c.pausedTarget = true
    TargetBot.setOff()
  end
  if c.pauseTarget then
    c.pausedTarget = true
    TargetBot.setOff()
  end
  if c.pauseCave then
    c.pausedCave = true
    CaveBot.setOff()
  end

  if c.followTarget then
    g_game.setChaseMode(2)
  end

  if g_game.isAttacking() then
    if g_game.getAttackingCreature():getName() == target then
      return
    end
  end
  g_game.attack(creature)

end)

onKeyDown(function(keys)
  if not c.enabled then return end
  if keys == config.esc then
    target = nil
  end
end)

UI.Separator()