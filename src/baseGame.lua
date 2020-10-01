local counter = 0
function basegame(dt) 
    if gameMode == "reversegame" then 
        reversegame(dt)
    end 
    if player1nukescore > 300 then 
        player1nukescore = 300 
    end 
    if player2nukescore > 300 then 
        player2nukescore = 300 
    end
    speedControl()
    balancer()
    
    if t < shakeDuration then
        t = t + dt
    end
   --print("T = " .. tostring(t))
    serveBot()
    if gameState == 'play' then 
        if (AGAINST_AI == 1) then
            AI(player2, maxBalls, AI_LEVEL)
        end
        if (love.keyboard.isDown(p1control.up) or sectortouched(2)) then
            player1.dy = (paddle_SPEED + p1bonus) * -1
        elseif (love.keyboard.isDown(p1control.down) or sectortouched(3)) then
            player1.dy = paddle_SPEED + p1bonus
        else
            player1.dy = 0
        end
        if (AGAINST_AI == 0) then
            if ((globalState ~= "nettest" and (love.keyboard.isDown(p2control.up) or sectortouched(1))) ) then
                player2.dy = (paddle_SPEED + p2bonus) * -1
            elseif ((globalState ~= "nettest" and (love.keyboard.isDown(p2control.down) or sectortouched(4)))) then
                player2.dy = paddle_SPEED + p2bonus
            elseif (globalState ~= "nettest") then 
                player2.dy = 0
            end
        end
       --print(areanuclear .. striken .. player1score .. player2score)
        for i = 1, maxBalls do
            if rules("p1hit", i) then
                
                if (areanuclear == 0 and striken == 1 and (player1score > ptw*0.8 or player2score > ptw*0.8)) then
                   --print("Calling animation")
                  --print("AREA NUCLEAR?" .. areanuclear)
                    superanimator("tensehit", 1)
                end
                if gameMode == "practice" then
                    player1score = player1score + 1
                end
                t = 0
                if (ballSpeed > 200) then
                    shakeMagnitude = ballSpeed / 200
                else
                    shakeMagnitude = 0
                end
                shakeDuration = 1
                randomtext = love.math.random(1, #textphrases)
                TEXT = textphrases[randomtext]
                soundtype = love.math.random(1, 1.2)

                if (player1striken == 1) then
                    TEXT = "PLAYER 1 STRIKES"
                    ballSpeed = ballSpeed + player1nukescore
                    potentialnuke1 = 0
                    player1striken = 0
                    player1nukescore = 0
                    potentialstrike1 = 0
                    striken = 1
                    if areanuclear == 0 then
                        sounds["striking"]:setPitch(ballSpeed / 250)
                        sounds["striking"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                   --print("AREA NUCLEAR?" .. areanuclear)
                    if areanuclear == 0 then 
                    superanimator("tensehit", 1)
                    end
                else
                    if areanuclear == 0 then
                        sounds["beep"]:setPitch(ballSpeed / 250)
                        sounds["beep"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                end
                if (striken == 1) then
                    
                    player1nukescore = player1nukescore * 1.5
                    if (synctype == 0) then
                        paddle_SPEED = paddle_SPEED * 1.10
                    elseif (synctype == 1) then
                        paddle_SPEED = ballSpeed
                    end
                    if (synctype == 0) then
                        AI_SPEED = AI_SPEED * 1.10
                    end
                    if (synctype == 1) then
                        AI_SPEED = ballSpeed * 1.1 / 10
                    end
                    ballSpeed = ballSpeed * 1.10
                end
                player1nukescore = player1nukescore + 10
                ball[i].dx = -ball[i].dx
                ball[i].x = player1.x + 30

                if (love.keyboard.isDown(p1control.up) or sectortouched(2)) then
                    select = math.random(1, 5)
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
                elseif love.keyboard.isDown(p1control.down) or sectortouched(3) then
                    select = math.random(1, 5)
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
                        select = math.random(1, 5)
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
                        select = math.random(1, 5)
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
            if rules("p2hit", i) then
                --ameState = 'quickanim'
                t = 0
                shakeDuration = 1
                if
                    (areanuclear == 0 and
                        (striken == 1 and (player1score > ptw*0.8 or player2score > ptw*0.8)))
                 then
                   --print("AREA NUCLEAR?" .. areanuclear)
                    superanimator("tensehit", 2)
                end
                if (ballSpeed > 200) then
                    shakeMagnitude = ballSpeed / 200
                else
                    shakeMagnitude = 0
                end
                randomtext = love.math.random(1, #textphrases)
                TEXT = textphrases[randomtext]
                soundtype = love.math.random(1, 1.2)

                if (player2striken == 1) then
                    TEXT = "PLAYER 2 STRIKES"
                    ballSpeed = ballSpeed + player2nukescore
                    striken = 1
                    player2striken = 0
                    potentialnuke2 = 0
                    player2nukescore = 0
                    potentialstrike2 = 0
                   --print("AREA NUCLEAR?" .. areanuclear)
                    if areanuclear == 0 then 
                    superanimator("tensehit", 2)
                    end
                    if areanuclear == 0 then
                        sounds["striking"]:setPitch(ballSpeed / 250)
                        sounds["striking"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                elseif (striken == 1) then
                    
                    player2nukescore = player2nukescore * 1.5
                    if (synctype == 0) then
                        paddle_SPEED = paddle_SPEED * 1.10
                    end
                    if (synctype == 1) then
                        paddle_SPEED = ballSpeed
                    end
                    if (synctype == 0) then
                        AI_SPEED = AI_SPEED * 1.10
                    end
                    if (synctype == 1) then
                        AI_SPEED = ballSpeed * 1.1 / 10
                    end
                    ballSpeed = ballSpeed * 1.10
                    if areanuclear == 0 then
                        sounds["beep"]:setPitch(ballSpeed / 250)
                        sounds["beep"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                else
                    if areanuclear == 0 then
                        sounds["beep"]:setPitch(ballSpeed / 250)
                        sounds["beep"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                end
                player2nukescore = player2nukescore + 10
                ball[i].dx = -ball[i].dx
                ball[i].x = player2.x - 30

                if ((globalState ~= "nettest" and (love.keyboard.isDown(p2control.up) or sectortouched(1)) ) or AI_SPEED < 0 or lastSentKeyClient == p2control.up) then
                    select = math.random(1, 5)
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
                elseif (globalState ~= "nettest" and (love.keyboard.isDown(p2control.down)or sectortouched(4))) or AI_SPEED > 0 or lastSentKeyClient == p2control.down then
                    select = math.random(1, 5)
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
                        select = math.random(1, 5)
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
                        select = math.random(1, 5)
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
            hitIdentifier()
            if ball[i].y <= 0 then
                soundtype = love.math.random(1, 5)
                sounds["wallhit"]:setPitch(ballSpeed / 250)
                sounds["wallhit"]:play()
                ball[i].y = 0
                ball[i].dy = -ball[i].dy
            end

            -- -4 to account for the ball's size
            if ball[i].y >= VIRTUAL_HEIGHT - 40 then
                soundtype = love.math.random(1, 5)
                sounds["wallhit"]:setPitch(ballSpeed / 250)
                sounds["wallhit"]:play()
                ball[i].y = VIRTUAL_HEIGHT - 40
                ball[i].dy = -ball[i].dy
            end
            --love.window.setTitle('Trying to update the ball')
            if timeIsSlow then
                if ballSpeed > originalSpeed / 3 then
                    paddle_SPEED = 300
                    ballSpeed = ballSpeed / (1 + (dt * 2))
                end
                player1nukescore = player1nukescore - (dt * 50)
                if player1nukescore < 1 or ball[1].dx > 0 then
                    timeIsSlow = false
                    player1reverbav = false
                    ballSpeed = originalSpeed
                    sounds["time"]:stop()
                    paddle_SPEED = originalPaddle
                end
            end
            if timeIsSlow2 then
                if ballSpeed > originalSpeed / 3 then
                    ballSpeed = ballSpeed / (1 + (dt * 2))
                end
                player2nukescore = player2nukescore - (dt * 50)
                if player2nukescore < 1 or ball[1].dx < 0 then
                    paddle_SPEED = 300
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
    goalManager()
    powerAvailability()
    player1:update(dt)
    player2:update(dt)
end




function debugCheck(dt)
    
    if (gameState == "menu") then
        updateTEXT = "0.7.9 Chalkboard"
    end
    dangerChecker()
    elapsed = elapsed + dt  
    rotation = math.sin(elapsed * 2.5) * 0.7
    if gameState == "assign" then
        controlChanger()
    end
    editor()
    mapChanger()
end 

function goalManager()
    for i = 1, maxBalls do
        if (rules("p1miss", i)) then
            ball[i].disabled = true 
            ball[i].x = 2000
            
            if ballsAlive() == false then 
                if (nuckemodactive == 0) then
                    areanuclear = 0
                    nuclearanimation = 3
                end
                striken = 0
                player1striken = 0
                player2striken = 0
                ballSpeed = ballSet
                if (synctype == 0) then
                    paddle_SPEED = ballSet
                end
                if (synctype == 1) then
                    paddle_SPEED = ballSpeed 
                end
        
                AI_SPEED = difficultyl 
                for i = 1, maxBalls do
                    ball[i]:reset(i, 2)
                end
                if (player2score+1 >= ptw and gameMode ~= "practice") then
                    for i = 1, maxBalls do
                        ball[i]:reset(i)
                    end
                    sounds["win"]:play()
                    gameState = "done"
                    TEXT = "Player 2 Won!"
                else
                    if globalState ~= "clienttest" or (globalState == "clienttest" and gameState == "1serve") then 
                        gameState = "1serve"
                        serveBot()
                        ball[i]:reset(i, 1)
                    end 
                end 
            end 

            player2score = player2score + 1
        end
        if (rules("p2miss", i)) then
            ball[i].disabled = true 
            ball[i].x = 2000
            if ballsAlive() == false then 
                if (nuckemodactive == 0) then
                    areanuclear = 0
                    nuclearanimation = 3
                end
                striken = 0
                player1striken = 0
                player2striken = 0
                ballSpeed = ballSet
    
                if (synctype == 0) then
                    paddle_SPEED = ballSet 
                    AI_SPEED = ballSet 
                end
                if (synctype == 1) then
                    paddle_SPEED = ballSpeed 
                    AI_SPEED = ballSpeed 
                end
    
                AI_SPEED = difficultyl 
                
                if (player1score+1 >= ptw) then
                    ball[i]:reset(i)
    
                    sounds["win"]:play()
                    gameState = "done"
                    TEXT = "Player 1 Won"
                else
                    if globalState ~= "nettest" or (globalState == "nettest" and gameState == "2serve") then 
                    gameState = "2serve"
                    serveBot()
    
                    ball[i]:reset(i, 2)
                    end 
    

                end
            end 
            sounds["score"]:play()
            player1score = player1score + 1

        end
    end
end

function powerAvailability()
    if (player1nukescore >= 20 and player1nukescore < 200) then
        potentialstrike1 = 1
        if (((globalState ~= "clienttest" and (love.keyboard.isDown(p1control.super) or doubleclick1 == true)) or (globalState == "clienttest" and lastSentKeyP1 == p1control.super)) ) then
            player1striken = 1
            doubleclick1 = false 
            player1reverbav = 0
        end
    end
    if (player1nukescore >= 140) and timeIsSlow2 == false and timeIsSlow == false and (maxBalls > 1 or (ball[1].dx < 0 and ball[1].x < VIRTUAL_WIDTH/2))then
        player1reverbav = 1
        if ((globalState == "clienttest" and lastSentKeyP1 == p1control.counter) or (globalState ~= "clienttest" and (love.keyboard.isDown(p1control.counter) or hold1 == true))) then
            powerControl(1, "special")
        end
    end
    if (player1nukescore >= 200) then
        potentialnuke1 = 1
        if ((globalState == "clienttest" and (lastSentKeyP1 == p1control.super or doubleclick1 == true))or (globalState ~= "clienttest" and (love.keyboard.isDown(p1control.super) or doubleclick1 == true))) then
            sounds["nuke"]:play()
            doubleclick1 = false 
            if areanuclear == 1 then
                maxspeed = maxspeed + 50
            end
            areanuclear = 1
            potentialstrike1 = 0
            striken = 0
            ballSpeed = ballSpeed * 2
            if (synctype == 0) then
                paddle_SPEED = paddle_SPEED * 2
            end
            if (synctype == 1) then
                paddle_SPEED = ballSpeed 
            end
            if (synctype == 0) then
                AI_SPEED = AI_SPEED * 2.2
            end
            if (synctype == 1) then
                AI_SPEED = ballSpeed * 1.1 / 10
            end
            player1nukescore = 0
            player1reverbav = 0
            potentialnuke1 = 0
        end
    end
    if (player2nukescore >= 20 and player2nukescore < 200) then
        potentialstrike2 = 1
        if (AGAINST_AI == 0) then
            if ((globalState ~= "nettest" and (love.keyboard.isDown(p2control.super) or doubleclick2)) or lastSentKeyClient == p2control.super ) then
                player2striken = 1
                player2reverbav = 0
                doubleclick2 = false 
            end
        end
    end
    if (player2nukescore >= 140) and timeIsSlow == false and timeIsSlow2 == false and (maxBalls > 1 or (ball[1].dx > 0 and ball[1].x > VIRTUAL_WIDTH/2)) then
        player2reverbav = 1
       --print("Available counter, " .. globalState .. tostring(love.keyboard.isDown(p2control.counter)))
        if (globalState ~= "nettest" and (love.keyboard.isDown(p2control.counter) or hold2)) or lastSentKeyClient == p2control.counter then
            sounds["time"]:play()
            player2reverbav = false
            timeIsSlow2 = true
            originalPaddle = paddle_SPEED
            originalSpeed = ballSpeed
            player2reverbav = 0
            potentialnuke2 = 0
            potentialstrike2 = 0
        end
    end
    if (player2nukescore >= 200) then
        potentialnuke2 = 1
        if (((globalState ~= "nettest" and (love.keyboard.isDown(p2control.super) or doubleclick2)) or lastSentKeyClient == p2control.super)) and AGAINST_AI == 0 then
            sounds["nuke"]:play()
            doubleclick2 = false 
            if areanuclear == 1 then
                maxspeed = maxspeed + 50
            end
            potentialstrike2 = 0
            areanuclear = 1
            player2reverbav = 0
            ballSpeed = ballSpeed * 2
            if (synctype == 0) then
                paddle_SPEED = paddle_SPEED * 2
            end
            if (synctype == 1) then
                paddle_SPEED = ballSpeed
            end
            if (synctype == 0) then
                AI_SPEED = AI_SPEED * 2.2
            end
            if (synctype == 1) then
                AI_SPEED = ballSpeed * 1.1 / 10
            end
            player2nukescore = 0
            potentialnuke2 = 0
        end
    end
end

function editor()
    if (gameState == "editor") then
        if debug then 
            --print("Editor is active!")
        end 
        local mx, my = love.mouse.getPosition()
        mx = mx * DIFFERENCE_X
        my = my * DIFFERENCE_Y
        if (love.mouse.isDown(2)) then
            wallbreaker(mx, my)
        end
        if (love.mouse.isDown(3)) then
            table.insert(walls, newWall(mx, my, 10, wall1width))
        end
    end
end

function nuclearDraw()
    love.graphics.setColor(1, 1, 1, 1)
    for i = 1, maxBalls do 
    love.graphics.circle("fill", ball[i].x, ball[i].y, explosionRange * 100, 100)
    end 
    player1.RED, player1.GREEN, player1.BLUE, player2.RED, player2.GREEN, player2.BLUE =
        nuclearanimation / 3,
        nuclearanimation / 3,
        nuclearanimation / 3,
        nuclearanimation / 3,
        nuclearanimation / 3,
        nuclearanimation / 3
    for i = 1, maxBalls do
        love.graphics.setColor(nuclearanimation / 3, nuclearanimation / 3, nuclearanimation / 3, 1)
        ball[i]:render("controlled")
    end
    player1:render()
    player2:render()
end 

function winDraw(who)

    love.graphics.setColor(0, 0, 0, 1)
    if who == 1 then 
        
    love.graphics.circle("fill", player2.x, player2.y, explosionRange * 100, 100)
    print("cicrleexplostion at " .. explosionRange)
    else 
    love.graphics.circle("fill", player1.x, player1.y, explosionRange * 100, 100)
    end 
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(TEXT, 0, 20, VIRTUAL_WIDTH, "center")
end 

function normalDraw()
    if (areanuclear == 1) then
        love.graphics.clear(1, 1, 1, 1)
    else
        love.graphics.clear(40 / 255, 40 / 255, 40 / 255, 1) 
    end
    staticanimator()

    if MAP_TYPE == 1 then 
        love.graphics.setColor(1, 0, 0.20, 1)
        love.graphics.rectangle("fill", VIRTUAL_WIDTH * 0.5, 0, 10, VIRTUAL_HEIGHT * 0.3)
        love.graphics.rectangle("fill", VIRTUAL_WIDTH * 0.5, VIRTUAL_HEIGHT * 0.7, 10, VIRTUAL_HEIGHT * 0.3)
        love.graphics.setColor(1, 1, 1, 1)
    end 
    if MAP_TYPE == 2 then 
        for i, wall in ipairs(walls) do
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle("fill", wall.wallx, wall.wally, 10, wall.wallheight)
        end
    end

    pongDraw()
    love.graphics.setFont(smallfont)
    for i = 1, maxBalls do
        if areanuclear == 1 then
            --love.window.setTitle('rendering black')
            ball[i]:render("black")
        else
            --love.window.setTitle('rendering white')
            ball[i]:render(" ")
        end
    end
    
end 
function pongDraw()
    --print("Drawing classic pong")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(TEXT, 0, 20, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(smallfont)
    love.graphics.setFont(scorefont)
    if (areanuclear == 1) then 
        love.graphics.setColor(0, 0, 0, 1)
    end
    love.graphics.print(tostring(math.floor(player1score)), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 12)
    love.graphics.print(tostring(math.floor(player2score)), VIRTUAL_WIDTH / 2 + 400, VIRTUAL_HEIGHT / 12)
    love.graphics.setColor(1, 1, 1, 1)
    displayPoints()
    player1:render()
    player2:render()

end
function practiceDraw()
    player1:render()
    love.graphics.rectangle("fill", VIRTUAL_WIDTH-10, 0, 10, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(TEXT, 0, 20, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(smallfont)
    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(math.floor(player1score)), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 12)
end
function menuDraw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(TEXT, 0, 20, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(smallfont)
    love.graphics.printf(updateTEXT, 0, VIRTUAL_HEIGHT * 0.95, VIRTUAL_WIDTH, "left")
    if MAP_TYPE == 1 then 
        love.graphics.setColor(1, 0, 0.20, 1)
        love.graphics.rectangle("fill", VIRTUAL_WIDTH * 0.5, 0, 10, VIRTUAL_HEIGHT * 0.3)
        love.graphics.rectangle("fill", VIRTUAL_WIDTH * 0.5, VIRTUAL_HEIGHT * 0.7, 10, VIRTUAL_HEIGHT * 0.3)
        love.graphics.setColor(1, 1, 1, 1)
    end 
    if MAP_TYPE == 2 then 
        for i, wall in ipairs(walls) do
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle("fill", wall.wallx, wall.wally, 10, wall.wallheight)
        end
    end
    player1:render()
    player2:render()
    ball[1]:render("controlled")
    if gameState == "touchcontrols" then
        if doubleclick1 or doubleclick2 then 
            gameState = "menu"
            globalState = "menu"
            resettinggenius()
        end
        love.graphics.setFont(smallfont)
        love.graphics.printf("The green zones are for moving up and down, double tap the red zone for special attack or to start the serve.", 10, 150, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Swipe from red to green for stopping time", 10, 450, VIRTUAL_WIDTH, "center")
    end
    if gameState == "windowsettings" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, settings, sounds, "right")
        love.keyboard.mouseisReleased = false
    end
    if gameState == "editor" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, editorpicks, sounds, "right")
        love.keyboard.mouseisReleased = false
    end
    if gameState == "speedSettings" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, speedParameters, sounds, "middle")
        love.keyboard.mouseisReleased = false
    end
    if gameState == "controlSettings" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, controlSettings, sounds, "control")
        love.keyboard.mouseisReleased = false
    end
    if gameState == "gameMode" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, modeSelectorButtons, sounds, "middle")
        love.keyboard.mouseisReleased = false
    end
    if gameState == "chooseIP" then
        IPselect = {}
        if isAndroid then 
        table.insert(
            IPselect,
            newButton(
                IPnew,
                function()
                    love.keyboard.setTextInput( true, 0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT/3)
                end
            )
        )
        end 
        if not isAndroid then 
        table.insert(
            IPselect,
            newButton(
                "LANHost",
                function()
                    globalState = "selfhost"
                    AGAINST_AI = 0 
                    gameState = "1serve"
                    ball[1]:reset(1, 1)
                    player2.dy = 0 
                end
            )
        )
        end 
        table.insert(
            IPselect,
            newButton(
                "Check Server",
                function()
                    IP = IPnew
                    counter = 0
                end
            )
        )
        if status == "offline" then 
            animateConnection()
        elseif status == "nettest" and IP == IPnew then 
            table.insert(
                IPselect,
                newButton(
                    "Connect as Host",
                    function()
                        resettinggenius()
                        globalState = "nettest"
                        AGAINST_AI = 0 
                        gameState = "1serve"
                        ball[1]:reset(1, 1)
                        player2.dy = 0 
                    end
                )
            )
            
        elseif status == "clienttest" and IP == IPnew  then 
            table.insert(
                IPselect,
                newButton(
                    "Connect as Guest",
                    function()
                        resettinggenius()
                        globalState = "clienttest"
                        AGAINST_AI = 0 
                        gameState = "1serve"
                        ball[1]:reset(1, 1)
                        player2.dy = 0 
                    end
                )
            )
        elseif status == "full" then 
            love.graphics.printf("SERVER FULL", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
        end
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, IPselect, sounds, "middle")
        love.keyboard.mouseisReleased = false
        if not isAndroid then 
        love.graphics.printf(IPnew, 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, "center")
        end 
        love.keyboard.mouseisReleased = false
    end
    if gameState == "menu" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, buttons, sounds, "middle")
        love.keyboard.mouseisReleased = false
    end
    if gameState == "difficulty" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, difbuttons, sounds, "middle")
        love.keyboard.mouseisReleased = false
    end
    if gameState == "multiMode" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, playerCountButtons, sounds, "middle")
        love.keyboard.mouseisReleased = false
    end
    if gameState == "prdiff" then
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, pracdiff, sounds, "playercount")
        love.keyboard.mouseisReleased = false
    end
    if gameState == 'start' then 
        love.graphics.push()
        love.graphics.translate(VIRTUAL_WIDTH * 0.4, VIRTUAL_HEIGHT * 0.5)
        love.graphics.rotate(rotation)
        love.graphics.setFont(smallfont)
        love.graphics.setColor(200/255, 200/255, 200/255, 1)
        if isAndroid then 
            love.graphics.print("Tap to Start", WINDOW_WIDTH / -10, VIRTUAL_HEIGHT / 8)
        else
            love.graphics.print("Press Enter to Start", WINDOW_WIDTH / -10, VIRTUAL_HEIGHT / 8)
        end 
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.pop()
    end
end
function baseDraw()
    love.graphics.clear(40 / 255, 40 / 255, 40 / 255, 1) 
    if shakeDuration > t then 
            
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(dx, dy)
    end
    if globalState == 'menu' then 
       --print("Drawing menuDraw")
        if gameState == 'animation' then 
            
           --print("Drawing animation")
            intro()
        end
        if gameState ~= 'animation' then
           --print("Drawing notanimtaion") 
            love.graphics.setFont(scorefont)
            menuDraw()
        end
    end
    if globalState == 'base' or globalState == 'reverse' or globalState == 'nettest' or globalState == 'clienttest' then 

        love.graphics.setFont(smallfont)
        if gameState == 'nuclearExplosion' then 
            nuclearDraw()
        end 

        if gameState == 'play' or gameState == '1serve' or gameState == '2serve' or gameState == 'done' then 
          --print("Drawing normally")
            normalDraw()
        end 
        if gameState == 'done' and player1score > player2score then 
            winDraw(1)
        elseif gameState == 'done' and player1score < player2score then 
            winDraw(2)
        end
    end 
    if paused then 
    mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, pauseButtons, sounds, "middle")
    love.keyboard.mouseisReleased = false
    end 
    if gameState == "done" then 
        mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, doneButtons, sounds, "middle")
        love.keyboard.mouseisReleased = false
    end
