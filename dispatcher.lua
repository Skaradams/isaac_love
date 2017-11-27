local inspect = require('lib.inspect')
local dispatcher = {}

local subscribers = {};
local messages = {};

dispatcher.channels = {
  CHARACTER = 'character'
}

function dispatcher.addMessage(message, channel)
  if(message and channel) then
    if(messages[channel] == nil) then
      messages[channel] = {}
    end
    table.insert(messages[channel], message)
  end
end

-- Subscriber should be an instance of middleclass
function dispatcher.subscribe(channel, subscriber)
  if(subscribers[channel] == nil) then
    subscribers[channel] = {}
  end

  local exists = false
  for i, current_subscriber in pairs(subscribers[channel]) do
    -- TODO : give id to objects to identify them ?
    if(current_subscriber == subscriber) then
      exists = true
    end
  end

  if(not exists) then
    table.insert(subscribers[channel], subscriber)
  end
end

function dispatcher.update()
  -- send messages to subscribers
  -- print(inspect(subscribers))
  for channel, channel_messages in pairs(messages) do
    for i, subscriber in pairs(subscribers[channel]) do
      subscriber:inbox(channel_messages)
    end
  end
  -- reset messages
  messages = {};
end

return dispatcher
