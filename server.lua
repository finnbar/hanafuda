-- server.lua, which runs the server stuff, unsurprisingly.

require "cards-define"
require "cards-score"
require "useful"
local socket = require "socket"
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('*', 12345)

local running = true
local games = {} -- a list of games tied to their roomname/number.
local users = {} -- a list of users, and the game they're in.
local data, msg_or_ip, port_or_nil
local cards = importCards(false)

function sendUDP(data,msg_or_ip,port_or_nil)
  print("Out > "..data)
  udp:sendto(data,msg_or_ip,port_or_nil)
end

function sendStartingGameState(firstPlayer, room, msg_or_ip, port_or_nil)
  -- Format:
  -- !handaschars!playareaaschars!numberofcardsopponenthas!
  -- All cards are one digit long, so the client just gets a string of them.
  local game = games[room]
  local nhand = 0
  local nopponent = 0
  local handchars = ''
  local playchars = ''
  if firstPlayer then
    nhand = #game.hand1
    nopponent = #game.hand2
    handchars = handAsChars(game.hand1,nhand)
  else
    nhand = #game.hand2
    nopponent = #game.hand1
    handchars = handAsChars(game.hand2,nhand)
  end
  nplay = #game.playArea
  playchars = handAsChars(game.playArea, nplay)
  sendUDP("!"..handchars.."!"..playchars.."!"..nopponent.."!", msg_or_ip, port_or_nil)
end

function handAsChars(cards, number)
  local chars = ''
  for i=1,number do
    chars = chars .. cards[i].charVal
  end
  return chars
end

function createNewGame(data, msg_or_ip, port_or_nil)
  -- Create a new room.
  -- Here, get the username and roomname from data (#roomname@username), and do the right stuff. Then we win?
  local newroomname, newusername = string.match(data,"^#(%w+)@(%w+)$")
  assert(newroomname and newusername)
  local istaken = false
  for i,j in pairs(users) do
    if i == newusername then
      sendUDP("@", msg_or_ip, port_or_nil)
      istaken = true
      break
    end
  end
  if not istaken then
    for i, j in pairs(games) do
      if i == newroomname then
        if #(j.players) == 1 then
          table.insert(games[i].players, newusername)
          sendStartingGameState(false, newroomname, msg_or_ip, port_or_nil)
          istaken = true
        else
          sendUDP("#", msg_or_ip, port_or_nil)
          istaken = true
          break
        end
      end
    end
    if not istaken then
      local h1 = {}
      local h2 = {}
      local p = {}
      local d = {}
      -- Flatten the deck.
      for i=1,12 do
        for j=1,4 do
          table.insert(d,cards[i][j])
        end
      end
      d = randSort(d) -- Okay, deck is randomised.
      for i=1,8 do
        table.insert(h1, table.remove(d,1))
        table.insert(h2, table.remove(d,1))
        table.insert(p, table.remove(d,1))
      end
      games[newroomname] = {deck = d, hand1 = h1, hand2 = h2, playArea = p, score1 = {}, score2 = {},  players = {newusername}}
      users[newusername] = newroomname
      sendStartingGameState(true, newroomname, msg_or_ip, port_or_nil)
    end
  end
end

function main()
  while running do
    data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then
      print("In > "..data)
      -- So, doing the rest of the game will go as follows. Most of it will be run by the clients - however, the server will allow you to draw a card from it, and pass your moves across. It makes a two-way connection.
      -- Messages from server key:
      -- # => roomname
      -- @ => username
      -- ! => starting game state
      -- > => move
      if string.sub(data,1,1) == "#" then
        createNewGame(data, msg_or_ip, port_or_nil)
      end
    elseif msg_or_ip ~= 'timeout' then
      error("Unknown network error: "..tostring(msg_or_ip))
    end
    socket.sleep(0.01)
  end
end

main()