end 
function androidDraw()
--HOME BUTTON HERE
mymenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, androidButtons, sounds, "android")
if showTouchControls then 
    love.graphics.setColor(15/255, 255/255, 15/255, 0.5)
    love.graphics.rectangle("fill", 0, 0, 100, VIRTUAL_HEIGHT)
    love.graphics.setColor(15/255, 255/255, 15/255, 0.5)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH-100, 0, 50, VIRTUAL_HEIGHT)
    love.graphics.setColor(255/255, 15/255, 15/255, 0.5)
    love.graphics.rectangle("fill", 100, 0, VIRTUAL_WIDTH/2-100, VIRTUAL_HEIGHT)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/2, 0, VIRTUAL_WIDTH/2-100, VIRTUAL_HEIGHT)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH/2-5, 0, 10, VIRTUAL_HEIGHT)
end 
end 
function renderEditor()
    if not blockinput then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", mx, my, 10, wall1width)
        love.graphics.setColor(1, 1, 1, 1)
    end
    for i, wall in ipairs(walls) do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", wall.wallx, wall.wally, 10, wall.wallheight)
    end
end

function intro()
    love.graphics.setColor(255, 255, 255, light / 255)
    love.graphics.draw(image, 0, 0)
end


function displayPoints()
    love.graphics.setFont(smallfont)
    if areanuclear == 1 then 
        love.graphics.setColor(0,0,0,1)
    end
    if (potentialstrike1 == 1 and potentialnuke1 == 0 and player1reverbav == 0) then --FLAG: AVAILABLE SUPER
        if (player1striken == 0) then
            love.graphics.print(
                tostring(math.floor(player1nukescore) .. "[" .. p1control.super .. "]"),
                VIRTUAL_WIDTH / 2 - 500,
                VIRTUAL_HEIGHT / 60
            )
        else
            love.graphics.print(tostring("READY"), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 60)
        end
    elseif (player1reverbav == 1 and potentialnuke1 == 0 ) then
        love.graphics.print(
            tostring(
                math.floor(player1nukescore) .. "[" .. p1control.super .. "]" .. " [" .. p1control.counter .. "]"
            ),
            VIRTUAL_WIDTH / 2 - 500,
            VIRTUAL_HEIGHT / 60
        )
    elseif (potentialnuke1 == 1) then
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.print(
            tostring(
                math.floor(player1nukescore) .. "[" .. p1control.super .. "]" .. " [" .. p1control.counter .. "]"
            ),
            VIRTUAL_WIDTH / 2 - 500,
            VIRTUAL_HEIGHT / 60
        )
        love.graphics.setColor(255, 255, 255, 255)
    elseif (potentialnuke1 == 1) then
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.print(
            tostring(
                math.floor(player1nukescore) .. "[" .. p1control.super .. "]" 
            ),
            VIRTUAL_WIDTH / 2 - 500,
            VIRTUAL_HEIGHT / 60
        )
        love.graphics.setColor(255, 255, 255, 255)
    else
        love.graphics.print(tostring(math.floor(player1nukescore)), VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 60)
    end
    if (potentialstrike2 == 1 and player2reverbav == 0) then
        if (player2striken == 0) then
            love.graphics.print(
                tostring(math.floor(player2nukescore) .. "[" .. p2control.super .. "]"),
                VIRTUAL_WIDTH / 2 + 430,
                VIRTUAL_HEIGHT / 60
            )
        else
            love.graphics.print(tostring("READY"), VIRTUAL_WIDTH / 2 + 430, VIRTUAL_HEIGHT / 60)
        end
    elseif (potentialnuke2 == 1) then
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.print(
            tostring(math.floor(player2nukescore) .. "[" .. p2control.super .. "] [" .. p2control.counter .. "]"),
            VIRTUAL_WIDTH / 2 + 400,
            VIRTUAL_HEIGHT / 60
        )
        love.graphics.setColor(255, 255, 255, 255)
    elseif (potentialnuke2 == 1 and maxBalls > 1) then 
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.print(
            tostring(math.floor(player2nukescore) .. "[" .. p2control.super .. "]"),
            VIRTUAL_WIDTH / 2 + 430,
            VIRTUAL_HEIGHT / 60
        )
        love.graphics.setColor(255, 255, 255, 255)       
    elseif (player2reverbav == 1 and potentialnuke2 == 0 ) then
        love.graphics.print(
            tostring(math.floor(player2nukescore) .. "[" .. p2control.super .. "] [" .. p2control.counter .. "]"),
            VIRTUAL_WIDTH / 2 + 400,
            VIRTUAL_HEIGHT / 60
        )
    else
        love.graphics.print(tostring(math.floor(player2nukescore)), VIRTUAL_WIDTH / 2 + 430, VIRTUAL_HEIGHT / 60)
    end
