function GenerateTileQuads(atlas) 
    local tiles = {}


    --starting location of the image
    local x = 0
    local y = 0

    --use to index the table
    local counter = 1

    --iterate 9  rows
    for row = 1, 9 do 
        --iterate 2  sets of 16 cols
        for set = 1, 2 do  
            tiles[counter] = {}

            --iterate 6 cols for each set
            for cols = 1, 6 do 
                local quad = love.graphics.newQuad(x, y, 32, 32, atlas:getDimensions())
                --insert quad into table
                table.insert(tiles[counter], quad)
                --set x pos to the next tile
                x = x + 32
            end
            counter = counter + 1
        end
        --reset x to begining and y to next row
        x = 0
        y = y + 32
    end
    return tiles
end