function basegame(dt) 
    if player1nukescore > 300 then 
        player1nukescore = 300 
    end 
    if player2nukescore > 300 then 
        player2nukescore = 300 
    end
    speedControl()
    balancer()
    musicController('norm', 1)
    if t < shakeDuration then
        t = t + dt
    end
    if gameState == 'play' then 
        if (AGAINST_AI == 1) then
            for i = 1, maxBalls do
                if (ball[i].y - player2.y >= 50 and player2.x - ball[i].x < AI_LEVEL) then
                    player2.dy = AI_SPEED
                elseif (player2.y - ball[i].y >= -20 and player2.x - ball[i].x < AI_LEVEL) then
                    player2.dy = -AI_SPEED
                else
                    player2.dy = 0
                end
                if
                    difficultyl == 350 and player2reverbav == true and VIRTUAL_WIDTH - ball[i].x < 90 and
                        math.abs(ball[i].y - player2.y) > 150
                 then
                    sounds["time"]:play()
                    player2reverbav = false
                    timeIsSlow2 = true
                    originalPaddle = paddle_SPEED
                    originalSpeed = ballSpeed
                    player2reverbav = 0
                    potentialnuke2 = 0
                    potentialstrike2 = 0
                end
    
                if (player2nukescore > AI_STRIKEMOD and striken == 0) then
                    player2striken = 1
                elseif (player2nukescore > AI_NUKEMOD and striken == 1) then
                    if (areanuclear == 1) then
                        maxspeed = maxspeed + 50
                    end
                    sounds["nuke"]:play()
                    potentialstrike2 = 0
                    areanuclear = 1
                    ballSpeed = ballSpeed * 2
                    if (synctype == 0) then
                        paddle_SPEED = paddle_SPEED * 2
                    end
                    if (synctype == 1) then
                        paddle_SPEED = ballSpeed / 10
                    end
                    if (synctype == 0) then
                        AI_SPEED = AI_SPEED * 2.2
                    end
                    if (synctype == 1) then
                        AI_SPEED = ballSpeed * 1.1 / 10
                    end
                    player2nukescore = 0
                    player2reverbav = 0
                    potentialnuke2 = 0
                end
            end
        end
        if (love.keyboard.isDown(p1control.up)) then
            player1.dy = (paddle_SPEED + p1bonus) * -1
        elseif (love.keyboard.isDown(p1control.down)) then
            player1.dy = paddle_SPEED + p1bonus
        else
            player1.dy = 0
        end
        if (AGAINST_AI == 0) then
            if (love.keyboard.isDown(p2control.up)) then
                player2.dy = (paddle_SPEED + p2bonus) * -1
            elseif (love.keyboard.isDown(p2control.down)) then
                player2.dy = paddle_SPEED + p2bonus
            else
                player2.dy = 0
            end
        end
        for i = 1, maxBalls do
            if ball[i]:collides(player1) then
                if (areanuclear == 0 and ((player1striken or player2striken) and (player1score > 9 or player2score > 9))) then
                    print("Calling animation")
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
                    player1nukescore = player1nukescore * 1.2
                    if (synctype == 0) then
                        paddle_SPEED = paddle_SPEED * 1.10
                    elseif (synctype == 1) then
                        paddle_SPEED = ballSpeed / 10
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

                if (love.keyboard.isDown(p1control.up)) then
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
                elseif love.keyboard.isDown(p1control.down) then
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
            if ball[i]:collides(player2) then
                --ameState = 'quickanim'
                t = 0
                shakeDuration = 1
                if
                    (areanuclear == 0 and
                        ((player1striken or player2striken) and (player1score > 9 or player2score > 9)))
                 then
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
                        paddle_SPEED = ballSpeed / 10
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

                if (love.keyboard.isDown(p2control.up) or AI_SPEED < 0) then
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
                elseif love.keyboard.isDown(p2control.down) or AI_SPEED > 0 then
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
                    paddle_SPEED = 30
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
    goalManager()
    powerAvailability()
    player1:update(dt)
    player2:update(dt)