end

function hitIdentifier()
        if (gameMode == "practice") then
            MAP_TYPE = 0
            if ball[i].x > VIRTUAL_WIDTH * 0.99 then
                soundtype = love.math.random(1, 5)
                sounds["wallhit"]:setPitch(ballSpeed / 250)
                sounds["wallhit"]:play()
                if (ball[i].dx > 0) then
                    ball[i].x = ball[i].x - 20
                else
                    ball[i].x = ball[i].x + 20
                end
                ball[i].dx = -ball[i].dx
            end
        end
        if (MAP_TYPE == 1) then
            if
                ball[i].y < VIRTUAL_HEIGHT * 0.3 and ball[i].x > VIRTUAL_WIDTH * 0.5 and
                    ball[i].x < VIRTUAL_WIDTH * 0.5 + 5
                then
                soundtype = love.math.random(1, 5)
                sounds["wallhit"]:setPitch(ballSpeed / 250)
                sounds["wallhit"]:play()
                if (ball[i].dx > 0) then
                    ball[i].x = ball[i].x - 20
                else
                    ball[i].x = ball[i].x + 20
                end
                ball[i].dx = -ball[i].dx
            end
            if
                ball[i].y > VIRTUAL_HEIGHT * 0.7 and ball[i].x > VIRTUAL_WIDTH * 0.5 and
                    ball[i].x < VIRTUAL_WIDTH * 0.5 + 5
                then
                soundtype = love.math.random(1, 5)
                sounds["wallhit"]:setPitch(ballSpeed / 250)
                sounds["wallhit"]:play()
                if (ball[i].dx > 0) then
                    ball[i].x = ball[i].x - 20
                else
                    ball[i].x = ball[i].x + 20
                end
                ball[i].dx = -ball[i].dx
            end
        end
        if (MAP_TYPE == 2) then 
            for i, wall in ipairs(walls) do
                if
                    (ball[1].y > wall.wally and ball[1].y < wall.wally + wall.wallheight and
                        ball[1].x > wall.wallx - ballSpeed / 200 and
                        ball[1].x < wall.wallx + 10 + ballSpeed / 200)
                then
                    controllerSer()
                    soundtype = love.math.random(1, 5)
                    sounds["wallhit"]:setPitch(ballSpeed / 250)
                    sounds["wallhit"]:play()
                    if (ball[1].dx > 0) then
                        ball[1].x = ball[1].x - 1
                    else
                        ball[1].x = ball[1].x + 1
                    end
                    ball[1].dx = -ball[1].dx
                elseif
                    (ball[1].y > wall.wally - 15 and ball[1].y < wall.wally + wall.wallheight + 10 and
                        ball[1].x > wall.wallx and
                        ball[1].x < wall.wallx + 10)
                then
                    controllerSer()
                    soundtype = love.math.random(1, 5)
                    sounds["wallhit"]:setPitch(ballSpeed / 250)
                    sounds["wallhit"]:play()
                    if (ball[1].dy > 0) then
                        ball[1].y = ball[1].y - 1
                    else
                        ball[1].y = ball[1].y + 1
                    end
                    ball[1].dy = -ball[1].dy
                end
            end
        end
