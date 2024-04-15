onKeyPress(function(keys)
    if keys == '0' then
        DropTrap(0, -1, 0)
        DropTrap(0, 1, 0)
        DropTrap(-1, -1, 0)
        DropTrap(-1, 0, 0)
        DropTrap(-1, 1, 0)
        DropTrap(1, -1, 0)
        DropTrap(1, 0, 0)
        DropTrap(1, 1, 0)
    end
end)

itemtrapid = {13328, 13329, 13330, 13331, 13332, 13333, 13334, 13335, 13336, 13337, 13338, 13339, 13340, 13341, 13342, 13428, 14256, 13429, 13427, 13422, 13430, 13424, 13426, 14255, 13431, 13423, 13421, 13425, 14261, 14263}

function DropTrap(x, y, z)
    if not g_game.isAttacking() then return end
    local target = g_game.getAttackingCreature()
    local position = target:getPosition()
    local containers = getContainers()
    position.x = position.x + x
    position.y = position.y + y
    for _, container in pairs(containers) do
        for __, item in ipairs(container:getItems()) do
            for ___, userItem in ipairs(itemtrapid) do
                if item:getId() == userItem then
                    g_game.move(item, target:getPosition(), item:getCount())
                end
            end
        end
    end
end