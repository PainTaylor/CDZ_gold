local idz = {13328, 13329, 13330, 13331, 13332, 13333, 13334, 13335, 13336, 13337, 13338, 13339, 13340, 13341, 13342, 13428, 14256, 13429, 13427, 13422, 13430, 13424, 13426, 14255, 13431, 13423, 13421, 13425, 14261, 14263} -- adicionar ID dos itens
macro(300, "Coletar itens do chão", function()
local z = posz()
for _, tile in ipairs(g_map.getTiles(z)) do
    if z ~= posz() then return end
        if getDistanceBetween(pos(), tile:getPosition()) <= 1 then -- distância que quer coletar
            if table.find(idz, tile:getTopLookThing():getId()) then
                g_game.move(tile:getTopLookThing(), {x = 65535, y=SlotAmmo, z=0}, tile:getTopLookThing():getCount())
            end
        end
    end
end)