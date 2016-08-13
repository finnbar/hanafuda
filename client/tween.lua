-- IT'S TIME FOR TWEEN TWO POINT OH
-- Features: you can now have multiple tweens in sequence, and let them run!
-- Note that easing is still linear, maybe Kirsty will have some magic non-linear easing to apply.

function createTweens(t)
  -- t is a list of tweens in form {start, end, length}.
  local transitions = {}
  for i,trans in pairs(t) do
    table.insert(transitions, {startNum = trans[1], endNum = trans[2], length = trans[3], currentTime = 0})
  end

  local finalNum = transitions[#transitions].endNum

  return {finalNum = finalNum, transitions = transitions} -- A table with its final position and a list of transitions (tween tables)
end

function updateTweens(t,dt) -- tween, deltatime
  local trans = t.transitions
  if #trans ~= 0 then
    trans[1].currentTime = trans[1].currentTime + dt -- update currentTime
    if trans[1].currentTime >= trans[1].length then
      local dt = trans[1].currentTime - trans[1].length
      table.remove(trans,1)
      if trans[1] then
        -- transfer remaining time to next tween
        trans[1].currentTime = trans[1].currentTime + dt
      end
    end
  end
  return t -- returns tweens
end

function valueTween(t)
  local trans = t.transitions
  if #trans ~= 0 then
    local currentTween = trans[1]
    return currentTween.startNum + ((currentTween.endNum - currentTween.startNum)*(currentTween.currentTime / currentTween.length))
  else
    return t.finalNum
  end
end

function isTweenFinished(t)
  return #t.transitions == 0
end
