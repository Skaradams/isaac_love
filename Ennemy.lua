local inspect = require('lib.inspect')
local dispatcher = require('dispatcher')
local utils = require('utils')
local class = require('lib.middleclass')
local ShootGenerator = require('ShootGenerator')
local Hitbox = require('Hitbox')

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
  self.life = 3
  self.shoots = {}
  self.hitbox = Hitbox:new(self, x, y, 30, 30)
  dispatcher.subscribe(dispatcher.channels.CHARACTER, self)
end

-- direction = x or y
-- value = 1 or -1
function Ennemy:shoot(direction, value)
  local step = 8;

  local newShoot = ShootGenerator:createShoot(
    self.position.x + 20,
    self.position.y + 20,
    self.shoots[#self.shoots],
    dispatcher.channels.ENNEMY_SHOOTS
  )
  if newShoot then
    local speed = {}
    speed[direction] = value * step
    newShoot:setSpeed(speed.x, speed.y)
    table.insert(self.shoots, newShoot)
  end
end

function Ennemy:updateShoots()
  local shoot
  local axis
  local newShoots = {}
  for i, shoot in pairs(self.shoots) do
    table.insert(newShoots, shoot)
    shoot:update()
  end
  self.shoots = newShoots
end

function Ennemy:inbox(messages)
  local direction
  local value
  for i, message in pairs(messages) do
    if(message.data.x == self.position.x) then
      direction = 'y'
      if(message.data.y <= self.position.y) then
        value = -1
      else
        value = 1
      end
    end
    if(message.data.y == self.position.y) then
      direction = 'x'
      if(message.data.x <= self.position.x) then
        value = -1
      else
        value = 1
      end
    end
    if(direction) then
      self:shoot(direction, value)
    end
  end
end

function Ennemy:update()
  self:updateShoots()
  self.hitbox:checkCollisions()
end

function Ennemy:collide()
  self.life = self.life - 1
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
  if self.life > 0 then
    love.graphics.draw(
      self.spritesheet,
      self.spritequad,
      self.position.x,
      self.position.y
    )
  end
  love.graphics.setColor(255, 255, 255)
  for i, shoot in pairs(self.shoots) do
    shoot:draw()
  end
end

return Ennemy
