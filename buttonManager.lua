mainMenu = Class{}
function resolutionButtons(gameState, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, buttons)
        
                if (gameState == 'windowsettings') then 

        local ev_button_width = VIRTUAL_WIDTH * (1/3)
        local ev_BUTTON_HEIGHT = 50
        local margin = 16
        local hot = false
        local cursor_y = 0
        local total_height = (ev_BUTTON_HEIGHT + margin) * #settings
        for i, button in ipairs(buttons) do 
            button.last = button.now
            local ev_bx = (VIRTUAL_WIDTH*0.8) - (ev_button_width * 0.5)
            local ev_by = (VIRTUAL_HEIGHT * 0.5) - (total_height * 0.5) + cursor_y
            local color = {255, 255, 255, 255}
            local mx, my = love.mouse.getPosition()
            local mx = mx * DIFFERENCE_X
            local my = my * DIFFERENCE_Y
            local hot = (mx > ev_bx and mx < ev_bx + ev_button_width and my > ev_by and my < ev_by + ev_BUTTON_HEIGHT) and i
            if (hot == i) then 
                color = {10, 10, 0, 255}
            end
                        button.now = love.mouse.isDown(1)
            if button.now and not button.last and hot == i then
                love.graphics.setColor(0,0,0,1)
                love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
            --  sounds['wallhit']:play()  
             button.fn()
         end
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", ev_bx,ev_by, ev_button_width, ev_BUTTON_HEIGHT)
            love.graphics.setColor(0, 0, 0, 255)
            local textW = smallfont:getWidth(button.text)
            local textH = smallfont:getHeight(button.text)
            love.graphics.print(button.text, smallfont, VIRTUAL_WIDTH*0.8 - textW*0.5, ev_by+textH*0.5)
        
            love.graphics.setColor(255, 255, 255, 255)
            cursor_y = cursor_y + (ev_BUTTON_HEIGHT + margin)
            
        end
        
                
    end
                  

    end
