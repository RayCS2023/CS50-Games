AlienLaunchMarker = Class{}
function AlienLaunchMarker:init(world)
    self.world = world

    --starting Coordinates
    self.baseX = 90
    self.baseY = VIRTUAL_HEIGHT - 100

    --coordinates shift was dragged
    self.shiftedX = self.baseX
    self.shiftedY = self.baseY

    --flags launcher 'status'
    self.launched = false
    self.aiming = false
    self.rotation = 0

    --player
    self.alien = nil
end

function AlienLaunchMarker:update(dt)
    
    if not self.launched then
        --mouse coordinates
        local x, y = push:toGame(love.mouse.getPosition())

        if love.mouse.wasPressed(1) and not self.launched then
            self.aiming = true
        elseif love.mouse.wasReleased(1) and self.aiming then
            self.launched = true
            
            --spawn alien
            self.alien = Alien(self.world, 'round', self.shiftedX, self.shiftedY, 'Player')
            -- apply the difference between current X,Y and base X,Y as launch vector impulse
            self.alien.body:setLinearVelocity((self.baseX - self.shiftedX) * 10, (self.baseY - self.shiftedY) * 10)

            -- make the alien pretty bouncy
            self.alien.fixture:setRestitution(0.4)

            --rolling friction
            self.alien.body:setAngularDamping(1)

            -- we're no longer aiming
            self.aiming = false
        elseif self.aiming then
            --self.rotation = self.baseY - self.shiftedY * 0.9
            self.shiftedX = math.min(self.baseX + 30, math.max(x, self.baseX - 30))
            self.shiftedY = math.min(self.baseY + 30, math.max(y, self.baseY - 30))
        end
    end
end

function AlienLaunchMarker:render()
    if not self.launched then
        -- render base alien, non physics based
        love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], 
        self.shiftedX - 17.5, self.shiftedY - 17.5)

        if self.aiming then
            -- render arrow if we're aiming, with transparency based on slingshot distance
            local impulseX = (self.baseX - self.shiftedX) * 10
            local impulseY = (self.baseY - self.shiftedY) * 10

            -- draw 6 circles simulating trajectory of estimated impulse
            local trajX, trajY = self.shiftedX, self.shiftedY
            local gravX, gravY = self.world:getGravity()

            for i = 1, 90 do
                love.graphics.setColor(255, 80, 255, (255 / 12) * i)

                -- trajectory X and Y for this iteration of the simulation
                trajX = self.shiftedX + i * 1/60 * impulseX
                trajY = self.shiftedY + i * 1/60 * impulseY + 0.5 * (i * i + i) * gravY * 1/60 * 1/60

                -- render every fifth calculation as a circle
                if i % 5 == 0 then
                    love.graphics.circle('fill', trajX, trajY, 3)
                end
            end
        end
        love.graphics.setColor(255, 255, 255, 255)
    else
        self.alien:render()
    end
end