PauseState = Class{__includes = BaseState}

local pause = love.graphics.newImage('pause.png')


function PauseState:enter(params)
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.score = params.score
    self.lastY = params.lastY
    self.pipeSpawnRate = params.pipeSpawnRate
end

function PauseState:update(dt)
    -- reset game if enter/return is pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            timer = self.timer, 
            score = self.score, 
            lastY = self.lastY, 
            pipeSpawnRate = self.pipeSpawnRate
        })
        sounds['music']:play()
    end
end


function PauseState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
    
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Paused', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press "p" to continue', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(pause, VIRTUAL_WIDTH/2 - 32, VIRTUAL_HEIGHT/2, 0, 0.125, 0.125)

end