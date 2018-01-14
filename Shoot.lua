local inspect = require('lib.inspect')
local dispatcher = require('dispatcher')
local class = require('lib.middleclass')
local getWorld = require('World')

local Shoot = class('Shoot')
local world = getWorld()

function Shoot:initialize(x, y, dispatcherChannel)
  self.createdAt = love.timer.getTime()

  self.axis = axis
  self.direction = direction
  self.dispatcherChannel = dispatcherChannel
  world:add(self, x, y, 5, 5)
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
  if world:hasItem(self) then
    local positionX, positionY, width, height = world:getRect(self)
    local goalX, goalY = positionX + self.speed.x, positionY + self.speed.y
    local actualX, actualY, collisions, collisionsCount = world:check(self, goalX, goalY)
    if(collisionsCount <= 0) then
      local newX, newY = world:update(self, positionX + self.speed.x, positionY + self.speed.y)
      dispatcher.addMessage(
        {
          data = {
            shoot = self
          }
        },
        self.dispatcherChannel
      )
    else
      for i, collision in pairs(collisions) do
        collision.other:collide(self)
        self:collide(collision.other)
      end
    end
  end
end

function Shoot:collide()
  self:destroy()
end

function Shoot:destroy()

  world:remove(self)
end

function Shoot:draw()
  if world:hasItem(self) then
    local positionX, positionY, width, height = world:getRect(self)
    love.graphics.circle("fill", positionX, positionY, 5, 100)
  end
end

return Shoot
