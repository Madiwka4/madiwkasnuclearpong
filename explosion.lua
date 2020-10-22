explosion = Class{}

function explosion:init(x, y, v, color)
	self.color = color 
	self.x = x 
	self.y = y 
    self.v = v
    self.range = 0  
    self.killed = false 
    print(self.i)
end

function explosion:update(dt)
    self.range = self.range + dt * 24 
    if self.range * self.v > VIRTUAL_WIDTH * 2 then 
        print("killing myself with range" .. self.range)
        self.killed = true
    end
end



function explosion:render()
    print("rendering myself" .. self.x .. " " .. self.y .. " " .. self.range .. " " .. self.v)
    love.graphics.setColor(color)
    love.graphics.circle("fill", self.x, self.y, self.range * self.v, 100)
end