PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.projSets = {}
    self.vel = {}
    self.test = {}
    self.radius = 1
    self.interval = {30,33,36}
    self.projectilePattern = {'circleSpread', 'circleSpreadAtReady', 'fall', 'laser'}

    local pattern = self.projectilePattern[math.random(#self.projectilePattern)]
    local projSet = ProjSet()
    table.insert(self.projSets, projSet)
    self:generateProjectiles(pattern, projSet)

    self.patternTimer = Timer.every(6.5, function() 
         local pattern = self.projectilePattern[math.random(#self.projectilePattern)]
         local projSet = ProjSet()
         table.insert(self.projSets, projSet)
         self:generateProjectiles(pattern, projSet)
    end)
end


function PlayState:update(dt)
    self.player:update(dt)
    self:removeProjectiles()
    --print(#self.projectiles)

    for i, projSets in pairs(self.projSets) do
        if projSets.launch then
            for j, projectile in pairs(projSets.projectiles) do 
                projectile:update(dt)
            end
        end
    end

    --collision detection
    if not self.player.invulnerable then
        for i, projSets in pairs(self.projSets) do
            for j, projectile in pairs(projSets.projectiles) do 
                if self.player.collider:collides(projectile.collider) then
                    self.player.health = self.player.health - 1
                    if self.player.health > 0 then
                        self.player.invulnerable = true
                    else
                        self.player.dead = true
                    end
                    goto done
                end
            end
        end
    end
    --print(self.counter)
    ::done::
end

function PlayState:render()
    self.player:render()
    for i, projSets in pairs(self.projSets) do
        for j, projectile in pairs(projSets.projectiles) do 
            projectile:render()
        end
    end

    --render hearts
    for i = 1, self.player.health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][5], (i - 1) * (16 + 1), 2)
    end

    love.graphics.setColor(COLOUR_DEFS['white'])
    love.graphics.setFont(gFonts['simple-font-small'])
    love.graphics.printf(tostring(math.floor(self.player.timeSurvived)), 0, 0, VIRTUAL_WIDTH, 'right')
end

function PlayState:enter(params)
    self.currChar = params.currChar

    self.player = Entity{
        animations = ENTITY_DEFS['player'].animations[self.currChar],
        
        x = 4,
        y = 0,
        
        width = 32,
        height = 32,
        gravity = GRAVITY,
        walkSpeed = PLAYER_WALK_SPEED
    }
end

function PlayState:removeProjectiles()
    for i, projSet in pairs(self.projSets) do 
        if projSet.projectilesFilled then
            for j, projectile in pairs(projSet.projectiles) do 
                if projectile.remove then
                    table.remove(projSet.projectiles, j)
                end
            end
        end
    end

    for i, projSet in pairs(self.projSets) do 
        if (#projSet.projectiles) == 0 and projSet.projectilesFilled then
            table.remove(self.projSets,i)
        end
    end
end

function PlayState:generateProjectiles(pattern, projSet)

    if pattern == 'circleSpread' then
        self.timer = Timer.every(0.5, function() 
            local t = self.interval[math.random(#self.interval)]
            for deg = 0, 360 - t, t do 
                local dx = 20*math.cos(math.rad(deg)) 
                local dy = 20*math.sin(math.rad(deg))
                local x = VIRTUAL_WIDTH/2 + dx
                local y = VIRTUAL_HEIGHT/2 + dy 
                local projectile = Projectile(x, y, 2*dx, 2*dy)
                table.insert(projSet.projectiles, projectile)
            end
            projSet.projectilesFilled = true
            self.radius = self.radius + 1
            if self.radius > 8 then
                self.radius = 1
                self.timer:remove()
            end
        end)
        projSet.launch = true
    elseif pattern == 'circleSpreadAtReady' then
        self.timer = Timer.every(0.5, function() 
            local t = self.interval[math.random(#self.interval)]
            for deg = 0, 360 - t, t do 
                local dx = self.radius* 20*math.cos(math.rad(deg)) 
                local dy = self.radius* 20*math.sin(math.rad(deg))
                local x = VIRTUAL_WIDTH/2 + dx
                local y = VIRTUAL_HEIGHT/2 + dy 
                local projectile = Projectile(x, y, 2*dx/self.radius, 2*dy/self.radius)
                table.insert(projSet.projectiles, projectile)
            end
            projSet.projectilesFilled = true
            self.radius = self.radius + 1
            
            if self.radius > 8 then
                projSet.launch = true
                self.radius = 1
                self.timer:remove()
            end
        end)
    elseif pattern == 'fall' then
        for i = 1, 50 do 
            local dx = 0
            local dy = math.random(30,40)
            local x = math.random(0, VIRTUAL_WIDTH)
            local y = math.random(0, VIRTUAL_HEIGHT - 50)
            local projectile = Projectile(x, y, dx, dy)
            table.insert(projSet.projectiles, projectile)
        end
        projSet.projectilesFilled = true
        Timer.after(2, function()
            projSet.launch = true
        end)
    elseif pattern == 'laser' then
        for i = 60, 420,  60 do 
            local dx = 0
            local dy = 0
            local x = i*math.cos(math.rad(0))
            local y = i*math.sin(math.rad(0))
            local projectile = Projectile(x, y, dx, dy)
            table.insert(projSet.projectiles, projectile)
        end
        projSet.launch = true

        projSet.Timer = Timer.every(0.3, function() 
            projSet.angle = projSet.angle + 10
            for i = 1, #projSet.projectiles do 
                local toX = i*60*math.cos(math.rad(projSet.angle))
                local toY = i*60*math.sin(math.rad(projSet.angle))
                Timer.tween(0.3, {
                    [projSet.projectiles[i]] = { x = toX, y = toY}
                })
            end

            if projSet.angle == 90 then
                projSet.projectilesFilled = true
            end
        end)

        Timer.after(2.5, function() 
            local newSet = ProjSet()
            for i = 60, 420,  60 do 
                local dx = 0
                local dy = 0
                local x = -i*math.cos(math.rad(0)) + VIRTUAL_WIDTH
                local y = i*math.sin(math.rad(0))
                local projectile = Projectile(x, y, dx, dy)
                table.insert(newSet.projectiles, projectile)
            end
            table.insert(self.projSets, newSet)
            newSet.launch = true

            newSet.Timer = Timer.every(0.3, function() 
                newSet.angle = newSet.angle + 10
                for i = 1, #newSet.projectiles do 
                    local toX = -i*60*math.cos(math.rad(newSet.angle)) + VIRTUAL_WIDTH
                    local toY = i*60*math.sin(math.rad(newSet.angle))
                    Timer.tween(0.3, {
                        [newSet.projectiles[i]] = { x = toX, y = toY}
                    })
                end
    
                if newSet.angle == 90 then
                    newSet.projectilesFilled = true
                end
            end)
        end)
    end

end
