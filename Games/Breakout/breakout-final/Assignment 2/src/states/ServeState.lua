ServeState = Class{__includes = BaseState}

function ServeState:enter(params) 
    --initiail all required objects
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = Ball()
    self.ball.skin = math.random(7)
    self.level = params.level
    self.recoverPoints = params.recoverPoints
    self.paddlePoints = params.paddlePoints

end

function ServeState:update(dt) 

    --have the balls sit on top of the paddle
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + self.paddle.width/2 - self.ball.width/2
    self.ball.y = self.paddle.y - self.ball.width

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level,
            highScores = self.highScores,
            recoverPoints = self.recoverPoints,
            paddlePoints = self.paddlePoints
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    --draw the ball and paddle
    self.paddle:render()
    self.ball:render()

    --draw the bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    --draw the score and health
    renderScore(self.score)
    renderHealth(self.health)

    --text for user
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end