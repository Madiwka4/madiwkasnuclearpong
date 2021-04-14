local running = true
local socket = require 'socket'
local udp = socket.udp()
local player1ip, player2ip, player1port, player2port = "none", "none", nil, nil
udp:settimeout(0)
udp:setsockname('*', 12345)
local p1ping = 0
local p2ping = 0
local requesterip 
local requresterport
while running do
  local data, msg_or_ip, port_or_nil
  local p1data, p2data
  repeat

    data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then

      if data == "HELLO" then
        requesterip = msg_or_ip
        requesterport = port_or_nil
      else
        print(string.sub(data,1,1) .. "Playerlist: " .. player1ip .. " " .. p1ping .. " " .. player2ip .. " " .. p2ping)
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
            p1ping = 0
            player1port = port_or_nil
            print("CONNECTED: PLAYER 1 FROM: " .. player1ip)
          elseif player2ip == "none" and msg_or_ip ~= player1ip then
            player2ip = msg_or_ip
            p2data = data
            p2ping = 0
            player2port = port_or_nil
            print("CONNECTED: PLAYER 2 FROM: " .. player2ip)
          elseif (player1ip ~= msg_or_ip and player2ip ~= msg_or_ip) then
            print("Lobby Full!" .. player1ip .. player2ip)
          end
        end

      end
    end
   until not data
    if player1ip ~= "none" then
      p1ping = p1ping + 1
      if p1ping > 100 then
        if p2data then
          udp:sendto(p2data .. '|' .. p1ping, player1ip, player1port)
        end
        print("PLAYER 1 DISCONNECTED")
        p1data = nil
        player1ip = "none"
        player1port = nil
      end
    end
    if player2ip ~= "none" then
      p2ping = p2ping + 1
      if p2ping > 100 then
        if p1data then
          udp:sendto(p1data .. '|' .. p2ping, player2ip, player2port)
        end
        print("PLAYER 2 DISCONNECTED")
        p2data = nil
        player2ip = "none"
        player2port = nil
      end
    end
    if p1data and player2port then
      udp:sendto(p1data .. '|' .. p2ping, player2ip, player2port)
      --rint("SENT TO " .. player2ip .. ":" .. player2port ..  " : " .. string.sub(p1data,1,1))
    end
    if p2data and player1port then
      udp:sendto(p2data .. '|' .. p1ping, player1ip, player1port)
      --print("SENT TO " .. player1ip .. ":" .. player1port .. " : " .. string.sub(p2data,1,1))
      --print("1::" .. p1data)
      --print("2::" .. p2data)
      --print("SENT1: " .. player2ip .. " " .. player2port .. " " .. p1data)
      --print("SENT2: " .. player1ip .. " " .. player1port .. " " .. p2data)
    end
    if requesterip then
        print("getting pnged!")
        if player1ip == "none" then
          udp:sendto("nettest",requesterip, requesterport)
          print("nettest av to: " .. requesterip)
        elseif player2ip == "none" then
          udp:sendto("clienttest", requesterip, requesterport)
          print("clienttest av to: " .. requesterip)
        else
          udp:sendto("full", requesterip, requesterport)
          print("full to: " .. msg_or_ip)
        end
        requesterip, requesterport = nil
    end
    socket.sleep(0.015)

end