function love.load()
	player = {
		x = 256,
		y = 256,
		act_x = 32,
		act_y = 32,
		speed = .125,

    -- STATS

    hp = 100,
    strength = 10,
    defense = 10,
    intelligence = 10,
    xp = 0




	}
	moving = false
	delay_count = 0
end

function draw_health_bar()
   love.graphics.rectangle("fill", 10, love.graphics.getHeight() - 100, ((player.hp/100) * 250), 20)
   love.graphics.rectangle("line", 10, love.graphics.getHeight() - 100, 250, 20)
end

function draw_currently_equipped_item()

end

function draw_hud()

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




function love.draw()
	love.graphics.rectangle("fill", player.act_x, player.act_y, 32, 32)
  draw_hud()
end


function love.keypressed(key)
	if key == 'escape' then 
		love.event.quit()
	end

	if key == 'h' then
    player.hp = player.hp + 10
	end


	if key == 'd' then
    player.hp = player.hp - 10
	end

end
