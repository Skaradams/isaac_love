local inspect = require('lib.inspect')
local class = require('lib.middleclass')
local dispatcher = require('dispatcher')
local Shoot = require('Shoot')

local Character = class('Character')

function Character:initialize(position)
  local default = {
    x = 200,
    y = 200
  }
  if(not position) then
    position = default
  else
    if(not position.x) then
      position.x = default.x
    end
    if(not position.y) then
      position.y = default.y
    end
  end

  self.position = position
  self.direction = 'stand'
  self.canShoot = true
  self.spriteState = {
    y = 1,
    x = 2
  }
  self.animationTimer = 0
  self.shoots = {}
  self.spritesheet = love.graphics.newImage("isaac_spritesheet.png")
end

function Character:updateShoots()
  local shoot
  local axis
  for i, shoot in pairs(self.shoots) do
    shoot:update()
  end
end

function Character:move()
  local step = 2
  local didMove = false
  if love.keyboard.isDown("up") then
    didMove = true
    self.spriteState.y = 4
    self.position.y = self.position.y - step;
  elseif love.keyboard.isDown("down") then
    didMove = true
    self.spriteState.y = 1
    self.position.y = self.position.y + step;
  end
  if love.keyboard.isDown("left") then
    didMove = true
    self.spriteState.y = 2
    self.position.x = self.position.x - step;
  elseif love.keyboard.isDown("right") then
    didMove = true
    self.spriteState.y = 3
    self.position.x = self.position.x + step;
  end
  if(didMove) then
    dispatcher.addMessage(
      {
        type = 'position',
        data = self.position
      },
      dispatcher.channels.CHARACTER
    )
  end
end

function Character:keypressed(key)
  local speed = {}
  local createShoot = false
  local step = 8;

  if key == "z"  then
    speed.y = -step
    createShoot = true
  elseif key == "s" then
    speed.y = step
    createShoot = true
  end
  if key == "q" then
    speed.x = -step
    createShoot = true
  elseif key == "d" then
    speed.x = step
    createShoot = true
  end
  if createShoot then
    local newShoot = Shoot:new(
      self.position.x + 50,
      self.position.y + 50,
      self
    )
    newShoot:setSpeed(speed.x, speed.y)
    table.insert(self.shoots, newShoot)
  end
end

function Character:update(timing)
  self.animationTimer = self.animationTimer + timing
  if(self.animationTimer > 0.2) then
    self.spriteState.x = self.spriteState.x + 1
    if(self.spriteState.x > 3) then
      self.spriteState.x = 1
    end
    self.animationTimer = 0
  end
  self:move()
  self:updateShoots()
end

function Character:draw()
  local width, height = self.spritesheet:getDimensions()
  self.spritequad = love.graphics.newQuad(
    width/3 * (self.spriteState.x - 1),
    height/4 * (self.spriteState.y - 1),
    width/3,
    height/4,
    self.spritesheet:getDimensions()
  )
  love.graphics.draw(
    self.spritesheet,
    self.spritequad,
    self.position.x,
    self.position.y
  )

  love.graphics.setColor(255, 255, 255)
  for i, shoot in pairs(self.shoots) do
    print(i)
    shoot:draw()
  end
end

return Character
