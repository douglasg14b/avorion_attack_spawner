-- Copyright 2017 Douglas Gaskell Apache License 2.0
-- v1.2

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

local shipValues = {}



function initialize(difficulty, scale, count)

    setInputValues(difficulty, scale, count)

    local x, y = Sector():getCoordinates()

    -- create location data for ships
    local dir = normalize(vec3(getFloat(-1, 1), getFloat(-1, 1), getFloat(-1, 1)))
    local up = vec3(0, 1, 0)
    local right = normalize(cross(dir, up))
    local pos = dir * 1000

    createShips(dir, up, right, pos)

    
    Player():sendChatMessage("Server", 0, 'Pirate attack sucessfully initiated'%_t)
    Sector():broadcastChatMessage("Server"%_t, 2, "Pirates are attacking the sector!"%_t)
    
    terminate()
end

function setInputValues(difficulty, scale, count)
    local x, y = Sector():getCoordinates()

    --Set difficulty
    if tonumber(difficulty) then
        if tonumber(difficulty) == 0 then
            difficulty = Balancing_GetPirateLevel(x, y) --Default: Game default
        else
            difficulty = math.max(math.min(difficulty, 100), 1) -- Ceiling: 100 floor: 1
        end
        
    else
        difficulty = Balancing_GetPirateLevel(x, y) --Default: Game default
    end

    --Set scale
    if tonumber(scale) then
        scale = math.max(math.min(scale, 100), 1) -- Ceiling: 100 floor: 1
    else
        scale = 1
    end

    --Set count
    if tonumber(count) then
        count = math.max(math.min(count, 25), 1) -- Ceiling: 25 floor: 1
    else
        count = 1
    end    

    PirateGenerator.pirateLevel = difficulty
    PirateGenerator.turretCounts = Balancing_GetEnemySectorTurrets(x, y)
    PirateGenerator.volumeScale = scale
    PirateGenerator.shipVolume = Balancing_GetSectorShipVolume(x, y) * scale
    PirateGenerator.shipCount = count
    print(count)
end

--Algorithim for creating the wave
function createShips(dir, up, right, pos)
    print("/n/n/n/n")
    local remainingVolume = PirateGenerator.shipVolume * PirateGenerator.shipCount
    local remainingShips = PirateGenerator.shipCount;
    local firstPirate
    --Spawn initial, largest ship
    if remainingShips >= 3 then
        firstPirate = PirateGenerator.create(MatrixLookUpPosition(-dir, up, pos), remainingVolume/3)

        remainingVolume = remainingVolume - (remainingVolume/3)
        remainingShips = remainingShips - 1
    elseif remainingShips == 2 then
        firstPirate = PirateGenerator.create(MatrixLookUpPosition(-dir, up, pos), remainingVolume/2)

        remainingVolume = remainingVolume - (remainingVolume/2)
        remainingShips = 1
    elseif remainingShips == 1 then
        firstPirate = PirateGenerator.create(MatrixLookUpPosition(-dir, up, pos), remainingVolume)

        remainingVolume = 0
        remainingShips = 0
    else
        --do something for bad input
    end

    local distance = firstPirate:getBoundingSphere().radius * 2 + 20

    local shipNum = 0;
    while(remainingShips > 0) do
        if remainingShips >= 3 then

            PirateGenerator.create(getSpawnLocation(-dir, up, pos, right, distance, shipNum + 1), remainingVolume/3)
            PirateGenerator.create(getSpawnLocation(-dir, up, pos, right, distance, shipNum + 2), remainingVolume/3)

            remainingVolume = remainingVolume - (remainingVolume/3*2)
            remainingShips = remainingShips - 2
            shipNum = shipNum + 2
        elseif remainingShips == 2 then

            PirateGenerator.create(getSpawnLocation(-dir, up, pos, right, distance, shipNum + 1), remainingVolume/2)
            PirateGenerator.create(getSpawnLocation(-dir, up, pos, right, distance, shipNum + 2), remainingVolume/2)

            remainingVolume = 0
            remainingShips = 0
            shipNum = shipNum + 2
        elseif remainingShips == 1 then
            PirateGenerator.create(getSpawnLocation(-dir, up, pos, right, distance, shipNum + 1), remainingVolume)

            remainingVolume = 0
            remainingShips = 0   
            shipNum = shipNum + 1         
        end
    end
end

--Determines the necessary spawning location
function getSpawnLocation(dir, up, pos, right, distance, shipNum)
    print(math.ceil(shipNum/2))
    if shipNum % 2 == 0 then
        return MatrixLookUpPosition(-dir, up, pos + right * distance  * math.ceil(shipNum/2))
    else
        return MatrixLookUpPosition(-dir, up, pos + right * -distance * math.ceil(shipNum/2))
    end
end

--Forumla to get the turret factor for the ship based on relative volume
function determineTurretFactor(shipVolume)
    local x, y = Sector():getCoordinates()
    local sectorVolume = Balancing_GetSectorShipVolume(x, y)
    local modOne = 0.5 * (math.pow(PirateGenerator.shipCount, (1/2)))
    local modTwo = shipVolume/sectorVolume/(math.sqrt(PirateGenerator.volumeScale) + (1.5 * math.sqrt(PirateGenerator.shipCount)))

    --print ("sectorVolume: " .. sectorVolume)
    --print ("Ship Volume: " .. shipVolume)
    --print("turret factor: " .. math.max(math.min(modTwo + modOne, 10), 1))
    --print ("Mod 1: " .. modOne)
    --print ("Mod 2: " .. modTwo)
    
    --Minimum of 1, maximum of 10 
    return math.max(math.min(modTwo + modOne, 10), 1)
end

-- Grabbed from pirategenerator.lua
-- Used to avoid changing native game files as much as possible
function PirateGenerator.create(position, volume, title)
    turretFactor = determineTurretFactor(volume)
    --TEMP Title
    title ="A Pirate Ship"

    position = position or Matrix()
    local x, y = Sector():getCoordinates()

    local faction = Galaxy():getPirateFaction(PirateGenerator.pirateLevel)

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