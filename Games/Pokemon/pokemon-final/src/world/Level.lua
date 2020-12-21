Level = Class{}

function Level:init() 
    self.tileW = 50
    self.tileH = 50

    --no tiles exsit on init
    self.baseLayer = TileMap(self.tileW, self.tileH)
    self.grassLayer = TileMap(self.tileW, self.tileH)
    --self.halfGrassLayer = TileMap(self.tileW, self.tileH)

    self:createMaps()

    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        mapX = 10,
        mapY = 10,
        width = 16,
        height = 16,
    }

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }

    self.player.stateMachine:change('idle')

end

function Level:createMaps() 
    --add baselayer tiles
    for y = 1, self.tileH do 
        table.insert(self.baseLayer.tiles, {})

        for x = 1, self.tileW do
            local id = TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]

            table.insert(self.baseLayer.tiles[y], Tile(x, y, id))
        end
    end

    --add tall grass tiles
    for y = 1, self.tileH do
        table.insert(self.grassLayer.tiles, {})
        --table.insert(self.halfGrassLayer.tiles, {})

        for x = 1, self.tileW do
            local id = y > 10 and TILE_IDS['tall-grass'] or TILE_IDS['empty']

            table.insert(self.grassLayer.tiles[y], Tile(x, y, id))
        end
    end
end

function Level:update(dt)
    self.player:update(dt)
end

function Level:render()
    self.baseLayer:render()
    self.grassLayer:render()
    self.player:render()
end