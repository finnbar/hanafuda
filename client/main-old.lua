require "cards"
require "tween"
local socket = require "socket"
local utf8 = require("utf8")

local address, port = "localhost", 12345

local bg = love.graphics.newImage("images/ukiyoebackground.jpg")
local largefont = love.graphics.newFont("intellecta-design_japonesa/Japonesa.ttf",80)
local midfont = love.graphics.newFont("intellecta-design_japonesa/Japonesa.ttf",50)
local hand = {}
local playArea = {}
local playAreaLocations = {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}
local cards = {}
local mode = 1
local roomname = ""
local username = ""
local errormsg = ""
local hiddencards = 8

--[[
Implementation notes!
Okay, so a client should open up and them immediately connect to the server. They should then enter their name, a room name and then be sent to that room (or hit random and be assigned a random room). The person that creates the room chooses the settings (number of rounds etc.) and then waits until the room is filled, and then the server sends "Start Game!" and then the game begins and it's all good.
]]

function love.load()
  cards = importCards(true)
  udp = socket.udp()
  udp:settimeout(0)
  udp:setpeername(address, port)
  love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
  repeat
    data, msg = udp:receive()
    if data then
      -- Do something with data.
      if string.sub(data,1,1) == "!" then
        -- It's a new game state, which we should unpack.
        -- Format:
        -- !handaschars!playareaaschars!numberofcardsopponenthas!
        charhand, charplay, nopp = string.match(data, "^!(.+)!(.+)!(%d)!$")
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
        mode = 3
      elseif string.sub(data,1,1) == "@" then
        mode = 1
        errormsg = "Choose a different username."
        username = ""
      elseif string.sub(data,1,1) == "#" then
        mode = 2
        errormsg = "Room in use."
        roomname = ""
      end
    elseif msg ~= 'timeout' then
      error("Network error: "..tostring(msg))
    end
  until not data
end

function love.draw()
  -- Draw background
  love.graphics.setColor(255,255,255)
  love.graphics.draw(bg,0,0,0,love.graphics.getWidth()/1280,love.graphics.getWidth()/1280)
  if mode == 1 then
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(largefont)
    love.graphics.printf("Please enter a username!",100,100,love.graphics.getWidth()-200,"center")
    love.graphics.printf(username,100,300,love.graphics.getWidth()-200,"center")
    love.graphics.setFont(midfont)
    love.graphics.printf(errormsg,100,500,love.graphics.getWidth()-200,"center")
  elseif mode == 2 then
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(largefont)
    love.graphics.printf("Please enter a room name!",100,100,love.graphics.getWidth()-200,"center")
    love.graphics.printf(roomname,100,300,love.graphics.getWidth()-200,"center")
    love.graphics.setFont(midfont)
    love.graphics.printf(errormsg,100,500,love.graphics.getWidth()-200,"center")
  else
    -- Draw hand
    for i, j in pairs(hand) do
      love.graphics.draw(j.image,j.x,j.y,0,j.size,j.size)
    end
    for i, j in pairs(playArea) do
      love.graphics.draw(j.image,j.x,j.y,0,j.size,j.size)
    end
  end
end

function love.mousepressed()

end

function love.textinput(t)
  if mode == 1 then
    username = username .. t
  elseif mode == 2 then
    roomname = roomname .. t
  end
end

function love.keypressed(key)
  if key == "backspace" then
    if mode == 1 then
      local byteoffset = utf8.offset(username, -1)
      if byteoffset then
        username = string.sub(username, 1, byteoffset - 1)
      end
    elseif mode == 2 then
      local byteoffset = utf8.offset(roomname, -1)
      if byteoffset then
        roomname = string.sub(roomname, 1, byteoffset - 1)
      end
    end
  elseif key == "return" then
    -- We want a room!
    if mode == 1 then
      mode = 2
    elseif mode == 2 then
      udp:send("#"..roomname.."@"..username)
    end
  end
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
  return (x*90)+100, y*150 + 30
end
