local character = require('character')
local ennemies = require('ennemies')

function love.keypressed(key)
  character.keypressed(key)
end


function love.load()
  character.load()
  ennemies.load()
  ennemies.spawn('wizoob', 350, 180)
  ennemies.spawn('wizoob', 150, 80)
end

function love.update(timing)
  character.update(timing)
end

function love.draw()
  character.draw()
  ennemies.draw()
end
