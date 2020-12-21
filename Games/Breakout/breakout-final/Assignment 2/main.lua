require 'src/Dependencies'

function love.load()
    --image filtering
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG 
    math.randomseed(os.time())

    -- title of application
    love.window.setTitle('Breakout')

    -- fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    --set inital font
    love.graphics.setFont(gFonts['small'])

    -- load up the graphics we'll be using throughout our states
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }
    
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --sounds
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav'),
        ['score'] = love.audio.newSource('sounds/score.wav'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav'),
        ['select'] = love.audio.newSource('sounds/select.wav'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav'),
        ['victory'] = love.audio.newSource('sounds/victory.wav'),
        ['recover'] = love.audio.newSource('sounds/recover.wav'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav'),
        ['pause'] = love.audio.newSource('sounds/pause.wav'),

        ['music'] = love.audio.newSource('sounds/music.wav')
    }

    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
        ['power-ups'] = GenerateQuadPowerUps(gTextures['main']),
        ['locked-brick'] = GenerateQuadLockedBrick(gTextures['main'])
    }


    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['gameover'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['highscores'] = function() return HighScoresState() end,
        ['enterhighscore'] = function() return EnterHighScoreState() end,
        ['paddleselect'] = function() return PaddleSelectState() end

    }

    -- play our music outside of all states and set it to looping
    gSounds['music']:play()
    gSounds['music']:setLooping(true)

    gStateMachine:change('start', {
        highScores = loadHighScores()
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)

    -- reset keys pressed
    love.keyboard.keysPressed = {}
end


function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    -- begin 
    push:apply('start')

    -- background should be drawn regardless of state, scaled to fit our
    -- virtual resolution
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
        0, -- x pos
        0, -- y pos 
        0, -- no rotation
        -- scale factors on X and Y axis so it fills the screen
        --we are find how many times the width of the background fits on the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    gStateMachine:render()
    
    -- display FPS for debugging; simply comment out to remove
    displayFPS()
    
    push:apply('end')
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

--console debugging
function love.conf(t)
    t.console = true
end

--global rendering functions

function renderHealth(health) 
    local xpos = VIRTUAL_WIDTH - 100

    --draw health left
    for i = 1, health do 
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], xpos, 4)
        xpos = xpos + 11
    end

    --draw missing health
    for i = 1, 3 - health do 
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], xpos, 4)
        xpos = xpos + 11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

--loads the stored highscores
function loadHighScores() 
    --set write directory folder where the list file exist
    love.filesystem.setIdentity('breakout')

    --if list files DNE
    if not love.filesystem.exists('breakout.lst') then
        local scores = ''

        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true --the first line is a name
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('breakout.lst') do
        --lines rotate between name and score
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores

end