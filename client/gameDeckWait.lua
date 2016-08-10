gameDeckWait = {}

function gameDeckWait.draw()
  drawCards(false)
  return gameDeckWait
end

function gameDeckWait.acceptMessage(data, msg)
  if string.sub(data,1,1) == ">" then
    updateTheirDeckMove(data)
    return gameHandPlay
  end
  return gameDeckWait
end

function gameDeckWait.update(dt)
  updateAllCards(dt)
  return gameDeckWait
end
