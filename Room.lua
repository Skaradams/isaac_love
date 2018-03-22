local inspect = require('lib.inspect')
local Character = require('Character')
local Ennemy = require('Ennemy')
local class = require('lib.middleclass')
local getWorld = require('World')

local Room = class('Room')
local world = getWorld()

-- TODO : Create a hitbox zone (cross) to trigger the room change
function Room:initialize(data, changeRoom)
  self.changeRoom = changeRoom
  self.character = Character:new()
  self.ennemies = {}
  if 'ennemies' in data then
    for i, ennemy in pairs(data.ennemies) do
      table.insert(self.ennemies, Ennemy:new(unpack(ennemy))
    end
  end
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
  self.character:draw()
  for i, ennemy in pairs(self.ennemies) do
    ennemy:draw()
  end
end

return Room
