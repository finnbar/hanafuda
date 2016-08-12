gameHandWait = {}

function gameHandWait.draw()
  drawCards(false)
  return gameHandWait
end

function gameHandWait.acceptMessage(data, msg)
  if data:sub(1,1) == ">" then
    updateTheirHandMove(data)
    return gameDeckWait
  elseif data:sub(1,1) == "?" then
    updateTheirHandScore(data)
    return theyScore
  end
  return gameHandWait
end

function gameHandWait.update(dt)
  updateAllCards(dt)
  return gameHandWait
end
