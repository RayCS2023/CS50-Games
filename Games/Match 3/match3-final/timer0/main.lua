push = require 'push'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()  

    currSecond = 0
    secTimer = 0

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    }) 

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

    secTimer = secTimer + dt
    
    if secTimer > 1 then
        currSecond = currSecond + 1
        secTimer = secTimer % 1 --set to time pass after 1 second
    end
end

function love.draw() 
    push:start()
    love.graphics.printf('Timer: ' .. tostring(currSecond) .. ' seconds',
    0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
    push:finish()
end