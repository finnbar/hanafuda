theyScore = {}

function theyScore.draw()
  drawCards(false)
  drawOverlay()
  return theyScore
end

function theyScore.acceptMessage(data, msg)
  return theyScore
end

function drawOverlay()

  -- draw the overlay semi-transparently
  love.graphics.setColor(0, 153, 255,200) -- change colour when someone gives an opinion
  love.graphics.rectangle("fill", 300, 230, 400, 200)

  -- tell them what happened
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.setFont(midfont)
  love.graphics.printf("They scored!",300,240,400,"center")

  -- give the actual score (andd later, moves)
  love.graphics.setFont(smallfont)
  love.graphics.printf("Will they continue...", 310, 320, 390, "left")

end
