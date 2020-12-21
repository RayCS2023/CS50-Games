StateMachine = Class{}

--param: list of possible states
function StateMachine:init(states)
    --this represents an empty state that does nothing
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    --empty if states dont exist
    self.states = states or {}
    self.current = self.empty
    self.stateName = ''
end

function StateMachine:change(stateName, enterParams)

    --check to see that the state exist
    assert(self.states[stateName]) 
    self.stateName = stateName

    --note exit and enter functions are not defined in the states    
    self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end


