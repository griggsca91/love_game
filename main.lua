function love.load()
	player = {
		x = 256,
		y = 256,
		act_x = 32,
		act_y = 32,
		speed = 10
	}
end



function love.update(dt)
	player.act_y = player.act_y - ((player.act_y - player.y) * player.speed * dt)
	player.act_x = player.act_x - ((player.act_x - player.x) * player.speed * dt)
end




function love.draw()
	love.graphics.rectangle("fill", player.x, player.y, 32, 32)
end


function love.keypressed(key)
	if key == 'down' then player.y = player.y + 32 
	elseif key == 'up' then player.y = player.y - 32 
	elseif key == 'left' then player.x = player.x - 32 
	elseif key == 'right' then player.x = player.x + 32 
	end

end
