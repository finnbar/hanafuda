function setUpGame(data)
  -- It's a new game state, which we should unpack.
  -- Format:
  -- !handaschars!playareaaschars!numberofcardsopponenthas!
  charhand, charplay, opposingCards = string.match(data, "^!(.+)!(.+)!(%d)!$")
  hnums = {string.byte(charhand,1,#charhand)}
  for i=1,#hnums do
    hnums[i] = hnums[i] - 64
    local xc,yc = math.ceil(hnums[i]/4),(hnums[i]%4)
    if yc==0 then yc=4 end
    table.insert(hand, cards[xc][yc])
    hand[i].x = 90*i - 80
    hand[i].y = 520
  end
  pnums = {string.byte(charplay,1,#charplay)}
  for i=1,#pnums do
    pnums[i] = pnums[i] - 64
    local x,y = math.ceil(pnums[i]/4),(pnums[i]%4)
    if y==0 then y=4 end
    table.insert(playArea, cards[x][y])
    playArea[i].x, playArea[i].y = getPlayAreaCoords()
  end
end
