BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    --start with full opacity and fade in
    self.transitionAlpha = 255

    -- start our level # label off-screen
    self.levelLabelY = -64
end

function BeginGameState:enter(params) 
    --store level 
    self.level = params.level

    -- spawn a board and place it toward the right
    self.board = Board(VIRTUAL_WIDTH - 272, 16, self.level)

    --over a period of 1 second, transition our alpha to 0
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    }):finish(function()
        --drop the level image to the middle of screen
        Timer.tween(0.25, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        }):finish(function()
            --wait 1 second
            Timer.after(1,function() 
                --move level image to the bottom of screen
                Timer.tween(0.25, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
                }):finish(function() 
                    --change state once finished
                    gStateMachine:change('play',{
                        level = self.level,
                        board = self.board
                    })
                end)
            end)
        end)
    end)

end

function BeginGameState:update(dt)
    Timer.update(dt)
end


function BeginGameState:render()
    -- render board of tiles
    self.board:render()

    -- render Level # label and background rect
    love.graphics.setColor(95, 205, 228, 200)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    -- our transition foreground rectangle that fades out
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end