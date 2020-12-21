push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/PauseState'
require 'states/ScoreState'
require 'states/CountDownState'
require 'states/TitleScreenState'

--constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--local variables: can only be accesed on this file
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0
local BACKGROUND_SCROLL_VEL = 30
local GROUND_SCROLL_VEL = 60
local BACKGROUND_STARTOVER_POINT = 413
local bird = Bird()
local pipePairs = {}
local spawnTimer = 0
local lastY = -PIPE_HEIGHT + math.random(80) + 20 --keept track of the height of last pipe display on window
local pause = false

--first function to be called
function love.load()
    love.graphics.setDefaultFilter('nearest',  'nearest')

    --app title
    love.window.setTitle('Flappy Bird')

    --set up window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,  WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        resizable = true,
        fullscreen = false
    })

    --add a keypressed table
    love.keyboard.keysPressed = {}

    -- add mouse input table
    love.mouse.buttonsPressed = {}

    --set randomseed
    math.randomseed(os.time())

    --init fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf',56)
    love.graphics.setFont(flappyFont)

    --sounds
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav' ,'static'),
        ['explosion'] = love.audio.newSource('explosion.wav' ,'static'),
        ['hurt'] = love.audio.newSource('hurt.wav' ,'static'),
        ['score'] = love.audio.newSource('score.wav' ,'static'),
        ['music'] = love.audio.newSource('marios_way.mp3' ,'static')
    }

    print(#sounds)
    --intital state machine
    gStateMachine = StateMachine {
        --create a new instance of the object everytime you press enter (this way the game resets)
        --note if you did ['title'] =  TitleScreenState(), you are not reseting the game
        ['title'] =  function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['countdown'] = function() return CountdownState() end,
        ['score'] = function() return ScoreState() end,
        ['pause'] = function() return PauseState() end
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()
    gStateMachine:change('title')

end

function love.resize(w,h)
    push:resize(w,h)
end 

--user input function
function love.keypressed(key)
    --add key pressed to table and set to value to true
    love.keyboard.keysPressed[key] = true
    print(key)

    if key == 'escape' then
        love.event.quit()
    end
end

--user input function
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    --check if key is pressed
    return love.keyboard.keysPressed[key] 
end

function love.mouse.wasPressed(button)
    --check if key is pressed
    return love.mouse.buttonsPressed[button] 
end

--update function
function love.update(dt)
    if love.keyboard.wasPressed('p') and (gStateMachine.stateName == 'play' or gStateMachine.stateName == 'pause') then
        if pause == false then
            pause = true
        else 
            pause = false
        end
    end

    --update still needs to be called in the pauseState
    gStateMachine:update(dt)

    if not pause then
        --update new  xpos (*dt to make it time independent)
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_VEL  * dt) % BACKGROUND_STARTOVER_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_VEL  * dt) % VIRTUAL_WIDTH
    end

    --reset table so no key pressed
    love.keyboard.keysPressed = {}

    --reset mouse table
    love.mouse.buttonsPressed = {}

end

--render function
function love.draw()
    push:start()
    
    --draw background
    love.graphics.draw(background, -backgroundScroll, 0)
    --love.graphics.rectangle( "fill", 300, -195, 70, 288 )

    gStateMachine:render()
    --draw ground (16 height of image)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end


function love.conf(t)
    t.console = true
end
