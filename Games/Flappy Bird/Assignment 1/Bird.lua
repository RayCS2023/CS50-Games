Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image =  love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --inital position  of bird at middle of screen
    self.x = VIRTUAL_WIDTH/2 -  (self.width / 2)
    self.y = VIRTUAL_HEIGHT/2 - (self.height / 2)

    --no falling velocity initally
    self.dy = 0
end

function Bird:update(dt)
    --idea of acceleration, every frame, dy increases
    self.dy = self.dy + GRAVITY * dt

    --check if space was pressed
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        sounds['jump']:play()
        self.dy = -5
    end

    --update y position (we dont mutiple by dt becuase dy is already frame independant)
    --every 60 frames (fps of your system), dy is increase by 20
    self.y = self.y + self.dy

end

function Bird:render()
    
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
    -- +2 and -4 are offsets to make the hit box smaller
    -- i.e +2 from the top left corner and then add the width will give 2 extra over the the right edge. However we want
    -- 2 pixels before the right edge, thus we have to subtract 4


    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end



