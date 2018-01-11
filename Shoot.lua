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
    local newX, newY, collisions, collisionsCount = world:update(self, positionX + self.speed.x, positionY + self.speed.y)
    dispatcher.addMessage(
      {
        data = {
          shoot = self
        }
      },
      self.dispatcherChannel
    )
  end
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
