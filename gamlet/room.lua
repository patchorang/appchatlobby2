conn_id_map = {}
conn_name_map = {}
online_user_list = {}
tagged_list = {}
location_map = {}

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function gettopplayers()
    tagged_id_to_count = {}
    for key,value in pairs(tagged_list) do

        count = 0
        for _ in pairs(value) do count = count + 1 end

        tagged_id_to_count[conn_name_map[key]] = count
    end
    return tagged_id_to_count
end

function generateScript()

    script = "\"actions\": [{\"action\": \"spin\", \"time\":\"10\"}"

    num_actions = math.random(5, 8)
    for i = 1, num_actions do
        script = script..", "..getActionDescriptor()
    end

    script = script.."]"

    return jsonify(script)
end

function jsonify(string)
    return "{"..string.."}"
end 

function getActionDescriptor()

    action = getAction()
    modifer = getModifier()
    time = getTime(action)
    print(action)

    action_descriptor = "\"action\": \""..action.."\", \"time\": \""..time.."\""
    if modifer ~= "" then
        action_descriptor = action_descriptor..", \"modifer\": \""..modifer.."\""
    end

    return jsonify(action_descriptor);
end

function getAction()
    actions = {"crawl", "run", "hop", "somersault", "roll", "freeze"}
    return actions[math.random(6)];
end

function getModifier()
    modifiers = {"hold", "tap", "", "", "", ""}
    return modifiers[math.random(6)];
end

function getTime(action)
    if action == "crawl" then 
        return math.random(4, 10)
    elseif action == "run" then
        return math.random(4, 10)
    elseif action == "hop" then
        return math.random(3, 6)
    elseif action == "somersault" then
        return math.random(4, 7)
    elseif action == "roll" then    
        return math.random(3, 6)
    elseif action == "freeze" then    
        return math.random(2, 4)
    end
end

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

gamooga.onmessage("getscript", function(conn_id, s)
    gamooga.broadcast("script", generateScript())
end)

--[[
User sends a "chat" message with his chat. We broadcast it
to all the users.
]]
gamooga.onmessage("chat", function(conn_id, data)
    gamooga.broadcast("chat",{f=conn_id_map[conn_id],c=data})
end)

--[[
User sends a "tagged" message with the user tagged. We broadcast it
to all the users.
data format is 'taggedUserId taggerId'
]]
gamooga.onmessage("taguser", function(conn_id, s)   
    tag_info = {}
    for word in s:gmatch("%w+") do table.insert(tag_info, word) end

    taggedId = tag_info[1]
    taggerId = tag_info[2]

    -- Add to tagged list
    if tagged_list[taggerId] == nil then
        tagged_list[taggerId] = {}
    end

    if tagged_list[taggerId][taggedId] ~= true then
        if taggedId ~= conn_id_map[conn_id] then
            tagged_list[taggerId][taggedId] = true;
            gamooga.broadcast("usertagged", conn_name_map[taggerId].." tagged "..conn_name_map[taggedId])

            gamooga.send(conn_id, "killedsomeone", "killedsomeone")

            killed_conn_id = ""
            for key, value in pairs(conn_id_map) do
                if value == taggedId then
                    killed_conn_id = key;
                end
            end

            gamooga.send(killed_conn_id, "youvebeenkilled", "youvebeenkilled")

            -- check if tagged all users, if so end the game
            if tablelength(tagged_list[taggerId]) + 1 == tablelength(conn_name_map) then
                gamooga.broadcast("gameover", {ol=gettopplayers()})
            end
        end
    end
end)

gamooga.onmessage("timerranout", function(conn_id, s)
    gamooga.broadcast("gameover", {ol=gettopplayers()})
end)

--[[
User sends the locations to the clients
data is form "lat long"
]]
gamooga.onmessage("locationupdate", function(conn_id, s)
    senderid = conn_id_map[conn_id];
    location_map[senderid] = s

    gamooga.broadcast("locationsupdate", {ol=location_map})
end)

--[[
Sends start game message to all users
]]
gamooga.onmessage("start", function(conn_id, s)
     gamooga.broadcast("startgame", "startgame")
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