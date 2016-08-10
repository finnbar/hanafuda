gameHandPlay = {}

function gameHandPlay.draw()
  drawCards(true)
  return gameHandPlay
end

function gameHandPlay.update(dt)
  game.update(dt)
  return gameHandPlay
end
