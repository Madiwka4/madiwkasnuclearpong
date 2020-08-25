paddle = Class{}

function paddle:init(x, y, width, height, player)
	self.RED = 255
	self.GREEN = 255
	self.BLUE = 255
	self.x = x 
	self.y = y 
	self.width = width 
	self.height = height 
	self.dy = 0 
	self.xy = x
	self.yx = y
	self.velocity = 0
	self.shadowbonus = 0
	self.player = player
end

function paddle:update(dt)
	--love.window.setTitle(tostring(player1.velocity * dt) .. " " ..  tostring(player1.dy) .. " " ..  tostring(dt) )
	if areanuclear == 0 then 
		self.RED = 1
		self.GREEN = 1
		self.BLUE = 1
	else 
		self.RED = 0
		self.GREEN = 0
		self.BLUE = 0
	end
	if ((self.player == 1 and timeIsSlow2) or self.player == 2 and timeIsSlow) then 
		self.dy = self.dy / 2
	end
	if (self.dy == 0) then 
		self.velocity = self.velocity - (self.velocity - self.velocity / (1.4))*dt*20  
		if (self.velocity*dt < 0.5 and self.velocity*dt > -0.5) then 
			self.velocity = 0
		end
	else
		self.velocity = self.velocity + self.dy*7*dt
		
	end
	if (self.velocity < 0) then
    	if (self.y > 0) then 
			self.y = self.y + self.velocity * dt
		else 
			self.velocity = 0
		end
   	elseif (self.velocity > 0) then 
       	if (self.y < VIRTUAL_HEIGHT - 80) then 
			self.y = self.y + self.velocity * dt 
		else 
			self.velocity = 0
		end
	else 
		self.velocity = 0
	end

	if ((timeIsSlow == false and self.player == 1) or (timeIsSlow2 == false and self.player == 2)) then 
		if (math.abs(self.yx - self.y) < 11) then 
			self.yx = self.y 
		end
	if (self.yx < self.y) then 
		self.yx = self.yx + math.abs(paddle_SPEED/1.7) * 7 * dt 
	elseif (self.yx > self.y) then 
		self.yx = self.yx - math.abs(paddle_SPEED/1.7) * 7 * dt
	end
end


end



function paddle:render()
	love.graphics.setColor(self.RED, self.GREEN, self.BLUE, 60/255)
	love.graphics.rectangle('fill', self.xy, self.yx, self.width, self.height, 20, 20)
	love.graphics.setColor(self.RED, self.GREEN, self.BLUE, 255)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 20, 20)
	love.graphics.setColor(255, 255, 255, 255)
end