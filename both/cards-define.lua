-- Import all of the cards, give them attributes.

function importCards(client)
  -- Okay, lots of stuff here.
  -- We're constructing a cards array with their image and value.
  -- We're also giving each card a "charVal", which is a one-character representation of the card being sent.
  local cards = {}
  for i=1,12 do
    table.insert(cards,{})
    for j=1,4 do
      table.insert(cards[i],{})
      cards[i][j] = {image = importImage(client, i, j), value = 1, month = i, number = j, charVal = string.char(((i-1)*4)+j+64), x = 0, y = 0, size = 1, tweens = {}, canBeMatched = false}
    end
  end
  -- Special case, dammit November
  cards[11][3].value = 5
  -- Most of the [2] cards are Ribbons.
  for i=1,12 do
    cards[i][2].value = 5
  end
  -- Except for these three annoyances:
  cards[12][2].value = 1
  cards[11][2].value = 10
  cards[8][2].value = 10
  -- Now, all of the cards are annoyances here!
  local bigcards = {1,3,8,11,12}
  for i=1,12 do
    cards[i][1].value = 10
  end
  for i,j in pairs(bigcards) do
    cards[j][1].value = 20
  end
  -- And finally, the Sake Cup, which is a world of its own.
  cards[9][1].value = 7 -- 7 is a good number.
  return cards
end

function importImage(client,i,j)
  local months = {"january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"}
  if client then
    return love.graphics.newImage("assets/images/cards/"..months[i]..j..".png")
  else
    return ""
  end
end
