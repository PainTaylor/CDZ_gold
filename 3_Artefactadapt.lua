setDefaultTab("Tools")

storage.holditem = now
onPlayerHealthChange(function(healthPercent)
  if healthPercent < 15 then
    storage.holditem  = now + 3000
  end
end)

  speedartefact = findItem(13788)
  reviveartefact = findItem(13815)
  Damageartefact = findItem(13779)
  LootArtefact = findItem(13694)
  PoisonArtefact = findItem(13727)

macro(200, 'RemovePoison', function()
    if isPoisioned() then
    moveToSlot(13727, 2)
  end
end)

macro(200, 'ArtefactAdapt', function()
  if storage.holditem > now then
    moveToSlot(13815, 2)
  elseif g_game.isAttacking() then
  	  x = g_game.getAttackingCreature()
  	 if x:getHealthPercent() <= 10 and x:isMonster() then
    	moveToSlot(13694, 2)
      delay(1000)
	else
		moveToSlot(13779, 2)
	end
  else
    moveToSlot(13788, 2)
  end
end)

