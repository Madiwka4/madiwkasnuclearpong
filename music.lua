function musicController(orders, toggling)
    if (orders == 'norm' and not mute) then 
        if (globalState == 'menu') then 
            sounds['gayTheme']:stop()
            sounds['gayTheme2']:stop()
            sounds['gayTheme3']:stop()
            sounds['gayTheme4']:stop()
            sounds['updateMusic']:play()
        elseif (areanuclear == 1) then 
            sounds['gayTheme']:setVolume(0)
            sounds['gayTheme2']:setVolume(0)
        
        elseif ((gameState == 'play' or gameState == '1serve' or gameState == '2serve') and player1score <= ptw*0.5 and player2score <= ptw*0.5 and areanuclear == 0) then 
            sounds['updateMusic']:stop()
            sounds['gayTheme2']:stop()
            sounds['gayTheme3']:stop()
            sounds['gayTheme4']:stop()
            sounds['gayTheme']:setPitch(1)
            sounds['gayTheme']:setLooping(true)
            sounds['gayTheme']:setVolume(0.5)
            sounds['gayTheme']:play()
        elseif gameState == 'play' and areanuclear == 0 and ((AGAINST_AI == 1 and player1score >= ptw*0.8 and player2score < ptw*0.8) or (globalState == "nettest" and player1score > ptw*0.8 and player2score <= ptw*0.8) or (globalState == "clienttest" and player2score > ptw*0.8 and player1score <= ptw*0.8)) then 
            --print(ptw*0.8)
            sounds['gayTheme']:stop()
            sounds['gayTheme2']:stop()
            sounds['gayTheme3']:stop()
            sounds['updateMusic']:stop()
            sounds['gayTheme4']:setPitch(1)
            sounds['gayTheme4']:setLooping(true)
            sounds['gayTheme4']:setVolume(0.5)
            sounds['gayTheme4']:play() 
         elseif gameState == 'play' and player1score >= ptw*0.8 or player2score > ptw*0.8 and areanuclear == 0 then 
            --print(ptw*0.8)
            sounds['gayTheme']:stop()
            sounds['gayTheme4']:stop()
            sounds['gayTheme3']:stop()
            sounds['updateMusic']:stop()
            sounds['gayTheme2']:setPitch(1)
            sounds['gayTheme2']:setLooping(true)
            sounds['gayTheme2']:setVolume(0.5)
            sounds['gayTheme2']:play()          
        elseif gameState == 'play' and player1score > ptw*0.5 or player2score > ptw*0.5 and areanuclear == 0 then 
            --print(ptw-4)
            sounds['gayTheme']:stop()
            sounds['gayTheme2']:stop()
            sounds['gayTheme4']:stop()
            sounds['updateMusic']:stop()
            sounds['gayTheme3']:setPitch(1)
            sounds['gayTheme3']:setLooping(true)
            sounds['gayTheme3']:setVolume(0.5)
            sounds['gayTheme3']:play()
            
         end
    elseif orders == "mute" then 
        if toggling == 1 then 
        sounds['gayTheme']:stop()
        sounds['gayTheme3']:stop()
        sounds['gayTheme2']:stop()
        sounds['gayTheme4']:stop()
        sounds['updateMusic']:stop()
            mute = true 
        else 
            mute = false
        end
    end
end