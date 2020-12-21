Alien  = Class{}

function Alien:init(world, type, x, y, userData)
    self.rotation = 0

    self.world = world
    self.type = type or 'square'

    self.body = love.physics.newBody(self.world, x or math.random(VIRTUAL_WIDTH), y or math.random(VIRTUAL_HEIGHT), 'dynamic')

    if self.type == 'square' then
        self.shape = love.physics.newRectangleShape(35, 35)
        self.sprite = math.random(5)
    else 
        self.shape = love.physics.newCircleShape(17.5)
        self.sprite = 9
    end

    self.fixture = love.physics.newFixture(self.body, self.shape)

    --set arbitary data to a fixture
    --custom metadata
    self.fixture:setUserData(userData)

    self.launched = false
end

function Alien:render()
    love.graphics.draw(gTextures['aliens'], gFrames['aliens'][self.sprite], math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(), 
    1, 1, --scale factors
    17.5, 17.5) --origin offsets
end