Level = Class{}

function Level:init() 
    self.world = love.physics.newWorld(0, 300)

    self.destroyedBodies = {}

    self.newPlayers = {}
    --callback function upon collision
    function beginContact(a, b, coll) 
        
        local types = {}
        types[a:getUserData()] = true
        types[b:getUserData()] = true


        if types['Obstacle'] and types['Player'] then
            self.collided = true
            --print(a:getUserData(), b:getUserData())
            --destroy block if the player veolcity is fast enough
            if a:getUserData() == 'Obstacle' then
                local velX, velY = b:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, a:getBody())
                end
            else
                local velX, velY = a:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)
                --print(a:getBody():getX(), a:getBody():getY())

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, b:getBody())
                end
            end
        end

        if types['Obstacle'] and types['Alien'] then

            -- destroy the alien if falling debris is falling fast enough
            if a:getUserData() == 'Obstacle' then
                local velX, velY = a:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, b:getBody())
                end
            else
                local velX, velY = b:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, a:getBody())
                end
            end
        end

        -- if we collided between the player and the alien...
        if types['Player'] and types['Alien'] then
            self.collided = true

            -- destroy the alien if player is traveling fast enough
            if a:getUserData() == 'Player' then
                local velX, velY = a:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)
                
                if sumVel > 20 then
                    --table.insert(self.destroyedBodies, b:getBody())
                end
            else
                local velX, velY = b:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, a:getBody())
                end
            end
        end

        -- if we hit the ground, play a bounce sound
        if types['Player'] and types['Ground'] then
            self.collided = true
            gSounds['bounce']:stop()
            gSounds['bounce']:play()
        end
    end

    --other collision call back functions
    function endContact(a, b, coll)
        
    end

    function preSolve(a, b, coll)

    end

    function postSolve(a, b, coll, normalImpulse, tangentImpulse)

    end

    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    self.aliens = {}
    table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - TILE_SIZE - ALIEN_SIZE / 2, 'Alien'))

    self.obstacles = {}
    table.insert(self.obstacles, Obstacle(self.world, 'vertical',
    VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 35 - 110 / 2))
    table.insert(self.obstacles, Obstacle(self.world, 'vertical',
    VIRTUAL_WIDTH - 35, VIRTUAL_HEIGHT - 35 - 110 / 2))
    table.insert(self.obstacles, Obstacle(self.world, 'horizontal',
    VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - 35 - 110 - 35 / 2))

    -- simple edge shape to represent collision for ground
    self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH * 3, 0)

    --ground
    self.groundBody = love.physics.newBody(self.world, -VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 35, 'static')
    self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape)
    self.groundFixture:setFriction(0.5)
    self.groundFixture:setUserData('Ground')

    self.background = Background()
    self.launchMarker = AlienLaunchMarker(self.world)
end

function Level:update(dt)

    --check was space bar press
    if self.launchMarker.launched and love.keyboard.wasPressed('space') and #self.newPlayers  < 2 and not(self.collided) then
        local x = self.launchMarker.alien.body:getX()
        local y = self.launchMarker.alien.body:getY()
        local xVel, yVel = self.launchMarker.alien.body:getLinearVelocity()
        table.insert(self.newPlayers, Alien(self.world, 'round', x, y+30, 'Player'))
        table.insert(self.newPlayers, Alien(self.world, 'round', x, y-30, 'Player'))
        self.newPlayers[1].body:setLinearVelocity(xVel, yVel + 30)
        self.newPlayers[2].body:setLinearVelocity(xVel, yVel - 30)
        for i, newPlayers in pairs(self.newPlayers) do
            newPlayers.fixture:setRestitution(0.4)
            newPlayers.body:setAngularDamping(1)
        end
    end 

    self.world:update(dt)
    self.launchMarker:update(dt)

    --remove all destroyed bodies
    for k, body in pairs(self.destroyedBodies) do
        if not body:isDestroyed() then 
            body:destroy()
        end
    end

    self.destroyedBodies = {}

    -- remove newplayer
    for i = #self.newPlayers, 1, -1 do
        if self.newPlayers[i].body:isDestroyed() then
            table.remove(self.newPlayers, i)
        end
    end

    -- remove all destroyed obstacles 
    for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].body:isDestroyed() then
            table.remove(self.obstacles, i)

            -- play random wood sound effect
            local soundNum = math.random(5)
            gSounds['break' .. tostring(soundNum)]:stop()
            gSounds['break' .. tostring(soundNum)]:play()
        end
    end

    -- remove all destroyed aliens
    for i = #self.aliens, 1, -1 do
        if self.aliens[i].body:isDestroyed() then
            table.remove(self.aliens, i)
            gSounds['kill']:stop()
            gSounds['kill']:play()
        end
    end

    --here
    -- replace launch marker if original alien stopped moving
    if self.launchMarker.launched then
        for i, newPlayers in pairs(self.newPlayers) do
            local xPos, yPos = newPlayers.body:getPosition()
            local xVel, yVel = newPlayers.body:getLinearVelocity()

            if not (math.abs(xVel) + math.abs(yVel) < 1.5) and not (xPos < 0) then
                return
            end
        end

        local xPos, yPos = self.launchMarker.alien.body:getPosition()
        local xVel, yVel = self.launchMarker.alien.body:getLinearVelocity()
        
        -- if we fired our alien to the left or it's almost done rolling, respawn
        if xPos < 0 or (math.abs(xVel) + math.abs(yVel) < 1.5) then
            --destroy and remove added players
            for i, newPlayers in pairs(self.newPlayers) do 
                table.insert(self.destroyedBodies, newPlayers.body)
            end

            self.launchMarker.alien.body:destroy()
            self.launchMarker = AlienLaunchMarker(self.world)
            self.collided = false

            -- re-initialize level if we have no more aliens
            if #self.aliens == 0 then
                gStateMachine:change('start')
            end
        end
    end
end

function Level:render()
    self.launchMarker:render()

    --render ground tiles
    for x = -VIRTUAL_WIDTH, VIRTUAL_WIDTH * 2, 35 do
        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12], x, VIRTUAL_HEIGHT - 35)
    end

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    for k, obstacle in pairs(self.obstacles) do
        obstacle:render()
    end

    for k, newPlayers in pairs(self.newPlayers) do
        newPlayers:render()
    end

    -- render instruction text if we haven't launched bird
    if not self.launchMarker.launched then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf('Click and drag circular alien to shoot!',
            0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
    end

    -- render victory text if all aliens are dead
    if #self.aliens == 0 then
        love.graphics.setFont(gFonts['huge'])
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
    end
end