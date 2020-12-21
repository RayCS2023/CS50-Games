function GenerateQuads(atlas, tileWidth, tileHeight)
    --atlas is also a sprite sheet
    --quad are fractions of the image

    --store the # of time the sheet can be cut vertically and horizontally
    --we are dividing the sheet to see how many times we need to iterate
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local counter = 1
    local spriteSheet = {}


    --note that we loop over y first so that the images can be placed in the spritesheet tables as rows
    --loop for y = 0 to y = sheetWidth - 1
    for y = 0, sheetHeight - 1 do
        --loop for x = 0 to x = sheetWidth - 1
        for x = 0, sheetWidth - 1 do
            spriteSheet[counter] = love.graphics.newQuad(
                x * tileWidth, -- top left x coordinate
                y * tileHeight, --  top left y coordinate
                tileWidth, -- width
                tileHeight, --height
                atlas:getDimensions() -- image dimensions
            )
            counter = counter + 1
        end
    end

    return spriteSheet
end

function table.slice(tbl, first, last, step) 
    --new table to bee returned
    local sliced = {}

    --start at first or  1
    --end  at last  or size of table
    --increament by step or 1
    for i = first or 1,  last or #tbl, step or 1 do
        --+1 because indexing starts at 1
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

function GenerateQuadsPaddles(atlas) 
    --start of the paddle sprites
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    --i is the rows of the image. Notice there are 4 sections of paddles
    for i = 0, 3 do
        --small paddle
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1

        --medium paddle
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1

        --large paddle
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1

        --huge paddle
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1
        
        --move to  the  next section of paddles
        y = y + 32
    end

    return quads
end


function GenerateQuadsBalls(atlas) 
    local quads = {}
    local counter = 1

    local x = 96
    local y = 48

    --the 4 ball row of spritesheet
    for i = 0, 3 do 
        quads[counter] = love.graphics.newQuad(x + i*8, y, 8,8, atlas:getDimensions())
        counter = counter + 1
    end

    y = 56

    --the 3 ball row of spritesheet
    for i = 0, 2 do 
        quads[counter] = love.graphics.newQuad(x + i*8, y, 8,8, atlas:getDimensions())
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsBricks(atlas)
    --first divided sheet into 32 by 16 pieces, then get the first 21 pieces 
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)     
end

function GenerateQuadPowerUps(atlas)

    --starting coordinate
    local y = 192
    local x = 0

    local counter = 1
    local quads = {}

    for i = 0, 9 do 
        quads[counter] = love.graphics.newQuad(x + i*16, y, 16, 16, atlas:getDimensions())
        counter = counter + 1
    end 

    return quads
end

function GenerateQuadLockedBrick(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 24, 24)     
end
