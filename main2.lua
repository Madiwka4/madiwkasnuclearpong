--CALLING OTHER LUA FILES
require "src/dependencies"
io.stdout:setvbuf("no")
--CANCELLED ATTEMPETED SHADING (NOT WORKING)
local shader_code =
    [[
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 pixel = Texel(image,uvs);
    return pixel * color;
}
]]

debug = true
--GLOBAL VARIABLES
gameMode = "normal"
globalState = "menu"
timeIsSlow = false
timeIsSlow2 = false
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
confirmation = "disconnected"
hitNum[4] = 0
p1bonus = 0
p2bonus = 0
hitNum[5] = 0
hitNum[6] = 0
GREEN = 255
BLUE = 255
updateTEXT = "Chalkboard Update"
maxBalls = 1
playerCount = 1
player1reverbav = 0
playertext = "1v1"
player2reverbav = 0
elapsed = 0
rotation = 0
TEXT = "Nuclear Pong"
currentKey = " "
ptw = 10

--CHECKING IF CONTROLS ARE TAKEN
danger = "none"
danger2 = "none"

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
prtext = "Easy"
lastSentKey = "c"
MAP_TYPE = 0
lastSentKeyClient = "c"
difficultyl = 300
req = "pp"
ballSet = 200
p1control = {up = "a", down = "z", super = "s", counter = "x"}
p2control = {up = ";", down = ".", super = "l", counter = ","}
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
        shakeDuration = 5
        if debug then
           --print("Shaking set to match almost over")
        end
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
modeSelectorButtons = {}
pracdiff = {}
playerCountButtons = {}
function controlChanger()
    if (gameState == "assign") then
        love.graphics.clear(50 / 255, 50 / 255, 50 / 255, 255)
        love.graphics.printf("SELECT BUTTON", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
    end
end
function love.load()
    simpleScale.setWindow(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
    configfile = io.open("config.lua", "r")
    configsave = io.open("config.lua", "w")
    shader = love.graphics.newShader(shader_code)
    time_1 = 0
   --print("Debug active")
    --load

    testwalls = love.filesystem.load("save.lua")()
    if testwalls ~= nil then
        walls = love.filesystem.load("save.lua")()
    end

    light = 0
    image = love.graphics.newImage("Madi.png")
    table.insert(
        editorpicks,
        newButton(
            "C",
            function()
                for k in pairs(walls) do
                    walls[k] = nil
                end
            end
        )
    )
    table.insert(
        editorpicks,
        newButton(
            "S",
            function()
                love.filesystem.write("save.lua", serialize(walls))
            end
        )
    )
    table.insert(
        editorpicks,
        newButton(
            "L",
            function()
                walls = love.filesystem.load("save.lua")()
            end
        )
    )
    table.insert(
        buttons,
        newButton(
            "Singleplayer",
            function()
                gameState = "gameMode"
            end
        )
    )
    table.insert(
        buttons,
        newButton(
            "Online Test",
            function()
                globalState = "nettest"
                AGAINST_AI = 0 
                gameState = "1serve"
            end
        )
    )
    table.insert(
        buttons,
        newButton(
            "Client Test",
            function()
                globalState = "clienttest"
                AGAINST_AI = 0 
                gameState = "1serve"
            end
        )
    )
    table.insert(
        buttons,
        newButton(
            "Multiplayer",
            function()
                gameState = "multiMode"
            end
        )
    )
    table.insert(
        buttons,
        newButton(
            "Settings",
            function()
                AGAINST_AI = 0
                gameState = "windowsettings"
            end
        )
    )
    table.insert(
        buttons,
        newButton(
            "Exit",
            function()
                love.event.quit(0)
            end
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "Easy",
            function()
                hardmanager("easy")
            end
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "Normal",
            function()
                hardmanager("normal")
            end
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "Hard",
            function()
                hardmanager("hard")
            end
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "Smart",
            function()
                hardmanager("smart")
            end
        )
    )
    table.insert(
        settings,
        newButton(
            "Change Map",
            function()
                MAP_TYPE = MAP_TYPE + 1
            end
        )
    )
    table.insert(
        settings,
        newButton(
            "Toggle Fullscreen",
            function()
                myscreen:toggle(VIRTUAL_HEIGHT, VIRTUAL_WIDTH)
                DIFFERENCE_X = myscreen.c
                DIFFERENCE_Y = myscreen.d
            end
        )
    )
    table.insert(
        settings,
        newButton(
            "Editor",
            function()
                gameState = "editor"
            end
        )
    )
    table.insert(
        settings,
        newButton(
            "Speed Settings",
            function()
                gameState = "speedSettings"
            end
        )
    )
    table.insert(
        settings,
        newButton(
            "Control Settings",
            function()
                gameState = "controlSettings"
            end
        )
    )
    table.insert(
        settings,
        newButton(
            "Back to Menu",
            function()
                gameState = "menu"
            end
        )
    )
    table.insert(
        speedParameters,
        newButton(
            "Back to Menu",
            function()
                gameState = "windowsettings"
            end
        )
    )
    --table.insert(speedParameters, newButton("Ball Speed: ", function() speedSetter('ball') end))
    table.insert(
        playerCountButtons,
        newButton(
            "Ball Speed: ",
            function()
                speedSetter("ball")
            end
        )
    )
    --table.insert(speedParameters, newButton("snc", function() speedSetter('snc') end))
    table.insert(
        playerCountButtons,
        newButton(
            "snc",
            function()
                speedSetter("snc")
            end
        )
    )
    table.insert(
        speedParameters,
        newButton(
            "NUCLEAR MODE",
            function()
                speedSetter("nuclearmod")
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "1up",
            function()
                gameState = "assign"
                req = "p1up"
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "1down",
            function()
                gameState = "assign"
                req = "p1down"
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "1special",
            function()
                gameState = "assign"
                req = "p1super"
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "1ct",
            function()
                gameState = "assign"
                req = "p1ct"
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "2up",
            function()
                gameState = "assign"
                req = "p2up"
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "2down",
            function()
                gameState = "assign"
                req = "p2down"
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "2special",
            function()
                gameState = "assign"
                req = "p2super"
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "2ct",
            function()
                gameState = "assign"
                req = "p2ct"
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "Default",
            function()
                p1control = {up = "a", down = "z", super = "s", counter = "x"}
                p2control = {up = ";", down = ".", super = "l", counter = ","}
            end
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "Return",
            function()
                gameState = "windowsettings"
            end
        )
    )
    table.insert(
        modeSelectorButtons,
        newButton(
            "Nuclear Pong",
            function()
                gameState = "difficulty"
            end
        )
    )
    table.insert(
        modeSelectorButtons,
        newButton(
            "Main Menu",
            function()
                gameState = "menu"
            end
        )
    )
    table.insert(
        pracdiff,
        newButton(
            "Silverblade",
            function()
                speedSetter("practice")
            end
        )
    )
    table.insert(
        pracdiff,
        newButton(
            "Return",
            function()
                speedSetter("reset")
                gameState = "gameMode"
            end
        )
    )
    table.insert(
        pracdiff,
        newButton(
            "Go!",
            function()
                gameMode = "practice"
                hardmanager("practice")
            end
        )
    )
    --table.insert(playerCountButtons, newButton("1v1", function() speedSetter('pc') end))
    table.insert(
        playerCountButtons,
        newButton(
            "ballCount",
            function()
                speedSetter("ballz")
            end
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "ballCount",
            function()
                speedSetter("ballz")
            end
        )
    )
    table.insert(
        playerCountButtons,
        newButton(
            "Return",
            function()
                speedSetter("reset")
                gameState = "menu"
        
            end
        )
    )
    table.insert(
        playerCountButtons,
        newButton(
            "ptw",
            function()
                speedSetter("ptw")
            end
        )
    )
    table.insert(
        playerCountButtons,
        newButton(
            "Play",
            function()
                AGAINST_AI = 0
                gameState = "1serve"
                globalState = "base"
            end
        )
    )
    table.insert(
        playerCountButtons,
        newButton(
            "Reverse Play",
            function()
                gameState = "1serve"
                gameMode = "reversegame"
            end
        )
    )

    --table.insert(speedParameters, newButton("Ball Speed: ", function() speedSetter() end))

    love.window.setTitle("NUCLEAR PONG")
    textphrases = {
        "Amazing",
        "Superb",
        "Absolutely beautiful!",
        "Awesome",
        "Look at That!",
        "Great",
        "Nice",
        "Boom!",
        "Dangerous!",
        "Astonishing!",
        "u/ebernerd saved me",
        "Absolutely Wonderful!",
        "Exsquisite",
        "Delicate",
        "Pow!",
        "Great Hit",
        "all hail nazarbayev"
    }
    sounds = {
        ["updateMusic"] = love.audio.newSource("audio/theme1.mp3", "static"),
        ["gayTheme"] = love.audio.newSource("audio/theme2.mp3", "static"),
        ["gayTheme2"] = love.audio.newSource("audio/theme3.mp3", "static"),
        ["gayTheme3"] = love.audio.newSource("audio/theme4.mp3", "static"),
        ["beep"] = love.audio.newSource("audio/hit1.mp3", "static"),
        ["wallhit"] = love.audio.newSource("audio/hit2.wav", "static"),
        ["win"] = love.audio.newSource("win.wav", "static"),
        ["score"] = love.audio.newSource("audio/score.wav", "static"),
        ["nuke"] = love.audio.newSource("audio/bomb.wav", "static"),
        ["striking"] = love.audio.newSource("audio/superhit.wav", "static"),
        ["nuclearhit"] = love.audio.newSource("audio/hit1.mp3", "static"),
        ["time"] = love.audio.newSource("audio/time.wav", "static")
    }
    love.graphics.setDefaultFilter("nearest", "nearest")
    --comic sans lmao
    math.randomseed(os.time())
    smallfont = love.graphics.newFont("font.ttf", 25)
    scorefont = love.graphics.newFont("font.ttf", 60)
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
        "",
        "",
        "",
        ""
    }
    --playe1nuke
    player1 = paddle(0, 30, 10, 100, 1)
    player2 = paddle(VIRTUAL_WIDTH * 0.99, VIRTUAL_HEIGHT * 0.88, 10, 100, 2)
    player3 = paddle(5000, 5000, 10, 100)
    player4 = paddle(5000, 5000, 10, 100)
    ball = {}
    ball[1] = eball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    ball[2] = eball(VIRTUAL_WIDTH / 1.9, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    ball[3] = eball(VIRTUAL_WIDTH / 1.8, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    ball[4] = eball(VIRTUAL_WIDTH / 2.2, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    ball[5] = eball(VIRTUAL_WIDTH / 2.1, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    myscreen = fullScreener(RESOLUTION_SET, isFullscreen, DIFFERENCE_X, DIFFERENCE_Y)
    mymenu = mainMenu()

    ballSpeed = 200

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState = "animation"
end
t = 0
shakeDuration = 0
shakeMagnitude = 1
function startShake(duration, magnitude)
    t, shakeDuration, shakeMagnitude = 0, duration or 1, magnitude or 5
end
function displayFPS()
    --love.window.setTitle(love.timer.getFPS())
    love.window.setTitle(globalState .. " " .. gameState)
    if love.keyboard.isDown("space") then
        player1nukescore = 200
        player1score = player1score + 0.2
        player2nukescore = 200
    end
    
end

function speedControl()
    if (ballSpeed > maxspeed and gameState == "play") then
        ballSpeed = maxspeed
    end
end

function love.update(dt)
    print("IMPORTANT!!!!!" .. globalState .. gameState)
    staticanimatorcounter(dt)
    musicController('norm', 1)
    if debug then
        displayFPS()
    end
    if globalState == "base" then
        basegame(dt)
    end
    if globalState == "menu" then
        debugCheck(dt)
    end
    if globalState == "nettest" then 
        basegame(dt)
        nettest(dt)
    end
    if globalState == "clienttest" then
        if confirmation ~= "disconnected" then 
            lastSentKeyP1 = lastSentKeyClient
        clientsBaseGame(dt) 
        end
        clienttest(dt)
    end
end
serverinit = false 
clientinit = false 
function nettest(dt)
    if serverinit == false then 
        local socket = require('socket')
        udp = socket.udp()
        udp:setsockname('*', 12345)
        udp:settimeout(0)
        serverinit = true 
    end 
    data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then 
    print(data .. "FROM " .. msg_or_ip)
    end 
	if data then
		local p = split(data, '|')
        lastSentKeyClient = p[1]
        for i = 1, maxBalls do 
            print (tostring(ball[i].dy))
        udp:sendto(tostring(lastSentKey) ..'|'.. tostring(ball[i].dy) .. '|' .. tostring(player2.y) .. '|' .. tostring(player1.y) .. '|' .. tostring(player1score) .. '|' .. tostring(player2score) .. '|' .. tostring(player1nukescore) .. '|' .. tostring(player2nukescore) .. "|confirmed|" .. tostring(ball[i].x) .. '|' .. tostring(ball[i].y), msg_or_ip, port_or_nil)
        print("SENT: " .. lastSentKey)
        end 
	end
end
function clienttest(dt) 
    if clientinit == false then 
        local socket = require "socket"
        local address, port = "127.0.0.1", 12345
        udp = socket.udp()
        udp:setpeername(address, port)
        udp:settimeout(0)
        clientinit = true 
    end
    udp:send(tostring(lastSentKey))
    print("SENT TO SERVER:" ..  lastSentKey)
    data = udp:receive()
    --print(data)
	if data then
        local p = split(data, '|')
        for i = 1, maxBalls do 
        local die = tonumber(p[2])
        print(p[2])
        print(p[2] + 0)
        print(tonumber(p[11]))
        lastSentKeyClient, ball[i].dy, player2.y, player1.y, player1score, player2score, player1nukescore, player2nukescore, confirmation, ball[i].x, ball[i].y = p[1], die, tonumber(p[3]), tonumber(p[4]), tonumber(p[5]), tonumber(p[6]), tonumber(p[7]), tonumber(p[8]), p[9], tonumber(p[10]), tonumber(p[11])
        end 
    else 
        confirmation = "disconnected"
    end
    print(confirmation .. " recieved " .. lastSentKeyClient .. " AND ")

end
function wallbreaker(x, y)
    if (gameState == "editor") then
        for i, wall in ipairs(walls) do
            if math.abs(wall.wallx - x) < 10 and math.abs(wall.wally - y) < 10 then
                table.remove(walls, i)
            end
        end
    end
end

function hardmanager(diff)
    selecting = 1
    if (diff == "easy") then
        INDIC[1] = ">"
        AGAINST_AI = 1
        AI_SPEED = ballSet / 10
        AI_STRIKEMOD = 100
        AI_NUKEMOD = 1000
        AI_LEVEL = 350
        difficultyl = 200
        selecting = 0
        gameState = "1serve"
        globalState = "base"
    end
    if (diff == "normal") then
        INDIC[2] = ">"
        AI_SPEED = ballSet / 10
        AI_LEVEL = 500
        AI_NUKEMOD = 250
        AI_STRIKEMOD = 60
        AGAINST_AI = 1
        difficultyl = 300
        selecting = 0
        gameState = "1serve"
        globalState = "base"
    end
    if (diff == "hard") then
        INDIC[3] = ">"
        AI_SPEED = ballSpeed * 1.1 + 50
        AI_SPEED = AI_SPEED / 10
        AI_LEVEL = 700
        AI_NUKEMOD = 200
        AI_STRIKEMOD = 20
        selecting = 0
        difficultyl = 350
        AGAINST_AI = 1
        gameState = "1serve"
        globalState = "base"
    end
    if (diff == "smart") then
        INDIC[3] = ">"
        AI_SPEED = ballSpeed * 1.1 + 50
        AI_SPEED = AI_SPEED / 10
        AI_LEVEL = 1500
        AI_NUKEMOD = 200
        AI_STRIKEMOD = 20
        selecting = 0
        difficultyl = 350
        AGAINST_AI = 1
        gameState = "1serve"
        globalState = "base"
    end
    if (diff == "practice") then
        INDIC[3] = ">"
        AI_SPEED = ballSpeed * 500 + 50
        AI_SPEED = AI_SPEED / 10
        AI_LEVEL = 700
        AI_NUKEMOD = 9000000000
        AI_STRIKEMOD = 90000000
        selecting = 0
        difficultyl = 350
        AGAINST_AI = 1
        gameState = "base"
    end
end

function dangerChecker() --CHECK IF CONTROLS ARE DUPLICATING
    if (p1control.up == p1control.down) then
        danger = "1up"
        danger2 = "1down"
    elseif (p1control.up == p1control.super) then
        danger = "1up"
        danger2 = "1special"
    elseif (p1control.up == p1control.counter) then
        danger = "1up"
        danger2 = "1ct"
    elseif (p1control.down == p1control.super) then
        danger = "1down"
        danger2 = "1special"
    elseif (p1control.down == p1control.counter) then
        danger = "1ct"
        danger2 = "1down"
    elseif (p1control.super == p1control.counter) then
        danger = "1special"
        danger2 = "1ct"
    elseif (p2control.down == p2control.up) then
        danger = "2down"
        danger2 = "2up"
    elseif (p2control.down == p2control.super) then
        danger = "2down"
        danger2 = "2special"
    elseif (p2control.down == p2control.counter) then
        danger = "2down"
        danger2 = "2ct"
    elseif (p2control.up == p2control.super) then
        danger = "2up"
        danger2 = "2special"
    elseif (p2control.up == p2control.counter) then
        danger = "2ct"
        danger2 = "2up"
    elseif (p2control.super == p2control.counter) then
        danger = "2special"
        danger2 = "2ct"
    else
        danger = "none"
        danger2 = "none"
    end
end
function love.keypressed(key)
    lastSentKey = key 
    if gameState == "assign" then
        if (req == "p1up") then
            p1control.up = key
            currentKey = key
            --love.window.setTitle(key)
            gameState = "controlSettings"
        end
        if (req == "p2up") then
            p2control.up = key
            currentKey = key
            --love.window.setTitle(key)
            gameState = "controlSettings"
        end
        if (req == "p1down") then
            p1control.down = key
            currentKey = key
            --love.window.setTitle(key)
            gameState = "controlSettings"
        end
        if (req == "p2down") then
            p2control.down = key
            currentKey = key
            -- love.window.setTitle(key)
            gameState = "controlSettings"
        end
        if (req == "p1super") then
            p1control.super = key
            currentKey = key
            -- love.window.setTitle(key)
            gameState = "controlSettings"
        end
        if (req == "p2super") then
            p2control.super = key
            currentKey = key
            -- love.window.setTitle(key)
            gameState = "controlSettings"
        end
        if (req == "p1ct") then
            p1control.counter = key
            currentKey = key
            --  love.window.setTitle(key)
            gameState = "controlSettings"
        end
        if (req == "p2ct") then
            p2control.counter = key
            currentKey = key
            --love.window.setTitle(key)
            gameState = "controlSettings"
        end
    end
    if key == "escape" then
        TEXT = "Escape Key"
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            resettinggenius()
            gameState = "menu"
            globalState = "menu"
            hardmanager()
        elseif (gameState == "done") then
            if (player1score > player2score) then
                gameState = "2serve"
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
                gameState = "1serve"
                resettinggenius()
                for i = 1, maxBalls do
                    ball[i]:reset(i)
                end
            end
        else
            gameState = "menu"
            globalState = "menu"
            if (love.math.random(0, 10) == 1) then
                TEXT = "Nuclear Ching Chong"
            else
                TEXT = "Nuclear Pong"
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
        if lastSentKey == key then
            lastSentKey = "g"
        end
end
function speedSetter(requesttype)
    if (requesttype == "ball") then
        if (ballSet > 550) then
            ballSet = 0
            paddle_SPEED = 0
        else
            ballSet = ballSet + 50
            paddle_SPEED = paddle_SPEED + 5
        end
        ballSpeed = ballSet
    end
    if (requesttype == "snc") then
        synctype = synctype + 1
        if (synctype > 1) then
            synctype = 0
        end

        if synctype == 0 then
            synctext = "Independent"
        end
        if synctype == 1 then
            synctext = "Synchronised"
        end
    end
    if (requesttype == "nuclearmod") then
        nuckemodactive = nuckemodactive + 1
        if (nuckemodactive > 1) then
            nuckemodactive = 0
        end
        if (nuckemodactive == 0) then
            areanuclear = 0
            nuclearanimation = 3
            ballSet = 200
            TEXT = "Nuclear Pong"

            synctype = 0
            maxspeed = 700
            synctext = "Independent"
            paddle_SPEED = ballSet / 10
            AI_SPEED = ballSet / 10
        end
        if (nuckemodactive == 1) then
            areanuclear = 1
            ballSet = 2000
            maxspeed = 2000
            paddle_SPEED = ballSet / 10
            AI_SPEED = ballSet / 10
            synctext = "death is imminent"
        end
        ballSpeed = ballSet
    end
    if (requesttype == "practice") then
        if (ballSpeed > 999) then
            ballSpeed = 200
            ballSet = 200
        end
        if (ballSpeed > 799) then
            prtext = "Insane"
            maxBalls = 5
        elseif ballSpeed > 599 then
            prtext = "Hard"
            maxBalls = 4
        elseif ballSpeed > 399 then
            prtext = "Normal"
            maxBalls = 3
        elseif ballSpeed > 199 then
            prtext = "Easy"
            maxBalls = 3
        end
        ballSpeed = ballSpeed + 200
        ballSet = ballSet + 200
    end
    if (requesttype == "reset") then
        ballSpeed = 200
        ballSet = 200
        synctype = 0
        prtext = "Easy"
        maxBalls = 1
    end
    if (requesttype == "pc") then
        if (playerCount == 2) then
            playerCount = 1
            playertext = "1v1"
        elseif (playerCount == 1) then
            playerCount = playerCount + 1
            player3.x = player1.x + VIRTUAL_WIDTH / 2
            player3.y = player3.y
            playertext = "2v2"
        end
    end
    if (requesttype == "ballz") then
        if (maxBalls > 1) then
            --love.window.setTitle("more than 4")
            maxBalls = 1
        else
            maxBalls = maxBalls + 1
        end
    end
    if requesttype == "ptw" then
        if ptw == 10 then
            ptw = 1
        else
            ptw = ptw + 1
        end
    end
end

function gameModeChanger()
    if (gameState == "gameMode") then
        local button_width = VIRTUAL_WIDTH * (1 / 3)
        local BUTTON_HEIGHT = 50
        local margin = 20
        local hot = false
        local cursor_y = 0
        local total_height = (BUTTON_HEIGHT + margin) * #buttons
        for i, button in ipairs(modeSelectorButtons) do
            button.last = button.now
            local bx = (VIRTUAL_WIDTH * 0.5) - (button_width * 0.5)
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
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
                sounds["wallhit"]:play()
                button.fn()
            end
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)
            love.graphics.setColor(0, 0, 0, 255)
            local textW = smallfont:getWidth(button.text)
            local textH = smallfont:getHeight(button.text)
            love.graphics.print(button.text, smallfont, VIRTUAL_WIDTH * 0.5 - textW * 0.5, by + textH * 0.5)
            love.graphics.setColor(255, 255, 255, 255)
            cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
        end
    end
    if (gameState == "multiMode") then
        local button_width = VIRTUAL_WIDTH * (1 / 3)
        local BUTTON_HEIGHT = 50
        local margin = 20
        local hot = false
        local cursor_y = 0
        local total_height = (BUTTON_HEIGHT + margin) * #buttons
        for i, button in ipairs(playerCountButtons) do
            button.last = button.now

            local bx = (VIRTUAL_WIDTH * 0.5) - (button_width * 0.5)

            local by = (VIRTUAL_HEIGHT * 0.3) - (total_height * 0.5) + cursor_y
            if (button.text == "Play") then
                by = by + by / 1.8
            end
            local color = {255, 255, 255, 255}
            local mx, my = love.mouse.getPosition()
            mx = mx * DIFFERENCE_X
            my = my * DIFFERENCE_Y
            hot = (mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT) and i
            if (hot == i) then
                if (button.text == "Play") then
                    color = {0 / 255, 255 / 255, 0 / 255, 255}
                else
                    color = {10, 10, 0, 255}
                end
            end
            button.now = love.mouse.isDown(1)
            if button.now and not button.last and hot == i then
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
                sounds["wallhit"]:play()
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
            if (button.text == "1v1") then
                love.graphics.print(playertext, smallfont, VIRTUAL_WIDTH * 0.5 - textW * 0.5, by + textH * 0.5)
            elseif button.text == "snc" then
                if (nuckemodactive == 1) then
                    love.graphics.setColor(1, 0, 0, 1)
                    love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH * 0.5 - textW * 0.5, by + textH * 0.5)
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH * 0.5 - textW * 0.5, by + textH * 0.5)
                    love.graphics.setColor(0, 0, 0, 1)
                else
                    --
                    love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH * 0.45 - textW * 0.5, by + textH * 0.5)
                end
            elseif (button.text == "ballCount") then
                love.graphics.print(
                    "Ball Count: " .. maxBalls,
                    smallfont,
                    VIRTUAL_WIDTH * 0.5 - textW * 0.5,
                    by + textH * 0.5
                )
            elseif (button.text == "Ball Speed: ") then
                if (nuckemodactive == 1) then
                    love.graphics.setColor(1, 0, 0, 1)
                    love.graphics.print(
                        "shaitan machina",
                        smallfont,
                        VIRTUAL_WIDTH * 0.5 - textW * 0.5,
                        by + textH * 0.5
                    )
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.print(
                        "shaitan machina",
                        smallfont,
                        VIRTUAL_WIDTH * 0.5 - textW * 0.5,
                        by + textH * 0.5
                    )
                    love.graphics.setColor(0, 0, 0, 1)
                else
                    love.graphics.print(
                        button.text .. ballSet,
                        smallfont,
                        VIRTUAL_WIDTH * 0.5 - textW * 0.5,
                        by + textH * 0.5
                    )
                end
            elseif button.text == "ptw" then
                love.graphics.print(
                    "Points to Win: " .. ptw,
                    smallfont,
                    VIRTUAL_WIDTH * 0.5 - textW * 1.5,
                    by + textH * 0.5
                )
            else
                love.graphics.print(button.text, smallfont, VIRTUAL_WIDTH * 0.5 - textW * 0.5, by + textH * 0.5)
            end
            love.graphics.setColor(255, 255, 255, 255)
            cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
        end
    end
end

function love.draw()
    simpleScale.set()
   
        baseDraw()
        
    simpleScale.unSet()
end

--Check if controls are duplicating
function controllerSer()
    for i = 1, maxBalls do
        if (ball[i].dy == 0) then
            hitNum[i] = hitNum[i] + 1
            if hitNum[i] >= 10 then
                ball[i].dy = 1
                hitNum[i] = 0
            end
        else
            hitNum[i] = 0
        end
    end
end

function palleteController() --!!!!LEGACY CODE, MIGRATED TO Paddle.lua!!!!
    if (areanuclear == 0) then
        player1.RED = 1
        player1.GREEN = 1
        player1.BLUE = 1
    end
    if (areanuclear == 0) then
        player2.RED = 1
        player2.GREEN = 1
        player2.BLUE = 1
    end
    if (areanuclear == 1) then
        player1.RED = 0
        player1.GREEN = 0
        player1.BLUE = 0
    end
    if (areanuclear == 1) then
        player2.RED = 0
        player2.GREEN = 0
        player2.BLUE = 0
    end
end

function love.wheelmoved(x, y)
    if (y < 0 and wall1width > 0) then
        wall1width = wall1width - 5
    elseif y > 0 and wall1width < 900 then
        wall1width = wall1width + 5
    end
end

function serveBot() --THIS IS USED TO CHANGE TEXT/BALL DIRECTION ON DIFFERENT SERVES
   --print("servebot called")
    if (gameState == "1serve") then
        updateTEXT = ""
        if (gameMode ~= "practice") then
            TEXT = "PLAYER 1, serve!(q)"
        end
        if ((globalState ~= "clienttest" and love.keyboard.isDown("q")) or (globalState == "clienttest" and lastSentKeyP1 == "q")) then
            TEXT = "Lets Begin!"
            ball_DIR = 1
            for i = 1, maxBalls do
                ball[i]:reset(i)
            end
            gameState = "play"
            
        end
    end
    if (gameState == "2serve") then
        TEXT = "PLAYER 2, serve!(p)"
        if (AGAINST_AI == 1) then
            TEXT = ""
            ball_DIR = -1
            for i = 1, maxBalls do
                ball[i]:reset(i)
            end

            gameState = "play"
            
        end
        if (((globalState == "nettest" and lastSentKeyClient == "p") or ((globalState ~= "nettest") and love.keyboard.isDown("p")))and AGAINST_AI == 0) then
            TEXT = "Lets Begin"
            ball_DIR = -1
            for i = 1, maxBalls do
                ball[i]:reset(i)
            end
            --love.window.setTitle("An atttttttt")
            gameState = "play"
            
        end
    end
end
function mapChanger()
    if (gameState == "editor") then
        MAP_TYPE = 2
    end
    if (MAP_TYPE > 2) then
        MAP_TYPE = 0
    end
    
end
function resolutionChanger()
    if (RESOLUTION_SET > 1) then
        RESOLUTION_SET = 0
    end
    if (RESOLUTION_SET == 0) then
        if (isFullscreen == 1) then
            DIFFERENCE_X = 1
            DIFFERENCE_Y = 1
            simpleScale.updateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false})
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
    for i = 1, maxBalls do
        ball[i]:reset(i)
    end
    paddle_SPEED = 20
    nuclearanimation = 3
    timeIsSlow = false
    timeIsSlow2 = false
    originalSpeed = 200
    gameState = "menu"
    globalState = "menu"
    gameMode = "normal"
    player1.height = 100
    player2.height = 100
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

function love.mousereleased(x, y, button)
    love.keyboard.mouseisReleased = true
    if (gameState == "editor") then
        if (#walls < 1000 and button == 1 and blockinput ~= true) then
            table.insert(walls, newWall(x * DIFFERENCE_X, y * DIFFERENCE_Y, 10, wall1width))
        end
    end
end

function ballsAlive()
    for i = 1, maxBalls do 
        if ball[i].disabled == false then 
            print("Ball " .. i .. " is not disabled")
        return true 
        end
    end 
    return false 
end 
function split(s, delimiter)
	result = {}
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end