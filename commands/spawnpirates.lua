-- Copyright 2017 Douglas Gaskell Apache License 2.0
-- v1.3
function execute(sender, commandName, ...)
    local args = {...}
    local parsedArgs = parseArguments(args)

    print("args: " .. parsedArgs["difficulty"] .. ",".. parsedArgs["scale"] .. "," .. parsedArgs["count"])

    if(parsedArgs["player"] ~= nil) then
        if(parsedArgs["player"] == "-me") then
            Player(sender):addScriptOnce("cmd/spawnpirates.lua", parsedArgs["difficulty"], parsedArgs["scale"], parsedArgs["count"])
        else
            local player = findPlayer(parsedArgs["player"])
            if player ~= false then -- Player found, spawn on player
                player:addScriptOnce("cmd/spawnpirates.lua", parsedArgs["difficulty"], parsedArgs["scale"], parsedArgs["count"])
            else
                Player(sender):sendChatMessage("SpawnPirates", 1, "Player '" .. parsedArgs["player"] .. "' is not online or does not exist.")
            end            
        end
    else
        Player(sender):addScriptOnce("cmd/spawnpirates.lua", parsedArgs["difficulty"], parsedArgs["scale"], parsedArgs["count"])
    end

end

function findPlayer(playerName)
    for i, player in pairs({Server():getOnlinePlayers()}) do
        if player.name:lower() == playerName:lower() then
          return player
        end
    end
    return false
end

function parseArguments(args)
    local parsedArgs = splitArguments(args, "--")

    if(parsedArgs["difficulty"] == nil) then
        parsedArgs["difficulty"] = 0
    end
    if(parsedArgs["scale"] == nil) then
        parsedArgs["scale"] = 0
    end
    if(parsedArgs["count"] == nil) then
        parsedArgs["count"] = 0
    end
    return parsedArgs
end


--Splits the arguments into their seperate commands
function splitArguments(args, delimiter)
    local concatianted = ""
    for index in ipairs(args) do
        if(string.match(args[index], "--")) then
            concatianted = concatianted .. " " .. args[index]
            --print(args[index])
        end
    end

    if concatianted == nil then
            concatianted = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(concatianted, "([^"..delimiter.."]+)") do
        if i > 1 then --slip first blank match
            local paramName = getArgumentName(str)
            if paramName ~= "invalid" then
                t[paramName] = getCommandValue(str)
                print(paramName .. ": {" .. t[paramName] .. "}")
            end
        end
            i = i + 1  
    end
    return t
end

--Determines the name via simple match, necessary to know which param is which
function getArgumentName(param)
    if(string.match(param, "--player")) then return "player"
    elseif(string.match(param, "--difficulty") or string.match(param, "--diff")) then return "difficulty"
    elseif(string.match(param, "--scale")) then return "scale"
    elseif(string.match(param, "--count")) then return "count"
    else return "invalid"
    end
end

--Since there will be a space after the command, find the first space and get the remainder of string from there
function getCommandValue(command)
    for i = 1, #command do
        local c = command:sub(i,i)
        if(c == " ") then
            if(command:sub(#command, #command) == " ") then
                return command:sub(i + 1, #command - 1) --last char is space, remove
            else
                return command:sub(i + 1, #command)
            end
        end
    end    
end

function getDescription()
    return "Spawns a pirate attack"
end

function getHelp()
    return "\nSpawns a pirate attack with the provided parameters. Usage: \n" ..
            "/spawnpirates {player} {difficulty} {scale} {pirateCount} \n" ..
           "Difficulties: [1-100], Scale: [1-100], PirateCount: [1-25]\n" ..
           "All parameters are optional, using '0' will set the parameters to their defaults\n" ..
           "To spawn on yourself use '--me' for the player"
end