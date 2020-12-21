push = require 'push'

require 'Util'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

TILE_SIZE = 16

SKY = 2
GROUND = 1

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('tiles0')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    math.randomseed(os.time())

    tiles = {}

    tilesheet = love.graphics.newImage('tiles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)

    mapWidth = 20
    mapHeight = 20

    backgroundR = math.random(255)
    backgroundG = math.random(255)
    backgroundB = math.random(255)

    for y = 1, mapHeight do
        table.insert(tiles, {})

        for x = 1, mapWidth do 
            table.insert(tiles[y], {
                id = y < 5 and SKY or GROUND
            })

        end
    end

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
        love.graphics.clear(backgroundR, backgroundG, backgroundB, 255)
        
        for y = 1, mapHeight do
            for x = 1, mapWidth do
                local tile = tiles[y][x]
                love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end
    push:finish()
end