-- Copyright 2017 Douglas Gaskell Apache License 2.0

if onServer() then
package.path = package.path .. ";data/scripts/lib/?.lua"
package.path = package.path .. ";data/scripts/?.lua"

require ("galaxy")
require ("stringutility")
local PlanGenerator = require ("plangenerator")
local ShipUtility = require ("shiputility")
local UpgradeGenerator = require ("upgradegenerator")
local TurretGenerator = require ("turretgenerator")
local PirateGenerator = {}


function initialize(difficulty)
    local difficulty = tonumber(difficulty)
    local message = "Invalid arguments provided"
    local valid = true;


    -- create attacking ships
    local dir = normalize(vec3(getFloat(-1, 1), getFloat(-1, 1), getFloat(-1, 1)))
    local up = vec3(0, 1, 0)
    local right = normalize(cross(dir, up))
    local pos = dir * 1000

     if difficulty == 1 then
        message = "Pirate attack difficulty 1 initiated"

        local pirate = PirateGenerator.createBandit(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20
        PirateGenerator.createOutlaw(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createOutlaw(MatrixLookUpPosition(-dir, up, pos + right * -distance))


    elseif difficulty == 2 then
        message = "Pirate attack difficulty 2 initiated"

        local pirate = PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20
        PirateGenerator.createBandit(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createBandit(MatrixLookUpPosition(-dir, up, pos + right * -distance))

    elseif difficulty == 3 then
        message = "Pirate attack difficulty 3 initiated"

        local pirate = PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * -distance))

    elseif difficulty == 4 then
        message = "Pirate attack difficulty 4 initiated"

        local pirate = PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * -distance))
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * -distance * 2.0))
        PirateGenerator.createBandit(MatrixLookUpPosition(-dir, up, pos + right * distance * 2.0))

    elseif difficulty == 5 then
        message = "Pirate attack difficulty 5 initiated"

        local pirate = PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos + right * -distance))
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * -distance * 2.0))
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * distance * 2.0))
        PirateGenerator.createBandit(MatrixLookUpPosition(-dir, up, pos + right * distance * 3.0))

    elseif difficulty == 6 then
        message = "Pirate attack difficulty 6 initiated"

        local pirate = PirateGenerator.createBattleship(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos + right * -distance))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * -distance * 2.0))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * distance * 2.0))
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * distance * 3.0))

    elseif difficulty == 7 then
        message = "Pirate attack difficulty 7 initiated"

        local pirate = PirateGenerator.createBattleship(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createBattleship(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos + right * -distance))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * -distance * 2.0))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * distance * 2.0))
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * distance * 3.0))        

    elseif difficulty == 8 then
        message = "Pirate attack difficulty 8 initiated"

        local pirate = PirateGenerator.createMothership(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createBattleship(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos + right * -distance))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * distance * 2.0))
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * distance * 3.0))        
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * -distance * 3.0))

    elseif difficulty == 9 then
        message = "Pirate attack difficulty 9 initiated"

        local pirate = PirateGenerator.createDreadnought(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createBattleship(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos + right * -distance))
        PirateGenerator.createBattleship(MatrixLookUpPosition(-dir, up, pos + right * -distance * 2.0))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * distance * 2.0))
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * distance * 3.0))        
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * -distance * 3.0))

    elseif difficulty == 10 then
        message = "Pirate attack difficulty 10 initiated"

        local pirate = PirateGenerator.createTitan(MatrixLookUpPosition(-dir, up, pos))

        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createBattleship(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createRaider(MatrixLookUpPosition(-dir, up, pos + right * -distance))
        PirateGenerator.createBattleship(MatrixLookUpPosition(-dir, up, pos + right * -distance * 2.0))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * distance * 2.0))
        PirateGenerator.createMarauder(MatrixLookUpPosition(-dir, up, pos + right * distance * 3.0))        
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * -distance * 3.0)) 
        PirateGenerator.createPirate(MatrixLookUpPosition(-dir, up, pos + right * distance * 4.0))  
        PirateGenerator.createBandit(MatrixLookUpPosition(-dir, up, pos + right * -distance * 4.0))

    elseif difficulty == 11 then
        message = "Pirate boss initiated"

        local pirate = PirateGenerator.createBoss(MatrixLookUpPosition(-dir, up, pos))
        local distance = pirate:getBoundingSphere().radius * 2 + 20

        PirateGenerator.createDreadnought(MatrixLookUpPosition(-dir, up, pos + right * distance))
        PirateGenerator.createDreadnought(MatrixLookUpPosition(-dir, up, pos + right * -distance))
    else
        valid = false
    end

    Player():sendChatMessage("Server", 0, message)
    if valid then
        Sector():broadcastChatMessage("Server"%_t, 2, "Pirates are attacking the sector!"%_t)
    end
    
    terminate()
