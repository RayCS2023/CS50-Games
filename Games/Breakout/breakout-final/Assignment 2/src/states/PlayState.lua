PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    params.ball.dx = math.random(-200, 200)
    params.ball.dy = math.random(-50, -60)

    -- grab game state vars from params
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = {params.ball}
    self.level = params.level
    self.highScores = params.highScores
    self.recoverPoints = params.recoverPoints
    self.paddlePoints = params.paddlePoints

    --vars for spawning Power-up
    self.spawningPowerUp = false
    self.timer = 0
    self.keyPowerActive = false
end

function PlayState:update(dt)

    self.timer = self.timer + dt

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    --update paddle movement
    self.paddle:update(dt)

    --update ball movement
    for k, ball in pairs(self.ball) do
        ball:update(dt)
    end

    --timer for power up spawn
    if self.timer > math.random(3,10) and not self.spawningPowerUp then
        self.spawningPowerUp = true
        self.powerUp = PowerUp()
        self.powerUp.dy = 100
    end

    if self.spawningPowerUp then
        self.powerUp:update(dt)
        if self.powerUp:collides(self.paddle) then
            if self.powerUp.PowerType == 10 then
                    print('key power')
                    self.keyPowerActive = true
                    self.spawningPowerUp = false
                    self.timer  = 0
            else 
                print('ball power')
                self.spawningPowerUp = false
                self.timer  = 0
                
                local ball1 = Ball()
                local ball2 = Ball()

                ball1.skin = math.random(7)
                ball2.skin = math.random(7)

                --hardcoded new ball positions
                ball1.x = self.paddle.x + self.paddle.width/2 - ball1.width/2
                ball1.y = self.paddle.y - ball1.width
                ball2.x = self.paddle.x + self.paddle.width/2 - ball2.width/2
                ball2.y = self.paddle.y - ball2.width

                --give ball random starting velocity
                ball1.dx = math.random(-200, 200)
                ball1.dy = math.random(-50, -60)
                ball2.dx = math.random(-200, 200)
                ball2.dy = math.random(-50, -60)

                table.insert(self.ball, ball1)
                table.insert(self.ball, ball2) 
            end
        elseif self.powerUp.y > VIRTUAL_HEIGHT then
            print('did not catch')
            self.spawningPowerUp = false
            self.timer = 0
        end
    end
    
    --check for collision
    for k, ball in pairs(self.ball) do
        if ball:collides(self.paddle) then
            gSounds['paddle-hit']:play()
            --bounce ball up 
            ball.dy = -ball.dy

            --this is to avoid infinite collision if the ball is inside the paddle
            ball.y = self.paddle.y - 8 --8 is the diameter of the ball

            --if collision on left side of the paddle when the paddle is moving left
            if self.paddle.dx < 0 and ball.x < self.paddle.x + (self.paddle.width/2) then
                ball.dx = -50 - (8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                -- else if we hit the paddle on its right side while moving right...
            elseif self.paddle.dx > 0 and ball.x > self.paddle.x + (self.paddle.width / 2) then
                --math.abs, because the value is going to negative
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
        end
    end

    --check for brick collision
    for k, ball in pairs(self.ball) do
        for k,brick in pairs(self.bricks) do 

            if not brick.destroyed and ball:collides(brick) then
                if not brick.locked or (brick.locked and self.keyPowerActive) then
                    if brick.locked then
                        self.score  = self.score + 1000
                    else
                        self.score  = self.score + (brick.tier * 200 + brick.color * 25)
                    end

                    brick:hit()
                    
                    -- if we have enough points, recover a point of health
                    if self.score > self.recoverPoints then
                        -- can't go above 3 health
                        self.health = math.min(3, self.health + 1)

                        -- multiply recover points by 2
                        self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                        -- play recover sound effect
                        gSounds['recover']:play()
                    end

                    if self.score > self.paddlePoints then
                        --increase the size paddle
                        if not (self.paddle.size == 4) then
                            self.paddle.size = self.paddle.size + 1
                            self.paddle.width = self.paddle.size * 32
                        end

                        --increase paddle points
                        self.paddlePoints = self.paddlePoints + 5000
                    end
                    

                    if brick.destroyed then
                        table.remove(self.bricks, k)
                        print(#self.bricks)
                    end

                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            ball = self.ball[1],
                            highScores = self.highScores,
                            recoverPoints = self.recoverPoints,
                            paddlePoints = self.paddlePoints
                        })
                    end
                end
                --when the ball is moving right and hits left of brick
                if ball.dx + 2 > 0 and ball.x < brick.x then
                    ball.dx = -ball.dx
                    ball.x = brick.x - ball.width
                --when the ball is moving left and hits right of brick
                elseif ball.dx < 0 and brick.x + brick.width < ball.x + ball.width then
                    ball.dx = -ball.dx
                    ball.x = brick.x + brick.width
                elseif ball.y < brick.y then
                    ball.dy = -ball.dy
                    ball.y = brick.y - ball.height
                else
                    ball.dy = -ball.dy
                    ball.y = brick.y + brick.height
                end

                --scale 
                ball.dy = ball.dy * 1.02

                --allows for collision with one block only
                break;
            end
            brick:update(dt)
        end
    end

    --if the balls goes below the paddle
    for k, ball in pairs(self.ball) do
        if ball.y > VIRTUAL_HEIGHT then
            if #self.ball ==  1 then
                --lose health and play sound
                self.health = self.health - 1

                --shrink the paddle
                if not (self.paddle.size == 1) then
                    self.paddle.size = self.paddle.size - 1
                    self.paddle.width = self.paddle.size * 32
                end
                gSounds['hurt']:play()

                if self.health > 0 then
                    --go to serve if we still have health left
                    gStateMachine:change('serve', {
                        paddle = self.paddle,
                        bricks = self.bricks,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        recoverPoints = self.recoverPoints,
                        paddlePoints = self.paddlePoints
                    })
                else
                    gStateMachine:change('gameover', {
                        score = self.score,
                        highScores = self.highScores
                    })
                end
            else
                table.remove(self.ball, k)
            end
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end

function PlayState:render() 
    self.paddle:render()

    for k, ball in pairs(self.ball) do
        ball:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    --render the bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
        brick:renderParticles()
    end

    if self.spawningPowerUp then
        self.powerUp:render()
    end

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end

    --render key power ups
    if self.keyPowerActive then
        love.graphics.draw(gTextures['main'], gFrames['power-ups'][10], 0, VIRTUAL_HEIGHT - 16)
    end
end

function PlayState:checkVictory() 
    return #self.bricks==0 and true or false
end