LevelMaker = Class{}

-- create a static function
function LevelMaker.generate(width, height)
    local blockIndices = {}
    local bushIndices = {}
    local counter = 0
    local tiles = {}
    local entities = {}
    local objects = {}

    -- get random generation of map tiles and toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for y = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation
    for x = 1, width do 
        local tileID = TILE_ID_EMPTY

        --row 1 to 6 are all "space" tiles
        for y = 1, 6 do 
            table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
        end

        --change to spawn falling gap
        if math.random(7) == 1 and not (x >= width - 1) then
            --note ID is still empty tiles
            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
            end
        else -- spawn ground/other things
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            --add the ground tiles
            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            --change to generate a pillar
            if math.random(8) == 1 and not (x >= width - 1) then
                blockHeight = 2

                --chance to spawn a bush on pillar
                if math.random(8) == 1 then
                    local bush = GameObject{
                        texture = 'bushes',
                        width = 16,
                        height = 16,
                        x = (x - 1) * TILE_SIZE,
                        y = (4 - 1) * TILE_SIZE,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(5) - 1) * 7
                    }
                    table.insert(objects,bush)
                    counter = counter + 1
                    table.insert(bushIndices, counter)
                end

                --change empty space tiles to ground tiles and remove topper
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            elseif  math.random(8) == 1 and not (x == width - 1) then -- spawn bush on ground with no pillar
                local bush = GameObject{
                    texture = 'bushes',
                    width = 16,
                    height = 16,
                    x = (x - 1) * TILE_SIZE,
                    y = (6 - 1) * TILE_SIZE,
                    frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(5) - 1) * 7,
                    collidable = false
                }
                table.insert(objects,bush)
                counter = counter + 1
                table.insert(bushIndices, counter)
            end

            --chance to spawn a block
            if math.random(10) == 1 and not (x >= width - 1) then
                local jumpBlock = GameObject{
                    texture = 'jump-blocks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = math.random(#JUMP_BLOCKS),
                    hit = false,
                    solid = true,
                    onCollide = function(obj) 
                        --if the block has not been hit
                        if not obj.hit then
                            --chance to spawn gem
                            if math.random(1) == 1 then
                                local gem = GameObject{
                                    texture = 'gems',
                                    x = (x - 1) * TILE_SIZE,
                                    y = (blockHeight - 1) * TILE_SIZE - 4,
                                    width = 16,
                                    height = 16,
                                    frame = math.random(#GEMS),
                                    collidable = true,
                                    consumable = true,
                                    solid = false,
                                    onConsume = function(player, object)
                                        gSounds['pickup']:play()
                                        player.score = player.score + 100
                                    end
                                }

                                Timer.tween(0.1, {
                                    [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                })
                                gSounds['powerup-reveal']:play()

                                table.insert(objects, gem)
                            end
                            obj.hit = true
                        else 
                            gSounds['empty-block']:play()
                        end
                    end

                }
                table.insert(objects, jumpBlock)
                counter = counter + 1
                table.insert(blockIndices, counter)
            end
        end
    end

    --color of thlock and key
    local colour =  math.random(5, 8)

    --locked block
    local blockToChange = blockIndices[math.random(#blockIndices)]
    objects[blockToChange].solid = true
    objects[blockToChange].hit = nil
    objects[blockToChange].onCollide = function(obj, player) 
        if player.keyPowered > 0 then
            for k, block in pairs(objects) do 
                if block.texture == 'locks-and-keys' then
                    table.remove(objects, k)
                end
            end
            --create a pole
            local pole = GameObject{
                texture = 'poles',
                x = (width - 2) * TILE_SIZE,
                y = (4 - 1) * TILE_SIZE,
                width = 16,
                height = 48,
                frame = math.random(6),
                collidable = true,
                consumable = true,
                solid = false,
                onConsume = function(obj) gStateMachine:change('play',{width = 2 * width, score = obj.score})end
            }
            --create flag 
            local flag = GameObject{
                texture = 'flags',
                x = (width - 2) * TILE_SIZE + 7,
                y = (4 - 1) * TILE_SIZE,
                width = 16,
                height = 16,
                frame = (math.random(4) - 1) * 9 + 7,
                collidable = false,
            }
            table.insert(objects, pole)
            table.insert(objects, flag)
        end
    end

    objects[blockToChange].texture = 'locks-and-keys'
    objects[blockToChange].frame = colour

    --key
    local bushToChange = bushIndices[math.random(#bushIndices)]
    objects[bushToChange].texture = 'locks-and-keys'
    objects[bushToChange].collidable = true
    objects[bushToChange].consumable = true
    objects[bushToChange].solid = false
    objects[bushToChange].onConsume = function(player) player.keyPowered = colour - 4 end
    objects[bushToChange].frame = colour - 4

    local map = TileMap(width, height, tiles)
    return GameLevel(entities, objects, map)
end