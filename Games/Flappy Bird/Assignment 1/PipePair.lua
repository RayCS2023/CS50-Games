PipePair = Class{}

--local GAP_HEIGHT = 90

function PipePair:init(y, gap)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    --this is two pipes stackes on top of each other and by adding gap_height, they are seperated by the gap space
    self.pipes = {
        ['top'] = Pipe('top', self.y),
        ['bot'] =  Pipe('bot', self.y + PIPE_HEIGHT + gap) 
    }
    self.remove = false
    self.score = false --keep track if the pipe has been scored or not
end

function PipePair:update(dt)
    if self.x >  -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['top'].x = self.x  
        self.pipes['bot'].x = self.x  
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end


