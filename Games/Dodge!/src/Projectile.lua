Projectile = Class{}

function Projectile:init(x, y , dx, dy)
    self.x = x
    self.y = y
    self.r = 3
    self.dx = dx
    self.dy = dy
    self.remove = false
    self.collider = Collider{
        type = 'circular',
        x = self.x,
        y = self.y,
        r = self.r
    }
end

function Projectile:update(dt)

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.x + self.r < 0 or self.x - self.r > VIRTUAL_WIDTH then
        self.remove = true
    end

    if self.y + self.r < 0 or self.y - self.r > VIRTUAL_HEIGHT then
        self.remove = true
    end

    self.collider:update(self.x, self.y)
    
end

function Projectile:render()
    love.graphics.setColor(COLOUR_DEFS['white'])
    love.graphics.circle( 'fill', self.x, self.y, self.r)

    self.collider:render()
end