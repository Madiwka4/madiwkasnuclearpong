function powerControl(initiate, type)
    if initiate == 1 and type == 'special' then 
        sounds["time"]:play() player1reverbav = false timeIsSlow = true originalSpeed = ballSpeed originalPaddle = paddle_SPEED player1reverbav = 0 potentialnuke1 = 0 potentialstrike1 = 0
    end    
end
function powerUpdate()

end