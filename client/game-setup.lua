function setUpGame(data, firstPlayer)
  -- It's a new game state, which we should unpack.
  -- Format:
  -- !handaschars!playareaaschars!numberofcardsopponenthas!
  local charhand, charplay, opposingCards = string.match(data, "^!(.+)!(.+)!(%d)!$")
  local hnums = {string.byte(charhand,1,#charhand)}
  for i=1,#hnums do
    local xc,yc = getCardFromChar(hnums[i])
    table.insert(hand, cards[xc][yc])
    hand[i].x, hand[i].y = getHandCoordinates(i)
  end
  local pnums = {string.byte(charplay,1,#charplay)}
  for i=1,#pnums do
    pnums[i] = pnums[i] - 64
    local x,y = math.ceil(pnums[i]/4),(pnums[i]%4)
    if y==0 then y=4 end
    table.insert(playArea, cards[x][y])
    playArea[i].row, playArea[i].col, playArea[i].x, playArea[i].y = getPlayAreaCoords(true)
  end
  local r,c
  r, c, emptyCard.x, emptyCard.y = getPlayAreaCoords(false)

  if firstPlayer then
    setCanBeMatched()
  end

end

function getCardFromChar(c)
  c = c - 64
  local xc,yc = math.ceil(c/4),(c%4)
  if yc==0 then yc=4 end
  return xc, yc
end
