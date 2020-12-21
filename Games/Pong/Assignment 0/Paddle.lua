Paddle = Class{}

--constructor
function Paddle:init(x, y, w, h)
    --member variables
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.dy = 0
end

--updates paddle position
function Paddle:update(dt)
    --move up
    if(self.dy < 0) then
        --top bound
        self.y = math.max(0, self.y + self.dy * dt)
    else -- move down
        --bottom bound
        self.y = math.min(VIRTUAL_HEIGHT - self.h, self.y + self.dy * dt)
    end
end


--draw the paddle on canvas
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end