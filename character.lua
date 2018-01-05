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
  self.lifeMax = 5
  self.life = 5
  dispatcher.subscribe(dispatcher.channels.ENNEMY_SHOOTS, self)
  world:add(self, self.position.x - 80, self.position.y - 30, 70, 70)
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
  local newPosition = {
    x = self.position.x,
    y = self.position.y
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
    self.position.x = newPosition.x
    self.position.y = newPosition.y
    local newX, newY, collisions, collisionsCount = world:move(self, newPosition.x, newPosition.y)
    if(collisionsCount > 0) then
      print("touchay")
    end

    dispatcher.addMessage(
      {
        type = 'position',
        data = newPosition
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
    local newShoot = ShootGenerator:createShoot(
      self.position.x + 50,
      self.position.y + 50,
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
  self:move()
  self:shoot()
  self:updateShoots()
end

function Character:inbox(messages, channel)
  if channel == dispatcher.channels.ENNEMY_SHOOTS then
    for i, message in pairs(messages) do
      local shoot = message.data.shoot
      local offset = 50
      -- print(inspect(self.position), inspect(shoot.position))
      -- print('-----------------------')
      if(
        shoot.position.x > self.position.x and shoot.position.x < self.position.x + offset
        and shoot.position.y > self.position.y and shoot.position.y < self.position.y + offset
      ) then

      end
    end
  end
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
    shoot:draw()
  end
end

return Character
