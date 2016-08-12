-- cards-tests, which has tests in it.

-- allow it to require the scoring code, as that's useful
package.path = package.path .. ";../server/?.lua"

require "useful"
require "cards-define"
require "cards-score"

function testAll(cards)
  for i=1,#tests do
    tests[i](cards)
    print("Test "..i.." passed!")
  end
end

function prettyPrintYaku(yaku)
  for i=1,#yaku do
    print(yaku[i][1].." points for "..yaku[i][2])
  end
end

function test1(cards)
  print("Testing: All of the cards from the bottom half (so 3+4 of every card). Should be 23 small and 1 ribbon.")
  local hand = {}
  for i=1,12 do
    for j=3,4 do
      table.insert(hand, cards[i][j])
    end
  end
  local res = scoreCards(hand)
  prettyPrintYaku(res)
  if not checkEquality(res,{{14, "Kasu +13"}}) then error("Test 1 Failed!") end
end

function test2(cards)
  print("Testing: Shikō vs Ame-Shikō. This hand contains Rainman.")
  local hand = {}
  for i,j in ipairs({3,8,11,12}) do
    table.insert(hand, cards[j][1])
  end
  local res = scoreCards(hand)
  prettyPrintYaku(res)
  if not checkEquality(res, {{7, "Ame-Shikō"}}) then error("Test 2 Failed!") end
end

function test3(cards)
  print("Testing: Shikō vs Ame-Shikō. This hand doesn't contain Rainman.")
  local hand = {}
  for i,j in ipairs({1,3,8,12}) do
    table.insert(hand, cards[j][1])
  end
  local res = scoreCards(hand)
  prettyPrintYaku(res)
  if not checkEquality(res, {{8, "Shikō"}}) then error("Test 3 Failed!") end
end

function test4(cards)
  print("Testing: Sake Cup Combos. This hand has both.")
  local hand = {cards[3][1], cards[8][1], cards[9][1]}
  local res = scoreCards(hand)
  prettyPrintYaku(res)
  if not checkEquality(res, {{5, "Tsukimi-zake"},{5, "Hanami-zake"}}) then error("Test 4 Failed!") end
end

function test5(cards)
  print("Testing: Sake Cup as a 1pt AND 10pt card. Here we have eight smalls and five mediums. So it should go for Tane +1.")
  local hand = {cards[9][1]}
  for i,j in ipairs({2,4,5,7}) do
    table.insert(hand,cards[j][1])
  end
  table.insert(hand,cards[11][2])
  for i=1,8 do
    table.insert(hand,cards[i][4])
  end
  local res = scoreCards(hand)
  prettyPrintYaku(res)
  if not checkEquality(res, {{2, "Tane +1"}}) then error("Test 5 Failed!") end
end

function test6(cards)
  print("Testing: Making sure it takes Inoshikachō where it can. This should go for Inoshikachō +2.")
  local hand = {}
  for i, j in ipairs({4,6,7,10}) do
    table.insert(hand,cards[j][1])
  end
  table.insert(hand,cards[11][2])
  local res = scoreCards(hand)
  prettyPrintYaku(res)
  if not checkEquality(res, {{7, "Inoshikachō +2"}}) then error("Test 6 Failed!") end
end

function test7(cards)
  print("Testing: The two ribbon combos (Akatan/Aotan), and making sure it takes both of them in their combined form.")
  local hand = {}
  for i, j in ipairs({1,2,3,4,6,9,10}) do
    table.insert(hand,cards[j][2])
  end
  local res = scoreCards(hand)
  prettyPrintYaku(res)
  if not checkEquality(res, {{11, "Akatan, Aotan no Chōfuku +1"}}) then error("Test 7 Failed!") end
end

tests = {test1, test2, test3, test4, test5, test6, test7}

cards = importCards(false)
testAll(cards)
