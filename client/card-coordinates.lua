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
