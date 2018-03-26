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
  self.character = Character:new({x = love.graphics.getWidth() / 2 + data.position[2], y = love.graphics.getHeight() + data.position[1]})
  self.ennemies = {}
  self.position = data.position
  if data.ennemies then
    for i, ennemy in pairs(data.ennemies) do
      table.insert(ennemy, self.position[1])
      table.insert(ennemy, self.position[2])
      table.insert(self.ennemies, Ennemy:new(unpack(ennemy)))
    end
  end
  self.door = Hitbox:new(self, (love.graphics.getWidth() / 2) - 10, 0, 20, 20, Hitbox.COLLISIONS.CROSS)
end

function Room:collide()
  for i, ennemy in pairs(self.ennemies) do
    ennemy:remove()
  end
  self.door:remove()
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
  if positionX then
    love.graphics.rectangle(
      "fill",
      positionX, positionY, rectWidth, rectHeight
    )
  end
end

return Room
