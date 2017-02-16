-- Copyright 2017 Douglas Gaskell Apache License 2.0
-- v1.2

function execute(sender, commandName, playerName, difficulty, scale, count)
    if playerName ~= nil then --Attempt to find player
print(playerName)
        if playerName == "--me" then -- Spawning on sender
            Player(sender):addScriptOnce("cmd/spawnpirates.lua", difficulty, scale, count)
            return 0, "", ""
        end

        if playerName == "--help" then --Getting help
            Player(sender):sendChatMessage("SpawnPirates", 0, getHelp())
            return 0, "", ""
        end


        local player = findPlayer(playerName)
        if player ~= false then -- Player found, spawn on player
            player:addScriptOnce("cmd/spawnpirates.lua", difficulty, scale, count)
        else
            Player(sender):sendChatMessage("SpawnPirates", 1, "Player '" .. playerName .. "' is not online or does not exist.")
        end
    else -- No player provided, spawn on sender
   	    Player(sender):addScriptOnce("cmd/spawnpirates.lua", difficulty, scale, count)
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