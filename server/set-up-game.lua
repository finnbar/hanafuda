function sendStartingGameState(firstPlayer, game)
  -- Format:
  -- !handaschars!playareaaschars!numberofcardsopponenthas!
  -- All cards are one digit long, so the client just gets a string of them.
  local nhand = 0
  local nopponent = 0
  local handchars = ''
  local playchars = ''
  local user
  print(game.players, #game.players)
  if firstPlayer then
    nhand = #game.hand1
    nopponent = #game.hand2
    handchars = handAsChars(game.hand1,nhand)
    user = game.players[1]
  else
    nhand = #game.hand2
    nopponent = #game.hand1
    handchars = handAsChars(game.hand2,nhand)
    user = game.players[2]
  end
  nplay = #game.playArea
  playchars = handAsChars(game.playArea, nplay)
  sendUDP("!"..handchars.."!"..playchars.."!"..nopponent.."!", user)
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
  local istaken = false
  if not (newroomname and newusername) then
    -- if the message is just not right, send them back to try again
    if string.match(data, "^#(.*)@(%w+)$") then -- proper username, no room
      sendUDP("#", {ip = msg_or_ip, port = port_or_nil})
    else
      sendUDP("@", {ip = msg_or_ip, port = port_or_nil})
    end
    istaken = true
  end
  if not istaken and users[newusername] then
    sendUDP("@", {ip = msg_or_ip, port = port_or_nil})
    istaken = true
  end
  if not istaken then
    for i, j in pairs(games) do
      if i == newroomname then
        if #(j.players) == 1 then
          users[newusername] = {username = newusername, room = newroomname, ip = msg_or_ip, port = port_or_nil}
          table.insert(games[i].players, users[newusername])
          -- Tell player 1 to leave waiting area
          sendStartingGameState(true, games[newroomname])
          -- Tell player 2 they were successful
          sendStartingGameState(false, games[newroomname])
          istaken = true
        else
          sendUDP("#", {ip = msg_or_ip, port = port_or_nil})
          istaken = true
          break
        end
      end
    end
    if not istaken then
      -- Set up a game, then send to waiting area
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
      users[newusername] = {username = newusername, room = newroomname, ip = msg_or_ip, port = port_or_nil}
      games[newroomname] = {roomname = newroomname, deck = d, hand1 = h1, hand2 = h2, playArea = p, score1 = {}, score2 = {},  players = {users[newusername]}, mode="h1", lastScore = {0, 0}, multipliers = {1, 1}}
      sendUDP("&", users[newusername])
    end
  end
end
