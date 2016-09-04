-- server.lua, which runs the server stuff, unsurprisingly.
package.path = package.path .. ";../both/?.lua" -- get anything from both folder

requires = {"cards-define","useful", "cards-score", "set-up-game", "game-end-updates", "game-updates"}

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

-- debug mode, for printing more stuff
debug = true

function sendUDP(data,msg_or_ip,port_or_nil)
  print("Out > "..data)
  udp:sendto(data,msg_or_ip,port_or_nil)
  table.insert(toValidate, {data = data, ip = msg_or_ip, port_or_nil = port_or_nil, timeSent = os.clock()})
end

function sendFailureMessage(msg_or_ip, port_or_nil)
  sendUDP("~", msg_or_ip, port_or_nil)
end

function main()
  math.randomseed(os.time()) -- Otherwise we get the same cards whenever server restarts
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
      if data == "OK" then
        removeValidatedMsg(msg_or_ip)
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
    socket.sleep(0.01)
  end
end

function removeValidatedMsg(msg_or_ip)
  for i,j in ipairs(toValidate) do
    if j.ip == msg_or_ip then
      table.remove(toValidate, i)
    end
    return true
  end
  return false
end

function checkForLostMsgs()
  for i = #toValidate,1,-1 do -- backwards to make removing easier
    local j = toValidate[i]
    if os.clock() - j.timeSent > 2 then
      sendUDP("*"..j.data, j.ip, j.port_or_nil)
      table.remove(toValidate, i)
    end
  end
end

main()
