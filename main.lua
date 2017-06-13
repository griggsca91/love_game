
maps = require "maps"

function love.load()


  STATES = {
    GAME = "GAME",
    MAP_EDITOR = "MAP_EDITOR",
  }

  cur_state = STATES.MAP_EDITOR
  
	player = {
		x = 256,
		y = 256,
		act_x = 32,
		act_y = 32,
		speed = .125,

    -- STATS

    cur_hp = 100,
    max_hp = 100,
    strength = 10,
    defense = 10,
    intelligence = 10,
    xp = 0

	}
	moving = false
	delay_count = 0

  log_file = love.filesystem.newFile("log"..os.time()..".txt")
  log_file:open("a") 


  map = maps.map1

end

function log(log_m)
  
  log_file:write(log_m.."\r\n")

  print(log_m)
end



function draw_health_bar()
   love.graphics.rectangle("fill", 10, love.graphics.getHeight() - 100, ((player.cur_hp/player.max_hp) * 250), 20)
   love.graphics.rectangle("line", 10, love.graphics.getHeight() - 100, 250, 20)
end

function draw_currently_equipped_item()

end

function draw_hud()

  draw_map()

  draw_health_bar()
  draw_currently_equipped_item()  



end

function love.update(dt)

	if not moving then		
		if love.keyboard.isDown("down") then 
			player.y = player.y + 32 
			moving = true
		end
		if love.keyboard.isDown('up') then 
			player.y = player.y - 32 
			moving = true
		end
		if love.keyboard.isDown('left') then 
			player.x = player.x - 32 
			moving = true
		end
		if love.keyboard.isDown('right') then 
			player.x = player.x + 32 
			moving = true
		end
		delay_count = 0
	else
		delay_count = delay_count + dt
		moving = player.speed > delay_count
	end

	player.act_y = player.act_y - ((player.act_y - player.y))
	player.act_x = player.act_x - ((player.act_x - player.x))
end


function draw_map()


  for y=1, #maps.map1 do
    for x=1, #maps.map1[y] do
      if  maps.map1[y][x] > 0 then
        love.graphics.rectangle("line", x*32, y*32, 32, 32)
      end
    end
  end


end

function love.draw()
	love.graphics.rectangle("fill", player.act_x, player.act_y, 32, 32)
  draw_hud()
end

function get_cursor_coords()
  print(player.act_x)
  print(player.act_y)
  local x = player.act_x / 32
  local y = player.act_y / 32
  return x,y
end

function process_game_key(key)
  if key == 'h' then
    log("Heal")
      if player.max_hp < player.cur_hp + 10 then
        player.cur_hp = player.max_hp
      else 
        player.cur_hp = player.cur_hp + 10 
      end
	end
	if key == 'd' then
    log("Damage")
    if 0 > player.cur_hp - 10 then 
      player.cur_hp = 0
    else 
      player.cur_hp = player.cur_hp - 10
    end
	end


  if key == 'space' then
    log("Attack")
  end


end

--TODO: Save the map to a file
function save_map()
end

function toggle_selected_block()

  local x, y = get_cursor_coords()

  if maps.map1[y][x] > 0 then
    maps.map1[y][x] = 0
  else
    maps.map1[y][x] = 1
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
    if cur_state == STATES.GAME then
      cur_state = STATES.MAP_EDITOR
    else
      cur_state = STATES.GAME
    end
  end


  if cur_state == STATES.GAME then
    process_game_key(key)
  elseif cur_state == STATES.MAP_EDITOR then 
    process_map_editor(key) 
	end

end
