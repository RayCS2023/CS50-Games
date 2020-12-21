--other state class will inherit from this class

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:updated(dt) end
function BaseState:render() end