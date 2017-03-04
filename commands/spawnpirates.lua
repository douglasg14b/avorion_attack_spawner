-- Copyright 2017 Douglas Gaskell Apache License 2.0
-- v1.3
function execute(sender, commandName, ...)
    local args = {...}

    if(#args == 1) then
        if(args[1] == "--help") then
            Player(sender):sendChatMessage("SpawnPirates", 0, getHelp())
            return 0, "", ""
        end
    end

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

    return 0, "", ""
end

function findPlayer(playerName)
    for i, player in pairs({Server():getOnlinePlayers()}) do
        if player.name:lower() == playerName:lower() then
          return player
        end
    end
    return false
end

--Arguments/parameters in the order you wish them to be in
local validParams = {
    {
        name = "player",
        hasDefault = false,
        hasAlius = true,
        alius = {"p"}
    },
    {
        name = "difficulty",
        hasDefault = true,
        hasAlius = true,
        defaultValue = 0,
        alius = {"diff", "d"}
    },
    {
        name = "scale",
        hasDefault = true,
        hasAlius = true,
        defaultValue = 0,
        alius = {"s"}
    },
    {
        name = "count",
        hasDefault = true,
        hasAlius = true,
        defaultValue = 0,
        alius = {"c"}
    }
}


function parseArguments(args)
    local parsedArgs = splitArguments(args, "--")

    --Set default values
    for index in ipairs(validParams) do
        if(validParams[index].hasDefault) then
            if(parsedArgs[validParams[index].name] == nil) then
                parsedArgs[validParams[index].name] = validParams[index].defaultValue
            end
        end
    end
    return parsedArgs
end


--Splits the arguments into their seperate commands
function splitArguments(args, delimiter)
    local concatinated = ""
    for index in ipairs(args) do
        if(string.match(args[index], "--")) then
            concatinated = concatinated .. " " .. args[index]
        end
    end

    if concatinated == nil then
        concatinated = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(concatinated, "([^"..delimiter.."]+)") do
        if i > 1 then --slip first blank match
            local paramName = getArgumentName(str)
            if paramName ~= "invalid" then
                t[paramName] = getCommandValue(str)
            end
        end
        i = i + 1  
    end
    return t
end

--Matches the argument up to the valid params 
function getArgumentName(param)
    local foundValid = false
    for index in pairs(validParams) do
        if(validParams[index].hasAlius) then
            print("has alius")
            for aIndex in pairs(validParams[index].alius) do
                if(string.match(param, "--" .. validParams[index].alius[aIndex])) then
                    return validParams[index].name
                end                
            end
        else
            if(string.match(param, "--" .. validParams[index].name)) then
                return validParams[index].name
            end
        end

    end
    return "invalid"
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
            "/spawnpirates [--player, --difficulty, --scale, --count]\n" ..
           "Difficulties: [1-100], Scale: [1-100], PirateCount: [1-25]\n" ..
           "All parameters are optional\n" ..
           "Example: /spawnpirates --difficulty 10 --scale 2 -- count 6 --player george"
end