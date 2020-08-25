function AI(target, ballCnt, diff)
    currentTarget = evaluateClosestBall(target);
   --print("CLOSEST TARGET IS " .. currentTarget)
    if diff < 1200 then 
       --print ("Normal targeting ".. currentTarget .. " " .. target.x - ball[currentTarget].x .. " " .. ball[currentTarget].y - target.y)
        if (ball[currentTarget].y - target.y >= target.height and target.x - ball[currentTarget].x < diff) then
            target.dy = AI_SPEED
        elseif (target.y - ball[currentTarget].y >= -target.height/2 and target.x - ball[currentTarget].x < diff) then
            target.dy = -AI_SPEED
        else
            target.dy = 0
        end
    else 
       --print("Complex targeting")
        
            neededTarget = predictBall(ball[currentTarget], target.x)
            if neededTarget ~= -1 then 
           --print("Calculated target = " .. neededTarget)
            if (target.y - neededTarget >= -target.height/2) then 
                target.dy = -AI_SPEED
            elseif (neededTarget - target.y >= target.height*0.9) then 
                target.dy = AI_SPEED
            else
                target.dy = 0
            end 
        end
    end 
    if
        difficultyl == 350 and player2reverbav == true and VIRTUAL_WIDTH - ball[currentTarget].x < 90 and
            math.abs(ball[currentTarget].y - targe.y) > 150
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
function evaluateClosestBall(target)
    local ans = 0
    local min = 99999;
    for i = 1, maxBalls do 
        if math.abs(target.x - ball[i].x ) < min then 
            min = math.abs(target.x - ball[i].x)
            ans = i 
        end 
    end 
    return ans
end 
function predictBall(target, px)
   --print("BALLSTATS:" .. target.x .. " " .. target.y)
    if target.dx > 0 then 
        local ans = recursiveCalculations(px, target.x, target.y, target.dx, target.dy, 1)
        return ans
    else 
       --print("GO TO CENTER!!")
        return VIRTUAL_HEIGHT/2
    end
end 
function recursiveCalculations(px, ex, ey, edx, edy, ifspecial)
    if VIRTUAL_WIDTH - ex < AI_SPEED then 
        local time = (VIRTUAL_WIDTH - ex)/(ballSpeed*edx)
        local distance = (ballSpeed * edy) * time 
        love.window.setTitle(ey + (distance*edy))
        return ey + (distance*edy)
    else 

        if (edy > 0) then 
        --print ("normal" .. ex .." " .. ey .. " " .. edx .. " " .. edy)
            local time = (VIRTUAL_HEIGHT-ey) / (ballSpeed * edy)
            local distance = (ballSpeed * edx) * time
        --print(distance .. " " .. edx .. " " .. time .. " " .. (px-ex))
            if distance > (px - ex) then 
                local anstime = (px - ex) / (ballSpeed * edx) 
                local bonus = (ballSpeed * edy) * anstime 
            --print("results: " .. bonus .. " " .. edx .. " " .. anstime .. " " .. (px-ex))
            -- if (ifspecial == 0) then  
                    return ey + bonus 
            -- else 
                --   return -1  
                --end
            else 
                local emulatedx = ex + distance 
                local emulatedy = VIRTUAL_HEIGHT
                local answer = recursiveCalculations(px, emulatedx, emulatedy, edx, -edy, 0)
                love.window.setTitle(answer)
                return answer 
            end  
        elseif edy == 0 then 
            return ey
        else
        --print ("inverse" .. ex .." " .. ey .. " " .. edx .. " " .. edy)
            local time = (ey) / math.abs((ballSpeed * edy))
            local distance = (ballSpeed * edx) * time 
        --print(distance .. " " .. edx .. " " .. time .. " " .. (px-ex))

            
        --print("Why th efuck ")

            if distance > (px - ex) then 
                local anstime = (px - ex) / (ballSpeed * edx) 
                local bonus = (ballSpeed * edy) * anstime
            --print("results: " .. bonus .. " " .. edx .. " " .. anstime .. " " .. (px-ex)) 
    --         if (ifspecial == 0) then 
                    local answer = ey + bonus 
                    love.window.setTitle(answer)
                    return answer 
        --       else 
        --         return -1 
            --   end
            else 
                local emulatedx = ex + distance 
                local emulatedy = 0
    ----print("results: " .. bonus .. " " .. edx .. " " .. anstime .. " " .. (VIRTUAL_WIDTH-ex)) 
                local answer = recursiveCalculations(px, emulatedx, emulatedy, edx, -edy, 0)
                love.window.setTitle(answer)
                return answer 
            end
        end
    end
end