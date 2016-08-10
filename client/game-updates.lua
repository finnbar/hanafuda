function updateYourHandMove(data)
  -- Update all the lists and data
  local match, newCard = string.match(data,"^>(.*)>(.)>$")
  if #match == 1 then
    moveByField(hand, playArea, "charVal", match)
  else
    -- move both to score pile
    moveByField(hand, yourScore, "charVal", match:sub(1,1))
    moveByField(playArea, yourScore, "charVal", match:sub(2,2))
  end
  local xc,yc = getCardFromChar(newCard:byte())
  deckFlip = cards[xc][yc]
  deckFlip.x, deckFlip.y = 70, 265

  selectedCard = deckFlip

  -- Move the cards (TODO)
end

function updateTheirHandMove(data)
  local match, newCard = string.match(data,"^>(.*)>(.)>$")

  -- Get the other players card and add to their score pile
  local theirX, theirY = getCardFromChar(match:byte()) -- first card is theirs
  local theirCard = cards[theirX][theirY]
  theirCard.x, theirCard.y = (opposingCards*90)-80, 10

  if #match == 1 then
    -- Put the new card in the playArea
    table.insert(playArea, theirCard)
  else
    -- move both to their score pile
    table.insert(theirScore, theirCard)
    moveByField(playArea, theirScore, "charVal", match:sub(2,2))
  end

  -- Deal with the deck flip
  local xc,yc = getCardFromChar(newCard:byte())
  deckFlip = cards[xc][yc]
  deckFlip.x, deckFlip.y = 70, 265

  opposingCards = opposingCards - 1 -- They must have used a card

  -- Now move the cards to the right places (TODO)
end

function updateYourDeckMove(data)
  local match = string.match(data,"^>(.*)>$")
  if #match == 0 then
    table.insert(playArea, deckFlip)
  elseif #match == 1 then
    table.insert(yourScore, deckFlip)
    moveByField(playArea, yourScore, "charVal", match)
  end
  deckFlip = nil

  -- Move the cards (TODO)
end

function updateTheirDeckMove(data)
  local match = string.match(data,"^>(.*)>$")
  if #match == 0 then
    table.insert(playArea, deckFlip)
    deckFlip = nil
  elseif #match == 1 then
    table.insert(theirScore, deckFlip)
    moveByField(playArea, theirScore, "charVal", match)
  end
  deckFlip = nil

  -- Move the cards (TODO)
end
