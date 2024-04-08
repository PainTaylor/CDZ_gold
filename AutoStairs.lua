setDefaultTab("Tools")
  ClosestStair = {};
ClosestStair.tile = nil;
ClosestStair.aditionalTiles = { 1067, 595, 5293, 5542,  1648, 1678, 13296, 1646, 5111, 1948, 7771, 8657, 1680, 6264, 1664, 6262, 5291, 6905, 1646, 435 };
ClosestStair.ignoredTiles = { 1949 }
ClosestStair.flags = { ignoreNonPathable = true, precision = 1, ignoreCreatures = false }
ClosestStair.walkTime = now;

local keyToPress = "Space";

ClosestStair.macro = macro(50, 'Escadas', function()
    local tiles = g_map.getTiles(posz());
    local playerPos = pos();
    local closestTile = nil;
    for i, tile in ipairs(tiles) do
        local tilePosition = tile:getPosition();
        local minimapColor = g_map.getMinimapColor(tilePosition);
        local StairColor = minimapColor >= 210 and minimapColor <= 213;
        if (StairColor and not tile:isPathable()) then
            local hasIgnoredTiles = false;
            for index, item in ipairs(tile:getItems()) do
                if (table.find(ClosestStair.ignoredTiles, item:getId())) then
                    hasIgnoredTiles = true;
                    break;
                end
            end
            if (
                not hasIgnoredTiles and
                (closestTile == nil or 
                getDistanceBetween(playerPos, tilePosition) < getDistanceBetween(playerPos, closestTile:getPosition()) or 
                closestTile:getPosition().z ~= posz())
            )  then
                closestTile = tile;
            end
        else
            for index, item in ipairs(tile:getItems()) do
                if (table.find(ClosestStair.aditionalTiles, item:getId())) then
                    if (closestTile == nil or 
                        getDistanceBetween(playerPos, tilePosition) < getDistanceBetween(playerPos, closestTile:getPosition()) or 
                        closestTile:getPosition().z ~= posz()
                    ) then
    
                        closestTile = tile;
    
                        break;
                    end
                end
            end
        end
    end
    
    if (ClosestStair.tile) then
        ClosestStair.tile:setText("");
    end

    ClosestStair.tile = closestTile;

    if (not ClosestStair.tile) then return end;
    
    ClosestStair.tile:setText("Press " .. keyToPress);
end);

onKeyPress(function(keys) 
    if (ClosestStair.macro.isOff()) then return; end
    if (keys ~= keyToPress) then return; end
    if (ClosestStair.tile == nil) then
        return modules.game_textmessage.displayGameMessage('Nenhuma escada/buraco/teleporte');
    end
    local tile = g_map.getTile(ClosestStair.tile:getPosition());
    local tilePosition = tile:getPosition();
    local distance = getDistanceBetween(pos(), tilePosition);

    if (tile:canShoot()) then
        use(tile:getTopUseThing());
    else
        autoWalk(tilePosition, 100, { ignoreNonPathable = true, precision = 1, ignoreCreatures = false, ignoreStairs = true });
    end
    if (ClosestStair.walkTime and ClosestStair.walkTime < now and distance == 1) then
        CaveBot.walkTo(tilePosition, 1, { precision = 1 }); 
        ClosestStair.walkTime = (now + 225);
    end
end)