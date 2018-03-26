local camera = require('Camera')
local Room = require('Room')
local dispatcher = require('dispatcher')

local room



function changeRoom(newRoom)
  camera:scale()
  local roomData = {
    ennemies = {
      {'wizoob', 40, 40}
    },
    position = {
      x = 0,
      y = - love.graphics.getHeight()
    }
  }


  camera:setPosition(0,love.graphics.getHeight())
  room = Room:new(roomData, function() print('change room 2') end, {65,43,21}, 2)
end

function love.load()
  local roomData = {
    ennemies = {
      {'wizoob', 350, 180},
      {'wizoob', 150, 80},
      {'wizoob', 15, 200}
    },
    position = {
      x = 0,
      y = 0
    }
  }
  room = Room:new(roomData, changeRoom, {12,34,56}, 1)
end

function love.keypressed(key)
  room:keypressed(key)
end

function love.update(timing)
  -- We'll use miliseconds everywhere
  timing = timing * 1000
  camera:update()
  room:update(timing)
  dispatcher.update()
end

function love.draw()
  camera:draw()
  room:draw()
end
