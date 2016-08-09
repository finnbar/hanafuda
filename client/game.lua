game = {}

local cardBacks = love.graphics.newImage("assets/images/back.png")

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
  for i, j in pairs(hand) do
    if selectedCard ~= 0 and selectedCard ~= i then
      love.graphics.setColor(255,255,255,125)
    end
    pasteCard(j)
    if j.canBeMatched then
      love.graphics.setColor(255,255,0,255)
      love.graphics.polygon("fill", {(90*i) - 44.5, 505,(90*i) - 38, 515,(90*i) - 31.5, 505})
    end
    love.graphics.setColor(255,255,255,255)
  end
  for i, j in pairs(playArea) do
    if selectedCard ~= 0 then
      if hand[selectedCard].month == j.month then
        love.graphics.setColor(255,255,255,255)
      else
        love.graphics.setColor(255,255,255,125)
      end
    else
      love.graphics.setColor(255,255,255,255)
    end
    pasteCard(j)
  end
  love.graphics.setColor(255,255,255,255)
  for i=1,opposingCards do
    love.graphics.draw(cardBacks, (i*90)-80, 10)
  end
  for i=-5,0 do
    love.graphics.draw(cardBacks, 70 + (2*i), 265 + (2*i))
  end
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