end 
function rules(query, i)
    if query == "p1hit" then 
        if gameMode == "normal" then  
        return ball[i]:collides(player1) 
        elseif gameMode == "reversegame" then 
        return ball[i].x < 0 and ball[i].disabled == false 
        end 
    end 
    if query == "p2hit" then 
        if gameMode == "normal" then 
            return ball[i]:collides(player2) 
        elseif gameMode == "reversegame" then 
            return ball[i].x > VIRTUAL_WIDTH-10 and ball[i].disabled == false 
        end
    end 
    if query == "p1miss" then 
        if gameMode == "reversegame" then  
            return ball[i]:collides(player1)
        elseif gameMode == "normal" then 
            return ball[i].x < -10 and ball[i].disabled == false 
        end
    end  
    if query == "p2miss" then 
        if gameMode == "reversegame" then 
            return ball[i]:collides(player2) 
        elseif gameMode == "normal" then 
            return ball[i].x > VIRTUAL_WIDTH and ball[i].disabled == false 
        end
    end 
end 
function clientsBaseGame(dt)
    if gameMode == "reverse" then 
        reversegame(dt)
    end 
    if player1nukescore > 300 then 
        player1nukescore = 300 
    end 
    if player2nukescore > 300 then 
        player2nukescore = 300 
    end
    speedControl()
    balancer()
    
    if t < shakeDuration then
        t = t + dt
    end
    
    if (lastSentKeyP1 == p1control.up) then
        player1.dy = (paddle_SPEED + p2bonus) * -1
       --print("moving player1 up")
    elseif (lastSentKeyP1 == p1control.down) then
        player1.dy = paddle_SPEED + p2bonus
       --print("moving player1 down")
    else
        player1.dy = 0
       ----print("stopping player")
    end
    if ((love.keyboard.isDown(p2control.up) or sectortouched(1))) then
        player2.dy = (paddle_SPEED + p2bonus) * -1
    elseif ((love.keyboard.isDown(p2control.down)) or sectortouched(4)) then
        player2.dy = paddle_SPEED + p2bonus
    else
        player2.dy = 0
    end
   --print("T = " .. tostring(t))
    serveBot()
    if gameState == 'play' then 
        if (AGAINST_AI == 1) then
            AI(player2, maxBalls, AI_LEVEL)
        end
       --print(areanuclear .. striken .. player1score .. player2score)
        for i = 1, maxBalls do
            if rules("p1hit", i) then
                
                if (areanuclear == 0 and striken == 1 and (player1score > ptw*0.8 or player2score > ptw*0.8)) then
                   --print("Calling animation")
                    superanimator("tensehit", 1)
                   --print("AREA NUCLEAR?" .. areanuclear)
                end
                if gameMode == "practice" then
                    player1score = player1score + 1
                end
                t = 0
                if (ballSpeed > 200) then
                    shakeMagnitude = ballSpeed / 200
                else
                    shakeMagnitude = 0
                end
                shakeDuration = 1
                randomtext = love.math.random(1, #textphrases)
                TEXT = textphrases[randomtext]
                soundtype = love.math.random(1, 1.2)

                if (player1striken == 1) then
                    TEXT = "PLAYER 1 STRIKES"
                    ballSpeed = ballSpeed + player1nukescore
                    potentialnuke1 = 0
                    player1striken = 0
                    player1nukescore = 0
                    potentialstrike1 = 0
                    striken = 1
                    if areanuclear == 0 then
                        sounds["striking"]:setPitch(ballSpeed / 250)
                        sounds["striking"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                    if areanuclear == 0 then 
                    superanimator("tensehit", 1)
                    end 
                else
                    if areanuclear == 0 then
                        sounds["beep"]:setPitch(ballSpeed / 250)
                        sounds["beep"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                end
                if (striken == 1) then
                    
                    player1nukescore = player1nukescore * 1.5
                    if (synctype == 0) then
                        paddle_SPEED = paddle_SPEED * 1.10
                    elseif (synctype == 1) then
                        paddle_SPEED = ballSpeed
                    end
                    if (synctype == 0) then
                        AI_SPEED = AI_SPEED * 1.10
                    end
                    if (synctype == 1) then
                        AI_SPEED = ballSpeed * 1.1 / 10
                    end
                    ballSpeed = ballSpeed * 1.10
                end
                player1nukescore = player1nukescore + 10
                ball[i].dx = -ball[i].dx
                ball[i].x = player1.x + 30
            end
            if rules("p2hit", i) then
                --ameState = 'quickanim'
                t = 0
                shakeDuration = 1
                if
                    (areanuclear == 0 and
                        (striken == 1 and (player1score > ptw*0.8 or player2score > ptw*0.8)))
                 then
                   --print("AREA NUCLEAR?" .. areanuclear)
                    superanimator("tensehit", 2)
                end
                if (ballSpeed > 200) then
                    shakeMagnitude = ballSpeed / 200
                else
                    shakeMagnitude = 0
                end
                randomtext = love.math.random(1, #textphrases)
                TEXT = textphrases[randomtext]
                soundtype = love.math.random(1, 1.2)

                if (player2striken == 1) then
                    TEXT = "PLAYER 2 STRIKES"
                    ballSpeed = ballSpeed + player2nukescore
                    striken = 1
                    player2striken = 0
                    potentialnuke2 = 0
                    player2nukescore = 0
                    potentialstrike2 = 0
                   --print("AREA NUCLEAR?" .. areanuclear)
                    if areanuclear == 0 then 
                    superanimator("tensehit", 2)
                    end
                    if areanuclear == 0 then
                        sounds["striking"]:setPitch(ballSpeed / 250)
                        sounds["striking"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                elseif (striken == 1) then
                    
                    player2nukescore = player2nukescore * 1.5
                    if (synctype == 0) then
                        paddle_SPEED = paddle_SPEED * 1.10
                    end
                    if (synctype == 1) then
                        paddle_SPEED = ballSpeed
                    end
                    if (synctype == 0) then
                        AI_SPEED = AI_SPEED * 1.10
                    end
                    if (synctype == 1) then
                        AI_SPEED = ballSpeed * 1.1 / 10
                    end
                    ballSpeed = ballSpeed * 1.10
                    if areanuclear == 0 then
                        sounds["beep"]:setPitch(ballSpeed / 250)
                        sounds["beep"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                else
                    if areanuclear == 0 then
                        sounds["beep"]:setPitch(ballSpeed / 250)
                        sounds["beep"]:play()
                    else
                        sounds["nuclearhit"]:setPitch(1)
                        sounds["nuclearhit"]:play()
                    end
                end
                player2nukescore = player2nukescore + 10
                ball[i].dx = -ball[i].dx
                ball[i].x = player2.x - 30
                if ((love.keyboard.isDown(p2control.up)) or sectortouched(1)) then
                    select = math.random(1, 5)
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
                elseif (love.keyboard.isDown(p2control.down) or sectortouched(4))then
                    select = math.random(1, 5)
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
                        select = math.random(1, 5)
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
                        select = math.random(1, 5)
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
            hitIdentifier()
            if ball[i].y <= 0 then
                soundtype = love.math.random(1, 5)
                sounds["wallhit"]:setPitch(ballSpeed / 250)
                sounds["wallhit"]:play()
                ball[i].y = 0
                ball[i].dy = -ball[i].dy
            end

            -- -4 to account for the ball's size
            if ball[i].y >= VIRTUAL_HEIGHT - 40 then
                soundtype = love.math.random(1, 5)
                sounds["wallhit"]:setPitch(ballSpeed / 250)
                sounds["wallhit"]:play()
                ball[i].y = VIRTUAL_HEIGHT - 40
                ball[i].dy = -ball[i].dy
               
            end
            --love.window.setTitle('Trying to update the ball')
            if timeIsSlow then
                if ballSpeed > originalSpeed / 3 then
                    paddle_SPEED = 300
                    ballSpeed = ballSpeed / (1 + (dt * 2))
                end
                player1nukescore = player1nukescore - (dt * 50)
                if player1nukescore < 1 or ball[1].dx > 0 then
                    timeIsSlow = false
                    player1reverbav = false
                    ballSpeed = originalSpeed
                    sounds["time"]:stop()
                    paddle_SPEED = originalPaddle
                end
            end
            if timeIsSlow2 then
                if ballSpeed > originalSpeed / 3 then
                    ballSpeed = ballSpeed / (1 + (dt * 2))
                end
                player2nukescore = player2nukescore - (dt * 50)
                if player2nukescore < 1 or ball[1].dx < 0 then
                    paddle_SPEED = 300
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
    goalManager()
    powerAvailability()
    player1:update(dt)
    player2:update(dt)
end 

function animateConnection()
    if GetIPType(IP) ~= 1 then 
        love.graphics.printf("WRONG SYNTAX", 0, VIRTUAL_HEIGHT-80, VIRTUAL_WIDTH, "center")
    else 
    counter = counter + 1 / love.timer.getFPS() 
    if counter < 0.8 then 
    love.graphics.printf("TRYING TO CONNECT.", 0, VIRTUAL_HEIGHT-80, VIRTUAL_WIDTH, "center")
    elseif counter < 1.6 then 
        love.graphics.printf("TRYING TO CONNECT..", 0, VIRTUAL_HEIGHT-80, VIRTUAL_WIDTH, "center")    
    elseif counter < 2.4 then 
        love.graphics.printf("TRYING TO CONNECT...", 0, VIRTUAL_HEIGHT-80, VIRTUAL_WIDTH, "center")
    else 
        love.graphics.printf("NO CONNECTION!", 0, VIRTUAL_HEIGHT-80, VIRTUAL_WIDTH, "center")
    end
end
end 
function GetIPType(ip)
    -- must pass in a string value
    if ip == nil or type(ip) ~= "string" then
        return 0
    end

    -- check for format 1.11.111.111 for ipv4
    local chunks = {ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")}
    if (#chunks == 4) then
        for _,v in pairs(chunks) do
            if (tonumber(v) < 0 or tonumber(v) > 255) then
                return 0
            end
        end
        return 1
    else
        return 0
    end

    -- check for ipv6 format, should be 8 'chunks' of numbers/letters
    local _, chunks = ip:gsub("[%a%d]+%:?", "")
    if chunks == 8 then
        return 2
    end

    -- if we get here, assume we've been given a random string
    return 3
end

function menuDemo(dt)
    paddle_SPEED = 200
    ballSpeed = 200
    if ball[1].dx > 0 then
    AI(player2, maxBalls, 1300)
    player1.goal = 360
    elseif ball[1].dx < 0 then 
    AI(player1, maxBalls, 1300)
    player2.goal = 360
    end 
    print(neededTarget, neededTarget1)
   --print("menu demo active")
    ball[1]:update(dt)
    player1:update(dt)
    player2:update(dt)    
    if ball[1].x < player1.x+15 then 
        player1.y = ball[1].y-player1.height  
    end 
    if ball[1].x > player2.x-15 then 
        player2.y = ball[1].y-player2.height 
    end 
    if ball[1].x >= player2.x-7 then
        sounds["beep"]:setPitch(ballSpeed / 250)
        sounds["beep"]:play()
        select = math.random(1, 2)
    if ball[1].dy < 0 then
        select = math.random(1, 5)
        if select == 1 then
            ball[1].dy = -1
        elseif select == 2 then
            ball[1].dy = -1.2
        elseif select == 3 then
            ball[1].dy = -1.5
        elseif select == 4 then
            ball[1].dy = -1.8
        elseif select == 5 then
            ball[1].dy = -2
        end
    else
        select = math.random(1, 5)
        if select == 1 then
            ball[1].dy = 1
        elseif select == 2 then
            ball[1].dy = 1.2
        elseif select == 3 then
            ball[1].dy = 1.5
        elseif select == 4 then
            ball[1].dy = 1.8
        elseif select == 5 then
            ball[1].dy = 2
        end
    end
        ball[1].x = player2.x-8
        ball[1].dx = -ball[1].dx
    end 
    if ball[1].x <= player1.x+7 then
        sounds["beep"]:setPitch(ballSpeed / 250)
        sounds["beep"]:play()
        select = math.random(1, 2)
    if ball[1].dy < 0 then
        select = math.random(1, 5)
        if select == 1 then
            ball[1].dy = -1
        elseif select == 2 then
            ball[1].dy = -1.2
        elseif select == 3 then
            ball[1].dy = -1.5
        elseif select == 4 then
            ball[1].dy = -1.8
        elseif select == 5 then
            ball[1].dy = -2
        end
    else
        select = math.random(1, 5)
        if select == 1 then
            ball[1].dy = 1
        elseif select == 2 then
            ball[1].dy = 1.2
        elseif select == 3 then
            ball[1].dy = 1.5
        elseif select == 4 then
            ball[1].dy = 1.8
        elseif select == 5 then
            ball[1].dy = 2
        end
    end
        ball[1].x = player1.x+8
        ball[1].dx = -ball[1].dx
    end
    
    if ball[1].y <= 0 then
        soundtype = love.math.random(1, 5)
        sounds["wallhit"]:setPitch(ballSpeed / 250)
        sounds["wallhit"]:play()
        ball[1].y = 0
        ball[1].dy = -ball[1].dy
    end

    -- -4 to account for the ball's size
    if ball[1].y >= VIRTUAL_HEIGHT - 40 then
        soundtype = love.math.random(1, 5)
        sounds["wallhit"]:setPitch(ballSpeed / 250)
        sounds["wallhit"]:play()
        ball[1].y = VIRTUAL_HEIGHT - 40
        ball[1].dy = -ball[1].dy
       
    end
end 