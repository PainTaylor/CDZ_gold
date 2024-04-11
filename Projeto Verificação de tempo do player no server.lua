onCreatureAppear(function(creature)
	if creature:isPlayer() then
		local config = storage.players_cache;
		local creatureName = creature:getName();
		local player_info = config[creatureName];
		if (player_info == nil) then
			config[creatureName] = os.time();
		end
		info(creatureName .. ' está no servidor há: ' .. (os.time() - config[creatureName]))
	end
end)


onCreatureAppear(function(creature)
local config = storage.script;
local playerInfo = config[creature:getName()];
config[creature:getName()] = os.time()
config[name] = creature:getName()
end)