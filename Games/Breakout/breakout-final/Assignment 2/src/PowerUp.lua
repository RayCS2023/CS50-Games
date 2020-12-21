PowerUp = Class{}

function PowerUp:init()
    self.width = 16
    self.height = 16

    self.PowerType = math.random(9,10)

    self.y = -self.height
    self.x = math.random(0, VIRTUAL_WIDTH - self.width - 16)
    self.dy = 0 
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:collides(obj)
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

function PowerUp:render()
    love.graphics.draw(gTextures['main'], gFrames['power-ups'][self.PowerType], self.x, self.y)
end