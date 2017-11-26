local class = require('lib.middleclass')

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
    for y, axis in pairs(shoot.axis) do
      shoot[axis.direction] = shoot[axis.direction] + axis.value
    end
  end
end

function Character:move()
  local step = 2;
  if love.keyboard.isDown("up") then
    self.spriteState.y = 4
    self.position.y = self.position.y - step;
  elseif love.keyboard.isDown("down") then
    self.spriteState.y = 1
    self.position.y = self.position.y + step;
  end
  if love.keyboard.isDown("left") then
    self.spriteState.y = 2
    self.position.x = self.position.x - step;
  elseif love.keyboard.isDown("right") then
    self.spriteState.y = 3
    self.position.x = self.position.x + step;
  end
end

function Character:keypressed(key)
  local axis = {};
  local step = 8;

  if key == "z"  then
    table.insert(axis, {
      direction = "y",
      value = -step;
    })
  elseif key == "s" then
    table.insert(axis, {
      direction = "y",
      value = step;
    })
  end
  if key == "q" then
    table.insert(axis, {
      direction = "x",
      value = -step;
    })
  elseif key == "d" then
    table.insert(axis, {
      direction = "x",
      value = step;
    })
  end
  if table.getn(axis) > 0 then
    print('insert shoot')
    table.insert(self.shoots, {
      x = self.position.x + 50,
      y = self.position.y + 50,
      axis = axis
    })
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
    love.graphics.circle("fill", shoot.x, shoot.y, 10, 100)
  end
end

return Character
