local inspect = require('lib.inspect')
local class = require('lib.middleclass')
local dispatcher = require('dispatcher')
local ShootGenerator = require('ShootGenerator')
local getWorld = require('World')

local Character = class('Character')
local world = getWorld()

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

  self.direction = 'stand'
  self.canShoot = true
  self.spriteState = {
    y = 1,
    x = 2
  }
  self.animationTimer = 0
  self.shoots = {}
  self.spritesheet = love.graphics.newImage("isaac_spritesheet.png")
  self.lifeMax = 5
  self.life = 5
  dispatcher.subscribe(dispatcher.channels.ENNEMY_SHOOTS, self)

  world:add(self, position.x, position.y, 70, 70)
end

function Character:updateShoots()
  local shoot
  local axis
  for i, shoot in pairs(self.shoots) do
    shoot:update()
  end
end

function Character:move()
  local positionX, positionY, width, height = world:getRect(self)
  local step = 2
  local didMove = false
  local newPosition = {
    x = positionX,
    y = positionY
  }
  if love.keyboard.isDown("up") then
    didMove = true
    self.spriteState.y = 4
    newPosition.y = newPosition.y - step;
  elseif love.keyboard.isDown("down") then
    didMove = true
    self.spriteState.y = 1
    newPosition.y = newPosition.y + step;
  end
  if love.keyboard.isDown("left") then
    didMove = true
    self.spriteState.y = 2
    newPosition.x = newPosition.x - step;
  elseif love.keyboard.isDown("right") then
    didMove = true
    self.spriteState.y = 3
    newPosition.x = newPosition.x + step;
  end
  if(didMove) then
    local newX, newY, collisions, collisionsCount = world:move(self, newPosition.x, newPosition.y)

    dispatcher.addMessage(
      {
        type = 'position',
        data = {
          x = newX,
          y = newY
        }
      },
      dispatcher.channels.CHARACTER
    )
  end
end

function Character:keypressed()
end

function Character:shoot()
  local speed = {}
  local createShoot = false
  local step = 8;
  if love.keyboard.isDown("z")  then
    speed.y = -step
    createShoot = true
  elseif love.keyboard.isDown("s") then
    speed.y = step
    createShoot = true
  end
  if love.keyboard.isDown("q") then
    speed.x = -step
    createShoot = true
  elseif love.keyboard.isDown("d") then
    speed.x = step
    createShoot = true
  end
  if createShoot then
    local positionX, positionY, width, height = world:getRect(self)
    local newShoot = ShootGenerator:createShoot(
      positionX + 50,
      positionY + 50,
      self.shoots[#self.shoots],
      dispatcher.channels.CHARACTER_SHOOTS
    )
    if newShoot then
      newShoot:setSpeed(speed.x, speed.y)
      table.insert(self.shoots, newShoot)
    end
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
  self:checkCollisions()
  self:move()
  self:shoot()
  self:updateShoots()
end

function Character:checkCollisions()
  local x, y, collisions, collisionsCount = world:check(self)
  if collisionsCount > 0 then
    for i, collision in pairs(collisions) do
      if collision.other.class.name == "Shoot" then
        collision.other:collide(self)
        self:collide(collision.other)
      end
    end
  end
end

function Character:collide(other)
  if other.class.name == "Shoot" then
    self.life = self.life - 1
  end
end

function Character:inbox(messages, channel)

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
  local positionX, positionY, rectWidth, rectHeight = world:getRect(self)
  love.graphics.draw(
    self.spritesheet,
    self.spritequad,
    positionX,
    positionY
  )

  love.graphics.setColor(255, 255, 255)
  for i, shoot in pairs(self.shoots) do
    shoot:draw()
  end
  love.graphics.print(self.life, 10, 10)
end

return Character
