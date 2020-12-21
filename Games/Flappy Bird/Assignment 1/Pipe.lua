Pipe = Class{}

PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

function Pipe:init(orientation,y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.w = PIPE_IMAGE:getWidth()
    self.h = PIPE_HEIGHT
    self.orientation = orientation
end

function Pipe:update(dt)
end

function Pipe:render()

    --reflection occurs at the assigned coorindates, therefore we are required to shift the pipe down since it got reflected up
    love.graphics.draw(
        PIPE_IMAGE, --image
        self.x, --xpos
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), -- ypos
        0, --rotation
        1, -- X scale
        self.orientation == 'top' and -1 or 1) -- Y scale
end