end


function PirateGenerator.createOutlaw(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 0.75, 0.5, "Outlaw"%_t)
end

function PirateGenerator.createBandit(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 1.0, 1.0, "Bandit"%_t)
end

function PirateGenerator.createPirate(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 1.5, 1.0, "Pirate"%_t)
end

function PirateGenerator.createMarauder(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 2.0, 1.25, "Marauder"%_t)
end

function PirateGenerator.createRaider(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 4.0, 1.5, "Raider"%_t)
end

function PirateGenerator.createBattleship(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 8.0, 5, "Pirate Battleship"%_t)
end

function PirateGenerator.createMothership(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 30.0, 5.0, "Pirate Mothership"%_t)
end

function PirateGenerator.createDreadnought(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 60.0, 6.0, "Pirate Dreadnought"%_t)
end

function PirateGenerator.createTitan(position, sizeScale, firepowerScale)
    return PirateGenerator.create(position, 150.0, 7.0, "Pirate Titan"%_t)
end

function PirateGenerator.createBoss(position, sizeScale, firepowerScale)
    local volumeFactor = 300
    local turretFactor = 4
    local turretRarity = Rarity(RarityType.Exotic)
    local title = "Pirate Boss"

    position = position or Matrix()
    local x, y = Sector():getCoordinates()
    PirateGenerator.pirateLevel = PirateGenerator.pirateLevel or Balancing_GetPirateLevel(x, y)  
    local faction = Galaxy():getPirateFaction(PirateGenerator.pirateLevel)
    local volume = Balancing_GetSectorShipVolume(x, y) * volumeFactor;   

    local probabilities = Balancing_GetMaterialProbability(x, y)
    local material = Material(getValueFromDistribution(probabilities))
    local plan = PlanGenerator.makeShipPlan(faction, volume, nil, material)
    local ship = Sector():createShip(faction, "", plan, position)    

    TurretGenerator.initialize(random():createSeed())
    local turret = TurretGenerator.generateArmed(x, y, nil, turretRarity)
    local numTurrets = math.max(2, Balancing_GetEnemySectorTurrets(x, y) * turretFactor)
    ShipUtility.addTurretsToCraft(ship, turret, numTurrets)
    
    ship.crew = ship.minCrew
    ship.title = title
    ship.shieldDurability = ship.shieldMaxDurability

    ShipAI(ship.index):setAggressive()

    ship:setValue("is_pirate", 1)

    return ship        
end

-- Grabbed from pirategenerator.lua
-- Used to avoid changing native game files as much as possible
function PirateGenerator.create(position, volumeFactor, turretFactor, title)
    position = position or Matrix()
    local x, y = Sector():getCoordinates()
    PirateGenerator.pirateLevel = PirateGenerator.pirateLevel or Balancing_GetPirateLevel(x, y)

    local faction = Galaxy():getPirateFaction(PirateGenerator.pirateLevel)

    local volume = Balancing_GetSectorShipVolume(x, y) * volumeFactor;

    local plan = PlanGenerator.makeShipPlan(faction, volume)
    local ship = Sector():createShip(faction, "", plan, position)

    -- turrets should also scale with pirate strength, but every pirate must have at least 1 turret
    local turrets = math.max(2, math.floor(Balancing_GetEnemySectorTurrets(x, y) * turretFactor))

    ShipUtility.addArmedTurretsToCraft(ship, turrets)

    ship.crew = ship.minCrew
    ship.title = title
    ship.shieldDurability = ship.shieldMaxDurability

    ShipAI(ship.index):setAggressive()

    ship:setValue("is_pirate", 1)

    return ship    
end



-- Grabbed from pirategenerator.lua
-- Used to avoid changing native game files as much as possible
function PirateGenerator.getPirateFaction()
    local x, y = Sector():getCoordinates()
    PirateGenerator.pirateLevel = PirateGenerator.pirateLevel or Balancing_GetPirateLevel(x, y)
    return Galaxy():getPirateFaction(PirateGenerator.pirateLevel)
end    

end