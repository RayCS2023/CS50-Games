--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end


function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end


    -- if not (self.dungeon.currentRoom.objects[2] == nil) then
    --     local pot = self.dungeon.currentRoom.objects[2]
    --     pot.x = pot.x + pot.dx * dt
    --     pot.y = pot.y + pot.dy * dt
    --     pot.disTraveled = pot.disTraveled + (pot.dx * dt + pot.dy * dt)
    --     if pot.state == 'sliding' then
    --         for i, entity in pairs(self.dungeon.currentRoom.entities) do 
    --             --print (entity.x,entity.y)
    --             if entity.collides(pot) then
    --             end
    --         end
    --     end 
    --     if pot.disTraveled > 64 then
    --         table.remove(self.dungeon.currentRoom.objects, 2)
    --     end 
    -- end
end