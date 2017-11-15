-- list of availables ennemy types
local pool = {
  wizoob = {
    image: 'wizoob.png'
  }
}

-- list of ennemies in room
local spawned = {}

function spawn(type) {
  if(type) then
    local ennemy = pool[type]
    ennemy.x = 450
    ennemy.y = 300
    table.insert(spawned, ennemy)
  end
}
