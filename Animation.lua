local class = require('lib.middleclass')
local inspect = require('lib.inspect')

local Animation = class('Animation')

Animation.DIRECTIONS = {
  LEFT = "left",
  DOWN = "down",
  UP = "up",
  RIGHT = "right"
}

function Animation:initialize(id, name, direction)
  self.config = require('assets.animations.' .. id .. '.config')
  self.direction = direction
  self.name = name
  self.lastTimer = 0
  self.currentFrame = 0
  self.spriteSheets = {}
  for i, current_direction in pairs(self.DIRECTIONS) do
    self.spriteSheets[current_direction] = love.graphics.newImage("assets/animations/" .. id .. "/" .. name .. '/' .. direction .. ".png")
  end
  self.quad = self:getQuad()
end

function Animation:getQuadDimensions()
  local width, height = self.spriteSheets[self.direction]:getDimensions()
  return width/self.config[self.name].frame_count, height
end

function Animation:getQuad()
  local width, height = self:getQuadDimensions()
  return love.graphics.newQuad(
    width * self.currentFrame,
    0,
    width,
    height,
    self.spriteSheets[self.direction]:getDimensions()
  )
end

function Animation:setDirection(direction)
  self.direction = direction
end

function Animation:update(timeDelta)
  self.lastTimer = self.lastTimer + timeDelta
  print(self.lastTimer)
  -- Loop through frames
  if self.lastTimer > self.config[self.name].frame_duration/1000 then
    self.currentFrame = self.currentFrame + 1
    if self.currentFrame >= self.config[self.name].frame_count then
      self.currentFrame = 1
    end
    self.lastTimer = 0
  end
end

function Animation:getFrame()
  return self.spriteSheets[self.direction], self:getQuad()
end

return Animation
