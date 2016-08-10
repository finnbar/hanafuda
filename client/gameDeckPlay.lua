gameDeckPlay = {}

function gameDeckPlay.draw()
  drawCards(true)
  return gameDeckPlay
end

function gameDeckPlay.acceptMessage(data, msg)
  if string.sub(data,1,1) == ">" then
    updateYourDeckMove(data)
    return gameHandWait
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
          selectedCard = nil
        end
      end
    end
  end
  return gameDeckPlay
end

function gameDeckPlay.update(dt)
  updateAllCards(dt)
  return gameDeckPlay
end
