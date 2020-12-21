FadeInState = Class{__includes = BaseState}

function FadeInState:init(colour, tweenTime, funcOnComplete) 
    self.r = colour.r
    self.g = colour.g
    self.b = colour.b
    self.opacity = 0
    self.tweenTime = tweenTime

    Timer.tween(self.tweenTime, {
        [self] = {opacity = 255}
    }):finish(function() 
        gStateStack:pop()
        funcOnComplete()
    end)
end

function FadeInState:render()
    love.graphics.setColor(self.r, self.g, self.b, self.opacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(255, 255, 255, 255)
end