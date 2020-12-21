SelectCharState = Class{__includes = BaseState}

TEXTURES ={'pink-monster-idle','dude-monster-idle', 'owlet-monster-idle'}

function SelectCharState:init()
    self.currChar = 1
end

function SelectCharState:update(dt) 
    if love.keyboard.wasPressed('left') then
        self.currChar = math.max(1, self.currChar - 1)
    elseif love.keyboard.wasPressed('right') then
        self.currChar = math.min(3, self.currChar + 1)
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateMachine:change('play' ,{
            currChar = self.currChar
        })
    end
end

function SelectCharState:render() 
    love.graphics.setFont(gFonts['pixel-font-medium'])
    love.graphics.printf("Select your hero", 0, VIRTUAL_HEIGHT / 8, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['pixel-font-small'])
    love.graphics.printf("(Press Enter to continue!)", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    

    if self.currChar == 1 then
        love.graphics.setColor(255, 255, 255, 200)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.setColor(COLOUR_DEFS['white'])

    if self.currChar == 3 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(255, 255, 255, 200)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.draw(gTextures[TEXTURES[self.currChar]], gFrames[TEXTURES[self.currChar]][1], VIRTUAL_WIDTH/2 - 16, VIRTUAL_HEIGHT/2 + 20)

end