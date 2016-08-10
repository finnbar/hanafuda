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
