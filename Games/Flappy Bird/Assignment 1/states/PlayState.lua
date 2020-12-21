PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24


function PlayState:enter(params)
    if not (params == nil) then
        self.bird = params.bird
        self.pipePairs = params.pipePairs
        self.timer = params.timer
        self.score = params.score
        self.lastY = params.lastY
        self.pipeSpawnRate = params.pipeSpawnRate
    end
end

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

    --starts as as 2 seconds
    self.pipeSpawnRate = 2
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end


function PlayState:update(dt)
    -- update timer
    self.timer = self.timer + dt
    
    if self.timer > self.pipeSpawnRate then

        --y ∈ [-278, -90]

        --pipes will extend out from the top at least 10 px
        local topBound = -PIPE_HEIGHT + 10

        --the next pipe will have be shifted <=20 px up or down
        local nextPipe = self.lastY + math.random(-20, 20)

        --no greater then 90px from the bottom
        local bottomBound = VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT

        --where the gap should start
        local y = math.max(topBound, math.min(nextPipe, bottomBound))

        self.lastY = y
        GAP_HEIGHT = math.random(80,110)
        --insert a new pipePair and reset timer
        table.insert(self.pipePairs, PipePair(y, GAP_HEIGHT))
        self.timer = 0
        self.pipeSpawnRate = 1.5 + math.random(0,10)/10
    end

    -- update bird position
    self.bird:update(dt)

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        --check if the bird passed the pipe
        if not pair.score then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.score = true
                sounds['score']:play()
            end
        end


        -- update position of pair
        pair:update(dt)
    end

    --remove pipe if it hit the left screen
    --notes another loop needed beccause if we deleted in the above loop
    --the indices will be incorrect since after every deletion
    --all indices shift down one
    for k, pair in pairs(self.pipePairs) do
        --check for collision
        if self.bird:collides(pair.pipes.top) or self.bird:collides(pair.pipes.bot) then
            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score',{
                score = self.score
            })
        end

        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score',{
            score = self.score
        })
    end

    if love.keyboard.wasPressed('p') then
        sounds['music']:pause()
        gStateMachine:change('pause', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            timer = self.timer, 
            score = self.score, 
            lastY = self.lastY, 
            pipeSpawnRate = self.pipeSpawnRate
        })
    end

end