local inspect = require('lib.inspect')
local class = require('lib.middleclass')
local dispatcher = require('dispatcher')
local ShootGenerator = require('ShootGenerator')
local getWorld = require('World')
local Animation = require('Animation')


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

  self.canShoot = true
  self.shoots = {}

  self.lifeMax = 5
  self.life = 5

  self.animations = {
    walk = Animation:new('character', 'walk', Animation.DIRECTIONS.LEFT)
  }

  dispatcher.subscribe(dispatcher.channels.ENNEMY_SHOOTS, self)
  local width, height = self.animations.walk:getQuadDimensions()

  -- Compute hitbox dimensions as a percentage of sprite dimensions
  local offsetX, offsetY = math.floor(width*20/100), math.floor(height*20/100)
  self.spriteOffset = {
    x = offsetX,
    y = offsetY
  }
  world:add(
    self,
    position.x + offsetX,
    position.y + offsetY,
    width - 2 * offsetX,
    height - 2 * offsetY
  )
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
    self.animations.walk:setDirection(Animation.DIRECTIONS.UP)
    newPosition.y = newPosition.y - step;
  elseif love.keyboard.isDown("down") then
    didMove = true
    self.animations.walk:setDirection(Animation.DIRECTIONS.DOWN)
    newPosition.y = newPosition.y + step;
  end
  if love.keyboard.isDown("left") then
    didMove = true
    self.animations.walk:setDirection(Animation.DIRECTIONS.LEFT)
    newPosition.x = newPosition.x - step;
  elseif love.keyboard.isDown("right") then
    didMove = true
    self.animations.walk:setDirection(Animation.DIRECTIONS.RIGHT)
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
  local direction;
  if love.keyboard.isDown("z")  then
    speed.y = -step
    createShoot = true
    direction = 'up'
  elseif love.keyboard.isDown("s") then
    speed.y = step
    createShoot = true
    direction = 'down'
  elseif love.keyboard.isDown("q") then
    speed.x = -step
    createShoot = true
    direction = 'left'
  elseif love.keyboard.isDown("d") then
    speed.x = step
    createShoot = true
    direction = 'right'
  end
  if createShoot then
    local positionX, positionY, width, height = world:getRect(self)
    local shootX, shootY = self:getShootPosition(direction)
    local newShoot = ShootGenerator:createShoot(
      shootX,
      shootY,
      self.shoots[#self.shoots],
      dispatcher.channels.CHARACTER_SHOOTS
    )
    if newShoot then
      newShoot:setSpeed(speed.x, speed.y)
      table.insert(self.shoots, newShoot)
    end
  end
end

function Character:getShootPosition(direction)
  local positionX, positionY, width, height = world:getRect(self)
  local shootOffset = 10

  if direction == 'up' then
    return positionX + width/2,
      positionY - self.spriteOffset.y - shootOffset
  elseif direction == 'down' then
    return positionX + width/2,
      positionY + height + self.spriteOffset.y + shootOffset
  elseif direction == 'left' then
    return positionX - self.spriteOffset.x - shootOffset,
      positionY - self.spriteOffset.y + shootOffset
  elseif direction == "right" then
    return positionX + width + self.spriteOffset.x + shootOffset,
      positionY - self.spriteOffset.y + shootOffset
  end
end

function Character:update(timing)
  for i, animation in pairs(self.animations) do
    animation:update(timing)
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
  local positionX, positionY, rectWidth, rectHeight = world:getRect(self)
  local sprite, quad = self.animations.walk:getFrame()
  love.graphics.draw(
    sprite,
    quad,
    positionX - self.spriteOffset.x,
    positionY - self.spriteOffset.y
  )
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle(
    "fill",
    positionX, positionY, rectWidth, rectHeight
  )

  for i, shoot in pairs(self.shoots) do
    shoot:draw()
  end
  love.graphics.print(self.life, 10, 10)
end

return Character
