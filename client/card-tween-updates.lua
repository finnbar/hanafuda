function updateCard(cardObject, dt)
  -- Apply tween
  for i,j in pairs(cardObject.tweens) do
    updateTweens(j, dt)
    local newval = valueTween(cardObject.tweens[i])
    if newval ~= nil then
      cardObject[i] = newval
    end
  end
  return cardObject
end

function updateAllCards(dt)
  local cardSets = {yourScore, theirScore, playArea, hand, {deckFlip}}
  for _,cardSet in pairs(cardSets) do
    for _,j in pairs(cardSet) do
      updateCard(j, dt)
    end
  end
end

function isCardMoving(card)
  for i,j in pairs(card.tweens) do
    if not isTweenFinished(j) then
      return true
    end
  end
  return false
end

function isAnyMoving()
  local cardSets = {yourScore, theirScore, playArea, hand, {deckFlip}}
  local somethingMoving = false

  for _, cardSet in pairs(cardSets) do
    for _,j in pairs(yourScore) do
      if isCardMoving(j) then
        return true
      end
    end
  end

  return false
end
