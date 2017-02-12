-- Copyright 2017 Douglas Gaskell Apache License 2.0
-- v1.0

function execute(sender, commandName, attackers)
   	Player(sender):addScriptOnce("cmd/spawnpirates.lua", attackers)
    return 0, "", ""
end

function getDescription()
    return "Spawns a pirate attack"
end

function getHelp()
    return "Echoes all given parameters to console. Usage: /echo This is a test"
end