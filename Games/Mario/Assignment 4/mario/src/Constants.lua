--size of window
WIN_WDITH = 1280
WIN_HEIGHT = 720

--size we're trying to emulate with push
VIR_WIDTH = 256
VIR_HEIGHT = 144

--tiles size, 16 by 16
TILE_SIZE = 16

--width and height of screen in tiless
--how many tiles can fit horizontally and vertically
WIN_WIDTH_IN_TILES = VIR_WIDTH / TILE_SIZE
WIN_HEIGHT_IN_TILES = VIR_HEIGHT / TILE_SIZE

--camera speed
CAMERA_SPEED = 100

--background speed
BACKGROUND_SPEED = 10

--number of tiles in each set
NUM_TILES_WIDE = 5
NUM_TILES_TALL = 4

--number of tiles sets 
NUM_TILE_SETS_WIDE = 6
NUM_TILE_SETS_TALL = 10

--number of topper sets
NUM_TOPPER_SETS_WIDE = 6
NUM_TOPPER_SETS_TALL = 18

--total number of topper and tile sets
TOTAL_TOPPER_SETS = NUM_TILE_SETS_WIDE * NUM_TILE_SETS_TALL
TOTAL_TILE_SETS = NUM_TILE_SETS_WIDE * NUM_TILE_SETS_TALL

--player speed
P_WALK_SPEED = 60

--player jump velocity
P_JUMP_VELOCITY = -150

-- snail movement speed
S_MOVE_SPEED = 10

-- tile IDs
TILE_ID_EMPTY = 5
TILE_ID_GROUND = 3

BUSH_IDS = {
    1, 2, 5, 6, 7
}

JUMP_BLOCKS = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    21, 22, 23, 24, 25, 26, 27, 28, 29, 30
}

GEMS = {
    1, 2, 3, 4, 5, 6, 7, 8
}

-- table of tiles that should trigger a collision
COLLIDABLE_TILES = {
    TILE_ID_GROUND
}