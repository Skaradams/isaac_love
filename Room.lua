local inspect = require('lib.inspect')
local Character = require('Character')
local Ennemy = require('Ennemy')
local class = require('lib.middleclass')
local getWorld = require('World')

local Room = class('Room')
local world = getWorld()

local character, wizoob1, wizoob2, wizoob3

function Room:initialize(changeRoom)
  self.changeRoom = changeRoom
  character = Character:new()
  wizoob1 = Ennemy:new('wizoob', 350, 180)
  wizoob2 = Ennemy:new('wizoob', 150, 80)
  wizoob3 = Ennemy:new('wizoob', 15, 200)
end

function Room:keypressed(key)
  character:keypressed(key)
end

function Room:update(timing)
  character:update(timing)
  wizoob1:update(timing)
  wizoob2:update(timing)
  wizoob3:update(timing)
end

function Room:draw()
  character:draw()
  wizoob1:draw()
  wizoob2:draw()
  wizoob3:draw()
end

return Room
