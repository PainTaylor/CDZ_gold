setDefaultTab("Main")
--onKeyDown(function(keys)
--if keys == '0' then
 -- say(player:getTitle())
--end
--end)

--------------------------------------------------------------------------------------

cdzgoldstaminarec = function()
    if isInPz() and (posx() >= 857 and posx() <= 876) and (posy() >= 898 and posy() <= 912) then
        return true
    else
        return false
    end
end

isinAriesSavepoint = function()
    if isInPz() and (posx() >= 954 and posx() <= 956) and (posy() >= 2300 and posy() <= 2302) then
        return true
    else
        return false
    end
end


isinGreciaSavepoint = function()
  if isInPz() and (posx() >= 1047 and posx() <= 1049) and (posy() >= 1014 and posy() <= 1016) then
    return true
end
end

IsInGreeceTemple = function()
    if isInPz() and (posx() >= 1005 and posx() <= 1026) and (posy() >= 999 and posy() <= 1013) then
        return true
    end
end


isinaiolosstart = function()
    if (posx() >= 883 and posx() <= 902) and (posy() >= 1676 and posy() <= 1683) then
        return true
    end
end



---------------------------------------------------------------------------------

setDefaultTab("Main")
-- allows to test/edit bot lua scripts ingame, you can have multiple scripts like this, just change storage.ingame_lua
UI.Button("Ingame macro editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_macros or "", {title="Macro editor", description="You can add your custom macros (or any other lua code) here"}, function(text)
    storage.ingame_macros = text
    reload()
  end)
end)
UI.Button("Ingame hotkey editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="Hotkeys editor", description="You can add your custom hotkeys/singlehotkeys here"}, function(text)
    storage.ingame_hotkeys = text
    reload()
  end)
end)

UI.Separator()

for _, scripts in ipairs({storage.ingame_macros, storage.ingame_hotkeys}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame edior error:\n" .. result)
    end
  end
end

UI.Separator()