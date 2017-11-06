local character = require('character')


function love.keypressed(key)
  character.keypressed(key)
end


function love.load()
  character.load()

end

function love.update(timing)
  character.update(timing)
end

function love.draw()
  character.draw()
end
