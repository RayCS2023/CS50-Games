--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

FadeOutState = Class{__includes = BaseState}

function FadeOutState:init(colour, tweentime, funcOnComplete)
    self.opacity = 255
    self.r = colour.r
    self.g = colour.g
    self.b = colour.b
    self.tweentime = tweentime

    Timer.tween(self.tweentime, {
        [self] = {opacity = 0}
    })
    :finish(function()
        gStateStack:pop()
        funcOnComplete()
    end)
end

function FadeOutState:render()
    love.graphics.setColor(self.r, self.g, self.b, self.opacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(255, 255, 255, 255)
end