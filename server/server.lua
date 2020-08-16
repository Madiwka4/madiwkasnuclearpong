local running = true
local socket = require 'socket'
local udp = socket.udp()
local player1ip, player2ip, p1data, p2data, player1port, player2port = "none", "none", nil, nil, nil, nil
udp:settimeout(0)
udp:setsockname('*', 12345)
local p1ping = 0
local p2ping = 0
local data, msg_or_ip, port_or_nil
while running do 
    data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then 
        if (player1ip == msg_or_ip) then 
            p1ping = 0
            p1data = data 
         elseif player2ip == msg_or_ip then 
             p2data = data
             p2ping = 0 
         else 
            if (player1ip == "none") then 
                player1ip = msg_or_ip 
                p1data = data
                player1port = port_or_nil
                print("CONNECTED: PLAYER 1 FROM: " .. player1ip)
            elseif player2ip == "none" and msg_or_ip ~= player1ip then 
                player2ip = msg_or_ip 
                p2data = data
                player2port = port_or_nil
                print("CONNECTED: PLAYER 2 FROM: " .. player2ip)
            elseif (player1ip ~= msg_or_ip and player2ip ~= msg_or_ip) then
                print("Lobby Full!" .. player1ip .. player2ip)
            end
         end


    elseif player1ip ~= "none" then 
        p1ping = p1ping + 1
        if p1ping > 5 then
            if p2data then  
            udp:sendto(p2data .. '|' .. p1ping, player1ip, player1port)
            end
            print("PLAYER 1 DISCONNECTED")
            p1data = nil 
            player1ip = "none"
            player1port = nil
        end
    elseif player2ip ~= "none" then 
        p2ping = p2ping + 1
        if p2ping > 5 then 
            if p1data then 
            udp:sendto(p1data .. '|' .. p2ping, player2ip, player2port)
            end
            print("PLAYER 2 DISCONNECTED")
            p2data = nil 
            player2ip = "none"
            player2port = nil
        end
    end
    if data then 
        print(data .. "FROM " .. msg_or_ip .. "Playerlist: " .. player1ip .. " " .. player2ip)
    end
	if p1data and p2data then
        udp:sendto(p1data .. '|' .. p2ping, player2ip, player2port)
        udp:sendto(p2data .. '|' .. p1ping, player1ip, player1port)
        print("SENT1: " .. player2ip .. " " .. player2port .. " " .. p1data)
        print("SENT2: " .. player1ip .. " " .. player1port .. " " .. p2data)
    end
    socket.sleep(0.01)
end 