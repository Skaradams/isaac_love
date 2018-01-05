local inspect = require('lib.inspect')
local dispatcher = {}

local subscribers = {};
local messages = {};

dispatcher.channels = {
  CHARACTER = 'character',
  ENNEMY_SHOOTS = 'ennemy_shoots',
  CHARACTER_SHOOTS = 'character_shoots'
}

-- Init subscribers
for i, channel in pairs(dispatcher.channels) do
  subscribers[channel] = {}
end

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
  for channel, channel_messages in pairs(messages) do
    for i, subscriber in pairs(subscribers[channel]) do
      subscriber:inbox(channel_messages, channel)
    end
  end
  -- reset messages
  messages = {};
end

return dispatcher
