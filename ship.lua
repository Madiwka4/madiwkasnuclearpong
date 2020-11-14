ship = Class{}





function ship:init()
    self.direction = love.math.random(0, 2)
    if self.direction == 0 then 
        self.y = VIRTUAL_HEIGHT + 100
        self.image = love.graphics.newImage('img/SPC/blue_0' .. love.math.random(1,6) .. '.png')
        self.scroll = -1 * love.math.random(80, 120) - background_scroll_speed
    else 
        self.y = -100
        self.image = love.graphics.newImage('img/SPC/red_0' .. love.math.random(1,6) .. '.png')
        self.scroll = love.math.random(80, 120) - background_scroll_speed
    end 
    self.x = love.math.random(40, VIRTUAL_WIDTH - 40)
    
    
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.destroyed = false 
    self.deathCounter = 0
self.deathNumber = 1 
end

function ship:update(dt)

    --print("Width " .. self.width .. " Height: " .. self.height)
    if self.destroyed then 
        self:deathanimation(dt)
    end
    self.y = self.y + self.scroll * dt
    --print("traveling at " .. self.y .. " " .. self.x)
    for i, ball in pairs(ball) do 
        print("BALL IS AT: " .. ball.x .. " " .. ball.y)
        print("I AM AT " .. self.x .. " " .. self.y)
        if self:collides(ball) then 
            print("KABOOM")
            self.destroyed = true 
        end 
    end 
end 

function ship:deathanimation(dt)
    self.deathCounter = self.deathCounter + dt 
    if self.deathCounter > 0.1 and self.deathNumber < 12 then 
        self.image = love.graphics.newImage('img/SPC/Explosion/explosion-' .. self.deathNumber .. '.png')
        self.deathCounter = 0
        self.deathNumber = self.deathNumber + 1
    end
end 

function ship:collides(object)
    if (object.y > self.y and object.y < self.y + self.height and
    object.x > self.x and
    object.x < self.x + self.width ) then 
        print("!!!!!!!!!!!!!" .. object.y .. " > " .. self.y .. " and " .. object.y .. " < " .. self.y + self.height .. " " .. object.x .. " > " .. self.x .. " and " .. object.x .. " < " .. self.x + self.width)
        return true 
        
    else
        return false
    end
    print("Shit detection")
end

function ship:render()
    if self.direction ~= 0 then 
    love.graphics.draw(self.image, self.x, self.y+self.height, 0, 1, -1)
    else
        love.graphics.draw(self.image, self.x, self.y)
    end
end 