end
function menumode(dt) 
    if (gameState == "menu") then
        updateTEXT = "0.7.1 Chalkboard Update"
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
        if (ball[i].x < 0 - ballSpeed * 0.5) then
            if (gameMode ~= "practice") then
                sounds["score"]:play()
            end
            if (nuckemodactive == 0) then
                areanuclear = 0
                nuclearanimation = 3
            end
            striken = 0
            player1striken = 0
            player2striken = 0
            ballSpeed = ballSet
            if (synctype == 0) then
                paddle_SPEED = ballSet / 10
            end
            if (synctype == 1) then
                paddle_SPEED = ballSpeed / 10
            end

            AI_SPEED = difficultyl / 10
            player2score = player2score + 1
            if (player2score == ptw and gameMode ~= "practice") then
                for i = 1, maxBalls do
                    ball[i]:reset(i)
                end
                sounds["win"]:play()
                gameState = "done"
                TEXT = "Player 2 Won!"
            else
                gameState = "1serve"
                serveBot()
                for i = 1, maxBalls do
                    ball[i]:reset(i)
                end
            end
        end
        if (ball[i].x > VIRTUAL_WIDTH + ballSpeed * 0.5) then
            sounds["score"]:play()
            if (nuckemodactive == 0) then
                areanuclear = 0
                nuclearanimation = 3
            end
            striken = 0
            player1striken = 0
            player2striken = 0
            ballSpeed = ballSet

            if (synctype == 0) then
                paddle_SPEED = ballSet / 10
                AI_SPEED = ballSet / 10
            end
            if (synctype == 1) then
                paddle_SPEED = ballSpeed / 10
                AI_SPEED = ballSpeed / 10
            end

            AI_SPEED = difficultyl / 10
            player1score = player1score + 1
            if (player1score == ptw) then
                ball[i]:reset(i)

                sounds["win"]:play()
                gameState = "done"
                TEXT = "Player 1 Won!"
            else
                gameState = "2serve"

                serveBot()

                ball[i]:reset(i)
            end
        end
    end
end

function powerAvailability()
    if (player1nukescore >= 20 and player1nukescore < 140) then
        potentialstrike1 = 1
        if (love.keyboard.isDown(p1control.super)) then
            player1striken = 1
            player1reverbav = 0
        end
    end
    if (player1nukescore >= 140) and timeIsSlow2 == false and timeIsSlow == false and maxBalls == 1 and ball[1].x < VIRTUAL_WIDTH / 2 then
        player1reverbav = 1
        if love.keyboard.isDown(p1control.counter) then
            powerControl(1, "special")
        end
    end
    if (player1nukescore >= 200) then
        potentialnuke1 = 1
        if (love.keyboard.isDown(p1control.super)) then
            sounds["nuke"]:play()
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
                paddle_SPEED = ballSpeed / 10
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
    if (player2nukescore >= 20 and player2nukescore <= 140) then
        potentialstrike2 = 1
        if (AGAINST_AI == 0) then
            if (love.keyboard.isDown(p2control.super)) then
                player2striken = 1
                player2reverbav = 0
            end
        end
    end
    if (player2nukescore >= 140) and timeIsSlow == false and timeIsSlow2 == false and maxBalls == 1 and ball[1].x > VIRTUAL_WIDTH / 2 then
        player2reverbav = 1
        if love.keyboard.isDown(p2control.counter) then
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
        if (love.keyboard.isDown(p2control.super) and AGAINST_AI == 0) then
            sounds["nuke"]:play()
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
                paddle_SPEED = ballSpeed / 10
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
        local mx, my = love.mouse.getPosition()
        mx = mx * DIFFERENCE_X
        my = my * DIFFERENCE_Y
        if not blockinput then
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.rectangle("fill", mx, my, 10, wall1width)
            love.graphics.setColor(1, 1, 1, 1)
        end
        if (love.mouse.isDown(2)) then
            wallbreaker(mx, my)
        end
        if (love.mouse.isDown(3)) then
            table.insert(walls, newWall(mx, my, 10, wall1width))
        end

        for i, wall in ipairs(walls) do
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle("fill", wall.wallx, wall.wally, 10, wall.wallheight)
        end
    end
end