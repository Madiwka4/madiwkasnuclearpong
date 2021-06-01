--CALLING OTHER LUA FILES

love.filesystem.setIdentity( "pong" )
love.filesystem.createDirectory( "a" )
require "src/dependencies"


--CANCELLED ATTEMPETED SHADING (NOT WORKING)
local shader_code =
    [[
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 pixel = Texel(image,uvs);
    return pixel * color;
}
]]
--ANDROID EXLUSIVE VARIABLES
touches = {}
doubleclick1 = false 
doubleclick2 = false 
hold1 = false 
hold2 = false 
debug = false
paused = false 
androidButtons = {}
pauseButtons = {}
doneButtons = {}
showTouchControls = false 
--GLOBAL VARIABLES


--0.9 VARIABLES
isButtonAnimated = false

wallsLoadError = false 
background = love.graphics.newImage('img/background.jpg')
backgroundScroll = 0

background_scroll_speed = 10
background_looping_point = 810

--END HERE




frameratecap = 1/60
realtimer = 0
myip = "unknown"
status = "offline"
gameMode = "normal"
ts = 0
globalState = "menu"
timeIsSlow = false
timeIsSlow2 = false
originalSpeed = 200
explosionRange = 0
blockinput = false
wall1width = 30
nuclearanimation = 3
easternum = 0
qq = 0 
ball_DIR = 0
updaterate = 0.015
RED = 255
hitNum = {}
hitNum[1] = 0
hitNum[2] = 0
hitNum[3] = 0
confirmation = "N"
hitNum[4] = 0
p1bonus = 0
p2bonus = 0
hitNum[5] = 0
hitNum[6] = 0
GREEN = 255
IP = '45.76.95.31'
IPnew = '45.76.95.31'
BLUE = 255
updateTEXT = "Galaxy Update"
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
checkrate = 0.5
--CHECKING IF CONTROLS ARE TAKEN
danger = "none"
danger2 = "none"

nuckemodactive = 0
maxspeed = 700
DIFFERENCE_X = 1
DIFFERENCE_Y = 1
OFFSET_X = 0 
OFFSET_Y = 0 
paddle_SPEED = 200
textamount = 15
AI_STRIKEMOD = 1000
resolutionWin = 0
AGAINST_AI = 0
RESOLUTION_SET = 0
AI_NUKEMOD = 1000
animstart = true
AI_SPEED = 300
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
function newTouch(id, x, y)
    return {
        id = id, 
        x = x, 
        y = y,
        originalX = x, 
        originalY = y 
    }
end 
function newButton(text, fn, sp, qp)
    if qp ~= nil then 
        return {
            x = (VIRTUAL_WIDTH * 0.5) - VIRTUAL_WIDTH * (1/3)*0.5,
            text = text,
            fn = fn,
            skipAnim = true,
            now = false,
            last = false
        }
    else
    return {
        x = 1300,
        text = text,
        fn = fn,
        skipAnim = sp,
        now = false,
        last = false
    }
