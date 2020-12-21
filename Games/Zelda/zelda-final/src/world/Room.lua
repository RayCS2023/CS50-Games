Room = Class{}

function Room:init(player)
    --height and width in tiles of the room
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    --tiles of the room
    self.tiles = {}
    self:generateWallsAndFloors()

    --enemies in the room
    self.entities = {}
    self:generateEntities()

    --switches/other pick ups
    self.objects = {}
    self:generateObjects()

    --the door in the room
    self.doorways = {}
    table.insert(self.doorways, Doorway('top', false, self))
    table.insert(self.doorways, Doorway('bottom', false, self))
    table.insert(self.doorways, Doorway('left', false, self))
    table.insert(self.doorways, Doorway('right', false, self))

    self.player = player
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
  
    --flag to see if we have collided with the pot
    self.potCollided = false
end

function Room:generateWallsAndFloors()
    --add tiles
    for y = 1, self.height do 
        table.insert(self.tiles,{})

        for x = 1, self.width do 
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
             -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end

            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    --generate 10 random enemies
    for i = 1, 10 do 
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = 16,
            height = 16,

            health = 1
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end

function Room:generateObjects() 
    --add a switch to game objects
    table.insert(self.objects, GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    ))  

    --add a pot at random
    table.insert(self.objects, GameObject(
        GAME_OBJECT_DEFS['pot'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
        VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
        VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    ))  

    --set the collision function of the switch
    self.objects[1].onCollide = function()
        if self.objects[1].state == 'unpressed' then
            self.objects[1].state = 'pressed'

            -- open all doors
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end
            gSounds['door']:play()
        end
    end
    self.objects[2].disTraveled = 0
    self.objects[2].dx = 0
    self.objects[2].dy = 0
    self.objects[2].fire = function(xVel, yVel) 
        self.objects[2].dx = xVel
        self.objects[2].dy = yVel
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        if not ( object.type == 'pot') then
            object:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - 6,
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
        
        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)
    
    if self.player then
        self.player:render()
    end

    love.graphics.setStencilTest()

    for k, object in pairs(self.objects) do
        if object.type == 'pot' then
            object:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end
end

function Room:update(dt)
    if #self.objects > 1 then
        if self.objects[2].state == 'lift' and self.objects[1].state == 'pressed' then
            for k, doorway in pairs(self.doorways) do
                doorway.open = false
            end
        elseif not (self.objects[2].state == 'lift') and self.objects[1].state == 'pressed' then
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end
        end
    end

    self:clearObjects()
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)



    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- remove entity from the table if health is <= 0
        if entity.health <= 0 then
            entity.dead = true
            if not entity.heartDroped then
                entity.heartDroped = true
                if math.random(2) == 1 then
                    local heart = GameObject(
                        GAME_OBJECT_DEFS['heart'],
                        entity.x,
                        entity.y
                    )
                    heart.onConsume = function()
                        --add health
                        self.player.health = math.min(6, self.player.health + 2)
                        --remove heart object
                        for i, object in pairs(self.objects) do 
                            if object.type == 'heart' then
                                table.remove(self.objects, i)
                            end
                        end
                    end 
                    table.insert(self.objects, heart)
                end
            end
        elseif not entity.dead then
            entity:processAI({room = self}, dt)
            entity:update(dt)
        end

        -- collision between the player and entities in the room
        if not entity.dead and entity:collides(self.player) and not self.player.invulnerable then
            gSounds['hit-player']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                gStateMachine:change('game-over')
            end
        end
    end

    --check for collision on pixel ahead so when you set the player positin later, it won't flicker
    if self.player.direction == 'left' then
        self.player.x = self.player.x - 1
    elseif self.player.direction == 'right' then
        self.player.x = self.player.x + 1
    elseif self.player.direction =='up' then
        self.player.y = self.player.y - 1
    else 
        self.player.y = self.player.y + 1
    end

    for k, object in pairs(self.objects) do
        --object:update(dt)

        -- trigger collision callback on object
        if self.player:collides(object) then
            if object.consumable then
                object:onConsume()
            elseif object.collidable then
                object:onCollide()
                if object.solid then
                    self.potCollided = true
                    if self.player.direction == 'left' then
                        self.player.x = object.x + object.width 
                    elseif self.player.direction == 'right' then
                        self.player.x = object.x - self.player.width
                    elseif self.player.direction == 'up' then
                        self.player.y = object.y + object.height - self.player.height / 2
                    else 
                        self.player.y = object.y - self.player.height
                    end
                end
            end
        else 
            self.potCollided = false
        end
    end

    if self.player.direction == 'left' then
        self.player.x = self.player.x + 1
    elseif self.player.direction == 'right' then
        self.player.x = self.player.x - 1
    elseif self.player.direction =='up' then
        self.player.y = self.player.y + 1
    else 
        self.player.y = self.player.y - 1
    end

    if self.potCollided then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            self.player:changeState('lift-pot')
        end
    end


    for i, obj in pairs(self.objects) do 
        if obj.state == 'sliding' and obj.type == 'pot' then
            obj.x = obj.x + obj.dx * dt
            obj.y = obj.y + obj.dy * dt
            obj.disTraveled = obj.disTraveled + (obj.dx * dt + obj.dy * dt)

            --collision with entity
            for k, entity in pairs(self.entities) do
                if not entity.dead and entity:collides(obj) then
                    entity:damage(1)
                    obj.remove = true
                    break
                end
            end

            --travelled more than 4 tilts
            if math.abs(math.floor(obj.disTraveled)) >= 64 and #self.objects > 1 then
                obj.remove = true
            end

            --collision with wall
            if obj.x < 32 or obj.x > VIRTUAL_WIDTH - 32 - obj.width or obj.y < 29 or  obj.y > VIRTUAL_HEIGHT - 32 - obj.height then
                obj.remove = true
            end

        end
    end
end

function Room:clearObjects() 
    for i, obj in pairs(self.objects) do 
        if obj.remove then
            table.remove(self.objects, i)
        end
    end
end