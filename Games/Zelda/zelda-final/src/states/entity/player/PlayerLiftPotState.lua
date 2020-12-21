PlayerLiftPotState = Class{__includes = EntityWalkState}

function PlayerLiftPotState:init(player) 
    self.entity = player
    self.entity:changeAnimation('pot-lift-' .. self.entity.direction)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerLiftPotState:update(dt)
    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        self.entity:changeState('pot-idle')
    end
end