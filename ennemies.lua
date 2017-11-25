local ennemies = {}

local dispatcher = require('dispatcher')

local utils = require('utils')

-- list of availables ennemy types
local pool = {
  wizoob = {
    image = 'wizoob.png'
  }
}

-- list of ennemies in room
local spawned = {}

function ennemies.spawn(type, x, y)
  if(type) then
    local ennemy = utils.clone(pool[type])
    ennemy.x = x
    ennemy.y = y
    table.insert(spawned, ennemy)
  end
end

function ennemies.load()
  for name, ennemy in pairs(pool) do
    ennemy.asset = love.graphics.newImage(ennemy.image)
    dispatcher.subscribe(dispatcher.channels.CHARACTER, ennemy)
  end
end


function ennemies.draw()
  for i, ennemy in pairs(spawned) do
    local width, height = ennemy.asset:getDimensions()
    local quad = love.graphics.newQuad(
      width/4,
      height/3 * 0,
      width/4,
      height/3,
      ennemy.asset:getDimensions()
    )

    love.graphics.draw(ennemy.asset, quad, ennemy.x, ennemy.y)
  end
end

return ennemies
