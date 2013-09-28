conn_id_map = {}
conn_name_map = {}
online_user_list = {}

--[[
On user connect, send him the list of online users in a 
message of type "userlist".
]]
gamooga.onconnect(function(conn_id)
    --gamooga.send(conn_id, "userlist", {ol=online_user_list})
    gamooga.send(conn_id, "userlist", {ol=conn_name_map})
end)

--[[
User sends "mynick" message right after he connects to the
room with his nick. We then send a "userjoin" message with
his nick to all the users.
info_string format is 'username playerId'
]]
gamooga.onmessage("mynick", function(conn_id, s)


	user_info = {}
	for word in s:gmatch("%w+") do table.insert(user_info, word) end

    username = user_info[1]
    playerId = user_info[2]

	tagged_list[playerId] = {};

    conn_name_map[playerId] = username
    conn_id_map[conn_id] = playerId

    online_user_list[username] = true
   	gamooga.broadcast("userjoin", username)
end)

--[[
User sends a "chat" message with his chat. We broadcast it
to all the users.
]]
gamooga.onmessage("chat", function(conn_id, data)
    gamooga.broadcast("chat",{f=conn_id_map[conn_id],c=data})
end)

--[[
Sends start game message to all users
]]
gamooga.onmessage("sendstartmessage", function(conn_id, s)
     gamooga.broadcast("startgame", "startgame")
end)

--[[
On a user disconnect, we send a "usergone" message to all
the users in that room with his nick.
]]
gamooga.ondisconnect(function(conn_id)
    online_user_list[conn_id_map[conn_id]] = nil
    gamooga.broadcast("usergone",conn_name_map[conn_id])
    conn_id_map[conn_id] = nil
end)