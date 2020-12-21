Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Constants'
require 'src/StateMachine'
require 'src/Colour_defs'
require 'src/Projectile'
require 'src/ProjSet'
require 'src/Util'
require 'src/Entity'
require 'src/Animation'
require 'src/entity_defs'
require 'src/Collider'

--states
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/SelectCharState'
require 'src/states/GameOverState'

gFonts = {
    ['pixel-font-large'] = love.graphics.newFont('fonts/superscr.ttf', 64),
    ['pixel-font-medium'] = love.graphics.newFont('fonts/superscr.ttf', 32),
    ['pixel-font-small'] = love.graphics.newFont('fonts/superscr.ttf', 16),
    ['simple-font-small'] = love.graphics.newFont('fonts/simple.ttf', 16),
}

gTextures = {
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['pink-monster-walk'] = love.graphics.newImage('graphics/Pink_Monster/Pink_Monster_Walk_6.png'),
    ['pink-monster-idle'] = love.graphics.newImage('graphics/Pink_Monster/Pink_Monster.png'),
    ['pink-monster-death'] = love.graphics.newImage('graphics/Pink_Monster/Pink_Monster_Death_8.png'),
    ['dude-monster-walk'] = love.graphics.newImage('graphics/Dude_Monster/Dude_Monster_Walk_6.png'),
    ['dude-monster-idle'] = love.graphics.newImage('graphics/Dude_Monster/Dude_Monster.png'),
    ['dude-monster-death'] = love.graphics.newImage('graphics/Dude_Monster/Dude_Monster_Death_8.png'),
    ['owlet-monster-walk'] = love.graphics.newImage('graphics/Owlet_Monster/Owlet_Monster_Walk_6.png'),
    ['owlet-monster-idle'] = love.graphics.newImage('graphics/Owlet_Monster/Owlet_Monster.png'),
    ['owlet-monster-death'] = love.graphics.newImage('graphics/Owlet_Monster/Owlet_Monster_Death_8.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
}

gFrames = {
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['pink-monster-walk'] = GenerateQuads(gTextures['pink-monster-walk'], 32, 32),
    ['pink-monster-idle'] = GenerateQuads(gTextures['pink-monster-idle'], 32, 32),
    ['pink-monster-death'] = GenerateQuads(gTextures['pink-monster-death'], 32, 32),
    ['dude-monster-walk'] = GenerateQuads(gTextures['dude-monster-walk'], 32, 32),
    ['dude-monster-idle'] = GenerateQuads(gTextures['dude-monster-idle'], 32, 32),
    ['dude-monster-death'] = GenerateQuads(gTextures['dude-monster-death'], 32, 32),
    ['owlet-monster-walk'] = GenerateQuads(gTextures['owlet-monster-walk'], 32, 32),
    ['owlet-monster-idle'] = GenerateQuads(gTextures['owlet-monster-idle'], 32, 32),
    ['owlet-monster-death'] = GenerateQuads(gTextures['owlet-monster-death'], 32, 32),
    ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
}

gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav'),
    ['main'] = love.audio.newSource('sounds/8-bit Detective.wav'),
}