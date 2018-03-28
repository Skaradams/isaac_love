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
  self.translating = false
end

function Camera:scale()
  love.graphics.scale(1.5, 1.5)
end

function Camera:setPosition(x, y)
  self.translating = true
  self.nextPosition = {
    x = x,
    y = y
  }
end

function Camera:checkTranslating()
  if self.nextPosition.x == nil and self.nextPosition.y == nil then
    self.translating = false
  end
  return self.translating
end

function Camera:update()
  local step = 4
  self:checkTranslating()

  if self.nextPosition.x ~= nil then
    if self.position.x > self.nextPosition.x then
      self.position.x = self.position.x - step
    else
      self.position.x = self.position.x + step
    end
    if math.abs(self.position.x - self.nextPosition.x) == step then
      self.position.x = self.nextPosition.x
      self.nextPosition.x = nil
    end
  end
  if self.nextPosition.y ~= nil then

    if self.position.y > self.nextPosition.y then
      self.position.y = self.position.y - step
    else
      self.position.y = self.position.y + step
    end
    if math.abs(self.position.y - self.nextPosition.y) == step then
      self.position.y = self.nextPosition.y
      self.nextPosition.y = nil
    end
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
