local discordTimes = {}
 -- insert your webhook link below
local webhook = "https://discordapp.com/api/webhooks/1318211954384568381/QhpRfcptUq3TOD4FmwewFOLhwQVRdGcB8edV9m4e6L4rYJls144pyvNZQu0JKN9w95Ch"

local default_data = {
  username = "PeriiCustomCheckuse", -- name discord displays the message from
}

local embed = {
  color = 10038562, -- default color - dark red
}

function onHTTPResult(data, err)
  if err then
    print("Discord Webhook Error: ".. err)
  end
end

 -- This allows you to send messages to discord using a webhook.
 -- The "id" is to save the time it was last used and the "delayed" is the next time it can send (Player alert beeps every 1500ms, you can make it so it only sends the alert once every 10 seconds etc.)
function CheckUse(data)
local id = data.id
  if id then
    local dTime = discordTimes[id]
    if dTime and os.time() < dTime then return end
    discordTimes[id] = os.time() + (0) -- delayed value or 10 seconds
  end

  local dEmbed = embed
  if data.color then dEmbed.color = data.color end
  dEmbed.title = "**".. data.title .."**"
  dEmbed.fields = {
    {
      name = "Name: ",
      value = data.name,
    },
    {
      name = "Message",
      value = data.message,
    }
  }

  local dataSend = default_data
  dataSend.embeds = { dEmbed }
  HTTP.postJSON(webhook, dataSend, onHTTPResult)
end

 --------------
 -- example --
 --------------

schedule(5000, function()
  local data = {   
   title = 'Used',
     name = player:getName(),
     message = 'Custom Iniciada',
     id = "pd",
  }
  CheckUse(data)
end)