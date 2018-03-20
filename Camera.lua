local class = require('lib.middleclass')
local Camera = class('Camera')
local globalCamera

function Camera:initialize(x, y)
  love.graphics.translate(x, y)
end

function Camera:setPosition(x, y)
  love.graphics.translate(x, y)
end

function getCamera()
  if not globalCamera then
    globalCamera = Camera:new(0, 0)
  end
  return globalCamera
end

return getCamera()
