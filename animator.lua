local player1anim = false 
local player2anim = false 
local player1animend = false 
local player2animaend = false 
local effectRange = {[0] = 0,[1] = 0}
local diseffectRange = {[0] = 0,[1] = 0}
function superanimator(type, param)
    if type == 'tensehit' then 
        if param == 1 then
           --print("Animation called!")
            player1anim = true 
        end
        if param == 2 then 
           --print("Animation called!")
            player2anim = true 
        end
    end
end
function staticanimatorcounter(dt)
    if (gameState == 'animation') then
        time_1 = time_1 + dt
        light = 255 - time_1 * 85
        if (light < 0) then 
            time_1 = 0
            light = 0
            gameState = 'start'
        end
    end
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
    if gameState == "done" then 
        if explosionRange < 40 then 
        nuclearanimation = nuclearanimation - dt
        explosionRange = explosionRange + dt*24
        end
    end
    if (player1anim) then 
       --print("Effect range: " .. effectRange[0])
        effectRange[0] = effectRange[0] + dt*24
        if effectRange[0] > 7500/ballSpeed then 
            player1animend = true
        end
    end 
    if player1animend then 
       --print("DISEffect range: " .. diseffectRange[0])
        diseffectRange[0] = diseffectRange[0] + dt*24
        if diseffectRange[0] > 50 then 
            effectRange[0] = 0
            diseffectRange[0] = 0
            player1anim = false
            player1animend = false
        end 
    end
    if (player2anim) then 
       --print("Effect range: " .. effectRange[1])
        effectRange[1] = effectRange[1] + dt*24
        if effectRange[1] > 7500/ballSpeed then 
            player2animend = true
        end
    end 
    if player2animend then 
       --print("DISEffect range: " .. diseffectRange[1])
        diseffectRange[1] = diseffectRange[1] + dt*24
        if diseffectRange[1] > 50 then 
            effectRange[1] = 0
            diseffectRange[1] = 0
            player2anim = false
            player2animend = false
        end 
    end
end
function staticanimator()
    if player1anim then 
        love.graphics.setColor(140/255,70/255,70/255,1)
        love.graphics.circle("fill", player1.x, player1.y , effectRange[0]*100, 100)
    end
    if player1animend then 
        love.graphics.setColor(40/255,40/255,40/255,1)
        love.graphics.circle("fill", player1.x, player1.y , diseffectRange[0]*100, 100)
    end
    if player2anim then 
        love.graphics.setColor(70/255,70/255,140/255,1)
        love.graphics.circle("fill", player2.x, player2.y , effectRange[1]*100, 100)
    end
    if player2animend then 
        love.graphics.setColor(40/255,40/255,40/255,1)
        love.graphics.circle("fill", player2.x, player2.y , diseffectRange[1]*100, 100)
    end
end
function animateExplosion(x, y, v, color)
    love.graphics.setColor(color)
    love.graphics.circle("fill", x, y, explosionRange * v, 100)
end 