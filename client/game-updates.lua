function updateYourHandMove(data)
  local match, newCard = string.match(data,"^>(.*)>(.)>$")
  processYourHandMatch(match)
  processFlip(newCard)
end

function updateTheirHandMove(data)
  local match, newCard = string.match(data,"^>(.*)>(.)>$")
  processTheirHandMatch(match)
  processFlip(newCard)
end

function updateYourDeckMove(data)
  local match = string.match(data,"^>(.*)>$")
  processYourDeckMatch(match)
end

function updateTheirDeckMove(data)
  local match = string.match(data,"^>(.*)>$")
  processTheirDeckMatch(match)
end

function updateYourHandScore(data)
  local score,match = string.match(data, "%?(%d+)%?(.*)%?") -- oops, forgot ? was regex special character
  totalScore = tonumber(score)
  processYourHandMatch(match)
end

function updateTheirHandScore(data)
  local score,match = string.match(data, "%?(%d+)%?(.*)%?") -- oops, forgot ? was regex special character
  totalScore = tonumber(score)
  processTheirHandMatch(match)
end

function updateYourDeckScore(data)
  local score,match = string.match(data, "%?(%d+)%?(.*)%?") -- oops, forgot ? was regex special character
  totalScore = tonumber(score)
  processYourDeckMatch(match)
end

function updateTheirDeckScore(data)
  local score,match = string.match(data, "%?(%d+)%?(.*)%?") -- oops, forgot ? was regex special character
  totalScore = tonumber(score)
  processTheirDeckMatch(match)
end

function processFlip(newCard)
  local xc,yc = getCardFromChar(newCard:byte())
  deckFlip = cards[xc][yc]
  deckFlip.x, deckFlip.y = 70, 265

  selectedCard = deckFlip

  -- Move empty card into the next position
  local r,c
  r, c, emptyCard.x, emptyCard.y = getPlayAreaCoords(false)
end


function processYourHandMatch(match)
  -- Update all the lists and data
  if #match == 1 then
    local toPlace = searchByField(hand, "charVal", match)
    moveByField(hand, playArea, "charVal", match)
    moveToPlayArea(toPlace, 0.5)
  else
    -- move both to score pile
    local handToMove = searchByField(hand, "charVal", match:sub(1, 1))
    local newx1, newy1 = getScoreCoords(handToMove, true)
    moveByField(hand, yourScore, "charVal", match:sub(1,1))

    local playAreaToMove = searchByField(playArea, "charVal", match:sub(2, 2))
    local newx2, newy2 = getScoreCoords(playAreaToMove, true)
    moveByField(playArea, yourScore, "charVal", match:sub(2,2))
    removeFromPlayAreaLocations(playAreaToMove)

    moveBothToScorePile(handToMove, playAreaToMove, newx1, newy1, newx2, newy2, 0.25, 0.25)
  end

  -- clear up and move along everything whatever match type
  removeCanBeMatched() -- unmatch all, so no triangles
  moveHandAlong() -- move everything along to make up for removed card
end

function processTheirHandMatch(match)
  -- Get the other players card and move to their hand
  local theirX, theirY = getCardFromChar(match:byte()) -- first card is theirs
  local theirCard = cards[theirX][theirY]
  theirCard.x, theirCard.y = (opposingCards*90)-80, 10

  if #match == 1 then
    -- Put the new card in the playArea
    table.insert(playArea, theirCard)
    moveToPlayArea(theirCard, 0.5)
  else
    -- move both to their score pile
    local newx1, newy1 = getScoreCoords(theirCard, false)
    table.insert(theirScore, theirCard)

    local playAreaToMove = searchByField(playArea, "charVal", match:sub(2, 2))
    local newx2, newy2 = getScoreCoords(playAreaToMove, false)
    moveByField(playArea, theirScore, "charVal", match:sub(2,2))
    removeFromPlayAreaLocations(playAreaToMove)

    moveBothToScorePile(theirCard, playAreaToMove, newx1, newy1, newx2, newy2, 0.25, 0.25)
  end
  opposingCards = opposingCards - 1 -- They must have used a card
end

function processYourDeckMatch(match)
  if #match == 0 then
    table.insert(playArea, deckFlip)
    moveToPlayArea(deckFlip, 0.5)
  elseif #match == 1 then
    local newx1, newy1 = getScoreCoords(deckFlip, true)
    table.insert(yourScore, deckFlip)

    local playAreaToMove = searchByField(playArea, "charVal", match)
    local newx2, newy2 = getScoreCoords(playAreaToMove, true)
    moveByField(playArea, yourScore, "charVal", match)
    removeFromPlayAreaLocations(playAreaToMove)

    moveBothToScorePile(deckFlip, playAreaToMove, newx1, newy1, newx2, newy2, 0.25, 0.25)
  end
  deckFlip = nil
  selectedCard = nil

  local r,c
  r, c, emptyCard.x, emptyCard.y = getPlayAreaCoords(false)
end

function processTheirDeckMatch(match)
  if #match == 0 then
    table.insert(playArea, deckFlip)
    moveToPlayArea(deckFlip, 0.5)
  elseif #match == 1 then
    local newx1, newy1 = getScoreCoords(deckFlip, false)
    table.insert(theirScore, deckFlip)

    local playAreaToMove = searchByField(playArea, "charVal", match)
    local newx2, newy2 = getScoreCoords(playAreaToMove, false)
    moveByField(playArea, theirScore, "charVal", match)
    removeFromPlayAreaLocations(playAreaToMove)

    moveBothToScorePile(deckFlip, playAreaToMove, newx1, newy1, newx2, newy2, 0.25, 0.25)
  end
  deckFlip = nil
  selectedCard = nil

  local r,c
  r, c, emptyCard.x, emptyCard.y = getPlayAreaCoords(false)

  setCanBeMatched() -- set canBeMatched here as computing repeatedly in update wastes time
end

function moveBothToScorePile(card1, card2, newx1, newy1, newx2, newy2, time1, time2)
  card1.tweens.x = createTweens({{card1.x, card2.x, time1}, {card2.x, newx1, time2}})
  card1.tweens.y = createTweens({{card1.y, card2.y, time1}, {card2.y, newy1, time2}})
  card1.tweens.size = createTweens({{1, 1, time1}, {1, 0.4, time2}})

  card2.tweens.x = createTweens({{card2.x, card2.x, time1}, {card2.x, newx2, time2}})
  card2.tweens.y = createTweens({{card2.y, card2.y, time1}, {card2.y, newy2, time2}})
  card2.tweens.size = createTweens({{1, 1, time1}, {1, 0.4, time2}})
end

function moveToPlayArea(card, time)
  local newx, newy
  card.row, card.col, newx, newy = getPlayAreaCoords(true)
  card.tweens.x = createTweens({{card.x, newx, time}})
  card.tweens.y = createTweens({{card.y, newy, time}})
end

function removeCanBeMatched()
  for _,card in pairs(hand) do
    card.canBeMatched = false
  end
end

function setCanBeMatched()
  for _, j in pairs(hand) do
    j.canBeMatched = false
    for _, l in pairs(playArea) do
      if j.month == l.month then
        j.canBeMatched = true
      end
    end
  end
end

function moveHandAlong()
  for i,j in pairs(hand) do
    local newx, newy = getHandCoordinates(i)
    j.tweens.x = createTweens({{j.x, newx, 0.25}})
    j.tweens.y = createTweens({{j.y, newy, 0.25}})
  end
end
