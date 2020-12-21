-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--game sounds
gSounds = {
    ['music'] = love.audio.newSource('sounds/music3.mp3'),
    ['select'] = love.audio.newSource('sounds/select.wav'),
    ['error'] = love.audio.newSource('sounds/error.wav'),
    ['match'] = love.audio.newSource('sounds/match.wav'),
    ['clock'] = love.audio.newSource('sounds/clock.wav'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav')
}

--game images
gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    --https://www.flaticon.com/authors/vectors-market
    ['shiny'] = love.graphics.newImage('graphics/shiny.png')
}

--game quads
gFrames = {
    --tiles[row][col]
    --tiles are put into tables grouped by the same color
    ['tiles'] = GenerateTileQuads(gTextures['main'])
}

--game fonts
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}