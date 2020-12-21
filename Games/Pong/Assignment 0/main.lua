--import required libraries
push = require 'push'
Class = require 'class'

--import user-defined classes/global variables
require 'Ball'
require 'Paddle'

--resize function
function love.resize(w, h)
    push:resize(w, h)
end

--first function to be called when app starts
function love.load()
    --initialize global variables
    init()

    --set game state
    gameState = 'start'

    --set title
    love.window.setTitle('Pong')

    --set filter type
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --"seed" math.random calls so the RNG remains random
    math.randomseed(os.time())

    --set active font defined in config
    love.graphics.setFont(FONT8)

    --init window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    --create ball obj
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    --create paddle obj
    p1 = Paddle(10, 30, 5, 20)
    p2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
end 

--handles user inputs
function love.keypressed(key)
    --quit is key pressed is escape
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        --reset game if in play state or start game if in start state
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            --start over
            gameState = 'serve'

            --reset scores
            P1_SCORE = 0
            P2_SCORE = 0

            --new serving player
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end


--update function to be called every frame
function love.update(dt)
    --collision check
    if gameState == 'play' then
        --left paddle collision
        if ball:collision(p1) then
            --ball moves in opposite direction will its speed scaled by little
            ball.dx = -ball.dx * SCALE_SPEED

            --in the case that the ball postiion shift to be inside the paddle, 
            --we want to reset the  ball position to be outside of the paddle
            ball.x = p1.x + p1.w 
            --if the ball was moving up
            if ball.dy < 0 then
                --randomize the angle of return after collision
                ball.dy = -math.random(10, 150)
            else -- if the ball was moving down
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end 
        --right paddle collision
        if ball:collision(p2) then
            --ball moves in opposite direction will its speed scaled by little
            ball.dx = -ball.dx * SCALE_SPEED

            --in the case that the ball postiion shift to be inside the paddle, 
            --we want to reset the  ball position to be outside of the paddle
            ball.x = p2.x - ball.w
            --if the ball was moving up
            if ball.dy < 0 then
                --randomize the angle of return after collision
                ball.dy = -math.random(10, 150)
            else -- if the ball was moving down
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end
        
        --check for top boundry
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        --check for bottom boundry
        if ball.y >= VIRTUAL_HEIGHT - ball.h then
            ball.y = VIRTUAL_HEIGHT - ball.h 
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        --update scores
        if ball.x < 0 then
            servingPlayer = 1
            P2_SCORE = P2_SCORE + 1
            sounds['score']:play()
            ball:reset()

            --check if the player2 won
            if P2_SCORE == 10 then
                winner = 2
                gameState = 'done'
            else 
                gameState = 'serve'
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            P1_SCORE = P1_SCORE + 1
            sounds['score']:play()
            ball:reset()

            --check if the a player1 won
            if P1_SCORE == 10 then
                winner = 1
                gameState = 'done'
            else 
                gameState = 'serve'
            end
        end

    elseif gameState == 'serve' then
        --get random dy
        ball.dy = math.random(-50, 50)

        --find the direction the balls need to go to
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    end

    --RIGHT PADDLE AI
    if gameState == 'play' then
        if ball.dx > 0 then
            m = ball.dy/ball.dx
            b = -ball.y + m * ball.x 
            y = m * (VIRTUAL_WIDTH - 10) - b

            if y < p2.y or y > p2.y + p2.h - ball.h then
                if p2.y > y then
                    p2.dy = -PADDLE_SPEED 
                elseif p2.y < y then
                    p2.dy = PADDLE_SPEED 
                end
            else
                p2.dy = 0
            end 
        end
    end

    --LEFT PADDLE AI
    if ball.y >= p1.y and ball.y <= p1.y + p1.h - ball.h then
        p1.dy = 0
    elseif p1.y + p1.h/2 > ball.y then
        p1.dy = -PADDLE_SPEED
    elseif p1.y + p1.h/2 < ball.y then
        p1.dy = PADDLE_SPEED
    end

    -- player 1 movement
    -- if love.keyboard.isDown('w') then
    --     p1.dy = -PADDLE_SPEED
    -- elseif love.keyboard.isDown('s') then
    --     p1.dy = PADDLE_SPEED
    -- else
    --     p1.dy = 0
    -- end

    -- player 2 movement
    -- if love.keyboard.isDown('up') then
    --     p2.dy = -PADDLE_SPEED
    -- elseif love.keyboard.isDown('down') then
    --     p2.dy = PADDLE_SPEED
    -- else
    --     p2.dy = 0
    -- end

    --update ball position
    if gameState == 'play' then
        ball:update(dt)
    end

    p1:update(dt)
    p2:update(dt)
end

--draws objs/compoents on to the canvas
function love.draw()
    --start render at virtual resolution
    push:apply('start')

    --clear background to a color
    love.graphics.clear(40, 45, 52, 255)

    --set active font
    love.graphics.setFont(FONT8)

    --print some text on based on state
    if gameState == 'start' then
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- nothing is displayed
    elseif gameState == 'done' then
        love.graphics.setFont(FONT16)
        love.graphics.printf('Player ' .. tostring(winner) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(FONT8)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    --set active font and print the player's scores
    love.graphics.setFont(FONT32)

    love.graphics.print(tostring(P1_SCORE), VIRTUAL_WIDTH / 2 - 50, 
    VIRTUAL_HEIGHT / 3)
    
    love.graphics.print(tostring(P2_SCORE), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)

    --draw the ball
    ball:render()

    --draw the paddles
    p1:render()
    p2:render()

    --render FPS
    displayFPS()

    --end render at virtual resolution
    push:apply('end')
end

--fps displayer 
function displayFPS()
    --set active font
    love.graphics.setFont(FONT8)
    
    --set active color
    love.graphics.setColor(0, 255, 0, 255)

    --print fps
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function init()
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720
    VIRTUAL_WIDTH = 432
    VIRTUAL_HEIGHT = 243
    PADDLE_SPEED = 200
    FONT8 = love.graphics.newFont('font.ttf', 8)
    FONT32 = love.graphics.newFont('font.ttf', 32)
    FONT16 = love.graphics.newFont('font.ttf', 16)
    SCALE_SPEED = 1.03
    P1_SCORE = 0
    P2_SCORE = 0
    servingPlayer = 1
    sounds = {
        ['paddle_hit'] = love.audio.newSource('assets/sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('assets/sounds/wall_hit.wav', 'static')
    }
end 