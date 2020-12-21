LevelMenuState = Class{__includes = BaseState}

function LevelMenuState:init(statIncreases, statsBeforeLevel, onComplete) 
    self.LevelMenu = Menu {
        x = 245,
        y = 0,
        width = 139,
        height = 152,
        cursorOff = true,
        items = {
            {
                text = 'HP: ' .. tostring(statsBeforeLevel.HP) .. ' + ' .. tostring(statIncreases.HPIncrease) .. ' = ' .. tostring(statsBeforeLevel.HP + statIncreases.HPIncrease),
                --onSelect = function() end
            },
            {
                text = 'Att: ' .. tostring(statsBeforeLevel.attack) .. ' + ' .. tostring(statIncreases.attackIncrease) .. ' = ' .. tostring(statsBeforeLevel.attack + statIncreases.attackIncrease),
                --onSelect = function() end
            },
            {
                text = 'Def: ' .. tostring(statsBeforeLevel.defense) .. ' + ' .. tostring(statIncreases.defenseIncrease) .. ' = ' .. tostring(statsBeforeLevel.defense + statIncreases.defenseIncrease),
                --onSelect = function() end
            },
            {
                text = 'Spd: ' .. tostring(statsBeforeLevel.speed) .. ' + ' .. tostring(statIncreases.speedIncrease) .. ' = ' .. tostring(statsBeforeLevel.speed + statIncreases.speedIncrease),
                --onSelect = function() end
            }
        }
    }

    self.onComplete = onComplete

end

function LevelMenuState:update(dt)
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop()
        self.onComplete()
    end
end

function LevelMenuState:render()
    self.LevelMenu:render()
end