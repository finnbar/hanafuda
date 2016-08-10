local cardBacks = love.graphics.newImage("assets/images/back.png")

function drawCards(yourGo)
  for i, j in pairs(hand) do
    if yourGo and selectedCard and selectedCard.charVal ~= j.charVal then
      love.graphics.setColor(255,255,255,125)
    end
    pasteCard(j)
    if yourGo and j.canBeMatched then
      love.graphics.setColor(255,255,0,255)
      love.graphics.polygon("fill", {(90*i) - 44.5, 505,(90*i) - 38, 515,(90*i) - 31.5, 505})
    end
    love.graphics.setColor(255,255,255,255)
  end
  for i, j in pairs(playArea) do
    if yourGo and selectedCard then
      if selectedCard.month == j.month then
        love.graphics.setColor(255,255,255,255)
      else
        love.graphics.setColor(255,255,255,125)
      end
    else
      love.graphics.setColor(255,255,255,255)
    end
    pasteCard(j)
  end

  -- Draw the backs of the oppositions cards
  love.graphics.setColor(255,255,255,255)
  for i=1,opposingCards do
    love.graphics.draw(cardBacks, (i*90)-80, 10)
  end

  -- Draw the deck
  love.graphics.setColor(255,255,255,255)
  for i=-5,0 do
    love.graphics.draw(cardBacks, 70 + (2*i), 265 + (2*i))
  end

  -- Draw the flip, if there is one
  if deckFlip then
    love.graphics.setColor(255,255,255,255)
    pasteCard(deckFlip)
  end
end

function pasteCard(cardObject)
  love.graphics.draw(cardObject.image, cardObject.x, cardObject.y, 0, cardObject.size, cardObject.size)
end
