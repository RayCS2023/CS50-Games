



LevelMaker = Class{}

function LevelMaker.createMap(level) 

    local bricks = {}

    --random rows and cols
    local rows = math.random(1,5)
    local cols = math.random (7,13)

    --we want odd cols for easier pattern generation
    cols = cols%2 == 0 and (cols + 1) or cols

    --brick tier, we have 4 different tiers
    --every 5 levels, the tier will change
    local brickTier = math.min(3, math.floor(level/5))

    --colors option of 1-3. 1-4. 1-5 depending on level
    local brickColor = math.min(5, (level % 5) + 3)

    local lockedBrick = level%5 == 0 and true or false

    local lockedRow = math.random(1,rows)

    --add bricks to table
    for y = 1, rows do

        --bool to see if we want to skip block
        local skipPattern = math.random(1,2) == 1 and true or false

        --bool to see if we want alternating colors
        local alternatePattern = math.random(1,2) == 1 and true or false

        -- used only when we want to skip a block, for skip pattern
        local skipFlag = math.random(2) == 1 and true or false

        -- used only when we want to alternate a block, for alternate pattern
        local alternateFlag = math.random(2) == 1 and true or false

        --generate the colour and tiers used for alternating

        local primaryColour = math.random(1, brickColor)
        local secondaryColour = math.random(1, brickColor)
        local primaryTier = math.random(0, brickTier)
        local secondaryTier = math.random(0, brickTier)

        -- solid color we'll use if we're not alternatin
        local solidColor = math.random(1, brickColor)
        local solidTier = math.random(0, brickTier)

        for x = 1, cols do
            -- checking for skiping only if skipPattern is true
            if skipPattern then
                if skipFlag then
                    -- turn skipping off for the next iteration
                    skipFlag = not skipFlag

                    -- Lua doesn't have a continue statement, so this is the workaround
                    goto continue
                else
                    -- flip the flag to true on an iteration we don't use it
                    skipFlag = not skipFlag
                end
            end

            --create the brick
            b = Brick( 
                -- x coordinate
                (x-1) -- coordinates start at 0
                * 32 -- brick width
                + 8 --shift all blockover by 8 to give a left and right padding of 8, the screen can fit 13 cols + 16pixels
                + (13 - cols) * 32/2, --add spacing for different cols numbers
                -- y coordinate
                y * 16  -- no need y to  start at 0 cause we need top padding
            )

            -- if we're alternating, figure out which color/tier we're on
            if alternatePattern then
                if alternateFlag then
                    b.color = primaryColour
                    b.tier = primaryTier
                    alternateFlag = not alternateFlag
                else
                    if y == lockedRow and lockedBrick then
                        b.locked = true
                    else
                        b.color = secondaryColour
                        b.tier = secondaryTier
                    end
                    alternateFlag = not alternateFlag
                end
            else
            --use solid colours otherwise
                if y == lockedRow and lockedBrick then
                    b.locked = true
                else
                    b.color = solidColor
                    b.tier = solidTier
                end
            end

            table.insert(bricks, b)

            -- Lua's version of the 'continue' statement
            ::continue::
        end
    end 
    
    return bricks
end