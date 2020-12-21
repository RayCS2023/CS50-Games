GameOverState = Class{__includes = BaseState}

function GameOverState:init() 
end

function GameOverState:update(dt) 
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateMachine:change('select')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render() 
    love.graphics.setFont(gFonts['pixel-font-medium'])
    love.graphics.printf("You've survived for " .. tostring(math.floor(self.timeSurvived)) .. " seconds", 0, VIRTUAL_HEIGHT / 8, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['pixel-font-small'])
    love.graphics.printf("Press Enter to play again!", 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['pixel-font-small'])
    love.graphics.printf('(ESC to quit)', 0, VIRTUAL_HEIGHT / 2 + 60, VIRTUAL_WIDTH, 'center')
end

function GameOverState:enter(params)
    self.timeSurvived = params.timeSurvived
end
