io.stdout:setvbuf('no')
Class = require 'class'
require 'paddle'
require 'simpleScale'
require 'TSerial'
require 'eball'
require 'fullScreener'
require 'superPowerControl'
require 'mainMenu'
require 'music'
require 'animator'
local serialize = require 'ser'
local shader_code = [[
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 pixel = Texel(image,uvs);
    return pixel * color;
}
]]
timeIsSlow = false 
timeIsSlow2 = false 
debug.shake = false
originalSpeed = 200
explosionRange = 0
blockinput = false
wall1width = 30
nuclearanimation = 3
easternum = 0
ball_DIR = 0
RED = 255
hitNum = {}
hitNum[1] = 0
hitNum[2] = 0
hitNum[3] = 0
hitNum[4] = 0
p1bonus = 0
p2bonus = 0
hitNum[5] = 0
hitNum[6] = 0
GREEN = 255
BLUE = 255
updateTEXT = 'Chalkboard Update'
maxBalls = 1
playerCount = 1
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
player1reverbav = 0
playertext = '1v1'
player2reverbav = 0
elapsed = 0
rotation = 0
TEXT = 'Nuclear Pong'
VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720
currentKey = " "
ptw = 10
danger = 'none'
danger2 = 'none'
nuckemodactive = 0
maxspeed = 700
DIFFERENCE_X = 1
DIFFERENCE_Y = 1
paddle_SPEED = 20
textamount = 15
AI_STRIKEMOD = 1000
resolutionWin = 0
AGAINST_AI = 0
RESOLUTION_SET = 0
AI_NUKEMOD = 1000
animstart = true
AI_SPEED = 30
craz = 0
AI_LEVEL = 500
isFullscreen = 0
prtext = 'Easy'
MAP_TYPE = 2
difficultyl = 300
req = 'pp'
ballSet = 200
p1control = {up = 'a', down = 'z', super = 's', counter = 'x'}
p2control = {up = ';', down = '.', super = 'l', counter = ','}
synctext = "Independent"
synctype = 0
function newButton(text, fn)
    return {
        text = text, 
        fn = fn,
        now = false,
        last = false
    }
end
function love.keyboard.mouseWasReleased()
    return love.keyboard.mouseisReleased
end
function autoSave(dt)
    autoTimer = autoTimer + dt
end

function balancer()
    if (player2score == 9 or player1score == 9) then 
        shakeDuration = 10
       -- love.window.setTitle("ALMOST WIN")
    end
        if (player1score < player2score) then 
            p1bonus = (player2score - player1score) * 5
        else
            p1bonus = 0
        end
                if (player2score < player1score) then 
            p2bonus = (player1score - player2score) * 5
        else
            p2bonus = 0
        end


    end
function newWall(wallx, wally, wallwidth, wallheight)
    return {
        wallx = wallx,
        wally = wally,
        walwidth = wallwidth,
        wallheight = wallheight
    }
end
speedParameters = {}
buttons = {}
difbuttons = {}
settings = {}
walls = {}
editorpicks = {}
controlSettings = {}
modeSelectorButtons= {}
pracdiff = {}
playerCountButtons = {}
function controlChanger()
    if (gameState == 'assign') then 
        love.graphics.clear(50/255,50/255,50/255,255)
        love.graphics.printf('SELECT BUTTON',0,VIRTUAL_HEIGHT / 2,VIRTUAL_WIDTH,'center')
    end
end
function love.load()
    simpleScale.setWindow(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
    configfile = io.open('config.lua', "r")
    configsave = io.open('config.lua', "w")
    shader = love.graphics.newShader(shader_code)
    time_1 = 0
    print("Debug active")
--load

testwalls = love.filesystem.load('save.lua')() 
if testwalls ~= nil then 
    walls = love.filesystem.load('save.lua')()
end



    light = 0
    image = love.graphics.newImage("Madi.png")
    table.insert(editorpicks, newButton("C", function() for k in pairs (walls) do walls[k] = nil end end))
    table.insert(editorpicks, newButton("S", function() love.filesystem.write('save.lua', serialize(walls)) end))
    table.insert(editorpicks, newButton("L", function() walls = love.filesystem.load('save.lua')() end))
    table.insert(buttons, newButton("Singleplayer", function() gameState = 'gameMode' end))
    table.insert(buttons, newButton("Multiplayer", function() gameState = 'multiMode' end))
    table.insert(buttons, newButton("Settings", function() AGAINST_AI = 0 gameState = 'windowsettings' end))
    table.insert(buttons, newButton("Exit", function() love.event.quit(0) end))
    table.insert(difbuttons, newButton("Easy", function() hardmanager('easy') end))
    table.insert(difbuttons, newButton("Normal", function() hardmanager('normal') end))
    table.insert(difbuttons, newButton("Hard", function() hardmanager('hard') end))
    table.insert(settings, newButton("Change Map", function() MAP_TYPE = MAP_TYPE + 1 end))
    table.insert(settings, newButton("Toggle Fullscreen", function() myscreen:toggle(VIRTUAL_HEIGHT, VIRTUAL_WIDTH) DIFFERENCE_X = myscreen.c DIFFERENCE_Y = myscreen.d end)) 
    table.insert(settings, newButton("Editor", function() gameState = 'editor' end))
    table.insert(settings, newButton("Speed Settings", function() gameState = 'speedSettings' end))
    table.insert(settings, newButton("Control Settings", function() gameState = 'controlSettings' end))
    table.insert(settings, newButton("Back to Menu", function() gameState = 'menu' end))
    table.insert(speedParameters, newButton("Back to Menu", function() gameState = 'windowsettings' end))
    --table.insert(speedParameters, newButton("Ball Speed: ", function() speedSetter('ball') end))
    table.insert(playerCountButtons, newButton("Ball Speed: ", function() speedSetter('ball') end))
    --table.insert(speedParameters, newButton("snc", function() speedSetter('snc') end))
    table.insert(playerCountButtons, newButton("snc", function() speedSetter('snc') end))
    table.insert(speedParameters, newButton("NUCLEAR MODE", function() speedSetter('nuclearmod') end))  
    table.insert(controlSettings, newButton("1up", function() gameState = 'assign' req = 'p1up' end))   
    table.insert(controlSettings, newButton("1down", function() gameState = 'assign' req = 'p1down' end))
    table.insert(controlSettings, newButton("1special",function() gameState = 'assign' req = 'p1super' end))
    table.insert(controlSettings, newButton("1ct", function() gameState = 'assign' req = 'p1ct' end))
    table.insert(controlSettings, newButton("2up", function() gameState = 'assign' req = 'p2up' end))   
    table.insert(controlSettings, newButton("2down", function() gameState = 'assign' req = 'p2down' end))
    table.insert(controlSettings, newButton("2special", function() gameState = 'assign' req = 'p2super' end))
    table.insert(controlSettings, newButton("2ct", function() gameState = 'assign' req = 'p2ct' end))
    table.insert(controlSettings, newButton("Default", function() p1control = {up = 'a', down = 'z', super = 's', counter = 'x'} p2control = {up = ';', down = '.', super = 'l', counter = ','} end))
    table.insert(controlSettings, newButton("Return", function() gameState = 'windowsettings' end))
    table.insert(modeSelectorButtons, newButton("Nuclear Pong", function() gameState = 'difficulty' end))
    table.insert(modeSelectorButtons, newButton("Nuclear Practice", function() gameState = 'prdiff' end))
    table.insert(modeSelectorButtons, newButton("Main Menu", function() gameState = 'menu' end))
    table.insert(pracdiff, newButton("Silverblade", function() speedSetter('practice') end))
    table.insert(pracdiff, newButton("Return", function() speedSetter('reset') gameState = 'gameMode' end))
    table.insert(pracdiff, newButton("Go!", function() gameMode = 'practice' hardmanager('practice') end))
    --table.insert(playerCountButtons, newButton("1v1", function() speedSetter('pc') end))
    table.insert(playerCountButtons, newButton("ballCount", function() speedSetter('ballz') end))
    table.insert(playerCountButtons, newButton("Return", function() speedSetter('reset') gameState = 'menu' end))
    table.insert(playerCountButtons, newButton("ptw", function() speedSetter('ptw') end))
    table.insert(playerCountButtons, newButton("Play", function() AGAINST_AI = 0 gameState = '1serve' end))


       
    --table.insert(speedParameters, newButton("Ball Speed: ", function() speedSetter() end))

         
    love.window.setTitle('NUCLEAR PONG')
    textphrases = {
        "Amazing", "Superb", "Absolutely beautiful!", "Awesome", "Look at That!", "Great", "Nice", "Boom!", "Dangerous!", "Astonishing!", "u/ebernerd saved me", "Absolutely Wonderful!", "Exsquisite", "Delicate", "Pow!", "Great Hit", "all hail nazarbayev"
    }
    sounds = {
        ['updateMusic'] = love.audio.newSource("audio/theme1.mp3", "static"),
        ['gayTheme'] = love.audio.newSource("audio/theme2.mp3", "static"),
        ['gayTheme2'] = love.audio.newSource("audio/theme3.mp3", "static"),
        ['gayTheme3'] = love.audio.newSource("audio/theme4.mp3", "static"),
        ['beep'] = love.audio.newSource("audio/hit1.mp3", "static"),
        ['wallhit'] = love.audio.newSource("audio/hit2.wav", "static"),
        ['win'] = love.audio.newSource("win.wav", "static"),
        ['score'] = love.audio.newSource("audio/score.wav", "static"),
        ['nuke'] = love.audio.newSource("audio/bomb.wav", "static"),
        ['striking'] = love.audio.newSource("audio/superhit.wav", "static"),
        ['nuclearhit'] = love.audio.newSource("audio/hit1.mp3", "static"),
        ['time'] = love.audio.newSource("audio/time.wav", "static")
    }
	love.graphics.setDefaultFilter('nearest', 'nearest')
	--comic sans lmao
    math.randomseed(os.time())
	smallfont = love.graphics.newFont('font.ttf', 30)
    scorefont = love.graphics.newFont('font.ttf', 90)
    love.graphics.setFont(smallfont)

	--push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
	--	fullscreen = isFullscreen,
	--	resizable = true,
	--	vsync = true,
	--})
