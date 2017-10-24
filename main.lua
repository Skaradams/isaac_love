local position = {
  x = 300,
  y = 200
}
local direction = 'stand'
local canShoot = true
local shoots = {}


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
  local step = 5;
  if love.keyboard.isDown("up") then
    position.y = position.y - step;
  elseif love.keyboard.isDown("down") then
    position.y = position.y + step;
  end
  if love.keyboard.isDown("left") then
    position.x = position.x - step;
  elseif love.keyboard.isDown("right") then
    position.x = position.x + step;
  end
end

function love.load()
  isaac = love.graphics.newImage("sprite.png")
end

function love.update()
  move()
  updateShoots()
end

function love.draw()
  love.graphics.draw(isaac, position.x, position.y)
  local i = 1
  love.graphics.setColor(255, 255, 255)
  while shoots[i] do
    love.graphics.circle("fill", shoots[i].x, shoots[i].y, 10, 100)
    i = i + 1
  end
end
