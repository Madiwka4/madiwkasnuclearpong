function musicController(orders, toggling)
    if (orders == 'norm') then 
        if (gameState ~= 'play' and gameState ~= '1serve' and gameState ~= '2serve' and areanuclear == 0) then 
            sounds['gayTheme']:stop()
            sounds['gayTheme2']:stop()
            sounds['updateMusic']:play()
        elseif (areanuclear == 1) then 
            sounds['gayTheme']:setVolume(0)
            sounds['gayTheme2']:setVolume(0)
        
        elseif ((gameState == 'play' or gameState == '1serve' or gameState == '2serve') and player1score <= 7 and player2score <= 7 and areanuclear == 0) then 
            sounds['updateMusic']:stop()
            sounds['gayTheme']:setPitch(1)
            sounds['gayTheme']:setLooping(true)
            sounds['gayTheme']:setVolume(0.5)
            sounds['gayTheme']:play()
         elseif gameState == 'play' and player1score > 7 or player2score > 7 and areanuclear == 0 then 
            sounds['gayTheme']:stop()
            sounds['updateMusic']:stop()
            sounds['gayTheme2']:setPitch(1)
            sounds['gayTheme2']:setLooping(true)
            sounds['gayTheme2']:setVolume(0.5)
            sounds['gayTheme2']:play()          
         else 
            
         end
    elseif orders ~= nil then  
        sounds[orders]:setPitch(1)
        sounds[orders]:setLooping(true)
        sounds[orders]:setVolume(0.9)
        sounds[orders]:play()
        if (toggling == 1) then 
            sounds[orders]:setVolume(0.9)
        else
            sounds[orders]:stop()
        end
    end
end