player1score = 0
player2score = 0
areanuclear = 0
player1nukescore = 0
player2nukescore = 0
striken = 0
soundtype = 1
soundturn = 1
potentialstrike1 = 0
potentialstrike2 = 0
potentialnuke1 = 0
potentialnuke2 = 0
player1striken = 0
player2striken = 0
randomtext = 0
selecting = 0
number = 0
elec = 1
INDIC = {
    '', '', '', ''
}
--playe1nuke
player1 = paddle(0,30,10,100, 1)
player2 = paddle(VIRTUAL_WIDTH * 0.99, VIRTUAL_HEIGHT * 0.88, 10, 100, 2)
player3 = paddle(5000, 5000, 10, 100)
player4 = paddle(5000, 5000, 10, 100)
ball = {}
ball[1] = eball(VIRTUAL_WIDTH / 2 , VIRTUAL_HEIGHT / 2 - 2, 16, 16)
ball[2] = eball(VIRTUAL_WIDTH / 1.9 , VIRTUAL_HEIGHT / 2 - 2, 16, 16)
ball[3] = eball(VIRTUAL_WIDTH / 1.8, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
ball[4] = eball(VIRTUAL_WIDTH / 2.2, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
ball[5] = eball(VIRTUAL_WIDTH / 2.1, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
myscreen = fullScreener(RESOLUTION_SET, isFullscreen, DIFFERENCE_X, DIFFERENCE_Y)
mymenu = mainMenu()

ballSpeed = 200


ballDX = math.random(2) == 1 and 100 or -100
ballDY = math.random(-50, 50)

gameState = 'animation'
end
t = 0
shakeDuration = 0
shakeMagnitude = 1
function startShake(duration, magnitude)
    t, shakeDuration, shakeMagnitude = 0, duration or 1, magnitude or 5
end
function displayFPS()
love.window.setTitle(love.timer.getFPS())
end

function speedControl()
	if (ballSpeed > maxspeed and gameState == 'play') then
		ballSpeed = maxspeed
	end
end

function love.update(dt)
    staticanimatorcounter(dt)
    displayFPS()
    if areanuclear == 1  then 
        if nuclearanimation > 0 then 
        gameState = 'nuclearExplosion'
        nuclearanimation = nuclearanimation - dt
        explosionRange = explosionRange + dt*24
        elseif (gameState ~= 'play') then 
        gameState = 'play'
        explosionRange = 0
        end
    end
    if player1nukescore > 300 then 
        player1nukescore = 300 end 
    if player2nukescore > 300 then 
        player2nukescore = 300 end
	speedControl()
    balancer()
    dangerChecker()
	musicController('norm', 1)
	palleteController()
    if (gameState == 'animation') then 
            animator(dt)
    end
	    if t < shakeDuration then
        t = t + dt
    end
        elapsed = elapsed + dt  
    rotation = math.sin(elapsed * 2.5) * 0.7
   -- if (gameState == 'quickanim') then 
   -- time_1 = time_1 + dt
   -- light = 255 - time_1 * 150
   -- if (light < 0) then 
    --	time_1 = 0
    --	light = 0
    --    gameState = 'play'
    --end    	
    --	end
    for i=1, maxBalls do
    if (AGAINST_AI == 1 or gameState == 'start') then 
        for i = 1, maxBalls do
        if (ball[i].y - player2.y >= 50 and player2.x - ball[i].x < AI_LEVEL) then 
            player2.dy = AI_SPEED
        elseif (player2.y - ball[i].y >= -20 and player2.x - ball[i].x < AI_LEVEL) then 
            player2.dy = -AI_SPEED
        else 
            player2.dy = 0
        end
        if difficultyl == 350 and player2reverbav == true and VIRTUAL_WIDTH - ball[i].x < 90 and math.abs(ball[i].y - player2.y) > 150 then 
            sounds["time"]:play()  player2reverbav = false timeIsSlow2 = true originalPaddle = paddle_SPEED originalSpeed = ballSpeed player2reverbav = 0 potentialnuke2 = 0 potentialstrike2 = 0
        end

        if (player2nukescore > AI_STRIKEMOD and striken == 0)
            then 
                player2striken = 1
        elseif (player2nukescore > AI_NUKEMOD and striken == 1)
            then 
         if (areanuclear == 1) then maxspeed = maxspeed + 50 end
        sounds['nuke']:play()
        potentialstrike2 = 0
        areanuclear = 1
        ballSpeed = ballSpeed * 2
        if (synctype == 0)
        	then 
        paddle_SPEED = paddle_SPEED * 2 end
    if (synctype == 1)
    	then 
            paddle_SPEED = ballSpeed/10
            
    	end
                if (synctype == 0)
        	then 
        AI_SPEED = AI_SPEED * 2.2 end
    if (synctype == 1)
    	then 
    		AI_SPEED = ballSpeed * 1.1 /10
    	end
        player2nukescore = 0
        player2reverbav = 0
        potentialnuke2 = 0
    end
    end


            
    end
    if (ball[i].x < 0 - ballSpeed*0.5) then 
        if (gameMode ~= 'practice') then
        sounds['score']:play()
    end
            if (nuckemodactive == 0) then 
    areanuclear = 0
    nuclearanimation = 3
end
        striken = 0
        player1striken = 0
        player2striken = 0

        ballSpeed = ballSet
                if (synctype == 0)
        	then 
        paddle_SPEED = ballSet/10 end
        if (synctype == 1)
    	then 
    		paddle_SPEED = ballSpeed/10
    	end

        AI_SPEED = difficultyl/10
        player2score = player2score + 1
        if (player2score ==ptw and gameMode ~= 'practice') then
            for i = 1, maxBalls do
            ball[i]:reset(i)
        end
            sounds['win']:play() 
            gameState = 'done'
            TEXT = 'Player 2 Won!'
        else 
        gameState = '1serve'
        serveBot()
        for i = 1, maxBalls do
        ball[i]:reset(i)
    end
    end
    end
    if (ball[i].x > VIRTUAL_WIDTH + ballSpeed*0.5) then

        sounds['score']:play()
            if (nuckemodactive == 0) then 
    areanuclear = 0
    nuclearanimation = 3
end
        striken = 0
        player1striken = 0
        player2striken = 0
        ballSpeed = ballSet 

                if (synctype == 0)
        	then 
        paddle_SPEED = ballSet/10 
        AI_SPEED = ballSet/10 end
    if (synctype == 1)
    	then 
    		paddle_SPEED = ballSpeed/10
    		AI_SPEED = ballSpeed/10
    	end

        AI_SPEED = difficultyl/10
        player1score = player1score + 1
        if (player1score == ptw) then 
       
            ball[i]:reset(i)
    
            sounds['win']:play()
            gameState = 'done'
            TEXT = 'Player 1 Won!'
        else 

        gameState = '2serve'

        serveBot()
    
        ball[i]:reset(i)
    
end
    end
    end

    if (player1nukescore >= 20 and player1nukescore < 140) then
        potentialstrike1 = 1
        if (love.keyboard.isDown(p1control.super)) then
        player1striken = 1
        player1reverbav = 0
        --player1nukescore = 0
        end
    end
    if (player1nukescore >= 140) and timeIsSlow2 == false and timeIsSlow == false and maxBalls == 1 and ball[1].x < VIRTUAL_WIDTH/2 then player1reverbav = 1 if love.keyboard.isDown(p1control.counter) then powerControl(1, 'special') end end
    if (player1nukescore >= 200) then
        --sounds['nukeready']:play()
        potentialnuke1 = 1
        if (love.keyboard.isDown(p1control.super)) then
            sounds['nuke']:play()
            if areanuclear == 1 then maxspeed = maxspeed + 50 end
        areanuclear = 1
        potentialstrike1 = 0
        striken = 0
        ballSpeed = ballSpeed * 2
                if (synctype == 0)
        	then 
        paddle_SPEED = paddle_SPEED * 2 end
     if (synctype == 1)
    	then 
    		paddle_SPEED = ballSpeed/10
    	end
                        if (synctype == 0)
        	then 
        AI_SPEED = AI_SPEED * 2.2 end
    if (synctype == 1)
    	then 
    		AI_SPEED = ballSpeed * 1.1 /10
    	end
        player1nukescore = 0
        player1reverbav = 0
        potentialnuke1 = 0
        end 
    end 
    
    if (player2nukescore >= 20 and player2nukescore <= 140) then
        potentialstrike2 = 1 
        if (AGAINST_AI == 0) then    
        if (love.keyboard.isDown(p2control.super)) then 
        player2striken = 1
                player2reverbav = 0

        end
    end
    end
    if (player2nukescore >= 140) and timeIsSlow == false and timeIsSlow2 == false and maxBalls == 1 and ball[1].x > VIRTUAL_WIDTH/2 then player2reverbav = 1 
    	if love.keyboard.isDown(p2control.counter) then sounds["time"]:play()  player2reverbav = false timeIsSlow2 = true originalPaddle = paddle_SPEED originalSpeed = ballSpeed player2reverbav = 0 potentialnuke2 = 0 potentialstrike2 = 0 end end
    if (player2nukescore >= 200) then
       -- sounds['nukeready']:play()
        potentialnuke2 = 1
        if (love.keyboard.isDown(p2control.super) and AGAINST_AI == 0) then
            sounds['nuke']:play()
            if areanuclear == 1 then maxspeed = maxspeed + 50 end
        potentialstrike2 = 0
        areanuclear = 1
                player2reverbav = 0
        --player2nukescore = 0
        ballSpeed = ballSpeed * 2
                if (synctype == 0)
        	then 
        paddle_SPEED = paddle_SPEED * 2 end
    if (synctype == 1)
    	then 
    		paddle_SPEED = ballSpeed/10
    	end
                        if (synctype == 0)
        	then 
        AI_SPEED = AI_SPEED * 2.2 end
    if (synctype == 1)
    	then 
    		AI_SPEED = ballSpeed * 1.1 / 10
    	end
        player2nukescore = 0
        potentialnuke2 = 0
        end 
    end  


        if (love.keyboard.isDown(p1control.up)) 
        then
        player1.dy = (paddle_SPEED + p1bonus) * -1
        elseif (love.keyboard.isDown(p1control.down))
        then 
        player1.dy = paddle_SPEED + p1bonus

        else
        player1.dy = 0
    end
    if (AGAINST_AI == 0) then 
        if (love.keyboard.isDown(p2control.up)) 
        then
        player2.dy = (paddle_SPEED + p2bonus) * -1
        elseif (love.keyboard.isDown(p2control.down)) 
        then
        player2.dy = paddle_SPEED + p2bonus
        else 
        player2.dy = 0
        end    
    end
        if gameState == 'play' then
            --love.window.setTitle('VOID')
            for i = 1, maxBalls do
            if ball[i]:collides(player1) then
                print(debug.shake)
                if ((areanuclear == 0 and ((player1striken or player2striken) and (player1score > 9 or player2score > 9))) or debug.shake) then
                    print("Calling animation")
                    superanimator('tensehit', 1) 
                end
                --gameState = 'quickanim'
                if gameMode == 'practice' then 
                    player1score = player1score + 1
                end
                t = 0
                if (ballSpeed > 200) then 
                shakeMagnitude = ballSpeed/200
            else shakeMagnitude = 0 end
                shakeDuration = 1
                randomtext = love.math.random(1, #textphrases)
                TEXT = textphrases[randomtext]
                soundtype = love.math.random(1, 1.2)

                
            
                if (player1striken == 1) then 
                    TEXT = 'PLAYER 1 STRIKES'
                    ballSpeed = ballSpeed + player1nukescore
                    potentialnuke1 = 0
                    player1striken = 0
                    player1nukescore = 0
                    potentialstrike1 = 0
                    striken = 1
                if areanuclear == 0 then 
                sounds['striking']:setPitch(ballSpeed/250)
                sounds['striking']:play()
            else 
                sounds['nuclearhit']:setPitch(1)
                sounds['nuclearhit']:play()
            end
                else
                	if areanuclear == 0 then                 
                sounds['beep']:setPitch(ballSpeed/250)
                sounds['beep']:play()
            else 
                sounds['nuclearhit']:setPitch(1)
                sounds['nuclearhit']:play()            	
            end
        end
                if (striken == 1) then 
                player1nukescore = player1nukescore * 1.2
                        if (synctype == 0)
        	then 
        paddle_SPEED = paddle_SPEED * 1.10
    elseif (synctype == 1)
    	then 
    		paddle_SPEED = ballSpeed / 10
    	end
                                if (synctype == 0)
        	then 
        AI_SPEED = AI_SPEED * 1.10 end
    if (synctype == 1)
    	then 
    		AI_SPEED = ballSpeed * 1.1/10
    	end
                ballSpeed = ballSpeed * 1.10
                end 
                player1nukescore = player1nukescore + 10
                ball[i].dx = -ball[i].dx
                ball[i].x = player1.x + 30
                
                if (love.keyboard.isDown(p1control.up)) then
                    select = math.random(1,5)
                    if select == 1 then 
                        ball[i].dy = -1
                    elseif select == 2 then 
                        ball[i].dy = -1.2
                    elseif select == 3 then 
                        ball[i].dy = -1.5 
                    elseif select == 4 then 
                        ball[i].dy = -1.8 
                    elseif select == 5 then 
                        ball[i].dy = -2
                    end 
                elseif love.keyboard.isDown(p1control.down) then 
                    select = math.random(1,5)
                    if select == 1 then 
                        ball[i].dy = 1
                    elseif select == 2 then 
                        ball[i].dy = 1.2
                    elseif select == 3 then 
                        ball[i].dy = 1.5 
                    elseif select == 4 then 
                        ball[i].dy = 1.8 
                    elseif select == 5 then 
                        ball[i].dy = 2
                    end 
                else 
                if ball[i].dy < 0 then 

                    select = math.random(1,5)
                    if select == 1 then 
                        ball[i].dy = -1
                    elseif select == 2 then 
                        ball[i].dy = -1.2
                    elseif select == 3 then 
                        ball[i].dy = -1.5 
                    elseif select == 4 then 
                        ball[i].dy = -1.8 
                    elseif select == 5 then 
                        ball[i].dy = -2
                    end 
                else
                    select = math.random(1,5)
                    if select == 1 then 
                        ball[i].dy = 1
                    elseif select == 2 then 
                        ball[i].dy = 1.2
                    elseif select == 3 then 
                        ball[i].dy = 1.5 
                    elseif select == 4 then 
                        ball[i].dy = 1.8 
                    elseif select == 5 then 
                        ball[i].dy = 2
                    end 
                end
            end
            end
            if ball[i]:collides(player2) then 
                --ameState = 'quickanim'
                t = 0
                shakeDuration = 1
                if ((areanuclear == 0 and ((player1striken or player2striken) and (player1score > 9 or player2score > 9))) or debug.shake) then
                    superanimator('tensehit', 2) 
                end
                                if (ballSpeed > 200) then 
                shakeMagnitude = ballSpeed/200
                else 
                	shakeMagnitude = 0 end
                randomtext = love.math.random(1, #textphrases)
                TEXT = textphrases[randomtext]
                soundtype = love.math.random(1, 1.2)

                
            
                if (player2striken == 1) then 
                    TEXT = 'PLAYER 2 STRIKES'
                    ballSpeed = ballSpeed + player2nukescore
                    striken=1
                    player2striken = 0
                    potentialnuke2 = 0
                    player2nukescore = 0
                    potentialstrike2 = 0
                    
                                	if areanuclear == 0 then                 
                sounds['striking']:setPitch(ballSpeed/250)
                sounds['striking']:play()
            else 
                sounds['nuclearhit']:setPitch(1)
                sounds['nuclearhit']:play()            	
            end
                elseif (striken == 1) then 
                player2nukescore = player2nukescore * 1.5
                        if (synctype == 0) then paddle_SPEED = paddle_SPEED * 1.10 end
                        if (synctype == 1) then paddle_SPEED = ballSpeed/10 end
                                                if (synctype == 0)
        	then 
        AI_SPEED = AI_SPEED * 1.10 end
    if (synctype == 1)
    	then 
    		AI_SPEED = ballSpeed * 1.1 / 10
    	end
                ballSpeed = ballSpeed * 1.10
                                                	if areanuclear == 0 then                 
                sounds['beep']:setPitch(ballSpeed/250)
                sounds['beep']:play()
            else 
                sounds['nuclearhit']:setPitch(1)
                sounds['nuclearhit']:play()            	
            end
                else
                                                    	if areanuclear == 0 then                 
                sounds['beep']:setPitch(ballSpeed/250)
                sounds['beep']:play()
            else 
                sounds['nuclearhit']:setPitch(1)
                sounds['nuclearhit']:play()            	
            end
                end
                player2nukescore = player2nukescore + 10
                ball[i].dx = -ball[i].dx
                ball[i].x = player2.x - 30

                               if (love.keyboard.isDown(p2control.up) or AI_SPEED < 0) then 
                                select = math.random(1,5)
                                if select == 1 then 
                                    ball[i].dy = -1
                                elseif select == 2 then 
                                    ball[i].dy = -1.2
                                elseif select == 3 then 
                                    ball[i].dy = -1.5 
                                elseif select == 4 then 
                                    ball[i].dy = -1.8 
                                elseif select == 5 then 
                                    ball[i].dy = -2
                                end 
                elseif love.keyboard.isDown(p2control.down) or AI_SPEED > 0 then 
                    select = math.random(1,5)
                    if select == 1 then 
                        ball[i].dy = 1
                    elseif select == 2 then 
                        ball[i].dy = 1.2
                    elseif select == 3 then 
                        ball[i].dy = 1.5 
                    elseif select == 4 then 
                        ball[i].dy = 1.8 
                    elseif select == 5 then 
                        ball[i].dy = 2
                    end 
                else 
                if ball[i].dy < 0 then 

                    select = math.random(1,5)
                    if select == 1 then 
                        ball[i].dy = -1
                    elseif select == 2 then 
                        ball[i].dy = -1.2
                    elseif select == 3 then 
                        ball[i].dy = -1.5 
                    elseif select == 4 then 
                        ball[i].dy = -1.8 
                    elseif select == 5 then 
                        ball[i].dy = -2
                    end 
                else
                    select = math.random(1,5)
                    if select == 1 then 
                        ball[i].dy = 1
                    elseif select == 2 then 
                        ball[i].dy = 1.2
                    elseif select == 3 then 
                        ball[i].dy = 1.5 
                    elseif select == 4 then 
                        ball[i].dy = 1.8 
                    elseif select == 5 then 
                        ball[i].dy = 2
                    end 
                end
            end
            end
        if ball[i].y <= 0 then
                soundtype = love.math.random(1, 5)
                sounds['wallhit']:setPitch(ballSpeed/250)
                sounds['wallhit']:play()
            ball[i].y = 0
            ball[i].dy = -ball[i].dy

        end

        -- -4 to account for the ball's size
        if ball[i].y >= VIRTUAL_HEIGHT - 40 then
                soundtype = love.math.random(1, 5)
                sounds['wallhit']:setPitch(ballSpeed/250)
                sounds['wallhit']:play()
            ball[i].y = VIRTUAL_HEIGHT - 40
            ball[i].dy = -ball[i].dy
        end           
            --love.window.setTitle('Trying to update the ball') 
            if timeIsSlow then 
                if ballSpeed > originalSpeed/3 then 
                    paddle_SPEED = 30
                    ballSpeed = ballSpeed / (1+(dt*2))
                end
                player1nukescore = player1nukescore - (dt*50) 
                if player1nukescore < 1 or ball[1].dx > 0 then
                    timeIsSlow = false 
                    player1reverbav = false
                    ballSpeed = originalSpeed
                    sounds["time"]:stop()
                    paddle_SPEED = originalPaddle
                end 
            end
            if timeIsSlow2 then  
                if ballSpeed > originalSpeed/3 then 
                    ballSpeed = ballSpeed / (1+(dt*2))
                end
                player2nukescore = player2nukescore - (dt*50) 
                if player2nukescore < 1 or ball[1].dx < 0 then
                    paddle_SPEED = 30
                    timeIsSlow2 = false 
                    player2reverbav = false
                    ballSpeed = originalSpeed
                    sounds["time"]:stop()
                    paddle_SPEED = originalPaddle
                end 
            end
            ball[i]:update(dt)
        end
        end
    
        player1:update(dt)
        player2:update(dt) 
        player3:update(dt)
        player4:update(dt)
        
    end
    function wallbreaker(x,y)
        if (gameState == 'editor') then 
    for i, wall in ipairs(walls) do
        

    if math.abs(wall.wallx - x) < 10  and math.abs(wall.wally - y) < 10 
        then 
            table.remove(walls, i)
        end
    end 
end
end
function editor()
    if (gameState == 'editor')
        then 
            local mx, my = love.mouse.getPosition()
            mx = mx * DIFFERENCE_X
            my = my * DIFFERENCE_Y
            if not blockinput then 
            love.graphics.setColor(1,0,0,1)
            love.graphics.rectangle('fill',mx, my, 10, wall1width)
            love.graphics.setColor(1,1,1,1)
        end
            if (love.mouse.isDown(2)) then 
               wallbreaker(mx, my)
           end
           if (love.mouse.isDown(3)) then
            table.insert(walls, newWall(mx,my, 10, wall1width))
           end
            
            for i, wall in ipairs(walls) do 
            love.graphics.setColor(1,1,1,1)
            love.graphics.rectangle("fill", wall.wallx, wall.wally, 10, wall.wallheight)
        end
    end
end
function hardmanager(diff)
 selecting = 1
 if (diff == 'easy')
    then 
    INDIC[1] = '>'
    AGAINST_AI = 1
    AI_SPEED = ballSet/10
    AI_STRIKEMOD = 100
    AI_NUKEMOD = 1000
    difficultyl = 200
    selecting = 0
    gameState = '1serve'
end
 if (diff == 'normal')
    then 
    INDIC[2] = '>'
    AI_SPEED = ballSet/10
    AI_LEVEL = 500
    AI_NUKEMOD = 250
    AI_STRIKEMOD = 60
    AGAINST_AI = 1
    difficultyl = 300
    selecting = 0
    gameState = '1serve'
end
  if (diff == 'hard')
    then 
    INDIC[3] = '>'
    AI_SPEED = ballSpeed * 1.1 + 50 
    AI_SPEED = AI_SPEED / 10
    AI_LEVEL = 700
    AI_NUKEMOD = 200
    AI_STRIKEMOD = 20
    selecting = 0
    difficultyl = 350
    AGAINST_AI = 1
    gameState = '1serve'
end
if (diff == 'practice') then 
    INDIC[3] = '>'
    AI_SPEED = ballSpeed * 500 + 50
    AI_SPEED = AI_SPEED / 10
    AI_LEVEL = 700
    AI_NUKEMOD = 9000000000
    AI_STRIKEMOD = 90000000
    selecting = 0
    difficultyl = 350
    AGAINST_AI = 1
    gameState = '1serve'    
    end
end

    
function dangerChecker()
if (p1control.up == p1control.down) then danger = '1up' danger2 = '1down' 
elseif (p1control.up == p1control.super) then danger = '1up' danger2 = '1special' 
elseif (p1control.up == p1control.counter) then danger = '1up' danger2 = '1ct'  
elseif (p1control.down == p1control.super) then danger = '1down' danger2 = '1special' 
elseif (p1control.down == p1control.counter) then danger = '1ct' danger2 = '1down'
elseif (p1control.super == p1control.counter) then danger = '1special' danger2 = '1ct' 
elseif (p2control.down == p2control.up) then danger = '2down' danger2 = '2up' 
elseif (p2control.down == p2control.super) then danger = '2down' danger2 = '2special'
elseif (p2control.down == p2control.counter) then danger = '2down' danger2 = '2ct'
elseif (p2control.up == p2control.super) then danger = '2up' danger2 = '2special'
elseif (p2control.up == p2control.counter) then danger = '2ct' danger2 = '2up'    
elseif (p2control.super == p2control.counter) then danger = '2special' danger2 = '2ct'  

else
    danger = "none"
    danger2 = "none"
end


end
function love.keypressed(key)
    if gameState == 'assign' then 
        if (req == 'p1up') then p1control.up = key
    currentKey = key
    --love.window.setTitle(key)
    gameState = 'controlSettings'
end
        if (req == 'p2up') then p2control.up = key
    currentKey = key
    --love.window.setTitle(key)
    gameState = 'controlSettings'
end
        if (req == 'p1down') then p1control.down = key
    currentKey = key
    --love.window.setTitle(key)
    gameState = 'controlSettings'
end
        if (req == 'p2down') then p2control.down = key
    currentKey = key
   -- love.window.setTitle(key)
    gameState = 'controlSettings'
end
        if (req == 'p1super') then p1control.super = key
    currentKey = key
   -- love.window.setTitle(key)
    gameState = 'controlSettings'
end
        if (req == 'p2super') then p2control.super = key
    currentKey = key
   -- love.window.setTitle(key)
    gameState = 'controlSettings'
end
        if (req == 'p1ct') then p1control.counter = key
    currentKey = key
  --  love.window.setTitle(key)
    gameState = 'controlSettings'
end
        if (req == 'p2ct') then p2control.counter = key
    currentKey = key
    --love.window.setTitle(key)
    gameState = 'controlSettings'
end
    end
	if key == 'escape' then 
		TEXT = 'Escape Key'
		love.event.quit()
    elseif key == 'enter' or key == 'return' then
       
    if gameState == 'start' then 
        resettinggenius()
    gameState = 'menu'
    hardmanager()
elseif (gameState == 'done') then 
    if (player1score > player2score) then 
        gameState = '2serve'
           potentialnuke1 = 0
    potentialnuke2 = 0
    striken = 0
    if (nuckemodactive == 0) then 
    areanuclear = 0
    nuclearanimation = 3
end
    potentialstrike1 = 0
    potentialstrike2 = 0
    player1nukescore = 0
    player2nukescore = 0
    else 
        gameState = '1serve'
    resettinggenius()
    for i = 1, maxBalls do 
    ball[i]:reset(i)
end
   end
    else
        gameState = 'menu'
        if (love.math.random(0, 10) == 1)
            then 
                TEXT = "Nuclear Ching Chong"
        else 
        TEXT = 'Nuclear Pong'
    end
        resettinggenius()
        for i = 1, maxBalls do
        ball[i]:reset(i)
    end
    end
end

end

function love.keyreleased(key) 
    currentKey = " "

    end
function speedSetter(requesttype)
	if (requesttype == 'ball') then 	
		if (ballSet > 550) then 
		ballSet = 0
		paddle_SPEED = 0
		
	else 
		ballSet = ballSet + 50
		paddle_SPEED = paddle_SPEED + 5
    end
    ballSpeed = ballSet
	end
	if (requesttype == 'snc') then
		synctype = synctype + 1
		if (synctype > 1) then 
			synctype = 0
		end
	   
	   if synctype == 0 then synctext = 'Independent' end
	   if synctype == 1 then synctext = 'Synchronised' end
	end
	if (requesttype == 'nuclearmod')
		then
			
		nuckemodactive = nuckemodactive + 1
		if (nuckemodactive > 1) then  

			nuckemodactive = 0		
		end
		if (nuckemodactive == 0)
			then 
            areanuclear = 0
            nuclearanimation = 3
			ballSet = 200 
			TEXT = "Nuclear Pong"

            synctype = 0
            maxspeed = 700
            synctext = 'Independent'
            paddle_SPEED = ballSet/10
            AI_SPEED = ballSet/10

		end
		if (nuckemodactive == 1)
			then
			areanuclear = 1
			ballSet = 2000
            maxspeed = 2000
            paddle_SPEED = ballSet/10
            AI_SPEED = ballSet/10
            synctext = "death is imminent"
		end
		ballSpeed = ballSet
	end
    if (requesttype == 'practice') then 
    if (ballSpeed > 999) then 
    ballSpeed = 200
    ballSet = 200
    end
    if (ballSpeed > 799) then 
    prtext = 'Insane'
    maxBalls = 5
elseif ballSpeed > 599 then 
    prtext = 'Hard'
    maxBalls = 4
elseif ballSpeed > 399 then 
    prtext = 'Normal'
    maxBalls = 3
elseif ballSpeed > 199 then 
    prtext = 'Easy'
    maxBalls = 3
end
    ballSpeed = ballSpeed + 200
    ballSet = ballSet + 200
    end
    if (requesttype == 'reset')
        then
        ballSpeed = 200
        ballSet = 200
        synctype = 0
        prtext = 'Easy' 
        maxBalls = 1
        end
    if (requesttype == 'pc') then 
        if (playerCount == 2) then 
    playerCount = 1
    playertext = '1v1'
    elseif (playerCount == 1) then 
    playerCount = playerCount + 1
    player3.x = player1.x + VIRTUAL_WIDTH / 2
    player3.y = player3.y
    playertext = '2v2'
end


    end
    if (requesttype == 'ballz') then 
if (maxBalls > 1) then 
    maxBalls = 1
    --love.window.setTitle("more than 4")
    else
    maxBalls = maxBalls + 1
end

    end
    if requesttype == 'ptw' then 
        if ptw == 10 then 
            ptw = 1
        else
            ptw = ptw + 1
        end
    end

	end

function gameModeChanger()
if (gameState == 'gameMode') then  
 local button_width = VIRTUAL_WIDTH * (1/3)
        local BUTTON_HEIGHT = 50
        local margin = 20
        local hot = false
        local cursor_y = 0
        local total_height = (BUTTON_HEIGHT + margin) * #buttons
        for i, button in ipairs(modeSelectorButtons) do 
            button.last = button.now
            local bx = (VIRTUAL_WIDTH*0.5) - (button_width * 0.5)
            local by = (VIRTUAL_HEIGHT * 0.5) - (total_height * 0.5) + cursor_y
            local color = {255, 255, 255, 255}
            local mx, my = love.mouse.getPosition()
            mx = mx * DIFFERENCE_X
            my = my * DIFFERENCE_Y
            hot = (mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT) and i
            if (hot == i) then 
                color = {10, 10, 0, 255}
            end
            button.now = love.mouse.isDown(1)
            if button.now and not button.last and hot == i then 
                                love.graphics.setColor(0,0,0,1)
                love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
                sounds['wallhit']:play()
             button.fn()
         end
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)
            love.graphics.setColor(0, 0, 0, 255)
            local textW = smallfont:getWidth(button.text)
            local textH = smallfont:getHeight(button.text)
            love.graphics.print(button.text, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5)
            love.graphics.setColor(255, 255, 255, 255)
            cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
            
        end
    end
if (gameState == 'multiMode')
    then 
 local button_width = VIRTUAL_WIDTH * (1/3)
        local BUTTON_HEIGHT = 50
        local margin = 20
        local hot = false
        local cursor_y = 0
        local total_height = (BUTTON_HEIGHT + margin) * #buttons
        for i, button in ipairs(playerCountButtons) do 
            button.last = button.now

            local bx = (VIRTUAL_WIDTH*0.5) - (button_width * 0.5)

            local by = (VIRTUAL_HEIGHT * 0.3) - (total_height * 0.5) + cursor_y
            if (button.text == 'Play') then 
                by = by + by/1.8
            end
            local color = {255, 255, 255, 255}
            local mx, my = love.mouse.getPosition()
            mx = mx * DIFFERENCE_X
            my = my * DIFFERENCE_Y
            hot = (mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT) and i
            if (hot == i) then 
                if (button.text == 'Play') then color = {0/255, 255/255, 0/255, 255} else
                color = {10, 10, 0, 255}
                end
            end
            button.now = love.mouse.isDown(1)
            if button.now and not button.last and hot == i then 
                love.graphics.setColor(0,0,0,1)
                love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
                sounds['wallhit']:play()
                if button.text == "Ball Speed: " and nuckemodactive == 1 then  
              else
                     
             button.fn()

         end
         end
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)
            love.graphics.setColor(0, 0, 0, 255)
            local textW = smallfont:getWidth(button.text)
            local textH = smallfont:getHeight(button.text)
            if (button.text == '1v1') then love.graphics.print(playertext, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5) 
                            elseif button.text == 'snc' then 
                if (nuckemodactive == 1) then
                                    love.graphics.setColor(1,0,0,1)
                love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5)
                love.graphics.setColor(1,1,1,1)
                love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5)
                love.graphics.setColor(0,0,0,1) 
                else
                     --
                love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH*0.45 - textW*0.5, by+textH*0.5)
            end
            elseif (button.text == 'ballCount') then love.graphics.print("Ball Count: " .. maxBalls, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5)
                            elseif (button.text == "Ball Speed: ") then 
                if (nuckemodactive == 1) then 
                love.graphics.setColor(1,0,0,1)
                love.graphics.print("shaitan machina", smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5)
                love.graphics.setColor(1,1,1,1)
                love.graphics.print("shaitan machina", smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5)
                love.graphics.setColor(0,0,0,1) 

                else
                love.graphics.print(button.text .. ballSet, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5)
            end
        elseif button.text == 'ptw' then love.graphics.print("Points to Win: " .. ptw, smallfont,VIRTUAL_WIDTH*0.5 - textW * 1.5, by+textH*0.5)
            else
            love.graphics.print(button.text, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5)
        end
            love.graphics.setColor(255, 255, 255, 255)
            cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
            
        end


    end


