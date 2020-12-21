ScoreState = Class{__includes = BaseState}

--credits: https://www.flaticon.com/free-icons/medal
local  first = love.graphics.newImage('first.png')
local  second = love.graphics.newImage('second.png')
local  third = love.graphics.newImage('third.png')


function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- reset game if enter/return is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end


function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')

    if self.score > 9 then
        --0.125 is 8 times smaller, and we need subtract half the image size. Therefore total of 16 times smaller giving us 32
        love.graphics.draw(first, VIRTUAL_WIDTH/2 - 32, 190, 0, 0.125, 0.125)
    elseif self.score > 4 then
        love.graphics.draw(second, VIRTUAL_WIDTH/2 - 32, 190, 0, 0.125, 0.125)
    elseif self.score > 1 then
        love.graphics.draw(third, VIRTUAL_WIDTH/2 - 32, 190, 0, 0.125, 0.125)
    end
end