gameDeckWait = {}

function gameDeckWait.draw()
  drawCards(false)
  return gameDeckWait
end

function gameDeckWait.acceptMessage(data, msg)
  if data:sub(1,1) == ">" then
    updateTheirDeckMove(data)
    return gameHandPlay
  elseif data:sub(1,1) == "?" then
    updateTheirDeckScore(data)
    return theyScore
  end
  return gameDeckWait
end

function gameDeckWait.update(dt)
  updateAllCards(dt)
  return gameDeckWait
end