end
function love.draw()
    simpleScale.set()
  --  resolutionChanger()
    --love.graphics.scale( 1.5, 1.5 )
   -- love.graphics.translate( (WINDOW_WIDTH*1.5 - WINDOW_WIDTH), WINDOW_HEIGHT*1.5 - WINDOW_HEIGHT )
--	push:apply('start')
        --resolutionButtons()
        if gameState == 'nuclearExplosion' then 
            love.graphics.setColor(1,1,1,1)
            love.graphics.circle("fill", ball[1].x, ball[1].y , explosionRange*100, 100)
            player1.RED, player1.GREEN, player1.BLUE, player2.RED, player2.GREEN, player2.BLUE = nuclearanimation/3,nuclearanimation/3,nuclearanimation/3,nuclearanimation/3,nuclearanimation/3,nuclearanimation/3
            for i = 1, maxBalls do
                love.graphics.setColor(nuclearanimation/3,nuclearanimation/3,nuclearanimation/3,1)
                ball[i]:render('controlled')
            end           
            player1:render()
            player2:render()
        elseif gameState == 'animation' then 
            callAnimator() --This calls a fucking 100 year old animator. I dont even remember what it does. This has nothing to do with the new one
        else
            mapChanger()
            if t < shakeDuration then
            	--love.window.setTitle("lamo")
                local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
                local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
                love.graphics.translate(dx, dy)
            end
            if (gameState == 'menu') then 
                updateTEXT = '0.7 Chalkboard Update'
            end
            serveBot()
            hardmanager()
 
            if (areanuclear == 1) then 
                love.graphics.setShader(shader)
                love.graphics.clear(1,1,1,1)
            else 
                love.graphics.setShader()
	            love.graphics.clear(40/255, 40/255, 40/255, 1) --BACKGROUND COLOR
            end
            staticanimator()
            if (gameMode == 'practice') then 
                love.graphics.rectangle('fill', VIRTUAL_WIDTH, 0, 10, VIRTUAL_HEIGHT)
            end
            if (MAP_TYPE == 1) then 
                love.graphics.setColor(1, 0, 0.20, 1)
                love.graphics.rectangle('fill', VIRTUAL_WIDTH *0.5, 0, 10, VIRTUAL_HEIGHT * 0.3)
                love.graphics.rectangle('fill', VIRTUAL_WIDTH *0.5, VIRTUAL_HEIGHT * 0.7, 10, VIRTUAL_HEIGHT * 0.3)
                love.graphics.setColor(1, 1, 1, 1)
            end
            love.graphics.setFont(scorefont)
            if gameState == 'play' or gameState == '1serve' or gameState == '2serve' then 
                love.graphics.setFont(smallfont)
            end
            love.graphics.setColor(1,1,1,1)
            love.graphics.printf(TEXT,0,20,VIRTUAL_WIDTH,'center')
            love.graphics.setFont(smallfont)
            love.graphics.printf(updateTEXT,0,VIRTUAL_HEIGHT * 0.95,VIRTUAL_WIDTH,'left')
            love.graphics.setFont(scorefont)
            love.graphics.print(tostring(math.floor(player1score)), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 12)
            if (gameMode ~= 'practice') then 
                love.graphics.print(tostring(math.floor(player2score)), VIRTUAL_WIDTH / 2 + 400, VIRTUAL_HEIGHT / 12)
            end
            love.graphics.setFont(smallfont)
        
            if (potentialstrike1 == 1 and potentialnuke1 == 0 and player1reverbav == 0) then 
                if (player1striken == 0) then 
                    love.graphics.print(tostring(math.floor(player1nukescore) .. '['..p1control.super..']'), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 60)
                else 
                    love.graphics.print(tostring('READY'), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 60) 
                end
            elseif (player1reverbav == 1 and potentialnuke1 == 0) then 
                love.graphics.print(tostring(math.floor(player1nukescore) ..'[' ..p1control.super .. ']' .. " ["..p1control.counter..']'), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 60) 
            elseif (potentialnuke1 == 1) then 
                love.graphics.setColor(255, 0, 0, 255)
                love.graphics.print(tostring(math.floor(player1nukescore) .. '[' .. p1control.super .. ']' .. " ["..p1control.counter .. ']'), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 60)  
                love.graphics.setColor(255, 255, 255, 255) 
            else 
                love.graphics.print(tostring(math.floor(player1nukescore)), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 60)
            end
            if (potentialstrike2 == 1 and player2reverbav == 0) then 
                if (player2striken == 0 and gameMode ~= 'practice') then 
                    love.graphics.print(tostring(math.floor(player2nukescore) .. '['..p2control.super..']'), VIRTUAL_WIDTH / 2 + 430, VIRTUAL_HEIGHT / 60)
                elseif (gameMode ~= 'practice') then 
    	            love.graphics.print(tostring('READY'), VIRTUAL_WIDTH / 2 + 430, VIRTUAL_HEIGHT / 60)
                end
            elseif (potentialnuke2 == 1 and gameMode ~= 'practice') then 
                love.graphics.setColor(255, 0, 0, 255)
                love.graphics.print(tostring(math.floor(player2nukescore) .. '['..p2control.super..']'), VIRTUAL_WIDTH / 2 + 430, VIRTUAL_HEIGHT / 60)
                love.graphics.setColor(255, 255, 255, 255) 
            elseif (player2reverbav == 1 and potentialnuke2 == 0) then 
                love.graphics.print(tostring(math.floor(player2nukescore) .. '['..p2control.super .. "] [" .. p2control.counter..']'), VIRTUAL_WIDTH / 2 + 430, VIRTUAL_HEIGHT / 60) 
    	    elseif (gameMode ~= 'practice') then 
                love.graphics.print(tostring(math.floor(player2nukescore)), VIRTUAL_WIDTH / 2 + 430, VIRTUAL_HEIGHT / 60)
            end
            if (MAP_TYPE == 2) then 
                for i, wall in ipairs(walls) do 

                    love.graphics.setColor(1,1,1,1)
                    love.graphics.rectangle("fill", wall.wallx, wall.wally, 10, wall.wallheight)
                end
            end
            
            if gameState ~= 'assign' then
                player1:render()
                player3:render()
            if gameMode ~= 'practice' then 
                player2:render()
                player4:render()
            end
            for i = 1, maxBalls do
                if areanuclear == 1 then 
                    ball[i]:render('black')
                    --love.window.setTitle('rendering black')    
                else 
                    ball[i]:render(' ')
                    --love.window.setTitle('rendering white')
                end
            end
            if gameState == 'windowsettings' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, settings, sounds, 'right')
                love.keyboard.mouseisReleased = false
            end
            if gameState == 'editor' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, editorpicks, sounds, 'right')
                love.keyboard.mouseisReleased = false
            end
            if gameState == 'speedSettings' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, speedParameters, sounds, 'middle')
                love.keyboard.mouseisReleased = false
            end
            if gameState == 'controlSettings' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, controlSettings, sounds, 'control')
                love.keyboard.mouseisReleased = false
            end        
            if gameState == 'gameMode' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, modeSelectorButtons, sounds, 'middle')
                love.keyboard.mouseisReleased = false
            end
            if gameState == 'menu' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, buttons, sounds, 'middle')
                love.keyboard.mouseisReleased = false
            end
            if gameState == 'difficulty' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, difbuttons, sounds, 'middle')
                love.keyboard.mouseisReleased = false
            end
            if gameState == 'multiMode' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, playerCountButtons, sounds, 'playercount')
                love.keyboard.mouseisReleased = false
            end        
            if gameState == 'prdiff' then 
                mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, pracdiff, sounds, 'playercount')
                love.keyboard.mouseisReleased = false
            end
        end
        editor()
        if (gameState == 'start') then 
            love.graphics.push()  
            love.graphics.translate(  
                VIRTUAL_WIDTH * 0.4,  
                VIRTUAL_HEIGHT * 0.5  
            )  
            love.graphics.rotate(rotation)
            love.graphics.setFont(smallfont)   
            love.graphics.print("Press Enter to Start", WINDOW_WIDTH / -10 , VIRTUAL_HEIGHT / 8)
            love.graphics.setColor(255,255,255,255)
            love.graphics.pop()  
  

        end
    end
    if gameState == 'assign' then 
        controlChanger()
    end
  simpleScale.unSet()
