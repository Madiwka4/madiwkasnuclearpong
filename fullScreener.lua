fullScreener = Class{}
function fullScreener:init(a,b,c,d,e,f)
	self.a = a
	self.b = b
	self.c = c
    self.d = d 
    self.e = e 
    self.f = f 
end
function fullScreener:toggle(vh, vw)
	self.a = self.a + 1
    if (self.a > 1) then 
        self.a = 0
    end
    if (self.a == 0 ) then
    if (self.b == 1) then
            self.c = 1
        self.d = 1
        self.e = 0 
        self.f = 0 
        simpleScale.updateWindow(WINDOW_WIDTH, WINDOW_HEIGHT,{fullscreen = false})
        self.b = 0
    end

        end
        if (self.a == 1) then
    if (self.b == 0) then 
        simpleScale.updateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = true})
        local newWidth = love.graphics.getWidth()
        local newHeight = love.graphics.getHeight()
        self.c = VIRTUAL_WIDTH / newWidth
        self.d = VIRTUAL_HEIGHT / newHeight
        self.e = math.fmod(newWidth * self.d, VIRTUAL_WIDTH) / 2
        self.f = math.fmod(newHeight * self.d, VIRTUAL_HEIGHT) / 2
        self.b = 1

    end
end
end
