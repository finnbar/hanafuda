-- server.lua, which runs the server stuff, unsurprisingly.
package.path = package.path .. ";../both/?.lua" -- get anything from both folder

requires = {"cards-define","useful", "cards-score", "set-up-game", "game-end-updates", "game-updates", "remove-user"}

for _,j in pairs(requires) do
  require(j)
end

local socket = require "socket"
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('*', 12345)

local running = true
local data, msg_or_ip, port_or_nil
cards = importCards(false)
games = {} -- a list of games tied to their roomname/number.
users = {} -- a list of users, and the game they're in.
local toValidate = {}

local lastSent

-- debug mode, for printing more stuff
debug = true

function sendUDP(data, user, add_to_list)
  if add_to_list == nil then
    add_to_list = true
  end
  print("Out > "..data)
  udp:sendto(data, user.ip, user.port)
  if add_to_list then
    table.insert(toValidate, {data = data, user = user, timeSent = socket.gettime()})
  end
end

function sendFailureMessage(msg_or_ip, port_or_nil)
  sendUDP("~", {ip = msg_or_ip, port = port_or_nil})
end

function main()
  math.randomseed(os.time()) -- Otherwise we get the same cards whenever server restarts
  lastSent = socket.gettime()
  while running do
    data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then
      print("In > "..data)
      -- So, doing the rest of the game will go as follows. Most of it will be run by the clients - however, the server will allow you to draw a card from it, and pass your moves across. It makes a two-way connection.
      -- Messages from server key:
      -- # => roomname
      -- @ => username
      -- ! => starting game state
      -- > => move or update
      -- ~ => failure message
      -- & => sends to waiting area
      -- ? => Koi-Koi
      -- < => game ending.
      -- OK => message received
      -- STILL HERE => to keep client connected to server
      if string.sub(data, 1, 2) == "OK" then
        removeValidatedMsg(data, msg_or_ip, port_or_nil)
      elseif string.sub(data,1,1) == "#" then
        createNewGame(data, msg_or_ip, port_or_nil)
      elseif string.sub(data,1,1) == ">" then
        updateGame(data, msg_or_ip, port_or_nil)
      elseif string.sub(data,1,1) == "?" then
        koiKoiUpdate(data, msg_or_ip, port_or_nil)
      end
    elseif msg_or_ip ~= 'timeout' then
      error("Unknown network error: "..tostring(msg_or_ip))
    end
    checkForLostMsgs()
    if socket.gettime() - lastSent > 30 then
      for name,user in pairs(users) do
        sendUDP("STILL HERE", user, false)
      end
      lastSent = socket.gettime()
    end
    socket.sleep(0.01)
  end
end

function removeValidatedMsg(data, msg_or_ip, port_or_nil)
  for i,j in ipairs(toValidate) do
    if j.user.ip == msg_or_ip and j.user.port == port_or_nil and "OK "..j.data == data then
      table.remove(toValidate, i)
      return true
    end
  end
  return false
end

function checkForLostMsgs()
  for i = #toValidate,1,-1 do -- backwards to make removing easier
    local j = toValidate[i]
    if socket.gettime() - j.timeSent > 0.75 then
      local stars = string.match(j.data, "(%**).*")
      if stars:len() < 20 then
        sendUDP("*"..j.data, j.user)
      else
        -- remove the user here.
      end
      table.remove(toValidate, i)
    end
  end
end

main()
