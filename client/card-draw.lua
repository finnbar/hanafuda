local cardBacks = love.graphics.newImage("assets/images/back.png")
local emptyImg = love.graphics.newImage("assets/images/empty.png")

emptyCard = {image = emptyImg, x = 0, y = 0, size = 1}

function drawCards(yourGo)

  -- Draw the deck
  -- Do this first so anything else is on top
  love.graphics.setColor(255,255,255,255)
  for i=-5,0 do
    love.graphics.draw(cardBacks, 70 + (2*i), 265 + (2*i))
  end

  -- Draw the empty space
  -- Again, do this early so it is at the bottom
  if yourGo then
    pasteCard(emptyCard)
  end

  -- Draw their hand
  for i, j in pairs(hand) do
    if yourGo and selectedCard and selectedCard.charVal ~= j.charVal then
      love.graphics.setColor(255,255,255,125)
    end
    pasteCard(j)
    if yourGo and j.canBeMatched then
      love.graphics.setColor(255,255,0,255)
      love.graphics.polygon("fill", {j.x + 35.5, 505,j.x + 42, 515,j.x + 48.5, 505})
    end
    love.graphics.setColor(255,255,255,255)
  end

  -- Draw the play area
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

  -- Draw all cards in both score piles
  love.graphics.setColor(255,255, 255, 255)
  for i,j in pairs(yourScore) do
    pasteCard(j)
  end

  for i,j in pairs(theirScore) do
    pasteCard(j)
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
