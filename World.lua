local bump = require('lib.bump')

local world

local function getWorld()
  if not world then
    world = bump.newWorld(50)
  end
  return world
end

return getWorld
