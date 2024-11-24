onTalk(function(name, level, mode, text, channelId, pos)
    if name == 'PainTaylor' then
        if text == 'Releve a todos o que a Sasha é' then
            player:setTitle('Sasha [Pinguça]')
        end
        if text == 'Perii Sai do armario' then
            player:setTitle('Boquinha [Veludo]')
        end
        if text == 'oque o Sek é?' then
            player:setTitle('Sektr [Abuser]')
        end
    end
end)