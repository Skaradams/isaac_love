local inspect = require('lib.inspect')
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

function Ennemy:initialize(type, x, y)
  local poolType = utils.clone(Ennemy.static.pool[type])
  self.spritesheet = love.graphics.newImage(poolType.image)
  self.position = {
    x = x,
    y = y
  }
  self.shoots = {}
  dispatcher.subscribe(dispatcher.channels.CHARACTER, self)
end

-- direction = x or y
-- value = 1 or -1
function Ennemy:shoot(direction, value)
  print(inspect(self.position))
  table.insert(self.shoots, {
    x = self.position.x + 50,
    y = self.position.y + 50,
    axis = {
      direction = direction,
      value = value
    }
  })

end

function Ennemy:updateShoots()
  local shoot
  local axis
  print(inspect(self.shoots))
  for i, shoot in pairs(self.shoots) do
    for y, axis in pairs(shoot.axis) do
      shoot[axis.direction] = shoot[axis.direction] + axis.value
    end
  end
end

function Ennemy:inbox(messages)
  local direction
  local value

  for i, message in pairs(messages) do
    if(message.data.x == self.position.x) then
      direction = 'x'
      if(message.data.y <= self.position.y) then
        value = -1
      else
        value = 1
      end
    end
    if(message.data.y == self.position.y) then
      direction = 'y'
      if(message.data.x <= self.position.x) then
        value = -1
      else
        value = 1
      end
    end
  end
  self:shoot(direction, value)
end

function Ennemy:update()
  self:updateShoots()
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
  love.graphics.setColor(255, 255, 255)
  for i, shoot in pairs(self.shoots) do
    love.graphics.circle("fill", shoot.x, shoot.y, 10, 100)
  end
end

return Ennemy