end
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
IPselect = {}
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
    walls = {}
    
    
    print (love.filesystem.getSaveDirectory())
    print (love.filesystem.getIdentity(  ))
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.keyboard.setKeyRepeat(true)
    
    tick.framerate = 60
    simpleScale.setWindow(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
    configfile = io.open("config.lua", "r")
    configsave = io.open("config.lua", "w")
    shader = love.graphics.newShader(shader_code)
    time_1 = 0
   --print("Debug active")
    --load

    testwalls = love.filesystem.load("save")
    if testwalls ~= nil then
        walls = love.filesystem.load("save")
        print("Save file found")
    else
        print("No save file found!")
    end 

    light = 0
    image = love.graphics.newImage("Madi.png")
    table.insert(
        androidButtons,
        newButton(
            "H",
            function()
                if globalState == "base" and gameState ~= "done"  then 
                paused = true 
                else 
                    resetButtonX(buttons)
                    TEXT = "Nuclear Pong"
                    resettinggenius()
                    paused = false 
                    gameState = "menu"
                    ball[1].dx = 1
                    ball_DIR = 1
                    ball[1].dy = 1
                    globalState = "menu"
                    hardmanager()
                end
            end, 
            false
        )
    )
    table.insert(
        editorpicks,
        newButton(
            "C",
            function()
                for k in pairs(walls) do
                    walls[k] = nil
                end
            end,
            false
        )
    )
    table.insert(
        pauseButtons,
        newButton(
            "Resume",
            function()
                paused = false 
                TEXT = "Let's Continue"
            end,
            false
        )
    )
    table.insert(
        doneButtons,
        newButton(
            "Freeplay",
            function()
                if player1score > player2score then 
                    gameState = "2serve"
                else 
                    gameState = "1serve"
                end
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
            end,
            false
        )
    )
    table.insert(
        doneButtons,
        newButton(
            "Menu",
            function()
                resettinggenius()
                TEXT = "Nuclear Pong"
                    paused = false 
                    gameState = "menu"
                    ball[1].dx = 1
                    ball_DIR = 1
                    ball[1].dy = 1
                    globalState = "menu"
                    hardmanager()
            end,
            false
        )
    )
    if not isAndroid then 
        table.insert(
            pauseButtons,
            newButton(
                "Toggle Fullscreen",
                function()
                    myscreen:toggle(VIRTUAL_HEIGHT, VIRTUAL_WIDTH)
                    DIFFERENCE_X = myscreen.c
                    DIFFERENCE_Y = myscreen.d
                    OFFSET_X = myscreen.e 
                    OFFSET_Y = myscreen.f 
                end,
                true
            )
        )
    end 
    table.insert(
        pauseButtons,
        newButton(
            "Toggle Music",
            function()
                if mute then 
                musicController("mute", 0)
                else 
                    musicController("mute", 1)
                end 
            end,
            true
        )
    )
    table.insert(
        pauseButtons,
        newButton(
            "Menu",
            function()
                resettinggenius()
                    paused = false 
                    TEXT = "Nuclear Pong"
                    gameState = "menu"
                    ball[1].dx = 1
                    ball_DIR = 1
                    ball[1].dy = 1
                    globalState = "menu"
                    hardmanager()
            end,
            false
        )
    )

    table.insert(
        editorpicks,
        newButton(
            "S",
            function()
                print(love.filesystem.write("save.lua", serialize(walls)))
            end,
            true
        )
    )
    table.insert(
        editorpicks,
        newButton(
            "L",
            function()
                walls = love.filesystem.load("save.lua")()
                if walls == nil then 
                    walls = {}
                    wallsLoadError = true 
                end
            end,
            true
        )
    )
    table.insert(
        buttons,
        newButton(
            "Singleplayer",
            function()
                ptw = 10
                gameState = "gameMode"
            end,
            false
        )
    )
    table.insert(
        buttons,
        newButton(
            "Online",
            function()
                MAP_TYPE = 0
                if isAndroid then 
                    love.keyboard.setTextInput( true, 0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT/3)
                end
                gameState = "chooseIP"
            end,
            false
        )
    )
    table.insert(
        IPselect,
        newButton(
            "Host",
            function()
                globalState = "nettest"
                AGAINST_AI = 0 
                gameState = "1serve"
                ball[1]:reset(1, 1)
            end,
            true
        )
    )
    table.insert(
        IPselect,
        newButton(
            "Guest",
            function()
                globalState = "clienttest"
                AGAINST_AI = 0 
                gameState = "1serve"
                ball[1]:reset(1, 1)
            end,
            true
        )
    )
    table.insert(
        buttons,
        newButton(
            "Multiplayer",
            function()
                gameState = "multiMode"
            end,
            false
        )
    )
    if not isAndroid then 
        table.insert(
            buttons,
            newButton(
                "Settings",
                function()
                    AGAINST_AI = 0
                    gameState = "windowsettings"
                end,
                false
            )
        )
    else 
        table.insert(
            buttons,
            newButton(
                "Show Controls",
                function()
                    if showTouchControls then 
                        showTouchControls = false 
                    else 
                        showTouchControls = true 
                    end 
                    gameState = "touchcontrols"
                end,
                true
            )
        )
    end 
    table.insert(
        buttons,
        newButton(
            "Exit",
            function()
                love.event.quit(0)
            end,
            false
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "Easy",
            function()
                hardmanager("easy")
            end,
            false
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "Normal",
            function()
                hardmanager("normal")
            end,
            false
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "Hard",
            function()
                hardmanager("hard")
            end,
            false
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "Smart",
            function()
                hardmanager("smart")
            end,
            false
        )
    )
    --table.insert(
    --    settings,
    --    newButton(
    --        "Change Map",
    --        function()
    --            MAP_TYPE = MAP_TYPE + 1
    --        end
    --    )
    --)
    table.insert(
        settings,
        newButton(
            "Toggle Fullscreen",
            function()
                myscreen:toggle(VIRTUAL_HEIGHT, VIRTUAL_WIDTH)
                DIFFERENCE_X = myscreen.c
                DIFFERENCE_Y = myscreen.d
                OFFSET_X = myscreen.e 
                OFFSET_Y = myscreen.f 
            end,
            true
        )
    )
    if isAndroid then 
        table.insert(
            buttons,
            newButton(
                "Toggle Music",
                function()
                    if mute then 
                    musicController("mute", 0)
                    else 
                        musicController("mute", 1)
                    end 
                end,
                true
            )
        )
    end
    table.insert(
        settings,
        newButton(
            "Toggle Music",
            function()
                if mute then 
                musicController("mute", 0)
                else 
                    musicController("mute", 1)
                end 
            end,
            true
        )
    )
    table.insert(
        settings,
        newButton(
            "Editor",
            function()
                gameState = "editor"
            end,
            true
        )
    )
    table.insert(
        settings,
        newButton(
            "Speed Settings",
            function()
                gameState = "speedSettings"
            end,
            true
        )
    )
    table.insert(
        settings,
        newButton(
            "Control Settings",
            function()
                gameState = "controlSettings"
            end,
            false
        )
    )
    table.insert(
        settings,
        newButton(
            "Back to Menu",
            function()
                gameState = "menu"
            end,
            false
        )
    )
    table.insert(
        speedParameters,
        newButton(
            "Back to Menu",
            function()
                gameState = "windowsettings"
            end,
            false
        )
    )
    --table.insert(speedParameters, newButton("Ball Speed: ", function() speedSetter('ball') end))
    table.insert(
        playerCountButtons,
        newButton(
            "Ball Speed: ",
            function()
                speedSetter("ball")
            end,
            true
        )
    )
    --table.insert(speedParameters, newButton("snc", function() speedSetter('snc') end))
    table.insert(
        playerCountButtons,
        newButton(
            "snc",
            function()
                speedSetter("snc")
            end,
            true
        )
    )
    table.insert(
        speedParameters,
        newButton(
            "NUCLEAR MODE",
            function()
                speedSetter("nuclearmod")
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "1up",
            function()
                gameState = "assign"
                req = "p1up"
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "1down",
            function()
                gameState = "assign"
                req = "p1down"
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "1special",
            function()
                gameState = "assign"
                req = "p1super"
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "1ct",
            function()
                gameState = "assign"
                req = "p1ct"
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "2up",
            function()
                gameState = "assign"
                req = "p2up"
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "2down",
            function()
                gameState = "assign"
                req = "p2down"
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "2special",
            function()
                gameState = "assign"
                req = "p2super"
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "2ct",
            function()
                gameState = "assign"
                req = "p2ct"
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "Default",
            function()
                p1control = {up = "a", down = "z", super = "s", counter = "x"}
                p2control = {up = ";", down = ".", super = "l", counter = ","}
            end,
            true
        )
    )
    table.insert(
        controlSettings,
        newButton(
            "Return",
            function()
                gameState = "windowsettings"
            end,
            false
        )
    )
    table.insert(
        modeSelectorButtons,
        newButton(
            "Nuclear Pong",
            function()
                gameState = "difficulty"
            end,
            false
        )
    )
    table.insert(
        modeSelectorButtons,
        newButton(
            "Main Menu",
            function()
                gameState = "menu"
            end,
            false
        )
    )
    table.insert(
        pracdiff,
        newButton(
            "Silverblade",
            function()
                speedSetter("practice")
            end,
            false
        )
    )
    table.insert(
        pracdiff,
        newButton(
            "Return",
            function()
                speedSetter("reset")
                gameState = "gameMode"
            end,
            false
        )
    )
    table.insert(
        pracdiff,
        newButton(
            "Go!",
            function()
                gameMode = "practice"
                hardmanager("practice")
            end,
            false
        )
    )
    --table.insert(playerCountButtons, newButton("1v1", function() speedSetter('pc') end))
    table.insert(
        playerCountButtons,
        newButton(
            "ballCount",
            function()
                speedSetter("ballz")
            end,
            true
        )
    )
    table.insert(
        difbuttons,
        newButton(
            "ballCount",
            function()
                speedSetter("ballz")
            end,
            true
        )
    )
    table.insert(
        playerCountButtons,
        newButton(
            "Return",
            function()
                speedSetter("reset")
                gameState = "menu"
                
            end,
            false
        )
    )
    table.insert(
        playerCountButtons,
        newButton(
            "ptw",
            function()
                speedSetter("ptw")
            end,
            true
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
            end,
            false
        )
    )
    table.insert(
        playerCountButtons,
        newButton(
            "Reverse Play",
            function()
                gameState = "1serve"
                gameMode = "reversegame"
                globalState = "base"
            end,
            false
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
        ["gayTheme4"] = love.audio.newSource("audio/theme5.mp3", "static"),
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
    love.window.setVSync( 0 )
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
    explosions = {}
    ball[1] = eball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    ball[2] = eball(VIRTUAL_WIDTH / 1.9, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    ball[3] = eball(VIRTUAL_WIDTH / 1.8, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    ball[4] = eball(VIRTUAL_WIDTH / 2.2, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    ball[5] = eball(VIRTUAL_WIDTH / 2.1, VIRTUAL_HEIGHT / 2 - 2, 16, 16)
    myscreen = fullScreener(RESOLUTION_SET, isFullscreen, DIFFERENCE_X, DIFFERENCE_Y, OFFSET_X, OFFSET_Y)
    if isAndroid then 
        myscreen:toggle(VIRTUAL_HEIGHT, VIRTUAL_WIDTH)
        DIFFERENCE_X = myscreen.c
        DIFFERENCE_Y = myscreen.d
        OFFSET_X = myscreen.e 
        OFFSET_Y = myscreen.f
    end
    mymenu = mainMenu()

    ballSpeed = 200
    background_scroll_speed = ballSpeed / 20
    background_scroll_speed = ballSpeed / 20
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
    love.window.setTitle(love.timer.getFPS())
    --love.window.setTitle(globalState .. " " .. gameState .. " " .. paddle_SPEED .. " " .. p1bonus .. " " .. player1.dy)
    if love.keyboard.isDown("space") then
        player1nukescore = 200
        player1score = player1score + 0.2
        player2nukescore = 200
    end
    
end

function speedControl()
    if (ballSpeed > maxspeed and gameState == "play") then
        ballSpeed = maxspeed
        background_scroll_speed = ballSpeed / 20
    end
end
checking = 0
function love.update(dt)
    --checking = checking + 1
    --print(checking)
    --print("IMPORTANT!!!!!" .. globalState .. gameState)
    for i, explosion in ipairs(explosions) do 
        explosion:update(dt)
    end
    staticanimatorcounter(dt)
        player1.goal = -1
        player2.goal = -1
    if gameState == "chooseIP" then 
        checkCurrentServer(dt)
    end
    if debug then
        displayFPS()
        --print(player2.y .. " " .. player2.goal .. " " .. player2.dy .. " " .. AI_SPEED .. " " .. paddle_SPEED .. " " .. lastSentKeyClient)
    end 
    if globalState == "base" and not paused then
        basegame(dt)
        
    end
    if globalState == "menu" then
        debugCheck(dt)
        if gameState ~= "animation" then 
            menuDemo(dt)
        end 
    end
    if gameState ~= "animation" then 
        musicController('norm', 1)
        
    end
     
    if globalState == "nettest" then 
        --print("Confcode: " .. confirmation)
        if confirmation == "N" then 
            basegame(dt)
        end
            nettest(dt)
        
    end
    if globalState == "selfhost" then 
        --print("Confcode: " .. confirmation)
        if confirmation == "N" then
            globalState = "nettest" 
            basegame(dt)
        end
            globalState = "selfhost"
            selfHost(dt)
            IP = "127.0.0.1"
        
    end
    if globalState == "clienttest" then
        ts = ts + dt 
        if confirmation == "N" then 
            lastSentKeyP1 = lastSentKeyClient
        clientsBaseGame(dt) 
        end 
        clienttest(dt)
    end

end
serverinit = false 
dserverinit = false
datawaspassedtimer = 0
clientinit = false 
function love.textinput(t)
    if gameState == "chooseIP" then 
    IPnew = IPnew .. t 
    end 
end
function nettest(dt)
   --print("nettest running")
    if serverinit == false then 
        local socket = require "socket"
        local address, port = IP, 12345
       --print(address)
        udp = socket.udp()
        udp:setpeername(address, port)
        udp:settimeout(0)
        serverinit = true 
    end 
    if isAndroid then 
        if table.empty(touches) then 
            lastSentKey = "g"
        end
    end
    for i = 1, maxBalls do 
        ts = ts + dt 
        if ts > updaterate then 
            udp:send(tostring(lastSentKey) .. 
            '|' .. tostring(ball[1].dy) .. 
            '|' .. tostring(player2.y) ..
            '|' .. tostring(player1.y) .. 
            '|' .. tostring(player1score) .. 
            '|' .. tostring(player2score) .. 
            '|' .. tostring(player1nukescore) .. 
            '|' .. tostring(player2nukescore) .. 
            '|' .. tostring(ball[1].x) .. 
            '|' .. tostring(ball[1].y) .. 
            '|' .. gameState .. 
            '|' .. tostring(ball[1].dx) .. 
            '|' .. tostring(ballSpeed) .. 
            '|' .. tostring(paddle_SPEED) .. 
            '|' .. tostring(player1striken) ..
            '|' .. tostring(areanuclear) ..
            "|HOST") 
            ts = 0
        end 
    end 

    local data
    local datanumtest = 0
    local datawaspassed = false 
    repeat 
        datanumtest = datanumtest + 1
       --print("LATENCY: " .. tostring(datanumtest))
    data = udp:receive()
    if data then
        datawaspassed = true 
       --print("ReceivedINFO: " .. data)
        confirmation = "N"
        local p = split(data, '|')
        if p[17] then 
            if tonumber(p[18]) > 90 then 
                confirmation = "L"
            end
            if p[17] ~= "CLIENT" then 
                confirmation = "U"
            end
        elseif p[1] == "RESPONSE" then 
            if p[2] == "1" then 

            elseif p[2] == "2" then 

            elseif p[2] == "3" then 
            end
        else 
            confirmation = "U"
        end

        if p[17] then 
        if ball[1].disabled and ball[1].x > 20 and ball[1].x < VIRTUAL_WIDTH - 20 then 
            ball[1].disabled = false 
           --print("illegal disabling")
        end
        if gameState ~= "1serve" then 
        if (ball[1].x > VIRTUAL_WIDTH/2) then 
            if tonumber(p[9]) > VIRTUAL_WIDTH/2 then
            die = tonumber(p[2])
            lastSentKeyClient, 
            ball[1].dy, 
            player2.y,
            player1score, 
            player2score, 
            player1nukescore, 
            player2nukescore, 
            ball[1].x, 
            ball[1].y, 
            gameState, 
            ball[1].dx, 
            ballSpeed, 
            paddle_SPEED,
            player2striken, 
            areanuclear = p[1], die, tonumber(p[4]), tonumber(p[5]), tonumber(p[6]), tonumber(p[7]), tonumber(p[8]), tonumber(p[9]), tonumber(p[10]), p[11], tonumber(p[12]), tonumber(p[13]), tonumber(p[14]), tonumber(p[15]), tonumber(p[16])
           --print("ACCEPTED")
        else 
       --print("DECLINED")
        end
        else  
            if tonumber(p[9]) > VIRTUAL_WIDTH/2 then 
                die = tonumber(p[2])
                lastSentKeyClient, 
                ball[1].dy, 
                player2.y,
                player1score, 
                player2score, 
                player1nukescore, 
                player2nukescore, 
                ball[1].x, 
                ball[1].y, 
                gameState, 
                ball[1].dx, 
                ballSpeed, 
                paddle_SPEED, player2striken,
                areanuclear = p[1], die, tonumber(p[4]), tonumber(p[5]), tonumber(p[6]), tonumber(p[7]), tonumber(p[8]), tonumber(p[9]), tonumber(p[10]), p[11], tonumber(p[12]), tonumber(p[13]), tonumber(p[14]), tonumber(p[15]), tonumber(p[16])
               --print("ACCEPTED")
            else 
           --print("ENFORCED" .. ball[1].x .. " " .. ball[1].dx)
            lastSentKeyClient = p[1]
            player2striken = tonumber(p[15])
            player2.y = tonumber(p[4])
            end 
        end
        end
        end
    end 
until not data
    if not datawaspassed then  
        datawaspassedtimer = datawaspassedtimer + 1 
        if datawaspassedtimer > 15 then 
        confirmation = "D"
        datawaspassedtimer = 0
        end 
    else 
        datawaspassedtimer = 0 
    end
end
function clienttest(dt) 
    if clientinit == false then 
        local socket = require "socket"
        local address, port = IP, 12345
        
        udp = socket.udp()
        udp:setpeername(address, port)
        udp:settimeout(0)
        clientinit = true 
    end
    if isAndroid then 
        if table.empty(touches) then 
            lastSentKey = "g"
        end
    end
    ts = ts + dt 
    if ts > updaterate then 
        udp:send(tostring(lastSentKey) .. 
        '|' .. tostring(ball[1].dy) .. 
        '|' .. tostring(player1.y) ..
        '|' .. tostring(player2.y) .. 
        '|' .. tostring(player1score) .. 
        '|' .. tostring(player2score) .. 
        '|' .. tostring(player1nukescore) .. 
        '|' .. tostring(player2nukescore) .. 
        '|' .. tostring(ball[1].x) .. 
        '|' .. tostring(ball[1].y) .. 
        '|' .. gameState .. 
        '|' .. tostring(ball[1].dx) .. 
        '|' .. tostring(ballSpeed) .. 
        '|' .. tostring(paddle_SPEED) ..
        '|' .. tostring(player2striken) .. 
        '|' .. tostring(areanuclear) ..
        "|CLIENT")
        ts = 0 
    end
    local data
    local datanumtest = 0
    local datawaspassed = false 
    repeat 
        datanumtest = datanumtest + 1
       --print("LATENCY: " .. tostring(datanumtest))
        data = udp:receive()
        
    if data then
       --print("RECEIVED DATA: " .. data)
        datawaspassed = true 
       --print("SENT TO SERVER:" ..  lastSentKey)
        confirmation = "N"
        local p = split(data, '|')
        if p[17] then 
            if p[17] ~= "HOST" then 
                confirmation = "U"
            end
            if tonumber(p[18]) > 90 then 
                confirmation = "L"
            end 
            for i = 1, maxBalls do 
            local die = tonumber(p[2])
            if (ball[i].x <= VIRTUAL_WIDTH/2) then
                if tonumber(p[9]) <= VIRTUAL_WIDTH/2 then 
                lastSentKeyClient, ball[i].dy, player1.y, player1score, player2score, player1nukescore, player2nukescore, ball[i].x, ball[i].y, gameState, ball[i].dx, ballSpeed, paddle_SPEED, player1striken, areanuclear  = p[1], die, tonumber(p[4]), tonumber(p[5]), tonumber(p[6]), tonumber(p[7]), tonumber(p[8]), tonumber(p[9]), tonumber(p[10]), p[11], tonumber(p[12]), tonumber(p[13]), tonumber(p[14]), tonumber(p[15]), tonumber(p[16])
               --print("ACCEPTED")
                else 
               --print("DECLINED")
                end
            else 
                if tonumber(p[9]) <= VIRTUAL_WIDTH/2 then 
                lastSentKeyClient, ball[i].dy, player1.y, player1score, player2score, player1nukescore, player2nukescore, ball[i].x, ball[i].y, gameState, ball[i].dx, ballSpeed, paddle_SPEED, player1striken, areanuclear = p[1], die, tonumber(p[4]), tonumber(p[5]), tonumber(p[6]), tonumber(p[7]), tonumber(p[8]), tonumber(p[9]), tonumber(p[10]), p[11], tonumber(p[12]), tonumber(p[13]), tonumber(p[14]), tonumber(p[15]), tonumber(p[16])
               --print("REROUTED")
                else lastSentKeyClient = p[1] 
                player1.y = tonumber(p[4])
                player1striken = tonumber(p[15])
               --print("ENFORCED")
                end
            end 
            end
        else
            confirmation = "U"
        end 
    end
   --print("GOT: " .. lastSentKeyClient)
    until not data 
    if not datawaspassed then  
        datawaspassedtimer = datawaspassedtimer + 1 
        if datawaspassedtimer > 15 then 
        confirmation = "D"
        datawaspassedtimer = 0
        end 
    else 
        datawaspassedtimer = 0 
    end
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
        AI_SPEED = ballSet
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
        AI_SPEED = ballSet
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
    if not isAndroid then
        lastSentKey = key  
    end
    
    if gameState == "chooseIP" then 
        if key == "backspace" then
            -- get the byte offset to the last UTF-8 character in the string.
            local byteoffset = utf8.offset(IPnew, -1)
     
            if byteoffset then
                -- remove the last UTF-8 character.
                -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
                IPnew = string.sub(IPnew, 1, byteoffset - 1)
            end
        end
    end
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
        if not isAndroid and globalState == "base" and gameState ~= "done" then 
            if paused then 
                paused = false 
                TEXT = "Let's Continue"
            else 
            paused = true
            TEXT = "PAUSED"
            end  
            
        end 
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            resettinggenius()
            gameState = "menu"
            ball[1].dx = 1
            ball[1].dy = 1
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
                    ball[i]:reset(i, 1)
                end
            end
        else
            gameState = "menu"
            ball[1].dx = 1
            ball[1].dy = 1
            globalState = "menu"
            if (love.math.random(0, 20) == 1) then
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
        if lastSentKey == key and not isAndroid then
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
        background_scroll_speed = ballSpeed / 20
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
            paddle_SPEED = ballSet
            AI_SPEED = ballSet
        end
        if (nuckemodactive == 1) then
            areanuclear = 1
            ballSet = 2000
            maxspeed = 2000
            paddle_SPEED = ballSet
            AI_SPEED = ballSet
            synctext = "death is imminent"
        end
        ballSpeed = ballSet
        background_scroll_speed = ballSpeed / 20
    end
    if (requesttype == "practice") then
        if (ballSpeed > 999) then
            ballSpeed = 200
            background_scroll_speed = ballSpeed / 20
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
        background_scroll_speed = ballSpeed / 20
        ballSet = ballSet + 200
    end
    if (requesttype == "reset") then
        ballSpeed = 200
        background_scroll_speed = ballSpeed / 20
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
            mx = mx   
            my = my  
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
            mx = mx   
            my = my  
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

function love.draw(dt)
    simpleScale.set()

        if globalState == "selfhost" then 
            globalState = "nettest"
            baseDraw()
            globalState = "selfhost"
        else
            baseDraw()
        end
        if (globalState == "nettest" or globalState == "clienttest" or globalState == "selfhost") and confirmation == "D" then 
            love.graphics.clear(50 / 255, 50 / 255, 50 / 255, 255)
            love.graphics.printf("WAIT FOR OPPONENT", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
        end
        if (globalState == "nettest" or globalState == "clienttest" or globalState == "selfhost") and confirmation == "U" then 
            love.graphics.clear(50 / 255, 50 / 255, 50 / 255, 255)
            love.graphics.printf("LOBBY FULL OR WRONG MODE CHOSEN", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
        end
        if (globalState == "nettest" or globalState == "clienttest" or globalState == "selfhost") and confirmation == "L" then 
            love.graphics.clear(50 / 255, 50 / 255, 50 / 255, 255)
            love.graphics.printf("POOR CONNECTION TO SERVER", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
        end
        if (globalState == "nettest" or globalState == "clienttest" or globalState == "selfhost") and confirmation == "S" then 
            love.graphics.clear(50 / 255, 50 / 255, 50 / 255, 255)
            love.graphics.printf("INTERNAL SERVER WAITING", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
            love.graphics.printf(myip, 0, VIRTUAL_HEIGHT / 2 + 120, VIRTUAL_WIDTH, "center")
        end
        if isAndroid then 
            androidDraw()
            love.keyboard.mouseisReleased = false
        end
        if debug then 
        if touches then 
        for i, touch in ipairs(touches) do 
        love.graphics.printf(touch.x, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
        end 
        if doubleclick1 then 
            TEXT = "DOUBLECLICK1"
            elseif doubleclick2 then TEXT = "DOUBLECLICK2"
            else TEXT = "NO"
            end
        end
    end 
    if wallsLoadError then 
        love.graphics.setColor(1,0,0,1)
        love.graphics.printf("Error loading map!", 0,0,VIRTUAL_WIDTH, "left")
    end
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
            if isAndroid then 
                TEXT = "PLAYER 1, serve!(double-click)"
            else
                TEXT = "PLAYER 1, serve!(q)"
            end
        end
        if ((globalState ~= "clienttest" and love.keyboard.isDown("q")) or (globalState == "clienttest" and lastSentKeyP1 == "q") or doubleclick1) then
            TEXT = "Lets Begin!"
            doubleclick1 = false 
            ball_DIR = 1
            if maxBalls == 1 then 
                ball[1]:reset(1, 1)
            else 
                for i = 1, maxBalls do
                    ball[i]:reset(i)
                end
            end 
            gameState = "play"
            
        end
    end
    if (gameState == "2serve") then
        if (gameMode ~= "practice") then
            if isAndroid then 
                TEXT = "PLAYER 2, serve!(double-click)"
            else
                TEXT = "PLAYER 2, serve!(p)"
            end
        end
        if (AGAINST_AI == 1) then
            TEXT = ""
            doubleclick2 = false 
            ball_DIR = -1
            if maxBalls == 1 then 
                ball[2]:reset(i, 2)
            else 
                for i = 1, maxBalls do
                    ball[i]:reset(i)
                end
            end 

            gameState = "play"
            
        end
        if (((globalState == "nettest" and lastSentKeyClient == "p") or ((globalState ~= "nettest") and love.keyboard.isDown("p")) or doubleclick2)and AGAINST_AI == 0) then
            TEXT = "Lets Begin"
            doubleclick2 = false 
            ball_DIR = -1
            if maxBalls == 1 then 
                ball[1]:reset(1, 2)
            else 
                for i = 1, maxBalls do
                    ball[i]:reset(i)
                end
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
            OFFSET_X = 0
            OFFSET_Y = 0
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
            OFFSET_X = math.fmod(newWidth, VIRTUAL_WIDTH) / 2 
            OFFSET_Y = math.fmod(newHeight, VIRTUAL_HEIGHT) / 2
            isFullscreen = 1
        end
    end
end
function resettinggenius()
    maxBalls = 1
    for i = 1, maxBalls do
        ball[i]:reset(i)
    end
    paddle_SPEED = 200
    nuclearanimation = 3
    timeIsSlow = false
    timeIsSlow2 = false
    serverinit = false 
    ts = 0 
    originalSpeed = 200
    gameState = "menu"
    ball[1].dx = 1
    ball_DIR = 1
    ball[1].dy = 1
    globalState = "menu"
    gameMode = "normal"
    player1.height = 100
    player2.height = 100
    ballSet = 200
    ballSpeed = ballSet
    background_scroll_speed = ballSpeed / 20
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
            table.insert(walls, newWall((x ) * DIFFERENCE_Y , (y ) * DIFFERENCE_Y , 10, wall1width))
        end
    end
end

function ballsAlive()
    for i = 1, maxBalls do 
        if ball[i].disabled == false then 
           --print("Ball " .. i .. " is not disabled")
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
address, port = IP, 12345
function checkCurrentServer(dt)
    if GetIPType(IP) ~= 1 then
        status = "offline"
    end 
    if GetIPType(IP) == 1 then 
    if dserverinit == false then 
       --print("Switching IP")
        socket = require "socket"
        address, port = IP, 12345
       --print(address)
        udp = socket.udp()
        udp:setpeername(address, port)
        udp:settimeout(0)
        dserverinit = true 
    end 
    if IP ~= address then dserverinit = false--print(IP .. " doesnt equal " .. address)
    else 
    ts = ts + dt
    --print(ts)
    if ts > checkrate then 
        status = "offline"
       --print("sent ping")
        udp:send("HELLO")
    local data
    data = udp:receive()
    if data then 
       --print("got answer!")
        local p = split(data, '|')
        status = p[1]
       print("answer is " .. status)
    else 
       print("no response!")
    end
    ts = 0 
    end 
end
end

end 
local gts = 0 
hostinit = false 
player1ip = "127.0.0.1"
player1port = "12345"
player2ip = "none"
player2port = nil
local p1ping = 0
local p2ping = 0
local requesterip 
local requresterport
function selfHost(dt)
   --print("Server running")
    if not hostinit then 
        local socket = require('socket')
        udp = socket.udp()
        udp:setsockname('*', 12345)
        udp:settimeout(0)
        local s = socket.udp()
        s:setpeername("74.125.115.104",80)
        myip, _ = s:getsockname()

        hostinit = true 
    else 
    gts = gts + dt 
    if gts > 0.015 then 
    local data, msg_or_ip, port_or_nil
  local p1data, p2data
  if table.empty(touches) then 
    lastSentKey = "g"
end
  repeat

    data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then

      if data == "HELLO" then
       --print("getting pinged")
        requesterip = msg_or_ip
        requesterport = port_or_nil
      else
       --print(string.sub(data,1,1) .. "Playerlist: " .. player1ip .. " " .. player2ip)
        if player2ip == msg_or_ip then
          p2data = data .. '|' .. p2ping
          p2ping = 0
        else
          if player2ip == "none" and msg_or_ip ~= player1ip then
            player2ip = msg_or_ip
            p2data = data .. '|' ..  p2ping
            p2ping = 0
            player2port = port_or_nil
           --print("CONNECTED: PLAYER 2 FROM: " .. player2ip)
          elseif (player1ip ~= msg_or_ip and player2ip ~= msg_or_ip) then
           --print("Lobby Full!" .. player1ip .. player2ip)
          end
        end

      end
    end
   until not data
    if player1ip ~= "none" then
      p1ping = p1ping + 1
    end
    if player2ip == "none" then 
        confirmation = "S"
    else 
       --print("Player2: " .. player2ip)
      p2ping = p2ping + 1
      if p2ping > 100 then
            for i = 1, maxBalls do 
                ts = ts + dt 
                if ts > updaterate then 
                    udp:sendto(tostring(lastSentKey) .. 
                    '|' .. tostring(ball[1].dy) .. 
                    '|' .. tostring(player2.y) ..
                    '|' .. tostring(player1.y) .. 
                    '|' .. tostring(player1score) .. 
                    '|' .. tostring(player2score) .. 
                    '|' .. tostring(player1nukescore) .. 
                    '|' .. tostring(player2nukescore) .. 
                    '|' .. tostring(ball[1].x) .. 
                    '|' .. tostring(ball[1].y) .. 
                    '|' .. gameState .. 
                    '|' .. tostring(ball[1].dx) .. 
                    '|' .. tostring(ballSpeed) .. 
                    '|' .. tostring(paddle_SPEED) .. 
                    '|' .. tostring(player1striken) .. 
                    '|' .. tostring(areanuclear) ..
                    "|HOST|".. p2ping, player2ip, player2port) 
                    ts = 0
                end 
            end 
       --print("PLAYER 2 DISCONNECTED")
        p2data = nil
        player2ip = "none"
        player2port = nil
      end
    end
    if player2port then
        for i = 1, maxBalls do 
            ts = ts + dt 
            if ts > updaterate then 
                udp:sendto(tostring(lastSentKey) .. 
                '|' .. tostring(ball[1].dy) .. 
                '|' .. tostring(player2.y) ..
                '|' .. tostring(player1.y) .. 
                '|' .. tostring(player1score) .. 
                '|' .. tostring(player2score) .. 
                '|' .. tostring(player1nukescore) .. 
                '|' .. tostring(player2nukescore) .. 
                '|' .. tostring(ball[1].x) .. 
                '|' .. tostring(ball[1].y) .. 
                '|' .. gameState .. 
                '|' .. tostring(ball[1].dx) .. 
                '|' .. tostring(ballSpeed) .. 
                '|' .. tostring(paddle_SPEED) .. 
                '|' .. tostring(player1striken) .. 
                '|' .. tostring(areanuclear) ..
                "|HOST|".. p2ping, player2ip, player2port) 
                ts = 0
            end 
        end 
     --print("SENT TO " .. player2ip .. ":" .. player2port ..  " : " ..lastSentKey)
    end
    local datanumtest = 0
    local datawaspassed = false 
    if p2data and player1port then
            datawaspassed = true 
           --print("ReceivedINFO: " .. p2data)
            confirmation = "N"
            local p = split(p2data, '|')
            if p[17] then 
                if tonumber(p[18]) > 90 then 
                    confirmation = "L"
                end
                if p[17] ~= "CLIENT" then 
                    confirmation = "U"
                end
            elseif p[1] == "RESPONSE" then 
                if p[2] == "1" then 
    
                elseif p[2] == "2" then 
    
                elseif p[2] == "3" then 
                end
            else 
                confirmation = "U"
            end
    
            if p[17] then 
            if ball[1].disabled and ball[1].x > 20 and ball[1].x < VIRTUAL_WIDTH - 20 then 
                ball[1].disabled = false 
               --print("illegal disabling")
            end
            if gameState ~= "1serve" then 
            if (ball[1].x > VIRTUAL_WIDTH/2) then 
                if tonumber(p[9]) > VIRTUAL_WIDTH/2 then
                die = tonumber(p[2])
                lastSentKeyClient, 
                ball[1].dy, 
                player2.y,
                player1score, 
                player2score, 
                player1nukescore, 
                player2nukescore, 
                ball[1].x, 
                ball[1].y, 
                gameState, 
                ball[1].dx, 
                ballSpeed, 
                paddle_SPEED, player2striken,
                areanuclear = p[1], die, tonumber(p[4]), tonumber(p[5]), tonumber(p[6]), tonumber(p[7]), tonumber(p[8]), tonumber(p[9]), tonumber(p[10]), p[11], tonumber(p[12]), tonumber(p[13]), tonumber(p[14]), tonumber(p[15]), tonumber(p[16])
               --print("ACCEPTED")
            else 
           --print("DECLINED")
            end
            else  
                if tonumber(p[9]) > VIRTUAL_WIDTH/2 then 
                    die = tonumber(p[2])
                    lastSentKeyClient, 
                    ball[1].dy, 
                    player2.y,
                    player1score, 
                    player2score, 
                    player1nukescore, 
                    player2nukescore, 
                    ball[1].x, 
                    ball[1].y, 
                    gameState, 
                    ball[1].dx, 
                    ballSpeed, 
                    paddle_SPEED, player2striken, 
                    areanuclear = p[1], die, tonumber(p[4]), tonumber(p[5]), tonumber(p[6]), tonumber(p[7]), tonumber(p[8]), tonumber(p[9]), tonumber(p[10]), p[11], tonumber(p[12]), tonumber(p[13]), tonumber(p[14]), tonumber(p[15]), tonumber(p[16])
                   --print("ACCEPTED")
                else 
               --print("ENFORCED" .. ball[1].x .. " " .. ball[1].dx)
                lastSentKeyClient = p[1]
                player2.y = tonumber(p[4])
                player2striken = tonumber(p[15])
                end 
            end
            end
            end
     --print("SENT TO " .. player1ip .. ":" .. player1port .. " : " .. string.sub(p2data,1,1))
      --print("1::" .. p1data)
      --print("2::" .. p2data)
      --print("SENT1: " .. player2ip .. " " .. player2port .. " " .. p1data)
      --print("SENT2: " .. player1ip .. " " .. player1port .. " " .. p2data)
    end
    if requesterip then
       --print("getting pnged!")
        if player2ip == "none" then
          udp:sendto("clienttest", requesterip, requesterport)
         --print("clienttest av to: " .. requesterip)
        else
          udp:sendto("full", requesterip, requesterport)
         --print("full to: " .. msg_or_ip)
        end
        requesterip, requesterport = nil
    end
    gts = 0
    end
end
end
local lastclick = 0
local clickInterval = 0.4
function love.touchpressed( id, x, y, dx, dy, pressure )
    if isAndroid then
        if x < love.graphics.getWidth()-OFFSET_X/2 then  
        actualX = (x - OFFSET_X/2) * DIFFERENCE_Y
        else 
            actualX = 1380
        end
        local existsingID = touchExists(id)
        if existsingID ~= -1 then 
            touches[existsingID].x = actualX
            touches[existsingID].y = (y) * DIFFERENCE_Y
        else 
            table.insert(touches, newTouch(id, actualX , (y)  * DIFFERENCE_Y))
            local time = love.timer.getTime()
            if actualX < VIRTUAL_WIDTH/2  then 
            if time <= lastclick + clickInterval and actualX> 100 then
                doubleclick1 = true 
                if gameState == "1serve" then 
                    lastSentKey = "q"
                else 
                    lastSentKey = p1control.super 
                end 
            else
                doubleclick1 = false 
                lastclick = time
            end

            else 
                if time <= lastclick + clickInterval and actualX < VIRTUAL_WIDTH-100 then
                    doubleclick2 = true 
                    if gameState == "2serve" then 
                        lastSentKey = "p"
                    else 
                        lastSentKey = p2control.super 
                    end 
                else
                    doubleclick2 = false 
                    lastclick = time
                end
            end
        end
    end 
end 
function love.touchreleased( id, x, y, dx, dy, pressure )
    if isAndroid then 
        if gameState == "start" then 
            resettinggenius()
            gameState = "menu"
            ball[1].dx = 1
            ball_DIR = 1
            ball[1].dy = 1
            globalState = "menu"
            hardmanager()

        end 
        local existsingID = touchExists(id)
        if existsingID ~= -1 then 
            table.remove(touches, existsingID)
        end
    end
end 
function love.touchmoved( id, x, y, dx, dy, pressure )
    if isAndroid then 
        if x < love.graphics.getWidth()-OFFSET_X/2 then  
            actualX = (x - OFFSET_X/2) * DIFFERENCE_Y
            else 
                actualX = 1380
            end
        local existsingID = touchExists(id)
        if existsingID ~= -1 then 
            touches[existsingID].x = actualX
            touches[existsingID].y = (y  ) * DIFFERENCE_Y 
            if touches[existsingID].originalX - touches[existsingID].x > 200 and 
            touches[existsingID].originalX < VIRTUAL_WIDTH/2 then 
                hold1 = true 
                lastSentKey = p1control.counter 
            else
                hold1 = false
            end
            if touches[existsingID].x - touches[existsingID].originalX > 200 and 
            touches[existsingID].originalX > VIRTUAL_WIDTH/2 then 
                hold2 = true 
            
                lastSentKey = p2control.counter 
            else
                hold2 = false
            end
        end
    end 
end 
function touchExists(ID)
    for i, touch in ipairs(touches) do 
        if touch.id == ID then 
            return i 
        end 
    end
    return -1
end 
function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end
function sectortouched(sector)
for i, touch in ipairs(touches) do 
    if (AGAINST_AI == 1) then 
        if sector == 2 and touch.x < 100 and touch.y < player1.y then 
            lastSentKey = p1control.up
            return true 
        elseif sector == 2 and touch.x > VIRTUAL_WIDTH/2+10 and touch.y < player1.y then 
                lastSentKey = p1control.up
                return true 
        elseif sector == 3 and touch.x < 100 and touch.y > player1.y+player1.height*0.9 then 
            lastSentKey = p1control.down
            return true    
        elseif sector == 3 and touch.x > VIRTUAL_WIDTH/2+10 and touch.y > player1.y+player1.height*0.9 then 
            lastSentKey = p1control.down
            return true  
        end
    else
    if sector == 1 and touch.x > VIRTUAL_WIDTH-100 and touch.y < player2.y then 
        lastSentKey = p2control.up 
        return true 
    elseif sector == 2 and touch.x < 100 and touch.y < player1.y then 
        lastSentKey = p1control.up
        return true 
    elseif sector == 3 and touch.x < 100 and touch.y > player1.y+player1.height*0.9 then 
        lastSentKey = p1control.down
        return true    
    elseif sector == 4 and touch.x > VIRTUAL_WIDTH-100 and touch.y > player2.y+player1.height*0.9 then 
        lastSentKey = p2control.down
        return true
    end 
end 
end
return false 
end 

function resetButtonX(arr)
    for i, buttons in ipairs(arr) do 
        buttons.x = 1300 
  end
end 

