function sendKoiKoiUpdate(playerNum, match, game)
  -- Let both players know what match occurred and the score
  local score
  if playerNum == 1 then
    score = game.lastScore[playerNum] * game.multipliers[playerNum]
  else
    score = game.lastScore[playerNum] * game.multipliers[playerNum]
  end

  local msg = "?"..score.."?"..match.."?"

  -- send to both
  sendUDP(msg, game.players[1].msg_or_ip, game.players[1].port_or_nil)
  sendUDP(msg, game.players[2].msg_or_ip, game.players[2].port_or_nil)
end

function sendContinueUpdate(game)
  local msg -- send flip if necessary, else just question marks
  if game.mode:sub(1,1) == "d" then
    msg = "?" .. game.deckFlip.charVal .. "?"
  else
    msg = "??"
  end

  -- send to both
  sendUDP(msg, game.players[1].msg_or_ip, game.players[1].port_or_nil)
  sendUDP(msg, game.players[2].msg_or_ip, game.players[2].port_or_nil)
end

function sendGameOver(game, winner)
  -- winner = 0 for draw, else player number
  local score
  if winner ~= 0 then
    score = game.lastScore[winner] * game.multipliers[winner]
  end

  -- decide messages for both
  local player1_msg, player2_msg
  if winner == 0 then
    player1_msg, player2_msg = "<draw<<", "<draw<<"
  elseif winner == 1 then
    player1_msg, player2_msg = "<win<"..score.."<", "<lose<"..score.."<"
  elseif winner == 2 then
    player1_msg, player2_msg = "<lose<"..score.."<", "<win<"..score.."<"
  end

  -- send to both
  sendUDP(player1_msg, game.players[1].msg_or_ip, game.players[1].port_or_nil)
  sendUDP(player2_msg, game.players[2].msg_or_ip, game.players[2].port_or_nil)

end

function koiKoiUpdate(data, msg_or_ip, port_or_nil)
  local roomname, username, response = string.match(data, "?(%w+)?(%w+)?(%w+)")
  local game = games[roomname]

  if game then
    local playerNum
    if game.mode:sub(2,2) == "1" then
      if game.mode:sub(1,1) == "h" then
        -- just changed, so the player we want an update from is actually 2
        playerNum = 2
      else
        playerNum = 1
      end
    else
      if game.mode:sub(1,1) == "h" then
        -- just changed, so the player we want an update from is actually 1
        playerNum = 1
      else
        playerNum = 2
      end
    end

    if username == game.players[playerNum].username then
      if response == "continue" then
        if #game.hand1 == 0 and #game.hand2 == 0 and game.mode:sub(1,1) == "h" then
          -- they have run out of moves, so it is a draw...
          -- I don't know why they continued either.
          sendGameOver(game, 0)
        end
        sendContinueUpdate(game)
      elseif response == "stop" then
        sendGameOver(game, playerNum)
      end
    end
  end
end
