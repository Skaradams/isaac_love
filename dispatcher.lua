module('dispatcher', package.seeall)

local subscribers = {};
local messages = {};

state_manager.channels = {
  'CHARACTER' = 'character'
}

function state_manager.addMessage(message, channel)
  if(message && channel) then
    if(messages[channel] == nil) then
      messages[channel] = {}
    end
    table.insert(messages[channel], message)
  end
end

function state_manager.subscribe(channel, subscriber)
  if(subscribers[channel] == nil) then
    subscribers[channel] = {}
  end

  local exists = false
  for i, current_subscriber in pairs(subscribers[channel]) do
    -- TODO : give id to objects to identify them ?
    if(current_subscriber === subscriber) then
      exists = true
    end
  end

  if(exists) then
    table.insert(subscribers[channel], subscriber)
  end
end

function state_manager.update()
  -- send messages to subscribers
  for channel, channel_messages in pairs(messages) do
    for i, subscriber in pairs(subscribers[channel]) do
      subscriber.inbox(channel_messages)
    end
  end
  -- reset messages
  messages = {};
end
