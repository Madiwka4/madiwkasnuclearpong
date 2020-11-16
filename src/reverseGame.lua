function reversegame(dt) 
    player1.height = ballSpeed/2
    player2.height = ballSpeed/2
    if (player1.y < ball[1].y)then 
        player1.y = player1.y + ballSpeed/50
    elseif(player1.y > ball[1].y)then 
        player1.y = player1.y - ballSpeed/50
    end 
    if (player2.y < ball[1].y) then 
        player2.y = player2.y + ballSpeed/50

    elseif(player2.y > ball[1].y) then
        player2.y = player2.y - ballSpeed/50
    end 
end
