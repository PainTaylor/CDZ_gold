setDefaultTab("Tools")
-- Target
local creatureId = nil;
local stopAttackRequested = false;
 
keepTarget = {
  setTarget = function(_creatureId)
    creatureId = _creatureId;
  end,
 
  stopAttack = function()
    stopAttackRequested = true;
  end
};
 
 
 
Target = {
 KeyCancel = 'Escape',
 cancelTime = 0,
 cancel = function()
  Target.Id = nil
  Target.get = nil
  Target.cancelTime = now + 100
  g_game.cancelAttack()
 end
 }
 
hotkey(Target.KeyCancel, function()
 Target.cancel()
end)
 
macro(100, 'Target', function()
 if Target.cancelTime >= now then return end
 if g_game.isAttacking() then
  Target.Id = g_game.getAttackingCreature():getId()
 elseif Target.Id then
  Target.get = getCreatureById(Target.Id)
  if Target.get then
   g_game.attack(Target.get)
  end
 end
end)

local STANCE_MODE_CHASE = 1;
local STANCE_MODE_STAND = 0;
local setStanceMode = g_game.setChaseMode;
local getStanceMode = g_game.getChaseMode;
onKeyDown(function(key)
    if (key ~= "6") then return; end
    local stanceMode = getStanceMode();
    if (stanceMode ~= STANCE_MODE_CHASE) then
        return setStanceMode(STANCE_MODE_CHASE);
    end
    setStanceMode(STANCE_MODE_STAND);
end)



BugLock = {};


local availableKeys = {
  ['W'] = { 0, -5 },
  ['S'] = { 0, 5 },
  ['A'] = { -5, 0 },
  ['D'] = { 5, 0 },
  ['C'] = { 5, 5 },
  ['Z'] = { -5, 5 },
  ['Q'] = { -5, -5 },
  ['E'] = { 5, -5 }
};

BugMap = macro(1, "BugMap", function()
if modules.game_walking.wsadWalking then
  BugLock.logic();
end
end)

function BugLock.logic()
  local playerPos = pos();
  local tile;
  for key, value in pairs(availableKeys) do
    if (modules.corelib.g_keyboard.isKeyPressed(key)) then
      playerPos.x = playerPos.x + value[1];
      playerPos.y = playerPos.y + value[2];
      tile = g_map.getTile(playerPos);
      break;
    end
  end
  if (not tile) then return end;
  g_game.use(tile:getTopUseThing());
end

BugLock.icon = addIcon("Bug Map", {item=10384, text="Bug Map", hotkey="Ctrl+Space"}, function(icon, isOn) 
  BugMap.setOn(isOn); 
end);

BugMap.setOn()


storage.timerhaste = now
macro(20, 'Haste', function()
  if storage.timerhaste <= now then
    say('speed up')
  end
end)

onTalk(function(name, level, mode, text, channelId, pos)
 if name == player:getName() and channelId == 0 and mode == 44 then
  if text:find('speed up') then
    storage.timerhaste = now + 58000
  end
 end
end)

macro(100, "anti paralyze", function() 
  if not isParalyzed() then return end
    say('Speed Up')
end)

say('light')
macro(15000, 'Light', function()
say('light')
end)

UI.Label("Mana training")
if type(storage.manaTrain) ~= "table" then
  storage.manaTrain = {on=false, title="MP%", text="utevo lux", min=80, max=100}
end

local manatrainmacro = macro(1000, function()
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  local mana = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain.max >= mana and mana >= storage.manaTrain.min then
    say(storage.manaTrain.text)
  end
end)
manatrainmacro.setOn(storage.manaTrain.on)

UI.DualScrollPanel(storage.manaTrain, function(widget, newParams) 
  storage.manaTrain = newParams
  manatrainmacro.setOn(storage.manaTrain.on)
end)