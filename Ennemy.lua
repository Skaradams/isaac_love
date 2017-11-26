local dispatcher = require('dispatcher')
local utils = require('utils')
local class = require('lib.middleclass')

local Ennemy = class('Ennemy')

-- list of availables ennemy types
Ennemy.static.pool = {
  wizoob = {
    image = 'wizoob.png'
  }
}

function Ennemy.initialize(self, type, x, y)
  print(type)
  local poolType = utils.clone(Ennemy.static.pool[type])
  self.spritesheet = love.graphics.newImage(poolType.image)
  self.position = {
    x = x,
    y = y
  }
  dispatcher.subscribe(dispatcher.channels.CHARACTER, self)
end

function Ennemy:draw()
  local width, height = self.spritesheet:getDimensions()
  self.spritequad = love.graphics.newQuad(
    width/4,
    height/3 * 0,
    width/4,
    height/3,
    self.spritesheet:getDimensions()
  )

  love.graphics.draw(
    self.spritesheet,
    self.spritequad,
    self.position.x,
    self.position.y
  )
end

return Ennemy
