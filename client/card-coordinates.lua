local yourScoreCount = {small = 0, ribbon = 0, medium = 0, large = 0}
local theirScoreCount = {small = 0, ribbon = 0, medium = 0, large = 0}

function getPlayAreaCoords(addToLocations)
  for i=1,#playAreaLocations do
    for j=1,2 do
      if playAreaLocations[i][j] == 0 then
        if addToLocations then
          playAreaLocations[i][j] = 1
        end
        return i, j,(i*90)+100, j*150+40
      end
    end
  end
end

function removeFromPlayAreaLocations(card)
  if card.row and card.col then
    playAreaLocations[card.row][card.col] = 0
  end
  card.row, card.col = nil, nil
end

function getScoreCoords(card, yourPile)
  -- uses the card and current cards in the score pile to place cards

  -- Get current count of large and small cards
  local scoreCount
  if yourPile then
    scoreCount = yourScoreCount
  else
    scoreCount = theirScoreCount
  end

  local x,y,extra

  if card.value == 1 then
    x = 750
    extra = 10 * scoreCount.small
    scoreCount.small = scoreCount.small + 1
  elseif card.value == 5 then
    x = 790
    extra = 20 * scoreCount.ribbon
    scoreCount.ribbon = scoreCount.ribbon + 1
  elseif card.value == 10 or card.value == 7 then
    x = 830
    extra = 20 * scoreCount.medium
    scoreCount.medium = scoreCount.medium + 1
  else
    x = 870
    extra = 20 * scoreCount.large
    scoreCount.large = scoreCount.large + 1
  end

  if yourPile then
    y = 450 + extra
  else
    y = 50 + extra
  end

  return x,y
end

function getHandCoordinates(i)
  return 90*i - 80, 520
end
