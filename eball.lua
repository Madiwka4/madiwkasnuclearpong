eball = Class{}

function eball:init(x, y, width, height)
		
		self.x = x 
		self.y = y 
		self.width = width 
		self.height = height 

		self.dy = math.random(-1, 1)
		self.dx = 1
		self.disabled = false
end
	
function eball:collides(paddle)
	if paddle.player == 2 and gameMode == 'practice' then return false
	else 
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 
	return true
end
end
function eball:reset(ballnum, player)
	if (gameMode == 'practice') then 
		if (self.x < 1) then 
			--love.window.setTitle(self.x)
			if not player then 
				self.x = VIRTUAL_WIDTH /2 - 2
			elseif player == 1 then 
				self.x = 50 
			elseif player == 2 then 
				self.x = VIRTUAL_WIDTH - 50
			else 
				self.x = VIRTUAL_WIDTH /2 - 2
			end
	
	self.y = VIRTUAL_HEIGHT /2 - 2
	self.dy = math.random(-1, 1)
	self.dx = math.random(-1,1) 
else  self.x = self.x self.y = self.y self.dx = -1 end
else
	if (ballnum == 2) then 
		self.dx = ball_DIR * -1
	else
		self.dx = ball_DIR
	end
	self.disabled = false 
	if not player then 
		self.x = VIRTUAL_WIDTH /2 - 2
	elseif player == 1 then 
		self.x = 50 
	elseif player == 2 then 
		self.x = VIRTUAL_WIDTH - 50
	else 
		self.x = VIRTUAL_WIDTH /2 - 2
	end
	self.y = VIRTUAL_HEIGHT /2 - 2
	self.dy = math.random(-1, 1)
	
	--love.window.setTitle("LMAOOOOOO")
end
end


function eball:update(dt)
	if player1nukescore > 20 then 
		potentialstrike1 = 1 
	else 
		potentialstrike1 = 0 
	end 
	if player1nukescore > 140 then 
		player1reverbav = 1 
	else 
		player1reverbav = 0 
	end 
	if player1nukescore > 200 then 
		potentialnuke1 = 1 
	else 
		potentialnuke1 = 0
	end
	if player2nukescore > 20 then 
		potentialstrike2 = 1 
	else 
		potentialstrike2 = 0 
	end 
	if player2nukescore > 140 then 
		player2reverbav = 1 
	else 
		player2reverbav = 0 
	end 
	if player2nukescore > 200 then 
		potentialnuke2 = 1 
	else 
		potentialnuke2 = 0
	end
	if self.disabled == false then 
    self.x = self.x + ballSpeed * self.dx * dt 
	self.y = self.y + ballSpeed * self.dy * dt
	end
end

function eball:render(color)
	if color == 'black' then 
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
	elseif color == 'controlled' then
		love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
	else 
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
	end
end