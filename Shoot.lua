local inspect = require('lib.inspect')
local dispatcher = require('dispatcher')
local class = require('lib.middleclass')
local Hitbox = require('Hitbox')

local Shoot = class('Shoot')

function Shoot:initialize(x, y, dispatcherChannel)
  self.createdAt = love.timer.getTime()

  self.axis = axis
  self.direction = direction
  self.dispatcherChannel = dispatcherChannel
  self.hitbox = Hitbox:new(self, x, y, 5, 5)
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
  local positionX, positionY, width, height = self.hitbox:getRect(self)
  if positionX and positionY then
      local newX, newY = self.hitbox:move(positionX + self.speed.x, positionY + self.speed.y)
      dispatcher.addMessage(
        {
          data = {
            shoot = self
          }
        },
        self.dispatcherChannel
      )
    end
  -- end
end

function Shoot:collide()
  self:destroy()
end

function Shoot:destroy()
  self.hitbox:remove()
end

function Shoot:draw()
  -- todo : remove myself from table of shoots (to be destroyed by garbage collector)
  local positionX, positionY, width, height = self.hitbox:getRect(self)
  if positionX and positionY then
    love.graphics.circle("fill", positionX, positionY, 5, 100)
  end
end

return Shoot
