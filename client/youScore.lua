youScore = {}

local continueButton = {x = 380, y = 390, width = 100, height = 30, colour = {51, 204, 255}, text = "Continue"}
local stopButton = {x = 500, y = 390, width = 100, height = 30, colour = {51, 204, 255}, text = "Stop"}

function youScore.draw()
  drawCards(false)
  drawMenu()
  return youScore
end

function youScore.mousemoved(x, y, dx, dy, istouch)
  if pointerInButton(continueButton, x, y) then
    continueButton.colour = {0, 153, 255}
  else
    continueButton.colour = {51, 204, 255}
  end
  if pointerInButton(stopButton, x, y) then
    stopButton.colour = {0, 153, 255}
  else
    stopButton.colour = {51, 204, 255}
  end
  return youScore
end

function youScore.acceptMessage(data, msg)
  if data:sub(1,1) == "?" then
    -- continue!
    local newCard = string.match(data, "%?(.*)%?")
    if #newCard == 0 then
      return gameHandWait
    else
      processFlip(newCard)
      return gameDeckPlay
    end
  elseif data:sub(1,1) == "<" then
    -- game over
    processGameOver(data)
    return gameOver
  end
  return youScore
end

function youScore.mousepressed(x, y, button, istouch)
  if pointerInButton(continueButton, x, y) then
    sendContinueMessage()
  elseif pointerInButton(stopButton, x, y) then
    sendStopMessage()
  end
  return youScore
end

function sendContinueMessage()
  udp:send("?"..roomname.."?"..username.."?continue")
end

function sendStopMessage()
  udp:send("?"..roomname.."?"..username.."?stop")
end

function drawButton(button)
  -- draw rectangle
  love.graphics.setColor(button.colour[1], button.colour[2], button.colour[3], 250)
  love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

  -- write text onto the button
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.setFont(tinyfont)
  love.graphics.printf(button.text, button.x, button.y + 0.1 * button.height, button.width, "center")
end

function pointerInButton(button, px, py)
  local endx, endy
  endx = button.width + button.x
  endy = button.height + button.y
  return px <= endx and px >= button.x and py <= endy and py >= button.y
end

function drawMenu()

  -- draw the overlay semi-transparently
  love.graphics.setColor(255, 255, 255,200)
  love.graphics.rectangle("fill", 300, 230, 400, 200)

  -- tell them what happened
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.setFont(midfont)
  love.graphics.printf("You score, yay!",300,240,400,"center")

  -- give the actual score (andd later, moves)
  love.graphics.setFont(smallfont)
  love.graphics.printf("Your score would be "..totalScore..".", 310, 300, 390, "left")
  love.graphics.printf("Continue?", 310, 340, 390, "left")

  drawButton(continueButton)
  drawButton(stopButton)
end
