local inspect = require('lib.inspect')
local class = require('lib.middleclass')
local Shoot = require('Shoot')

local ShootGenerator = class('ShootGenerator')

local minTimeDelta = 0.3


local function canShoot(shoot)
  local now = love.timer.getTime()

  return shoot.createdAt == nil or (now - shoot.createdAt) >= minTimeDelta
end

function ShootGenerator.static:createShoot(x, y, lastShoot, dispatcherChannel)
  if lastShoot then
  end
  if not lastShoot or canShoot(lastShoot) then
    return Shoot:new(x, y, dispatcherChannel)
  end
end

return ShootGenerator
