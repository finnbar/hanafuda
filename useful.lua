-- Useful. Has useful stuff!

function checkEquality(t1, t2)
  if #t1 ~= #t2 then return false end
  for i=1,#t1 do
    if type(t1[i]) == "table" and type(t2[i]) == "table" then
      if not checkEquality(t1[i],t2[i]) then return false end
    else
      if t1[i] ~= t2[i] then return false end
    end
  end
  return true
end

function copy(obj, seen)
  -- From http://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function randSort(t) -- THANKS THE INTERNET! ("no problem" - The Internet)
	for i = #t, 2, -1 do -- backwards
    local r = math.random(i)
    t[i], t[r] = t[r], t[i] -- swap the randomly selected item to position i
	end
	return t
end

function searchForCard(cards, charVal)
  for index,card in pairs(cards) do
    if card.charVal == charVal then
      return card
    end
  end
end
