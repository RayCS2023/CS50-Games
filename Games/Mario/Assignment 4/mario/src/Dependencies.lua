--libraries
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--game states
require 'src/states/BaseState'
require 'src/states/game/StartState'
require 'src/states/game/PlayState'

--utilities
require 'src/Constants'
require 'src/StateMachine'
require 'src/Util'

--game object states
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkingState'
require 'src/states/entity/PlayerJumpState'

require 'src/states/entity/snail/SnailChasingState'
require 'src/states/entity/snail/SnailIdleState'
require 'src/states/entity/snail/SnailMovingState'


--game objects
require 'src/LevelMaker'
require 'src/Tile'
require 'src/TileMap'
require 'src/GameLevel'
require 'src/GameObject'
require 'src/Entity'
require 'src/Player'
require 'src/Snail'
require 'src/Animation'



--game sounds, images, fonts, tiles
gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav'),
    ['death'] = love.audio.newSource('sounds/death.wav'),
    ['music'] = love.audio.newSource('sounds/music.wav'),
    ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav'),
    ['empty-block'] = love.audio.newSource('sounds/empty-block.wav'),
    ['kill'] = love.audio.newSource('sounds/kill.wav'),
    ['kill2'] = love.audio.newSource('sounds/kill2.wav')
}

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['jump-blocks'] = love.graphics.newImage('graphics/jump_blocks.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['green-alien'] = love.graphics.newImage('graphics/green_alien.png'),
    ['creatures'] = love.graphics.newImage('graphics/creatures.png'),
    ['locks-and-keys'] = love.graphics.newImage('graphics/keys_and_locks.png'),
    ['poles'] = love.graphics.newImage('graphics/flags.png'),
    ['flags'] = love.graphics.newImage('graphics/flags.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    
    ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
    
    ['bushes'] = GenerateQuads(gTextures['bushes'], 16, 16),
    ['jump-blocks'] = GenerateQuads(gTextures['jump-blocks'], 16, 16),
    ['gems'] = GenerateQuads(gTextures['gems'], 16, 16),
    ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 256, 128),
    ['green-alien'] = GenerateQuads(gTextures['green-alien'], 16, 20),
    ['creatures'] = GenerateQuads(gTextures['creatures'], 16, 16),
    ['locks-and-keys'] = GenerateQuads(gTextures['locks-and-keys'], 16 ,16),
    ['poles'] = GenerateQuads(gTextures['flags'], 16 ,64),
    ['flags'] = GenerateQuads(gTextures['flags'], 16 ,16)
}

gFrames['tilesets'] = GenerateTileSets(gFrames['tiles'], 
    NUM_TILE_SETS_WIDE, NUM_TILE_SETS_TALL, NUM_TILES_WIDE, NUM_TILES_TALL)

gFrames['toppersets'] = GenerateTileSets(gFrames['toppers'], 
NUM_TOPPER_SETS_WIDE, NUM_TOPPER_SETS_TALL, NUM_TILES_WIDE, NUM_TILES_TALL)

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}