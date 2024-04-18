setDefaultTab("Main")
onTextMessage(function(mode, text)
  if text:find('Completo') then
    if text:find('Graad') then
      quest = 'graad'
    end
    if text:find('Cassius') then
      quest = 'cassios'
    end
    if text:find('Soldier') then
      quest = 'soldier'
    end
    if text:find('Daichi') then
      quest = 'daichi'
    end
  end
end)



onTalk(function(name, level, mode, text, channelId, pos)
if name == 'Grande Mestre' and text:find('faltam') then
  if text:find('Cassius') then
    actualquest = 'cassios'
  end
  if text:find('Soldiers') then
    actualquest = 'soldier'
  end
  if text:find('Daichi') then
    actualquest = 'daichi'
  end
  if text:find('Graad') then
    actualquest = 'graad'
  end
end
end)

info('Loaded Quests')