setDefaultTab("Cave")

storage.itemxp = now
macro(200, 'XpBooster', function()
	if storage.star5 < now then
		use(13282)
	end
	if storage.star15 < now then
		use(12228)
	end
	if storage.star20 < now then
		use(13226)
	end
	if storage.star25 < now then
		use(13420)
	end
	if player:getLevel() >= 300 and storage.star50 < now then
		use(14288)
	end
end)
if storage.star5 = nil then
	storage.star5 = now
end
if storage.star15 = nil then
	storage.star15 = now
end
if storage.star20 = nil then
	storage.star20 = now
end
if storage.star25 = nil then
	storage.star25 = now
end
if storage.star50 = nil then
	storage.star50 = now
end

onTextMessage(function(mode, text)
if text:find('Bonus ativado') then
	if text:find('+5%') then
		storage.star5active = true
		storage.star5 = now + 1800000
	end
	if text:find('+15%') then
		storage.star15active = true
		storage.star15 = now + 1800000
	end
	if text:find('+20%') then
		storage.star20active = true
		storage.star20 = now + 1800000
	end
	if text:find('+25%') then
		storage.star25active = true
		storage.star25 = now + 1800000
	end
	if text:find('+50%') then
		storage.star50active = true
		storage.star50 = now + 1800000
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


storage.itemloot = now
macro(200, 'Totem Bost', function()
if storage.itemloot < now then
usewith(14198, player:getPosition())
end
end)

onTextMessage(function(mode, text)
if text:find('um totem') then
storage.itemloot = now + 3600000
end
end)