Paddle = Class{}

function Paddle:init(skin) 
    --x position
    self.x = VIRTUAL_WIDTH/2 - 32

    --y position
    self.y = VIRTUAL_HEIGHT - 32

    --initial velcity
    self.dx = 0

    -- medium paddl dimensions
    self.width = 64
    self.height = 16

    --paddle skin
    self.skin = skin

    --paddle size
    self.size = 2
end 

function Paddle:update(dt) 

    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED 
    else
        self.dx = 0
    end

    --check to prevent paddle from moving pass the boundries
    if self.dx < 0 then --moving left
        self.x = math.max(0,self.x + self.dx * dt)
    else --moving right
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt )
    end

end

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x, self.y)
end
