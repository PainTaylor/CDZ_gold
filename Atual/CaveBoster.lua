storage.itemxp = now
macro(200, 'XpBooster', function()
if storage.itemxp < now then
use(13226)
use(13282)
use(13228)
use(13420)
if player:getLevel() >= 300 then
use(14288)
end
end
end)

onTextMessage(function(mode, text)
if text:find('Bonus ativado') then
if player:getLevel() >= 300 then
totalbonus = '115'
else
totalbonus = '65'
end
if text:find(totalbonus) then
storage.itemxp = now + 1800000
end
end
end)


storage.itemloot = now
macro(200, 'LootBoster', function()
if storage.itemloot < now then
use(14637)
end
end)

onTextMessage(function(mode, text)
if text:find('Bonus de loot') then
storage.itemloot = now + 1800000
end
end)