end
   --    push:apply('end')
    function controllerSer()
        for i = 1, maxBalls do
    if (ball[i].dy == 0) then
        hitNum[i] = hitNum[i] +1
        --love.window.setTitle(hitNum[i])
        if hitNum[i] >= 10 then
        ball[i].dy = 1
        hitNum[i] = 0 
        end
    else 
        hitNum[i] = 0
    end
end

    end
        function palleteController()
        if (areanuclear == 0) then player1.RED = 1 player1.GREEN = 1 player1.BLUE = 1 end
        if (areanuclear == 0) then player2.RED = 1 player2.GREEN = 1 player2.BLUE = 1 end
        if (areanuclear == 1) then player1.RED = 0 player1.GREEN = 0 player1.BLUE = 0 end
        if (areanuclear == 1) then player2.RED = 0 player2.GREEN = 0 player2.BLUE = 0 end       
        end
    




function love.wheelmoved(x, y)
if (y < 0 and wall1width > 0) then 
    wall1width = wall1width - 5
elseif y > 0 and wall1width < 900 then wall1width = wall1width + 5
end

    end

function serveBot()
if (gameState == '1serve') then 
    updateTEXT = ''
            if (gameMode ~= 'practice') then 
    TEXT = 'PLAYER 1, serve!(q)'
