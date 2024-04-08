local idz = {13328, 13329, 13330, 13331, 13332, 13333, 13334, 13335, 13336, 13337, 13338, 13339, 13340, 13341, 13342, 13428, 14256, 13429, 13427, 13422, 13430, 13424, 13426, 14255, 13431, 13423, 13421, 13425, 14261, 14263}

macro(300, "Coletar itens do chão", function()
    local playerPos = g_game.getLocalPlayer():getPosition()
    local z = playerPos.z 
    local tiles = g_map.getTiles(posz()) 
    for _, tile in ipairs(tiles) do 
        if z ~= playerPos.z then return end 
        if g_game.getAttackingCreature() == nil then
            if getDistanceBetween(pos(), tile:getPosition()) <= 8 then
                local topThing = tile:getTopMoveThing()
                if topThing and table.find(idz, topThing:getId()) then 
                    g_game.move(topThing, {x = 65535, y = SlotAmmo, z = 0}, topThing:getCount()) 
                end
            end
        end
    end
end)


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