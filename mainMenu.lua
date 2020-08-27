mainMenu = Class{}
function mainMenu:butt(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, buttons, sounds, location)
          if (gameState == 'editor')
        then
         ev_button_width = VIRTUAL_WIDTH * (1/72)
        ev_BUTTON_HEIGHT = VIRTUAL_WIDTH * (1/72)
        local margin = 16
        local hot = false
        local cursor_y = 0
        blockinput = false
        local total_height = (ev_BUTTON_HEIGHT + margin) * #buttons
        for i, button in ipairs(buttons) do 
            button.last = button.now
             ev_bx = (VIRTUAL_WIDTH*0.05) - (ev_button_width * 0.5)
             ev_by = (VIRTUAL_HEIGHT * 0.1) - (total_height * 0.5) + cursor_y
            local color = {255, 255, 255, 255}
            local mx, my = love.mouse.getPosition()
            mx = mx * DIFFERENCE_X
            my = my * DIFFERENCE_Y
            hot = (mx > ev_bx and mx < ev_bx + ev_button_width and my > ev_by and my < ev_by + ev_BUTTON_HEIGHT) and i
            if (hot == i) then 
                blockinput = blockinput or true
                color = {10, 10, 0, 255}
            end

                        button.now = love.keyboard.mouseWasReleased()

            if button.now and not button.last and hot == i then

                love.graphics.setColor(0,0,0,1)
                love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
                sounds['wallhit']:play()
             button.fn()
         end
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", ev_bx,ev_by, ev_button_width, ev_BUTTON_HEIGHT)
            love.graphics.setColor(0, 0, 0, 255)
            local textW = smallfont:getWidth(button.text)
            local textH = smallfont:getHeight(button.text)
            love.graphics.print(button.text, smallfont, VIRTUAL_WIDTH*0.05 - textW*0.5, ev_by*0.9+textH*0.01)
            love.graphics.setColor(255, 255, 255, 255)
            cursor_y = cursor_y + (ev_BUTTON_HEIGHT + margin)
            
        end  
    else
        if location == 'middle' then 
            locationx = (VIRTUAL_WIDTH * 0.5)
            locationy = (VIRTUAL_HEIGHT* 0.5)
        elseif location == 'right' then 
            locationx = (VIRTUAL_WIDTH * 0.8)
            locationy = (VIRTUAL_HEIGHT* 0.5)
        elseif location == 'control' then
            locationx = (VIRTUAL_WIDTH * 0.2)
            locationy = (VIRTUAL_HEIGHT* 0.5)
        elseif location == "android" then 
            locationx = (VIRTUAL_WIDTH * 0.5)
            locationy = (10)
        end

            local ev_button_width = VIRTUAL_WIDTH * (1/3)
            local ev_BUTTON_HEIGHT = 50
            if location == "android" then 
                ev_button_width = 30
                ev_BUTTON_HEIGHT = 30
            end 
        local margin = 16
        local hot = false
        local cursor_y = 0
        local total_height = (ev_BUTTON_HEIGHT + margin) * #buttons
        local ev_bx, ev_by
        for i, button in ipairs(buttons) do 
            button.last = button.now
            if (location == 'control') then 
                
                    if string.sub(button.text, 1, 1) == '2' then 
                    ev_bx = (VIRTUAL_WIDTH*0.2) - (ev_button_width * 0.5)
                    ev_by = locationy - (total_height * 0.5) + cursor_y
                    elseif string.sub(button.text, 1, 1) == '1' then 
                        ev_bx = (VIRTUAL_WIDTH*0.8) - (ev_button_width * 0.5)
                        ev_by = locationy - (total_height * 0.5) + cursor_y
                    else 
                        ev_bx = (VIRTUAL_WIDTH*0.5) - (ev_button_width * 0.5)
                        ev_by = locationy - (total_height * 0.5) + cursor_y
                    end
                elseif button.text == 'NUCLEAR MODE' and easternum < 11 then 
                    ev_bx = -400
                    ev_by = -400
                else
                    ev_bx = locationx - (ev_button_width * 0.5)
                    ev_by = locationy - (total_height * 0.5) + cursor_y
            end
            if (button.text == 'Play') and location == 'playercount' then color = {0/255, 255/255, 0/255, 255} else
                color = {10, 10, 0, 255}
            end
            local color = {255, 255, 255, 255}
            if (button.text == 'NUCLEAR MODE' and easternum > 10) then 
                color = {0,0,0,1}
                else
                color = {1,1,1,1}
            end
            local mx, my = love.mouse.getPosition()
            local mx = mx * DIFFERENCE_X
            local my = my * DIFFERENCE_Y
            local hot = (mx > ev_bx and mx < ev_bx + ev_button_width and my > ev_by and my < ev_by + ev_BUTTON_HEIGHT) and i
            if (hot == i) then 
                color = {10, 10, 0, 255}
            end
                        button.now = love.keyboard.mouseWasReleased()
            if button.now and not button.last and hot == i then
                love.graphics.setColor(0,0,0,1)
                love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
              sounds['wallhit']:play()  
             button.fn()
         end
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", ev_bx,ev_by, ev_button_width, ev_BUTTON_HEIGHT)
            love.graphics.setColor(0, 0, 0, 255)
            local textW = smallfont:getWidth(button.text)
            local textH = smallfont:getHeight(button.text)
            if (location == 'control') then 
                if danger == button.text or danger2 == button.text then
                    love.graphics.setColor(1,0,0,1)
                else 
                    love.graphics.setColor(0,0,0,1)
                end 
                if (button.text == "1up") then 
                    love.graphics.print("P1 UP: " .. string.upper(p1control.up), smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
                elseif button.text == '2up' then 
                    love.graphics.print("P2 UP: " .. string.upper(p2control.up), smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
                elseif button.text == '1down' then 
                    love.graphics.print("P1 DOWN: " .. string.upper(p1control.down), smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
                    elseif button.text == '2down' then 
                    love.graphics.print("P2 DOWN: " .. string.upper(p2control.down), smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
                    elseif button.text == '1special' then 
                    love.graphics.print("P1 SPECIAL: " .. string.upper(p1control.super), smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
                    elseif button.text == '2special' then 
                    love.graphics.print("P2 SPECIAL: " .. string.upper(p2control.super), smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
                    elseif button.text == '1ct' then 
                    love.graphics.print("P1 COUNTER: " .. string.upper(p1control.counter), smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
                elseif button.text == '2ct' then 
                    love.graphics.print("P2 COUNTER: " .. string.upper(p2control.counter), smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
                else
                love.graphics.print(button.text, smallfont, ev_bx + (ev_button_width * 0.1), ev_by+textH*0.5)
               
                end
                cursor_y = cursor_y + (ev_BUTTON_HEIGHT + margin)
            else
                    if (button.text == '1v1') then 
                        love.graphics.print(playertext, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, by+textH*0.5) 
                    elseif button.text == 'snc' then 
                        if (nuckemodactive == 1) then
                            love.graphics.setColor(1,0,0,1)
                            love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.7, ev_by+textH*0.5)
                            love.graphics.setColor(1,1,1,1)
                            love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.7, ev_by+textH*0.5)
                            love.graphics.setColor(0,0,0,1) 
                        else
                            love.graphics.print(synctext, smallfont, VIRTUAL_WIDTH*0.45 - textW*0.5, ev_by+textH*0.5)
                        end
                    elseif (button.text == 'ballCount') then 
                        love.graphics.print("Ball Count: " .. maxBalls, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.7, ev_by+textH*0.5)
                    elseif (button.text == "Ball Speed: ") then 
                        if (nuckemodactive == 1) then 

                            love.graphics.setColor(1,0,0,1)
                            love.graphics.print("shaitan machina", smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, ev_by+textH*0.5)
                            love.graphics.setColor(1,1,1,1)
                            love.graphics.print("shaitan machina", smallfont, VIRTUAL_WIDTH*0.5 - textW*0.5, ev_by+textH*0.5)
                            love.graphics.setColor(0,0,0,1) 

                        else
                            love.graphics.print(button.text .. ballSet, smallfont, VIRTUAL_WIDTH*0.5 - textW*0.6, ev_by+textH*0.5)
                        end
                    elseif button.text == 'ptw' then 
                        love.graphics.print("Points to Win: " .. ptw, smallfont,VIRTUAL_WIDTH*0.5 - textW * 2.8, ev_by+textH*0.5)
                    elseif (button.text ==  'Silverblade') then 
                        love.graphics.print("Difficulty: " .. prtext, smallfont, VIRTUAL_WIDTH*0.5 - textW , ev_by+textH*0.5) 
                    else
                        love.graphics.print(button.text, smallfont, locationx - textW*0.5, ev_by+textH*0.5)
                    end
                        love.graphics.setColor(255, 255, 255, 255)
                        cursor_y = cursor_y + (ev_BUTTON_HEIGHT + margin)
                    end
                end            
            end
        end
function mainMenu:addButton(text, fn)
    return {
        text = text, 
        fn = fn,
        now = false,
        last = false
    }
end
function menuButtons()

local button_width = VIRTUAL_WIDTH * (1/3)
local BUTTON_HEIGHT = 50
local margin = 16
local hot = false
local cursor_y = 0
local total_height = (BUTTON_HEIGHT + margin) * #buttons
for i, button in ipairs(buttons) do 
button.last = button.now
local bx = (VIRTUAL_WIDTH*0.5) - (button_width * 0.5)
local by = (VIRTUAL_HEIGHT * 0.8) - (total_height * 0.5) + cursor_y
local color = {255, 255, 255, 255}
local mx, my = love.mouse.getPosition()
mx = mx * DIFFERENCE_X
my = my * DIFFERENCE_Y
hot = (mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT) and i
if (hot == i) then 
    color = {10, 10, 0, 255}
end
button.now = love.keyboard.mouseWasReleased()
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