end
    if (love.keyboard.isDown('q') or gameMode == 'practice') then
        TEXT = 'Lets Begin!'
        ball_DIR = 1
        for i = 1, maxBalls do 
    ball[i]:reset(i)

end
    --love.window.setTitle("An atttttttt")
        gameState = 'play'
    end
end
if (gameState == '2serve') then 
    TEXT = 'PLAYER 2, serve!(p)'
    if (AGAINST_AI == 1) then 
        TEXT = ''
        ball_DIR = -1
        for i = 1, maxBalls do
    ball[i]:reset(i)
end
    --love.window.setTitle("An atttttttt")
        gameState = 'play'
    end  
    if (love.keyboard.isDown('p') and AGAINST_AI == 0) then 
        TEXT = 'Lets Begin'
        ball_DIR = -1
            for i = 1, maxBalls do
    ball[i]:reset(i)
end
    --love.window.setTitle("An atttttttt")
        gameState = 'play'
    end
end
end
function mapChanger()
    for i = 1, maxBalls do
    if (gameState == 'editor') then MAP_TYPE = 2 end
    if (MAP_TYPE > 2) then 
        MAP_TYPE = 0
    end
    if (gameMode == 'practice') then 
        MAP_TYPE = 0
     if ball[i].x > VIRTUAL_WIDTH * 0.99 then
                soundtype = love.math.random(1, 5)
                sounds['wallhit']:setPitch(ballSpeed/250)
                sounds['wallhit']:play()
            if (ball[i].dx > 0)
                then ball[i].x = ball[i].x - 20
                else ball[i].x = ball[i].x + 20
                end
            ball[i].dx = -ball[i].dx

        end

    end
    if (MAP_TYPE == 1)
        then 
                if ball[i].y < VIRTUAL_HEIGHT * 0.3 and ball[i].x > VIRTUAL_WIDTH * 0.5 and ball[i].x < VIRTUAL_WIDTH * 0.5 + 5 then
                soundtype = love.math.random(1, 5)
                sounds['wallhit']:setPitch(ballSpeed/250)
                sounds['wallhit']:play()
            if (ball[i].dx > 0)
                then ball[i].x = ball[i].x - 20
                else ball[i].x = ball[i].x + 20
                end
            ball[i].dx = -ball[i].dx

        end
                        if ball[i].y > VIRTUAL_HEIGHT * 0.7 and ball[i].x > VIRTUAL_WIDTH * 0.5 and ball[i].x < VIRTUAL_WIDTH * 0.5 + 5 then
                soundtype = love.math.random(1, 5)
                sounds['wallhit']:setPitch(ballSpeed/250)
                sounds['wallhit']:play()
            if (ball[i].dx > 0)
                then ball[i].x = ball[i].x - 20
                else ball[i].x = ball[i].x + 20
                end
            ball[i].dx = -ball[i].dx

        end
    end
    if (MAP_TYPE == 2) then
                for i, wall in ipairs(walls) do 

        if (ball[1].y > wall.wally and ball[1].y < wall.wally+wall.wallheight and ball[1].x > wall.wallx - ballSpeed/200 and ball[1].x < wall.wallx + 10 + ballSpeed/200) then 
            controllerSer()
                            soundtype = love.math.random(1, 5)
                sounds['wallhit']:setPitch(ballSpeed/250)
                sounds['wallhit']:play()
            if (ball[1].dx > 0)
                then ball[1].x = ball[1].x - 1
                else ball[1].x = ball[1].x + 1
                end
            ball[1].dx = -ball[1].dx

        elseif (ball[1].y > wall.wally-15 and ball[1].y < wall.wally+wall.wallheight+10 and ball[1].x > wall.wallx and ball[1].x < wall.wallx + 10) then 
            controllerSer()
                            soundtype = love.math.random(1, 5)
                sounds['wallhit']:setPitch(ballSpeed/250)
                sounds['wallhit']:play()
            if (ball[1].dy > 0)
                then ball[1].y = ball[1].y - 1
                else ball[1].y = ball[1].y + 1
                end
            ball[1].dy = -ball[1].dy
        end
        end
        end 
    end
        
