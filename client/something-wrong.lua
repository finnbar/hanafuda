somethingWrong = {}

function somethingWrong.draw()
  love.graphics.setFont(smallfont)
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("It seems something has gone wrong somewhere. Sad.", 100, 250, 800, "center")
  love.graphics.printf("We are very sorry about this.", 100, 320, 800, "center")
  love.graphics.printf("Maybe you should try playing again.", 100, 390, 800, "center")
  love.graphics.printf("Press enter to do that.", 100, 460, 800, "center")
  return somethingWrong
end

function somethingWrong.keypressed(k)
  if k == "return" then
    mode = 2
    return menu
  end
  return somethingWrong
end
