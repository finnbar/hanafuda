function removeUser(username, message)
  if users[username] then
    local roomName = users[username].room
    local room = games[roomName]

    local otherUsername
    if room.players[1] and room.players[1].username ~= username then
      otherUsername = room.players[1].username
    elseif room.players[2] and room.players[2].username ~= username then
      otherUsername = room.players[2].username
    end

    if otherUsername then
      local otherUser = users[otherUsername]
      sendUDP(message, otherUser)
      users[otherUsername] = nil
    end

    -- finally, remove user and room
    games[roomName] = nil
    users[username] = nil
  end
end

function quitGame(data, msg_or_ip, port_or_nil)
  local username = string.match(data, "QUIT (%w*) %w*")
  removeUser(username, "QUIT")
end
