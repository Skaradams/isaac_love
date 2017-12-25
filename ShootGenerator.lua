local inspect = require('lib.inspect')
local class = require('lib.middleclass')
local Shoot = require('Shoot')

local ShootGenerator = class('ShootGenerator')

local minTimeDelta = 0.4


local function canShoot(shoot)
  local now = love.timer.getTime()
  print(now, shoot.createdAt)
  return shoot.createdAt == nil or (now - shoot.createdAt) >= minTimeDelta
end

function ShootGenerator.static:createShoot(x, y, lastShoot)
  if lastShoot then
  end
  if not lastShoot or canShoot(lastShoot) then
    return Shoot:new(x, y)
  end
end

return ShootGenerator
