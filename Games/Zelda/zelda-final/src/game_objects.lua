--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        collidable = true,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        collidable = true,
        texture = 'tiles',
        frame = 33,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'not-sliding',
        states = {
            ['not-sliding'] = {
                frame = 33
            },
            ['lift'] = {
                frame = 33
            },
            ['sliding'] = {
                frame = 33
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        width = 16,
        height = 16,
        frame = 5,
        solid = false,
        consumable = true,
        defaultState = 'active',
        states = {
            ['active'] = {
                frame = 5
            }
        }
    }
}