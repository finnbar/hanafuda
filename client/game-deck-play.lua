gameDeckPlay = {}

function gameDeckPlay.draw()
  drawCards(true)
  return gameDeckPlay
end

function gameDeckPlay.acceptMessage(data, msg)
  if data:sub(1,1) == ">" then
    updateYourDeckMove(data)
    return gameHandWait
  elseif data:sub(1,1) == "?" then
    updateYourDeckScore(data)
    return youScore
  elseif data:sub(1,1) == "<" then
    processGameOver(data)
    return gameOver
  end
  return gameDeckPlay
end

function gameDeckPlay.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- Check if it's on the table
    for i,j in pairs(playArea) do
      if pointerInCard(j, x, y) then
        if selectedCard and selectedCard.month == j.month then
          -- Okay, that's our move, send it off.
          udp:send(">"..roomname..">"..username..">"..j.charVal)
        end
      end
    end
    if pointerInCard(emptyCard, x, y) then
      udp:send(">"..roomname..">"..username..">")
    end
  end
  return gameDeckPlay
end

function gameDeckPlay.update(dt)
  updateAllCards(dt)
  return gameDeckPlay
end
