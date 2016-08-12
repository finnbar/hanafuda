theyScore = {}

function theyScore.draw()
  drawCards(false)
  drawOverlay()
  return theyScore
end

function theyScore.acceptMessage(data, msg)
  if data:sub(1,1) == "?" then
    -- continue!
    local newCard = string.match(data, "%?(.*)%?")
    if #newCard == 0 then
      return gameHandPlay
    else
      processFlip(newCard)
      return gameDeckWait
    end
  elseif data:sub(1,1) == "<" then
    -- game over
    processGameOver(data)
    return gameOver
  end
  return theyScore
end

function drawOverlay()

  -- draw the overlay semi-transparently
  love.graphics.setColor(255, 255, 255,200)
  love.graphics.rectangle("fill", 300, 230, 400, 200)

  -- tell them what happened
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.setFont(midfont)
  love.graphics.printf("They scored!",300,250,400,"center")

  love.graphics.setFont(smallfont)
  love.graphics.printf("Will they continue...", 310, 340, 390, "left")

end
