local class = require('lib.middleclass')
local Camera = class('Camera')
local globalCamera

function Camera:initialize(x, y)
  self.position = {
    x = x,
    y = y
  }
  self.nextPosition = {
    x = x,
    y = y
  }
  love.graphics.push()
  love.graphics.translate(x, y)
end

function Camera:scale()
  love.graphics.scale(1.5, 1.5)
end

function Camera:setPosition(x, y)
  self.nextPosition = {
    x = x,
    y = y
  }
end

function Camera:update()
  if self.position.x > self.nextPosition.x then
    self.position.x = self.position.x - 1
  else
    self.position.x = self.position.x + 1
  end

  if self.position.y > self.nextPosition.y then
    self.position.y = self.position.y - 1
  else
    self.position.y = self.position.y + 1
  end
end

function Camera:draw()
  love.graphics.translate(self.position.x, self.position.y)
end

function getCamera()
  if not globalCamera then
    globalCamera = Camera:new(0, 0)
  end
  return globalCamera
end

return getCamera()
