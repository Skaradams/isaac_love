local inspect = require('lib.inspect')
local class = require('lib.middleclass')
local getWorld = require('World')

local Hitbox = class('Hitbox')
local world = getWorld()

function Hitbox:initialize(owner, positionX, positionY, width, height)
  self.owner = owner
  world:add(
    self,
    positionX,
    positionY,
    width,
    height
  )
end

function Hitbox:getRect()
  if world:hasItem(self) then
    return world:getRect(self)
  end
end

function Hitbox:move(positionX, positionY)
  if world:hasItem(self) then
    local newX, newY, collisions, collisionsCount = world:move(self, positionX, positionY)
    self:collide(collisions, collisionsCount)
    return newX, newY
  end
end

function Hitbox:checkCollisions(goalX, goalY)
  if world:hasItem(self) then
    if goalX and goalY then
      local x, y, collisions, collisionsCount = world:check(self, goalX, goalY)
    else
      local x, y, collisions, collisionsCount = world:check(self)
    end
    self:collide(collisions, collisionsCount)
    return collisions, collisionsCount
  end
end

function Hitbox:collide(collisions, collisionsCount)
  if collisionsCount and collisionsCount > 0 then
    for i, collision in pairs(collisions) do
      collision.other.owner:collide(self)
      self.owner:collide(collision.other)
    end
  end
end

function Hitbox:remove()
  world:remove(self)
end

return Hitbox
