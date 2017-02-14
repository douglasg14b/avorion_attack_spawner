-- Copyright 2017 Douglas Gaskell Apache License 2.0
-- v1.0

function execute(sender, commandName, difficulty, playerName)
    if playerName ~= nil then --Attempt to find player
        local player = findPlayer(playerName)
        if player ~= false then -- Player found, spawn on player
            player:addScriptOnce("cmd/spawnpirates.lua", difficulty)
        else
            Player(sender):sendChatMessage("SpawnPirates", 1, "Player '" .. playerName .. "' is not online or does not exist.")
        end
    else -- No player provided, spawn on sender
   	    Player(sender):addScriptOnce("cmd/spawnpirates.lua", difficulty)
    end
    return 0, "", ""
end

function findPlayer(playerName)
    for i, player in pairs({Server():getOnlinePlayers()}) do
        if player.name:lower() == playerName:lower() then
          print("found player")
          return player
        end
    end
    return false
end

function getDescription()
    return "Spawns a pirate attack"
end

function getHelp()
    return "Spawns a pirate attack with the provided difficulty." ..
            "/spawnpirates {difficulty}" ..
           " Difficulties: 1-11"
end