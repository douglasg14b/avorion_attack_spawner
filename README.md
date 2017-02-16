# Pirate and Alien(soon) Attack Spawner
### v1.2

Allows you to spawn waves of pirates (aliens coming soon) of various difficulties. 
## Installation

**Follow the instructions on the release page:**  [Latest Release](https://github.com/douglasg14b/avorion_attack_spawner/releases/latest)

Otherwise:

Copy the files into the folders as they are listed in the repository. You may need to create the `cmd` folder under your `player` directory. You can find these directories under your `Avorion` installation folder, under `Avorion/data`
- `scripts/commands/spawnpirates.lua`
- `scripts/player/cmd/spawnpirates.lua`

## Usage
`/spawnpirates {player} {difficulty} {scale} {pirateCount}`



- `player` is the player you wish to spawn the pirates on including yourself. For ease of use, you may use `--me` to spawn the wave in your sector
 - **Valid Values:**
   - Any online player
    - `--me`
- `difficulty` The pirates difficulty level. This increases their armor, module, and weapon material and rarity levels
 - **Valid Values:**
   - `1` to `100`
- `scale` Scales the pirates block volume. This increases their overall size as well as their turret count
 - **Valid Values:**
   - `1` to `100`
- `pirateCount` The number of pirates you wish to spawn
 - **Valid Values:**
   - `1` to `25`
   
**All Parameters are optional**. All parameters will default to the games defaults for your sector. If you do not enter any parameters a single pirate with the default stats for your sector will spawn on you.

Parameters are constrained to their allowed range. So if you enter a `difficulty` of 250, it will cap it at 100.

**Example:** `/spawnpirates --me 0 10 3`. This will spawn a wave of three pirates of the default difficulty, with a scale multiplyer of 10 in your sector.

**Help**: To recieve help in game, type `/spawnpirates --help`

### Planned

- Alien Spawning
