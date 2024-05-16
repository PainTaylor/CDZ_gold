--LoadMain
modules.corelib.HTTP.get('https://raw.githubusercontent.com/PainTaylor/CDZ_gold/main/tyrLoader.lua', function(script)
    assert(loadstring(script))()
  end);