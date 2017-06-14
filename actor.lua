local Actor = {}

Actor.TYPES = {
  PLAYER = "PLAYER",
  ENEMY = "ENEMY"
}


function Actor:new(o)

  o = o or {}

  if o.stats == nil then
    o.stats = {
      max_hp = 100,
      cur_hp = 100,
      strength = 10,
      defense = 10,
      intelligence = 10,
      xp = 0
    }
  end
 
  if o.speed == nil then o.speed = .125 end
  
  if o.x == nil then error("Please provide an x position") end
  if o.y == nil then error("Please provide a y position") end

  -- Player specific properties only
  if o.off_x == nil then o.off_x = 0 end
  if o.off_y == nil then o.off_y = 0 end
  
  if o.actor_type == nil then o.actor_type = Actor.TYPES.PLAYER end

  setmetatable(o, self)
  self.__index = self

  return o
end





return Actor
