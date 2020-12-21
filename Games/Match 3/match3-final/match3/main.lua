require 'src/Dependencies'

function love.load() 
    --set title
    love.window.setTitle('Match 3')

    --set filter mode
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --seed RNG 
    math.randomseed(os.time())

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --set looping music
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    --init state machine
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }

    gStateMachine:change('start')

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- keep track of scrolling our background on the X axis
    backgroundX = 0
    backgroundScrollSpeed = 80
end

--function to make screen resizeable
function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    --add key pressed to our table at this frame
    love.keyboard.keysPressed[key] = true
end

--function to check if the key was pressed this frame
function love.keyboard.wasPressed(key) 
    return love.keyboard.keysPressed[key]
end

function  love.update(dt) 
    -- scrolling background
    backgroundX = (backgroundX - backgroundScrollSpeed * dt) % (-1024 + VIRTUAL_WIDTH - 4 + 51)

    gStateMachine:update(dt)

    --clear table
    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], backgroundX, 0)
    
    gStateMachine:render()
    push:finish()
end