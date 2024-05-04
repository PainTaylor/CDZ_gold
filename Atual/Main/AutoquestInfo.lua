setDefaultTab("Main")
onTextMessage(function(mode, text)
  if text:find('Completo') then
    if text:find('Graad') then
      storage.quest = 'graad'
    end
    if text:find('Cassius') then
      storage.quest = 'cassios'
    end
    if text:find('Soldier') then
      storage.quest = 'soldier'
    end
    if text:find('Daichi') then
      storage.quest = 'daichi'
    end
    if text:find('Ushio') then
      storage.quest = 'ushio'
    end
    if text:find('Sho') then
      storage.quest = 'sho'
    end
    if text:find('Ichi') then
      storage.quest = 'ichi'
    end
  end
end)



onTalk(function(name, level, mode, text, channelId, pos)
if name == 'Grande Mestre' and text:find('faltam') then
  if text:find('Cassius') then
    storage.actualquest = 'cassios'
  end
  if text:find('Soldiers') then
    storage.actualquest = 'soldier'
  end
  if text:find('Daichi') then
    storage.actualquest = 'daichi'
  end
  if text:find('Graad') then
    storage.actualquest = 'graad'
  end
  if text:find('Ushios') then
    storage.actualquest = 'ushios'
  end
  if text:find('Sho') then
    storage.actualquest = 'sho'
  end
  if text:find('Ichi') then
    storage.actualquest = 'ichi'
  end
end
end)

info('Loaded Quests')


