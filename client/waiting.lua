waiting = {}

function waiting.draw()
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(largefont)
  love.graphics.printf("Waiting for your partner...",100,100,love.graphics.getWidth()-200,"center")
  return waiting
end

function waiting.acceptMessage(data, msg)
  if string.sub(data,1,1) == "!" then
    setUpGame(data, true)
    return gameHandPlay
  end
  return waiting
end
