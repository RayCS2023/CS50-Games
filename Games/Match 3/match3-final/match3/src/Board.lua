Board = Class{}

function Board:init(x, y, level) 
    self.x = x
    self.y = y
    self.matches = {}
    self.level = level

    self:initializeTiles()
end

function Board:initializeTiles() 
    self.tiles = {}


    for tileY = 1, 8 do
        -- insert new row
        table.insert(self.tiles, {})
        for tileX = 1, 8 do
            local giveShiny = math.random(1, 100) <=5 and true or false
            local tile = Tile(tileX, tileY, math.random(18), math.random(math.floor(self.level/5) + 1), giveShiny)
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], tile)
        end
    end
end

function Board:render() 
    for y = 1, 8 do 
        for x = 1, 8 do
            if self.tiles[y][x] then
                self.tiles[y][x]:render(self.x, self.y)
            end
        end
    end
end

function Board:calculateMatches() 
    local matches = {}
    local shinyTiles = {}
    
    --horizontal matches
    for y = 1, 8 do 
        local colorToMatch = self.tiles[y][1].colour
        local patternToMatch = self.tiles[y][1].variety
        local matchNum = 1
        --loop through the other tiles
        for x = 2, 8 do 
            -- if this is the same color as the one we're trying to match
            if self.tiles[y][x].colour == colorToMatch and self.tiles[y][x].variety == patternToMatch then
                matchNum = matchNum + 1
            else
                --the new tile is the new color to match
                colorToMatch = self.tiles[y][x].colour
                patternToMatch = self.tiles[y][x].variety

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                        --print('1', self.tiles[y][x2].boardX, self.tiles[y][x2].boardY)

                        --check to see if the tile is shiny
                        if self.tiles[y][x2].shiny then
                            table.insert(shinyTiles, self.tiles[y][x2])
                        end
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end
                matchNum = 1
                -- don't need to check last two if 6 did not match 7 
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])

                --print('2', self.tiles[y][x].boardX, self.tiles[y][x].boardY)

                --check to see if the tile is shiny
                if self.tiles[y][x].shiny then
                    table.insert(shinyTiles, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].colour
        local patternToMatch = self.tiles[1][x].variety
        local matchNum = 1

        -- every vertical tile
        for y = 2, 8 do 
            if self.tiles[y][x].colour == colorToMatch and self.tiles[y][x].variety == patternToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].colour
                patternToMatch = self.tiles[y][x].variety

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                        --print('3', self.tiles[y2][x].boardX, self.tiles[y2][x].boardY)

                        if self.tiles[y2][x].shiny then
                            table.insert(shinyTiles, self.tiles[y2][x])
                        end
                    end

                    table.insert(matches, match)
                end
                matchNum = 1
                -- don't need to check last two if 6 and 7 did not match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the  column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last column by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                --print('4', self.tiles[y][x].boardX, self.tiles[y][x].boardY)

                --check to see if the tile is shiny
                if self.tiles[y][x].shiny then
                    table.insert(shinyTiles, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end
    self.matches = matches
    self:checkShiny(self.matches, shinyTiles)
    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.boardY][tile.boardX] = nil
        end
    end
    self.matches = nil
end

function Board:getFallingTiles() 
    local tweens = {}

    for x = 1, 8 do 
        local space = false
        --first space found
        local spaceY = 0
        local y = 8

        --start at last block of the last row
        while y >=1 do
            local tile = self.tiles[y][x]
            if tile == nil then
                space = true
                if spaceY == 0 then
                    spaceY = y
                end
            elseif space then
                if tile then
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.boardY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.boardY - 1) * 32
                    }
                    --the above piece will always be a space
                    space = true
                    spaceY = spaceY - 1
                    y = spaceY
                end
            end
            y = y - 1
        end
    end

    --create new tile 
    for x = 1, 8 do
        local factor = 0
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if no tile exist
            if not tile then
                if factor == 0 then
                    factor = y
                end
                local giveShiny = math.random(1, 100) <=5 and true or false
                local tile = Tile(x, y, math.random(18), math.random(math.floor(self.level/5) + 1), giveShiny)
                self.tiles[y][x] = tile
                tile.y = tile.y - 32 * factor 

                tweens[tile] = {
                    y = (tile.boardY - 1) * 32
                }
            end
        end
    end
    
    return tweens
end

