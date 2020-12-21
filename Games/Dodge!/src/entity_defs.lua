ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        animations = {

            [1] = {
                ['walk'] = {
                    frames = {1, 2, 3, 4, 5, 6},
                    interval = 0.155,
                    texture = 'pink-monster-walk'
                },
                ['idle'] = {
                    frames = {1},
                    texture = 'pink-monster-idle'
                },
                ['death'] = {
                    frames = {1, 2, 3, 4, 5, 6, 7,8},
                    interval = 0.155,
                    texture = 'pink-monster-death'
                }
            },
            [2] = {
                ['walk'] = {
                    frames = {1, 2, 3, 4, 5, 6},
                    interval = 0.155,
                    texture = 'dude-monster-walk'
                },
                ['idle'] = {
                    frames = {1},
                    texture = 'dude-monster-idle'
                },
                ['death'] = {
                    frames = {1, 2, 3, 4, 5, 6, 7,8},
                    interval = 0.155,
                    texture = 'dude-monster-death'
                }
            },
            [3] = {
                ['walk'] = {
                    frames = {1, 2, 3, 4, 5, 6},
                    interval = 0.155,
                    texture = 'owlet-monster-walk'
                },
                ['idle'] = {
                    frames = {1},
                    texture = 'owlet-monster-idle'
                },
                ['death'] = {
                    frames = {1, 2, 3, 4, 5, 6, 7,8},
                    interval = 0.155,
                    texture = 'owlet-monster-death'
                }
            },
        }
    }
}