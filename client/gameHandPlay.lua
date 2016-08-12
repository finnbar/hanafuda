gameHandPlay = {}

function gameHandPlay.draw()
  drawCards(true)
  return gameHandPlay
end

function gameHandPlay.update(dt)
  updateAllCards(dt)
  return gameHandPlay
end

function gameHandPlay.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- First check if the card is in hand.
    for i,j in pairs(hand) do
      if pointerInCard(j, x, y) then
        if selectedCard and selectedCard.charVal == j.charVal then
          selectedCard = nil
        else
          selectedCard = j
        end
        return gameHandPlay
      end
    end
    -- Then check if it's on the table
    for i,j in pairs(playArea) do
      if pointerInCard(j, x, y) then
        if selectedCard and selectedCard.month == j.month then
          -- Okay, that's our move, send it off.
          udp:send(">"..roomname..">"..username..">"..selectedCard.charVal..j.charVal)
          selectedCard = nil
        end
      end
    end
    -- check if it is the empty card
    if pointerInCard(emptyCard, x, y) then
      if selectedCard then
        udp:send(">"..roomname..">"..username..">"..selectedCard.charVal)
        selectedCard = nil
      end
    end
  end
  selectedCard = nil
  return gameHandPlay
end

function gameHandPlay.acceptMessage(data, msg)
  if data:sub(1,1) == "~" then
    -- failure message somehow (deal with this later)
  elseif data:sub(1,1) == ">" then
    updateYourHandMove(data)
    return gameDeckPlay
  elseif data:sub(1,1) == "?" then
    updateYourHandScore(data)
    return youScore
  elseif data:sub(1,1) == "<" then
    processGameOver(data)
    return gameOver
  end
  return gameHandPlay
end
