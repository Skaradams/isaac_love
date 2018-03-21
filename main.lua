local camera = require('Camera')
local Room = require('Room')
local dispatcher = require('dispatcher')

local room

function changeRoom(room)
  room = room
end

function love.load()
  room = Room:new(changeRoom)
end

function love.keypressed(key)
  room:keypressed(key)
end

function love.update(timing)
  -- We'll use miliseconds everywhere
  timing = timing * 1000

  room:update(timing)
  dispatcher.update()
end

function love.draw()
  room:draw()
end
