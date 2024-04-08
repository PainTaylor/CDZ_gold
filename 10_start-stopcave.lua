onKeyDown(function(keys)
  if keys == 'F12' then
    if CaveBot.isOn() then
      CaveBot.setOff()
      TargetBot.setOff()
    elseif CaveBot.isOff() then
      CaveBot.setOn()
      TargetBot.setOn()
    end
  end
end)