rm game.love 
rm game.zip
zip -r game * 
mv game.zip game.love
love2d game.love