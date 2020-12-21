StartState = Class{__includes = BaseState}

local tilePositions = {}

function StartState:init() 
    --selected item on menu 
    self.currentMenuItem = 1

    --colour used to change the title
    self.colours = {
        [1] = {217, 87, 99, 255},  --red
        [2] = {95, 205, 228, 255}, --blue
        [3] = {251, 242, 54, 255}, --yellow
        [4] = {118, 66, 138, 255}, --purple
        [5] = {153, 229, 80, 255}, --green
        [6] = {223, 113, 38, 255}  --orange
    }

    --letters to be drawn on screen and their space relative to the center
    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }

    --timer to switch colou of the title
    self.colourTimer = Timer.every(0.075, function() 
        --store colour 6
        local temp = self.colours[6]

        --shift colours at curr to equal to prev
        for i = 6, 2, -1 do 
            self.colours[i] = self.colours[i-1]
        end
        self.colours[1] = temp
    end)

    --create a board of tiles to display
    for i = 1, 64 do 
        table.insert(tilePositions, gFrames['tiles'][math.random(18)][math.random(6)])
    end

    -- used to animate our full-screen transition rect
    self.transitionAlpha = 0

    -- if we've selected an option, we need to display the from reading input
    self.disableInput = false
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    --switch state if enter/return is pressed 
    if not self.disableInput then
        -- change menu item
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            gSounds['select']:play()
        end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem == 2 then
                love.event.quit()
            else
                self.disableInput = true
                --play an animation
                Timer.tween(1,{
                    [self] = {transitionAlpha = 255}
                }):finish(function()
                    gStateMachine:change('begin-game', {
                        level = 10
                    })
                end)
            end
        end
    end
    Timer.update(dt)
end

function StartState:render() 
    --render tiles
    for y = 1, 8 do
        for x = 1, 8 do
            -- render shadow first
            love.graphics.setColor(0, 0, 0, 255) --black
            --128 is the spacing for 4 block, the screen can fit 16 blocks in total
            --3 is the offset for the shadow
            love.graphics.draw(gTextures['main'], tilePositions[(y - 1) * 8 + x], 
                (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

            -- render tile
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.draw(gTextures['main'], tilePositions[(y - 1) * 8 + x], 
                (x - 1) * 32 + 128, (y - 1) * 32 + 16)
        end
    end
    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    --params: y = -60
    self:drawMatch3Text(-60)
    --params: y = 12
    self:drawOptions(12)


    -- draw our transparent rectangle that changes opacity when we chaneg state
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function StartState:drawMatch3Text(y)
    -- draw semi-transparent rect behind MATCH 3
    love.graphics.setColor(255, 255, 255, 128)
    
    -- 6 at the end is for rounded corners
    --box is 150 by 58
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 75, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)
    -- draw MATCH 3 text shadows
    love.graphics.setFont(gFonts['large'])
    self:drawTextShadow('MATCH 3', VIRTUAL_HEIGHT / 2 + y)

    --render the colourful match 3 letters
    for i = 1, 6 do  
        love.graphics.setColor(self.colours[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRTUAL_HEIGHT / 2 + y, VIRTUAL_WIDTH + self.letterTable[i][2], 'center')
    end

end

function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34, 32, 52, 255) -- gray shadow color
    --when centered, the top left is no longer at x = 0
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    --draw text starting a pixel to the left
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    --draw text starting a 2 pixels to the left
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    --draw text starting a 2 pixels to the bottom
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end

function StartState:drawOptions(y)
    -- draw rect behind start and quit game text
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 75, VIRTUAL_HEIGHT / 2 + y, 150, 58, 6)

     -- draw Start text
     love.graphics.setFont(gFonts['medium'])
     self:drawTextShadow('Start', VIRTUAL_HEIGHT / 2 + y + 8)
     
     if self.currentMenuItem == 1 then
         love.graphics.setColor(99, 155, 255, 255)
     else
         love.graphics.setColor(48, 96, 130, 255)
     end
     
     love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8, VIRTUAL_WIDTH, 'center')
 
     -- draw Quit Game text
     love.graphics.setFont(gFonts['medium'])
     self:drawTextShadow('Quit Game', VIRTUAL_HEIGHT / 2 + y + 33)
     
     if self.currentMenuItem == 2 then
         love.graphics.setColor(99, 155, 255, 255)
     else
         love.graphics.setColor(48, 96, 130, 255)
     end
     
     love.graphics.printf('Quit Game', 0, VIRTUAL_HEIGHT / 2 + y + 33, VIRTUAL_WIDTH, 'center')
end