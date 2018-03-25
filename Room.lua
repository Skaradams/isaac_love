local inspect = require('lib.inspect')
local Character = require('Character')
local Ennemy = require('Ennemy')
local Hitbox = require('Hitbox')
local class = require('lib.middleclass')
local getWorld = require('World')

local Room = class('Room')
local world = getWorld()

-- TODO : Create a hitbox zone (cross) to trigger the room change
function Room:initialize(data, changeRoom, color)
  self.backgroundColor = color
  self.changeRoom = changeRoom
  self.character = Character:new({love.graphics.getWidth() / 2, love.graphics.getHeight()})
  self.ennemies = {}
  if data.ennemies then
    for i, ennemy in pairs(data.ennemies) do
      table.insert(self.ennemies, Ennemy:new(unpack(ennemy)))
    end
  end
  self.door = Hitbox:new(self, love.graphics.getWidth() / 2, 0, 20, 20, Hitbox.COLLISIONS.CROSS)
end

function Room:collide()
  for i, ennemy in pairs(self.ennemies) do
    ennemy:remove()
  end
  self.changeRoom()
end

function Room:keypressed(key)
  self.character:keypressed(key)
end

function Room:update(timing)
  self.character:update(timing)
  for i, ennemy in pairs(self.ennemies) do
    ennemy:update(timing)
  end
end

function Room:draw()
  love.graphics.setBackgroundColor(unpack(self.backgroundColor))
  self.character:draw()
  for i, ennemy in pairs(self.ennemies) do
    ennemy:draw()
  end

  positionX, positionY, rectWidth, rectHeight = self.door:getRect()
  -- love.graphics.setColor(78, 35, 123)
  love.graphics.rectangle(
    "fill",
    positionX, positionY, rectWidth, rectHeight
  )
end

return Room
