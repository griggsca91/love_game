function love.load()
	player = {
		x = 256,
		y = 256,
		act_x = 32,
		act_y = 32,
		speed = .5
	}
	moving = false
	delay = .125 
	delay_count = 0
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
		moving = delay > delay_count
	end

	player.act_y = player.act_y - ((player.act_y - player.y))
	player.act_x = player.act_x - ((player.act_x - player.x))
end




function love.draw()
	love.graphics.rectangle("fill", player.act_x, player.act_y, 32, 32)
end


function love.keypressed(key)
	if key == 'escape' then 
		love.event.quit()
	end

	if key == 'd' then
		debug.debug()
	end

end
