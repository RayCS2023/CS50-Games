Collider = Class{}

--collider can be a box or a circle
function Collider:init(dims)
    self.type = dims.type
    self.x = dims.x
    self.y = dims.y
    self.w = dims.w or nil
    self.h = dims.h or nil
    self.r = dims.r or nil
end

function Collider:update(x, y, direction) 
    self.x = x
    self.y = y

    if direction == 'left' then
        self.x = self.x + 1
    end
end

function Collider:render()
    if self.type == 'box' then
        love.graphics.setColor(COLOUR_DEFS['magenta'])
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
        --love.graphics.points(self.x, self.y)
        love.graphics.setColor(COLOUR_DEFS['white'])
    else
        love.graphics.setColor(COLOUR_DEFS['magenta'])
        love.graphics.circle('line', self.x, self.y, self.r)
        --love.graphics.points(self.x, self.y)
        love.graphics.setColor(COLOUR_DEFS['white'])
    end
end

function Collider:collides(collider)
    if self.type == 'box' and collider.type == 'circular' then
        return self:circleBoxCollision(collider)
    elseif self.type == 'box' and collider.type == 'box' then
        return self:BoxBoxCollision(collider)
    end

end

function Collider:circleBoxCollision(collider)
    local deltaX = collider.x - math.max(self.x, math.min(collider.x, self.x + self.w))
    local deltaY = collider.y - math.max(self.y, math.min(collider.y, self.y + self.h))

    -- pythagorean theorem to check distance.
    return (deltaX * deltaX + deltaY*deltaY) < (collider.r * collider.r)
end

-- AABB collision
function Collider:BoxBoxCollision(collider)
    return not (self.x > collider.x + collider.w or self.x + self.w < collider.x or 
            self.y > collider.y + collider.h or self.y + self.h < collider.y)
end