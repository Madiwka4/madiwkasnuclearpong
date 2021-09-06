rm game.love 
rm game.zip
zip -r game * 
mv game.zip game.love
cp ../libdiscord-rpc.so libdiscord-rpc.so
love game.love --fused
rm game.love
