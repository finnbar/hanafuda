theyQuit = {}

function theyQuit.draw()
  love.graphics.setFont(smallfont)
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("It seems they quit while you were still playing...", 100, 250, 800, "center")
  love.graphics.printf("It was probably because you were winning.", 100, 320, 800, "center")
  love.graphics.printf("Maybe you should play someone a bit more friendly.", 100, 390, 800, "center")
  love.graphics.printf("Press enter to do that.", 100, 460, 800, "center")
  return theyQuit
end

function theyQuit.keypressed(k)
  if k == "return" then
    mode = 2
    return menu
  end
  return theyQuit
end
