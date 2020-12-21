push = require 'push'

require 'Util'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

TILE_SIZE = 16

CHARACTER_WIDTH = 16
CHARACTER_HEIGHT = 20

CAMERA_SCROLL_SPEED = 40
CHARACTER_MOVE_SPEED = 40

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

    characterSheet = love.graphics.newImage('character.png')
    characterQuads = GenerateQuads(characterSheet, CHARACTER_WIDTH, CHARACTER_HEIGHT)

    --middle of the screen at x
    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    characterY = ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT

    mapWidth = 20
    mapHeight = 20

    -- amount by which we'll translate the scene to emulate a camera
    cameraScroll = 0

    backgroundR = math.random(255)
    backgroundG = math.random(255)
    backgroundB = math.random(255)

    for y = 1, mapHeight do
        table.insert(tiles, {})
        
        for x = 1, mapWidth do
            -- sky and bricks; this ID directly maps to whatever quad we want to render
            table.insert(tiles[y], {
                id = y < 7 and SKY or GROUND
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

function love.update(dt)
    -- update camera scroll based on user input
    if love.keyboard.isDown('left') then
        characterX = characterX - CHARACTER_MOVE_SPEED * dt
    elseif love.keyboard.isDown('right') then
        characterX = characterX + CHARACTER_MOVE_SPEED * dt
    end

    cameraScroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)

end

function love.draw()
    push:start()
        -- translate scene by camera scroll amount; negative shifts have the effect of making it seem
        -- like we're actually moving right and vice-versa; note the use of math.floor, as rendering
        -- fractional camera offsets with a virtual resolution will result in weird pixelation and artifacting
        -- as things are attempted to be drawn fractionally and then forced onto a small virtual canvas
        love.graphics.translate(-math.floor(cameraScroll), 0)
        love.graphics.clear(backgroundR, backgroundG, backgroundB, 255)
        
        for y = 1, mapHeight do
            for x = 1, mapWidth do
                local tile = tiles[y][x]
                love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end

        -- draw character
        love.graphics.draw(characterSheet, characterQuads[1], math.floor(characterX), math.floor(characterY))
    push:finish()
end