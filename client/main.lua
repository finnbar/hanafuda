package.path = package.path .. ";../both/?.lua"

requires = {"cards-define","cards-score","useful", "card-draw", "game-setup", "game-updates", "game", "gameDeckPlay", "gameDeckWait", "gameHandPlay", "gameHandWait", "gameOver", "menu", "theyScore", "tween", "waiting", "youScore"}
for i,j in pairs(requires) do
  require(j)
end
local socket = require "socket"
utf8 = require("utf8")

local address, port = "localhost", 12345

bg = love.graphics.newImage("assets/images/ukiyoebackground.jpg")
largefont = love.graphics.newFont("assets/intellecta-design_japonesa/Japonesa.ttf",80)
midfont = love.graphics.newFont("assets/intellecta-design_japonesa/Japonesa.ttf",50)

local gamestate = menu
errormsg = ""
mode = 1
cards = {}

-- Game variables
hand = {}
selectedCard = 0
playArea = {}
playAreaLocations = {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}
opposingCards = 8
deckFlip = nil
yourScore = {}
theirScore = {}

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

function updateCard(cardObject)
  -- Apply tween, not sure about this yet.
  for i,j in pairs(cardObject.tweens) do
    cardObject.tweens[i] = updateTweens(j)
    local newval = valueTween(cardObject.tweens[i])
    if newval ~= nil then
      cardObject[i] = newval
    end
  end
  return cardObject
end

function pointerInCard(cardObject, px, py)
  endx = (cardObject.image:getWidth()*cardObject.size) + cardObject.x
  endy = (cardObject.image:getHeight()*cardObject.size) + cardObject.y
  if px <= endx and px >= cardObject.x and py <= endy and py >= cardObject.y then return true else return false end
end
