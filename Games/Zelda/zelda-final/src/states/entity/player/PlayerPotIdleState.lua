PlayerPotIdleState = Class{__includes = EntityIdleState}

function PlayerPotIdleState:init(player,dungeon)
    self.dungeon = dungeon 
    self.entity = player
    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.dungeon.currentRoom.objects[2].collidable = false
    self.dungeon.currentRoom.objects[2].state = 'lift'

end

function PlayerPotIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pot-walk')
    end

    local pot = self.dungeon.currentRoom.objects[2]
    if self.entity.direction == 'right' then
        pot.x = self.entity.x + 2
        pot.y = self.entity.y - pot.height/2 - 4
    elseif self.entity.direction == 'up' then
        pot.x = self.entity.x 
        pot.y = self.entity.y - pot.height/2 - 4
    elseif self.entity.direction == 'down' then
        pot.x = self.entity.x 
        pot.y = self.entity.y - pot.height + 5
    else 
        pot.x = self.entity.x - 2
        pot.y = self.entity.y - pot.height/2 - 4
    end


    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then  
        if self.entity.direction == 'left' then
            pot.y = pot.y + pot.height
            pot.x = pot.x - 16
            pot.fire(-50,0)
        elseif self.entity.direction == 'right' then
            pot.y = pot.y + pot.height
            pot.x = pot.x + 16
            pot.fire(50,0)
        elseif self.entity.direction == 'up' then
            pot.fire(0,-50)
        else
            pot.y = pot.y + self.entity.height
            pot.fire(0,50)
        end
        pot.state = 'sliding'
        self.entity:changeState('idle')
    end
end