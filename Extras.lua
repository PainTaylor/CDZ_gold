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