local position = {
  x = 300,
  y = 200
}
local direction = 'stand'
local canShoot = true
local shoots = {}
local spriteState = {
  y = 1,
  x = 2
}


function love.keypressed(key)
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
    table.insert(shoots, {
      x = position.x + 50,
      y = position.y + 50,
      axis = axis
    })
  end
end


function updateShoots()
  local i = 1
  local y = 1
  local shoot
  local axis
  while shoots[i] do
    y = 1
    shoot = shoots[i]
    while shoot.axis[y] do
      axis = shoot.axis[y]
      shoot[axis.direction] = shoot[axis.direction] + axis.value
      y = y + 1
    end
    i = i + 1
  end
end

function move(direction)
  local step = 2;
  if love.keyboard.isDown("up") then
    spriteState.y = 4
    position.y = position.y - step;
  elseif love.keyboard.isDown("down") then
    spriteState.y = 1
    position.y = position.y + step;
  end
  if love.keyboard.isDown("left") then
    spriteState.y = 2
    position.x = position.x - step;
  elseif love.keyboard.isDown("right") then
    spriteState.y = 3
    position.x = position.x + step;
  end
end

function love.load()
  isaac = love.graphics.newImage("isaac_spritesheet.png")
end
local animationTimer = 0
function love.update(timing)
  animationTimer = animationTimer + timing
  print(animationTimer)
  if(animationTimer > 0.2) then
    spriteState.x = spriteState.x + 1
    if(spriteState.x > 3) then
      spriteState.x = 1
    end
    animationTimer = 0
  end
  move()
  updateShoots()
end

function love.draw()
  local width, height = isaac:getDimensions()
  print(
    width/3 * (spriteState.x - 1),
    height/4 * (spriteState.y - 1)
  )
  local quad = love.graphics.newQuad(
    width/3 * (spriteState.x - 1),
    height/4 * (spriteState.y - 1),
    width/3,
    height/4,
    isaac:getDimensions()
  )

  love.graphics.scale(1.5, 1.5)
  love.graphics.draw(isaac, quad, position.x, position.y)

  local i = 1
  love.graphics.setColor(255, 255, 255)
  while shoots[i] do
    love.graphics.circle("fill", shoots[i].x, shoots[i].y, 10, 100)
    i = i + 1
  end
end
