package.path = package.path .. ";../both/?.lua"

requires = {"cards-define","useful", "card-coordinates", "card-draw", "game-setup", "game-updates", "game-deck-play", "game-deck-wait", "game-hand-play", "game-hand-wait", "gameover", "menu", "they-score", "tween", "waiting", "you-score"}
for i,j in pairs(requires) do
  require(j)
end
local socket = require "socket"
utf8 = require("utf8")

local address, port = "localhost", 12345

japonesaFile = "assets/intellecta-design_japonesa/Japonesa.ttf"
japaneseStyleFile = "assets/jonathan-s-harris_japanese-style/Japanese Style.ttf"

bg = love.graphics.newImage("assets/images/ukiyoebackground.jpg")
largefont = love.graphics.newFont(japaneseStyleFile, 80)
midfont = love.graphics.newFont(japaneseStyleFile, 50)
smallfont = love.graphics.newFont(japaneseStyleFile,30)
tinyfont = love.graphics.newFont(japaneseStyleFile, 20)

local gamestate = menu
errormsg = ""
mode = 1
cards = {}

-- Game variables
hand = {}
selectedCard = nil
playArea = {}
playAreaLocations = {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}
opposingCards = 8
deckFlip = nil
yourScore = {}
theirScore = {}
totalScore = 0

function love.load()
  cards = importCards(true)
  udp = socket.udp()
  udp:settimeout(0)
  udp:setpeername(address, port)
  love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
  local data, msg
  repeat
    data, msg = udp:receive()
    if data then
      if gamestate.acceptMessage then
        gamestate = gamestate.acceptMessage(data, msg)
      end
    elseif msg ~= 'timeout' then
      error("Network error: "..tostring(msg))
    end
  until not data
  if gamestate.update then
    gamestate = gamestate.update(dt)
  end
end

function love.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(bg,0,0,0,love.graphics.getWidth()/1280,love.graphics.getWidth()/1280)
  if gamestate.draw then
    gamestate = gamestate.draw()
  end
end

function love.mousepressed(x,y,button,istouch)
  if gamestate.mousepressed then
    gamestate = gamestate.mousepressed(x,y,button,istouch)
  end
end

function love.keypressed(k)
  if gamestate.keypressed then
    gamestate = gamestate.keypressed(k)
  end
end

function love.textinput(t)
  if gamestate.textinput then
    gamestate = gamestate.textinput(t)
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  if gamestate.mousemoved then
    gamestate = gamestate.mousemoved(x, y, dx, dy, istouch)
  end
end

function updateCard(cardObject, dt)
  -- Apply tween, not sure about this yet.
  for i,j in pairs(cardObject.tweens) do
    cardObject.tweens[i] = updateTweens(j, dt)
    local newval = valueTween(cardObject.tweens[i])
    if newval ~= nil then
      cardObject[i] = newval
    end
  end
  return cardObject
end

function updateAllCards(dt)
  for i,j in pairs(yourScore) do
    updateCard(j, dt)
  end

  for i,j in pairs(theirScore) do
    updateCard(j, dt)
  end

  for i,j in pairs(playArea) do
    updateCard(j, dt)
  end

  for i,j in pairs(hand) do
    updateCard(j, dt)
  end

  if deckFlip then
    updateCard(deckFlip, dt)
  end
end

function pointerInCard(cardObject, px, py)
  local endx, endy
  endx = (cardObject.image:getWidth()*cardObject.size) + cardObject.x
  endy = (cardObject.image:getHeight()*cardObject.size) + cardObject.y
  if px <= endx and px >= cardObject.x and py <= endy and py >= cardObject.y then return true else return false end
end
