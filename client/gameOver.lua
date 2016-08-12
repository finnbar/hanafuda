gameOver = {}

local outcome, finalScore

function processGameOver(data)
  outcome, finalScore = string.match(data, "<(%w+)<(%d*)<")
end

function gameOver.draw()
  if outcome == "win" then
    drawWinScreen()
  elseif outcome == "lose" then
    drawLoseScreen()
  else
    drawDrawScreen()
  end
  return gameOver
end

function drawWinScreen()
  drawGameOverScreen("You win! Yay!", "You scored "..finalScore..". Good job!")
end

function drawLoseScreen()
  drawGameOverScreen("You lose. Sad.", "They scored "..finalScore..". But you can win next time")
end

function drawDrawScreen()
  drawGameOverScreen("It was a draw.", "I guess you both win?")
end

function drawGameOverScreen(msg1, msg2)
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(largefont)
  love.graphics.printf(msg1,100,200,love.graphics.getWidth()-200,"center")
  love.graphics.setFont(midfont)
  love.graphics.printf(msg2,100,350,love.graphics.getWidth()-200,"center")
end
