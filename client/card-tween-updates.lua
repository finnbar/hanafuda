function updateCard(cardObject, dt)
  -- Apply tween
  for i,j in pairs(cardObject.tweens) do
    cardObject.tweens[i] = updateTweens(j, dt)
    local newval = valueTween(cardObject.tweens[i])
    if newval ~= nil then
      cardObject[i] = newval
    end
  end
  return cardObject
end

function updateAllCards(dt)
  for i,j in pairs(yourScore) do
    updateCard(j, dt)
  end

  for i,j in pairs(theirScore) do
    updateCard(j, dt)
  end

  for i,j in pairs(playArea) do
    updateCard(j, dt)
  end

  for i,j in pairs(hand) do
    updateCard(j, dt)
  end

  if deckFlip then
    updateCard(deckFlip, dt)
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
  local somethingMoving = false

  for _,j in pairs(yourScore) do
    somethingMoving = somethingMoving or isCardMoving(j)
  end

  for _,j in pairs(theirScore) do
    somethingMoving = somethingMoving or isCardMoving(j)
  end

  for _,j in pairs(playArea) do
    somethingMoving = somethingMoving or isCardMoving(j)
  end

  for _,j in pairs(hand) do
    somethingMoving = somethingMoving or isCardMoving(j)
  end

  if deckFlip then
    somethingMoving = somethingMoving or isCardMoving(deckFlip)
  end

  return somethingMoving
end
