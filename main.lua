local character = require('character')
local ennemies = require('ennemies')

function love.keypressed(key)
  character.keypressed(key)
end


function love.load()
  room = love.graphics.newImage("room.png")
  character.load()
  ennemies.load()
  ennemies.spawn('wizoob', 350, 180)
  ennemies.spawn('wizoob', 150, 80)
  ennemies.spawn('wizoob', 15, 200)
end

function love.update(timing)
  character.update(timing)
end

function love.draw()
  love.graphics.draw(room, 0, 0)
  love.graphics.scale(1.5, 1.5)
  character.draw()
  ennemies.draw()
end
