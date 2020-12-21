Tile = Class{}

function Tile:init(x, y, color, variety, shiny) 
    -- board positions
    self.boardX = x
    self.boardY = y

    -- board coordinate coordinates
    self.x = (self.boardX - 1) * 32
    self.y = (self.boardY - 1) * 32

    -- tile appearance/points
    self.colour = color
    self.variety = variety

    self.shiny = shiny

    --max of 64 particle for this  system
    self.psystem = love.graphics.newParticleSystem(gTextures['shiny'], 2)

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    self.psystem:setLinearAcceleration(
        -15, --min x acceleration
            -15, --min y acceleration
            15, --max x acceleration
            15  --max y acceleration
    )

    -- spread of particles; normal looks more natural than uniform, which is clumpy; numbers
    -- are the spawn distance away in X and Y axis
    self.psystem:setAreaSpread('normal', 5, 5)

    self.psystem:setSizes(0.05)

    if self.shiny then
        Timer.every(0.5, function()
            self.psystem:emit(2)
        end)
    end 
end

function Tile:update(dt) 
    self.psystem:update(dt)
end

function Tile:render(x,y) 
    --x and y are offsets
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.colour][self.variety], self.x + x + 2, self.y + y + 2)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.colour][self.variety], self.x + x, self.y + y)

    if self.shiny then
        love.graphics.draw(self.psystem, self.x + VIRTUAL_WIDTH - 272 + 20, self.y + 16 + 15)
    end
end

function Tile:swap(tile, tileBoard)
    local tempX = self.boardX
    local tempY = self.boardY

    self.boardX = tile.boardX
    self.boardY = tile.boardY

    tile.boardX = tempX
    tile.boardY = tempY
end