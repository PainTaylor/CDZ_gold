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
end
end)

info('Loaded Quests')