end
function resolutionChanger()
    if (RESOLUTION_SET > 1) then 
        RESOLUTION_SET = 0
    end
    if (RESOLUTION_SET == 0 ) then
    if (isFullscreen == 1) then
            DIFFERENCE_X = 1
        DIFFERENCE_Y = 1
        simpleScale.updateWindow(WINDOW_WIDTH, WINDOW_HEIGHT,{fullscreen = false})
        isFullscreen = 0
    end

        end
        if (RESOLUTION_SET == 1) then
    if (isFullscreen == 0) then 
        simpleScale.updateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = true})
        local newWidth = love.graphics.getWidth()
        local newHeight = love.graphics.getHeight()
        DIFFERENCE_X = VIRTUAL_WIDTH / newWidth
        DIFFERENCE_Y = VIRTUAL_HEIGHT / newHeight
        isFullscreen = 1

    end
end

    
end
function resettinggenius()
    maxBalls = 1
    for i =1, maxBalls do
        ball[i]:reset(i)
    end
    paddle_SPEED = 20
    nuclearanimation = 3
    timeIsSlow =false 
    timeIsSlow2 = false 
    originalSpeed = 200
    gameState = 'menu'
    gameMode = 'notpracticd'
    ballSet = 200
    ballSpeed = ballSet
            player2.GREEN = 255
        player2.BLUE = 255
        player1.GREEN = 255
        player1.BLUE = 255
                player1score = 0
        player2score = 0
           potentialnuke1 = 0
    potentialnuke2 = 0
    striken = 0
    areanuclear = 0
    potentialstrike1 = 0
    potentialstrike2 = 0
    player1nukescore = 0
    player2nukescore = 0
    player1reverbav = 0
    player2reverbav = 0
    selecting = 0
    AGAINST_AI = 0
    end

function animator(dt)
    if (gameState == 'animation') then
    time_1 = time_1 + dt
    light = 255 - time_1 * 85
    if (light < 0) then 
        time_1 = 0
        light = 0
        gameState = 'start'
    end
end
   

end
function callAnimator()
            love.graphics.setColor(255,255,255,light/255)
        love.graphics.draw(image,0,0)
    end
function love.mousereleased(x, y, button)
love.keyboard.mouseisReleased = true
    if (gameState == 'editor') then
        if (#walls < 1000 and button == 1 and blockinput ~= true) then 
        table.insert(walls, newWall(x*DIFFERENCE_X,y*DIFFERENCE_Y, 10, wall1width))
        end 
    end
end