gameHandPlay = {}

function gameHandPlay.draw()
  drawCards(true)
  return gameHandPlay
end

function gameHandPlay.update(dt)
  for i, j in pairs(hand) do
    hand[i] = updateCard(j)
    local willBeMatched = false
    for k, l in pairs(playArea) do
      if j.month == l.month then
        willBeMatched = true
      end
    end
    hand[i].canBeMatched = willBeMatched
  end
  return gameHandPlay
end

function gameHandPlay.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- First check if the card is in hand.
    for i,j in pairs(hand) do
      if pointerInCard(j, x, y) then
        if selectedCard == i then
          selectedCard = 0
        else
          selectedCard = i
        end
        return gameHandPlay
      end
    end
    -- Then check if it's on the table
    for i,j in pairs(playArea) do
      if pointerInCard(j, x, y) then
        if selectedCard ~= 0 and hand[selectedCard].month == j.month then
          -- Okay, that's our move, send it off.
          udp:send(">"..roomname..">"..username..">"..hand[selectedCard].charVal..j.charVal)
          selectedCard = 0
        end
      end
    end
  end
  selectedCard = 0
  return gameHandPlay
end

function gameHandPlay.acceptMessage(data, msg)
  if string.sub(data,1,1) == "~" then
    -- failure message somehow (deal with this later)
  elseif string.sub(data,1,1) == ">" then
    updateYourHandMove(data)
    return gameDeckPlay
  end
  return gameHandPlay
end
