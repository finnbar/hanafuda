gameHandWait = {}

function gameHandWait.draw()
  drawCards(false)
  return gameHandWait
end

function gameHandWait.acceptMessage(data, msg)
  if string.sub(data,1,1) == ">" then
    updateTheirHandMove(data)
    return gameDeckWait
  end
  return gameHandWait
end
