menu = {}
username = ""
roomname = ""

function menu.update(dt, data, msg)
  return menu
end

function menu.draw()
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
  end
  return menu
end

function menu.textinput(t)
  if mode == 1 then
    username = username .. t
  elseif mode == 2 then
    roomname = roomname .. t
  end
  return menu
end

function menu.keypressed(key)
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
  return menu
end

function menu.acceptMessage(data, msg)
  if data:sub(1,1) == "!" then
    setUpGame(data, false)
    return gameHandWait
  elseif data:sub(1,1) == "&" then
    return waiting
  elseif string.sub(data,1,1) == "@" then
    mode = 1
    errormsg = "Username already used or no valid username entered"
  elseif string.sub(data,1,1) == "#" then
    mode = 2
    errormsg = "Room in use or no valid room entered."
  end
  return menu
end
