GameObject = Class{}

function GameObject:init(def, x, y) 
    --string identifying object type
    self.type = def.type

    --animations 
    self.texture = def.texture
    self.frame = def.frame or 1

    --collable object or not
    self.solid = def.solid
    self.consumable = def.consumable
    self.collidable = def.collidable
    self.remove = false

    --pressed or unpressed state
    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    --dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end

function GameObject:collides(target)
    --print(self.x, self.y)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end