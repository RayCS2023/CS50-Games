PlayState = Class{__includes = BaseState}

function PlayState:init() 
    -- position of the tile which we're highlighting
    self.boardHighlightX = 1
    self.boardHighlightY = 1

    -- timer used to switch the highlight rect's color
    --the tile outline switches color depending on wether this is true or false
    self.rectHighlighted = false

    --check to see if input is enabled
    self.enableInput = true

    -- tile we're currently highlighting (preparing to swap)
    self.highlightedTile = nil

    --game info
    self.score = 0
    self.timer = 60

    -- set our Timer class to change highlighted tile outline's colour
    Timer.every(0.5, function()
        self.rectHighlighted = not self.rectHighlighted
    end)

    -- subtract 1 from timer every second
    Timer.every(1, function()
        self.timer = self.timer - 1

        -- play warning sound on timer if we get low
        if self.timer <= 5 then
            gSounds['clock']:play()
        end
    end)
end

function PlayState:enter(params) 
    self.level = params.level
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16)
    self.score = params.score or 0
    self.scoreGoal = self.level * 1.25 * 1000
    self.board:checkBoard()
end

function PlayState:update(dt) 
    self.board:update(dt)

    --exit game function
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    --change state if we run out of time
    if self.timer == 0 then
        Timer.clear()
        gSounds['game-over']:play()
        gStateMachine:change('game-over', {
            score = self.score
        })
    end

    --change state to next level 
    if self.score >= self.scoreGoal then
        Timer.clear()
        gSounds['next-level']:play()
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.score
        })
    end

    --input handling
    if self.enableInput then
        if love.keyboard.wasPressed('up') then
            gSounds['select']:play()
            self.boardHighlightY = math.max(1, self.boardHighlightY - 1)
        elseif love.keyboard.wasPressed('down') then
            gSounds['select']:play()
            self.boardHighlightY = math.min(8, self.boardHighlightY + 1)
        elseif love.keyboard.wasPressed('left') then
            gSounds['select']:play()
            self.boardHighlightX = math.max(1, self.boardHighlightX - 1)
        elseif love.keyboard.wasPressed('right') then
            self.boardHighlightX = math.min(8, self.boardHighlightX + 1)
            gSounds['select']:play()
        end

        --highlighting tile if enter is pressed
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            --board index of the highlighted tile
            local x = self.boardHighlightX
            local y = self.boardHighlightY

            -- if nothing is highlighted, highlight current tile
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]
            --we want unhighlight the current tile 
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil
            --th sum will equal 1 if the tile is adjacent
            elseif math.abs(self.highlightedTile.boardX - x) + math.abs(self.highlightedTile.boardY - y) > 1 then
                gSounds['error']:play()
                self.highlightedTile = nil
            --need to swap tiles
            else 
                self.enableInput = false
                local newTile = self.board.tiles[y][x]
                self.highlightedTile:swap(newTile)
                -- swap tiles in the tiles table
                self.board.tiles[self.highlightedTile.boardY][self.highlightedTile.boardX] = self.highlightedTile
                self.board.tiles[newTile.boardY][newTile.boardX] = newTile

                --swap animation
                --note that we did not update  the tile x,y coordinates
                Timer.tween(0.1, {
                    [self.highlightedTile] = {x = newTile.x, y = newTile.y},
                    [newTile] = {x = self.highlightedTile.x, y = self.highlightedTile.y}
                }):finish(function()
                    --copy of the highlighted tile for swapping
                    local tile = self.highlightedTile 

                    --set to nil so there is tile highlighted on the board after swap
                    self.highlightedTile = nil

                    local matches = self.board:calculateMatches()
                    if matches then
                        self:calculateMatches(matches)
                    else --revert back to old blocks
                        -- swap grid positions of tiles
                        newTile:swap(tile)

                        -- swap tiles in the tiles table
                        self.board.tiles[tile.boardY][tile.boardX] = tile
                        self.board.tiles[newTile.boardY][newTile.boardX] = newTile
                        Timer.after(0.3, function()
                            Timer.tween(0.1, {
                                [tile] = {x = newTile.x, y = newTile.y},
                                [newTile] = {x = tile.x, y = tile.y}
                            }):finish(function()
                                self.enableInput = true
                            end)
                        end)
                    end
                end)
    
            end
        end
    end
    Timer.update(dt)
end

function PlayState:render()
    -- render board of tiles
    self.board:render()

    -- render highlighted tile if it exists
    if self.highlightedTile then
        --color is added to the existing colors
        love.graphics.setBlendMode('add')
        love.graphics.setColor(255, 255, 255, 96)

        --(VIRTUAL_WIDTH - 272) and 16 are x and y offsets
        love.graphics.rectangle('fill', (self.highlightedTile.boardX - 1) * 32 + (VIRTUAL_WIDTH - 272),
        (self.highlightedTile.boardY - 1) * 32 + 16, 32, 32, 4)


        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- render highlight rect color based on timer
    if self.rectHighlighted then
        love.graphics.setColor(217, 87, 99, 255)
    else
        love.graphics.setColor(172, 50, 50, 255)
    end

    -- draw actual outlined rect
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', (self.boardHighlightX - 1) * 32 + (VIRTUAL_WIDTH - 272), (self.boardHighlightY - 1) * 32 + 16, 32, 32, 4)

    -- GUI text
    love.graphics.setColor(56, 56, 56, 234)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 4)

    love.graphics.setColor(99, 155, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end

function PlayState:calculateMatches(matches) 

    if matches then
        gSounds['match']:stop()
        gSounds['match']:play()
        -- add score for each match
        for k, match in pairs(matches) do
            self.score = self.score + #match * 50
            for j, tile in pairs(match) do 
                self.score = self.score + (tile.variety - 1) * 50
            end
            self.timer = self.timer + #match
        end

        self.board:removeMatches()
        local tilesToFall = self.board:getFallingTiles()

        -- first, tween the falling tiles over 0.25s
        Timer.tween(0.25, tilesToFall):finish(function() 
            Timer.after(0.25, function()
                self:calculateMatches(self.board:calculateMatches())
            end)
        end)
    else
        self.enableInput = true
        self.board:checkBoard()
    end
end
