-- IT'S TIME FOR TWEEN TWO POINT OH
-- Features: you can now have multiple tweens in sequence, and let them run!
-- Note that easing is still linear, maybe Kirsty will have some magic non-linear easing to apply.

function createTweens(t)
  -- t is a list of tweens in form {start, end, length}.
  local tweens = {}
  for i,j in pairs(t) do
    table.insert(tweens, j)
    table.insert(tweens[#tweens], 0) -- add the last field, currentTime
  end
  return tweens -- a list of tweens in form {start, end, length, currentTime}
end

function updateTweens(t,dt) -- tween, deltatime
  if t[1] ~= nil then
    t[1][4] = t[1][4] + dt -- update currentTime
    if t[1][4] >= t[1][3] then
      local dt = t[1][4] - t[1][3]
      table.remove(t,1)
      if t[1] ~= nil then
        t[1][4] = t[1][4] + dt
      end
    end
    return t -- returns tweens if there is still motion, else false
  else
    return {}
  end
end

function valueTween(t)
  if #t ~= 0 then
    local currentTween = t[1]
    return currentTween[1] + ((currentTween[2] - currentTween[1])*(currentTween[4] / currentTween[3]))
  else return nil end
end
