Ball = Class{}

--constructor
function Ball:init(x, y, w, h)
    --member variables
    self.x = x
    self.y  = y
    self.w = w
    self.h = h
end

--reset ball position to inital game state
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
end

--update ball position (called every frame)

function Ball:update(dt)
    --mutiple by dt to make  movement time dependant instead of frame dependant
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

--draw to the ball to the canvas 
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

--AABB Collision
function Ball:collision(paddle)
    --check left and right edges
    if self.x > paddle.x + paddle.w or paddle.x > self.x +self.w then
        return false
    end

    --check top and bottom edge
    if self.y > paddle.y + paddle.h or paddle.y > self.y + self.h then
        return false
    end

    --collision occured otherwise
    return true
end

