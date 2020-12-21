StartState = Class{__includes = BaseState}


function StartState:init()
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('select')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setFont(gFonts['pixel-font-large'])
    love.graphics.setColor(COLOUR_DEFS['white'])

    love.graphics.printf('Dodge!', 0, VIRTUAL_HEIGHT / 2 - 70, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['pixel-font-medium'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['pixel-font-small'])
    love.graphics.printf('(ESC to quit)', 0, VIRTUAL_HEIGHT / 2 + 60, VIRTUAL_WIDTH, 'center')

end

function StartState:enter(params)
end