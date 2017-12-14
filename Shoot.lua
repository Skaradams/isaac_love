local inspect = require('lib.inspect')
local dispatcher = require('dispatcher')
local class = require('lib.middleclass')

local Shoot = class('Shoot')

function Shoot:initialize(x, y, axis, direction, owner)
  self.owner = owner
  self.position = {
    x = x,
    y = y
  }
  self.axis = axis
  self.direction = direction
end

function Shoot:update()

end
