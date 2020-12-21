Brick = Class{}


--particle colours
particleColours = {
    --blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    },
    [6] = {
        ['r'] = 128,
        ['g'] = 128,
        ['b'] = 128
    }
}

function Brick:init(x, y) 
    -- used for coloring and score calculation
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y

    --brick dimensions
    self.width = 32
    self.height = 16

    --use to see if the block if destroyed or not
    self.destroyed = false

    --max of 64 particle for this  system
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    self.psystem:setLinearAcceleration(
        -15, --min x acceleration
          0, --min y acceleration
         15, --max x acceleration
         80  --max y acceleration
    )

    -- spread of particles; normal looks more natural than uniform, which is clumpy; numbers
    -- are the spawn distance away in X and Y axis
    self.psystem:setAreaSpread('normal', 10, 10)

    self.locked = false

end

function Brick:hit() 

    --color transition over the life time of the particle. 
    --In this case the color stay the same but the opacity(brightness) changes
    if not self.locked then
        self.psystem:setColors(
            particleColours[self.color].r, --RBG color r component
            particleColours[self.color].g, --RBG color g component
            particleColours[self.color].b, --RBG color b component
            55 * (self.tier + 1),        --RBG color alpha componenet(brightness)
            particleColours[self.color].r, 
            particleColours[self.color].g,
            particleColours[self.color].b,
            0
        )
        self.psystem:emit(64)
    end

    -- sound on hit
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()



    --check locked brick
    if self.locked then
        self.locked = false
        self.tier = 0
        self.color = 6
    --if we are at the lowest tier
    elseif self.tier == 0 then
        --if we are at base color blue a tier 1
        if self.color == 1 then
            self.destroyed = true
        else 
            self.color = self.color - 1
        end
    else
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    end

    -- play a second layer sound if the brick is destroyed
    if self.destroyed then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end

function Brick:update(dt)
    --updatee the particle system
    self.psystem:update(dt)
    
end

function Brick:renderParticles()
    --these coordinates points to the center of the brick
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end

function Brick:render() 
    if not self.destroyed then
        if self.locked then
            love.graphics.draw(gTextures['main'], 
            gFrames['locked-brick'][1],
            self.x, self.y)
        else
            love.graphics.draw(gTextures['main'], 
            gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
            self.x, self.y)
        end
    end
end