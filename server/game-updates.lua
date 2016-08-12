function updateGame(data, msg_or_ip, port_or_nil)
  local roomname, username, match = string.match(data,"^>(%w+)>(%w+)>(.*)")
  assert(roomname and username and match)
  local game = games[roomname]
  local msg_sent = false
  local error_message = nil
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
    else
      error_message = "Game mode doesn't end in 1 or 2"
    end
    if playerNum and username == game.players[playerNum].username then
      if string.sub(game.mode, 1, 1) == "h" then
        if verifyHandMove(match, game, playerHand) then
          updateHandMove(match, game, playerNum, playerHand, playerScore)
          sendAllUpdates(playerNum, match, game)
          msg_sent = true
        else
          error_message = "Hand move verification failed"
        end
      elseif string.sub(game.mode, 1, 1) == "d" then
        if verifyDeckMove(match, game, playerHand) then
          updateDeckMove(match, game, playerNum, playerHand, playerScore)
          sendAllUpdates(playerNum, match, game)
          msg_sent = true
        else
          error_message = "Deck move verification failed"
        end
      else
        error_message = "Game mode doesn't start with h or d"
      end
    else
      error_message = "Player authentication failed"
    end
  end
  if not msg_sent then
    sendFailureMessage(msg_or_ip, port_or_nil)
  end
  if debug and error_message then
    print("Error: " .. error_message)
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
    local card = searchByField(game.playArea, "charVal", match)
    return card and card.month == game.deckFlip.month
  else
    return false
  end
end

function updateHandMove(match, game, playerNum, playerHand, playerScore)
  game.status = nil -- nothing to signal (yet)

  if #match == 1 then
    moveByField(playerHand, game.playArea, "charVal", match)
  elseif #match == 2 then
    moveByField(playerHand, playerScore, "charVal", match:sub(1, 1))
    moveByField(game.playArea, playerScore, "charVal", match:sub(2, 2))
  end
  -- deal the next card
  game.deckFlip = table.remove(game.deck, 1)

  game.mode = "d"..playerNum

  -- check if the game has been won
  local newScore = numericalScore(playerScore)
  if newScore > game.lastScore[playerNum] then
    game.status = "continue?"
    game.lastScore[playerNum] = newScore
  end

end

function updateDeckMove(match, game, playerNum, playerHand, playerScore)
  game.status = nil -- nothing to signal (yet)

  local oppositeNum = 3 - playerNum
  if #match == 0 then
    table.insert(game.playArea, game.deckFlip)
  elseif #match == 1 then
    moveByField(game.playArea, playerScore, "charVal", match)
    table.insert(playerScore, game.deckFlip)
  end
  game.mode = "h"..oppositeNum

  -- check if we have run out of game moves
  if #game.hand1 == 0 and #game.hand2 == 0 then
    game.status = "draw"
  end

  -- check if the game has been won
  local newScore = numericalScore(playerScore)
  if newScore > game.lastScore[playerNum] then
    game.status = "continue?"
    game.lastScore[playerNum] = newScore
  end

end

function sendAllUpdates(playerNum, match, game)
  if game.status then
    if game.status == "draw" then
      sendGameOver(game, 0)
    elseif game.status == "continue?" then
      sendKoiKoiUpdate(playerNum, match, game)
    end
  else
    -- all is fine
    sendGameUpdate(playerNum, match, game)
  end
end

function sendGameUpdate(playerNum, match, game)
  local data
  data = ">" .. match .. ">"

  if game.mode:sub(1,1) == "d" then
    -- We need to deal a card
    data = data..game.deckFlip.charVal..">"
  end

  local otherPlayer = 3 - playerNum

  -- send message to player who sent move, approving it:
  sendUDP(data, game.players[playerNum].msg_or_ip, game.players[playerNum].port_or_nil)

  -- send message to other player
  sendUDP(data, game.players[otherPlayer].msg_or_ip, game.players[otherPlayer].port_or_nil)

end
