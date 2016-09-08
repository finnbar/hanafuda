function removeUser(username, message)
  if users[username] then
    local roomName = users[username].room
    local room = rooms[roomName]

    local otherUsername
    if room.players[1] and room.players[1].username ~= username then
      otherUsername = room.players[1].username
    elseif room.players[2] and room.players[2].username ~= username then
      otherUsername = room.players[2].username
    end

    if otherUserName then
      local otherUser = users[otherUsername]
      sendUDP(message, otherUser.ip, otherUser.port)
      users[otherUsername] = nil
    end

    -- finally, remove user and room
    rooms[roomName] = nil
    users[username] = nil
  end
end
