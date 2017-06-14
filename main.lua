Map = require "maps"
Actor = require "actor"


function love.load()

  STATES = {
    GAME = "GAME",
    MAP_EDITOR = "MAP_EDITOR",
  }

  DIRECTION = {
    UP = "up",
    DOWN = "down",
    LEFT = "left", 
    RIGHT = "right"
  }

  cur_state = STATES.MAP_EDITOR
--[[
  player = {
    x = love.graphics.getWidth()/2,
    y = love.graphics.getWidth()/2,
    off_x = 0,
    off_y = 0,
    speed = .125,
    -- STATS
    cur_hp = 100,
    max_hp = 100,
    strength = 10,
    defense = 10,
    intelligence = 10,
    xp = 0
  }
  --]]

  player = Actor:new({
    x = love.graphics.getWidth()/2,
    y = love.graphics.getHeight()/2
  })


  badies = {}

  for i = 1,10 do
    badies[i] = Actor:new({
      x = i*32,
      y = i*32
    })
    print("x: "..badies[i].x.."y: "..badies[i].y)
  end

  moving = false
  delay_count = 0

  log_file = love.filesystem.newFile("log"..os.time()..".txt")
  log_file:open("a") 

  log("loading maps.map")
  cur_map = Map:load("maps.map")
  if cur_map == nil then
    log('maps.map could not be loaded, creating a new map')
    cur_map = Map:new()
  end
end

function log(log_m)
  
  log_file:write(log_m.."\r\n")

  print(log_m)
end

function draw_badies()
 
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(255, 0, 0)
  for i = 1, #badies do 
    log("x "..(badies[i].x-player.off_x).." y: "..(badies[i].y-player.off_y))
    love.graphics.rectangle("fill", (badies[i].x)-player.off_x, (badies[i].y)-player.off_y, 32, 32)
  end
  love.graphics.setColor(r, g, b, a)
end

function draw_health_bar()
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("fill", 10, love.graphics.getHeight() - 100, ((player.stats.cur_hp/player.stats.max_hp) * 250), 20)
  love.graphics.rectangle("line", 10, love.graphics.getHeight() - 100, 250, 20)
  love.graphics.setColor(r, g, b, a)
end

function draw_hud()
  draw_health_bar()
end

function love.update(dt)

  if not moving then		
    if love.keyboard.isDown(DIRECTION.DOWN)
      and can_move(player.x, player.y, DIRECTION.DOWN) then 
      log("DOWN: player.y: "..player.y.." player.x: "..player.x)
      player.y = player.y + 32 
      player.off_y = player.off_y + 32
      moving = true
      log("DOWN: player.y: "..player.y.." player.x: "..player.x)
    end
    if love.keyboard.isDown(DIRECTION.UP)
      and can_move(player.x, player.y, DIRECTION.UP) then 
      log("UP: player.y: "..player.y.." player.x: "..player.x)
      player.y = player.y - 32 
      player.off_y = player.off_y - 32
      moving = true
      log("UP: player.y: "..player.y.." player.x: "..player.x)
    end
    if love.keyboard.isDown(DIRECTION.LEFT)
      and can_move(player.x, player.y, DIRECTION.LEFT) then 
      log("LEFT: player.y: "..player.y.." player.x: "..player.x)
      player.x = player.x - 32 
      player.off_x = player.off_x - 32
      moving = true
      log("LEFT: player.y: "..player.y.." player.x: "..player.x)
    end
    if love.keyboard.isDown(DIRECTION.RIGHT)
      and can_move(player.x, player.y, DIRECTION.RIGHT) then 
      log("RIGHT: player.y: "..player.y.." player.x: "..player.x)
      player.x = player.x + 32 
      player.off_x = player.off_x + 32
      moving = true
      log("RIGHT: player.y: "..player.y.." player.x: "..player.x)
    end
    delay_count = 0
    --	log("player.x: "..player.x.." player.act_x: "..player.act_x.." player.y: "..player.y.." player.act_y: "..player.act_y)
  else
    delay_count = delay_count + dt
    moving = player.speed > delay_count
  end

  --	player.act_y = player.act_y - ((player.act_y - player.y))
  --	player.act_x = player.act_x - ((player.act_x - player.x))

end

function draw_map()
  local r, g, b, a = love.graphics.getColor()

  love.graphics.setColor(204, 204, 204)

  for y=1, #cur_map.data do
    for x=1, #cur_map.data[y] do
      if  cur_map.data[y][x] > 0 then
        love.graphics.rectangle("fill", (x*32)-player.off_x, (y*32)-player.off_y, 32, 32)
      end
    end
  end

  love.graphics.setColor(r, g, b, a)

end


function draw_player()
  local r, g, b, a = love.graphics.getColor()

  love.graphics.setColor(255,102, 0) 
  love.graphics.rectangle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 32, 32)
  love.graphics.setColor(r, g, b, a)
end

function love.draw()
  draw_map()
  draw_player() 
  draw_badies()
  draw_hud()
end


function conv_pixels_to_coords(x_pix, y_pix)
	return (x_pix/32), (y_pix/32)
end


function get_cursor_coords()
  return conv_pixels_to_coords(player.x, player.y)
end

function can_move(x_pix, y_pix, direction)


  if cur_state == STATES.MAP_EDITOR then return true end

  local dir_x, dir_y = conv_pixels_to_coords(x_pix, y_pix)

  if direction == DIRECTION.UP then dir_y = dir_y - 1
  elseif direction == DIRECTION.DOWN then dir_y = dir_y + 1
  elseif direction == DIRECTION.LEFT then dir_x = dir_x - 1
  elseif direction == DIRECTION.RIGHT then dir_x = dir_x + 1
  else error("Direction: "..direction.." is not a valid value")
  end

  -- log("can_move - x: "..dir_x..", y: "..dir_y.." - "..tostring((cur_map.data[dir_y][dir_x] == 0)))

	return cur_map.data[dir_y][dir_x] == 0 
end


function process_game_key(key)
  if key == 'h' then
    log("Heal")
    if player.stats.max_hp < player.stats.cur_hp + 10 then
      player.stats.cur_hp = player.stats.max_hp
    else 
      player.stats.cur_hp = player.stats.cur_hp + 10 
    end
  end
  if key == 'd' then
    log("Damage")
    if 0 > player.stats.cur_hp - 10 then 
      player.stats.cur_hp = 0
    else 
      player.stats.cur_hp = player.stats.cur_hp - 10
    end
  end

  if key == 'space' then
    log("Attack")
  end

end

--TODO: Save the map to a file
function save_map()
  log("saving map: "..cur_map.title)
  cur_map:save()
end

function toggle_selected_block()
  local x, y = get_cursor_coords()
  log("toggling x: "..x.." y: "..y)
  if cur_map.data[y][x] > 0 then
    cur_map.data[y][x] = 0
  else
    cur_map.data[y][x] = 1
  end
end

function process_map_editor(key)

  if key == "s" then
    save_map()
  end

  if key == "space" then
    toggle_selected_block()
  end

end

function love.keypressed(key)
  log("Key: "..key)

  if key == 'escape' then 
    log("Quiting")
    log_file:close()
    love.event.quit()
  end

  -- TOGGLE STATE
  if key == "`" then
    log("cur_state: "..cur_state)
    if cur_state == STATES.GAME then
      cur_state = STATES.MAP_EDITOR
    else
      cur_state = STATES.GAME
    end
    log("switched to: "..cur_state)
  end


  if cur_state == STATES.GAME then
    process_game_key(key)
  elseif cur_state == STATES.MAP_EDITOR then 
    process_map_editor(key) 
  end

end
