button = Class{}

function button:init(x, y, width, height, color)
    self.x = x 
    self.y = y
    self.w = width
    self.h = height
    self.color = color
end

function button:update(dt)

end



function button:render()
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle("fill", self.x,self.y, self.w, self.h)
    love.graphics.setColor(0, 0, 0, 255)
end