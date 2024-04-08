onTextMessage(function(mode, text)
  if text:find('Task') and text:find('Completo') then
    playSound('/sounds/magnum.ogg')
      g_window.setTitle(player:getName() .. " - Task Complete")
  end
end)

onTalk(function(name, level, mode, text, channelId, pos)
if name ~= 'Grande Mestre' then return end
if text:find('Caso queira você pode tentar pegar outra missão') then
  g_window.setTitle("CDZ Gold - " .. player:getName())
end
end)