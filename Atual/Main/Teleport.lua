setDefaultTab("Main")
local windowUI = setupUI([[
MainWindow
  id: main
  !text: tr('Minoru Teleport by Kays')
  size: 230 310
  scrollable: true
    
  ScrollablePanel
    id: TpList
    anchors.top: parent.top
    anchors.left: parent.left
    size: 190 225
    vertical-scrollbar: mainScroll

    Button
      !text: tr('Grecia')
      anchors.top: parent.top
      anchors.left: parent.left
      width: 165

    Button
      !text: tr('North City')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('Siberia')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('Bugavila')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165
      
    Button
      !text: tr('Medusa')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('Asgard')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

  VerticalScrollBar  
    id: mainScroll
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    step: 48
    pixels-scroll: true
    
  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 15

]], g_ui.getRootWidget());
windowUI:hide();

TpMinoru = {};
local MainPanel = windowUI.main;
local TpList = windowUI.TpList;

TpMinoru.close = function()
  windowUI:hide()
  schedule(1000, function()
      NPC.say('bye');
end)
end

TpMinoru.show = function()
    windowUI:show();
    windowUI:raise();
    windowUI:focus();
end

windowUI.closeButton.onClick = function()
    TpMinoru.close();
end

TpMinoru.tpToCity = function(city)
    NPC.say(city);
    schedule(500, function()
        NPC.say('yes');
    end);
end


for i, child in pairs(TpList:getChildren()) do
    child.onClick = function()
        TpMinoru.tpToCity(child:getText())
    end
end

onTalk(function(name, level, mode, text, channelId, pos)
  if (name ~= 'Athena Travel') then return; end              
  if (mode ~= 51) then return; end
  if (text:find('Para onde gostaria de ir?')) then 
      TpMinoru.show();
  else
      TpMinoru.close();
  end
end);

onKeyDown(function(keys)
    if (keys == 'Escape' and windowUI:isVisible())  then
        TpMinoru.close();
    end
end);

info('Loaded TPs')