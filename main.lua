local camera = require('Camera')
local Character = require('Character')
local Ennemy = require('Ennemy')
local dispatcher = require('dispatcher')

local room, character, wizoob1, wizoob2, wizoob3

function love.keypressed(key)
  character:keypressed(key)
end

function love.load()
  character = Character:new()
  wizoob1 = Ennemy:new('wizoob', 350, 180)
  wizoob2 = Ennemy:new('wizoob', 150, 80)
  wizoob3 = Ennemy:new('wizoob', 15, 200)
end

function love.update(timing)
  -- We'll use miliseconds everywhere
  timing = timing * 1000
  character:update(timing)
  wizoob1:update(timing)
  wizoob2:update(timing)
  wizoob3:update(timing)
  dispatcher.update()
end

function love.draw()
  character:draw()
  wizoob1:draw()
  wizoob2:draw()
  wizoob3:draw()
end
