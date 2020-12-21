Ball = Class{}

function Ball:init(skin)
    --ball dimensions
    self.width = 8
    self.height = 8

    --ball x and y velocity
    self.dx = 0
    self.dy = 0

    self.skin = skin

end

function Ball:collides(obj) 
    
    --check left edge of ball
    if self.x > obj.x + obj.width then
        return false
    end

    --check right edge of ball
    if self.x + self.width < obj.x then
        return false
    end

    --check top edge of  ball
    if self.y > obj.y + obj.height then
        return false
    end

    --check bottom edge of ball
    if self.y + self.height < obj.y then
        return false
    end

    --collision occured if reached this point
    return true
end

function Ball:update(dt) 
    --increament position
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    --left wall collision
    if self.x <= 0 then
        gSounds['wall-hit']:play()
        --if the ball has already pass the left wall, set the x back to be against the wall
        self.x = 0
        self.dx = -self.dx
    end

    --right wall collision
    if self.x >= VIRTUAL_WIDTH - 8 then
        gSounds['wall-hit']:play()
        --if the ball has already pass the right wall, set the x back to be against the wall
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
    end

    --top wall collision
    if self.y <= 0 then
        gSounds['wall-hit']:play()
        self.y = 0
        self.dy = -self.dy
    end


end

function Ball:reset() 
    self.x = VIRTUAL_WIDTH/2 - 2
    self.y = VIRTUAL_HEIGHT/2 - 2
    self.dx = 0
    self.dy = 0  
end

function Ball:render() 
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end