local ProtocolGame = g_game.getProtocolGame();
local OutputMessage = modules._G.OutputMessage;

local opcode = 16;
local SpecialOpcode = modules._G.SpecialOpcode;

macro(100, 'Bypassdoor', function()
  local window = modules.game_antibotcode.MainWindow;
  if (window:isHidden()) then return; end

  local codePanel = window:getChildById("codePanel");
  local msg = OutputMessage.create();
  msg:addU8(SpecialOpcode);
  msg:addU8(opcode);
  msg:addU8(1);
  msg:addString(codePanel:getText());
  ProtocolGame:send(msg);
  window:hide();
end)