function Board:checkShiny(matches, shinyTiles) 
    local rowsCleared = {}

    for i, tile in pairs(shinyTiles) do
        local shinyY = tile.boardY
        for j, match in pairs(matches) do 
            --tells us if they match is horizontal or vertical
            local count = 0
            for k, matchTiles in pairs(match) do 
                --remove the tile from the match if the X value is equal to shiny's X value
                if matchTiles.boardY == shinyY then
                    count = count + 1
                end 
                 
                --this is a horizontal match so we remove the whole match
                if count >= 3 then
                    table.remove(matches, j)
                    break
                end
            end
        end
    end

    for i, tile in pairs(shinyTiles) do
        if not rowsCleared[tile.boardY] then
            local rowToClear = {}
            for x = 1, 8 do 
                table.insert(rowToClear, self.tiles[tile.boardY][x])
            end
            table.insert(matches, rowToClear)
            rowsCleared[tile.boardY] = true;
        end
    end

    -- for j, match in pairs(matches) do 
    --     for k, matchTiles in pairs(match) do 
    --         print(matchTiles.boardX, matchTiles.boardY)
    --     end
    -- end
end

function Board:update(dt)
    for y = 1, 8 do 
        for x = 1, 8  do
            self.tiles[y][x]:update(dt)
        end
    end
end

function Board:checkBoard() 

    local possibleRowMatches = {}
    local possibleColMatches = {}

    --find possibleRows
    for y = 1, 8 do 
        for x = 1, 7  do
            local tile = self.tiles[y][x]
            --if the next tile matches the current one
            if self.tiles[y][x+1].variety == tile.variety and self.tiles[y][x+1].colour == tile.colour then
                table.insert(possibleRowMatches, y)
                break
            end

            if not (x == 7) then
                if self.tiles[y][x+2].variety == tile.variety and self.tiles[y][x+2].colour == tile.colour then
                    table.insert(possibleRowMatches, y)
                    break
                end
            end
        end
    end

    --find possibleCols
    for x = 1, 8 do 
        for y = 1, 7  do
            local tile = self.tiles[y][x]
            --if the next tile matches the current one
            if self.tiles[y+1][x].variety == tile.variety and self.tiles[y+1][x].colour == tile.colour then
                table.insert(possibleColMatches, x)
                break
            end

            if not (y == 7) then
                if self.tiles[y+2][x].variety == tile.variety and self.tiles[y+2][x].colour == tile.colour then
                    table.insert(possibleColMatches, x)
                    break
                end
            end

        end
    end

    --check row swaps
    for i, y in pairs(possibleRowMatches) do
        for x = 1, 8 do 
            local currTile = self.tiles[y][x]
            --perform right swapping
            if not (x == 8) then
                local tileToSwap = self.tiles[y][x+1]

                local matches = self:checkMatches(currTile, tileToSwap)

                if matches then
                    print(x,y)
                    return 
                end
            end
            --perform up swapping
            if not (y == 1) then
                local tileToSwap = self.tiles[y-1][x]

                local matches = self:checkMatches(currTile, tileToSwap)

                if matches then
                    print(x,y)
                    return 
                end
            end

            --perform down swapping
            if not (y == 8) then
                local tileToSwap = self.tiles[y+1][x]

                local matches = self:checkMatches(currTile, tileToSwap)

                if matches then
                    print(x,y)
                    return 
                end
            end
        end
    end

    --check col swaps
    for i, x in pairs(possibleColMatches) do 
        for y = 1, 8 do
            local currTile = self.tiles[y][x]

            --perform down swapping
            if not (y == 8) then
                local tileToSwap = self.tiles[y+1][x]

                local matches = self:checkMatches(currTile, tileToSwap)

                if matches then
                    print(x,y)
                    return 
                end
            end

            --perform left swapping
            if not (x == 1) then
                local tileToSwap = self.tiles[y][x-1]

                local matches = self:checkMatches(currTile, tileToSwap)

                if matches then
                    print(x,y)
                    return 
                end
            end

            --perform right swapping
            if not (x == 8) then
                local tileToSwap = self.tiles[y][x+1]

                local matches = self:checkMatches(currTile, tileToSwap)

                if matches then
                    print(x,y)
                    return 
                end
            end
        end
    end

    --if we reach here the function did not return and thus the board has no matches
    --generate new tiles
    self:initializeTiles()
    self:checkBoard()

    --testing by print the results
    -- for i, y in pairs(possibleRowMatches) do
    --     print(y)
    -- end
    -- print()
    -- for i, x in pairs(possibleColMatches) do
    --     print(x)
    -- end
end

function Board:checkMatches(currTile,tileToSwap) 
    currTile:swap(tileToSwap)

    self.tiles[currTile.boardY][currTile.boardX] = currTile
    self.tiles[tileToSwap.boardY][tileToSwap.boardX] = tileToSwap

    local matches = self:calculateMatches()

    --swap back
    currTile:swap(tileToSwap)

    self.tiles[currTile.boardY][currTile.boardX] = currTile
    self.tiles[tileToSwap.boardY][tileToSwap.boardX] = tileToSwap

    return matches
end