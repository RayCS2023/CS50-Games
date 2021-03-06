require 'src/Dependencies'

function love.load()
    love.window.setTitle('Dodge!')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['select'] = function() return SelectCharState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
    }

    gStateMachine:change('start')

    gSounds['main']:setLooping(true)
    gSounds['main']:setVolume(0.5)
    gSounds['main']:play()

    love.keyboard.keysPressed = {}
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end