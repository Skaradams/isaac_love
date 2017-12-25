local inspect = require('lib.inspect')
local dispatcher = require('dispatcher')
local class = require('lib.middleclass')

local Shoot = class('Shoot')

function Shoot:initialize(x, y)
  self.createdAt = love.timer.getTime()
  self.position = {
    x = x,
    y = y
  }
  self.axis = axis
  self.direction = direction
end

function Shoot:setSpeed(speedX, speedY)
  if(not speedX) then
    speedX = 0
  end
  if(not speedY) then
    speedY = 0
  end
  self.speed = {
    x = speedX,
    y = speedY
  }
end

function Shoot:update()
  self.position.x = self.position.x + self.speed.x
  self.position.y = self.position.y + self.speed.y
end

function Shoot:draw()
  love.graphics.circle("fill", self.position.x, self.position.y, 10, 100)
end

return Shoot
