-- server.lua, which runs the server stuff, unsurprisingly.
package.path = package.path .. ";../both/?.lua" -- get anything from both folder

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
          table.insert(games[i].players, {username = newusername, msg_or_ip = msg_or_ip, port_or_nil = port_or_nil})
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
      games[newroomname] = {deck = d, hand1 = h1, hand2 = h2, playArea = p, score1 = {}, score2 = {},  players = {{username = newusername, msg_or_ip = msg_or_ip, port_or_nil = port_or_nil}}, mode="h1"}
      users[newusername] = newroomname
      sendStartingGameState(true, newroomname, msg_or_ip, port_or_nil)
    end
  end
end

function updateGame(data, msg_or_ip, port_or_nil)
  local roomname, username, match = string.match(data,"^>(%w+)>(%w+)>(%w*)")
  assert(roomname and username and match)
  local game = games[roomname]
  local msg_sent = false
  if game then
    local playerHand, playerScore, playerNum
    if string.sub(game.mode, 2, 2) == "1" then
      -- player 1's go
      playerNum = 1
      playerHand = game.hand1
      playerScore = game.score1
    elseif string.sub(game.mode, 2, 2) == "2" then
      -- player 2's go
      playerNum = 2
      playerHand = game.hand2
      playerScore = game.score2
    end
    if playerNum and username == game.players[playerNum].username then
      if string.sub(game.mode, 1, 1) == "h" then
        if verifyHandMove(match, game, playerHand) then
          updateHandMove(match, game, playerNum, playerHand, playerScore)
          sendGameUpdate(playerNum, match, game)
          msg_sent = true
        end
      elseif string.sub(game.mode, 1, 1) == "d" then
        if verifyDeckMove(match, game, playerHand) then
          updateHandMove(match, game, playerNum, playerHand, playerScore)
          sendGameUpdate(playerNum, match, game)
          msg_sent = true
        end
      end
    end
  end
  if not msg_sent then
    sendFailureMessage(msg_or_ip, port_or_nil)
  end
end

function verifyHandMove(match, game, playerHand)
  if #match == 1 then
    -- Placing a card, is it in hand?
    return searchByField(playerHand, "charVal", match)
  elseif #match == 2 then
    -- Matching a card
    local c1, card1, c2, card2

    -- Get cards from hand and play area
    c1 = string.sub(match, 1, 1)
    card1 = searchByField(playerHand, "charVal", c1)
    c2 = string.sub(match, 2, 2)
    card2 = searchByField(game.playArea, "charVal", c2)

    -- Check cards exist and match
    return card1 and card2 and card1.month == card2.month
  else
    return false
  end
end

function verifyDeckMove(match, game, playerHand)
  if #match == 0 then
    return true -- you can always drop a card
  elseif #match == 1 then
    -- Matching this card with the deck flip
    local card = searchByField(playerHand, "charVal", match)
    return card and card.month == game.deckFlip.month
  else
    return false
  end
end

function updateHandMove(match, game, playerNum, playerHand, playerScore)
  if #match == 1 then
    moveByField(playerHand, game.playArea, "charVal", match)
  elseif #match == 2 then
    moveByField(playerHand, playerScore, "charVal", match:sub(1, 1))
    moveByField(game.playArea, playerScore, "charVal", match:sub(2, 2))
  end
  game.mode = "d"..playerNum
end

function updateDeckMove(match, game, playerNum, playerHand, playerScore)
  local oppositeNum = 3 - playerNum
  if #match == 0 then
    table.insert(game.playArea, game.deckFlip)
  elseif #match == 1 then
    moveByField(playerHand, playerScore, "charVal", match)
    table.insert(playerScore, game.deckFlip)
  end
  game.mode = "h"..oppositeNum
end

function sendGameUpdate(playerNum, match, game)
  local data
  if #match == 1 then
    data = string.format(">%s>", match)
  else
    data = string.format(">%s%s>", match:sub(1,1), match:sub(2,2))
  end

  local otherPlayer = 3 - playerNum

  -- send message to player who sent move, approving it:
  sendUDP(data, game.players[playerNum].msg_or_ip, game.players[playerNum].port_or_nil)

  -- send message to other player
  if #game.players == 2 then
    -- Check that both players are connected
    sendUDP(data, game.players[otherPlayer].msg_or_ip, game.players[otherPlayer].port_or_nil)
  else
    -- Store move to send later?
  end

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
      if string.sub(data,1,1) == "#" then
        createNewGame(data, msg_or_ip, port_or_nil)
      elseif string.sub(data,1,1) == ">" then
        updateGame(data, msg_or_ip, port_or_nil)
      end
    elseif msg_or_ip ~= 'timeout' then
      error("Unknown network error: "..tostring(msg_or_ip))
    end
    socket.sleep(0.01)
  end
end

main()
