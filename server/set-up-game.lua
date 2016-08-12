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
          -- Tell player 1 to leave waiting area
          sendStartingGameState(true, newroomname, games[i].players[1].msg_or_ip, games[i].players[1].port_or_nil)
          -- Tell player 2 they were successful
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
      games[newroomname] = {deck = d, hand1 = h1, hand2 = h2, playArea = p, score1 = {}, score2 = {},  players = {{username = newusername, msg_or_ip = msg_or_ip, port_or_nil = port_or_nil}}, mode="h1", lastScore = {0, 0}}
      users[newusername] = newroomname
      sendUDP("&", msg_or_ip, port_or_nil)
    end
  end
end
