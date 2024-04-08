setDefaultTab("Cave")
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