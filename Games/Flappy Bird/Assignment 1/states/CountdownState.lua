CountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    --increase timer
    self.timer = self.timer + dt

    --once timer is greater 0.75s
    if self.timer > COUNTDOWN_TIME then

        --take reminder and start  incrementing again
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        --reset at 0
        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end