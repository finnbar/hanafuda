game = {}

function game.update(dt)
  for i, j in pairs(hand) do
    hand[i] = updateCard(j)
    local willBeMatched = false
    for k, l in pairs(playArea) do
      if j.month == l.month then
        willBeMatched = true
      end
    end
    hand[i].canBeMatched = willBeMatched
  end
  return game
end

function game.acceptMessage(data, msg)
  if string.sub(data,1,1) == "!" then
    setUpGame(data)
  elseif string.sub(data,1,1) == "@" then
    mode = 1
    errormsg = "Choose a different username."
    return menu
  elseif string.sub(data,1,1) == "#" then
    mode = 2
    errormsg = "Room in use."
    return menu
  end
  return game
end

function game.draw()
  drawCards(true)
  return game
end

function game.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- First check if the card is in hand.
    for i,j in pairs(hand) do
      if pointerInCard(j, x, y) then
        if selectedCard == i then
          selectedCard = 0
        else
          selectedCard = i
        end
        return game
      end
    end
    -- Then check if it's on the table
    for i,j in pairs(playArea) do
      if pointerInCard(j, x, y) then
        if selectedCard ~= 0 and hand[selectedCard].month == j.month then
          -- Okay, that's our move, send it off.
          udp:send(">"..roomname..">"..username..">"..hand[selectedCard].charVal..j.charVal)
          selectedCard = 0
          return game
        end
      end
    end
  end
  selectedCard = 0
  return game
end

function getPlayAreaCoords()
  local x,y = 0,0
  for i=1,#playAreaLocations do
    for j=1,2 do
      if playAreaLocations[i][j] == 0 then
        x,y = i,j
        playAreaLocations[i][j] = 1
        break
      end
    end
    if x~=0 and y~=0 then break end
  end
  return (x*90)+100, y*150 + 40
end
