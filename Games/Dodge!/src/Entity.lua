Entity = Class()

function Entity:init(def)
    self.animations = self:createAnimations(def.animations)
    self:changeAnimation('idle')
    self.direction = 'right'

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    self.timeSurvived = 0
    self.reflect = false
    self.gravity = def.gravity
    self.dx = def.walkSpeed
    self.dy = 0
    self.health = 3
    self.invulnerable = false
    self.flashTimer = 0
    self.invulnerableTimer = 0
    self.invulnerableDuration = 1.5
    self.dead = false
    self.disableInput = false
    self.deathAnimation = nil
    self.collider = Collider{
        type = 'box',
        x = self.x,
        y = self.y,
        w = self.width/2 - 10,
        h = self.height/2 - 5
    }
 
end

function Entity:update(dt) 
    self.timeSurvived = self.timeSurvived + dt

    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.flashTimer = 0
        end
    end

    if self.dead and not self.deathAnimation then
        self.disableInput = true
        self:changeAnimation('death')
        self.deathAnimation = self.currentAnimation
    end

    self.dy =  self.dy + self.gravity * dt

    if not self.disableInput then
        if love.keyboard.isDown('left') then
            self:changeAnimation('walk')
            self.x = math.max(4, self.x - self.dx * dt)
            self.reflect = true
            self.direction = 'left'
        elseif love.keyboard.isDown('right') then
            self:changeAnimation('walk')
            self.x = math.min(VIRTUAL_WIDTH - 4,self.x + self.dx * dt)
            self.reflect = false
            self.direction = 'right'
        else
            self:changeAnimation('idle')
            if self.direction == 'left' then
                self.reflect = true
            else
                self.reflect = false
            end
        end

        if love.keyboard.wasPressed('space') and self.y == VIRTUAL_HEIGHT - 8 then
            self.dy =  PLAYER_JUMP_VELOCITY
            gSounds['jump']:play()
        end
    end

    self.y =  math.min(VIRTUAL_HEIGHT - 8 , self.y +  self.dy * dt)

    self.collider:update(self.x - 4, self.y - 4, self.direction)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self.deathAnimation then
        if self.deathAnimation.timesPlayed == 1 then
            gStateMachine:change('game-over', {
                timeSurvived = self.timeSurvived 
            })
        end
    end

end

function Entity:render()
    local anim = self.currentAnimation
    love.graphics.setColor(COLOUR_DEFS['white'])

    if self.invulnerable and self.flashTimer > 0.1 then
        self.flashTimer = 0
        love.graphics.setColor(255, 255, 255, 64)
    end

    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],math.floor(self.x), math.floor(self.y),
    0, -- rotation
    self.reflect == true and -0.5 or 0.5, --x scale
    0.5, -- y sacle
    16, -- x origin offset
    16) -- y origin offset

    --self.collider:render()
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end