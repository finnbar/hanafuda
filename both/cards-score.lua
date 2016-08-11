-- Define combos:

local previousScore = {}

function scoreBig(bigs)
  if #bigs < 3 then
    return {0, ""}
  end
  -- Do we have Rainman?
  local hasRainman = false
  for i=1,#bigs do
    if bigs[i].month == 11 then
      hasRainman = true
      break
    end
  end
  if #bigs == 3 and not hasRainman then
    return {5, "Sankō"}
  elseif #bigs == 4 then
    if hasRainman then
      return {7, "Ame-Shikō"}
    else
      return {8, "Shikō"}
    end
  elseif #bigs == 5 then
    return {15, "Gokō"}
  end
end

function scoreTane(mediums)
  if #mediums < 5 then
    return {0, ""}
  elseif #mediums == 5 then
    return {1, "Tane"}
  else
    return {#mediums - 4, "Tane +"..(#mediums - 5)}
  end
end

function scoreMediums(mediums)
  local hasCards = {false, false, false}
  for i=1,#mediums do
    card = mediums[i]
    if card.month == 6 then
      hasCards[1] = true
    elseif card.month == 7 then
      hasCards[2] = true
    elseif card.month == 10 then
      hasCards[3] = true
    end
  end
  if hasCards[1] and hasCards[2] and hasCards[3] then
    if #mediums == 3 then
      return {5, "Inoshikachō"}
    else
      return {#mediums + 2, "Inoshikachō +"..(#mediums - 3)}
    end
  else
    return scoreTane(mediums)
  end
end

function scoreRibbons(ribbons)
  local blueRibbons = 0
  local poetryRibbons = 0
  for i=1,#ribbons do
    if ribbons[i].month == 6 or ribbons[i].month == 9 or ribbons[i].month == 10 then -- june, oct, sept
      blueRibbons = blueRibbons + 1
    elseif ribbons[i].month < 4 and ribbons[i].month > 0 then -- march, jan, feb
      poetryRibbons = poetryRibbons + 1
    end
  end
  if blueRibbons == 3 and poetryRibbons == 3 then
    if #ribbons > 6 then
      return {#ribbons + 4, "Akatan, Aotan no Chōfuku +"..(#ribbons - 6)}
    else
      return {10, "Akatan, Aotan no Chōfuku"}
    end
  elseif blueRibbons == 3 then
    if #ribbons > 3 then
      return {#ribbons + 2, "Aotan +"..(#ribbons - 3)}
    else
      return {5, "Aotan"}
    end
  elseif poetryRibbons == 3 then
    if #ribbons > 3 then
      return {#ribbons + 2, "Akatan +"..(#ribbons - 3)}
    else
      return {5, "Akatan"}
    end
  else
    -- Tanzaku
    if #ribbons > 5 then
      return {#ribbons - 4, "Tanzaku +"..(#ribbons - 5)}
    elseif #ribbons == 5 then
      return {1, "Tanzaku"}
    end
  end
  return {0, ""}
end

function scoreSmall(smalls)
  if #smalls < 10 then
    return {0, ""}
  elseif #smalls == 10 then
    return {1, "Kasu"}
  else
    return {#smalls - 9, "Kasu +"..(#smalls - 10)}
  end
end

function scoreSake(bigs)
  local hasMoon = false
  local hasBlossom = false
  for i=1,#bigs do
    if bigs[i].month == 8 then hasMoon = true end
    if bigs[i].month == 3 then hasBlossom = true end
  end
  local response = {}
  if hasMoon then
    table.insert(response,{5, "Tsukimi-zake"})
  end
  if hasBlossom then
    table.insert(response,{5, "Hanami-zake"})
  end
  return response
end

function scoreCards(cards)
  -- First, split cards up into sets:
  local smalls, ribbons, mediums, bigs, sakeCup = splitCards(cards)
  if sakeCup then
    print(#smalls.." smalls, "..#ribbons.." ribbons, "..#mediums.." mediums, "..#bigs.." bigs and the Sake Cup.")
  else
    print(#smalls.." smalls, "..#ribbons.." ribbons, "..#mediums.." mediums, "..#bigs.." bigs and no Sake Cup.")
  end
  local yaku = {}
  table.insert(yaku,scoreRibbons(ribbons))
  table.insert(yaku,scoreBig(bigs))
  -- Sake Cup nonsense:
  if sakeCup then
    local sakeResponse = scoreSake(bigs)
    for i=1,#sakeResponse do
      table.insert(yaku,sakeResponse[i])
    end
    -- Now, see which scores more, whether you have Sake as a 1pt or 10pt card
    local newmediums = copy(mediums)
    local newsmalls = copy(smalls)
    table.insert(newmediums,sakeCup)
    table.insert(newsmalls,sakeCup)
    table.insert(yaku,scoreMediums(newmediums))
    table.insert(yaku,scoreSmall(newsmalls))
  else
    table.insert(yaku,scoreMediums(mediums))
    table.insert(yaku,scoreSmall(smalls))
  end
  -- Now remove all extra {0,""}
  -- I don't want to go through a table and remove as we go as that makes weird stuff happen with the for loop, so let's just make a new table.
  local resultYaku = {}
  for i=1,#yaku do
    if yaku[i][1] ~= 0 then
      table.insert(resultYaku, yaku[i])
    end
  end
  return resultYaku
end

function splitCards(cards)
  local smalls, ribbons, mediums, bigs, hasSakeCup = {}, {}, {}, {}, false
  for i=1,#cards do
    v = cards[i].value
    if v == 1 then
      table.insert(smalls,cards[i])
    elseif v == 5 then
      table.insert(ribbons,cards[i])
    elseif v == 7 then
      hasSakeCup = cards[i]
    elseif v == 10 then
      table.insert(mediums,cards[i])
    elseif v == 20 then
      table.insert(bigs,cards[i])
    end
  end
  return smalls, ribbons, mediums, bigs, hasSakeCup
end

function checkIfScores(cards)
  local yaku = scoreCards(cards)
  if not checkEquality(previousScore, yaku) then
    -- Score!
    local total = 0
    for i=1,#yaku do
      total = total + yaku[i][1]
    end
    previousScore = copy(yaku)
    return {total, yaku}
  end
end

function numericalScore(cards)
  local yaku = scoreCards(cards)
  local total = 0
  for i=1,#yaku do
    total = total + yaku[i][1]
  end
  return total
end
